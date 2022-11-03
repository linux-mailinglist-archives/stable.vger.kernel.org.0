Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F46182F4
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiKCPeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKCPeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:34:13 -0400
Received: from finn.localdomain (finn.gateworks.com [108.161.129.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB59011C38
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 08:34:12 -0700 (PDT)
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1oqcDw-000Nj3-8T; Thu, 03 Nov 2022 15:33:44 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>, Han Xu <han.xu@nxp.com>,
        kernel <kernel@pengutronix.de>, stable <stable@vger.kernel.org>
Cc:     Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH v2 stable 5.10] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times
Date:   Thu,  3 Nov 2022 08:33:41 -0700
Message-Id: <20221103153341.2600899-1-tharvey@gateworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
v2: add sb tag and add upstream commit id
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 92e8ca56f566..200d3ab343b0 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -653,8 +653,9 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	unsigned int tRP_ps;
 	bool use_half_period;
 	int sample_delay_ps, sample_delay_factor;
-	u16 busy_timeout_cycles;
+	unsigned int busy_timeout_cycles;
 	u8 wrn_dly_sel;
+	u64 busy_timeout_ps;
 
 	if (sdr->tRC_min >= 30000) {
 		/* ONFI non-EDO modes [0-3] */
@@ -678,7 +679,8 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	addr_setup_cycles = TO_CYCLES(sdr->tALS_min, period_ps);
 	data_setup_cycles = TO_CYCLES(sdr->tDS_min, period_ps);
 	data_hold_cycles = TO_CYCLES(sdr->tDH_min, period_ps);
-	busy_timeout_cycles = TO_CYCLES(sdr->tWB_max + sdr->tR_max, period_ps);
+	busy_timeout_ps = max(sdr->tBERS_max, sdr->tPROG_max);
+	busy_timeout_cycles = TO_CYCLES(busy_timeout_ps, period_ps);
 
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
-- 
2.25.1

