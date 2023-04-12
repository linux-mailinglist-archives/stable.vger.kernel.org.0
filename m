Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5016DEE27
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjDLIkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjDLIjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EACD7EC7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A32C162F80
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72A5C433D2;
        Wed, 12 Apr 2023 08:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288548;
        bh=xsVNdltK1tOP4oDjAlWlPJ2n4xSkE32XTtY/BYtaMDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwNqkjw9wXCeOYV7wv/Ve4+12VEmADNdvfeO0h9U/rflT4MGU3tkbIHs1NcRts+44
         BxynNhcOVqUKqCpe+gNOOhmbpd4n5H3hxR6HyyJrCEObtZS9kjaoCxmu8Zoywnn8Kx
         o+37tsPaVKuDh6EieV0l62j25BxpEnMcmFzjitrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Dooks <ben.dooks@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/93] soc: sifive: ccache: use pr_fmt() to remove CCACHE: prefixes
Date:   Wed, 12 Apr 2023 10:33:05 +0200
Message-Id: <20230412082823.229829021@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@sifive.com>

[ Upstream commit 696ab9bda22a770d079dc3a23bac9aaa553d98f4 ]

Use the pr_fmt() macro to prefix all the output with "CCACHE:"
to avoid having to write it out each time, or make a large diff
when the next change comes along.

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Signed-off-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220913061817.22564-6-zong.li@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 17080af7dfa00..91f0c2b32ea2b 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -5,6 +5,9 @@
  * Copyright (C) 2018-2022 SiFive, Inc.
  *
  */
+
+#define pr_fmt(fmt) "CCACHE: " fmt
+
 #include <linux/debugfs.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
@@ -85,13 +88,13 @@ static void ccache_config_read(void)
 
 	cfg = readl(ccache_base + SIFIVE_CCACHE_CONFIG);
 
-	pr_info("CCACHE: %u banks, %u ways, sets/bank=%llu, bytes/block=%llu\n",
+	pr_info("%u banks, %u ways, sets/bank=%llu, bytes/block=%llu\n",
 		(cfg & 0xff), (cfg >> 8) & 0xff,
 		BIT_ULL((cfg >> 16) & 0xff),
 		BIT_ULL((cfg >> 24) & 0xff));
 
 	cfg = readl(ccache_base + SIFIVE_CCACHE_WAYENABLE);
-	pr_info("CCACHE: Index of the largest way enabled: %u\n", cfg);
+	pr_info("Index of the largest way enabled: %u\n", cfg);
 }
 
 static const struct of_device_id sifive_ccache_ids[] = {
@@ -155,7 +158,7 @@ static irqreturn_t ccache_int_handler(int irq, void *device)
 	if (irq == g_irq[DIR_CORR]) {
 		add_h = readl(ccache_base + SIFIVE_CCACHE_DIRECCFIX_HIGH);
 		add_l = readl(ccache_base + SIFIVE_CCACHE_DIRECCFIX_LOW);
-		pr_err("CCACHE: DirError @ 0x%08X.%08X\n", add_h, add_l);
+		pr_err("DirError @ 0x%08X.%08X\n", add_h, add_l);
 		/* Reading this register clears the DirError interrupt sig */
 		readl(ccache_base + SIFIVE_CCACHE_DIRECCFIX_COUNT);
 		atomic_notifier_call_chain(&ccache_err_chain,
@@ -175,7 +178,7 @@ static irqreturn_t ccache_int_handler(int irq, void *device)
 	if (irq == g_irq[DATA_CORR]) {
 		add_h = readl(ccache_base + SIFIVE_CCACHE_DATECCFIX_HIGH);
 		add_l = readl(ccache_base + SIFIVE_CCACHE_DATECCFIX_LOW);
-		pr_err("CCACHE: DataError @ 0x%08X.%08X\n", add_h, add_l);
+		pr_err("DataError @ 0x%08X.%08X\n", add_h, add_l);
 		/* Reading this register clears the DataError interrupt sig */
 		readl(ccache_base + SIFIVE_CCACHE_DATECCFIX_COUNT);
 		atomic_notifier_call_chain(&ccache_err_chain,
@@ -185,7 +188,7 @@ static irqreturn_t ccache_int_handler(int irq, void *device)
 	if (irq == g_irq[DATA_UNCORR]) {
 		add_h = readl(ccache_base + SIFIVE_CCACHE_DATECCFAIL_HIGH);
 		add_l = readl(ccache_base + SIFIVE_CCACHE_DATECCFAIL_LOW);
-		pr_err("CCACHE: DataFail @ 0x%08X.%08X\n", add_h, add_l);
+		pr_err("DataFail @ 0x%08X.%08X\n", add_h, add_l);
 		/* Reading this register clears the DataFail interrupt sig */
 		readl(ccache_base + SIFIVE_CCACHE_DATECCFAIL_COUNT);
 		atomic_notifier_call_chain(&ccache_err_chain,
@@ -218,7 +221,7 @@ static int __init sifive_ccache_init(void)
 
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
-		pr_err("CCACHE: no interrupts property\n");
+		pr_err("No interrupts property\n");
 		return -ENODEV;
 	}
 
@@ -227,7 +230,7 @@ static int __init sifive_ccache_init(void)
 		rc = request_irq(g_irq[i], ccache_int_handler, 0, "ccache_ecc",
 				 NULL);
 		if (rc) {
-			pr_err("CCACHE: Could not request IRQ %d\n", g_irq[i]);
+			pr_err("Could not request IRQ %d\n", g_irq[i]);
 			return rc;
 		}
 	}
-- 
2.39.2



