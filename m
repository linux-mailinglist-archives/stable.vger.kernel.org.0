Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB033CC4FB
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 19:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhGQRsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 13:48:12 -0400
Received: from aposti.net ([89.234.176.197]:56838 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhGQRsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 13:48:12 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Simon Ser <contact@emersion.fr>
Subject: [PATCH 2/2] drm/ingenic: Switch IPU plane to type OVERLAY
Date:   Sat, 17 Jul 2021 18:44:46 +0100
Message-Id: <20210717174446.14455-3-paul@crapouillou.net>
In-Reply-To: <1626352148199179@kroah.com>
References: <1626352148199179@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 68b433fe6937cfa3f8975d18643d5956254edd6a upstream.

It should have been an OVERLAY from the beginning. The documentation
stipulates that there should be an unique PRIMARY plane per CRTC.

Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20210329175046.214629-2-paul@crapouillou.net
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++------
 drivers/gpu/drm/ingenic/ingenic-ipu.c     |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 3e839fc715d9..b6bb5fc7d183 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -347,7 +347,7 @@ static void ingenic_drm_plane_enable(struct ingenic_drm *priv,
 	unsigned int en_bit;
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
+		if (plane != &priv->f0)
 			en_bit = JZ_LCD_OSDC_F1EN;
 		else
 			en_bit = JZ_LCD_OSDC_F0EN;
@@ -362,7 +362,7 @@ void ingenic_drm_plane_disable(struct device *dev, struct drm_plane *plane)
 	unsigned int en_bit;
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
+		if (plane != &priv->f0)
 			en_bit = JZ_LCD_OSDC_F1EN;
 		else
 			en_bit = JZ_LCD_OSDC_F0EN;
@@ -389,8 +389,7 @@ void ingenic_drm_plane_config(struct device *dev,
 
 	ingenic_drm_plane_enable(priv, plane);
 
-	if (priv->soc_info->has_osd &&
-	    plane->type == DRM_PLANE_TYPE_PRIMARY) {
+	if (priv->soc_info->has_osd && plane != &priv->f0) {
 		switch (fourcc) {
 		case DRM_FORMAT_XRGB1555:
 			ctrl |= JZ_LCD_OSDCTRL_RGB555;
@@ -423,7 +422,7 @@ void ingenic_drm_plane_config(struct device *dev,
 	}
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY) {
+		if (plane != &priv->f0) {
 			xy_reg = JZ_REG_LCD_XYP1;
 			size_reg = JZ_REG_LCD_SIZE1;
 		} else {
@@ -455,7 +454,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[0];
 
-		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane == &priv->f0)
 			hwdesc = priv->dma_hwdesc_f0;
 		else
 			hwdesc = priv->dma_hwdesc_f1;
diff --git a/drivers/gpu/drm/ingenic/ingenic-ipu.c b/drivers/gpu/drm/ingenic/ingenic-ipu.c
index fc8c6e970ee3..06fd118b1444 100644
--- a/drivers/gpu/drm/ingenic/ingenic-ipu.c
+++ b/drivers/gpu/drm/ingenic/ingenic-ipu.c
@@ -753,7 +753,7 @@ static int ingenic_ipu_bind(struct device *dev, struct device *master, void *d)
 
 	err = drm_universal_plane_init(drm, plane, 1, &ingenic_ipu_plane_funcs,
 				       soc_info->formats, soc_info->num_formats,
-				       NULL, DRM_PLANE_TYPE_PRIMARY, NULL);
+				       NULL, DRM_PLANE_TYPE_OVERLAY, NULL);
 	if (err) {
 		dev_err(dev, "Failed to init plane: %i\n", err);
 		return err;
-- 
2.30.2

