Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131834049D1
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbhIILni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235738AbhIILmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17992611CA;
        Thu,  9 Sep 2021 11:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187704;
        bh=kGXbNKcYX2nS3OMh1RxXIHO3hMuuK6b0q/CJlBpnRlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfXKUAI7nV8dpmOun8VRKIsSwPG7+Ck7And25+ifw4UMhGh8zazJhYqSs4WMVYTz5
         9jxrIgcqORDLu4QXTndimO8qisW5jGpcih1F3TwA5rN+Ue7JBb8VZEh82JqdN7EgA7
         WypBar0pDMSgX/aFv48tzuhLLwFOg/2Zqa5xOUCzQIUP8EZZyBiF+GL+xzk4Mz/T1F
         KnR1nwxU3xUvqlv5gIUGxjBQ8p5gP3LMzj9NMd7iyckG7Seh6FhoALAMgV1qPhrdVB
         r2hPg7/JZUJEJb+TenaaRpaMNSMzmVkeAQk++g09LQ+e4Y0ivomCs1nW+cc1BZ8Gfv
         4VaVzGFjTCyMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 029/252] drm/ast: Disable fast reset after DRAM initial
Date:   Thu,  9 Sep 2021 07:37:23 -0400
Message-Id: <20210909114106.141462-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>

[ Upstream commit f34bf652d680cf65783e7c57d61c94ee87f092bd ]

[Bug][AST2500]

V1:
When AST2500 acts as stand-alone VGA so that DRAM and DVO initialization
have to be achieved by VGA driver with P2A (PCI to AHB) enabling.
However, HW suggests disable Fast reset mode after DRAM initializaton,
because fast reset mode is mainly designed for ARM ICE debugger.
Once Fast reset is checked as enabling, WDT (Watch Dog Timer) should be
first enabled to avoid system deadlock before disable fast reset mode.

V2:
Use to_pci_dev() to get revision of PCI configuration.

V3:
If SCU00 is not unlocked, just enter its password again.
It is unnecessary to clear AHB lock condition and restore WDT default
setting again, before Fast-reset clearing.

V4:
repatch after "error : could not build fake ancestor" resolved.

V5:
Since CVE_2019_6260 item3, Most of AST2500 have disabled P2A(PCIe to AMBA).
However, for backward compatibility, some patches about P2A, such as items
of v5.2 and v5.3, are considered to be upstreamed with comments.
1. Add define macro to improve source readability.
ast_drv.h, ast_main.c, ast_post.c
2. Add comment about "Fast restet" is enabled for ARM-ICE debugger
ast_post.c
3. Add comment about Reset USB port to patch USB unknown device issue
ast_post.c

Signed-off-by: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210709080900.4056-1-kuohsiang_chou@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_drv.h  |  6 +++
 drivers/gpu/drm/ast/ast_main.c |  5 ++
 drivers/gpu/drm/ast/ast_post.c | 91 ++++++++++++++++++++++++----------
 3 files changed, 76 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 911f9f414774..39ca338eb80b 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -337,6 +337,11 @@ int ast_mode_config_init(struct ast_private *ast);
 #define AST_DP501_LINKRATE	0xf014
 #define AST_DP501_EDID_DATA	0xf020
 
+/* Define for Soc scratched reg */
+#define AST_VRAM_INIT_STATUS_MASK	GENMASK(7, 6)
+//#define AST_VRAM_INIT_BY_BMC		BIT(7)
+//#define AST_VRAM_INIT_READY		BIT(6)
+
 int ast_mm_init(struct ast_private *ast);
 
 /* ast post */
@@ -346,6 +351,7 @@ bool ast_is_vga_enabled(struct drm_device *dev);
 void ast_post_gpu(struct drm_device *dev);
 u32 ast_mindwm(struct ast_private *ast, u32 r);
 void ast_moutdwm(struct ast_private *ast, u32 r, u32 v);
+void ast_patch_ahb_2500(struct ast_private *ast);
 /* ast dp501 */
 void ast_set_dp501_video_output(struct drm_device *dev, u8 mode);
 bool ast_backup_fw(struct drm_device *dev, u8 *addr, u32 size);
diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index 2aff2e6cf450..79a361867955 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -97,6 +97,11 @@ static void ast_detect_config_mode(struct drm_device *dev, u32 *scu_rev)
 	jregd0 = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd0, 0xff);
 	jregd1 = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd1, 0xff);
 	if (!(jregd0 & 0x80) || !(jregd1 & 0x10)) {
+		/* Patch AST2500 */
+		if (((pdev->revision & 0xF0) == 0x40)
+			&& ((jregd0 & AST_VRAM_INIT_STATUS_MASK) == 0))
+			ast_patch_ahb_2500(ast);
+
 		/* Double check it's actually working */
 		data = ast_read32(ast, 0xf004);
 		if ((data != 0xFFFFFFFF) && (data != 0x00)) {
diff --git a/drivers/gpu/drm/ast/ast_post.c b/drivers/gpu/drm/ast/ast_post.c
index 0607658dde51..b5d92f652fd8 100644
--- a/drivers/gpu/drm/ast/ast_post.c
+++ b/drivers/gpu/drm/ast/ast_post.c
@@ -2028,6 +2028,40 @@ static bool ast_dram_init_2500(struct ast_private *ast)
 	return true;
 }
 
+void ast_patch_ahb_2500(struct ast_private *ast)
+{
+	u32	data;
+
+	/* Clear bus lock condition */
+	ast_moutdwm(ast, 0x1e600000, 0xAEED1A03);
+	ast_moutdwm(ast, 0x1e600084, 0x00010000);
+	ast_moutdwm(ast, 0x1e600088, 0x00000000);
+	ast_moutdwm(ast, 0x1e6e2000, 0x1688A8A8);
+	data = ast_mindwm(ast, 0x1e6e2070);
+	if (data & 0x08000000) {					/* check fast reset */
+		/*
+		 * If "Fast restet" is enabled for ARM-ICE debugger,
+		 * then WDT needs to enable, that
+		 * WDT04 is WDT#1 Reload reg.
+		 * WDT08 is WDT#1 counter restart reg to avoid system deadlock
+		 * WDT0C is WDT#1 control reg
+		 *	[6:5]:= 01:Full chip
+		 *	[4]:= 1:1MHz clock source
+		 *	[1]:= 1:WDT will be cleeared and disabled after timeout occurs
+		 *	[0]:= 1:WDT enable
+		 */
+		ast_moutdwm(ast, 0x1E785004, 0x00000010);
+		ast_moutdwm(ast, 0x1E785008, 0x00004755);
+		ast_moutdwm(ast, 0x1E78500c, 0x00000033);
+		udelay(1000);
+	}
+	do {
+		ast_moutdwm(ast, 0x1e6e2000, 0x1688A8A8);
+		data = ast_mindwm(ast, 0x1e6e2000);
+	}	while (data != 1);
+	ast_moutdwm(ast, 0x1e6e207c, 0x08000000);	/* clear fast reset */
+}
+
 void ast_post_chip_2500(struct drm_device *dev)
 {
 	struct ast_private *ast = to_ast_private(dev);
@@ -2035,39 +2069,44 @@ void ast_post_chip_2500(struct drm_device *dev)
 	u8 reg;
 
 	reg = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd0, 0xff);
-	if ((reg & 0x80) == 0) {/* vga only */
+	if ((reg & AST_VRAM_INIT_STATUS_MASK) == 0) {/* vga only */
 		/* Clear bus lock condition */
-		ast_moutdwm(ast, 0x1e600000, 0xAEED1A03);
-		ast_moutdwm(ast, 0x1e600084, 0x00010000);
-		ast_moutdwm(ast, 0x1e600088, 0x00000000);
-		ast_moutdwm(ast, 0x1e6e2000, 0x1688A8A8);
-		ast_write32(ast, 0xf004, 0x1e6e0000);
-		ast_write32(ast, 0xf000, 0x1);
-		ast_write32(ast, 0x12000, 0x1688a8a8);
-		while (ast_read32(ast, 0x12000) != 0x1)
-			;
-
-		ast_write32(ast, 0x10000, 0xfc600309);
-		while (ast_read32(ast, 0x10000) != 0x1)
-			;
+		ast_patch_ahb_2500(ast);
+
+		/* Disable watchdog */
+		ast_moutdwm(ast, 0x1E78502C, 0x00000000);
+		ast_moutdwm(ast, 0x1E78504C, 0x00000000);
+
+		/*
+		 * Reset USB port to patch USB unknown device issue
+		 * SCU90 is Multi-function Pin Control #5
+		 *	[29]:= 1:Enable USB2.0 Host port#1 (that the mutually shared USB2.0 Hub
+		 *				port).
+		 * SCU94 is Multi-function Pin Control #6
+		 *	[14:13]:= 1x:USB2.0 Host2 controller
+		 * SCU70 is Hardware Strap reg
+		 *	[23]:= 1:CLKIN is 25MHz and USBCK1 = 24/48 MHz (determined by
+		 *				[18]: 0(24)/1(48) MHz)
+		 * SCU7C is Write clear reg to SCU70
+		 *	[23]:= write 1 and then SCU70[23] will be clear as 0b.
+		 */
+		ast_moutdwm(ast, 0x1E6E2090, 0x20000000);
+		ast_moutdwm(ast, 0x1E6E2094, 0x00004000);
+		if (ast_mindwm(ast, 0x1E6E2070) & 0x00800000) {
+			ast_moutdwm(ast, 0x1E6E207C, 0x00800000);
+			mdelay(100);
+			ast_moutdwm(ast, 0x1E6E2070, 0x00800000);
+		}
+		/* Modify eSPI reset pin */
+		temp = ast_mindwm(ast, 0x1E6E2070);
+		if (temp & 0x02000000)
+			ast_moutdwm(ast, 0x1E6E207C, 0x00004000);
 
 		/* Slow down CPU/AHB CLK in VGA only mode */
 		temp = ast_read32(ast, 0x12008);
 		temp |= 0x73;
 		ast_write32(ast, 0x12008, temp);
 
-		/* Reset USB port to patch USB unknown device issue */
-		ast_moutdwm(ast, 0x1e6e2090, 0x20000000);
-		temp  = ast_mindwm(ast, 0x1e6e2094);
-		temp |= 0x00004000;
-		ast_moutdwm(ast, 0x1e6e2094, temp);
-		temp  = ast_mindwm(ast, 0x1e6e2070);
-		if (temp & 0x00800000) {
-			ast_moutdwm(ast, 0x1e6e207c, 0x00800000);
-			mdelay(100);
-			ast_moutdwm(ast, 0x1e6e2070, 0x00800000);
-		}
-
 		if (!ast_dram_init_2500(ast))
 			drm_err(dev, "DRAM init failed !\n");
 
-- 
2.30.2

