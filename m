Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12610499AAF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573178AbiAXVok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455133AbiAXVes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3365AB81142;
        Mon, 24 Jan 2022 21:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1D7C340E7;
        Mon, 24 Jan 2022 21:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060085;
        bh=Gj+/fEzo/MIrlAptBR6EwJeX40dJ6PyDWkKRNwcTaWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SegIXzSS2IAjx32mbozDlyz9LnoQL7p/2+YaRpssX1gAlUmAhZQVXp6bPxaiiKX65
         0Ly+lyHdm/wNKiXPKww92hdCcbk+jU6KuX+LwPzp34xa9dVDbuhV1/v7r8k4mFIWyD
         xKoAg7e0OR9Nf++iJXF13OSh09HZaQHXKLS8OymI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0801/1039] PCI: mvebu: Fix support for bus mastering and PCI_COMMAND on emulated bridge
Date:   Mon, 24 Jan 2022 19:43:10 +0100
Message-Id: <20220124184152.227183950@linuxfoundation.org>
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

[ Upstream commit e42b85583719adb87ab88dc7bcd41b38011f7d11 ]

According to PCI specifications bits [0:2] of Command Register, this should
be by default disabled on reset. So explicitly disable these bits at early
beginning of driver initialization.

Also remove code which unconditionally enables all 3 bits and let kernel
code (via pci_set_master() function) to handle bus mastering of PCI Bridge
via emulated PCI_COMMAND on emulated bridge.

Adjust existing functions mvebu_pcie_handle_iobase_change() and
mvebu_pcie_handle_membase_change() to handle PCI_IO_BASE and PCI_MEM_BASE
registers correctly even when bus mastering on emulated bridge is disabled.

Link: https://lore.kernel.org/r/20211125124605.25915-7-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 52 ++++++++++++++++++------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index beae555b06bbc..326527f2d6f41 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -215,16 +215,14 @@ static void mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
 {
 	u32 cmd, mask;
 
-	/* Point PCIe unit MBUS decode windows to DRAM space. */
-	mvebu_pcie_setup_wins(port);
-
-	/* Master + slave enable. */
+	/* Disable Root Bridge I/O space, memory space and bus mastering. */
 	cmd = mvebu_readl(port, PCIE_CMD_OFF);
-	cmd |= PCI_COMMAND_IO;
-	cmd |= PCI_COMMAND_MEMORY;
-	cmd |= PCI_COMMAND_MASTER;
+	cmd &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
 	mvebu_writel(port, cmd, PCIE_CMD_OFF);
 
+	/* Point PCIe unit MBUS decode windows to DRAM space. */
+	mvebu_pcie_setup_wins(port);
+
 	/* Enable interrupt lines A-D. */
 	mask = mvebu_readl(port, PCIE_MASK_OFF);
 	mask |= PCIE_MASK_ENABLE_INTS;
@@ -371,8 +369,7 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 
 	/* Are the new iobase/iolimit values invalid? */
 	if (conf->iolimit < conf->iobase ||
-	    conf->iolimitupper < conf->iobaseupper ||
-	    !(conf->command & PCI_COMMAND_IO)) {
+	    conf->iolimitupper < conf->iobaseupper) {
 		mvebu_pcie_set_window(port, port->io_target, port->io_attr,
 				      &desired, &port->iowin);
 		return;
@@ -409,8 +406,7 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 	struct pci_bridge_emul_conf *conf = &port->bridge.conf;
 
 	/* Are the new membase/memlimit values invalid? */
-	if (conf->memlimit < conf->membase ||
-	    !(conf->command & PCI_COMMAND_MEMORY)) {
+	if (conf->memlimit < conf->membase) {
 		mvebu_pcie_set_window(port, port->mem_target, port->mem_attr,
 				      &desired, &port->memwin);
 		return;
@@ -430,6 +426,24 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 			      &port->memwin);
 }
 
+static pci_bridge_emul_read_status_t
+mvebu_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
+				     int reg, u32 *value)
+{
+	struct mvebu_pcie_port *port = bridge->data;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		*value = mvebu_readl(port, PCIE_CMD_OFF);
+		break;
+
+	default:
+		return PCI_BRIDGE_EMUL_NOT_HANDLED;
+	}
+
+	return PCI_BRIDGE_EMUL_HANDLED;
+}
+
 static pci_bridge_emul_read_status_t
 mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 				     int reg, u32 *value)
@@ -484,17 +498,14 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 
 	switch (reg) {
 	case PCI_COMMAND:
-	{
-		if (!mvebu_has_ioport(port))
-			conf->command &= ~PCI_COMMAND_IO;
-
-		if ((old ^ new) & PCI_COMMAND_IO)
-			mvebu_pcie_handle_iobase_change(port);
-		if ((old ^ new) & PCI_COMMAND_MEMORY)
-			mvebu_pcie_handle_membase_change(port);
+		if (!mvebu_has_ioport(port)) {
+			conf->command = cpu_to_le16(
+				le16_to_cpu(conf->command) & ~PCI_COMMAND_IO);
+			new &= ~PCI_COMMAND_IO;
+		}
 
+		mvebu_writel(port, new, PCIE_CMD_OFF);
 		break;
-	}
 
 	case PCI_IO_BASE:
 		mvebu_pcie_handle_iobase_change(port);
@@ -554,6 +565,7 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 }
 
 static struct pci_bridge_emul_ops mvebu_pci_bridge_emul_ops = {
+	.read_base = mvebu_pci_bridge_emul_base_conf_read,
 	.write_base = mvebu_pci_bridge_emul_base_conf_write,
 	.read_pcie = mvebu_pci_bridge_emul_pcie_conf_read,
 	.write_pcie = mvebu_pci_bridge_emul_pcie_conf_write,
-- 
2.34.1



