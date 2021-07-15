Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB03C9EAB
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhGOMfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhGOMfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 643856136E;
        Thu, 15 Jul 2021 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626352338;
        bh=7yFu7cJnENS+busAXR9D32G1Rfb1VXnBmFLqpXsCYoY=;
        h=Subject:To:Cc:From:Date:From;
        b=PNgcvcH/b/YBSb310/ZTs9gQHMKypUOV+ojyG4ROQ/aySEPvjZHyIxtdkBXuTrqwf
         /zw1ZN89sZssROoPtyTGXRiz0UHMM6d0uStcJD+hNa3rCh2QdxP48nlKDcCgidRWyl
         Mp+3AgwT2PoSrMfZk/exwGc4xqbTVsnHpQR3n2tw=
Subject: FAILED: patch "[PATCH] drm/ingenic: Switch IPU plane to type OVERLAY" failed to apply to 5.10-stable tree
To:     paul@crapouillou.net, contact@emersion.fr, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:29:08 +0200
Message-ID: <1626352148199179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 68b433fe6937cfa3f8975d18643d5956254edd6a Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Mon, 29 Mar 2021 18:50:45 +0100
Subject: [PATCH] drm/ingenic: Switch IPU plane to type OVERLAY

It should have been an OVERLAY from the beginning. The documentation
stipulates that there should be an unique PRIMARY plane per CRTC.

Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20210329175046.214629-2-paul@crapouillou.net

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 29742ec5ab95..09225b770bb8 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -419,7 +419,7 @@ static void ingenic_drm_plane_enable(struct ingenic_drm *priv,
 	unsigned int en_bit;
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
+		if (plane != &priv->f0)
 			en_bit = JZ_LCD_OSDC_F1EN;
 		else
 			en_bit = JZ_LCD_OSDC_F0EN;
@@ -434,7 +434,7 @@ void ingenic_drm_plane_disable(struct device *dev, struct drm_plane *plane)
 	unsigned int en_bit;
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
+		if (plane != &priv->f0)
 			en_bit = JZ_LCD_OSDC_F1EN;
 		else
 			en_bit = JZ_LCD_OSDC_F0EN;
@@ -461,8 +461,7 @@ void ingenic_drm_plane_config(struct device *dev,
 
 	ingenic_drm_plane_enable(priv, plane);
 
-	if (priv->soc_info->has_osd &&
-	    plane->type == DRM_PLANE_TYPE_PRIMARY) {
+	if (priv->soc_info->has_osd && plane != &priv->f0) {
 		switch (fourcc) {
 		case DRM_FORMAT_XRGB1555:
 			ctrl |= JZ_LCD_OSDCTRL_RGB555;
@@ -510,7 +509,7 @@ void ingenic_drm_plane_config(struct device *dev,
 	}
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY) {
+		if (plane != &priv->f0) {
 			xy_reg = JZ_REG_LCD_XYP1;
 			size_reg = JZ_REG_LCD_SIZE1;
 		} else {
@@ -561,7 +560,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 		height = newstate->src_h >> 16;
 		cpp = newstate->fb->format->cpp[0];
 
-		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane == &priv->f0)
 			hwdesc = &priv->dma_hwdescs->hwdesc_f0;
 		else
 			hwdesc = &priv->dma_hwdescs->hwdesc_f1;
diff --git a/drivers/gpu/drm/ingenic/ingenic-ipu.c b/drivers/gpu/drm/ingenic/ingenic-ipu.c
index 5ae6adab8306..3b1091e7c0cd 100644
--- a/drivers/gpu/drm/ingenic/ingenic-ipu.c
+++ b/drivers/gpu/drm/ingenic/ingenic-ipu.c
@@ -767,7 +767,7 @@ static int ingenic_ipu_bind(struct device *dev, struct device *master, void *d)
 
 	err = drm_universal_plane_init(drm, plane, 1, &ingenic_ipu_plane_funcs,
 				       soc_info->formats, soc_info->num_formats,
-				       NULL, DRM_PLANE_TYPE_PRIMARY, NULL);
+				       NULL, DRM_PLANE_TYPE_OVERLAY, NULL);
 	if (err) {
 		dev_err(dev, "Failed to init plane: %i\n", err);
 		return err;

