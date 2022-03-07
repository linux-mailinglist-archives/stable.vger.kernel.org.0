Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41E54CF71D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiCGJok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240785AbiCGJle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1695C673F9;
        Mon,  7 Mar 2022 01:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DA561052;
        Mon,  7 Mar 2022 09:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B7FC340E9;
        Mon,  7 Mar 2022 09:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645893;
        bh=9/buMwFS7Y8UssTi4NtLWSigzMdyRLdbfYR//WrF/1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiq/QFS7TPFTr06dGSefvn835Ha9qAnbW34K8MvjlU1PgnVLhQxXnxwPOd2iI432X
         CNT5sAC5nW6z2mIDtxNNhN0oCPu2QWwq62iTNbk6AswVLOirm+A+ectRiBhI/edRDj
         aEqAmVgBt2XV7B2+l+md/Raz9Y5CevqsMyLvD9Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/262] PCI: mvebu: Fix configuring secondary bus of PCIe Root Port via emulated bridge
Date:   Mon,  7 Mar 2022 10:16:53 +0100
Message-Id: <20220307091704.448542471@linuxfoundation.org>
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

[ Upstream commit 91a8d79fc797d3486ae978beebdfc55261c7d65b ]

It looks like that mvebu PCIe controller has for each PCIe link fully
independent PCIe host bridge and so every PCIe Root Port is isolated not
only on its own bus but also isolated from each others. But in past device
tree structure was defined to put all PCIe Root Ports (as PCI Bridge
devices) into one root bus 0 and this bus is emulated by pci-mvebu.c
driver.

Probably reason for this decision was incorrect understanding of PCIe
topology of these Armada SoCs and also reason of misunderstanding how is
PCIe controller generating Type 0 and Type 1 config requests (it is fully
different compared to other drivers). Probably incorrect setup leaded to
very surprised things like having PCIe Root Port (PCI Bridge device, with
even incorrect Device Class set to Memory Controller) and the PCIe device
behind the Root Port on the same PCI bus, which obviously was needed to
somehow hack (as these two devices cannot be in reality on the same bus).

Properly set mvebu local bus number and mvebu local device number based on
PCI Bridge secondary bus number configuration. Also correctly report
configured secondary bus number in config space. And explain in driver
comment why this setup is correct.

Link: https://lore.kernel.org/r/20211125124605.25915-12-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 99 +++++++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 2e69455400288..76f35d0773b79 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -125,6 +125,11 @@ static bool mvebu_pcie_link_up(struct mvebu_pcie_port *port)
 	return !(mvebu_readl(port, PCIE_STAT_OFF) & PCIE_STAT_LINK_DOWN);
 }
 
+static u8 mvebu_pcie_get_local_bus_nr(struct mvebu_pcie_port *port)
+{
+	return (mvebu_readl(port, PCIE_STAT_OFF) & PCIE_STAT_BUS) >> 8;
+}
+
 static void mvebu_pcie_set_local_bus_nr(struct mvebu_pcie_port *port, int nr)
 {
 	u32 stat;
@@ -437,6 +442,20 @@ mvebu_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
 		*value = mvebu_readl(port, PCIE_CMD_OFF);
 		break;
 
+	case PCI_PRIMARY_BUS: {
+		/*
+		 * From the whole 32bit register we support reading from HW only
+		 * secondary bus number which is mvebu local bus number.
+		 * Other bits are retrieved only from emulated config buffer.
+		 */
+		__le32 *cfgspace = (__le32 *)&bridge->conf;
+		u32 val = le32_to_cpu(cfgspace[PCI_PRIMARY_BUS / 4]);
+		val &= ~0xff00;
+		val |= mvebu_pcie_get_local_bus_nr(port) << 8;
+		*value = val;
+		break;
+	}
+
 	default:
 		return PCI_BRIDGE_EMUL_NOT_HANDLED;
 	}
@@ -520,7 +539,8 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_PRIMARY_BUS:
-		mvebu_pcie_set_local_bus_nr(port, conf->secondary_bus);
+		if (mask & 0xff00)
+			mvebu_pcie_set_local_bus_nr(port, conf->secondary_bus);
 		break;
 
 	default:
@@ -1135,8 +1155,83 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		/*
+		 * PCIe topology exported by mvebu hw is quite complicated. In
+		 * reality has something like N fully independent host bridges
+		 * where each host bridge has one PCIe Root Port (which acts as
+		 * PCI Bridge device). Each host bridge has its own independent
+		 * internal registers, independent access to PCI config space,
+		 * independent interrupt lines, independent window and memory
+		 * access configuration. But additionally there is some kind of
+		 * peer-to-peer support between PCIe devices behind different
+		 * host bridges limited just to forwarding of memory and I/O
+		 * transactions (forwarding of error messages and config cycles
+		 * is not supported). So we could say there are N independent
+		 * PCIe Root Complexes.
+		 *
+		 * For this kind of setup DT should have been structured into
+		 * N independent PCIe controllers / host bridges. But instead
+		 * structure in past was defined to put PCIe Root Ports of all
+		 * host bridges into one bus zero, like in classic multi-port
+		 * Root Complex setup with just one host bridge.
+		 *
+		 * This means that pci-mvebu.c driver provides "virtual" bus 0
+		 * on which registers all PCIe Root Ports (PCI Bridge devices)
+		 * specified in DT by their BDF addresses and virtually routes
+		 * PCI config access of each PCI bridge device to specific PCIe
+		 * host bridge.
+		 *
+		 * Normally PCI Bridge should choose between Type 0 and Type 1
+		 * config requests based on primary and secondary bus numbers
+		 * configured on the bridge itself. But because mvebu PCI Bridge
+		 * does not have registers for primary and secondary bus numbers
+		 * in its config space, it determinates type of config requests
+		 * via its own custom way.
+		 *
+		 * There are two options how mvebu determinate type of config
+		 * request.
+		 *
+		 * 1. If Secondary Bus Number Enable bit is not set or is not
+		 * available (applies for pre-XP PCIe controllers) then Type 0
+		 * is used if target bus number equals Local Bus Number (bits
+		 * [15:8] in register 0x1a04) and target device number differs
+		 * from Local Device Number (bits [20:16] in register 0x1a04).
+		 * Type 1 is used if target bus number differs from Local Bus
+		 * Number. And when target bus number equals Local Bus Number
+		 * and target device equals Local Device Number then request is
+		 * routed to Local PCI Bridge (PCIe Root Port).
+		 *
+		 * 2. If Secondary Bus Number Enable bit is set (bit 7 in
+		 * register 0x1a2c) then mvebu hw determinate type of config
+		 * request like compliant PCI Bridge based on primary bus number
+		 * which is configured via Local Bus Number (bits [15:8] in
+		 * register 0x1a04) and secondary bus number which is configured
+		 * via Secondary Bus Number (bits [7:0] in register 0x1a2c).
+		 * Local PCI Bridge (PCIe Root Port) is available on primary bus
+		 * as device with Local Device Number (bits [20:16] in register
+		 * 0x1a04).
+		 *
+		 * Secondary Bus Number Enable bit is disabled by default and
+		 * option 2. is not available on pre-XP PCIe controllers. Hence
+		 * this driver always use option 1.
+		 *
+		 * Basically it means that primary and secondary buses shares
+		 * one virtual number configured via Local Bus Number bits and
+		 * Local Device Number bits determinates if accessing primary
+		 * or secondary bus. Set Local Device Number to 1 and redirect
+		 * all writes of PCI Bridge Secondary Bus Number register to
+		 * Local Bus Number (bits [15:8] in register 0x1a04).
+		 *
+		 * So when accessing devices on buses behind secondary bus
+		 * number it would work correctly. And also when accessing
+		 * device 0 at secondary bus number via config space would be
+		 * correctly routed to secondary bus. Due to issues described
+		 * in mvebu_pcie_setup_hw(), PCI Bridges at primary bus (zero)
+		 * are not accessed directly via PCI config space but rarher
+		 * indirectly via kernel emulated PCI bridge driver.
+		 */
 		mvebu_pcie_setup_hw(port);
-		mvebu_pcie_set_local_dev_nr(port, 1);
+		mvebu_pcie_set_local_dev_nr(port, 0);
 	}
 
 	pcie->nports = i;
-- 
2.34.1



