Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6559951A9AD
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356715AbiEDRSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357412AbiEDRPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FB454BDF
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA150B827AC
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750D3C385A5;
        Wed,  4 May 2022 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683503;
        bh=xGGDPF0DTjcAr+4naN64H2tBJ0GKsH9c4Zp1Prq44W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iacq1/vglEWj1QxiJoGV+9HX1YOe/1aj0RYZzKOL8zg6x0hBnDj6cLiFGoGuXuVd5
         p7n6wnFD5VZPdlfPyuE+t7jcK5AwMARafkvmO6MesEcNKgOZtcEeFmqfewYQUtG60Y
         li9Wb3w0zZl09sCG4O7Uo/jbmdNAOfL8/dFpgkJ91cP7w26urtu7Zc5xRV4xPynXVl
         YiOK5djJF4kUFi3DN8GQD2rRyzROspwi7Tl1+kcX1FHvkqp4HzbfP3LkElNrIBJLBX
         BbGYz6sVHtxHzk7V10KBSYtKOAEuuoIWodiIl13ZlQiAoyc4+JZ4rVQtGccHru3vzN
         VSNow1+hO5bOA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 15/30] PCI: aardvark: Make MSI irq_chip structures static driver structures
Date:   Wed,  4 May 2022 18:57:40 +0200
Message-Id: <20220504165755.30002-16-kabel@kernel.org>
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
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 00fe1e6682ad..7011a4a36165 100644
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
@@ -1194,6 +1192,12 @@ static int advk_msi_set_affinity(struct irq_data *irq_data,
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
@@ -1210,7 +1214,7 @@ static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
 
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_set_info(domain, virq + i, hwirq + i,
-				    &pcie->msi_bottom_irq_chip,
+				    &advk_msi_bottom_irq_chip,
 				    domain->host_data, handle_simple_irq,
 				    NULL, NULL);
 
@@ -1280,29 +1284,23 @@ static const struct irq_domain_ops advk_pcie_irq_domain_ops = {
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
 
-- 
2.35.1

