Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DEC604014
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiJSJnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiJSJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9AEF5CF4;
        Wed, 19 Oct 2022 02:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5B4161807;
        Wed, 19 Oct 2022 09:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D605CC433D6;
        Wed, 19 Oct 2022 09:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170924;
        bh=5aitl3GEqiPMweqkIwJxZlH7zJawy7W/BWV5r8LclIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uO1ifnZnBCUhaOF+j0x8BAOQGx1C4kDRaPjzU23VLZnz//hp+2hmtsJjLPiHl8XfD
         y/UpEvJ2yGj3DhzWdonQhYQS4o6JXX/rzp26dnuoX1/i+3VKwSnpORujO6cvzgMnU7
         pfRnwEAgoQkhk9K38lJSQ5MXiM5eDV5grYPz2grk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 838/862] clk: bcm2835: Round UART input clock up
Date:   Wed, 19 Oct 2022 10:35:25 +0200
Message-Id: <20221019083326.915279544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f1102b4c7e88..e74fe6219d14 100644
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
@@ -993,12 +996,34 @@ static unsigned long bcm2835_clock_rate_from_divisor(struct bcm2835_clock *clock
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
@@ -1006,7 +1031,12 @@ static unsigned long bcm2835_clock_get_rate(struct clk_hw *hw,
 
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
@@ -2143,7 +2173,8 @@ static const struct bcm2835_clk_desc clk_desc_array[] = {
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



