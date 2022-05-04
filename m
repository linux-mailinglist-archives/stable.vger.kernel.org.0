Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1773651A9AA
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356701AbiEDRSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357445AbiEDRPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D43254BF3
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ECCA617A6
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7DEC385B7;
        Wed,  4 May 2022 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683514;
        bh=oK9np9ARkndcHCYoKU7BnzEmtKlDN6eVBtbW52QLmR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJz87PNlnPvYyhLweK4XChls0XBR70zoKQR5tWoUzRIKz3ZMSvMl3zFRd3AJfA6zA
         OIGOv5XFUS/kCzlp+Ovyc12Uu0kfaWdop5S5vdWXdczzLAQCJVFpTevTEyyEi71rie
         sMkkH7O/XDx3JBQ5dLsoZUt704qXKAo/n99sx6ovBoWgJOczg28jzRYhA/EEnSD2Dd
         P4CrYlpMwQxuMkAFOlZPjAE54C2+/NnoS1ETmwf4EGlJj4gSQuNdGa9l3pqQf0mVzc
         zoR8Afuo11lk50IFeuwQMyYbPdIyqqpFqTEiZuOXR2BXp123O2WPOA093PV669XvIA
         7RMsNrYN2IRxA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 22/30] PCI: aardvark: Add support for ERR interrupt on emulated bridge
Date:   Wed,  4 May 2022 18:57:47 +0200
Message-Id: <20220504165755.30002-23-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 3ebfefa396ebee21061fd5fa36073368ed2cd467 upstream.

ERR interrupt is triggered when corresponding bit is unmasked in both ISR0
and PCI_EXP_DEVCTL registers. Unmasking ERR bits in PCI_EXP_DEVCTL register
is not enough. This means that currently the ERR interrupt is never
triggered.

Unmask ERR bits in ISR0 register at driver probe time. ERR interrupt is not
triggered until ERR bits are unmasked also in PCI_EXP_DEVCTL register,
which is done by AER driver. So it is safe to unconditionally unmask all
ERR bits in aardvark probe.

Aardvark HW sets PCI_ERR_ROOT_AER_IRQ to zero and when corresponding bits
in ISR0 and PCI_EXP_DEVCTL are enabled, the HW triggers a generic interrupt
on GIC. Chain this interrupt to PCIe interrupt 0 with
generic_handle_domain_irq() to allow processing of ERR interrupts.

Link: https://lore.kernel.org/r/20220110015018.26359-14-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 35 ++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 4cc88fa66979..0384dc842e6d 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -98,6 +98,10 @@
 #define PCIE_MSG_PM_PME_MASK			BIT(7)
 #define PCIE_ISR0_MASK_REG			(CONTROL_BASE_ADDR + 0x44)
 #define     PCIE_ISR0_MSI_INT_PENDING		BIT(24)
+#define     PCIE_ISR0_CORR_ERR			BIT(11)
+#define     PCIE_ISR0_NFAT_ERR			BIT(12)
+#define     PCIE_ISR0_FAT_ERR			BIT(13)
+#define     PCIE_ISR0_ERR_MASK			GENMASK(13, 11)
 #define     PCIE_ISR0_INTX_ASSERT(val)		BIT(16 + (val))
 #define     PCIE_ISR0_INTX_DEASSERT(val)	BIT(20 + (val))
 #define     PCIE_ISR0_ALL_MASK			GENMASK(31, 0)
@@ -778,11 +782,15 @@ advk_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
 	case PCI_INTERRUPT_LINE: {
 		/*
 		 * From the whole 32bit register we support reading from HW only
-		 * one bit: PCI_BRIDGE_CTL_BUS_RESET.
+		 * two bits: PCI_BRIDGE_CTL_BUS_RESET and PCI_BRIDGE_CTL_SERR.
 		 * Other bits are retrieved only from emulated config buffer.
 		 */
 		__le32 *cfgspace = (__le32 *)&bridge->conf;
 		u32 val = le32_to_cpu(cfgspace[PCI_INTERRUPT_LINE / 4]);
+		if (advk_readl(pcie, PCIE_ISR0_MASK_REG) & PCIE_ISR0_ERR_MASK)
+			val &= ~(PCI_BRIDGE_CTL_SERR << 16);
+		else
+			val |= PCI_BRIDGE_CTL_SERR << 16;
 		if (advk_readl(pcie, PCIE_CORE_CTRL1_REG) & HOT_RESET_GEN)
 			val |= PCI_BRIDGE_CTL_BUS_RESET << 16;
 		else
@@ -808,6 +816,19 @@ advk_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_INTERRUPT_LINE:
+		/*
+		 * According to Figure 6-3: Pseudo Logic Diagram for Error
+		 * Message Controls in PCIe base specification, SERR# Enable bit
+		 * in Bridge Control register enable receiving of ERR_* messages
+		 */
+		if (mask & (PCI_BRIDGE_CTL_SERR << 16)) {
+			u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
+			if (new & (PCI_BRIDGE_CTL_SERR << 16))
+				val &= ~PCIE_ISR0_ERR_MASK;
+			else
+				val |= PCIE_ISR0_ERR_MASK;
+			advk_writel(pcie, val, PCIE_ISR0_MASK_REG);
+		}
 		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
 			u32 val = advk_readl(pcie, PCIE_CORE_CTRL1_REG);
 			if (new & (PCI_BRIDGE_CTL_BUS_RESET << 16))
@@ -1457,6 +1478,18 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
 
+	/* Process ERR interrupt */
+	if (isr0_status & PCIE_ISR0_ERR_MASK) {
+		advk_writel(pcie, PCIE_ISR0_ERR_MASK, PCIE_ISR0_REG);
+
+		/*
+		 * Aardvark HW returns zero for PCI_ERR_ROOT_AER_IRQ, so use
+		 * PCIe interrupt 0
+		 */
+		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+			dev_err_ratelimited(&pcie->pdev->dev, "unhandled ERR IRQ\n");
+	}
+
 	/* Process MSI interrupts */
 	if (isr0_status & PCIE_ISR0_MSI_INT_PENDING)
 		advk_pcie_handle_msi(pcie);
-- 
2.35.1

