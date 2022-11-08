Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826FE621426
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiKHN5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiKHN5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:57:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C15E66C96
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E87A06159E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FEFC433C1;
        Tue,  8 Nov 2022 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915863;
        bh=pxKVE1D5Zj1fQ3Aa4/VTwYrPBciQ9jH29TC0lZ2hP84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjPj/dX6bLiBHvM0mxjR3QOki7hnTZfWvHYJ7MdY1MrigfrWJkvwunzI65jTorqTF
         Lulbr7HyVdQASySDce05OtiFcwY32g7Dl7TyMyp24SQwRQZeC9l5zgoO27sxHDTo7u
         hioZcSLn6efnsGeM1TLUnpfXTtaU/x4um8xgY9NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Han Xu <han.xu@nxp.com>,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH 5.10 084/118] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times
Date:   Tue,  8 Nov 2022 14:39:22 +0100
Message-Id: <20221108133344.351592584@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 0fddf9ad06fd9f439f137139861556671673e31c upstream.

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
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -653,8 +653,9 @@ static void gpmi_nfc_compute_timings(str
 	unsigned int tRP_ps;
 	bool use_half_period;
 	int sample_delay_ps, sample_delay_factor;
-	u16 busy_timeout_cycles;
+	unsigned int busy_timeout_cycles;
 	u8 wrn_dly_sel;
+	u64 busy_timeout_ps;
 
 	if (sdr->tRC_min >= 30000) {
 		/* ONFI non-EDO modes [0-3] */
@@ -678,7 +679,8 @@ static void gpmi_nfc_compute_timings(str
 	addr_setup_cycles = TO_CYCLES(sdr->tALS_min, period_ps);
 	data_setup_cycles = TO_CYCLES(sdr->tDS_min, period_ps);
 	data_hold_cycles = TO_CYCLES(sdr->tDH_min, period_ps);
-	busy_timeout_cycles = TO_CYCLES(sdr->tWB_max + sdr->tR_max, period_ps);
+	busy_timeout_ps = max(sdr->tBERS_max, sdr->tPROG_max);
+	busy_timeout_cycles = TO_CYCLES(busy_timeout_ps, period_ps);
 
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |


