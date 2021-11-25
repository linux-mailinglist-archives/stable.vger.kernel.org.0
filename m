Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8345D20F
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhKYAeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346176AbhKYAbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:31:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80575610A1;
        Thu, 25 Nov 2021 00:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637799992;
        bh=h5mcdSaPpfkFPx5zU2b0phRjk1OsFPcyKFHCCe4YYLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCvzj0bY3LCkOkL72RCK0oRiDouxVqEKApMZ95Ag8SU5ZtL0YNNIMV6B1lje2zQ2A
         DExKYXhhT50BzVxavzncpR8LgIciJ2eRBaZvPwAta9HHOzmgSp8L9JWOJSyT/4Cluc
         WFeXY7+Q21L/CfA0IF7KSy84PFAJCv7/toUPUetqADw2fahLMRLFkAHLFYhwzVj7Oq
         /gDdhpxk5xq1nnQCej7+ZMfS9ivuQ/F3LyE7xaAMjppW5oyvaj+MPjYUxWLBspw206
         yAwVDelnYGpH8rLID5t69VgGPnKmOdDGB8NUZUBXBzwmaXQ2cH39XE6LQ1DWe/ioH2
         uqOTYwfaywkNg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 06/22] PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros
Date:   Thu, 25 Nov 2021 01:26:00 +0100
Message-Id: <20211125002616.31363-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
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
---
 drivers/pci/controller/pci-aardvark.c | 41 ++++++++++++---------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index f65bb9b26ac3..ca2d6b5534c9 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -32,17 +32,6 @@
 #define     PCIE_CORE_CMD_MEM_IO_REQ_EN				BIT(2)
 #define PCIE_CORE_DEV_REV_REG					0x8
 #define PCIE_CORE_PCIEXP_CAP					0xc0
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
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX_EN			BIT(6)
@@ -267,6 +256,11 @@ static inline u32 advk_readl(struct advk_pcie *pcie, u64 reg)
 	return readl(pcie->base + reg);
 }
 
+static inline u16 advk_read16(struct advk_pcie *pcie, u64 reg)
+{
+	return advk_readl(pcie, (reg & ~0x3)) >> ((reg & 0x3) * 8);
+}
+
 static u8 advk_pcie_ltssm_state(struct advk_pcie *pcie)
 {
 	u32 val;
@@ -366,16 +360,16 @@ static int advk_pcie_train_at_gen(struct advk_pcie *pcie, int gen)
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
@@ -470,13 +464,14 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
-- 
2.32.0

