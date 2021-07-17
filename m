Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38F63CC4FA
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 19:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhGQRsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 13:48:06 -0400
Received: from aposti.net ([89.234.176.197]:56828 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhGQRsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 13:48:05 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "H . Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 1/2] drm/ingenic: Fix non-OSD mode
Date:   Sat, 17 Jul 2021 18:44:45 +0100
Message-Id: <20210717174446.14455-2-paul@crapouillou.net>
In-Reply-To: <1626352148199179@kroah.com>
References: <1626352148199179@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7b4957684e5d813fcbdc98144e3cc5c4467b3e2e upstream.

Even though the JZ4740 did not have the OSD mode, it had (according to
the documentation) two DMA channels, but there is absolutely no
information about how to select the second DMA channel.

Make the ingenic-drm driver work in non-OSD mode by using the
foreground0 plane (which is bound to the DMA0 channel) as the primary
plane, instead of the foreground1 plane, which is the primary plane
when in OSD mode.

Fixes: 3c9bea4ef32b ("drm/ingenic: Add support for OSD mode")
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210124085552.29146-5-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index a3d1617d7c67..3e839fc715d9 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -455,7 +455,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[0];
 
-		if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
 			hwdesc = priv->dma_hwdesc_f0;
 		else
 			hwdesc = priv->dma_hwdesc_f1;
@@ -692,6 +692,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	const struct jz_soc_info *soc_info;
 	struct ingenic_drm *priv;
 	struct clk *parent_clk;
+	struct drm_plane *primary;
 	struct drm_bridge *bridge;
 	struct drm_panel *panel;
 	struct drm_encoder *encoder;
@@ -784,9 +785,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	if (soc_info->has_osd)
 		priv->ipu_plane = drm_plane_from_index(drm, 0);
 
-	drm_plane_helper_add(&priv->f1, &ingenic_drm_plane_helper_funcs);
+	primary = priv->soc_info->has_osd ? &priv->f1 : &priv->f0;
 
-	ret = drm_universal_plane_init(drm, &priv->f1, 1,
+	drm_plane_helper_add(primary, &ingenic_drm_plane_helper_funcs);
+
+	ret = drm_universal_plane_init(drm, primary, 1,
 				       &ingenic_drm_primary_plane_funcs,
 				       ingenic_drm_primary_formats,
 				       ARRAY_SIZE(ingenic_drm_primary_formats),
@@ -798,7 +801,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 
 	drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
 
-	ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
+	ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
 					NULL, &ingenic_drm_crtc_funcs, NULL);
 	if (ret) {
 		dev_err(dev, "Failed to init CRTC: %i\n", ret);
-- 
2.30.2

