Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085B837C6B8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhELPxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhELPtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 769E061422;
        Wed, 12 May 2021 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833123;
        bh=Rd7/jkZaQPeU3MGkbzUL4jwXVTMMUEuAqfKekpuH5Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsQ2NcW2GK0i0pEL596mOYMV9ltAW60DRQx4h/r7oVv4sNWWaqFpu5ZukijRYe/ns
         bVJ8+JlPN2VKfsHDWnyeVmX5QCo3tjrLcuSC7dqqLP8oY99dwG9EkSItMjV/DayhV7
         j7fsKWju3KbDcK8a8oYs9JPgUwNYair33ccZGsoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.11 026/601] MIPS: pci-rt2880: fix slot 0 configuration
Date:   Wed, 12 May 2021 16:41:43 +0200
Message-Id: <20210512144828.679769153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

commit 8e98b697006d749d745d3b174168a877bb96c500 upstream.

pci_fixup_irqs() used to call pcibios_map_irq on every PCI device, which
for RT2880 included bus 0 slot 0. After pci_fixup_irqs() got removed,
only slots/funcs with devices attached would be called. While arguably
the right thing, that left no chance for this driver to ever initialize
slot 0, effectively bricking PCI and USB on RT2880 devices such as the
Belkin F5D8235-4 v1.

Slot 0 configuration needs to happen after PCI bus enumeration, but
before any device at slot 0x11 (func 0 or 1) is talked to. That was
determined empirically by testing on a Belkin F5D8235-4 v1 device. A
minimal BAR 0 config write followed by read, then setting slot 0
PCI_COMMAND to MASTER | IO | MEMORY is all that seems to be required for
proper functionality.

Tested by ensuring that full- and high-speed USB devices get enumerated
on the Belkin F5D8235-4 v1 (with an out of tree DTS file from OpenWrt).

Fixes: 04c81c7293df ("MIPS: PCI: Replace pci_fixup_irqs() call with host bridge IRQ mapping hooks")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Tobias Wolf <dev-NTEO@vplace.de>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/pci/pci-rt2880.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/arch/mips/pci/pci-rt2880.c
+++ b/arch/mips/pci/pci-rt2880.c
@@ -180,7 +180,6 @@ static inline void rt2880_pci_write_u32(
 
 int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	u16 cmd;
 	int irq = -1;
 
 	if (dev->bus->number != 0)
@@ -188,8 +187,6 @@ int pcibios_map_irq(const struct pci_dev
 
 	switch (PCI_SLOT(dev->devfn)) {
 	case 0x00:
-		rt2880_pci_write_u32(PCI_BASE_ADDRESS_0, 0x08000000);
-		(void) rt2880_pci_read_u32(PCI_BASE_ADDRESS_0);
 		break;
 	case 0x11:
 		irq = RT288X_CPU_IRQ_PCI;
@@ -201,16 +198,6 @@ int pcibios_map_irq(const struct pci_dev
 		break;
 	}
 
-	pci_write_config_byte((struct pci_dev *) dev,
-		PCI_CACHE_LINE_SIZE, 0x14);
-	pci_write_config_byte((struct pci_dev *) dev, PCI_LATENCY_TIMER, 0xFF);
-	pci_read_config_word((struct pci_dev *) dev, PCI_COMMAND, &cmd);
-	cmd |= PCI_COMMAND_MASTER | PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-		PCI_COMMAND_INVALIDATE | PCI_COMMAND_FAST_BACK |
-		PCI_COMMAND_SERR | PCI_COMMAND_WAIT | PCI_COMMAND_PARITY;
-	pci_write_config_word((struct pci_dev *) dev, PCI_COMMAND, cmd);
-	pci_write_config_byte((struct pci_dev *) dev, PCI_INTERRUPT_LINE,
-			      dev->irq);
 	return irq;
 }
 
@@ -251,6 +238,30 @@ static int rt288x_pci_probe(struct platf
 
 int pcibios_plat_dev_init(struct pci_dev *dev)
 {
+	static bool slot0_init;
+
+	/*
+	 * Nobody seems to initialize slot 0, but this platform requires it, so
+	 * do it once when some other slot is being enabled. The PCI subsystem
+	 * should configure other slots properly, so no need to do anything
+	 * special for those.
+	 */
+	if (!slot0_init && dev->bus->number == 0) {
+		u16 cmd;
+		u32 bar0;
+
+		slot0_init = true;
+
+		pci_bus_write_config_dword(dev->bus, 0, PCI_BASE_ADDRESS_0,
+					   0x08000000);
+		pci_bus_read_config_dword(dev->bus, 0, PCI_BASE_ADDRESS_0,
+					  &bar0);
+
+		pci_bus_read_config_word(dev->bus, 0, PCI_COMMAND, &cmd);
+		cmd |= PCI_COMMAND_MASTER | PCI_COMMAND_IO | PCI_COMMAND_MEMORY;
+		pci_bus_write_config_word(dev->bus, 0, PCI_COMMAND, cmd);
+	}
+
 	return 0;
 }
 


