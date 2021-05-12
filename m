Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAF37CB29
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242436AbhELQet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241495AbhELQ1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7936117A;
        Wed, 12 May 2021 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834802;
        bh=+xqDSngApgCW2BjSzwJIKLaZ/C4Yi037RkbA38SPMN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBvoZgEZVQwHUuwy/+v5YQaSmh/XVdtebFGeafNAMOrkppMPmtt5F61P9V9ioBGQA
         D6RbzwaoKLHFYGo2I4ntWqh2WGVk5Dorv1CH7pI/zR6qlqxhyIBqRcFKZPchMbiRzg
         wOuydgI55/DGotTsrSEXN1Xum3DHQHwJpdICqlO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 5.12 072/677] drm/ingenic: Fix non-OSD mode
Date:   Wed, 12 May 2021 16:41:58 +0200
Message-Id: <20210512144839.626308700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -554,7 +554,7 @@ static void ingenic_drm_plane_atomic_upd
 		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[0];
 
-		if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
 			hwdesc = &priv->dma_hwdescs->hwdesc_f0;
 		else
 			hwdesc = &priv->dma_hwdescs->hwdesc_f1;
@@ -826,6 +826,7 @@ static int ingenic_drm_bind(struct devic
 	const struct jz_soc_info *soc_info;
 	struct ingenic_drm *priv;
 	struct clk *parent_clk;
+	struct drm_plane *primary;
 	struct drm_bridge *bridge;
 	struct drm_panel *panel;
 	struct drm_encoder *encoder;
@@ -940,9 +941,11 @@ static int ingenic_drm_bind(struct devic
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
@@ -954,7 +957,7 @@ static int ingenic_drm_bind(struct devic
 
 	drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
 
-	ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
+	ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
 					NULL, &ingenic_drm_crtc_funcs, NULL);
 	if (ret) {
 		dev_err(dev, "Failed to init CRTC: %i\n", ret);


