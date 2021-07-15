Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E84A3CA942
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbhGOTFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241460AbhGOTEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86CC761409;
        Thu, 15 Jul 2021 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375659;
        bh=WL4coB8igxkVHU+RhTg9k6iV3QdIlvvea6iAsOYIlDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok6ImwqSEhzmmuA39YGo0lFRyBK+CkJ3yS7SO0qfG2kZcDGzLSid/7I8W7nWAkDsK
         54mUHGezp3CA/W2gpSE7c8nNhVQviru9tJTe2o0HboAVMBmPbKHCXG122nKLTCSkky
         Y1W6rf80dplXKDpXe5f0heaoIHUziEH08ZHRBa08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Simon Ser <contact@emersion.fr>
Subject: [PATCH 5.12 181/242] drm/ingenic: Switch IPU plane to type OVERLAY
Date:   Thu, 15 Jul 2021 20:39:03 +0200
Message-Id: <20210715182625.173409561@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 68b433fe6937cfa3f8975d18643d5956254edd6a upstream.

It should have been an OVERLAY from the beginning. The documentation
stipulates that there should be an unique PRIMARY plane per CRTC.

Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20210329175046.214629-2-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c |   11 +++++------
 drivers/gpu/drm/ingenic/ingenic-ipu.c     |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -413,7 +413,7 @@ static void ingenic_drm_plane_enable(str
 	unsigned int en_bit;
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
+		if (plane != &priv->f0)
 			en_bit = JZ_LCD_OSDC_F1EN;
 		else
 			en_bit = JZ_LCD_OSDC_F0EN;
@@ -428,7 +428,7 @@ void ingenic_drm_plane_disable(struct de
 	unsigned int en_bit;
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY)
+		if (plane != &priv->f0)
 			en_bit = JZ_LCD_OSDC_F1EN;
 		else
 			en_bit = JZ_LCD_OSDC_F0EN;
@@ -455,8 +455,7 @@ void ingenic_drm_plane_config(struct dev
 
 	ingenic_drm_plane_enable(priv, plane);
 
-	if (priv->soc_info->has_osd &&
-	    plane->type == DRM_PLANE_TYPE_PRIMARY) {
+	if (priv->soc_info->has_osd && plane != &priv->f0) {
 		switch (fourcc) {
 		case DRM_FORMAT_XRGB1555:
 			ctrl |= JZ_LCD_OSDCTRL_RGB555;
@@ -504,7 +503,7 @@ void ingenic_drm_plane_config(struct dev
 	}
 
 	if (priv->soc_info->has_osd) {
-		if (plane->type == DRM_PLANE_TYPE_PRIMARY) {
+		if (plane != &priv->f0) {
 			xy_reg = JZ_REG_LCD_XYP1;
 			size_reg = JZ_REG_LCD_SIZE1;
 		} else {
@@ -554,7 +553,7 @@ static void ingenic_drm_plane_atomic_upd
 		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[0];
 
-		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane == &priv->f0)
 			hwdesc = &priv->dma_hwdescs->hwdesc_f0;
 		else
 			hwdesc = &priv->dma_hwdescs->hwdesc_f1;
--- a/drivers/gpu/drm/ingenic/ingenic-ipu.c
+++ b/drivers/gpu/drm/ingenic/ingenic-ipu.c
@@ -760,7 +760,7 @@ static int ingenic_ipu_bind(struct devic
 
 	err = drm_universal_plane_init(drm, plane, 1, &ingenic_ipu_plane_funcs,
 				       soc_info->formats, soc_info->num_formats,
-				       NULL, DRM_PLANE_TYPE_PRIMARY, NULL);
+				       NULL, DRM_PLANE_TYPE_OVERLAY, NULL);
 	if (err) {
 		dev_err(dev, "Failed to init plane: %i\n", err);
 		return err;


