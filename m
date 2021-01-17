Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA632F9203
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 12:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbhAQLaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 06:30:35 -0500
Received: from aposti.net ([89.234.176.197]:36742 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbhAQLaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 06:30:10 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 3/3] drm/ingenic: Fix non-OSD mode
Date:   Sun, 17 Jan 2021 11:26:46 +0000
Message-Id: <20210117112646.98353-4-paul@crapouillou.net>
In-Reply-To: <20210117112646.98353-1-paul@crapouillou.net>
References: <20210117112646.98353-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index d23a3292a0e0..9d883864e078 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -553,7 +553,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[0];
 
-		if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
 			hwdesc = &priv->dma_hwdescs->hwdesc_f0;
 		else
 			hwdesc = &priv->dma_hwdescs->hwdesc_f1;
@@ -814,6 +814,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	const struct jz_soc_info *soc_info;
 	struct ingenic_drm *priv;
 	struct clk *parent_clk;
+	struct drm_plane *primary;
 	struct drm_bridge *bridge;
 	struct drm_panel *panel;
 	struct drm_encoder *encoder;
@@ -928,9 +929,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	if (soc_info->has_osd)
 		priv->ipu_plane = drm_plane_from_index(drm, 0);
 
-	drm_plane_helper_add(&priv->f1, &ingenic_drm_plane_helper_funcs);
+	primary = priv->soc_info->has_osd ? &priv->f1 : &priv->f0;
 
-	ret = drm_universal_plane_init(drm, &priv->f1, 1,
+	drm_plane_helper_add(primary, &ingenic_drm_plane_helper_funcs);
+
+	ret = drm_universal_plane_init(drm, primary, 1,
 				       &ingenic_drm_primary_plane_funcs,
 				       priv->soc_info->formats_f1,
 				       priv->soc_info->num_formats_f1,
@@ -942,7 +945,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 
 	drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
 
-	ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
+	ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
 					NULL, &ingenic_drm_crtc_funcs, NULL);
 	if (ret) {
 		dev_err(dev, "Failed to init CRTC: %i\n", ret);
-- 
2.29.2

