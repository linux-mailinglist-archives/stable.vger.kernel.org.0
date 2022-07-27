Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA345582E57
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbiG0RLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241545AbiG0RKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFF55B05D;
        Wed, 27 Jul 2022 09:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC061601C0;
        Wed, 27 Jul 2022 16:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64CBC433C1;
        Wed, 27 Jul 2022 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940085;
        bh=nd8DyLqag7jTxEYrgZmLlRg8gkbWYfUvoQZaK/Chyxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWty93t8hkawQJiMM2K8hJCr3kGXIDQOg6M/sRzuH8MEJNg573KTE+lFKlRha1/Qz
         rqB3QzlyUmDeiyedc5WvU3HIhPEZD4y/JXoQTLwQ2iHWhCuEd7GnKz57s7ecC6iMPK
         1vdt0I+Nh4PgaQr6FID0jNnDF/bx1whRAHaauaOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Han Xu <han.xu@nxp.com>,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/201] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times
Date:   Wed, 27 Jul 2022 18:09:36 +0200
Message-Id: <20220727161029.918070306@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 0fddf9ad06fd9f439f137139861556671673e31c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 62f4988c2a5f..aef722dfdef5 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -655,9 +655,10 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
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
@@ -690,7 +691,8 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	addr_setup_cycles = TO_CYCLES(sdr->tALS_min, period_ps);
 	data_setup_cycles = TO_CYCLES(sdr->tDS_min, period_ps);
 	data_hold_cycles = TO_CYCLES(sdr->tDH_min, period_ps);
-	busy_timeout_cycles = TO_CYCLES(sdr->tWB_max + sdr->tR_max, period_ps);
+	busy_timeout_ps = max(sdr->tBERS_max, sdr->tPROG_max);
+	busy_timeout_cycles = TO_CYCLES(busy_timeout_ps, period_ps);
 
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
-- 
2.35.1



