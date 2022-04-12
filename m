Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A44FD717
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354605AbiDLH5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359232AbiDLHmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A4055775;
        Tue, 12 Apr 2022 00:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408E96153F;
        Tue, 12 Apr 2022 07:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FC8C385A1;
        Tue, 12 Apr 2022 07:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748049;
        bh=Jh0HxlaHDCPkrzXaR6A0TjXlWJhTiro1dmjnLAkCRbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWIROBpHZbSO+lNDwRvJOnMnTjHgWvwEs0B3PPiZnhs1k6nU1EZ2TtUQ3/Ieh71E0
         sNAaB/ofpKN4RyQVEdM7M+DXqAGPWDaKJmOASXP9Txnz2oOaK5lUPNxdlvtPWF8SQN
         eLcsNmW3wAT3FYOxX6B7u3pOX/Zh4+RmZehZSsKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.17 301/343] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Date:   Tue, 12 Apr 2022 08:31:59 +0200
Message-Id: <20220412063000.011949903@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 0df6664531a12cdd8fc873f0cac0dcb40243d3e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -206,11 +206,11 @@ static inline void __iomem *gic_dist_bas
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
@@ -224,13 +224,13 @@ static void gic_do_wait_for_rwp(void __i
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


