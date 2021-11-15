Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B56B4526FD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbhKPCO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236956AbhKORso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:48:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796B56331D;
        Mon, 15 Nov 2021 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997428;
        bh=IZR7cgCtUPBX1voHkqKq/vgyCP2712nXTXKX4Wp3xP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifBcIaXYf6/oWgheRLHLPzXGfFmn2E4nY9fy+pDiBKfeUm/LmIgGr9svrMl6L2Rz+
         huULHQ5NV6sAgd6+aXBNaV2uIIGZmsU1Q86177AQ3kC8pQKIb7K4cbnPOiVupjZ/YI
         ilO2+DiGn34c3ToFBjeZl5E4sAF2TltlJi6m1jTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.10 143/575] PCI: aardvark: Fix reporting Data Link Layer Link Active
Date:   Mon, 15 Nov 2021 17:57:48 +0100
Message-Id: <20211115165348.633226587@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 2b650b7ff20eb7ea8ef9031d20fb657286ab90cc upstream.

Add support for reporting PCI_EXP_LNKSTA_DLLLA bit in Link Control register
on emulated bridge via current LTSSM state. Also correctly indicate DLLLA
capability via PCI_EXP_LNKCAP_DLLLARC bit in Link Control Capability
register.

Link: https://lore.kernel.org/r/20211005180952.6812-14-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -328,6 +328,20 @@ static inline bool advk_pcie_link_up(str
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
@@ -798,12 +812,26 @@ advk_pci_bridge_emul_pcie_conf_read(stru
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
@@ -811,7 +839,6 @@ advk_pci_bridge_emul_pcie_conf_read(stru
 	case PCI_CAP_LIST_ID:
 	case PCI_EXP_DEVCAP:
 	case PCI_EXP_DEVCTL:
-	case PCI_EXP_LNKCAP:
 		*value = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
 		return PCI_BRIDGE_EMUL_HANDLED;
 	default:


