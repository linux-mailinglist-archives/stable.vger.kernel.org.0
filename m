Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BFA51AA40
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356386AbiEDRWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357550AbiEDRPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E22354FB8
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3BBA616AC
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D13C385C4;
        Wed,  4 May 2022 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683521;
        bh=LbdFsUVPQuQKXf29wiQKo3pV0naA4dA9/eLYOgK2KzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoxeEbGh/ZfbML69m49WpN0wlZduv6WoNiIH5HXW6ioIuinF10+YONMOXdR/JTaYA
         kskfFGn64i5h1kz8Bz0jWPB6zqW4559B+nI4W3p+T1m0Vp14GWUttghG73R+B1hiFM
         Cmpkbu4FkNh21vVfxwI2uixPDf5h4Vno9DV3CJV4Ckh9QXaJF4uDc6jQhdc5NCLrRT
         dUr4gN50k3sGbqpasmmXNxHt+EWg6bGxlnvWOoG3ic4/4VnI6nnmW/IIPOx9ru0mj+
         fDV/VFTZ7i+y+wt5IMTdJfdjj3Q6pIDgDE0BUXlThhvTD9JTYCJapddmwaKD375Gdk
         mXg3PPYkGrUKw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 26/30] PCI: aardvark: Use separate INTA interrupt for emulated root bridge
Date:   Wed,  4 May 2022 18:57:51 +0200
Message-Id: <20220504165755.30002-27-kabel@kernel.org>
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

commit 815bc313686783e3a1823ec0efc332c70e6bd976 upstream.

Emulated root bridge currently provides only one Legacy INTA interrupt
which is used for reporting PCIe PME and ERR events and handled by kernel
PCIe PME and AER drivers.

Aardvark HW reports these PME and ERR events separately, so there is no
need to mix real INTA interrupt and emulated INTA interrupt for PCIe PME
and AER drivers.

Register a new advk-RP (as in Root Port) irq chip and a new irq domain
for emulated root bridge and use this new separate irq domain for
providing INTA interrupt from emulated root bridge for PME and ERR events.

The real INTA interrupt from real devices is now separate.

A custom map_irq callback function on PCI host bridge structure is used to
allocate IRQ mapping for emulated root bridge from new irq domain. Original
callback of_irq_parse_and_map_pci() is used for all other devices as before.

Link: https://lore.kernel.org/r/20220110015018.26359-19-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 69 ++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 1943e7e312ab..39fa8af01671 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -273,6 +273,7 @@ struct advk_pcie {
 	} wins[OB_WIN_COUNT];
 	u8 wins_count;
 	int irq;
+	struct irq_domain *rp_irq_domain;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
 	raw_spinlock_t irq_lock;
@@ -1436,6 +1437,44 @@ static void advk_pcie_remove_irq_domain(struct advk_pcie *pcie)
 	irq_domain_remove(pcie->irq_domain);
 }
 
+static struct irq_chip advk_rp_irq_chip = {
+	.name = "advk-RP",
+};
+
+static int advk_pcie_rp_irq_map(struct irq_domain *h,
+				unsigned int virq, irq_hw_number_t hwirq)
+{
+	struct advk_pcie *pcie = h->host_data;
+
+	irq_set_chip_and_handler(virq, &advk_rp_irq_chip, handle_simple_irq);
+	irq_set_chip_data(virq, pcie);
+
+	return 0;
+}
+
+static const struct irq_domain_ops advk_pcie_rp_irq_domain_ops = {
+	.map = advk_pcie_rp_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static int advk_pcie_init_rp_irq_domain(struct advk_pcie *pcie)
+{
+	pcie->rp_irq_domain = irq_domain_add_linear(NULL, 1,
+						    &advk_pcie_rp_irq_domain_ops,
+						    pcie);
+	if (!pcie->rp_irq_domain) {
+		dev_err(&pcie->pdev->dev, "Failed to add Root Port IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void advk_pcie_remove_rp_irq_domain(struct advk_pcie *pcie)
+{
+	irq_domain_remove(pcie->rp_irq_domain);
+}
+
 static void advk_pcie_handle_pme(struct advk_pcie *pcie)
 {
 	u32 requester = advk_readl(pcie, PCIE_MSG_LOG_REG) >> 16;
@@ -1457,7 +1496,7 @@ static void advk_pcie_handle_pme(struct advk_pcie *pcie)
 		if (!(le16_to_cpu(pcie->bridge.pcie_conf.rootctl) & PCI_EXP_RTCTL_PMEIE))
 			return;
 
-		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+		if (generic_handle_domain_irq(pcie->rp_irq_domain, 0) == -EINVAL)
 			dev_err_ratelimited(&pcie->pdev->dev, "unhandled PME IRQ\n");
 	}
 }
@@ -1509,7 +1548,7 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 		 * Aardvark HW returns zero for PCI_ERR_ROOT_AER_IRQ, so use
 		 * PCIe interrupt 0
 		 */
-		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+		if (generic_handle_domain_irq(pcie->rp_irq_domain, 0) == -EINVAL)
 			dev_err_ratelimited(&pcie->pdev->dev, "unhandled ERR IRQ\n");
 	}
 
@@ -1553,6 +1592,21 @@ static void advk_pcie_irq_handler(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
+static int advk_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct advk_pcie *pcie = dev->bus->sysdata;
+
+	/*
+	 * Emulated root bridge has its own emulated irq chip and irq domain.
+	 * Argument pin is the INTx pin (1=INTA, 2=INTB, 3=INTC, 4=INTD) and
+	 * hwirq for irq_create_mapping() is indexed from zero.
+	 */
+	if (pci_is_root_bus(dev->bus))
+		return irq_create_mapping(pcie->rp_irq_domain, pin - 1);
+	else
+		return of_irq_parse_and_map_pci(dev, slot, pin);
+}
+
 static void __maybe_unused advk_pcie_disable_phy(struct advk_pcie *pcie)
 {
 	phy_power_off(pcie->phy);
@@ -1754,14 +1808,24 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = advk_pcie_init_rp_irq_domain(pcie);
+	if (ret) {
+		dev_err(dev, "Failed to initialize irq\n");
+		advk_pcie_remove_msi_irq_domain(pcie);
+		advk_pcie_remove_irq_domain(pcie);
+		return ret;
+	}
+
 	irq_set_chained_handler_and_data(pcie->irq, advk_pcie_irq_handler, pcie);
 
 	bridge->sysdata = pcie;
 	bridge->ops = &advk_pcie_ops;
+	bridge->map_irq = advk_pcie_map_irq;
 
 	ret = pci_host_probe(bridge);
 	if (ret < 0) {
 		irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
+		advk_pcie_remove_rp_irq_domain(pcie);
 		advk_pcie_remove_msi_irq_domain(pcie);
 		advk_pcie_remove_irq_domain(pcie);
 		return ret;
@@ -1813,6 +1877,7 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 
 	/* Remove IRQ domains */
+	advk_pcie_remove_rp_irq_domain(pcie);
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 
-- 
2.35.1

