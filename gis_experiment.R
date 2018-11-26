library(tidyverse)
library(rgdal)
library(ggplot2)
library(rgeos)
library(ggmap)
library(RColorBrewer)

register_google(key = "insert.key")

# Read shapefile using OGR
shp = "insert.file.path"
myshp = readOGR(shp, layer = basename(str_split(shp, "\\.")[[1]])[1]) # This is a fancy way of being lazy, so I do not need to type the layer name in

# Convert to lat long
myshp_proj = spTransform(myshp, CRS("+proj=longlat +datum=WGS84"))

# Find polygon centroid (This centers the map)
centroid = gCentroid(myshp_proj)

# Get the Google basemap
terrain_gmap = get_map(location = c(lon = centroid$x, lat = centroid$y),
                    color = "color",
                    source = "google",
                    maptype = "terrain",
                    zoom = 9)

# Convert shapefile to format ggmap can work with
polys = broom::tidy(myshp_proj)


# Define the color scheme for mapping shp
colors = brewer.pal(9, "OrRd")

# create the final map
ggmap(terrain_gmap) +
    geom_polygon(aes(x = long, y = lat, group = group),
    data = polys,
    color = colors[5],
    fill = colors[4],
    alpha = 0.5) +
    labs(x = "Longitude", y = "Latitude")


