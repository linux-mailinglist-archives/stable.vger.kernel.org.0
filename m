Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6393C531935
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbiEWRas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242065AbiEWR1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8612F7A834;
        Mon, 23 May 2022 10:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA5760916;
        Mon, 23 May 2022 17:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9215C385A9;
        Mon, 23 May 2022 17:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326520;
        bh=Qr/lYCw4/9dsMMT+lBGIKoa8ijiTrhX1E/KTvsgFOEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfqrtVyeN8vOpMtpEBmCbyiG8TKA2+6zdq6YT6piJvsuPexdf7LDSxST7tUM/icBh
         cMRzWUqzZXhCBUa8EACvTqNMEQf0Lw5vsFHoz2ITZ2oxb9+Czv9vnhtvqpxUjQQPOD
         /tqfVvq5rqI9Fr0kf9vVblLYcQHfo0y2rPVJAhs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/132] Revert "PCI: aardvark: Rewrite IRQ code to chained IRQ handler"
Date:   Mon, 23 May 2022 19:04:48 +0200
Message-Id: <20220523165836.192515032@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit a3b69dd0ad6265c29c4b6fb381cd76fb3bebdf8c ]

This reverts commit 1571d67dc190e50c6c56e8f88cdc39f7cc53166e.

This commit broke support for setting interrupt affinity. It looks like
that it is related to the chained IRQ handler. Revert this commit until
issue with setting interrupt affinity is fixed.

Fixes: 1571d67dc190 ("PCI: aardvark: Rewrite IRQ code to chained IRQ handler")
Link: https://lore.kernel.org/r/20220515125815.30157-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 48 ++++++++++++---------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ff45052cf48d..7cc2c54daad0 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -272,7 +272,6 @@ struct advk_pcie {
 		u32 actions;
 	} wins[OB_WIN_COUNT];
 	u8 wins_count;
-	int irq;
 	struct irq_domain *rp_irq_domain;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
@@ -1572,26 +1571,21 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 	}
 }
 
-static void advk_pcie_irq_handler(struct irq_desc *desc)
+static irqreturn_t advk_pcie_irq_handler(int irq, void *arg)
 {
-	struct advk_pcie *pcie = irq_desc_get_handler_data(desc);
-	struct irq_chip *chip = irq_desc_get_chip(desc);
-	u32 val, mask, status;
+	struct advk_pcie *pcie = arg;
+	u32 status;
 
-	chained_irq_enter(chip, desc);
+	status = advk_readl(pcie, HOST_CTRL_INT_STATUS_REG);
+	if (!(status & PCIE_IRQ_CORE_INT))
+		return IRQ_NONE;
 
-	val = advk_readl(pcie, HOST_CTRL_INT_STATUS_REG);
-	mask = advk_readl(pcie, HOST_CTRL_INT_MASK_REG);
-	status = val & ((~mask) & PCIE_IRQ_ALL_MASK);
+	advk_pcie_handle_int(pcie);
 
-	if (status & PCIE_IRQ_CORE_INT) {
-		advk_pcie_handle_int(pcie);
+	/* Clear interrupt */
+	advk_writel(pcie, PCIE_IRQ_CORE_INT, HOST_CTRL_INT_STATUS_REG);
 
-		/* Clear interrupt */
-		advk_writel(pcie, PCIE_IRQ_CORE_INT, HOST_CTRL_INT_STATUS_REG);
-	}
-
-	chained_irq_exit(chip, desc);
+	return IRQ_HANDLED;
 }
 
 static int advk_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
@@ -1673,7 +1667,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	struct advk_pcie *pcie;
 	struct pci_host_bridge *bridge;
 	struct resource_entry *entry;
-	int ret;
+	int ret, irq;
 
 	bridge = devm_pci_alloc_host_bridge(dev, sizeof(struct advk_pcie));
 	if (!bridge)
@@ -1759,9 +1753,17 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	if (IS_ERR(pcie->base))
 		return PTR_ERR(pcie->base);
 
-	pcie->irq = platform_get_irq(pdev, 0);
-	if (pcie->irq < 0)
-		return pcie->irq;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_irq(dev, irq, advk_pcie_irq_handler,
+			       IRQF_SHARED | IRQF_NO_THREAD, "advk-pcie",
+			       pcie);
+	if (ret) {
+		dev_err(dev, "Failed to register interrupt\n");
+		return ret;
+	}
 
 	pcie->reset_gpio = devm_gpiod_get_from_of_node(dev, dev->of_node,
 						       "reset-gpios", 0,
@@ -1818,15 +1820,12 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	irq_set_chained_handler_and_data(pcie->irq, advk_pcie_irq_handler, pcie);
-
 	bridge->sysdata = pcie;
 	bridge->ops = &advk_pcie_ops;
 	bridge->map_irq = advk_pcie_map_irq;
 
 	ret = pci_host_probe(bridge);
 	if (ret < 0) {
-		irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 		advk_pcie_remove_rp_irq_domain(pcie);
 		advk_pcie_remove_msi_irq_domain(pcie);
 		advk_pcie_remove_irq_domain(pcie);
@@ -1875,9 +1874,6 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	advk_writel(pcie, PCIE_ISR1_ALL_MASK, PCIE_ISR1_REG);
 	advk_writel(pcie, PCIE_IRQ_ALL_MASK, HOST_CTRL_INT_STATUS_REG);
 
-	/* Remove IRQ handler */
-	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
-
 	/* Remove IRQ domains */
 	advk_pcie_remove_rp_irq_domain(pcie);
 	advk_pcie_remove_msi_irq_domain(pcie);
-- 
2.35.1



