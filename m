Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EA85219D6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244944AbiEJNvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245047AbiEJNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F383443D2;
        Tue, 10 May 2022 06:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C283DB81DA2;
        Tue, 10 May 2022 13:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC7CC385A6;
        Tue, 10 May 2022 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189657;
        bh=jFnAKTcpZKMOoreHyThA4h5lT/C6YV3XwTgRFXYjlzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZnyJH92HWkG65qYPBis6NcWy8XGo+AqYD+P/K4V0FjbaL8WPylE/BE4alsu8WgOQ
         9QffPeaMrl/babuceg9lG6EMrjrOgcjqDHvRK9RVU/rhrloIk+WUS7Kc+7e2yRaEnF
         rcK10/n0ZM5qRTadJN7h0urS97Yv9puljza81nQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 120/135] PCI: aardvark: Make MSI irq_chip structures static driver structures
Date:   Tue, 10 May 2022 15:08:22 +0200
Message-Id: <20220510130743.840323275@linuxfoundation.org>
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

From: "Marek Beh�n" <kabel@kernel.org>

commit c3cb8e51839adc0aaef478c47665443d02f5aa07 upstream.

In [1] it was agreed that we should use struct irq_chip as a global
static struct in the driver. Even though the structure currently
contains a dynamic member (parent_device), In [2] the plans to kill it
and make the structure completely static were set out.

Convert Aardvark's priv->msi_bottom_irq_chip and priv->msi_irq_chip to
static driver structure.

[1] https://lore.kernel.org/linux-pci/877dbcvngf.wl-maz@kernel.org/
[2] https://lore.kernel.org/linux-pci/874k6gvkhz.wl-maz@kernel.org/

Link: https://lore.kernel.org/r/20220110015018.26359-7-kabel@kernel.org
Signed-off-by: Marek Beh�n <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Beh�n <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -274,8 +274,6 @@ struct advk_pcie {
 	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
-	struct irq_chip msi_bottom_irq_chip;
-	struct irq_chip msi_irq_chip;
 	struct msi_domain_info msi_domain_info;
 	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
 	struct mutex msi_used_lock;
@@ -1194,6 +1192,12 @@ static int advk_msi_set_affinity(struct
 	return -EINVAL;
 }
 
+static struct irq_chip advk_msi_bottom_irq_chip = {
+	.name			= "MSI",
+	.irq_compose_msi_msg	= advk_msi_irq_compose_msi_msg,
+	.irq_set_affinity	= advk_msi_set_affinity,
+};
+
 static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
 				     unsigned int virq,
 				     unsigned int nr_irqs, void *args)
@@ -1210,7 +1214,7 @@ static int advk_msi_irq_domain_alloc(str
 
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_set_info(domain, virq + i, hwirq + i,
-				    &pcie->msi_bottom_irq_chip,
+				    &advk_msi_bottom_irq_chip,
 				    domain->host_data, handle_simple_irq,
 				    NULL, NULL);
 
@@ -1280,29 +1284,23 @@ static const struct irq_domain_ops advk_
 	.xlate = irq_domain_xlate_onecell,
 };
 
+static struct irq_chip advk_msi_irq_chip = {
+	.name = "advk-MSI",
+};
+
 static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
 	struct device_node *node = dev->of_node;
-	struct irq_chip *bottom_ic, *msi_ic;
 	struct msi_domain_info *msi_di;
 	phys_addr_t msi_msg_phys;
 
 	mutex_init(&pcie->msi_used_lock);
 
-	bottom_ic = &pcie->msi_bottom_irq_chip;
-
-	bottom_ic->name = "MSI";
-	bottom_ic->irq_compose_msi_msg = advk_msi_irq_compose_msi_msg;
-	bottom_ic->irq_set_affinity = advk_msi_set_affinity;
-
-	msi_ic = &pcie->msi_irq_chip;
-	msi_ic->name = "advk-MSI";
-
 	msi_di = &pcie->msi_domain_info;
 	msi_di->flags = MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
 		MSI_FLAG_MULTI_PCI_MSI;
-	msi_di->chip = msi_ic;
+	msi_di->chip = &advk_msi_irq_chip;
 
 	msi_msg_phys = virt_to_phys(&pcie->msi_msg);
 


