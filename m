Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BE7499A8D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573508AbiAXVpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55362 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455976AbiAXVhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C41446150B;
        Mon, 24 Jan 2022 21:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56F0C340E7;
        Mon, 24 Jan 2022 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060220;
        bh=SyNYiTwXVXJKE4VV1grcVx6e6PGFPM/ywr0MEph9OnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBIqVi630kWP5W+JtB3jZwclUEdpMKl3sw2PXSlmeUU7A1II3WFNMN1gY+DcZsZb8
         HMGWraIqhvBbfEzH8iCLOSESyxuB3gznUhgsZ2+nJd8MO8pPo5oTcflcR1B0RSHMzE
         6EWbo/1JmYtCcBTABrEFT2pWDsYh7lU5o1D/ba9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.16 0878/1039] PCI: pci-bridge-emul: Correctly set PCIe capabilities
Date:   Mon, 24 Jan 2022 19:44:27 +0100
Message-Id: <20220124184154.814356084@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1f1050c5e1fefb34ac90a506b43e9da803b5f8f7 upstream.

Older mvebu hardware provides PCIe Capability structure only in version 1.
New mvebu and aardvark hardware provides it in version 2. So do not force
version to 2 in pci_bridge_emul_init() and rather allow drivers to set
correct version. Drivers need to set version in pcie_conf.cap field without
overwriting PCI_CAP_LIST_ID register. Both drivers (mvebu and aardvark) do
not provide slot support yet, so do not set PCI_EXP_FLAGS_SLOT flag.

Link: https://lore.kernel.org/r/20211124155944.1290-6-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    4 +++-
 drivers/pci/controller/pci-mvebu.c    |    8 ++++++++
 drivers/pci/pci-bridge-emul.c         |    5 +----
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -872,7 +872,6 @@ advk_pci_bridge_emul_pcie_conf_read(stru
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
-	case PCI_CAP_LIST_ID:
 	case PCI_EXP_DEVCAP:
 	case PCI_EXP_DEVCTL:
 		*value = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
@@ -953,6 +952,9 @@ static int advk_sw_pci_bridge_init(struc
 	/* Support interrupt A for MSI feature */
 	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
 
+	/* Aardvark HW provides PCIe Capability structure in version 2 */
+	bridge->pcie_conf.cap = cpu_to_le16(2);
+
 	/* Indicates supports for Completion Retry Status */
 	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
 
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -655,6 +655,8 @@ static struct pci_bridge_emul_ops mvebu_
 static int mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 {
 	struct pci_bridge_emul *bridge = &port->bridge;
+	u32 pcie_cap = mvebu_readl(port, PCIE_CAP_PCIEXP);
+	u8 pcie_cap_ver = ((pcie_cap >> 16) & PCI_EXP_FLAGS_VERS);
 
 	bridge->conf.vendor = PCI_VENDOR_ID_MARVELL;
 	bridge->conf.device = mvebu_readl(port, PCIE_DEV_ID_OFF) >> 16;
@@ -667,6 +669,12 @@ static int mvebu_pci_bridge_emul_init(st
 		bridge->conf.iolimit = PCI_IO_RANGE_TYPE_32;
 	}
 
+	/*
+	 * Older mvebu hardware provides PCIe Capability structure only in
+	 * version 1. New hardware provides it in version 2.
+	 */
+	bridge->pcie_conf.cap = cpu_to_le16(pcie_cap_ver);
+
 	bridge->has_pcie = true;
 	bridge->data = port;
 	bridge->ops = &mvebu_pci_bridge_emul_ops;
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -297,10 +297,7 @@ int pci_bridge_emul_init(struct pci_brid
 	if (bridge->has_pcie) {
 		bridge->conf.capabilities_pointer = PCI_CAP_PCIE_START;
 		bridge->pcie_conf.cap_id = PCI_CAP_ID_EXP;
-		/* Set PCIe v2, root port, slot support */
-		bridge->pcie_conf.cap =
-			cpu_to_le16(PCI_EXP_TYPE_ROOT_PORT << 4 | 2 |
-				    PCI_EXP_FLAGS_SLOT);
+		bridge->pcie_conf.cap |= cpu_to_le16(PCI_EXP_TYPE_ROOT_PORT << 4);
 		bridge->pcie_cap_regs_behavior =
 			kmemdup(pcie_cap_regs_behavior,
 				sizeof(pcie_cap_regs_behavior),


