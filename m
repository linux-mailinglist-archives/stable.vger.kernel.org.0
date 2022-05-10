Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158E75219FA
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244297AbiEJNwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245087AbiEJNrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B948F238D5F;
        Tue, 10 May 2022 06:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C4FB81DAB;
        Tue, 10 May 2022 13:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AA4C385C6;
        Tue, 10 May 2022 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189708;
        bh=/VW0fGEvj9Ck3B+k87lk/yi8fq2edXK2jlcJqJUGgoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZegdJjg4CiSFpcgFGq/0KVzhX0vbfuc156p+bhhFgdpsiY0+P/TvCrdRSdrBRFCd
         fIu/mzL5SpVsfqkTDVlfs8Rl2I+WTLllDfl9P4wwr6ein/rjo+mwW51qj3AKDm59lS
         fmj7T8qdmok3JZa+yvZVuhXlV/jnfqCORM7dC2Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 129/135] PCI: aardvark: Add support for PME interrupts
Date:   Tue, 10 May 2022 15:08:31 +0200
Message-Id: <20220510130744.098872483@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1480,6 +1480,18 @@ static void advk_pcie_handle_int(struct
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


