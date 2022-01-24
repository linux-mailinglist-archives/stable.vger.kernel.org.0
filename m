Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6E498F35
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbiAXTvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348618AbiAXThn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 229FBB81142;
        Mon, 24 Jan 2022 19:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48681C340E5;
        Mon, 24 Jan 2022 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053058;
        bh=4ZpRgW4Bcsrip4PUdaaioMGM1mw8+zX2JCcZ9hwNATU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/3oiWqqZsasGCurFi6nMFcEcsgoR1onGCPjIGl2R0P41bkVwakii9O51CYHl8Jam
         keJm8fH0Ail9xYVipzS64SN6LR7iZ9lFKWRsw5ogXImFwkLD+tihii3HKFOjIpESC8
         z9tQgZ81fCVqHOL5AV8Dq2N5SctRKJsIUKtjCwFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 262/320] PCI: pci-bridge-emul: Correctly set PCIe capabilities
Date:   Mon, 24 Jan 2022 19:44:06 +0100
Message-Id: <20220124184002.900020903@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -863,7 +863,6 @@ advk_pci_bridge_emul_pcie_conf_read(stru
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
-	case PCI_CAP_LIST_ID:
 	case PCI_EXP_DEVCAP:
 	case PCI_EXP_DEVCTL:
 		*value = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
@@ -944,6 +943,9 @@ static int advk_sw_pci_bridge_init(struc
 	/* Support interrupt A for MSI feature */
 	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
 
+	/* Aardvark HW provides PCIe Capability structure in version 2 */
+	bridge->pcie_conf.cap = cpu_to_le16(2);
+
 	/* Indicates supports for Completion Retry Status */
 	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
 
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -576,6 +576,8 @@ struct pci_bridge_emul_ops mvebu_pci_bri
 static void mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 {
 	struct pci_bridge_emul *bridge = &port->bridge;
+	u32 pcie_cap = mvebu_readl(port, PCIE_CAP_PCIEXP);
+	u8 pcie_cap_ver = ((pcie_cap >> 16) & PCI_EXP_FLAGS_VERS);
 
 	bridge->conf.vendor = PCI_VENDOR_ID_MARVELL;
 	bridge->conf.device = mvebu_readl(port, PCIE_DEV_ID_OFF) >> 16;
@@ -588,6 +590,12 @@ static void mvebu_pci_bridge_emul_init(s
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
@@ -288,10 +288,7 @@ int pci_bridge_emul_init(struct pci_brid
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


