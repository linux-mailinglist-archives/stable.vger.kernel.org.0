Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A159461D8D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243892AbhK2S0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:26:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58592 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348472AbhK2SYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:24:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 291CFB815BB;
        Mon, 29 Nov 2021 18:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD0DC53FAD;
        Mon, 29 Nov 2021 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210059;
        bh=JBLXgJNu3FH6yHtT+CX9IKKsb/syryqVjWdm6mki82c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXWf4TZIj8navW2Nchls+Qdm+5oty8XqZQMtkx0hhqHCPSY5oOx6vLxB28OJVFFj7
         NBXROVnpCWLhhcYuOw5JeGvPofNLpe6xKIOHd0iubOBm5sHpCJWDOYVVSDymyRjhYf
         dGzRmXlM9TNorl2bQw51P4FFX3oCSr1frJrQDsTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 28/69] PCI: aardvark: Configure PCIe resources from ranges DT property
Date:   Mon, 29 Nov 2021 19:18:10 +0100
Message-Id: <20211129181704.588196421@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 64f160e19e9264a7f6d89c516baae1473b6f8359 upstream.

In commit 6df6ba974a55 ("PCI: aardvark: Remove PCIe outbound window
configuration") was removed aardvark PCIe outbound window configuration and
commit description said that was recommended solution by HW designers.

But that commit completely removed support for configuring PCIe IO
resources without removing PCIe IO 'ranges' from DTS files. After that
commit PCIe IO space started to be treated as PCIe MEM space and accessing
it just caused kernel crash.

Moreover implementation of PCIe outbound windows prior that commit was
incorrect. It completely ignored offset between CPU address and PCIe bus
address and expected that in DTS is CPU address always same as PCIe bus
address without doing any checks. Also it completely ignored size of every
PCIe resource specified in 'ranges' DTS property and expected that every
PCIe resource has size 128 MB (also for PCIe IO range). Again without any
check. Apparently none of PCIe resource has in DTS specified size of 128
MB. So it was completely broken and thanks to how aardvark mask works,
configuration was completely ignored.

This patch reverts back support for PCIe outbound window configuration but
implementation is a new without issues mentioned above. PCIe outbound
window is required when DTS specify in 'ranges' property non-zero offset
between CPU and PCIe address space. To address recommendation by HW
designers as specified in commit description of 6df6ba974a55, set default
outbound parameters as PCIe MEM access without translation and therefore
for this PCIe 'ranges' it is not needed to configure PCIe outbound window.
For PCIe IO space is needed to configure aardvark PCIe outbound window.

This patch fixes kernel crash when trying to access PCIe IO space.

Link: https://lore.kernel.org/r/20210624215546.4015-2-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # 6df6ba974a55 ("PCI: aardvark: Remove PCIe outbound window configuration")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |  190 +++++++++++++++++++++++++++++++++-
 1 file changed, 189 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -106,6 +106,46 @@
 #define PCIE_MSI_PAYLOAD_REG			(CONTROL_BASE_ADDR + 0x9C)
 #define     PCIE_MSI_DATA_MASK			GENMASK(15, 0)
 
+/* PCIe window configuration */
+#define OB_WIN_BASE_ADDR			0x4c00
+#define OB_WIN_BLOCK_SIZE			0x20
+#define OB_WIN_COUNT				8
+#define OB_WIN_REG_ADDR(win, offset)		(OB_WIN_BASE_ADDR + \
+						  OB_WIN_BLOCK_SIZE * (win) + \
+						  (offset))
+#define OB_WIN_MATCH_LS(win)			OB_WIN_REG_ADDR(win, 0x00)
+#define     OB_WIN_ENABLE			BIT(0)
+#define OB_WIN_MATCH_MS(win)			OB_WIN_REG_ADDR(win, 0x04)
+#define OB_WIN_REMAP_LS(win)			OB_WIN_REG_ADDR(win, 0x08)
+#define OB_WIN_REMAP_MS(win)			OB_WIN_REG_ADDR(win, 0x0c)
+#define OB_WIN_MASK_LS(win)			OB_WIN_REG_ADDR(win, 0x10)
+#define OB_WIN_MASK_MS(win)			OB_WIN_REG_ADDR(win, 0x14)
+#define OB_WIN_ACTIONS(win)			OB_WIN_REG_ADDR(win, 0x18)
+#define OB_WIN_DEFAULT_ACTIONS			(OB_WIN_ACTIONS(OB_WIN_COUNT-1) + 0x4)
+#define     OB_WIN_FUNC_NUM_MASK		GENMASK(31, 24)
+#define     OB_WIN_FUNC_NUM_SHIFT		24
+#define     OB_WIN_FUNC_NUM_ENABLE		BIT(23)
+#define     OB_WIN_BUS_NUM_BITS_MASK		GENMASK(22, 20)
+#define     OB_WIN_BUS_NUM_BITS_SHIFT		20
+#define     OB_WIN_MSG_CODE_ENABLE		BIT(22)
+#define     OB_WIN_MSG_CODE_MASK		GENMASK(21, 14)
+#define     OB_WIN_MSG_CODE_SHIFT		14
+#define     OB_WIN_MSG_PAYLOAD_LEN		BIT(12)
+#define     OB_WIN_ATTR_ENABLE			BIT(11)
+#define     OB_WIN_ATTR_TC_MASK			GENMASK(10, 8)
+#define     OB_WIN_ATTR_TC_SHIFT		8
+#define     OB_WIN_ATTR_RELAXED			BIT(7)
+#define     OB_WIN_ATTR_NOSNOOP			BIT(6)
+#define     OB_WIN_ATTR_POISON			BIT(5)
+#define     OB_WIN_ATTR_IDO			BIT(4)
+#define     OB_WIN_TYPE_MASK			GENMASK(3, 0)
+#define     OB_WIN_TYPE_SHIFT			0
+#define     OB_WIN_TYPE_MEM			0x0
+#define     OB_WIN_TYPE_IO			0x4
+#define     OB_WIN_TYPE_CONFIG_TYPE0		0x8
+#define     OB_WIN_TYPE_CONFIG_TYPE1		0x9
+#define     OB_WIN_TYPE_MSG			0xc
+
 /* LMI registers base address and register offsets */
 #define LMI_BASE_ADDR				0x6000
 #define CFG_REG					(LMI_BASE_ADDR + 0x0)
@@ -174,6 +214,13 @@ struct advk_pcie {
 	struct platform_device *pdev;
 	void __iomem *base;
 	struct list_head resources;
+	struct {
+		phys_addr_t match;
+		phys_addr_t remap;
+		phys_addr_t mask;
+		u32 actions;
+	} wins[OB_WIN_COUNT];
+	u8 wins_count;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
 	raw_spinlock_t irq_lock;
@@ -349,9 +396,39 @@ err:
 	dev_err(dev, "link never came up\n");
 }
 
+/*
+ * Set PCIe address window register which could be used for memory
+ * mapping.
+ */
+static void advk_pcie_set_ob_win(struct advk_pcie *pcie, u8 win_num,
+				 phys_addr_t match, phys_addr_t remap,
+				 phys_addr_t mask, u32 actions)
+{
+	advk_writel(pcie, OB_WIN_ENABLE |
+			  lower_32_bits(match), OB_WIN_MATCH_LS(win_num));
+	advk_writel(pcie, upper_32_bits(match), OB_WIN_MATCH_MS(win_num));
+	advk_writel(pcie, lower_32_bits(remap), OB_WIN_REMAP_LS(win_num));
+	advk_writel(pcie, upper_32_bits(remap), OB_WIN_REMAP_MS(win_num));
+	advk_writel(pcie, lower_32_bits(mask), OB_WIN_MASK_LS(win_num));
+	advk_writel(pcie, upper_32_bits(mask), OB_WIN_MASK_MS(win_num));
+	advk_writel(pcie, actions, OB_WIN_ACTIONS(win_num));
+}
+
+static void advk_pcie_disable_ob_win(struct advk_pcie *pcie, u8 win_num)
+{
+	advk_writel(pcie, 0, OB_WIN_MATCH_LS(win_num));
+	advk_writel(pcie, 0, OB_WIN_MATCH_MS(win_num));
+	advk_writel(pcie, 0, OB_WIN_REMAP_LS(win_num));
+	advk_writel(pcie, 0, OB_WIN_REMAP_MS(win_num));
+	advk_writel(pcie, 0, OB_WIN_MASK_LS(win_num));
+	advk_writel(pcie, 0, OB_WIN_MASK_MS(win_num));
+	advk_writel(pcie, 0, OB_WIN_ACTIONS(win_num));
+}
+
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
+	int i;
 
 	/* Set to Direct mode */
 	reg = advk_readl(pcie, CTRL_CONFIG_REG);
@@ -415,15 +492,51 @@ static void advk_pcie_setup_hw(struct ad
 	reg = PCIE_IRQ_ALL_MASK & (~PCIE_IRQ_ENABLE_INTS_MASK);
 	advk_writel(pcie, reg, HOST_CTRL_INT_MASK_REG);
 
+	/*
+	 * Enable AXI address window location generation:
+	 * When it is enabled, the default outbound window
+	 * configurations (Default User Field: 0xD0074CFC)
+	 * are used to transparent address translation for
+	 * the outbound transactions. Thus, PCIe address
+	 * windows are not required for transparent memory
+	 * access when default outbound window configuration
+	 * is set for memory access.
+	 */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL2_REG);
 	reg |= PCIE_CORE_CTRL2_OB_WIN_ENABLE;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL2_REG);
 
-	/* Bypass the address window mapping for PIO */
+	/*
+	 * Set memory access in Default User Field so it
+	 * is not required to configure PCIe address for
+	 * transparent memory access.
+	 */
+	advk_writel(pcie, OB_WIN_TYPE_MEM, OB_WIN_DEFAULT_ACTIONS);
+
+	/*
+	 * Bypass the address window mapping for PIO:
+	 * Since PIO access already contains all required
+	 * info over AXI interface by PIO registers, the
+	 * address window is not required.
+	 */
 	reg = advk_readl(pcie, PIO_CTRL);
 	reg |= PIO_CTRL_ADDR_WIN_DISABLE;
 	advk_writel(pcie, reg, PIO_CTRL);
 
+	/*
+	 * Configure PCIe address windows for non-memory or
+	 * non-transparent access as by default PCIe uses
+	 * transparent memory access.
+	 */
+	for (i = 0; i < pcie->wins_count; i++)
+		advk_pcie_set_ob_win(pcie, i,
+				     pcie->wins[i].match, pcie->wins[i].remap,
+				     pcie->wins[i].mask, pcie->wins[i].actions);
+
+	/* Disable remaining PCIe outbound windows */
+	for (i = pcie->wins_count; i < OB_WIN_COUNT; i++)
+		advk_pcie_disable_ob_win(pcie, i);
+
 	advk_pcie_train_link(pcie);
 
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
@@ -1038,6 +1151,7 @@ static int advk_pcie_probe(struct platfo
 	struct advk_pcie *pcie;
 	struct resource *res;
 	struct pci_host_bridge *bridge;
+	struct resource_entry *entry;
 	int ret, irq;
 
 	bridge = devm_pci_alloc_host_bridge(dev, sizeof(struct advk_pcie));
@@ -1067,6 +1181,80 @@ static int advk_pcie_probe(struct platfo
 		return ret;
 	}
 
+	resource_list_for_each_entry(entry, &pcie->resources) {
+		resource_size_t start = entry->res->start;
+		resource_size_t size = resource_size(entry->res);
+		unsigned long type = resource_type(entry->res);
+		u64 win_size;
+
+		/*
+		 * Aardvark hardware allows to configure also PCIe window
+		 * for config type 0 and type 1 mapping, but driver uses
+		 * only PIO for issuing configuration transfers which does
+		 * not use PCIe window configuration.
+		 */
+		if (type != IORESOURCE_MEM && type != IORESOURCE_MEM_64 &&
+		    type != IORESOURCE_IO)
+			continue;
+
+		/*
+		 * Skip transparent memory resources. Default outbound access
+		 * configuration is set to transparent memory access so it
+		 * does not need window configuration.
+		 */
+		if ((type == IORESOURCE_MEM || type == IORESOURCE_MEM_64) &&
+		    entry->offset == 0)
+			continue;
+
+		/*
+		 * The n-th PCIe window is configured by tuple (match, remap, mask)
+		 * and an access to address A uses this window if A matches the
+		 * match with given mask.
+		 * So every PCIe window size must be a power of two and every start
+		 * address must be aligned to window size. Minimal size is 64 KiB
+		 * because lower 16 bits of mask must be zero. Remapped address
+		 * may have set only bits from the mask.
+		 */
+		while (pcie->wins_count < OB_WIN_COUNT && size > 0) {
+			/* Calculate the largest aligned window size */
+			win_size = (1ULL << (fls64(size)-1)) |
+				   (start ? (1ULL << __ffs64(start)) : 0);
+			win_size = 1ULL << __ffs64(win_size);
+			if (win_size < 0x10000)
+				break;
+
+			dev_dbg(dev,
+				"Configuring PCIe window %d: [0x%llx-0x%llx] as %lu\n",
+				pcie->wins_count, (unsigned long long)start,
+				(unsigned long long)start + win_size, type);
+
+			if (type == IORESOURCE_IO) {
+				pcie->wins[pcie->wins_count].actions = OB_WIN_TYPE_IO;
+				pcie->wins[pcie->wins_count].match = pci_pio_to_address(start);
+			} else {
+				pcie->wins[pcie->wins_count].actions = OB_WIN_TYPE_MEM;
+				pcie->wins[pcie->wins_count].match = start;
+			}
+			pcie->wins[pcie->wins_count].remap = start - entry->offset;
+			pcie->wins[pcie->wins_count].mask = ~(win_size - 1);
+
+			if (pcie->wins[pcie->wins_count].remap & (win_size - 1))
+				break;
+
+			start += win_size;
+			size -= win_size;
+			pcie->wins_count++;
+		}
+
+		if (size > 0) {
+			dev_err(&pcie->pdev->dev,
+				"Invalid PCIe region [0x%llx-0x%llx]\n",
+				(unsigned long long)entry->res->start,
+				(unsigned long long)entry->res->end + 1);
+			return -EINVAL;
+		}
+	}
+
 	pcie->reset_gpio = devm_gpiod_get_from_of_node(dev, dev->of_node,
 						       "reset-gpios", 0,
 						       GPIOD_OUT_LOW,


