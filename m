Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E579157EF3F
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGWNnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiGWNnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:43:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B065D9
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 044B7B801B8
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB44C341C0;
        Sat, 23 Jul 2022 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658583816;
        bh=8yh0kG08+KgSTFs2DRrsInhgkhL5NoZgjhD9/aNEtCs=;
        h=Subject:To:Cc:From:Date:From;
        b=xoPX5A59abKrCtTD826FO+bUXVM+44dpYRxAtaaJLH9nlcZI3VEeut+k9WwQrXtR3
         kIw7psG7mkqVRKS8Z3m8r0N5l3MvL4t5g/oMe2hlp/PK1cwn030JXobffuQUs3i4Kj
         ZB4ueiLn5ZF5Ri4Go6Cf4pnmzewwwNV7PkvNY4uQ=
Subject: FAILED: patch "[PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on" failed to apply to 5.15-stable tree
To:     s.hauer@pengutronix.de, han.xu@nxp.com, richard@nod.at,
        tomasz.mon@camlingroup.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 Jul 2022 15:43:33 +0200
Message-ID: <165858381313218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0fddf9ad06fd9f439f137139861556671673e31c Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Fri, 1 Jul 2022 13:03:41 +0200
Subject: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
though: It is calculated based on the maximum page read time, but the
timeout is also used for page write and block erase operations which
require orders of magnitude bigger timeouts.

Fix this by calculating busy_timeout_cycles from the maximum of
tBERS_max and tPROG_max.

This is for now the easiest and most obvious way to fix the driver.
There's room for improvements though: The NAND_OP_WAITRDY_INSTR tells us
the desired timeout for the current operation, so we could program the
timeout dynamically for each operation instead of setting a fixed
timeout. Also we could wire up the interrupt handler to actually detect
and forward timeouts occurred when waiting for the chip being ready.

As a sidenote I verified that the change in 06781a5026350 is really
correct. I wired up the interrupt handler in my tree and measured the
time between starting the operation and the timeout interrupt handler
coming in. The time increases 41us with each step in the timeout
register which corresponds to 4096 clock cycles with the 99MHz clock
that I have.

Fixes: 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setting")
Fixes: b1206122069aa ("mtd: rawniand: gpmi: use core timings instead of an empirical derivation")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Han Xu <han.xu@nxp.com>
Tested-by: Tomasz Moń <tomasz.mon@camlingroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 889e40329956..93da23682d86 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -850,9 +850,10 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	unsigned int tRP_ps;
 	bool use_half_period;
 	int sample_delay_ps, sample_delay_factor;
-	u16 busy_timeout_cycles;
+	unsigned int busy_timeout_cycles;
 	u8 wrn_dly_sel;
 	unsigned long clk_rate, min_rate;
+	u64 busy_timeout_ps;
 
 	if (sdr->tRC_min >= 30000) {
 		/* ONFI non-EDO modes [0-3] */
@@ -885,7 +886,8 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	addr_setup_cycles = TO_CYCLES(sdr->tALS_min, period_ps);
 	data_setup_cycles = TO_CYCLES(sdr->tDS_min, period_ps);
 	data_hold_cycles = TO_CYCLES(sdr->tDH_min, period_ps);
-	busy_timeout_cycles = TO_CYCLES(sdr->tWB_max + sdr->tR_max, period_ps);
+	busy_timeout_ps = max(sdr->tBERS_max, sdr->tPROG_max);
+	busy_timeout_cycles = TO_CYCLES(busy_timeout_ps, period_ps);
 
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |

