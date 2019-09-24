Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B751BD023
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfIXRDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409804AbfIXQmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1E2217D9;
        Tue, 24 Sep 2019 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343351;
        bh=TmUVAbWSEcYcj+irDhRNLuE3zHUilfSwCYvlTjdtEr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBD8bNM1g48X9pJtKfuSHgg82VV7LgC8IcW4GdvJ0F+ZZB2bygo+PwZG72TntheNG
         jNOcKk029iinJEQDM57mx9DxTcW+fet/BCWBUoMST1oCIbPWgtzQU/MAJAlEc6sVq3
         zUPjQV/5Ly4o4JYbqf5RDkr6Shs88XSKH+/9riN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        David Lechner <david@lechnology.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 14/87] drm/tinydrm/Kconfig: drivers: Select BACKLIGHT_CLASS_DEVICE
Date:   Tue, 24 Sep 2019 12:40:30 -0400
Message-Id: <20190924164144.25591-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

[ Upstream commit 3389669ac5ea598562673c04971d7bb0fab0e9f1 ]

The mipi_dbi helper is missing a dependency on DRM_KMS_HELPER and putting
that in revealed this problem:

drivers/video/fbdev/Kconfig:12:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:12: symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:75:     symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:69:     symbol DRM_KMS_HELPER is selected by TINYDRM_MIPI_DBI
drivers/gpu/drm/tinydrm/Kconfig:11:     symbol TINYDRM_MIPI_DBI is selected by TINYDRM_HX8357D
drivers/gpu/drm/tinydrm/Kconfig:15:     symbol TINYDRM_HX8357D depends on BACKLIGHT_CLASS_DEVICE
drivers/video/backlight/Kconfig:144:    symbol BACKLIGHT_CLASS_DEVICE is selected by FB_BACKLIGHT
drivers/video/fbdev/Kconfig:187:        symbol FB_BACKLIGHT depends on FB

A symbol that selects DRM_KMS_HELPER can not depend on
BACKLIGHT_CLASS_DEVICE. The reason for this is that DRM_KMS_FB_HELPER
selects FB instead of depending on it.

The tinydrm drivers have somehow gotten away with depending on
BACKLIGHT_CLASS_DEVICE because DRM_TINYDRM selects DRM_KMS_HELPER and the
drivers depend on that symbol.

An audit shows that all DRM drivers that select DRM_KMS_HELPER and use
BACKLIGHT_CLASS_DEVICE, selects it:
  DRM_TILCDC, DRM_GMA500, DRM_SHMOBILE, DRM_NOUVEAU, DRM_FSL_DCU,
  DRM_I915, DRM_RADEON, DRM_AMDGPU, DRM_PARADE_PS8622

Documentation/kbuild/kconfig-language.txt has a note regarding select:
1. 'select should be used with care since it doesn't visit dependencies.'
   This is not a problem since BACKLIGHT_CLASS_DEVICE doesn't have any
   dependencies.
2. 'In general use select only for non-visible symbols'
   BACKLIGHT_CLASS_DEVICE is user visible.

The real solution to this would be to have DRM_KMS_FB_HELPER depend on the
user visible symbol FB. That is a can of worms I'm not willing to tackle.
I fear that such a change will result in me handling difficult fallouts
for the next weeks. So I'm following DRM suite here.

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: David Lechner <david@lechnology.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190722104312.16184-7-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tinydrm/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tinydrm/Kconfig b/drivers/gpu/drm/tinydrm/Kconfig
index 87819c82bcce8..f2f0739d1035d 100644
--- a/drivers/gpu/drm/tinydrm/Kconfig
+++ b/drivers/gpu/drm/tinydrm/Kconfig
@@ -14,8 +14,8 @@ config TINYDRM_MIPI_DBI
 config TINYDRM_HX8357D
 	tristate "DRM support for HX8357D display panels"
 	depends on DRM_TINYDRM && SPI
-	depends on BACKLIGHT_CLASS_DEVICE
 	select TINYDRM_MIPI_DBI
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  DRM driver for the following HX8357D panels:
 	  * YX350HV15-T 3.5" 340x350 TFT (Adafruit 3.5")
@@ -35,8 +35,8 @@ config TINYDRM_ILI9225
 config TINYDRM_ILI9341
 	tristate "DRM support for ILI9341 display panels"
 	depends on DRM_TINYDRM && SPI
-	depends on BACKLIGHT_CLASS_DEVICE
 	select TINYDRM_MIPI_DBI
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  DRM driver for the following Ilitek ILI9341 panels:
 	  * YX240QV29-T 2.4" 240x320 TFT (Adafruit 2.4")
@@ -46,8 +46,8 @@ config TINYDRM_ILI9341
 config TINYDRM_MI0283QT
 	tristate "DRM support for MI0283QT"
 	depends on DRM_TINYDRM && SPI
-	depends on BACKLIGHT_CLASS_DEVICE
 	select TINYDRM_MIPI_DBI
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  DRM driver for the Multi-Inno MI0283QT display panel
 	  If M is selected the module will be called mi0283qt.
@@ -78,8 +78,8 @@ config TINYDRM_ST7586
 config TINYDRM_ST7735R
 	tristate "DRM support for Sitronix ST7735R display panels"
 	depends on DRM_TINYDRM && SPI
-	depends on BACKLIGHT_CLASS_DEVICE
 	select TINYDRM_MIPI_DBI
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  DRM driver Sitronix ST7735R with one of the following LCDs:
 	  * JD-T18003-T01 1.8" 128x160 TFT
-- 
2.20.1

