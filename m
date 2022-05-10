Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC25219D0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244895AbiEJNv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245053AbiEJNrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB8551339;
        Tue, 10 May 2022 06:34:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C82A6165A;
        Tue, 10 May 2022 13:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E3CC385C6;
        Tue, 10 May 2022 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189663;
        bh=Rm2T/hMeDswMU2o1bPZjdjw++Wz2KHX8zBWK5TdXEqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhPFG/PB1sVU2pXWyXApDHhg+SkF+GjjLnKDihi8xhjTwLFQTG42VcHYA2J+dOZCo
         ij0jW+R5mNbECeUlAfJ1PJ+aNdhy6RgnGRDOGg4MJH3tJ0tHq5MU/3YdPINb8Ykr5A
         C5P90Jzk+1X1stq1g/VjxTTV4GCGtkmVmtoFaGb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 121/135] PCI: aardvark: Make msi_domain_info structure a static driver structure
Date:   Tue, 10 May 2022 15:08:23 +0200
Message-Id: <20220510130743.868373375@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Marek Behún" <kabel@kernel.org>

commit 26bcd54e4a5cd51ec12d06fdc30e22863ed4c422 upstream.

Make Aardvark's msi_domain_info structure into a private driver structure.
Domain info is same for every potential instatination of a controller.

Link: https://lore.kernel.org/r/20220110015018.26359-8-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -274,7 +274,6 @@ struct advk_pcie {
 	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
-	struct msi_domain_info msi_domain_info;
 	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
 	struct mutex msi_used_lock;
 	u16 msi_msg;
@@ -1288,20 +1287,20 @@ static struct irq_chip advk_msi_irq_chip
 	.name = "advk-MSI",
 };
 
+static struct msi_domain_info advk_msi_domain_info = {
+	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+		  MSI_FLAG_MULTI_PCI_MSI,
+	.chip	= &advk_msi_irq_chip,
+};
+
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct msi_domain_info *msi_di;
 	phys_addr_t msi_msg_phys;
 
 	mutex_init(&pcie->msi_used_lock);
 
-	msi_di = &pcie->msi_domain_info;
-	msi_di->flags = MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		MSI_FLAG_MULTI_PCI_MSI;
-	msi_di->chip = &advk_msi_irq_chip;
-
 	msi_msg_phys = virt_to_phys(&pcie->msi_msg);
 
 	advk_writel(pcie, lower_32_bits(msi_msg_phys),
@@ -1317,7 +1316,8 @@ static int advk_pcie_init_msi_irq_domain
 
 	pcie->msi_domain =
 		pci_msi_create_irq_domain(of_node_to_fwnode(node),
-					  msi_di, pcie->msi_inner_domain);
+					  &advk_msi_domain_info,
+					  pcie->msi_inner_domain);
 	if (!pcie->msi_domain) {
 		irq_domain_remove(pcie->msi_inner_domain);
 		return -ENOMEM;


