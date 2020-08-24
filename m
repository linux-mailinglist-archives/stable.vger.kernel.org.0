Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC424FAE3
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgHXKA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgHXIcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA772087D;
        Mon, 24 Aug 2020 08:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257952;
        bh=djItqV/kV6AW66PqnX49nw1rlTBXTbemxJL4FdlGbQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyT+xGh26f8Zv+mDO3mfriNWGawKhbmzQhThwPOBtE66dlB+4Fa5ybuyeaIULgI5w
         Ic6AX4E4PdnG8yDXTaN+DbmNSpWRgfGKJQIWKItxR9fVOwW4FDIQ7TLZeGWlHLZ4zn
         Na1y2IAYsVxHeI3uzasgn+4hNs6Bvj91huuuT0BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 003/148] drm/ast: Remove unused code paths for AST 1180
Date:   Mon, 24 Aug 2020 10:28:21 +0200
Message-Id: <20200824082414.106228049@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 05f13f5b5996d20a9819e0c6fd0cda4956c8aff9 ]

The ast driver contains code paths for AST 1180 chips. The chip is not
supported and the rsp code has never been tested. Simplify the driver by
removing the AST 1180 code.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200617080340.29584-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_drv.c  |  1 -
 drivers/gpu/drm/ast/ast_drv.h  |  2 -
 drivers/gpu/drm/ast/ast_main.c | 89 +++++++++++++++-------------------
 drivers/gpu/drm/ast/ast_mode.c | 11 +----
 drivers/gpu/drm/ast/ast_post.c | 10 ++--
 5 files changed, 43 insertions(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index b7ba22dddcad9..83509106f3ba9 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -59,7 +59,6 @@ static struct drm_driver driver;
 static const struct pci_device_id pciidlist[] = {
 	AST_VGA_DEVICE(PCI_CHIP_AST2000, NULL),
 	AST_VGA_DEVICE(PCI_CHIP_AST2100, NULL),
-	/*	AST_VGA_DEVICE(PCI_CHIP_AST1180, NULL), - don't bind to 1180 for now */
 	{0, 0, 0},
 };
 
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 656d591b154b3..09f2659e29118 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -52,7 +52,6 @@
 
 #define PCI_CHIP_AST2000 0x2000
 #define PCI_CHIP_AST2100 0x2010
-#define PCI_CHIP_AST1180 0x1180
 
 
 enum ast_chip {
@@ -64,7 +63,6 @@ enum ast_chip {
 	AST2300,
 	AST2400,
 	AST2500,
-	AST1180,
 };
 
 enum ast_tx_chip {
diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index e5398e3dabe70..f48a9f62368c0 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -142,50 +142,42 @@ static int ast_detect_chip(struct drm_device *dev, bool *need_post)
 	ast_detect_config_mode(dev, &scu_rev);
 
 	/* Identify chipset */
-	if (dev->pdev->device == PCI_CHIP_AST1180) {
-		ast->chip = AST1100;
-		DRM_INFO("AST 1180 detected\n");
-	} else {
-		if (dev->pdev->revision >= 0x40) {
-			ast->chip = AST2500;
-			DRM_INFO("AST 2500 detected\n");
-		} else if (dev->pdev->revision >= 0x30) {
-			ast->chip = AST2400;
-			DRM_INFO("AST 2400 detected\n");
-		} else if (dev->pdev->revision >= 0x20) {
-			ast->chip = AST2300;
-			DRM_INFO("AST 2300 detected\n");
-		} else if (dev->pdev->revision >= 0x10) {
-			switch (scu_rev & 0x0300) {
-			case 0x0200:
-				ast->chip = AST1100;
-				DRM_INFO("AST 1100 detected\n");
-				break;
-			case 0x0100:
-				ast->chip = AST2200;
-				DRM_INFO("AST 2200 detected\n");
-				break;
-			case 0x0000:
-				ast->chip = AST2150;
-				DRM_INFO("AST 2150 detected\n");
-				break;
-			default:
-				ast->chip = AST2100;
-				DRM_INFO("AST 2100 detected\n");
-				break;
-			}
-			ast->vga2_clone = false;
-		} else {
-			ast->chip = AST2000;
-			DRM_INFO("AST 2000 detected\n");
+	if (dev->pdev->revision >= 0x40) {
+		ast->chip = AST2500;
+		DRM_INFO("AST 2500 detected\n");
+	} else if (dev->pdev->revision >= 0x30) {
+		ast->chip = AST2400;
+		DRM_INFO("AST 2400 detected\n");
+	} else if (dev->pdev->revision >= 0x20) {
+		ast->chip = AST2300;
+		DRM_INFO("AST 2300 detected\n");
+	} else if (dev->pdev->revision >= 0x10) {
+		switch (scu_rev & 0x0300) {
+		case 0x0200:
+			ast->chip = AST1100;
+			DRM_INFO("AST 1100 detected\n");
+			break;
+		case 0x0100:
+			ast->chip = AST2200;
+			DRM_INFO("AST 2200 detected\n");
+			break;
+		case 0x0000:
+			ast->chip = AST2150;
+			DRM_INFO("AST 2150 detected\n");
+			break;
+		default:
+			ast->chip = AST2100;
+			DRM_INFO("AST 2100 detected\n");
+			break;
 		}
+		ast->vga2_clone = false;
+	} else {
+		ast->chip = AST2000;
+		DRM_INFO("AST 2000 detected\n");
 	}
 
 	/* Check if we support wide screen */
 	switch (ast->chip) {
-	case AST1180:
-		ast->support_wide_screen = true;
-		break;
 	case AST2000:
 		ast->support_wide_screen = false;
 		break;
@@ -469,15 +461,13 @@ int ast_driver_load(struct drm_device *dev, unsigned long flags)
 	if (need_post)
 		ast_post_gpu(dev);
 
-	if (ast->chip != AST1180) {
-		ret = ast_get_dram_info(dev);
-		if (ret)
-			goto out_free;
-		ast->vram_size = ast_get_vram_info(dev);
-		DRM_INFO("dram MCLK=%u Mhz type=%d bus_width=%d size=%08x\n",
-			 ast->mclk, ast->dram_type,
-			 ast->dram_bus_width, ast->vram_size);
-	}
+	ret = ast_get_dram_info(dev);
+	if (ret)
+		goto out_free;
+	ast->vram_size = ast_get_vram_info(dev);
+	DRM_INFO("dram MCLK=%u Mhz type=%d bus_width=%d size=%08x\n",
+		 ast->mclk, ast->dram_type,
+		 ast->dram_bus_width, ast->vram_size);
 
 	ret = ast_mm_init(ast);
 	if (ret)
@@ -496,8 +486,7 @@ int ast_driver_load(struct drm_device *dev, unsigned long flags)
 	    ast->chip == AST2200 ||
 	    ast->chip == AST2300 ||
 	    ast->chip == AST2400 ||
-	    ast->chip == AST2500 ||
-	    ast->chip == AST1180) {
+	    ast->chip == AST2500) {
 		dev->mode_config.max_width = 1920;
 		dev->mode_config.max_height = 2048;
 	} else {
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 3a3a511670c9c..73fd76cec5120 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -769,9 +769,6 @@ static void ast_crtc_dpms(struct drm_crtc *crtc, int mode)
 {
 	struct ast_private *ast = crtc->dev->dev_private;
 
-	if (ast->chip == AST1180)
-		return;
-
 	/* TODO: Maybe control display signal generation with
 	 *       Sync Enable (bit CR17.7).
 	 */
@@ -793,16 +790,10 @@ static void ast_crtc_dpms(struct drm_crtc *crtc, int mode)
 static int ast_crtc_helper_atomic_check(struct drm_crtc *crtc,
 					struct drm_crtc_state *state)
 {
-	struct ast_private *ast = crtc->dev->dev_private;
 	struct ast_crtc_state *ast_state;
 	const struct drm_format_info *format;
 	bool succ;
 
-	if (ast->chip == AST1180) {
-		DRM_ERROR("AST 1180 modesetting not supported\n");
-		return -EINVAL;
-	}
-
 	if (!state->enable)
 		return 0; /* no mode checks if CRTC is being disabled */
 
@@ -1044,7 +1035,7 @@ static enum drm_mode_status ast_mode_valid(struct drm_connector *connector,
 
 		if ((ast->chip == AST2100) || (ast->chip == AST2200) ||
 		    (ast->chip == AST2300) || (ast->chip == AST2400) ||
-		    (ast->chip == AST2500) || (ast->chip == AST1180)) {
+		    (ast->chip == AST2500)) {
 			if ((mode->hdisplay == 1920) && (mode->vdisplay == 1080))
 				return MODE_OK;
 
diff --git a/drivers/gpu/drm/ast/ast_post.c b/drivers/gpu/drm/ast/ast_post.c
index 2d1b186197432..af0c8ebb009a1 100644
--- a/drivers/gpu/drm/ast/ast_post.c
+++ b/drivers/gpu/drm/ast/ast_post.c
@@ -58,13 +58,9 @@ bool ast_is_vga_enabled(struct drm_device *dev)
 	struct ast_private *ast = dev->dev_private;
 	u8 ch;
 
-	if (ast->chip == AST1180) {
-		/* TODO 1180 */
-	} else {
-		ch = ast_io_read8(ast, AST_IO_VGA_ENABLE_PORT);
-		return !!(ch & 0x01);
-	}
-	return false;
+	ch = ast_io_read8(ast, AST_IO_VGA_ENABLE_PORT);
+
+	return !!(ch & 0x01);
 }
 
 static const u8 extreginfo[] = { 0x0f, 0x04, 0x1c, 0xff };
-- 
2.25.1



