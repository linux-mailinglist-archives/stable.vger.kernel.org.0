Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA7210BD6C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbfK0U6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfK0U6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 552AE20862;
        Wed, 27 Nov 2019 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888292;
        bh=nyKkzBi6H7Uh8OTeR56ZnuDUxLI1jcTiVleAkU5JdKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7piuzW7C3Zf7qYQ3Zo5HCAn8nLNgB8LEJEbg1pCMHK1TJrjjB0oXFPVUHgtk6h5P
         RJR2/qFGAqVuNZeRWKpebe3Y/K0yeN8dwlNGXgol03rNRSdkEoPq1hv8fQPZrUJGVk
         hUwjmPepdAVNnriqjzsluwsaOREfAf5HVNOcrm20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Honghui Zhang <honghui.zhang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/306] PCI: mediatek: Fixup MSI enablement logic by enabling MSI before clocks
Date:   Wed, 27 Nov 2019 21:28:48 +0100
Message-Id: <20191127203120.582753149@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Honghui Zhang <honghui.zhang@mediatek.com>

[ Upstream commit 3828d60fd2ef99f97a677c1f95af2ab3e65e2576 ]

Commit 43e6409db64d ("PCI: mediatek: Add MSI support for MT2712 and
MT7622") added MSI support but enabled MSI in the wrong place, at a step
in the probe sequence where clocks were not still enabled.

Fix this issue by calling mtk_pcie_enable_msi() in mtk_pcie_startup_port_v2()
since clocks are enabled when mtk_pcie_startup_port_v2() is called.

To avoid forward declaration of mtk_pcie_enable_msi(), move the
mtk_pcie_startup_port_v2() function definition in the file.

Fixes: 43e6409db64d ("PCI: mediatek: Add MSI support for MT2712 and MT7622")
Signed-off-by: Honghui Zhang <honghui.zhang@mediatek.com>
[lorenzo.pieralisi@arm.com: squashed commit and adapted log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 143 +++++++++++++------------
 1 file changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 8d1364c317747..1bfbceb9f4458 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -394,75 +394,6 @@ static struct pci_ops mtk_pcie_ops_v2 = {
 	.write = mtk_pcie_config_write,
 };
 
-static int mtk_pcie_startup_port_v2(struct mtk_pcie_port *port)
-{
-	struct mtk_pcie *pcie = port->pcie;
-	struct resource *mem = &pcie->mem;
-	const struct mtk_pcie_soc *soc = port->pcie->soc;
-	u32 val;
-	size_t size;
-	int err;
-
-	/* MT7622 platforms need to enable LTSSM and ASPM from PCIe subsys */
-	if (pcie->base) {
-		val = readl(pcie->base + PCIE_SYS_CFG_V2);
-		val |= PCIE_CSR_LTSSM_EN(port->slot) |
-		       PCIE_CSR_ASPM_L1_EN(port->slot);
-		writel(val, pcie->base + PCIE_SYS_CFG_V2);
-	}
-
-	/* Assert all reset signals */
-	writel(0, port->base + PCIE_RST_CTRL);
-
-	/*
-	 * Enable PCIe link down reset, if link status changed from link up to
-	 * link down, this will reset MAC control registers and configuration
-	 * space.
-	 */
-	writel(PCIE_LINKDOWN_RST_EN, port->base + PCIE_RST_CTRL);
-
-	/* De-assert PHY, PE, PIPE, MAC and configuration reset	*/
-	val = readl(port->base + PCIE_RST_CTRL);
-	val |= PCIE_PHY_RSTB | PCIE_PERSTB | PCIE_PIPE_SRSTB |
-	       PCIE_MAC_SRSTB | PCIE_CRSTB;
-	writel(val, port->base + PCIE_RST_CTRL);
-
-	/* Set up vendor ID and class code */
-	if (soc->need_fix_class_id) {
-		val = PCI_VENDOR_ID_MEDIATEK;
-		writew(val, port->base + PCIE_CONF_VEND_ID);
-
-		val = PCI_CLASS_BRIDGE_PCI;
-		writew(val, port->base + PCIE_CONF_CLASS_ID);
-	}
-
-	/* 100ms timeout value should be enough for Gen1/2 training */
-	err = readl_poll_timeout(port->base + PCIE_LINK_STATUS_V2, val,
-				 !!(val & PCIE_PORT_LINKUP_V2), 20,
-				 100 * USEC_PER_MSEC);
-	if (err)
-		return -ETIMEDOUT;
-
-	/* Set INTx mask */
-	val = readl(port->base + PCIE_INT_MASK);
-	val &= ~INTX_MASK;
-	writel(val, port->base + PCIE_INT_MASK);
-
-	/* Set AHB to PCIe translation windows */
-	size = mem->end - mem->start;
-	val = lower_32_bits(mem->start) | AHB2PCIE_SIZE(fls(size));
-	writel(val, port->base + PCIE_AHB_TRANS_BASE0_L);
-
-	val = upper_32_bits(mem->start);
-	writel(val, port->base + PCIE_AHB_TRANS_BASE0_H);
-
-	/* Set PCIe to AXI translation memory space.*/
-	val = fls(0xffffffff) | WIN_ENABLE;
-	writel(val, port->base + PCIE_AXI_WINDOW0);
-
-	return 0;
-}
-
 static void mtk_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	struct mtk_pcie_port *port = irq_data_get_irq_chip_data(data);
@@ -639,8 +570,6 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 		ret = mtk_pcie_allocate_msi_domains(port);
 		if (ret)
 			return ret;
-
-		mtk_pcie_enable_msi(port);
 	}
 
 	return 0;
@@ -707,6 +636,78 @@ static int mtk_pcie_setup_irq(struct mtk_pcie_port *port,
 	return 0;
 }
 
+static int mtk_pcie_startup_port_v2(struct mtk_pcie_port *port)
+{
+	struct mtk_pcie *pcie = port->pcie;
+	struct resource *mem = &pcie->mem;
+	const struct mtk_pcie_soc *soc = port->pcie->soc;
+	u32 val;
+	size_t size;
+	int err;
+
+	/* MT7622 platforms need to enable LTSSM and ASPM from PCIe subsys */
+	if (pcie->base) {
+		val = readl(pcie->base + PCIE_SYS_CFG_V2);
+		val |= PCIE_CSR_LTSSM_EN(port->slot) |
+		       PCIE_CSR_ASPM_L1_EN(port->slot);
+		writel(val, pcie->base + PCIE_SYS_CFG_V2);
+	}
+
+	/* Assert all reset signals */
+	writel(0, port->base + PCIE_RST_CTRL);
+
+	/*
+	 * Enable PCIe link down reset, if link status changed from link up to
+	 * link down, this will reset MAC control registers and configuration
+	 * space.
+	 */
+	writel(PCIE_LINKDOWN_RST_EN, port->base + PCIE_RST_CTRL);
+
+	/* De-assert PHY, PE, PIPE, MAC and configuration reset	*/
+	val = readl(port->base + PCIE_RST_CTRL);
+	val |= PCIE_PHY_RSTB | PCIE_PERSTB | PCIE_PIPE_SRSTB |
+	       PCIE_MAC_SRSTB | PCIE_CRSTB;
+	writel(val, port->base + PCIE_RST_CTRL);
+
+	/* Set up vendor ID and class code */
+	if (soc->need_fix_class_id) {
+		val = PCI_VENDOR_ID_MEDIATEK;
+		writew(val, port->base + PCIE_CONF_VEND_ID);
+
+		val = PCI_CLASS_BRIDGE_PCI;
+		writew(val, port->base + PCIE_CONF_CLASS_ID);
+	}
+
+	/* 100ms timeout value should be enough for Gen1/2 training */
+	err = readl_poll_timeout(port->base + PCIE_LINK_STATUS_V2, val,
+				 !!(val & PCIE_PORT_LINKUP_V2), 20,
+				 100 * USEC_PER_MSEC);
+	if (err)
+		return -ETIMEDOUT;
+
+	/* Set INTx mask */
+	val = readl(port->base + PCIE_INT_MASK);
+	val &= ~INTX_MASK;
+	writel(val, port->base + PCIE_INT_MASK);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		mtk_pcie_enable_msi(port);
+
+	/* Set AHB to PCIe translation windows */
+	size = mem->end - mem->start;
+	val = lower_32_bits(mem->start) | AHB2PCIE_SIZE(fls(size));
+	writel(val, port->base + PCIE_AHB_TRANS_BASE0_L);
+
+	val = upper_32_bits(mem->start);
+	writel(val, port->base + PCIE_AHB_TRANS_BASE0_H);
+
+	/* Set PCIe to AXI translation memory space.*/
+	val = fls(0xffffffff) | WIN_ENABLE;
+	writel(val, port->base + PCIE_AXI_WINDOW0);
+
+	return 0;
+}
+
 static void __iomem *mtk_pcie_map_bus(struct pci_bus *bus,
 				      unsigned int devfn, int where)
 {
-- 
2.20.1



