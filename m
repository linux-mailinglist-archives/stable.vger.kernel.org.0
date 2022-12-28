Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D459657A97
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiL1PNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiL1PM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:12:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32513E04
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE42A6155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1365C433D2;
        Wed, 28 Dec 2022 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240359;
        bh=WWXPe6OSHavPDXoVgv4cyCejTfMR4/H9rhyeXOWx0so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKCbeKC9zMf0NCdcyPXmrCDrLb07wdEFDsm9nIqOzfMqQaQi4JyfLYRGfH0wjzHGw
         Xt9QAwbL7hBBKnwfOSS4oPmR/fWWKp6GQXMie1dilF6wAq6pzPfEi5XhvxMaCmKMnH
         dWkBb+TezgfDrXt4VSdrdRdEV0Vcy0aSiiU49zBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0151/1073] clocksource/drivers/sh_cmt: Access registers according to spec
Date:   Wed, 28 Dec 2022 15:28:59 +0100
Message-Id: <20221228144332.124461510@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 3f44f7156f59cae06e9160eafb5d8b2dfd09e639 ]

Documentation for most CMTs say that it takes two input clocks before
changes propagate to the timer. This is especially relevant when the timer
is stopped to change further settings.

Implement the delays according to the spec. To avoid unnecessary delays in
atomic mode, also check if the to-be-written value actually differs.

CMCNT is a bit special because testing showed that it requires 3 cycles to
propagate, which affects all CMTs. Also, the WRFLAG needs to be checked
before writing. This fixes "cannot clear CMCNT" messages which occur often
on R-Car Gen4 SoCs, but only very rarely on older SoCs for some reason.

Fixes: 81b3b2711072 ("clocksource: sh_cmt: Add support for multiple channels per device")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221130210609.7718-1-wsa+renesas@sang-engineering.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/sh_cmt.c | 88 ++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 33 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 64dcb082d4cf..7b952aa52c0b 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
@@ -116,6 +117,7 @@ struct sh_cmt_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 	unsigned long rate;
+	unsigned int reg_delay;
 
 	raw_spinlock_t lock; /* Protect the shared start/stop register */
 
@@ -247,10 +249,17 @@ static inline u32 sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 
 static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch, u32 value)
 {
-	if (ch->iostart)
-		ch->cmt->info->write_control(ch->iostart, 0, value);
-	else
-		ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
+	u32 old_value = sh_cmt_read_cmstr(ch);
+
+	if (value != old_value) {
+		if (ch->iostart) {
+			ch->cmt->info->write_control(ch->iostart, 0, value);
+			udelay(ch->cmt->reg_delay);
+		} else {
+			ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
+			udelay(ch->cmt->reg_delay);
+		}
+	}
 }
 
 static inline u32 sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
@@ -260,7 +269,12 @@ static inline u32 sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 
 static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch, u32 value)
 {
-	ch->cmt->info->write_control(ch->ioctrl, CMCSR, value);
+	u32 old_value = sh_cmt_read_cmcsr(ch);
+
+	if (value != old_value) {
+		ch->cmt->info->write_control(ch->ioctrl, CMCSR, value);
+		udelay(ch->cmt->reg_delay);
+	}
 }
 
 static inline u32 sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
@@ -268,14 +282,33 @@ static inline u32 sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 	return ch->cmt->info->read_count(ch->ioctrl, CMCNT);
 }
 
-static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch, u32 value)
+static inline int sh_cmt_write_cmcnt(struct sh_cmt_channel *ch, u32 value)
 {
+	/* Tests showed that we need to wait 3 clocks here */
+	unsigned int cmcnt_delay = DIV_ROUND_UP(3 * ch->cmt->reg_delay, 2);
+	u32 reg;
+
+	if (ch->cmt->info->model > SH_CMT_16BIT) {
+		int ret = read_poll_timeout_atomic(sh_cmt_read_cmcsr, reg,
+						   !(reg & SH_CMT32_CMCSR_WRFLG),
+						   1, cmcnt_delay, false, ch);
+		if (ret < 0)
+			return ret;
+	}
+
 	ch->cmt->info->write_count(ch->ioctrl, CMCNT, value);
+	udelay(cmcnt_delay);
+	return 0;
 }
 
 static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch, u32 value)
 {
-	ch->cmt->info->write_count(ch->ioctrl, CMCOR, value);
+	u32 old_value = ch->cmt->info->read_count(ch->ioctrl, CMCOR);
+
+	if (value != old_value) {
+		ch->cmt->info->write_count(ch->ioctrl, CMCOR, value);
+		udelay(ch->cmt->reg_delay);
+	}
 }
 
 static u32 sh_cmt_get_counter(struct sh_cmt_channel *ch, u32 *has_wrapped)
@@ -319,7 +352,7 @@ static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 
 static int sh_cmt_enable(struct sh_cmt_channel *ch)
 {
-	int k, ret;
+	int ret;
 
 	dev_pm_syscore_device(&ch->cmt->pdev->dev, true);
 
@@ -347,26 +380,9 @@ static int sh_cmt_enable(struct sh_cmt_channel *ch)
 	}
 
 	sh_cmt_write_cmcor(ch, 0xffffffff);
-	sh_cmt_write_cmcnt(ch, 0);
-
-	/*
-	 * According to the sh73a0 user's manual, as CMCNT can be operated
-	 * only by the RCLK (Pseudo 32 kHz), there's one restriction on
-	 * modifying CMCNT register; two RCLK cycles are necessary before
-	 * this register is either read or any modification of the value
-	 * it holds is reflected in the LSI's actual operation.
-	 *
-	 * While at it, we're supposed to clear out the CMCNT as of this
-	 * moment, so make sure it's processed properly here.  This will
-	 * take RCLKx2 at maximum.
-	 */
-	for (k = 0; k < 100; k++) {
-		if (!sh_cmt_read_cmcnt(ch))
-			break;
-		udelay(1);
-	}
+	ret = sh_cmt_write_cmcnt(ch, 0);
 
-	if (sh_cmt_read_cmcnt(ch)) {
+	if (ret || sh_cmt_read_cmcnt(ch)) {
 		dev_err(&ch->cmt->pdev->dev, "ch%u: cannot clear CMCNT\n",
 			ch->index);
 		ret = -ETIMEDOUT;
@@ -995,8 +1011,8 @@ MODULE_DEVICE_TABLE(of, sh_cmt_of_table);
 
 static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 {
-	unsigned int mask;
-	unsigned int i;
+	unsigned int mask, i;
+	unsigned long rate;
 	int ret;
 
 	cmt->pdev = pdev;
@@ -1032,10 +1048,16 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	if (ret < 0)
 		goto err_clk_unprepare;
 
-	if (cmt->info->width == 16)
-		cmt->rate = clk_get_rate(cmt->clk) / 512;
-	else
-		cmt->rate = clk_get_rate(cmt->clk) / 8;
+	rate = clk_get_rate(cmt->clk);
+	if (!rate) {
+		ret = -EINVAL;
+		goto err_clk_disable;
+	}
+
+	/* We shall wait 2 input clks after register writes */
+	if (cmt->info->model >= SH_CMT_48BIT)
+		cmt->reg_delay = DIV_ROUND_UP(2UL * USEC_PER_SEC, rate);
+	cmt->rate = rate / (cmt->info->width == 16 ? 512 : 8);
 
 	/* Map the memory resource(s). */
 	ret = sh_cmt_map_memory(cmt);
-- 
2.35.1



