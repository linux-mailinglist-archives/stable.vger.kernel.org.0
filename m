Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18055521B2B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244501AbiEJOI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344251AbiEJOHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4622108AA;
        Tue, 10 May 2022 06:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4CA618E6;
        Tue, 10 May 2022 13:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D183EC385A6;
        Tue, 10 May 2022 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190123;
        bh=TTrhFrNvC9hgLfiLdrKUwZrPPrNeRkdEBmCBSa+m7I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M05MuQe2h/jTqRQtlhdRyLeN6QHMtlG/3tqSxGwkLyudxLLOvxRtc2dmGRWUfgH0k
         6Od0Tw/U8/KR1jxNbALWOGhY7b+yM+0DG4YZNq738dZZ+aULO4z8tMKnFrSF0u4kfi
         4AgucuxIA9MhwL8b1f1/AaiyKRaFNANFwCEH0aTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.17 136/140] PCI: aardvark: Use separate INTA interrupt for emulated root bridge
Date:   Tue, 10 May 2022 15:08:46 +0200
Message-Id: <20220510130745.478359983@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   69 +++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 2 deletions(-)

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
@@ -1434,6 +1435,44 @@ static void advk_pcie_remove_irq_domain(
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
@@ -1455,7 +1494,7 @@ static void advk_pcie_handle_pme(struct
 		if (!(le16_to_cpu(pcie->bridge.pcie_conf.rootctl) & PCI_EXP_RTCTL_PMEIE))
 			return;
 
-		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+		if (generic_handle_domain_irq(pcie->rp_irq_domain, 0) == -EINVAL)
 			dev_err_ratelimited(&pcie->pdev->dev, "unhandled PME IRQ\n");
 	}
 }
@@ -1507,7 +1546,7 @@ static void advk_pcie_handle_int(struct
 		 * Aardvark HW returns zero for PCI_ERR_ROOT_AER_IRQ, so use
 		 * PCIe interrupt 0
 		 */
-		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+		if (generic_handle_domain_irq(pcie->rp_irq_domain, 0) == -EINVAL)
 			dev_err_ratelimited(&pcie->pdev->dev, "unhandled ERR IRQ\n");
 	}
 
@@ -1551,6 +1590,21 @@ static void advk_pcie_irq_handler(struct
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
@@ -1752,14 +1806,24 @@ static int advk_pcie_probe(struct platfo
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
@@ -1811,6 +1875,7 @@ static int advk_pcie_remove(struct platf
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 
 	/* Remove IRQ domains */
+	advk_pcie_remove_rp_irq_domain(pcie);
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 


