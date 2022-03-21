Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA39E4E2330
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345849AbiCUJVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 05:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345841AbiCUJVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 05:21:21 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE74F4619;
        Mon, 21 Mar 2022 02:19:56 -0700 (PDT)
Date:   Mon, 21 Mar 2022 09:19:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647854394;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tt65ZL8xhF4wrewSGkn1srAbuGS8NYTI48r/kHBjnA8=;
        b=SQpEu1umeqqoYlZ8gyMziv4NTrmnD5LR8d3UDtkd9th72+JlDGssvMD2c/FJ+694006bVq
        cB5vmT2WToQUAPaSMaNk9UO9bNbM4U9xrRF1jBGYvwAOXdLUcsotWWw/x8Z3ofgET5W///
        lug5MYus5+31w+UtrLKvSv1J94EN6000mZW1+g4Gu9NhH7RkadkRbnFesdUpRmT915hD/u
        aZkQFh9VbT1JMuNo+XhjYAXB5WpHyjGkqhOr7G09jxMhIwuUAQeCT2qZN92P0IwlGHzjoO
        R5r6XFeOUqiT4dALiZckfeTFhS8xs4hc1rwQOr6SBBdqRLcyDddhqAlEWI510Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647854394;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tt65ZL8xhF4wrewSGkn1srAbuGS8NYTI48r/kHBjnA8=;
        b=64lhmoy5uAAYItB0du58oe9UpuFF1fd06NTrYLQ3XFOcMxMR+YIC8lE7j1w51CZo9261Aa
        ek7zg52IEPq+5hBQ==
From:   "irqchip-bot for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        tglx@linutronix.de
In-Reply-To: <20220315165034.794482-2-maz@kernel.org>
References: <20220315165034.794482-2-maz@kernel.org>
MIME-Version: 1.0
Message-ID: <164785439291.389.17030931008479432629.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     c114741827436ad1f1d465f3719f77b996ea6eca
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/c114741827436ad1f1d465f3719f77b996ea6eca
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Tue, 15 Mar 2022 16:50:32 
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 21 Mar 2022 09:17:13 

irqchip/gic-v3: Fix GICR_CTLR.RWP polling

It turns out that our polling of RWP is totally wrong when checking
for it in the redistributors, as we test the *distributor* bit index,
whereas it is a different bit number in the RDs... Oopsie boo.

This is embarassing. Not only because it is wrong, but also because
it took *8 years* to notice the blunder...

Just fix the damn thing.

Fixes: 021f653791ad ("irqchip: gic-v3: Initial support for GICv3")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/20220315165034.794482-2-maz@kernel.org
---
 drivers/irqchip/irq-gic-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 0efe1a9..9b63165 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -206,11 +206,11 @@ static inline void __iomem *gic_dist_base(struct irq_data *d)
 	}
 }
 
-static void gic_do_wait_for_rwp(void __iomem *base)
+static void gic_do_wait_for_rwp(void __iomem *base, u32 bit)
 {
 	u32 count = 1000000;	/* 1s! */
 
-	while (readl_relaxed(base + GICD_CTLR) & GICD_CTLR_RWP) {
+	while (readl_relaxed(base + GICD_CTLR) & bit) {
 		count--;
 		if (!count) {
 			pr_err_ratelimited("RWP timeout, gone fishing\n");
@@ -224,13 +224,13 @@ static void gic_do_wait_for_rwp(void __iomem *base)
 /* Wait for completion of a distributor change */
 static void gic_dist_wait_for_rwp(void)
 {
-	gic_do_wait_for_rwp(gic_data.dist_base);
+	gic_do_wait_for_rwp(gic_data.dist_base, GICD_CTLR_RWP);
 }
 
 /* Wait for completion of a redistributor change */
 static void gic_redist_wait_for_rwp(void)
 {
-	gic_do_wait_for_rwp(gic_data_rdist_rd_base());
+	gic_do_wait_for_rwp(gic_data_rdist_rd_base(), GICR_CTLR_RWP);
 }
 
 #ifdef CONFIG_ARM64
