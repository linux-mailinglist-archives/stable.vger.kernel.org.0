Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253DE3DD8BC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbhHBNzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235265AbhHBNww (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:52:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A195760551;
        Mon,  2 Aug 2021 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912300;
        bh=j34rqbkjDUG74k2x7CXphuk7DnB+5Qwigbx4HerbAuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doxdH0FmxhMMoE245gQSvq7v5wsT4Zc38pRj8nap8RKCAlWO9eXK+2YRuahhWNKPd
         SgZN0AsI6rT/naX8e/ZHiDKcmH/azVKsgKOZ6vty9GRdXNh9Kj11H17h8PincBVklU
         oyMINp19Oy74L4GUuBuIyaAfK0BZXLfNe9j7Om3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shmuel Hazan <sh@tkos.co.il>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 5.4 36/40] PCI: mvebu: Setup BAR0 in order to fix MSI
Date:   Mon,  2 Aug 2021 15:45:16 +0200
Message-Id: <20210802134336.542092671@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmuel Hazan <sh@tkos.co.il>

commit 216f8e95aacc8e9690d8e2286c472671b65f4128 upstream.

According to the Armada XP datasheet, section 10.2.6: "in order for
the device to do a write to the MSI doorbell address, it needs to write
to a register in the internal registers space".

As a result of the requirement above, without this patch, MSI won't
function and therefore some devices won't operate properly without
pci=nomsi.

This requirement was not present at the time of writing this driver
since the vendor u-boot always initializes all PCIe controllers
(incl. BAR0 initialization) and for some time, the vendor u-boot was
the only available bootloader for this driver's SoCs (e.g. A38x,A37x,
etc).

Tested on an Armada 385 board on mainline u-boot (2020.4), without
u-boot PCI initialization and the following PCIe devices:
        - Wilocity Wil6200 rev 2 (wil6210)
        - Qualcomm Atheros QCA6174 (ath10k_pci)

Both failed to get a response from the device after loading the
firmware and seem to operate properly with this patch.

Link: https://lore.kernel.org/r/20200623060334.108444-1-sh@tkos.co.il
Signed-off-by: Shmuel Hazan <sh@tkos.co.il>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-mvebu.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -105,6 +105,7 @@ struct mvebu_pcie_port {
 	struct mvebu_pcie_window memwin;
 	struct mvebu_pcie_window iowin;
 	u32 saved_pcie_stat;
+	struct resource regs;
 };
 
 static inline void mvebu_writel(struct mvebu_pcie_port *port, u32 val, u32 reg)
@@ -149,7 +150,9 @@ static void mvebu_pcie_set_local_dev_nr(
 
 /*
  * Setup PCIE BARs and Address Decode Wins:
- * BAR[0,2] -> disabled, BAR[1] -> covers all DRAM banks
+ * BAR[0] -> internal registers (needed for MSI)
+ * BAR[1] -> covers all DRAM banks
+ * BAR[2] -> Disabled
  * WIN[0-3] -> DRAM bank[0-3]
  */
 static void mvebu_pcie_setup_wins(struct mvebu_pcie_port *port)
@@ -203,6 +206,12 @@ static void mvebu_pcie_setup_wins(struct
 	mvebu_writel(port, 0, PCIE_BAR_HI_OFF(1));
 	mvebu_writel(port, ((size - 1) & 0xffff0000) | 1,
 		     PCIE_BAR_CTRL_OFF(1));
+
+	/*
+	 * Point BAR[0] to the device's internal registers.
+	 */
+	mvebu_writel(port, round_down(port->regs.start, SZ_1M), PCIE_BAR_LO_OFF(0));
+	mvebu_writel(port, 0, PCIE_BAR_HI_OFF(0));
 }
 
 static void mvebu_pcie_setup_hw(struct mvebu_pcie_port *port)
@@ -708,14 +717,13 @@ static void __iomem *mvebu_pcie_map_regi
 					      struct device_node *np,
 					      struct mvebu_pcie_port *port)
 {
-	struct resource regs;
 	int ret = 0;
 
-	ret = of_address_to_resource(np, 0, &regs);
+	ret = of_address_to_resource(np, 0, &port->regs);
 	if (ret)
 		return ERR_PTR(ret);
 
-	return devm_ioremap_resource(&pdev->dev, &regs);
+	return devm_ioremap_resource(&pdev->dev, &port->regs);
 }
 
 #define DT_FLAGS_TO_TYPE(flags)       (((flags) >> 24) & 0x03)


