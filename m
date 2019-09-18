Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44A2B5C6B
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfIRG0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbfIRG0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED4420644;
        Wed, 18 Sep 2019 06:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787972;
        bh=EOYs7diMSh6dCmIDrI61xIdpH8YnS9qM0s6IaGFfKao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwoW93TyycDYqa/HwnOX+WNJdltzVYQtlCfJ23qwZ2uWUx7PBOamMA43LAXAPZbNu
         hy0lO5tr+MUZxNutUTLBKjbThDkF2NGI2Q8T4Fm1t2vwIoEEkRS2j1UoKHL15uLv32
         D54SmQyU4mgJnjqVB+jBGZv7DN6xkO2xKSt5MTho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.2 53/85] drm/meson: Add support for XBGR8888 & ABGR8888 formats
Date:   Wed, 18 Sep 2019 08:19:11 +0200
Message-Id: <20190918061235.793519854@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 5ffff4415f9eeae834960226770963e2947e17eb upstream.

Add missing XBGR8888 & ABGR8888 formats variants from the primary plane.

Fixes: bbbe775ec5b5 ("drm: Add support for Amlogic Meson Graphic Controller")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190429075238.7884-1-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/meson/meson_plane.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/meson/meson_plane.c
+++ b/drivers/gpu/drm/meson/meson_plane.c
@@ -153,6 +153,13 @@ static void meson_plane_atomic_update(st
 		priv->viu.osd1_blk0_cfg[0] |= OSD_BLK_MODE_32 |
 					      OSD_COLOR_MATRIX_32_ARGB;
 		break;
+	case DRM_FORMAT_XBGR8888:
+		/* For XRGB, replace the pixel's alpha by 0xFF */
+		writel_bits_relaxed(OSD_REPLACE_EN, OSD_REPLACE_EN,
+				    priv->io_base + _REG(VIU_OSD1_CTRL_STAT2));
+		priv->viu.osd1_blk0_cfg[0] |= OSD_BLK_MODE_32 |
+					      OSD_COLOR_MATRIX_32_ABGR;
+		break;
 	case DRM_FORMAT_ARGB8888:
 		/* For ARGB, use the pixel's alpha */
 		writel_bits_relaxed(OSD_REPLACE_EN, 0,
@@ -160,6 +167,13 @@ static void meson_plane_atomic_update(st
 		priv->viu.osd1_blk0_cfg[0] |= OSD_BLK_MODE_32 |
 					      OSD_COLOR_MATRIX_32_ARGB;
 		break;
+	case DRM_FORMAT_ABGR8888:
+		/* For ARGB, use the pixel's alpha */
+		writel_bits_relaxed(OSD_REPLACE_EN, 0,
+				    priv->io_base + _REG(VIU_OSD1_CTRL_STAT2));
+		priv->viu.osd1_blk0_cfg[0] |= OSD_BLK_MODE_32 |
+					      OSD_COLOR_MATRIX_32_ABGR;
+		break;
 	case DRM_FORMAT_RGB888:
 		priv->viu.osd1_blk0_cfg[0] |= OSD_BLK_MODE_24 |
 					      OSD_COLOR_MATRIX_24_RGB;
@@ -346,7 +360,9 @@ static const struct drm_plane_funcs meso
 
 static const uint32_t supported_drm_formats[] = {
 	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_XBGR8888,
 	DRM_FORMAT_RGB888,
 	DRM_FORMAT_RGB565,
 };


