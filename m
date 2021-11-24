Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4477E45D068
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352199AbhKXWxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352220AbhKXWxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 469D66109D;
        Wed, 24 Nov 2021 22:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794198;
        bh=WqOr2e+1G6O5xvrRKN9cZ1xHjTUfDZNkwFKKdR0jvLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keyQu9+WuYXZ0fKVSYc2vdSPKfKV3u9U/rB5wcvPG4hWGNnacxsCpZ7ZnA4Va5d82
         4IQnYRnvorEzf3RYqQmTysvCI6t0FRjRNPcMxoC5cXlUgondszF2hx+lUhIesZsIzk
         IoJBFiCpSc3U5lKKVzDfxxACbwBKWxATI7K8JKj33adXVsudhOA9C0GSB7p6rL7Yme
         gWpzHOJ4IpZB2l7IUe7tPBacm3QSxxiGe3H2MowdFyWZLrxmQ9OQF3fPdon7CJw3Vb
         gaSB/R7srppP2CRLka0b+77KIaLB4zSNUbcPz/miBSXi25vjqblmizQE3Sx/yjpsO0
         R5RJHTEWupufA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 07/24] PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros
Date:   Wed, 24 Nov 2021 23:49:16 +0100
Message-Id: <20211124224933.24275-8-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
 drivers/pci/host/pci-aardvark.c | 42 +++++++++++++++------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 0cfec5660c69..3ad6b6245f94 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -29,17 +29,7 @@
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
@@ -229,6 +219,11 @@ static inline u32 advk_readl(struct advk_pcie *pcie, u64 reg)
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
@@ -301,16 +296,16 @@ static int advk_pcie_train_at_gen(struct advk_pcie *pcie, int gen)
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
@@ -400,13 +395,14 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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

