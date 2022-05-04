Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11DE51AA29
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354351AbiEDRVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357504AbiEDRPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F302354FA4
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72206B827A1
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E0C385B4;
        Wed,  4 May 2022 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683518;
        bh=ZSxPyRi7K10IeKlxM/Md5ciEHwx6cuUsJTXroKX4QZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnYLKFHbRJxNhmsU0DKIPdSxIuOTK0gZG24Ne3+vdbaQW2pNhI8ACDUI2qy4ado6R
         nI1/9cVAYswSzBk4z3gG9OFwyZYS5Go7eR9L1wiPdyeH2WltJzHwWVLB1hDcVL8PW5
         PZy2yrTveYGE4kfUx7PXK7qdKdnpBDy4sG8htWM4/C/t9HZKnHZHfS+/c6N6sLdfSP
         F+RaYMJZF4jG14G5WdDxLg6Pcb/NiCBlRCvA5MdIxXvsRB8njX+mR4XtM8t9o7g7OS
         9G+aPLkWJ80oopneYiep95wH35Mms18mQvmg8YGSr7ymb6/pusD4A+cbd5r6jKbJH0
         L5ehgo1hNC9UQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 24/30] PCI: aardvark: Add support for PME interrupts
Date:   Wed,  4 May 2022 18:57:49 +0200
Message-Id: <20220504165755.30002-25-kabel@kernel.org>
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

commit 0fc75d87454195885bd1a81fc7e6ce92572b6109 upstream.

Currently enabling PCI_EXP_RTSTA_PME bit in PCI_EXP_RTCTL register does
nothing. This is because PCIe PME driver expects to receive PCIe interrupt
defined in PCI_EXP_FLAGS_IRQ register, but aardvark hardware does not
trigger PCIe INTx/MSI interrupt for PME event, rather it triggers custom
aardvark interrupt which this driver is not processing yet.

Fix this issue by handling PME interrupt in advk_pcie_handle_int() and
chaining it to PCIe interrupt 0 with generic_handle_domain_irq() (since
aardvark sets PCI_EXP_FLAGS_IRQ to zero). With this change PCIe PME driver
finally starts receiving PME interrupt.

Link: https://lore.kernel.org/r/20220110015018.26359-17-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ba641dc84bd3..42b6f9e2c043 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1480,6 +1480,18 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
 
+	/* Process PME interrupt */
+	if (isr0_status & PCIE_MSG_PM_PME_MASK) {
+		/*
+		 * Do not clear PME interrupt bit in ISR0, it is cleared by IRQ
+		 * receiver by writing to the PCI_EXP_RTSTA register of emulated
+		 * root bridge. Aardvark HW returns zero for PCI_EXP_FLAGS_IRQ,
+		 * so use PCIe interrupt 0.
+		 */
+		if (generic_handle_domain_irq(pcie->irq_domain, 0) == -EINVAL)
+			dev_err_ratelimited(&pcie->pdev->dev, "unhandled PME IRQ\n");
+	}
+
 	/* Process ERR interrupt */
 	if (isr0_status & PCIE_ISR0_ERR_MASK) {
 		advk_writel(pcie, PCIE_ISR0_ERR_MASK, PCIE_ISR0_REG);
-- 
2.35.1

