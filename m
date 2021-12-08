Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9703E46CD9E
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 07:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhLHGWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 01:22:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48334 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbhLHGWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 01:22:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC555B81FC0;
        Wed,  8 Dec 2021 06:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22351C341DC;
        Wed,  8 Dec 2021 06:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638944347;
        bh=M6up1qlgbGE/z3KR6aLNCdI8++m53DtOfEAz9+WnHEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9bqB9Zkk2fFODJOf2x2TV/EJ8po+1GdBC25EZxyCKTFQf6Da+asQrfv07UUKnMA1
         bAx5AzPYDCjvze+UsxHPm3R4mbbdYsmtW8m5UQmAKoI+MfKwGGcqBhRv472fhji2+S
         AW2c6WmTtWOtx8OOxffnKzUC788x8r+o8QvQha8ZaxlQndCa3GfPErTRZEVTxPNKny
         A3VmARXlS97Ba18fMjBnk4bWWV32YVC0NJqrRIL/1q0oWOYLHqphngqNPmgfucWrmT
         lpzNHwU2B9gBnF/Cmj2cOYxqxslbzrGa1Hoqz4B8oXWFF4oUXjoQ3X+UXIEl+I3MOe
         G9omDSDdeKcyg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     linux-pci@vger.kernel.org, pali@kernel.org,
        Marc Zyngier <maz@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 07/17] PCI: aardvark: Fix setting MSI address
Date:   Wed,  8 Dec 2021 07:18:41 +0100
Message-Id: <20211208061851.31867-8-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208061851.31867-1-kabel@kernel.org>
References: <20211208061851.31867-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

MSI address for receiving MSI interrupts needs to be correctly set before
enabling processing of MSI interrupts.

Move code for setting PCIE_MSI_ADDR_LOW_REG and PCIE_MSI_ADDR_HIGH_REG
from advk_pcie_init_msi_irq_domain() to advk_pcie_setup_hw(), before
enabling PCIE_CORE_CTRL2_MSI_ENABLE.

After this we can remove the now unused member msi_msg, which was used
only for MSI doorbell address. MSI address can be any address which cannot
be used to DMA to. So change it to the address of the main struct advk_pcie.

Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # f21a8b1b6837 ("PCI: aardvark: Move to MSI handling using generic MSI support")
---
 drivers/pci/controller/pci-aardvark.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 74b60cb2e6fd..d518cface0a7 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -285,7 +285,6 @@ struct advk_pcie {
 	struct msi_domain_info msi_domain_info;
 	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
 	struct mutex msi_used_lock;
-	u16 msi_msg;
 	int link_gen;
 	struct pci_bridge_emul bridge;
 	struct gpio_desc *reset_gpio;
@@ -480,6 +479,7 @@ static void advk_pcie_disable_ob_win(struct advk_pcie *pcie, u8 win_num)
 
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
+	phys_addr_t msi_addr;
 	u32 reg;
 	int i;
 
@@ -568,6 +568,11 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg |= LANE_COUNT_1;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
 
+	/* Set MSI address */
+	msi_addr = virt_to_phys(pcie);
+	advk_writel(pcie, lower_32_bits(msi_addr), PCIE_MSI_ADDR_LOW_REG);
+	advk_writel(pcie, upper_32_bits(msi_addr), PCIE_MSI_ADDR_HIGH_REG);
+
 	/* Enable MSI */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL2_REG);
 	reg |= PCIE_CORE_CTRL2_MSI_ENABLE;
@@ -1191,10 +1196,10 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
 					 struct msi_msg *msg)
 {
 	struct advk_pcie *pcie = irq_data_get_irq_chip_data(data);
-	phys_addr_t msi_msg = virt_to_phys(&pcie->msi_msg);
+	phys_addr_t msi_addr = virt_to_phys(pcie);
 
-	msg->address_lo = lower_32_bits(msi_msg);
-	msg->address_hi = upper_32_bits(msi_msg);
+	msg->address_lo = lower_32_bits(msi_addr);
+	msg->address_hi = upper_32_bits(msi_addr);
 	msg->data = data->hwirq;
 }
 
@@ -1336,7 +1341,6 @@ static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 	struct device_node *node = dev->of_node;
 	struct irq_chip *bottom_ic, *msi_ic;
 	struct msi_domain_info *msi_di;
-	phys_addr_t msi_msg_phys;
 
 	raw_spin_lock_init(&pcie->msi_irq_lock);
 	mutex_init(&pcie->msi_used_lock);
@@ -1359,13 +1363,6 @@ static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 		MSI_FLAG_MULTI_PCI_MSI;
 	msi_di->chip = msi_ic;
 
-	msi_msg_phys = virt_to_phys(&pcie->msi_msg);
-
-	advk_writel(pcie, lower_32_bits(msi_msg_phys),
-		    PCIE_MSI_ADDR_LOW_REG);
-	advk_writel(pcie, upper_32_bits(msi_msg_phys),
-		    PCIE_MSI_ADDR_HIGH_REG);
-
 	pcie->msi_inner_domain =
 		irq_domain_add_linear(NULL, MSI_IRQ_NUM,
 				      &advk_msi_domain_ops, pcie);
-- 
2.32.0

