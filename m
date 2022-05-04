Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA651AA32
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356856AbiEDRWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357384AbiEDRPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0915654BD3
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C1761926
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B5BC385B0;
        Wed,  4 May 2022 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683510;
        bh=qB6Coj1/PjFn9mJ3kB3VIxylq/jcfyJgedfsVLitv1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTWbqNmQw0HXfaiVfTUlPbXqcOz/85Fo9VLZPcK2T1ekPMUdL5Q6TduE27dqSKqe4
         7zvyyYsejfcczoblY2I4FREckrG1P0hTOPHnudkCN04cN+vk4QMd83xmBTn2uZJcbD
         yEjTdASYOSLfY6hkU99FjZ9WThxfO1PLVoxVMXGirJ3SeZkGGOFjLKH3E7V/CibHzM
         DDgUITnm4Nv6nXcWvkFXAUs1n8FOr6MjZc6gwhxNNfQBORqNdQTcfEegsnCaTZeWxg
         9iavPeNaLU4nK7no0lKGYiw+heQNoKLt+uHGK2WiaegowmgdYJhUHdrYklsrdQPmuB
         brDHNcabt89NQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 19/30] PCI: aardvark: Add support for masking MSI interrupts
Date:   Wed,  4 May 2022 18:57:44 +0200
Message-Id: <20220504165755.30002-20-kabel@kernel.org>
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

commit e77d9c90691071769cd2b86ef097f7d07167dc3b upstream.

We should not unmask MSIs at setup, but only when kernel asks for them
to be unmasked.

At setup, mask all MSIs, and implement IRQ chip callbacks for masking
and unmasking particular MSIs.

Link: https://lore.kernel.org/r/20220110015018.26359-11-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 54 ++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index b96ef0fdf9e6..ad3931919de3 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -274,6 +274,7 @@ struct advk_pcie {
 	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
+	raw_spinlock_t msi_irq_lock;
 	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
 	struct mutex msi_used_lock;
 	u16 msi_msg;
@@ -570,12 +571,10 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	advk_writel(pcie, PCIE_ISR1_ALL_MASK, PCIE_ISR1_REG);
 	advk_writel(pcie, PCIE_IRQ_ALL_MASK, HOST_CTRL_INT_STATUS_REG);
 
-	/* Disable All ISR0/1 Sources */
+	/* Disable All ISR0/1 and MSI Sources */
 	advk_writel(pcie, PCIE_ISR0_ALL_MASK, PCIE_ISR0_MASK_REG);
 	advk_writel(pcie, PCIE_ISR1_ALL_MASK, PCIE_ISR1_MASK_REG);
-
-	/* Unmask all MSIs */
-	advk_writel(pcie, ~(u32)PCIE_MSI_ALL_MASK, PCIE_MSI_MASK_REG);
+	advk_writel(pcie, PCIE_MSI_ALL_MASK, PCIE_MSI_MASK_REG);
 
 	/* Unmask summary MSI interrupt */
 	reg = advk_readl(pcie, PCIE_ISR0_MASK_REG);
@@ -1193,10 +1192,52 @@ static int advk_msi_set_affinity(struct irq_data *irq_data,
 	return -EINVAL;
 }
 
+static void advk_msi_irq_mask(struct irq_data *d)
+{
+	struct advk_pcie *pcie = d->domain->host_data;
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
+	u32 mask;
+
+	raw_spin_lock_irqsave(&pcie->msi_irq_lock, flags);
+	mask = advk_readl(pcie, PCIE_MSI_MASK_REG);
+	mask |= BIT(hwirq);
+	advk_writel(pcie, mask, PCIE_MSI_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->msi_irq_lock, flags);
+}
+
+static void advk_msi_irq_unmask(struct irq_data *d)
+{
+	struct advk_pcie *pcie = d->domain->host_data;
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
+	u32 mask;
+
+	raw_spin_lock_irqsave(&pcie->msi_irq_lock, flags);
+	mask = advk_readl(pcie, PCIE_MSI_MASK_REG);
+	mask &= ~BIT(hwirq);
+	advk_writel(pcie, mask, PCIE_MSI_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->msi_irq_lock, flags);
+}
+
+static void advk_msi_top_irq_mask(struct irq_data *d)
+{
+	pci_msi_mask_irq(d);
+	irq_chip_mask_parent(d);
+}
+
+static void advk_msi_top_irq_unmask(struct irq_data *d)
+{
+	pci_msi_unmask_irq(d);
+	irq_chip_unmask_parent(d);
+}
+
 static struct irq_chip advk_msi_bottom_irq_chip = {
 	.name			= "MSI",
 	.irq_compose_msi_msg	= advk_msi_irq_compose_msi_msg,
 	.irq_set_affinity	= advk_msi_set_affinity,
+	.irq_mask		= advk_msi_irq_mask,
+	.irq_unmask		= advk_msi_irq_unmask,
 };
 
 static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
@@ -1286,7 +1327,9 @@ static const struct irq_domain_ops advk_pcie_irq_domain_ops = {
 };
 
 static struct irq_chip advk_msi_irq_chip = {
-	.name = "advk-MSI",
+	.name		= "advk-MSI",
+	.irq_mask	= advk_msi_top_irq_mask,
+	.irq_unmask	= advk_msi_top_irq_unmask,
 };
 
 static struct msi_domain_info advk_msi_domain_info = {
@@ -1300,6 +1343,7 @@ static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 	struct device *dev = &pcie->pdev->dev;
 	phys_addr_t msi_msg_phys;
 
+	raw_spin_lock_init(&pcie->msi_irq_lock);
 	mutex_init(&pcie->msi_used_lock);
 
 	msi_msg_phys = virt_to_phys(&pcie->msi_msg);
-- 
2.35.1

