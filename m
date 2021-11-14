Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5696744F83B
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhKNNxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:53:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhKNNxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:53:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BCCB61077;
        Sun, 14 Nov 2021 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636897841;
        bh=XyE4yuvpKXcwqUhy0f28phlAqmKA7F3g7Hj7gZcOgVI=;
        h=Subject:To:Cc:From:Date:From;
        b=YMkC5GE+C4yqMmB8a7sTsPbimspUvyskYqRIqaQAsJmXbROkrhc8MeYfvHTtMZmEd
         1IganhICOGZtllnzS0mHCQnK0stEanD1ZvD1cquQCUNemhWlg82cCOzOBu/EYYRipT
         XTj921gIQ9GDtok77Z2JpLoNJpDGVpEFOgCaWICI=
Subject: FAILED: patch "[PATCH] PCI: aardvark: Fix checking for link up via LTSSM state" failed to apply to 4.14-stable tree
To:     pali@kernel.org, kabel@kernel.org, lorenzo.pieralisi@arm.com,
        repk@triplefau.lt
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 14:50:39 +0100
Message-ID: <163689783914134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 661c399a651c11aaf83c45cbfe0b4a1fb7bc3179 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Tue, 5 Oct 2021 20:09:51 +0200
Subject: [PATCH] PCI: aardvark: Fix checking for link up via LTSSM state
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Current implementation of advk_pcie_link_up() is wrong as it marks also
link disabled or hot reset states as link up.

Fix it by marking link up only to those states which are defined in PCIe
Base specification 3.0, Table 4-14: Link Status Mapped to the LTSSM.

To simplify implementation, Define macros for every LTSSM state which
aardvark hardware can return in CFG_REG register.

Fix also checking for link training according to the same Table 4-14.
Define a new function advk_pcie_link_training() for this purpose.

Link: https://lore.kernel.org/r/20211005180952.6812-13-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Cc: Remi Pommarel <repk@triplefau.lt>

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 2c66cdbb8dd6..f831f7d197bd 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -165,8 +165,50 @@
 #define CFG_REG					(LMI_BASE_ADDR + 0x0)
 #define     LTSSM_SHIFT				24
 #define     LTSSM_MASK				0x3f
-#define     LTSSM_L0				0x10
 #define     RC_BAR_CONFIG			0x300
+
+/* LTSSM values in CFG_REG */
+enum {
+	LTSSM_DETECT_QUIET			= 0x0,
+	LTSSM_DETECT_ACTIVE			= 0x1,
+	LTSSM_POLLING_ACTIVE			= 0x2,
+	LTSSM_POLLING_COMPLIANCE		= 0x3,
+	LTSSM_POLLING_CONFIGURATION		= 0x4,
+	LTSSM_CONFIG_LINKWIDTH_START		= 0x5,
+	LTSSM_CONFIG_LINKWIDTH_ACCEPT		= 0x6,
+	LTSSM_CONFIG_LANENUM_ACCEPT		= 0x7,
+	LTSSM_CONFIG_LANENUM_WAIT		= 0x8,
+	LTSSM_CONFIG_COMPLETE			= 0x9,
+	LTSSM_CONFIG_IDLE			= 0xa,
+	LTSSM_RECOVERY_RCVR_LOCK		= 0xb,
+	LTSSM_RECOVERY_SPEED			= 0xc,
+	LTSSM_RECOVERY_RCVR_CFG			= 0xd,
+	LTSSM_RECOVERY_IDLE			= 0xe,
+	LTSSM_L0				= 0x10,
+	LTSSM_RX_L0S_ENTRY			= 0x11,
+	LTSSM_RX_L0S_IDLE			= 0x12,
+	LTSSM_RX_L0S_FTS			= 0x13,
+	LTSSM_TX_L0S_ENTRY			= 0x14,
+	LTSSM_TX_L0S_IDLE			= 0x15,
+	LTSSM_TX_L0S_FTS			= 0x16,
+	LTSSM_L1_ENTRY				= 0x17,
+	LTSSM_L1_IDLE				= 0x18,
+	LTSSM_L2_IDLE				= 0x19,
+	LTSSM_L2_TRANSMIT_WAKE			= 0x1a,
+	LTSSM_DISABLED				= 0x20,
+	LTSSM_LOOPBACK_ENTRY_MASTER		= 0x21,
+	LTSSM_LOOPBACK_ACTIVE_MASTER		= 0x22,
+	LTSSM_LOOPBACK_EXIT_MASTER		= 0x23,
+	LTSSM_LOOPBACK_ENTRY_SLAVE		= 0x24,
+	LTSSM_LOOPBACK_ACTIVE_SLAVE		= 0x25,
+	LTSSM_LOOPBACK_EXIT_SLAVE		= 0x26,
+	LTSSM_HOT_RESET				= 0x27,
+	LTSSM_RECOVERY_EQUALIZATION_PHASE0	= 0x28,
+	LTSSM_RECOVERY_EQUALIZATION_PHASE1	= 0x29,
+	LTSSM_RECOVERY_EQUALIZATION_PHASE2	= 0x2a,
+	LTSSM_RECOVERY_EQUALIZATION_PHASE3	= 0x2b,
+};
+
 #define VENDOR_ID_REG				(LMI_BASE_ADDR + 0x44)
 
 /* PCIe core controller registers */
@@ -258,13 +300,35 @@ static inline u32 advk_readl(struct advk_pcie *pcie, u64 reg)
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
@@ -287,7 +351,7 @@ static void advk_pcie_wait_for_retrain(struct advk_pcie *pcie)
 	size_t retries;
 
 	for (retries = 0; retries < RETRAIN_WAIT_MAX_RETRIES; ++retries) {
-		if (!advk_pcie_link_up(pcie))
+		if (advk_pcie_link_training(pcie))
 			break;
 		udelay(RETRAIN_WAIT_USLEEP_US);
 	}
@@ -706,7 +770,7 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		/* u32 contains both PCI_EXP_LNKCTL and PCI_EXP_LNKSTA */
 		u32 val = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg) &
 			~(PCI_EXP_LNKSTA_LT << 16);
-		if (!advk_pcie_link_up(pcie))
+		if (advk_pcie_link_training(pcie))
 			val |= (PCI_EXP_LNKSTA_LT << 16);
 		*value = val;
 		return PCI_BRIDGE_EMUL_HANDLED;

