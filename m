Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF59417312
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344720AbhIXMx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344721AbhIXMwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2B7F6124C;
        Fri, 24 Sep 2021 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487778;
        bh=El6RrObEra+TgvnnROtLU9sKOQy/hyp6Ou5WZ2aQziA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07nr7V9tzfU7obUAj1OqaQycS/20sdLwI09YR4eMnYDknr/ymr0xYpf5yXUnG4942
         w3U7WI6W/zQHq/UbBvyZoRI1yLoOqxOLHwEzkqTEJgLuTmqrLLy7Bcr5EAs5U+JHhL
         Jby8xN3v2XFcB1QA1xxmkvuvpgvZ8Z4UJFMeHYkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Jaszczyk <jaz@semihalf.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 01/50] PCI: pci-bridge-emul: Fix big-endian support
Date:   Fri, 24 Sep 2021 14:43:50 +0200
Message-Id: <20210924124332.279325483@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Jaszczyk <jaz@semihalf.com>

commit e0d9d30b73548fbfe5c024ed630169bdc9a08aee upstream.

Perform conversion to little-endian before every write to configuration
space and convert it back to CPU endianness on reads.

Additionally, initialise every multiple byte field of config space with
the cpu_to_le* macro, which is required since the structure describing
config space of emulated bridge assumes little-endian convention.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |   25 +++++++------
 drivers/pci/pci-bridge-emul.h |   78 +++++++++++++++++++++---------------------
 2 files changed, 52 insertions(+), 51 deletions(-)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -270,10 +270,10 @@ static const struct pci_bridge_reg_behav
 int pci_bridge_emul_init(struct pci_bridge_emul *bridge,
 			 unsigned int flags)
 {
-	bridge->conf.class_revision |= PCI_CLASS_BRIDGE_PCI << 16;
+	bridge->conf.class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);
 	bridge->conf.header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->conf.cache_line_size = 0x10;
-	bridge->conf.status = PCI_STATUS_CAP_LIST;
+	bridge->conf.status = cpu_to_le16(PCI_STATUS_CAP_LIST);
 	bridge->pci_regs_behavior = kmemdup(pci_regs_behavior,
 					    sizeof(pci_regs_behavior),
 					    GFP_KERNEL);
@@ -284,8 +284,9 @@ int pci_bridge_emul_init(struct pci_brid
 		bridge->conf.capabilities_pointer = PCI_CAP_PCIE_START;
 		bridge->pcie_conf.cap_id = PCI_CAP_ID_EXP;
 		/* Set PCIe v2, root port, slot support */
-		bridge->pcie_conf.cap = PCI_EXP_TYPE_ROOT_PORT << 4 | 2 |
-			PCI_EXP_FLAGS_SLOT;
+		bridge->pcie_conf.cap =
+			cpu_to_le16(PCI_EXP_TYPE_ROOT_PORT << 4 | 2 |
+				    PCI_EXP_FLAGS_SLOT);
 		bridge->pcie_cap_regs_behavior =
 			kmemdup(pcie_cap_regs_behavior,
 				sizeof(pcie_cap_regs_behavior),
@@ -327,7 +328,7 @@ int pci_bridge_emul_conf_read(struct pci
 	int reg = where & ~3;
 	pci_bridge_emul_read_status_t (*read_op)(struct pci_bridge_emul *bridge,
 						 int reg, u32 *value);
-	u32 *cfgspace;
+	__le32 *cfgspace;
 	const struct pci_bridge_reg_behavior *behavior;
 
 	if (bridge->has_pcie && reg >= PCI_CAP_PCIE_END) {
@@ -343,11 +344,11 @@ int pci_bridge_emul_conf_read(struct pci
 	if (bridge->has_pcie && reg >= PCI_CAP_PCIE_START) {
 		reg -= PCI_CAP_PCIE_START;
 		read_op = bridge->ops->read_pcie;
-		cfgspace = (u32 *) &bridge->pcie_conf;
+		cfgspace = (__le32 *) &bridge->pcie_conf;
 		behavior = bridge->pcie_cap_regs_behavior;
 	} else {
 		read_op = bridge->ops->read_base;
-		cfgspace = (u32 *) &bridge->conf;
+		cfgspace = (__le32 *) &bridge->conf;
 		behavior = bridge->pci_regs_behavior;
 	}
 
@@ -357,7 +358,7 @@ int pci_bridge_emul_conf_read(struct pci
 		ret = PCI_BRIDGE_EMUL_NOT_HANDLED;
 
 	if (ret == PCI_BRIDGE_EMUL_NOT_HANDLED)
-		*value = cfgspace[reg / 4];
+		*value = le32_to_cpu(cfgspace[reg / 4]);
 
 	/*
 	 * Make sure we never return any reserved bit with a value
@@ -387,7 +388,7 @@ int pci_bridge_emul_conf_write(struct pc
 	int mask, ret, old, new, shift;
 	void (*write_op)(struct pci_bridge_emul *bridge, int reg,
 			 u32 old, u32 new, u32 mask);
-	u32 *cfgspace;
+	__le32 *cfgspace;
 	const struct pci_bridge_reg_behavior *behavior;
 
 	if (bridge->has_pcie && reg >= PCI_CAP_PCIE_END)
@@ -414,11 +415,11 @@ int pci_bridge_emul_conf_write(struct pc
 	if (bridge->has_pcie && reg >= PCI_CAP_PCIE_START) {
 		reg -= PCI_CAP_PCIE_START;
 		write_op = bridge->ops->write_pcie;
-		cfgspace = (u32 *) &bridge->pcie_conf;
+		cfgspace = (__le32 *) &bridge->pcie_conf;
 		behavior = bridge->pcie_cap_regs_behavior;
 	} else {
 		write_op = bridge->ops->write_base;
-		cfgspace = (u32 *) &bridge->conf;
+		cfgspace = (__le32 *) &bridge->conf;
 		behavior = bridge->pci_regs_behavior;
 	}
 
@@ -431,7 +432,7 @@ int pci_bridge_emul_conf_write(struct pc
 	/* Clear the W1C bits */
 	new &= ~((value << shift) & (behavior[reg / 4].w1c & mask));
 
-	cfgspace[reg / 4] = new;
+	cfgspace[reg / 4] = cpu_to_le32(new);
 
 	if (write_op)
 		write_op(bridge, reg, old, new, mask);
--- a/drivers/pci/pci-bridge-emul.h
+++ b/drivers/pci/pci-bridge-emul.h
@@ -6,65 +6,65 @@
 
 /* PCI configuration space of a PCI-to-PCI bridge. */
 struct pci_bridge_emul_conf {
-	u16 vendor;
-	u16 device;
-	u16 command;
-	u16 status;
-	u32 class_revision;
+	__le16 vendor;
+	__le16 device;
+	__le16 command;
+	__le16 status;
+	__le32 class_revision;
 	u8 cache_line_size;
 	u8 latency_timer;
 	u8 header_type;
 	u8 bist;
-	u32 bar[2];
+	__le32 bar[2];
 	u8 primary_bus;
 	u8 secondary_bus;
 	u8 subordinate_bus;
 	u8 secondary_latency_timer;
 	u8 iobase;
 	u8 iolimit;
-	u16 secondary_status;
-	u16 membase;
-	u16 memlimit;
-	u16 pref_mem_base;
-	u16 pref_mem_limit;
-	u32 prefbaseupper;
-	u32 preflimitupper;
-	u16 iobaseupper;
-	u16 iolimitupper;
+	__le16 secondary_status;
+	__le16 membase;
+	__le16 memlimit;
+	__le16 pref_mem_base;
+	__le16 pref_mem_limit;
+	__le32 prefbaseupper;
+	__le32 preflimitupper;
+	__le16 iobaseupper;
+	__le16 iolimitupper;
 	u8 capabilities_pointer;
 	u8 reserve[3];
-	u32 romaddr;
+	__le32 romaddr;
 	u8 intline;
 	u8 intpin;
-	u16 bridgectrl;
+	__le16 bridgectrl;
 };
 
 /* PCI configuration space of the PCIe capabilities */
 struct pci_bridge_emul_pcie_conf {
 	u8 cap_id;
 	u8 next;
-	u16 cap;
-	u32 devcap;
-	u16 devctl;
-	u16 devsta;
-	u32 lnkcap;
-	u16 lnkctl;
-	u16 lnksta;
-	u32 slotcap;
-	u16 slotctl;
-	u16 slotsta;
-	u16 rootctl;
-	u16 rsvd;
-	u32 rootsta;
-	u32 devcap2;
-	u16 devctl2;
-	u16 devsta2;
-	u32 lnkcap2;
-	u16 lnkctl2;
-	u16 lnksta2;
-	u32 slotcap2;
-	u16 slotctl2;
-	u16 slotsta2;
+	__le16 cap;
+	__le32 devcap;
+	__le16 devctl;
+	__le16 devsta;
+	__le32 lnkcap;
+	__le16 lnkctl;
+	__le16 lnksta;
+	__le32 slotcap;
+	__le16 slotctl;
+	__le16 slotsta;
+	__le16 rootctl;
+	__le16 rsvd;
+	__le32 rootsta;
+	__le32 devcap2;
+	__le16 devctl2;
+	__le16 devsta2;
+	__le32 lnkcap2;
+	__le16 lnkctl2;
+	__le16 lnksta2;
+	__le32 slotcap2;
+	__le16 slotctl2;
+	__le16 slotsta2;
 };
 
 struct pci_bridge_emul;


