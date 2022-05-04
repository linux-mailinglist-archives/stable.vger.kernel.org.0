Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE04F51A9F8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357069AbiEDRTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357736AbiEDRPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87D34D26C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF6461931
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873EAC385A5;
        Wed,  4 May 2022 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683511;
        bh=ztObVUwDhe4+yim/9mKWxs9oywA9XPXyB8C0mZuT82o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSnGByMhCyrRVTbOPmJjL45nxsT9E4IXgq/tmpcb9V9gAJ/RkgiO8J3+XxiS8qKRD
         btgG2UtaCZTQ6WMdqPrrBWvK2CueGdmTdmn05NmzZPLtm1uoWceRoAmyQdr5Ns+/kX
         GGpe1Oypfe4fj80ar1qzA4eeCAl3l0VW9wlScoYBUCJRGO8yCjlP9YgYvZ4h4uhKnL
         kU/Xg4SDecYnF1G5yLsdnrpn02X8qO6YOTGVbq3LThSrNAtepFgXb/cIzUiXk/5/RW
         AUPzxYUJ5BCxC3Y9RsUJgcWBnKEAfN/x3AA48P72x4WFXd55NfKAF+Dpw75KZGtUzc
         5GgPW3KUA0VTA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 20/30] PCI: aardvark: Fix setting MSI address
Date:   Wed,  4 May 2022 18:57:45 +0200
Message-Id: <20220504165755.30002-21-kabel@kernel.org>
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

commit 46ad3dc4171b5ee1d12267d70112563d5760210a upstream.

MSI address for receiving MSI interrupts needs to be correctly set before
enabling processing of MSI interrupts.

Move code for setting PCIE_MSI_ADDR_LOW_REG and PCIE_MSI_ADDR_HIGH_REG
from advk_pcie_init_msi_irq_domain() to advk_pcie_setup_hw(), before
enabling PCIE_CORE_CTRL2_MSI_ENABLE.

After this we can remove the now unused member msi_msg, which was used
only for MSI doorbell address. MSI address can be any address which cannot
be used to DMA to. So change it to the address of the main struct advk_pcie.

Link: https://lore.kernel.org/r/20220110015018.26359-12-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # f21a8b1b6837 ("PCI: aardvark: Move to MSI handling using generic MSI support")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ad3931919de3..43f79cbf9027 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -277,7 +277,6 @@ struct advk_pcie {
 	raw_spinlock_t msi_irq_lock;
 	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
 	struct mutex msi_used_lock;
-	u16 msi_msg;
 	int link_gen;
 	struct pci_bridge_emul bridge;
 	struct gpio_desc *reset_gpio;
@@ -472,6 +471,7 @@ static void advk_pcie_disable_ob_win(struct advk_pcie *pcie, u8 win_num)
 
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
+	phys_addr_t msi_addr;
 	u32 reg;
 	int i;
 
@@ -560,6 +560,11 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -1179,10 +1184,10 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
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
 
@@ -1341,18 +1346,10 @@ static struct msi_domain_info advk_msi_domain_info = {
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	phys_addr_t msi_msg_phys;
 
 	raw_spin_lock_init(&pcie->msi_irq_lock);
 	mutex_init(&pcie->msi_used_lock);
 
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
2.35.1

