Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9F469B0F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345798AbhLFPMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:12:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42130 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353194AbhLFPKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:10:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90ABFB8111C;
        Mon,  6 Dec 2021 15:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9653C341C2;
        Mon,  6 Dec 2021 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803236;
        bh=zgixiv1fbTmJSTkPrAa/v9Je8jGM81zKUkUUGjw6b1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXcok+wR2tmJByCfvdX3y4b7AYStqDc/BePt7nWu7a4RWm9Hdiw5Lc2gYz2m4cMJ2
         2iRwIjPXBNiZ9IAFQg6VrDZwmdJehi+fYDt/W4jRKlkrvtBohebCLGNWT1ygoj14m+
         5IlS/+uUYi7MfUmxdJQP9yTHHOlOAR/dyGpq7b/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Wang <xswang@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Victor Gu <xigu@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 045/106] PCI: aardvark: Remove PCIe outbound window configuration
Date:   Mon,  6 Dec 2021 15:55:53 +0100
Message-Id: <20211206145556.955099663@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |   55 ----------------------------------------
 1 file changed, 55 deletions(-)

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
@@ -248,26 +230,6 @@ static int advk_pcie_wait_for_link(struc
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
@@ -391,11 +353,6 @@ err:
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
@@ -1048,12 +1005,6 @@ static int advk_pcie_parse_request_of_pc
 
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
@@ -1062,12 +1013,6 @@ static int advk_pcie_parse_request_of_pc
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


