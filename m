Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5D147B1B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgAXJkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbgAXJkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:53 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F052070A;
        Fri, 24 Jan 2020 09:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858852;
        bh=fpY12Lb8/uYEbyDI/+r1P0YaZpo/v1IHuJbuIh3KUMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwy7YFqAheo1q9PKDyUailWyefmV1S6sbJ4jsaAxtTvPhUI2sAR00KscL354KLCrt
         vHkKQLcB3GPMlja2XeeILYoDaj216/ULFvCA6CAPep2uB69EDYTJ6RgaNfDTbLShbI
         mIU+PyC+w1JyMvtIWGmhdXwD6kM67ZilHd22wKAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/102] PCI: mobiveil: Fix csr_read()/write() build issue
Date:   Fri, 24 Jan 2020 10:30:59 +0100
Message-Id: <20200124092815.102113818@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 4906c05b87d44c19b225935e24d62e4480ca556d ]

RISCV has csr_read()/write() macros in arch/riscv/include/asm/csr.h.

The same function naming is used in the PCI mobiveil driver thus
causing build error.

Rename csr_[read,write][l,] to mobiveil_csr_read()/write() to fix it.

drivers/pci/controller/pcie-mobiveil.c:238:69: error: macro "csr_read" passed 3 arguments, but takes just 1
 static u32 csr_read(struct mobiveil_pcie *pcie, u32 off, size_t size)

drivers/pci/controller/pcie-mobiveil.c:253:80: error: macro "csr_write" passed 4 arguments, but takes just 2
 static void csr_write(struct mobiveil_pcie *pcie, u32 val, u32 off, size_t size)

Fixes: bcbe0d9a8d93 ("PCI: mobiveil: Unify register accessors")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Cc: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Minghuan Lian <Minghuan.Lian@nxp.com>
Cc: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Cc: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 119 +++++++++++++------------
 1 file changed, 62 insertions(+), 57 deletions(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index a45a6447b01d9..32f37d08d5bc7 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -235,7 +235,7 @@ static int mobiveil_pcie_write(void __iomem *addr, int size, u32 val)
 	return PCIBIOS_SUCCESSFUL;
 }
 
-static u32 csr_read(struct mobiveil_pcie *pcie, u32 off, size_t size)
+static u32 mobiveil_csr_read(struct mobiveil_pcie *pcie, u32 off, size_t size)
 {
 	void *addr;
 	u32 val;
@@ -250,7 +250,8 @@ static u32 csr_read(struct mobiveil_pcie *pcie, u32 off, size_t size)
 	return val;
 }
 
-static void csr_write(struct mobiveil_pcie *pcie, u32 val, u32 off, size_t size)
+static void mobiveil_csr_write(struct mobiveil_pcie *pcie, u32 val, u32 off,
+			       size_t size)
 {
 	void *addr;
 	int ret;
@@ -262,19 +263,19 @@ static void csr_write(struct mobiveil_pcie *pcie, u32 val, u32 off, size_t size)
 		dev_err(&pcie->pdev->dev, "write CSR address failed\n");
 }
 
-static u32 csr_readl(struct mobiveil_pcie *pcie, u32 off)
+static u32 mobiveil_csr_readl(struct mobiveil_pcie *pcie, u32 off)
 {
-	return csr_read(pcie, off, 0x4);
+	return mobiveil_csr_read(pcie, off, 0x4);
 }
 
-static void csr_writel(struct mobiveil_pcie *pcie, u32 val, u32 off)
+static void mobiveil_csr_writel(struct mobiveil_pcie *pcie, u32 val, u32 off)
 {
-	csr_write(pcie, val, off, 0x4);
+	mobiveil_csr_write(pcie, val, off, 0x4);
 }
 
 static bool mobiveil_pcie_link_up(struct mobiveil_pcie *pcie)
 {
-	return (csr_readl(pcie, LTSSM_STATUS) &
+	return (mobiveil_csr_readl(pcie, LTSSM_STATUS) &
 		LTSSM_STATUS_L0_MASK) == LTSSM_STATUS_L0;
 }
 
@@ -323,7 +324,7 @@ static void __iomem *mobiveil_pcie_map_bus(struct pci_bus *bus,
 		PCI_SLOT(devfn) << PAB_DEVICE_SHIFT |
 		PCI_FUNC(devfn) << PAB_FUNCTION_SHIFT;
 
-	csr_writel(pcie, value, PAB_AXI_AMAP_PEX_WIN_L(WIN_NUM_0));
+	mobiveil_csr_writel(pcie, value, PAB_AXI_AMAP_PEX_WIN_L(WIN_NUM_0));
 
 	return pcie->config_axi_slave_base + where;
 }
@@ -353,13 +354,14 @@ static void mobiveil_pcie_isr(struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 
 	/* read INTx status */
-	val = csr_readl(pcie, PAB_INTP_AMBA_MISC_STAT);
-	mask = csr_readl(pcie, PAB_INTP_AMBA_MISC_ENB);
+	val = mobiveil_csr_readl(pcie, PAB_INTP_AMBA_MISC_STAT);
+	mask = mobiveil_csr_readl(pcie, PAB_INTP_AMBA_MISC_ENB);
 	intr_status = val & mask;
 
 	/* Handle INTx */
 	if (intr_status & PAB_INTP_INTX_MASK) {
-		shifted_status = csr_readl(pcie, PAB_INTP_AMBA_MISC_STAT);
+		shifted_status = mobiveil_csr_readl(pcie,
+						    PAB_INTP_AMBA_MISC_STAT);
 		shifted_status &= PAB_INTP_INTX_MASK;
 		shifted_status >>= PAB_INTX_START;
 		do {
@@ -373,12 +375,13 @@ static void mobiveil_pcie_isr(struct irq_desc *desc)
 							    bit);
 
 				/* clear interrupt handled */
-				csr_writel(pcie, 1 << (PAB_INTX_START + bit),
-					   PAB_INTP_AMBA_MISC_STAT);
+				mobiveil_csr_writel(pcie,
+						    1 << (PAB_INTX_START + bit),
+						    PAB_INTP_AMBA_MISC_STAT);
 			}
 
-			shifted_status = csr_readl(pcie,
-						   PAB_INTP_AMBA_MISC_STAT);
+			shifted_status = mobiveil_csr_readl(pcie,
+							    PAB_INTP_AMBA_MISC_STAT);
 			shifted_status &= PAB_INTP_INTX_MASK;
 			shifted_status >>= PAB_INTX_START;
 		} while (shifted_status != 0);
@@ -413,7 +416,7 @@ static void mobiveil_pcie_isr(struct irq_desc *desc)
 	}
 
 	/* Clear the interrupt status */
-	csr_writel(pcie, intr_status, PAB_INTP_AMBA_MISC_STAT);
+	mobiveil_csr_writel(pcie, intr_status, PAB_INTP_AMBA_MISC_STAT);
 	chained_irq_exit(chip, desc);
 }
 
@@ -474,24 +477,24 @@ static void program_ib_windows(struct mobiveil_pcie *pcie, int win_num,
 		return;
 	}
 
-	value = csr_readl(pcie, PAB_PEX_AMAP_CTRL(win_num));
+	value = mobiveil_csr_readl(pcie, PAB_PEX_AMAP_CTRL(win_num));
 	value &= ~(AMAP_CTRL_TYPE_MASK << AMAP_CTRL_TYPE_SHIFT | WIN_SIZE_MASK);
 	value |= type << AMAP_CTRL_TYPE_SHIFT | 1 << AMAP_CTRL_EN_SHIFT |
 		 (lower_32_bits(size64) & WIN_SIZE_MASK);
-	csr_writel(pcie, value, PAB_PEX_AMAP_CTRL(win_num));
+	mobiveil_csr_writel(pcie, value, PAB_PEX_AMAP_CTRL(win_num));
 
-	csr_writel(pcie, upper_32_bits(size64),
-		   PAB_EXT_PEX_AMAP_SIZEN(win_num));
+	mobiveil_csr_writel(pcie, upper_32_bits(size64),
+			    PAB_EXT_PEX_AMAP_SIZEN(win_num));
 
-	csr_writel(pcie, lower_32_bits(cpu_addr),
-		   PAB_PEX_AMAP_AXI_WIN(win_num));
-	csr_writel(pcie, upper_32_bits(cpu_addr),
-		   PAB_EXT_PEX_AMAP_AXI_WIN(win_num));
+	mobiveil_csr_writel(pcie, lower_32_bits(cpu_addr),
+			    PAB_PEX_AMAP_AXI_WIN(win_num));
+	mobiveil_csr_writel(pcie, upper_32_bits(cpu_addr),
+			    PAB_EXT_PEX_AMAP_AXI_WIN(win_num));
 
-	csr_writel(pcie, lower_32_bits(pci_addr),
-		   PAB_PEX_AMAP_PEX_WIN_L(win_num));
-	csr_writel(pcie, upper_32_bits(pci_addr),
-		   PAB_PEX_AMAP_PEX_WIN_H(win_num));
+	mobiveil_csr_writel(pcie, lower_32_bits(pci_addr),
+			    PAB_PEX_AMAP_PEX_WIN_L(win_num));
+	mobiveil_csr_writel(pcie, upper_32_bits(pci_addr),
+			    PAB_PEX_AMAP_PEX_WIN_H(win_num));
 
 	pcie->ib_wins_configured++;
 }
@@ -515,27 +518,29 @@ static void program_ob_windows(struct mobiveil_pcie *pcie, int win_num,
 	 * program Enable Bit to 1, Type Bit to (00) base 2, AXI Window Size Bit
 	 * to 4 KB in PAB_AXI_AMAP_CTRL register
 	 */
-	value = csr_readl(pcie, PAB_AXI_AMAP_CTRL(win_num));
+	value = mobiveil_csr_readl(pcie, PAB_AXI_AMAP_CTRL(win_num));
 	value &= ~(WIN_TYPE_MASK << WIN_TYPE_SHIFT | WIN_SIZE_MASK);
 	value |= 1 << WIN_ENABLE_SHIFT | type << WIN_TYPE_SHIFT |
 		 (lower_32_bits(size64) & WIN_SIZE_MASK);
-	csr_writel(pcie, value, PAB_AXI_AMAP_CTRL(win_num));
+	mobiveil_csr_writel(pcie, value, PAB_AXI_AMAP_CTRL(win_num));
 
-	csr_writel(pcie, upper_32_bits(size64), PAB_EXT_AXI_AMAP_SIZE(win_num));
+	mobiveil_csr_writel(pcie, upper_32_bits(size64),
+			    PAB_EXT_AXI_AMAP_SIZE(win_num));
 
 	/*
 	 * program AXI window base with appropriate value in
 	 * PAB_AXI_AMAP_AXI_WIN0 register
 	 */
-	csr_writel(pcie, lower_32_bits(cpu_addr) & (~AXI_WINDOW_ALIGN_MASK),
-		   PAB_AXI_AMAP_AXI_WIN(win_num));
-	csr_writel(pcie, upper_32_bits(cpu_addr),
-		   PAB_EXT_AXI_AMAP_AXI_WIN(win_num));
+	mobiveil_csr_writel(pcie,
+			    lower_32_bits(cpu_addr) & (~AXI_WINDOW_ALIGN_MASK),
+			    PAB_AXI_AMAP_AXI_WIN(win_num));
+	mobiveil_csr_writel(pcie, upper_32_bits(cpu_addr),
+			    PAB_EXT_AXI_AMAP_AXI_WIN(win_num));
 
-	csr_writel(pcie, lower_32_bits(pci_addr),
-		   PAB_AXI_AMAP_PEX_WIN_L(win_num));
-	csr_writel(pcie, upper_32_bits(pci_addr),
-		   PAB_AXI_AMAP_PEX_WIN_H(win_num));
+	mobiveil_csr_writel(pcie, lower_32_bits(pci_addr),
+			    PAB_AXI_AMAP_PEX_WIN_L(win_num));
+	mobiveil_csr_writel(pcie, upper_32_bits(pci_addr),
+			    PAB_AXI_AMAP_PEX_WIN_H(win_num));
 
 	pcie->ob_wins_configured++;
 }
@@ -579,42 +584,42 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 	struct resource_entry *win;
 
 	/* setup bus numbers */
-	value = csr_readl(pcie, PCI_PRIMARY_BUS);
+	value = mobiveil_csr_readl(pcie, PCI_PRIMARY_BUS);
 	value &= 0xff000000;
 	value |= 0x00ff0100;
-	csr_writel(pcie, value, PCI_PRIMARY_BUS);
+	mobiveil_csr_writel(pcie, value, PCI_PRIMARY_BUS);
 
 	/*
 	 * program Bus Master Enable Bit in Command Register in PAB Config
 	 * Space
 	 */
-	value = csr_readl(pcie, PCI_COMMAND);
+	value = mobiveil_csr_readl(pcie, PCI_COMMAND);
 	value |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
-	csr_writel(pcie, value, PCI_COMMAND);
+	mobiveil_csr_writel(pcie, value, PCI_COMMAND);
 
 	/*
 	 * program PIO Enable Bit to 1 (and PEX PIO Enable to 1) in PAB_CTRL
 	 * register
 	 */
-	pab_ctrl = csr_readl(pcie, PAB_CTRL);
+	pab_ctrl = mobiveil_csr_readl(pcie, PAB_CTRL);
 	pab_ctrl |= (1 << AMBA_PIO_ENABLE_SHIFT) | (1 << PEX_PIO_ENABLE_SHIFT);
-	csr_writel(pcie, pab_ctrl, PAB_CTRL);
+	mobiveil_csr_writel(pcie, pab_ctrl, PAB_CTRL);
 
-	csr_writel(pcie, (PAB_INTP_INTX_MASK | PAB_INTP_MSI_MASK),
-		   PAB_INTP_AMBA_MISC_ENB);
+	mobiveil_csr_writel(pcie, (PAB_INTP_INTX_MASK | PAB_INTP_MSI_MASK),
+			    PAB_INTP_AMBA_MISC_ENB);
 
 	/*
 	 * program PIO Enable Bit to 1 and Config Window Enable Bit to 1 in
 	 * PAB_AXI_PIO_CTRL Register
 	 */
-	value = csr_readl(pcie, PAB_AXI_PIO_CTRL);
+	value = mobiveil_csr_readl(pcie, PAB_AXI_PIO_CTRL);
 	value |= APIO_EN_MASK;
-	csr_writel(pcie, value, PAB_AXI_PIO_CTRL);
+	mobiveil_csr_writel(pcie, value, PAB_AXI_PIO_CTRL);
 
 	/* Enable PCIe PIO master */
-	value = csr_readl(pcie, PAB_PEX_PIO_CTRL);
+	value = mobiveil_csr_readl(pcie, PAB_PEX_PIO_CTRL);
 	value |= 1 << PIO_ENABLE_SHIFT;
-	csr_writel(pcie, value, PAB_PEX_PIO_CTRL);
+	mobiveil_csr_writel(pcie, value, PAB_PEX_PIO_CTRL);
 
 	/*
 	 * we'll program one outbound window for config reads and
@@ -647,10 +652,10 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 	}
 
 	/* fixup for PCIe class register */
-	value = csr_readl(pcie, PAB_INTP_AXI_PIO_CLASS);
+	value = mobiveil_csr_readl(pcie, PAB_INTP_AXI_PIO_CLASS);
 	value &= 0xff;
 	value |= (PCI_CLASS_BRIDGE_PCI << 16);
-	csr_writel(pcie, value, PAB_INTP_AXI_PIO_CLASS);
+	mobiveil_csr_writel(pcie, value, PAB_INTP_AXI_PIO_CLASS);
 
 	/* setup MSI hardware registers */
 	mobiveil_pcie_enable_msi(pcie);
@@ -668,9 +673,9 @@ static void mobiveil_mask_intx_irq(struct irq_data *data)
 	pcie = irq_desc_get_chip_data(desc);
 	mask = 1 << ((data->hwirq + PAB_INTX_START) - 1);
 	raw_spin_lock_irqsave(&pcie->intx_mask_lock, flags);
-	shifted_val = csr_readl(pcie, PAB_INTP_AMBA_MISC_ENB);
+	shifted_val = mobiveil_csr_readl(pcie, PAB_INTP_AMBA_MISC_ENB);
 	shifted_val &= ~mask;
-	csr_writel(pcie, shifted_val, PAB_INTP_AMBA_MISC_ENB);
+	mobiveil_csr_writel(pcie, shifted_val, PAB_INTP_AMBA_MISC_ENB);
 	raw_spin_unlock_irqrestore(&pcie->intx_mask_lock, flags);
 }
 
@@ -684,9 +689,9 @@ static void mobiveil_unmask_intx_irq(struct irq_data *data)
 	pcie = irq_desc_get_chip_data(desc);
 	mask = 1 << ((data->hwirq + PAB_INTX_START) - 1);
 	raw_spin_lock_irqsave(&pcie->intx_mask_lock, flags);
-	shifted_val = csr_readl(pcie, PAB_INTP_AMBA_MISC_ENB);
+	shifted_val = mobiveil_csr_readl(pcie, PAB_INTP_AMBA_MISC_ENB);
 	shifted_val |= mask;
-	csr_writel(pcie, shifted_val, PAB_INTP_AMBA_MISC_ENB);
+	mobiveil_csr_writel(pcie, shifted_val, PAB_INTP_AMBA_MISC_ENB);
 	raw_spin_unlock_irqrestore(&pcie->intx_mask_lock, flags);
 }
 
-- 
2.20.1



