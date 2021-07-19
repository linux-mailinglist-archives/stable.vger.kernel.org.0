Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64493CE019
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345667AbhGSPNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345656AbhGSPMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2983361279;
        Mon, 19 Jul 2021 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709961;
        bh=hF/vTH+1CY/GWVUsaya4fy7AT5xadmNfZnudOOYv4Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Unl4+sU1ZK3hW0syDG3W63s3QDvabZE+VF7NUUGefzZWhVdNBAwH7TSbfRxGxiO26
         Y5XZl6w/EbFBI2HOrbEvbuSgiJVFjNMMfn+tLRxT13Vex8DCfcluhit/DC8Cu/QLiF
         Jcjwbm6GlqwtErhfN8SG0+ZvfPmFZw2Akm4aC64c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 5.10 018/243] drm/ingenic: Fix non-OSD mode
Date:   Mon, 19 Jul 2021 16:50:47 +0200
Message-Id: <20210719144941.515329280@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

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
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -455,7 +455,7 @@ static void ingenic_drm_plane_atomic_upd
 		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[0];
 
-		if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
 			hwdesc = priv->dma_hwdesc_f0;
 		else
 			hwdesc = priv->dma_hwdesc_f1;
@@ -692,6 +692,7 @@ static int ingenic_drm_bind(struct devic
 	const struct jz_soc_info *soc_info;
 	struct ingenic_drm *priv;
 	struct clk *parent_clk;
+	struct drm_plane *primary;
 	struct drm_bridge *bridge;
 	struct drm_panel *panel;
 	struct drm_encoder *encoder;
@@ -784,9 +785,11 @@ static int ingenic_drm_bind(struct devic
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
@@ -798,7 +801,7 @@ static int ingenic_drm_bind(struct devic
 
 	drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
 
-	ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
+	ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
 					NULL, &ingenic_drm_crtc_funcs, NULL);
 	if (ret) {
 		dev_err(dev, "Failed to init CRTC: %i\n", ret);


