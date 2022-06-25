Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150FE55AB07
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiFYObm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiFYObm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368EE17E01
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C480D61454
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F6C3411C;
        Sat, 25 Jun 2022 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656167499;
        bh=yCZ19EvjyWXzS45XMoTB0bN2ecI7gxGYneSY7Tm3+AQ=;
        h=Subject:To:Cc:From:Date:From;
        b=JCl/ifayz53pEA5MJKnVfmG34wPX1azBcG6toy6fV7TGrIIMHX587iol+594le3M+
         YSeoHu1G/70thNav1dDGaD+gLvSbkOLSL1GVyujRihso+z6z4KOkjXKXJQQ1qSGP6G
         4mWqhvwTw8Wol9RQMuvGgKKxGzBeaQ4Vtl7Vt2ho=
Subject: FAILED: patch "[PATCH] mtd: rawnand: gpmi: Fix setting busy timeout setting" failed to apply to 4.19-stable tree
To:     s.hauer@pengutronix.de, miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:31:36 +0200
Message-ID: <16561674962311@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 06781a5026350cde699d2d10c9914a25c1524f45 Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 14 Jun 2022 10:31:38 +0200
Subject: [PATCH] mtd: rawnand: gpmi: Fix setting busy timeout setting

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
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220614083138.3455683-1-s.hauer@pengutronix.de

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 0b68d05846e1..889e40329956 100644
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

