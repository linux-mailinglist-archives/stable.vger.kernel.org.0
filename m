Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E841B41F611
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354530AbhJAUBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353785AbhJAUBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 16:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E8A161AE3;
        Fri,  1 Oct 2021 19:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633118359;
        bh=AnT/bHMnHpA5tXsWpeRaU9QFeJWGS+qPnC/eUU5Lnbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zwb5R7TzXWoTycZHQWO4BN6V4jLRb9Z/dWEJLZQafBZtIPtRwCGsCzbuvYj0Si9p+
         cI/e6wMpFMGZfYE5dB2VycQgqDdgNy5pYHte6ChOIIEGdk684SG+se+E6M6ih/rokW
         GaCdikArwnXoLARuaN7bS48ynoXX4u9NdDuc/6hnF883DWiQ0nwnl1/oXkGVupGVUv
         2nz0cZnQvt7BRsyfGbNLHkG2PCNlWl4h0bpPdzuOA5b6jPKy5zQD1u9zhq2lW5RGEn
         iCM0Tpr18aH/2ynJ9rHrj/Vo5NmB5AVJ7Pr4JfakNfzWQe3To6CIr6AfcaFf5igbW4
         NmmqHiuw3anVg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Remi Pommarel <repk@triplefau.lt>, stable@vger.kernel.org
Subject: [PATCH 12/13] PCI: aardvark: Fix checking for link up via LTSSM state
Date:   Fri,  1 Oct 2021 21:58:55 +0200
Message-Id: <20211001195856.10081-13-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211001195856.10081-1-kabel@kernel.org>
References: <20211001195856.10081-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

Current implementation of advk_pcie_link_up() is wrong as it marks also
link disabled or hot reset states as link up.

Fix it by marking link up only to those states which are defined in PCIe
Base specification 3.0, Table 4-14: Link Status Mapped to the LTSSM.

To simplify implementation, Define macros for every LTSSM state which
aardvark hardware can return in CFG_REG register.

Fix also checking for link training according to the same Table 4-14.
Define a new function advk_pcie_link_training() for this purpose.

Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Remi Pommarel <repk@triplefau.lt>
Cc: stable@vger.kernel.org
---
 drivers/pci/controller/pci-aardvark.c | 69 +++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 5387d9cc3eba..9465b630cede 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -165,7 +165,44 @@
 #define CFG_REG					(LMI_BASE_ADDR + 0x0)
 #define     LTSSM_SHIFT				24
 #define     LTSSM_MASK				0x3f
+#define     LTSSM_DETECT_QUIET			0x0
+#define     LTSSM_DETECT_ACTIVE			0x1
+#define     LTSSM_POLLING_ACTIVE		0x2
+#define     LTSSM_POLLING_COMPLIANCE		0x3
+#define     LTSSM_POLLING_CONFIGURATION		0x4
+#define     LTSSM_CONFIG_LINKWIDTH_START	0x5
+#define     LTSSM_CONFIG_LINKWIDTH_ACCEPT	0x6
+#define     LTSSM_CONFIG_LANENUM_ACCEPT		0x7
+#define     LTSSM_CONFIG_LANENUM_WAIT		0x8
+#define     LTSSM_CONFIG_COMPLETE		0x9
+#define     LTSSM_CONFIG_IDLE			0xa
+#define     LTSSM_RECOVERY_RCVR_LOCK		0xb
+#define     LTSSM_RECOVERY_SPEED		0xc
+#define     LTSSM_RECOVERY_RCVR_CFG		0xd
+#define     LTSSM_RECOVERY_IDLE			0xe
 #define     LTSSM_L0				0x10
+#define     LTSSM_RX_L0S_ENTRY			0x11
+#define     LTSSM_RX_L0S_IDLE			0x12
+#define     LTSSM_RX_L0S_FTS			0x13
+#define     LTSSM_TX_L0S_ENTRY			0x14
+#define     LTSSM_TX_L0S_IDLE			0x15
+#define     LTSSM_TX_L0S_FTS			0x16
+#define     LTSSM_L1_ENTRY			0x17
+#define     LTSSM_L1_IDLE			0x18
+#define     LTSSM_L2_IDLE			0x19
+#define     LTSSM_L2_TRANSMIT_WAKE		0x1a
+#define     LTSSM_DISABLED			0x20
+#define     LTSSM_LOOPBACK_ENTRY_MASTER		0x21
+#define     LTSSM_LOOPBACK_ACTIVE_MASTER	0x22
+#define     LTSSM_LOOPBACK_EXIT_MASTER		0x23
+#define     LTSSM_LOOPBACK_ENTRY_SLAVE		0x24
+#define     LTSSM_LOOPBACK_ACTIVE_SLAVE		0x25
+#define     LTSSM_LOOPBACK_EXIT_SLAVE		0x26
+#define     LTSSM_HOT_RESET			0x27
+#define     LTSSM_RECOVERY_EQUALIZATION_PHASE0	0x28
+#define     LTSSM_RECOVERY_EQUALIZATION_PHASE1	0x29
+#define     LTSSM_RECOVERY_EQUALIZATION_PHASE2	0x2a
+#define     LTSSM_RECOVERY_EQUALIZATION_PHASE3	0x2b
 #define     RC_BAR_CONFIG			0x300
 #define VENDOR_ID_REG				(LMI_BASE_ADDR + 0x44)
 
@@ -258,13 +295,35 @@ static inline u32 advk_readl(struct advk_pcie *pcie, u64 reg)
 	return readl(pcie->base + reg);
 }
 
-static int advk_pcie_link_up(struct advk_pcie *pcie)
+static u8 advk_pcie_ltssm_state(struct advk_pcie *pcie)
 {
-	u32 val, ltssm_state;
+	u32 val;
+	u8 ltssm_state;
 
 	val = advk_readl(pcie, CFG_REG);
 	ltssm_state = (val >> LTSSM_SHIFT) & LTSSM_MASK;
-	return ltssm_state >= LTSSM_L0;
+	return ltssm_state;
+}
+
+static inline bool advk_pcie_link_up(struct advk_pcie *pcie)
+{
+	/* check if LTSSM is in normal operation - some L* state */
+	u8 ltssm_state = advk_pcie_ltssm_state(pcie);
+	return ltssm_state >= LTSSM_L0 && ltssm_state < LTSSM_DISABLED;
+}
+
+static inline bool advk_pcie_link_training(struct advk_pcie *pcie)
+{
+	/*
+	 * According to PCIe Base specification 3.0, Table 4-14: Link
+	 * Status Mapped to the LTSSM is Link Training mapped to LTSSM
+	 * Configuration and Recovery states.
+	 */
+	u8 ltssm_state = advk_pcie_ltssm_state(pcie);
+	return ((ltssm_state >= LTSSM_CONFIG_LINKWIDTH_START &&
+		 ltssm_state < LTSSM_L0) ||
+		(ltssm_state >= LTSSM_RECOVERY_EQUALIZATION_PHASE0 &&
+		 ltssm_state <= LTSSM_RECOVERY_EQUALIZATION_PHASE3));
 }
 
 static int advk_pcie_wait_for_link(struct advk_pcie *pcie)
@@ -287,7 +346,7 @@ static void advk_pcie_wait_for_retrain(struct advk_pcie *pcie)
 	size_t retries;
 
 	for (retries = 0; retries < RETRAIN_WAIT_MAX_RETRIES; ++retries) {
-		if (!advk_pcie_link_up(pcie))
+		if (advk_pcie_link_training(pcie))
 			break;
 		udelay(RETRAIN_WAIT_USLEEP_US);
 	}
@@ -706,7 +765,7 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		/* u32 contains both PCI_EXP_LNKCTL and PCI_EXP_LNKSTA */
 		u32 val = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg) &
 			~(PCI_EXP_LNKSTA_LT << 16);
-		if (!advk_pcie_link_up(pcie))
+		if (advk_pcie_link_training(pcie))
 			val |= (PCI_EXP_LNKSTA_LT << 16);
 		*value = val;
 		return PCI_BRIDGE_EMUL_HANDLED;
-- 
2.32.0

