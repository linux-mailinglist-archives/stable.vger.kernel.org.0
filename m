Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DB04F47C5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiDEVUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457387AbiDEQDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:03:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF402AE1;
        Tue,  5 Apr 2022 08:40:01 -0700 (PDT)
Date:   Tue, 05 Apr 2022 15:39:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649173200;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CF1SEm6yplTkf5CDH5Ci9Fu4GP9Jj3yDWTJBOlnHqag=;
        b=BPM3DQBiWEVv2TUQShQHWjiwkWHRKQ1/lphuNCOyBIqak1pVzTtyRvgv9OFn7SHid9UCBw
        FN/VIr8UU/qS77RFf4VeOF9aS+1iX5qEY56yDErqo/KCX11QGyph+WUi3NFU5kxx3XN6uV
        lEDxuT7d4P7VCdXSzKIsdQBF3xqVZLjVDhyb1BS/gn8Mbx2frg9K/UL+o1wN6xuYaELivn
        wkBMMgHnpHERCKfWZjUbwGd834g+Ngltfzd2+inKl+jw4SYtnF0iR7QU4JansNIjsgHmPN
        MkN5lMIc9YkQktjhBtRJzrL8TzMBGhiQNifBFfPYzjkH0KW/sGuPg81WlTJrXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649173200;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CF1SEm6yplTkf5CDH5Ci9Fu4GP9Jj3yDWTJBOlnHqag=;
        b=Avy9u3VENAVlHZOVx8DcgMkKqaVf330spLReJWV9nTABk8d+MFmp1jhn4b4nNvkMi+DP6b
        nHixnOssaaRXNdBA==
From:   "irqchip-bot for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-fixes] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        tglx@linutronix.de
In-Reply-To: <20220315165034.794482-2-maz@kernel.org>
References: <20220315165034.794482-2-maz@kernel.org>
MIME-Version: 1.0
Message-ID: <164917319947.389.16591150926204042875.tip-bot2@tip-bot2>
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

The following commit has been merged into the irq/irqchip-fixes branch of irqchip:

Commit-ID:     0df6664531a12cdd8fc873f0cac0dcb40243d3e9
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/0df6664531a12cdd8fc873f0cac0dcb40243d3e9
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Tue, 15 Mar 2022 16:50:32 
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Tue, 05 Apr 2022 16:33:13 +01:00

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
