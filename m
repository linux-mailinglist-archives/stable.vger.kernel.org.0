Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7382A51AA1D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356593AbiEDRVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357820AbiEDRPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9676E554A1
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1AA0B827A7
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6459FC385B3;
        Wed,  4 May 2022 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683539;
        bh=FyUzATSN42WowRLu1VHLzhqJBmINwknsRiRWvGTZk6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOXogAbubYdHPm8XWpHOMPZguN+10h2YQNKRcHwmi4rn4nPFTZ9id5ibqVPOfrQB5
         n+zxTizxYUJ6zHC6OvYQ1ZuZ1/uTLprWG76ATxQL2m4tt1ziv+Ry+OXR6mdw3vZU+u
         dVHo0DhEFGFHLFzjry7K0jclWlUXz/XreZWI8OdpZ+9Uafbyld0T8mLUiTeel7O3BX
         cHKEparKJSVSSbygZMqD2wwyNOKR3AQQKjdtiRWZvkOF9qCmgMnQ5/62utdqBFcfdV
         Tee3PiDIZp0QShUt04KSLiY0/rbppFbia4H5puM/hCfXIXBUJ5KIDsWNn5Y8HrrALm
         I8SyzsNqWfRMw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 02/19] PCI: aardvark: Rewrite IRQ code to chained IRQ handler
Date:   Wed,  4 May 2022 18:58:35 +0200
Message-Id: <20220504165852.30089-3-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165852.30089-1-kabel@kernel.org>
References: <20220504165852.30089-1-kabel@kernel.org>
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

commit 1571d67dc190e50c6c56e8f88cdc39f7cc53166e upstream.

Rewrite the code to use irq_set_chained_handler_and_data() handler with
chained_irq_enter() and chained_irq_exit() processing instead of using
devm_request_irq().

advk_pcie_irq_handler() reads IRQ status bits and calls other functions
based on which bits are set. These functions then read its own IRQ status
bits and calls other aardvark functions based on these bits. Finally
generic_handle_domain_irq() with translated linux IRQ numbers are called.

Link: https://lore.kernel.org/r/20220110015018.26359-5-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 48 +++++++++++++++------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 250ab1ce098d..73ffe9ae3bf6 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -268,6 +268,7 @@ struct advk_pcie {
 		u32 actions;
 	} wins[OB_WIN_COUNT];
 	u8 wins_count;
+	int irq;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
 	raw_spinlock_t irq_lock;
@@ -1430,21 +1431,26 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 	}
 }
 
-static irqreturn_t advk_pcie_irq_handler(int irq, void *arg)
+static void advk_pcie_irq_handler(struct irq_desc *desc)
 {
-	struct advk_pcie *pcie = arg;
-	u32 status;
+	struct advk_pcie *pcie = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	u32 val, mask, status;
 
-	status = advk_readl(pcie, HOST_CTRL_INT_STATUS_REG);
-	if (!(status & PCIE_IRQ_CORE_INT))
-		return IRQ_NONE;
+	chained_irq_enter(chip, desc);
 
-	advk_pcie_handle_int(pcie);
+	val = advk_readl(pcie, HOST_CTRL_INT_STATUS_REG);
+	mask = advk_readl(pcie, HOST_CTRL_INT_MASK_REG);
+	status = val & ((~mask) & PCIE_IRQ_ALL_MASK);
 
-	/* Clear interrupt */
-	advk_writel(pcie, PCIE_IRQ_CORE_INT, HOST_CTRL_INT_STATUS_REG);
+	if (status & PCIE_IRQ_CORE_INT) {
+		advk_pcie_handle_int(pcie);
 
-	return IRQ_HANDLED;
+		/* Clear interrupt */
+		advk_writel(pcie, PCIE_IRQ_CORE_INT, HOST_CTRL_INT_STATUS_REG);
+	}
+
+	chained_irq_exit(chip, desc);
 }
 
 static void __maybe_unused advk_pcie_disable_phy(struct advk_pcie *pcie)
@@ -1511,7 +1517,7 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	struct advk_pcie *pcie;
 	struct pci_host_bridge *bridge;
 	struct resource_entry *entry;
-	int ret, irq;
+	int ret;
 
 	bridge = devm_pci_alloc_host_bridge(dev, sizeof(struct advk_pcie));
 	if (!bridge)
@@ -1597,17 +1603,9 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	if (IS_ERR(pcie->base))
 		return PTR_ERR(pcie->base);
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_irq(dev, irq, advk_pcie_irq_handler,
-			       IRQF_SHARED | IRQF_NO_THREAD, "advk-pcie",
-			       pcie);
-	if (ret) {
-		dev_err(dev, "Failed to register interrupt\n");
-		return ret;
-	}
+	pcie->irq = platform_get_irq(pdev, 0);
+	if (pcie->irq < 0)
+		return pcie->irq;
 
 	pcie->reset_gpio = devm_gpiod_get_from_of_node(dev, dev->of_node,
 						       "reset-gpios", 0,
@@ -1656,11 +1654,14 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	irq_set_chained_handler_and_data(pcie->irq, advk_pcie_irq_handler, pcie);
+
 	bridge->sysdata = pcie;
 	bridge->ops = &advk_pcie_ops;
 
 	ret = pci_host_probe(bridge);
 	if (ret < 0) {
+		irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 		advk_pcie_remove_msi_irq_domain(pcie);
 		advk_pcie_remove_irq_domain(pcie);
 		return ret;
@@ -1708,6 +1709,9 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	advk_writel(pcie, PCIE_ISR1_ALL_MASK, PCIE_ISR1_REG);
 	advk_writel(pcie, PCIE_IRQ_ALL_MASK, HOST_CTRL_INT_STATUS_REG);
 
+	/* Remove IRQ handler */
+	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
+
 	/* Remove IRQ domains */
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
-- 
2.35.1

