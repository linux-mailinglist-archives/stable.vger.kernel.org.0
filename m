Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333154FD766
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353186AbiDLH2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351701AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F49615FD6;
        Mon, 11 Apr 2022 23:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 540C1B81B46;
        Tue, 12 Apr 2022 06:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DF5C385A6;
        Tue, 12 Apr 2022 06:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746309;
        bh=Jh0HxlaHDCPkrzXaR6A0TjXlWJhTiro1dmjnLAkCRbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Anl/4Tqcs6dOvkWsRolH4YTPc3pvNMxzl/3J8WW4ggdWE2bFffq0aP0Yad7Kln7SG
         ecH+0K8sG+7unxecOGwiTl8EUBNINGYrEputGO0LEhKtmAfxNJzL+0YoJJs1RGw6qF
         Wf5Mff+nA5ZZdZbdwQiIihYv49LgIIUUoyQisGos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 237/277] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Date:   Tue, 12 Apr 2022 08:30:40 +0200
Message-Id: <20220412062948.902442685@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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


