Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E2A469B57
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345902AbhLFPPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346409AbhLFPNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:13:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE188C08EAF7;
        Mon,  6 Dec 2021 07:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA566132E;
        Mon,  6 Dec 2021 15:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF0CC341C2;
        Mon,  6 Dec 2021 15:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803160;
        bh=x3zMfbuljULYDBpIGmbISV0EKKFYdb7wmRWQcXSTw+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIOYyJgzF4bde1LR9NQsTRVoC9rdfQnzPGC7xvAMTFJoNfPKX5geEkccosVKx0tZt
         COAMWH2poUTCFUPyrKehZKaAMRqNFOSS4gTKS9JpoY1hgMoRye1GHr53RAvyMcbi8G
         qzlkyxGehlAJoDN290D1KDkVu7JB6GUEb3FEK44o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH 4.14 050/106] PCI: aardvark: Fix checking for link up via LTSSM state
Date:   Mon,  6 Dec 2021 15:55:58 +0100
Message-Id: <20211206145557.157043898@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

commit 661c399a651c11aaf83c45cbfe0b4a1fb7bc3179 upstream.

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
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |   71 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 4 deletions(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -152,9 +152,50 @@
 #define CFG_REG					(LMI_BASE_ADDR + 0x0)
 #define     LTSSM_SHIFT				24
 #define     LTSSM_MASK				0x3f
-#define     LTSSM_L0				0x10
 #define     RC_BAR_CONFIG			0x300
 
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
 /* PCIe core controller registers */
 #define CTRL_CORE_BASE_ADDR			0x18000
 #define CTRL_CONFIG_REG				(CTRL_CORE_BASE_ADDR + 0x0)
@@ -248,13 +289,35 @@ static inline u32 advk_readl(struct advk
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
+	  * According to PCIe Base specification 3.0, Table 4-14: Link
+	  * Status Mapped to the LTSSM is Link Training mapped to LTSSM
+	  * Configuration and Recovery states.
+	  */
+	u8 ltssm_state = advk_pcie_ltssm_state(pcie);
+	return ((ltssm_state >= LTSSM_CONFIG_LINKWIDTH_START &&
+		  ltssm_state < LTSSM_L0) ||
+		(ltssm_state >= LTSSM_RECOVERY_EQUALIZATION_PHASE0 &&
+		  ltssm_state <= LTSSM_RECOVERY_EQUALIZATION_PHASE3));
 }
 
 static int advk_pcie_wait_for_link(struct advk_pcie *pcie)


