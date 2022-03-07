Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45F4CF774
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiCGJqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiCGJle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183936A066;
        Mon,  7 Mar 2022 01:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B970E611D5;
        Mon,  7 Mar 2022 09:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B0AC340E9;
        Mon,  7 Mar 2022 09:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645890;
        bh=8H1O5Gd8aWDSuSOPM7T7kVZcc3Rbn5AoTu7LfcSiU3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw4BipxD8M6uPRSqIwxZfgwOrgamlXOhCdYSK9y53hX6ONHgLZcZEfS6QeC1eXTbL
         u4k503wwAzqVrnqcYhUBlPzPP6ui1dBX2IF7h15gyVEDvyMzcAcAT6K3aYX1GAFFUZ
         hjFyXEA+hnXThWYqb9xyDrCbYBu2Gkp7/S38QXhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/262] PCI: mvebu: Fix support for bus mastering and PCI_COMMAND on emulated bridge
Date:   Mon,  7 Mar 2022 10:16:52 +0100
Message-Id: <20220307091704.421592444@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 5d5f23b1d355b..2e69455400288 100644
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



