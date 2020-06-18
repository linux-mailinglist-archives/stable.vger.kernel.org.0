Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A251FE738
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgFRCjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgFRBM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B43C8214DB;
        Thu, 18 Jun 2020 01:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442778;
        bh=QzHsFMc7e1sAg3TGj2D+4DGxTg90cYJi1ce6cG/HcDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEAKdeDvC6VfbF2KaH5xqS1cIIWVq5MKAEWURbodcwLtrCFT0IcKXjSue3C75AX3s
         uMnoT6iwmm8JlgHXl3oOS28rS4nu2sd4J7exiYgdzPJSdou1HDdd/EU+gZHxA883MF
         aaUAebt15C5JzFVdjqyJp/1UXgHtA3MJcplD3g0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bharat Gooty <bharat.gooty@broadcom.com>,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 224/388] drivers: phy: sr-usb: do not use internal fsm for USB2 phy init
Date:   Wed, 17 Jun 2020 21:05:21 -0400
Message-Id: <20200618010805.600873-224-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharat Gooty <bharat.gooty@broadcom.com>

[ Upstream commit 6f0577d1411337a0d97d545abe4a784e9e611516 ]

During different reboot cycles, USB PHY PLL may not always lock
during initialization and therefore can cause USB to be not usable.

Hence do not use internal FSM programming sequence for the USB
PHY initialization.

Fixes: 4dcddbb38b64 ("phy: sr-usb: Add Stingray USB PHY driver")
Signed-off-by: Bharat Gooty <bharat.gooty@broadcom.com>
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Link: https://lore.kernel.org/r/20200513173947.10919-1-rayagonda.kokatanur@broadcom.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-bcm-sr-usb.c | 55 +--------------------------
 1 file changed, 2 insertions(+), 53 deletions(-)

diff --git a/drivers/phy/broadcom/phy-bcm-sr-usb.c b/drivers/phy/broadcom/phy-bcm-sr-usb.c
index fe6c58910e4c..7c7862b4f41f 100644
--- a/drivers/phy/broadcom/phy-bcm-sr-usb.c
+++ b/drivers/phy/broadcom/phy-bcm-sr-usb.c
@@ -16,8 +16,6 @@ enum bcm_usb_phy_version {
 };
 
 enum bcm_usb_phy_reg {
-	PLL_NDIV_FRAC,
-	PLL_NDIV_INT,
 	PLL_CTRL,
 	PHY_CTRL,
 	PHY_PLL_CTRL,
@@ -31,18 +29,11 @@ static const u8 bcm_usb_combo_phy_ss[] = {
 };
 
 static const u8 bcm_usb_combo_phy_hs[] = {
-	[PLL_NDIV_FRAC]	= 0x04,
-	[PLL_NDIV_INT]	= 0x08,
 	[PLL_CTRL]	= 0x0c,
 	[PHY_CTRL]	= 0x10,
 };
 
-#define HSPLL_NDIV_INT_VAL	0x13
-#define HSPLL_NDIV_FRAC_VAL	0x1005
-
 static const u8 bcm_usb_hs_phy[] = {
-	[PLL_NDIV_FRAC]	= 0x0,
-	[PLL_NDIV_INT]	= 0x4,
 	[PLL_CTRL]	= 0x8,
 	[PHY_CTRL]	= 0xc,
 };
@@ -52,7 +43,6 @@ enum pll_ctrl_bits {
 	SSPLL_SUSPEND_EN,
 	PLL_SEQ_START,
 	PLL_LOCK,
-	PLL_PDIV,
 };
 
 static const u8 u3pll_ctrl[] = {
@@ -66,29 +56,17 @@ static const u8 u3pll_ctrl[] = {
 #define HSPLL_PDIV_VAL		0x1
 
 static const u8 u2pll_ctrl[] = {
-	[PLL_PDIV]	= 1,
 	[PLL_RESETB]	= 5,
 	[PLL_LOCK]	= 6,
 };
 
 enum bcm_usb_phy_ctrl_bits {
 	CORERDY,
-	AFE_LDO_PWRDWNB,
-	AFE_PLL_PWRDWNB,
-	AFE_BG_PWRDWNB,
-	PHY_ISO,
 	PHY_RESETB,
 	PHY_PCTL,
 };
 
 #define PHY_PCTL_MASK	0xffff
-/*
- * 0x0806 of PCTL_VAL has below bits set
- * BIT-8 : refclk divider 1
- * BIT-3:2: device mode; mode is not effect
- * BIT-1: soft reset active low
- */
-#define HSPHY_PCTL_VAL	0x0806
 #define SSPHY_PCTL_VAL	0x0006
 
 static const u8 u3phy_ctrl[] = {
@@ -98,10 +76,6 @@ static const u8 u3phy_ctrl[] = {
 
 static const u8 u2phy_ctrl[] = {
 	[CORERDY]		= 0,
-	[AFE_LDO_PWRDWNB]	= 1,
-	[AFE_PLL_PWRDWNB]	= 2,
-	[AFE_BG_PWRDWNB]	= 3,
-	[PHY_ISO]		= 4,
 	[PHY_RESETB]		= 5,
 	[PHY_PCTL]		= 6,
 };
@@ -186,38 +160,13 @@ static int bcm_usb_hs_phy_init(struct bcm_usb_phy_cfg *phy_cfg)
 	int ret = 0;
 	void __iomem *regs = phy_cfg->regs;
 	const u8 *offset;
-	u32 rd_data;
 
 	offset = phy_cfg->offset;
 
-	writel(HSPLL_NDIV_INT_VAL, regs + offset[PLL_NDIV_INT]);
-	writel(HSPLL_NDIV_FRAC_VAL, regs + offset[PLL_NDIV_FRAC]);
-
-	rd_data = readl(regs + offset[PLL_CTRL]);
-	rd_data &= ~(HSPLL_PDIV_MASK << u2pll_ctrl[PLL_PDIV]);
-	rd_data |= (HSPLL_PDIV_VAL << u2pll_ctrl[PLL_PDIV]);
-	writel(rd_data, regs + offset[PLL_CTRL]);
-
-	/* Set Core Ready high */
-	bcm_usb_reg32_setbits(regs + offset[PHY_CTRL],
-			      BIT(u2phy_ctrl[CORERDY]));
-
-	/* Maximum timeout for Core Ready done */
-	msleep(30);
-
+	bcm_usb_reg32_clrbits(regs + offset[PLL_CTRL],
+			      BIT(u2pll_ctrl[PLL_RESETB]));
 	bcm_usb_reg32_setbits(regs + offset[PLL_CTRL],
 			      BIT(u2pll_ctrl[PLL_RESETB]));
-	bcm_usb_reg32_setbits(regs + offset[PHY_CTRL],
-			      BIT(u2phy_ctrl[PHY_RESETB]));
-
-
-	rd_data = readl(regs + offset[PHY_CTRL]);
-	rd_data &= ~(PHY_PCTL_MASK << u2phy_ctrl[PHY_PCTL]);
-	rd_data |= (HSPHY_PCTL_VAL << u2phy_ctrl[PHY_PCTL]);
-	writel(rd_data, regs + offset[PHY_CTRL]);
-
-	/* Maximum timeout for PLL reset done */
-	msleep(30);
 
 	ret = bcm_usb_pll_lock_check(regs + offset[PLL_CTRL],
 				     BIT(u2pll_ctrl[PLL_LOCK]));
-- 
2.25.1

