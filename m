Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC201FE81F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgFRCqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbgFRBKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340CF221FA;
        Thu, 18 Jun 2020 01:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442644;
        bh=+M0W5qBbHTPjU1IEEobOMiZujG9hxISML1JRsZPtPdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vd2uZbKD2Ul2FKiwxWd9kVMVRRMFSqEDDPIakzR+makaXrgofbbgRDfD+goyngmcF
         TQXyzQYF8lsF/xKT3pANXNjeB8VrZw84W6Skx0a2K8iOWmfZ1QguS8gTEkJ5ERu7iv
         tdCahUV5W9ZRZUil2ALTAnjxooetfwPaEQG8h1Uw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 118/388] staging: mt7621-pci: fix PCIe interrupt mapping
Date:   Wed, 17 Jun 2020 21:03:35 -0400
Message-Id: <20200618010805.600873-118-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit fab6710e4c51f4eb622f95a08322ab5fdbe3f295 ]

MT7621 has three assigned interrupts for the pcie. This
interrupts should properly being mapped taking into account
which devices are finally connected in which bus according
to link status. So the irq mappings should be as follows
according to link status (three bits indicating which devices
are link up):

* For PCIe Bus 1 slot 0:
  - status = 0x2 || status = 0x6 => IRQ = pcie1_irq (24).
  - status = 0x4 => IRQ = pcie2_irq (25).
  - default => IRQ = pcie0_irq (23).
* For PCIe Bus 2 slot 0:
  - status = 0x5 || status = 0x6 => IRQ = pcie2_irq (25).
  - default => IRQ = pcie1_irq (24).
* For PCIe Bus 2 slot 1:
  - status = 0x5 || status = 0x6 => IRQ = pcie2_irq (25).
  - default => IRQ = pcie1_irq (24).
* For PCIe Bus 3 any slot:
  - default => IRQ = pcie2_irq (25).

Because of this, the function 'of_irq_parse_and_map_pci' cannot
be used and we need to change device tree information from using
the 'interrupt-map' and 'interrupt-map-mask' properties into an
'interrupts' property to be able to get irq information from the
ports using the 'platform_get_irq' and storing an 'irq-map' into
the pcie driver data node to properly map correct irq using a
new 'mt7621_map_irq' function where this map will be read and the
correct irq returned.

Fixes: 46d093124df4 ("staging: mt7621-pci: improve interrupt mapping")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20200413055942.2714-1-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-dts/mt7621.dtsi  |  9 +++----
 drivers/staging/mt7621-pci/pci-mt7621.c | 36 +++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index 9e5cf68731bb..82aa93634eda 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -523,11 +523,10 @@ pcie: pcie@1e140000 {
 			0x01000000 0 0x00000000 0x1e160000 0 0x00010000 /* io space */
 		>;
 
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0xF0000 0 0 1>;
-		interrupt-map = <0x10000 0 0 1 &gic GIC_SHARED 4 IRQ_TYPE_LEVEL_HIGH>,
-				<0x20000 0 0 1 &gic GIC_SHARED 24 IRQ_TYPE_LEVEL_HIGH>,
-				<0x30000 0 0 1 &gic GIC_SHARED 25 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SHARED 4 IRQ_TYPE_LEVEL_HIGH
+				GIC_SHARED 24 IRQ_TYPE_LEVEL_HIGH
+				GIC_SHARED 25 IRQ_TYPE_LEVEL_HIGH>;
 
 		status = "disabled";
 
diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index b9d460a9c041..36207243a71b 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -97,6 +97,7 @@
  * @pcie_rst: pointer to port reset control
  * @gpio_rst: gpio reset
  * @slot: port slot
+ * @irq: GIC irq
  * @enabled: indicates if port is enabled
  */
 struct mt7621_pcie_port {
@@ -107,6 +108,7 @@ struct mt7621_pcie_port {
 	struct reset_control *pcie_rst;
 	struct gpio_desc *gpio_rst;
 	u32 slot;
+	int irq;
 	bool enabled;
 };
 
@@ -120,6 +122,7 @@ struct mt7621_pcie_port {
  * @dev: Pointer to PCIe device
  * @io_map_base: virtual memory base address for io
  * @ports: pointer to PCIe port information
+ * @irq_map: irq mapping info according pcie link status
  * @resets_inverted: depends on chip revision
  * reset lines are inverted.
  */
@@ -135,6 +138,7 @@ struct mt7621_pcie {
 	} offset;
 	unsigned long io_map_base;
 	struct list_head ports;
+	int irq_map[PCIE_P2P_MAX];
 	bool resets_inverted;
 };
 
@@ -279,6 +283,16 @@ static void setup_cm_memory_region(struct mt7621_pcie *pcie)
 	}
 }
 
+static int mt7621_map_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
+{
+	struct mt7621_pcie *pcie = pdev->bus->sysdata;
+	struct device *dev = pcie->dev;
+	int irq = pcie->irq_map[slot];
+
+	dev_info(dev, "bus=%d slot=%d irq=%d\n", pdev->bus->number, slot, irq);
+	return irq;
+}
+
 static int mt7621_pci_parse_request_of_pci_ranges(struct mt7621_pcie *pcie)
 {
 	struct device *dev = pcie->dev;
@@ -330,6 +344,7 @@ static int mt7621_pcie_parse_port(struct mt7621_pcie *pcie,
 {
 	struct mt7621_pcie_port *port;
 	struct device *dev = pcie->dev;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct device_node *pnode = dev->of_node;
 	struct resource regs;
 	char name[10];
@@ -371,6 +386,12 @@ static int mt7621_pcie_parse_port(struct mt7621_pcie *pcie,
 	port->slot = slot;
 	port->pcie = pcie;
 
+	port->irq = platform_get_irq(pdev, slot);
+	if (port->irq < 0) {
+		dev_err(dev, "Failed to get IRQ for PCIe%d\n", slot);
+		return -ENXIO;
+	}
+
 	INIT_LIST_HEAD(&port->list);
 	list_add_tail(&port->list, &pcie->ports);
 
@@ -585,13 +606,15 @@ static int mt7621_pcie_init_virtual_bridges(struct mt7621_pcie *pcie)
 {
 	u32 pcie_link_status = 0;
 	u32 n;
-	int i;
+	int i = 0;
 	u32 p2p_br_devnum[PCIE_P2P_MAX];
+	int irqs[PCIE_P2P_MAX];
 	struct mt7621_pcie_port *port;
 
 	list_for_each_entry(port, &pcie->ports, list) {
 		u32 slot = port->slot;
 
+		irqs[i++] = port->irq;
 		if (port->enabled)
 			pcie_link_status |= BIT(slot);
 	}
@@ -614,6 +637,15 @@ static int mt7621_pcie_init_virtual_bridges(struct mt7621_pcie *pcie)
 		 (p2p_br_devnum[1] << PCIE_P2P_BR_DEVNUM1_SHIFT) |
 		 (p2p_br_devnum[2] << PCIE_P2P_BR_DEVNUM2_SHIFT));
 
+	/* Assign IRQs */
+	n = 0;
+	for (i = 0; i < PCIE_P2P_MAX; i++)
+		if (pcie_link_status & BIT(i))
+			pcie->irq_map[n++] = irqs[i];
+
+	for (i = n; i < PCIE_P2P_MAX; i++)
+		pcie->irq_map[i] = -1;
+
 	return 0;
 }
 
@@ -638,7 +670,7 @@ static int mt7621_pcie_register_host(struct pci_host_bridge *host,
 	host->busnr = pcie->busn.start;
 	host->dev.parent = pcie->dev;
 	host->ops = &mt7621_pci_ops;
-	host->map_irq = of_irq_parse_and_map_pci;
+	host->map_irq = mt7621_map_irq;
 	host->swizzle_irq = pci_common_swizzle;
 	host->sysdata = pcie;
 
-- 
2.25.1

