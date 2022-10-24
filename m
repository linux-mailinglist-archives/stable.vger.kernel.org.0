Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D8C60B2CD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiJXQvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbiJXQts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688321C939;
        Mon, 24 Oct 2022 08:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21FBAB81A1D;
        Mon, 24 Oct 2022 12:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1F8C433D6;
        Mon, 24 Oct 2022 12:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616119;
        bh=dGzsi4pDI1Jp9PjrvwwEhtLRXOy69barBNPW9yRhwBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Padg/s8LJJLKsx1K9vWm40og14de9j9Prpkj0+M3sBpZD098n72m1Db3ySUnjJg51
         lanZ98vXq3O7IIQ9Es6t7vCJpWrpF5F1qbk8ALEeQX5vcBILy0CE/LRz2baFpvFS2J
         QxzCjhhTN6uRpzhRSBg/43dTCrN13vqCskoYur9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/530] clk: bcm2835: Round UART input clock up
Date:   Mon, 24 Oct 2022 13:34:13 +0200
Message-Id: <20221024113108.075605977@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan T. Ivanov <iivanov@suse.de>

[ Upstream commit f690a4d7a8f66430662975511c86819dc9965bcc ]

It was reported that RPi3[1] and RPi Zero 2W boards have issues with
the Bluetooth. It turns out that when switching from initial to
operation speed host and device no longer can talk each other because
host uses incorrect UART baud rate.

The UART driver used in this case is amba-pl011. Original fix, see
below Github link[2], was inside pl011 module, but somehow it didn't
look as the right place to fix. Beside that this original rounding
function is not exactly perfect for all possible clock values. So I
deiced to move the hack to the platform which actually need it.

The UART clock is initialised to be as close to the requested
frequency as possible without exceeding it. Now that there is a
clock manager that returns the actual frequencies, an expected
48MHz clock is reported as 47999625. If the requested baud rate
== requested clock/16, there is no headroom and the slight
reduction in actual clock rate results in failure.

If increasing a clock by less than 0.1% changes it from ..999..
to ..000.., round it up.

[1] https://bugzilla.suse.com/show_bug.cgi?id=1188238
[2] https://github.com/raspberrypi/linux/commit/ab3f1b39537f6d3825b8873006fbe2fc5ff057b7

Cc: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20220912081306.24662-1-iivanov@suse.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index f17b65d546e9..141ce19bc570 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -502,6 +503,8 @@ struct bcm2835_clock_data {
 	bool low_jitter;
 
 	u32 tcnt_mux;
+
+	bool round_up;
 };
 
 struct bcm2835_gate_data {
@@ -994,12 +997,34 @@ static unsigned long bcm2835_clock_rate_from_divisor(struct bcm2835_clock *clock
 	return temp;
 }
 
+static unsigned long bcm2835_round_rate(unsigned long rate)
+{
+	unsigned long scaler;
+	unsigned long limit;
+
+	limit = rate / 100000;
+
+	scaler = 1;
+	while (scaler < limit)
+		scaler *= 10;
+
+	/*
+	 * If increasing a clock by less than 0.1% changes it
+	 * from ..999.. to ..000.., round up.
+	 */
+	if ((rate + scaler - 1) / scaler % 1000 == 0)
+		rate = roundup(rate, scaler);
+
+	return rate;
+}
+
 static unsigned long bcm2835_clock_get_rate(struct clk_hw *hw,
 					    unsigned long parent_rate)
 {
 	struct bcm2835_clock *clock = bcm2835_clock_from_hw(hw);
 	struct bcm2835_cprman *cprman = clock->cprman;
 	const struct bcm2835_clock_data *data = clock->data;
+	unsigned long rate;
 	u32 div;
 
 	if (data->int_bits == 0 && data->frac_bits == 0)
@@ -1007,7 +1032,12 @@ static unsigned long bcm2835_clock_get_rate(struct clk_hw *hw,
 
 	div = cprman_read(cprman, data->div_reg);
 
-	return bcm2835_clock_rate_from_divisor(clock, parent_rate, div);
+	rate = bcm2835_clock_rate_from_divisor(clock, parent_rate, div);
+
+	if (data->round_up)
+		rate = bcm2835_round_rate(rate);
+
+	return rate;
 }
 
 static void bcm2835_clock_wait_busy(struct bcm2835_clock *clock)
@@ -2144,7 +2174,8 @@ static const struct bcm2835_clk_desc clk_desc_array[] = {
 		.div_reg = CM_UARTDIV,
 		.int_bits = 10,
 		.frac_bits = 12,
-		.tcnt_mux = 28),
+		.tcnt_mux = 28,
+		.round_up = true),
 
 	/* TV encoder clock.  Only operating frequency is 108Mhz.  */
 	[BCM2835_CLOCK_VEC]	= REGISTER_PER_CLK(
-- 
2.35.1



