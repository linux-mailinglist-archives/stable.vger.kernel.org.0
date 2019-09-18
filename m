Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C62B5D4F
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbfIRGUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbfIRGUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C57721924;
        Wed, 18 Sep 2019 06:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787651;
        bh=yQ9h4yLVSfDxLQCWQd9WmA0cFx043a9Mbo/vQWky9s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7YBDrzHn/XwdlzYew6Vy186ZAl2giD+seu/AlHBDvBik/FwuKG94IgbVXuGEpVhv
         f16GwILB/GOFLgwVQH9W4Aq9XqF+Pk6exKwKzm5OvRcGWLsCrTFsACwx0wa/7dFL87
         ckkyOm8J6uaJrJJMTBQlL0eFWIO5jh4CHStq0xxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 4.14 28/45] drm/meson: Add support for XBGR8888 & ABGR8888 formats
Date:   Wed, 18 Sep 2019 08:19:06 +0200
Message-Id: <20190918061226.060082443@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
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
@@ -124,6 +124,13 @@ static void meson_plane_atomic_update(st
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
@@ -131,6 +138,13 @@ static void meson_plane_atomic_update(st
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
@@ -200,7 +214,9 @@ static const struct drm_plane_funcs meso
 
 static const uint32_t supported_drm_formats[] = {
 	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_XBGR8888,
 	DRM_FORMAT_RGB888,
 	DRM_FORMAT_RGB565,
 };


