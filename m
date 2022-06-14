Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB59754ABD1
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 10:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiFNIcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 04:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFNIcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 04:32:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885614162F
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 01:32:09 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o11y1-0005RE-2o; Tue, 14 Jun 2022 10:32:05 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1o11xy-000S7F-PX; Tue, 14 Jun 2022 10:32:04 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1o11xz-00EUzl-8K; Tue, 14 Jun 2022 10:32:03 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-mtd@lists.infradead.org
Cc:     Han Xu <han.xu@nxp.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        stable@vger.kernel.org
Subject: [PATCH] mtd: rawnand: gpmi: Fix setting busy timeout setting
Date:   Tue, 14 Jun 2022 10:31:38 +0200
Message-Id: <20220614083138.3455683-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The DEVICE_BUSY_TIMEOUT value is described in the Reference Manual as:

| Timeout waiting for NAND Ready/Busy or ATA IRQ. Used in WAIT_FOR_READY
| mode. This value is the number of GPMI_CLK cycles multiplied by 4096.

So instead of multiplying the value in cycles with 4096, we have to
divide it by that value. Use DIV_ROUND_UP to make sure we are on the
safe side, especially when the calculated value in cycles is smaller
than 4096 as typically the case.

This bug likely never triggered because any timeout != 0 usually will
do. In my case the busy timeout in cycles was originally calculated as
2408, which multiplied with 4096 is 0x968000. The lower 16 bits were
taken for the 16 bit wide register field, so the register value was
0x8000. With 2970bf5a32f0 ("mtd: rawnand: gpmi: fix controller timings
setting") however the value in cycles became 2384, which multiplied
with 4096 is 0x950000. The lower 16 bit are 0x0 now resulting in an
intermediate timeout when reading from NAND.

Fixes: b1206122069aa ("mtd: rawnand: gpmi: use core timings instead of an empirical derivation")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Just a resend with +Cc: stable@vger.kernel.org

 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 0b68d05846e18..889e403299568 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -890,7 +890,7 @@ static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:
-- 
2.30.2

