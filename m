Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADE84DA06D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 17:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350198AbiCOQv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 12:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350192AbiCOQv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 12:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331945715E;
        Tue, 15 Mar 2022 09:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0ECF6150C;
        Tue, 15 Mar 2022 16:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1339CC340F4;
        Tue, 15 Mar 2022 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647363043;
        bh=DLkgOaHA7X05ej4y1HzFD8hVwJioUhOuvlYG1ioWxlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGdIHrwzla74JRUbBhrpwH1GfAcq/po8n5QsxHfrGUifnI0RZgs5B3iZqJKEcD+J8
         fPiWLvFudoImXGBqYRLB1ff8rTfzXswdEt67KIc2Bdu+3wOlGQjhZd2tBA4vIJVP0t
         A0nnJIrAeyl+t+N+MlCy4Qh9iQH+pB4SFbqYgmAZbiMYoitSjmN9V3FGAaNmXAe/78
         sxxDre9/nDbWZN49kXToY70QlDCF8m+N0gDiGyAi2dSKzF76hfuaRPcC6xyw2qooSg
         vxbV2xxrKwbZsDdgeDS5U+bnWJOcMV2gQCbqEruHLwwcGaj/4EH74CEGWSvSZZUYaR
         tFZrbjJppoiIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nUANc-00EhkO-W5; Tue, 15 Mar 2022 16:50:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Date:   Tue, 15 Mar 2022 16:50:32 +0000
Message-Id: <20220315165034.794482-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315165034.794482-1-maz@kernel.org>
References: <20220315165034.794482-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, andre.przywara@arm.com, tglx@linutronix.de, eric.auger@redhat.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns out that our polling of RWP is totally wrong when checking
for it in the redistributors, as we test the *distributor* bit index,
whereas it is a different bit number in the RDs... Oopsie boo.

This is embarassing. Not only because it is wrong, but also because
it took *8 years* to notice the blunder...

Just fix the damn thing.

Fixes: 021f653791ad ("irqchip: gic-v3: Initial support for GICv3")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/irqchip/irq-gic-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 5e935d97207d..736163d36b13 100644
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
-- 
2.34.1

