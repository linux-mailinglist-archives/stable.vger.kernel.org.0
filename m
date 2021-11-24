Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7F45D06F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352230AbhKXWxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352221AbhKXWxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3173861074;
        Wed, 24 Nov 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794210;
        bh=PbvrPwin+UfMB6JKJNnqUr8Irinrk68Nm/z6gcOPn9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/nwntXiMjHa9gurHUoXY7vNdQWlKvPLofFARRGNv9enSKVum7XHCw9cGtBvdfg2W
         tYX1rYOTUHS7kjfv5qFrVmAE/YP1dvQ0DpNWopePSfXbJTxxgNmpMB46VOmYxjrJtG
         VL8fdLna8Hka9qgS07/gJg6NSjZdDgfDds/w/un5rXrbbKjvaB3Z6L9mV4jqac5jcQ
         T5Oo+syb8DQ4aVnYNL/cRGFJtX3iT7llBz1YmQZxiLFhL+JUjVZv/Z4H+SUMLVB2Ck
         SipEdEAK7GHs6o8yXP5R9+eXS2xCD78VnmiTBdq2fnBxgcQIwMtGbsdzp6zx1VUGYz
         HnrzxSNf/pLsA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Evan Wang <xswang@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Victor Gu <xigu@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 14/24] PCI: aardvark: Remove PCIe outbound window configuration
Date:   Wed, 24 Nov 2021 23:49:23 +0100
Message-Id: <20211124224933.24275-15-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Wang <xswang@marvell.com>

commit 6df6ba974a55678a2c7d9a0c06eb15cde0c4b184 upstream.

Outbound window is used to translate CPU space addresses to PCIe space
addresses when the CPU initiates PCIe transactions.

According to the suggestion of the HW designers, the recommended
solution is to use the default outbound parameters, even though the
current outbound window setting does not cause any known functional
issue.

This patch doesn't address any known functional issue, but aligns to
HW design guidelines, and removes code that isn't needed.

Signed-off-by: Evan Wang <xswang@marvell.com>
[Thomas: tweak commit log.]
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
[lorenzo.pieralisi@arm.com: handled host->controller dir move]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Victor Gu <xigu@marvell.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 55 ---------------------------------
 1 file changed, 55 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 66c4b9282420..4021c4d1c6e8 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -107,24 +107,6 @@
 #define PCIE_MSI_PAYLOAD_REG			(CONTROL_BASE_ADDR + 0x9C)
 #define     PCIE_MSI_DATA_MASK			GENMASK(15, 0)
 
-/* PCIe window configuration */
-#define OB_WIN_BASE_ADDR			0x4c00
-#define OB_WIN_BLOCK_SIZE			0x20
-#define OB_WIN_REG_ADDR(win, offset)		(OB_WIN_BASE_ADDR + \
-						 OB_WIN_BLOCK_SIZE * (win) + \
-						 (offset))
-#define OB_WIN_MATCH_LS(win)			OB_WIN_REG_ADDR(win, 0x00)
-#define OB_WIN_MATCH_MS(win)			OB_WIN_REG_ADDR(win, 0x04)
-#define OB_WIN_REMAP_LS(win)			OB_WIN_REG_ADDR(win, 0x08)
-#define OB_WIN_REMAP_MS(win)			OB_WIN_REG_ADDR(win, 0x0c)
-#define OB_WIN_MASK_LS(win)			OB_WIN_REG_ADDR(win, 0x10)
-#define OB_WIN_MASK_MS(win)			OB_WIN_REG_ADDR(win, 0x14)
-#define OB_WIN_ACTIONS(win)			OB_WIN_REG_ADDR(win, 0x18)
-
-/* PCIe window types */
-#define OB_PCIE_MEM				0x0
-#define OB_PCIE_IO				0x4
-
 /* LMI registers base address and register offsets */
 #define LMI_BASE_ADDR				0x6000
 #define CFG_REG					(LMI_BASE_ADDR + 0x0)
@@ -248,26 +230,6 @@ static int advk_pcie_wait_for_link(struct advk_pcie *pcie)
 	return -ETIMEDOUT;
 }
 
-/*
- * Set PCIe address window register which could be used for memory
- * mapping.
- */
-static void advk_pcie_set_ob_win(struct advk_pcie *pcie,
-				 u32 win_num, u32 match_ms,
-				 u32 match_ls, u32 mask_ms,
-				 u32 mask_ls, u32 remap_ms,
-				 u32 remap_ls, u32 action)
-{
-	advk_writel(pcie, match_ls, OB_WIN_MATCH_LS(win_num));
-	advk_writel(pcie, match_ms, OB_WIN_MATCH_MS(win_num));
-	advk_writel(pcie, mask_ms, OB_WIN_MASK_MS(win_num));
-	advk_writel(pcie, mask_ls, OB_WIN_MASK_LS(win_num));
-	advk_writel(pcie, remap_ms, OB_WIN_REMAP_MS(win_num));
-	advk_writel(pcie, remap_ls, OB_WIN_REMAP_LS(win_num));
-	advk_writel(pcie, action, OB_WIN_ACTIONS(win_num));
-	advk_writel(pcie, match_ls | BIT(0), OB_WIN_MATCH_LS(win_num));
-}
-
 static void advk_pcie_issue_perst(struct advk_pcie *pcie)
 {
 	u32 reg;
@@ -391,11 +353,6 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
-	int i;
-
-	/* Point PCIe unit MBUS decode windows to DRAM space */
-	for (i = 0; i < 8; i++)
-		advk_pcie_set_ob_win(pcie, i, 0, 0, 0, 0, 0, 0, 0);
 
 	/* Set to Direct mode */
 	reg = advk_readl(pcie, CTRL_CONFIG_REG);
@@ -1048,12 +1005,6 @@ static int advk_pcie_parse_request_of_pci_ranges(struct advk_pcie *pcie)
 
 		switch (resource_type(res)) {
 		case IORESOURCE_IO:
-			advk_pcie_set_ob_win(pcie, 1,
-					     upper_32_bits(res->start),
-					     lower_32_bits(res->start),
-					     0,	0xF8000000, 0,
-					     lower_32_bits(res->start),
-					     OB_PCIE_IO);
 			err = devm_pci_remap_iospace(dev, res, iobase);
 			if (err) {
 				dev_warn(dev, "error %d: failed to map resource %pR\n",
@@ -1062,12 +1013,6 @@ static int advk_pcie_parse_request_of_pci_ranges(struct advk_pcie *pcie)
 			}
 			break;
 		case IORESOURCE_MEM:
-			advk_pcie_set_ob_win(pcie, 0,
-					     upper_32_bits(res->start),
-					     lower_32_bits(res->start),
-					     0x0, 0xF8000000, 0,
-					     lower_32_bits(res->start),
-					     (2 << 20) | OB_PCIE_MEM);
 			res_valid |= !(res->flags & IORESOURCE_PREFETCH);
 			break;
 		case IORESOURCE_BUS:
-- 
2.32.0

