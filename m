Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E47D41F615
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 21:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242085AbhJAUBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354579AbhJAUBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 16:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4442461ACF;
        Fri,  1 Oct 2021 19:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633118361;
        bh=kX5tAlOqeyECvhAjEkYqDcJ8a2WjedAJRyZ2DXvs5G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5nTu1s4r4P0I09Y0ZTnhoD1YULhUEpWxhVEweFVeyYoep3WkFUvwybw0G9Hlmb5+
         qnB+nr4invW/AV1asT9zAb/xlQc6HWpX7brD0JoycrnQt7C00v0OEdKRGUdtSRBRYC
         dvr/pkBFMRUJWi9nyBVDUvtcqPldyzgMuY3ZsIfELm7+noL4moXpyYpxsICQSxDl+i
         7kqJPin+MqBHlZF9xOTdRqbgTL0eO5xk66OUaFwJQ4VOECNdC9OvV3nQUyRJj61ZX4
         7UmKPzjQhM4dD/UW3yrqrXDk4k73wKGxrLV7KwVH4vJ+4B5KstaeJit764L6lKB8bn
         nzO1dY/4CG9nA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 13/13] PCI: aardvark: Fix reporting Data Link Layer Link Active
Date:   Fri,  1 Oct 2021 21:58:56 +0200
Message-Id: <20211001195856.10081-14-kabel@kernel.org>
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

Add support for reporting PCI_EXP_LNKSTA_DLLLA bit in Link Control register
on emulated bridge via current LTSSM state. Also correctly indicate DLLLA
capability via PCI_EXP_LNKCAP_DLLLARC bit in Link Control Capability
register.

Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/controller/pci-aardvark.c | 29 ++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 9465b630cede..f429c89ba4a1 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -312,6 +312,20 @@ static inline bool advk_pcie_link_up(struct advk_pcie *pcie)
 	return ltssm_state >= LTSSM_L0 && ltssm_state < LTSSM_DISABLED;
 }
 
+static inline bool advk_pcie_link_active(struct advk_pcie *pcie)
+{
+	/*
+	 * According to PCIe Base specification 3.0, Table 4-14: Link
+	 * Status Mapped to the LTSSM, and 4.2.6.3.6 Configuration.Idle
+	 * is Link Up mapped to LTSSM Configuration.Idle, Recovery, L0,
+	 * L0s, L1 and L2 states. And according to 3.2.1. Data Link
+	 * Control and Management State Machine Rules is DL Up status
+	 * reported in DL Active state.
+	 */
+	u8 ltssm_state = advk_pcie_ltssm_state(pcie);
+	return ltssm_state >= LTSSM_CONFIG_IDLE && ltssm_state < LTSSM_DISABLED;
+}
+
 static inline bool advk_pcie_link_training(struct advk_pcie *pcie)
 {
 	/*
@@ -761,12 +775,26 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
+	case PCI_EXP_LNKCAP: {
+		u32 val = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
+		/*
+		 * PCI_EXP_LNKCAP_DLLLARC bit is hardwired in aardvark HW to 0.
+		 * But support for PCI_EXP_LNKSTA_DLLLA is emulated via ltssm
+		 * state so explicitly enable PCI_EXP_LNKCAP_DLLLARC flag.
+		 */
+		val |= PCI_EXP_LNKCAP_DLLLARC;
+		*value = val;
+		return PCI_BRIDGE_EMUL_HANDLED;
+	}
+
 	case PCI_EXP_LNKCTL: {
 		/* u32 contains both PCI_EXP_LNKCTL and PCI_EXP_LNKSTA */
 		u32 val = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg) &
 			~(PCI_EXP_LNKSTA_LT << 16);
 		if (advk_pcie_link_training(pcie))
 			val |= (PCI_EXP_LNKSTA_LT << 16);
+		if (advk_pcie_link_active(pcie))
+			val |= (PCI_EXP_LNKSTA_DLLLA << 16);
 		*value = val;
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
@@ -774,7 +802,6 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 	case PCI_CAP_LIST_ID:
 	case PCI_EXP_DEVCAP:
 	case PCI_EXP_DEVCTL:
-	case PCI_EXP_LNKCAP:
 		*value = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
 		return PCI_BRIDGE_EMUL_HANDLED;
 	default:
-- 
2.32.0

