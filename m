Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8EE40E57E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345827AbhIPRME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350464AbhIPRJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7861D61B44;
        Thu, 16 Sep 2021 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810247;
        bh=PigDoh3hyPXh6lz7HeYb2Ci/XfGGvqQFWZpJhMgen44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdTWgH8bPF4niM4pXxZyrHqX0Km0+bjKWm4mxUbwGet3oXEEUryJSf8XmOf2aL5qH
         hXvrvo55QNbkhR2BfZZiz4Jygu1LDgQ7WKkDrjH3zn66yzOSytZpN9rlTwmRsGEADS
         gfyuCJsxXyl6NiyBYWdxN2EfLuHNjOhT1Zs5NHY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.14 071/432] PCI: aardvark: Fix masking and unmasking legacy INTx interrupts
Date:   Thu, 16 Sep 2021 17:57:00 +0200
Message-Id: <20210916155813.193730834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit d212dcee27c1f89517181047e5485fcbba4a25c2 upstream.

irq_mask and irq_unmask callbacks need to be properly guarded by raw spin
locks as masking/unmasking procedure needs atomic read-modify-write
operation on hardware register.

Link: https://lore.kernel.org/r/20210820155020.3000-1-pali@kernel.org
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -230,6 +230,7 @@ struct advk_pcie {
 	u8 wins_count;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
+	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
 	struct irq_chip msi_bottom_irq_chip;
@@ -1045,22 +1046,28 @@ static void advk_pcie_irq_mask(struct ir
 {
 	struct advk_pcie *pcie = d->domain->host_data;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
 	u32 mask;
 
+	raw_spin_lock_irqsave(&pcie->irq_lock, flags);
 	mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	mask |= PCIE_ISR1_INTX_ASSERT(hwirq);
 	advk_writel(pcie, mask, PCIE_ISR1_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->irq_lock, flags);
 }
 
 static void advk_pcie_irq_unmask(struct irq_data *d)
 {
 	struct advk_pcie *pcie = d->domain->host_data;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
 	u32 mask;
 
+	raw_spin_lock_irqsave(&pcie->irq_lock, flags);
 	mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	mask &= ~PCIE_ISR1_INTX_ASSERT(hwirq);
 	advk_writel(pcie, mask, PCIE_ISR1_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->irq_lock, flags);
 }
 
 static int advk_pcie_irq_map(struct irq_domain *h,
@@ -1144,6 +1151,8 @@ static int advk_pcie_init_irq_domain(str
 	struct irq_chip *irq_chip;
 	int ret = 0;
 
+	raw_spin_lock_init(&pcie->irq_lock);
+
 	pcie_intc_node =  of_get_next_child(node, NULL);
 	if (!pcie_intc_node) {
 		dev_err(dev, "No PCIe Intc node found\n");


