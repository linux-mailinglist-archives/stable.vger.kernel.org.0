Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54D461D88
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351538AbhK2S0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:26:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58474 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344521AbhK2SYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:24:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FE97B815BE;
        Mon, 29 Nov 2021 18:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84EAC53FC7;
        Mon, 29 Nov 2021 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210042;
        bh=v1pKXicVWu4IWYc2sBsUb7cp29jef7YcG0oney47T0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/qJ9KLkEwf22/upLgv0Bu8TUJJh5J35FWqVzIWSztpf/InGk2tPGs4kli9CNpfC2
         QXKZxjBGbFomQRpL+QZ5MXn5rBfTN3TZOecXNVFiEbkMp3vU8Gu0bmIezKwRs/xX+m
         PId97eRox4nxOp7CXACGaIJ70BgX040qxHfrQCs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 22/69] PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros
Date:   Mon, 29 Nov 2021 19:18:04 +0100
Message-Id: <20211129181704.390847960@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 96be36dbffacea0aa9e6ec4839583e79faa141a1 upstream.

PCI-E capability macros are already defined in linux/pci_regs.h.
Remove their reimplementation in pcie-aardvark.

Link: https://lore.kernel.org/r/20200430080625.26070-9-pali@kernel.org
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   42 +++++++++++++++-------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -28,17 +28,7 @@
 #define     PCIE_CORE_CMD_IO_ACCESS_EN				BIT(0)
 #define     PCIE_CORE_CMD_MEM_ACCESS_EN				BIT(1)
 #define     PCIE_CORE_CMD_MEM_IO_REQ_EN				BIT(2)
-#define PCIE_CORE_DEV_CTRL_STATS_REG				0xc8
-#define     PCIE_CORE_DEV_CTRL_STATS_RELAX_ORDER_DISABLE	(0 << 4)
-#define     PCIE_CORE_DEV_CTRL_STATS_MAX_PAYLOAD_SZ_SHIFT	5
-#define     PCIE_CORE_DEV_CTRL_STATS_SNOOP_DISABLE		(0 << 11)
-#define     PCIE_CORE_DEV_CTRL_STATS_MAX_RD_REQ_SIZE_SHIFT	12
-#define     PCIE_CORE_DEV_CTRL_STATS_MAX_RD_REQ_SZ		0x2
-#define PCIE_CORE_LINK_CTRL_STAT_REG				0xd0
-#define     PCIE_CORE_LINK_L0S_ENTRY				BIT(0)
-#define     PCIE_CORE_LINK_TRAINING				BIT(5)
-#define     PCIE_CORE_LINK_SPEED_SHIFT				16
-#define     PCIE_CORE_LINK_WIDTH_SHIFT				20
+#define PCIE_CORE_PCIEXP_CAP					0xc0
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX_EN			BIT(6)
@@ -210,6 +200,11 @@ static inline u32 advk_readl(struct advk
 	return readl(pcie->base + reg);
 }
 
+static inline u16 advk_read16(struct advk_pcie *pcie, u64 reg)
+{
+	return advk_readl(pcie, (reg & ~0x3)) >> ((reg & 0x3) * 8);
+}
+
 static int advk_pcie_link_up(struct advk_pcie *pcie)
 {
 	u32 val, ltssm_state;
@@ -262,16 +257,16 @@ static int advk_pcie_train_at_gen(struct
 	 * Start link training immediately after enabling it.
 	 * This solves problems for some buggy cards.
 	 */
-	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
-	reg |= PCIE_CORE_LINK_TRAINING;
-	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
+	reg = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_LNKCTL);
+	reg |= PCI_EXP_LNKCTL_RL;
+	advk_writel(pcie, reg, PCIE_CORE_PCIEXP_CAP + PCI_EXP_LNKCTL);
 
 	ret = advk_pcie_wait_for_link(pcie);
 	if (ret)
 		return ret;
 
-	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
-	neg_gen = (reg >> PCIE_CORE_LINK_SPEED_SHIFT) & 0xf;
+	reg = advk_read16(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_LNKSTA);
+	neg_gen = reg & PCI_EXP_LNKSTA_CLS;
 
 	return neg_gen;
 }
@@ -356,13 +351,14 @@ static void advk_pcie_setup_hw(struct ad
 		PCIE_CORE_ERR_CAPCTL_ECRC_CHCK_RCV;
 	advk_writel(pcie, reg, PCIE_CORE_ERR_CAPCTL_REG);
 
-	/* Set PCIe Device Control and Status 1 PF0 register */
-	reg = PCIE_CORE_DEV_CTRL_STATS_RELAX_ORDER_DISABLE |
-		(7 << PCIE_CORE_DEV_CTRL_STATS_MAX_PAYLOAD_SZ_SHIFT) |
-		PCIE_CORE_DEV_CTRL_STATS_SNOOP_DISABLE |
-		(PCIE_CORE_DEV_CTRL_STATS_MAX_RD_REQ_SZ <<
-		 PCIE_CORE_DEV_CTRL_STATS_MAX_RD_REQ_SIZE_SHIFT);
-	advk_writel(pcie, reg, PCIE_CORE_DEV_CTRL_STATS_REG);
+	/* Set PCIe Device Control register */
+	reg = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
+	reg &= ~PCI_EXP_DEVCTL_RELAX_EN;
+	reg &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
+	reg &= ~PCI_EXP_DEVCTL_READRQ;
+	reg |= PCI_EXP_DEVCTL_PAYLOAD; /* Set max payload size */
+	reg |= PCI_EXP_DEVCTL_READRQ_512B;
+	advk_writel(pcie, reg, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 
 	/* Program PCIe Control 2 to disable strict ordering */
 	reg = PCIE_CORE_CTRL2_RESERVED |


