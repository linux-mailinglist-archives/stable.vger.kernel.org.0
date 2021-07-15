Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6D3CA81A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbhGOS60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241892AbhGOS5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D38F7613CA;
        Thu, 15 Jul 2021 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375282;
        bh=kIJjCrthO1egSsvVnu+MUx6xexkyLYYkfMkFavHOCk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g55YOIPQN2fzg3/2TH8mh5d6BQ8OPnBvI1O8qNdWbOmyn21HXaTMibSE10dgCBt7o
         JRBm4xOaVpc7/uwqN5hODXtYKkBq9GyQXPwUZFOQe99PgAzg/itmDoTDohCbSXJPds
         SCHoY6rgvBvoHV5X6k5WJ1qBtJf5XarxI0dP85XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 003/242] drm/ast: Fixed CVE for DP501
Date:   Thu, 15 Jul 2021 20:36:05 +0200
Message-Id: <20210715182552.362293449@linuxfoundation.org>
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

From: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>

[ Upstream commit ba4e0339a6a33e2ba341703ce14ae8ca203cb2f1 ]

[Bug][DP501]
If ASPEED P2A (PCI to AHB) bridge is disabled and disallowed for
CVE_2019_6260 item3, and then the monitor's EDID is unable read through
Parade DP501.
The reason is the DP501's FW is mapped to BMC addressing space rather
than Host addressing space.
The resolution is that using "pci_iomap_range()" maps to DP501's FW that
stored on the end of FB (Frame Buffer).
In this case, FrameBuffer reserves the last 2MB used for the image of
DP501.

Signed-off-by: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421085859.17761-1-kuohsiang_chou@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_dp501.c | 139 +++++++++++++++++++++++---------
 drivers/gpu/drm/ast/ast_drv.h   |  12 +++
 drivers/gpu/drm/ast/ast_main.c  |  11 ++-
 3 files changed, 125 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_dp501.c b/drivers/gpu/drm/ast/ast_dp501.c
index 88121c0e0d05..cd93c44f2662 100644
--- a/drivers/gpu/drm/ast/ast_dp501.c
+++ b/drivers/gpu/drm/ast/ast_dp501.c
@@ -189,6 +189,9 @@ bool ast_backup_fw(struct drm_device *dev, u8 *addr, u32 size)
 	u32 i, data;
 	u32 boot_address;
 
+	if (ast->config_mode != ast_use_p2a)
+		return false;
+
 	data = ast_mindwm(ast, 0x1e6e2100) & 0x01;
 	if (data) {
 		boot_address = get_fw_base(ast);
@@ -207,6 +210,9 @@ static bool ast_launch_m68k(struct drm_device *dev)
 	u8 *fw_addr = NULL;
 	u8 jreg;
 
+	if (ast->config_mode != ast_use_p2a)
+		return false;
+
 	data = ast_mindwm(ast, 0x1e6e2100) & 0x01;
 	if (!data) {
 
@@ -271,25 +277,55 @@ u8 ast_get_dp501_max_clk(struct drm_device *dev)
 	struct ast_private *ast = to_ast_private(dev);
 	u32 boot_address, offset, data;
 	u8 linkcap[4], linkrate, linklanes, maxclk = 0xff;
+	u32 *plinkcap;
 
-	boot_address = get_fw_base(ast);
-
-	/* validate FW version */
-	offset = 0xf000;
-	data = ast_mindwm(ast, boot_address + offset);
-	if ((data & 0xf0) != 0x10) /* version: 1x */
-		return maxclk;
-
-	/* Read Link Capability */
-	offset  = 0xf014;
-	*(u32 *)linkcap = ast_mindwm(ast, boot_address + offset);
-	if (linkcap[2] == 0) {
-		linkrate = linkcap[0];
-		linklanes = linkcap[1];
-		data = (linkrate == 0x0a) ? (90 * linklanes) : (54 * linklanes);
-		if (data > 0xff)
-			data = 0xff;
-		maxclk = (u8)data;
+	if (ast->config_mode == ast_use_p2a) {
+		boot_address = get_fw_base(ast);
+
+		/* validate FW version */
+		offset = AST_DP501_GBL_VERSION;
+		data = ast_mindwm(ast, boot_address + offset);
+		if ((data & AST_DP501_FW_VERSION_MASK) != AST_DP501_FW_VERSION_1) /* version: 1x */
+			return maxclk;
+
+		/* Read Link Capability */
+		offset  = AST_DP501_LINKRATE;
+		plinkcap = (u32 *)linkcap;
+		*plinkcap  = ast_mindwm(ast, boot_address + offset);
+		if (linkcap[2] == 0) {
+			linkrate = linkcap[0];
+			linklanes = linkcap[1];
+			data = (linkrate == 0x0a) ? (90 * linklanes) : (54 * linklanes);
+			if (data > 0xff)
+				data = 0xff;
+			maxclk = (u8)data;
+		}
+	} else {
+		if (!ast->dp501_fw_buf)
+			return AST_DP501_DEFAULT_DCLK;	/* 1024x768 as default */
+
+		/* dummy read */
+		offset = 0x0000;
+		data = readl(ast->dp501_fw_buf + offset);
+
+		/* validate FW version */
+		offset = AST_DP501_GBL_VERSION;
+		data = readl(ast->dp501_fw_buf + offset);
+		if ((data & AST_DP501_FW_VERSION_MASK) != AST_DP501_FW_VERSION_1) /* version: 1x */
+			return maxclk;
+
+		/* Read Link Capability */
+		offset = AST_DP501_LINKRATE;
+		plinkcap = (u32 *)linkcap;
+		*plinkcap = readl(ast->dp501_fw_buf + offset);
+		if (linkcap[2] == 0) {
+			linkrate = linkcap[0];
+			linklanes = linkcap[1];
+			data = (linkrate == 0x0a) ? (90 * linklanes) : (54 * linklanes);
+			if (data > 0xff)
+				data = 0xff;
+			maxclk = (u8)data;
+		}
 	}
 	return maxclk;
 }
@@ -298,26 +334,57 @@ bool ast_dp501_read_edid(struct drm_device *dev, u8 *ediddata)
 {
 	struct ast_private *ast = to_ast_private(dev);
 	u32 i, boot_address, offset, data;
+	u32 *pEDIDidx;
 
-	boot_address = get_fw_base(ast);
-
-	/* validate FW version */
-	offset = 0xf000;
-	data = ast_mindwm(ast, boot_address + offset);
-	if ((data & 0xf0) != 0x10)
-		return false;
-
-	/* validate PnP Monitor */
-	offset = 0xf010;
-	data = ast_mindwm(ast, boot_address + offset);
-	if (!(data & 0x01))
-		return false;
+	if (ast->config_mode == ast_use_p2a) {
+		boot_address = get_fw_base(ast);
 
-	/* Read EDID */
-	offset = 0xf020;
-	for (i = 0; i < 128; i += 4) {
-		data = ast_mindwm(ast, boot_address + offset + i);
-		*(u32 *)(ediddata + i) = data;
+		/* validate FW version */
+		offset = AST_DP501_GBL_VERSION;
+		data = ast_mindwm(ast, boot_address + offset);
+		if ((data & AST_DP501_FW_VERSION_MASK) != AST_DP501_FW_VERSION_1)
+			return false;
+
+		/* validate PnP Monitor */
+		offset = AST_DP501_PNPMONITOR;
+		data = ast_mindwm(ast, boot_address + offset);
+		if (!(data & AST_DP501_PNP_CONNECTED))
+			return false;
+
+		/* Read EDID */
+		offset = AST_DP501_EDID_DATA;
+		for (i = 0; i < 128; i += 4) {
+			data = ast_mindwm(ast, boot_address + offset + i);
+			pEDIDidx = (u32 *)(ediddata + i);
+			*pEDIDidx = data;
+		}
+	} else {
+		if (!ast->dp501_fw_buf)
+			return false;
+
+		/* dummy read */
+		offset = 0x0000;
+		data = readl(ast->dp501_fw_buf + offset);
+
+		/* validate FW version */
+		offset = AST_DP501_GBL_VERSION;
+		data = readl(ast->dp501_fw_buf + offset);
+		if ((data & AST_DP501_FW_VERSION_MASK) != AST_DP501_FW_VERSION_1)
+			return false;
+
+		/* validate PnP Monitor */
+		offset = AST_DP501_PNPMONITOR;
+		data = readl(ast->dp501_fw_buf + offset);
+		if (!(data & AST_DP501_PNP_CONNECTED))
+			return false;
+
+		/* Read EDID */
+		offset = AST_DP501_EDID_DATA;
+		for (i = 0; i < 128; i += 4) {
+			data = readl(ast->dp501_fw_buf + offset + i);
+			pEDIDidx = (u32 *)(ediddata + i);
+			*pEDIDidx = data;
+		}
 	}
 
 	return true;
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index f871fc36c2f7..a3f67a34f616 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -121,6 +121,7 @@ struct ast_private {
 
 	void __iomem *regs;
 	void __iomem *ioregs;
+	void __iomem *dp501_fw_buf;
 
 	enum ast_chip chip;
 	bool vga2_clone;
@@ -298,6 +299,17 @@ int ast_mode_config_init(struct ast_private *ast);
 #define AST_MM_ALIGN_SHIFT 4
 #define AST_MM_ALIGN_MASK ((1 << AST_MM_ALIGN_SHIFT) - 1)
 
+#define AST_DP501_FW_VERSION_MASK	GENMASK(7, 4)
+#define AST_DP501_FW_VERSION_1		BIT(4)
+#define AST_DP501_PNP_CONNECTED		BIT(1)
+
+#define AST_DP501_DEFAULT_DCLK	65
+
+#define AST_DP501_GBL_VERSION	0xf000
+#define AST_DP501_PNPMONITOR	0xf010
+#define AST_DP501_LINKRATE	0xf014
+#define AST_DP501_EDID_DATA	0xf020
+
 int ast_mm_init(struct ast_private *ast);
 
 /* ast post */
diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index c29cc7f19863..189d783f6e2c 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -99,7 +99,7 @@ static void ast_detect_config_mode(struct drm_device *dev, u32 *scu_rev)
 	if (!(jregd0 & 0x80) || !(jregd1 & 0x10)) {
 		/* Double check it's actually working */
 		data = ast_read32(ast, 0xf004);
-		if (data != 0xFFFFFFFF) {
+		if ((data != 0xFFFFFFFF) && (data != 0x00)) {
 			/* P2A works, grab silicon revision */
 			ast->config_mode = ast_use_p2a;
 
@@ -411,6 +411,7 @@ struct ast_private *ast_device_create(const struct drm_driver *drv,
 		return ast;
 	dev = &ast->base;
 
+	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
 	ast->regs = pcim_iomap(pdev, 1, 0);
@@ -450,6 +451,14 @@ struct ast_private *ast_device_create(const struct drm_driver *drv,
 	if (ret)
 		return ERR_PTR(ret);
 
+	/* map reserved buffer */
+	ast->dp501_fw_buf = NULL;
+	if (dev->vram_mm->vram_size < pci_resource_len(dev->pdev, 0)) {
+		ast->dp501_fw_buf = pci_iomap_range(dev->pdev, 0, dev->vram_mm->vram_size, 0);
+		if (!ast->dp501_fw_buf)
+			drm_info(dev, "failed to map reserved buffer!\n");
+	}
+
 	ret = ast_mode_config_init(ast);
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.30.2



