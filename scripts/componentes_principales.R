library(tidyverse)
library(GGally)
library(reshape)
library(scatterplot3d) 
library(factoextra)

estados <- as.data.frame(state.x77)

names(estados)
names(estados)[4] = "Life_Exp"
names(estados)[6] = "HS_Grad"

names(estados)

#########################################################

n = nrow(estados)
p = ncol(estados)

#########################################################

ggpairs(data=estados,
        mapping = aes(color="red")
        ) +
  theme(panel.background = element_rect("#202020"),
        panel.grid = element_line("blue"),
        axis.title = element_blank()
        )


min(estados$Population)

estados %>% filter(Population == 365)

#########################################################

medias = colMeans(estados)
estados_centrado = estados - t(data.frame(replicate(nrow(estados),medias)))

#########################################################

covarianzas = cov(estados_centrado)

eigen_valores_S = eigen(covarianzas)$values
eigen_vectores_S = eigen(covarianzas)$vector

eigen_valores_S / sum(eigen_valores_S)
cumsum(eigen_valores_S) / sum(eigen_valores_S)

#########################################################

correlaciones = cor(estados_centrado)

eigen_valores_R = eigen(correlaciones)$values
eigen_vectores_R = eigen(correlaciones)$vector

eigen_valores_R / sum(eigen_valores_R)
cumsum(eigen_valores_R) / sum(eigen_valores_R)


###################################################################
################## Funci�n implementada para PCA ##################
###################################################################

componentes_principales = princomp(estados,cor=TRUE,fix_sign = TRUE)

## Visualizaci�n
fviz_eig(componentes_principales)

## scores
View(componentes_principales$scores)

## Mapa de calor de las nuevas correlaciones

nvas_corr = cor(componentes_principales$scores)
df = melt(nvas_corr)

colnames(df) = c("x","y","correlaci�n")

ggplot(df, aes(x = x, y = y, fill = correlaci�n)) +
  geom_tile(color="white") +
  geom_text(aes(label = round(correlaci�n,2)), color = "white", size = 8) +
  scale_fill_gradient2(low="white",
                       mid="orange", high="red",
                       guide=guide_colorbar(ticks=FALSE,
                                            barheight=5, limits=c(-1,1))) 

## Visualizar las primeras 3 componentes principales

primeras_tres = componentes_principales$scores[,1:3]

scatterplot3d(primeras_tres,pch=19)

##

componentes_principales$loadings

###################################################################
################## gr�ficas de las tres primeras cp ###############
###################################################################

primeras_tres = as.data.frame(primeras_tres)

ggplot(data=primeras_tres) +
  geom_point(mapping=aes(x=Comp.1,y=Comp.2)) +
  geom_text(mapping = aes(x=Comp.1,y=Comp.2,label=rownames(primeras_tres)))

ggplot(data=primeras_tres) +
  geom_point(mapping=aes(x=Comp.2,y=Comp.3)) +
  geom_text(mapping = aes(x=Comp.2,y=Comp.3,label=rownames(primeras_tres)))

ggplot(data=primeras_tres) +
  geom_point(mapping=aes(x=Comp.1,y=Comp.3)) +
  geom_text(mapping = aes(x=Comp.1,y=Comp.3,label=rownames(primeras_tres)))













  
  
  