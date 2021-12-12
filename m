Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D039471AD3
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhLLOfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:35:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33132 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhLLOfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:35:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BAFB80D11
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB0C341C6;
        Sun, 12 Dec 2021 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319749;
        bh=Xb7KrINoB+/NyJSDP1VNelqRo5x6qO7/g+7xI3tD7eY=;
        h=Subject:To:Cc:From:Date:From;
        b=SqSgjRfuRmwUYPe25fODcVxg1n/hAw/0LAk+f18VQpTnSloFGS3r2KHymmAZtc2rD
         SHXXsi9/HQCZOTbFqmjs/O6zYV8sudbvwlbOZBSwgKWpSwqbeNZ0KumO8Pnlqyrcmu
         qjyF6px6OJB7JS47SBrWkfFIXpgOg+uSO1g6+ypk=
Subject: FAILED: patch "[PATCH] mtd: rawnand: fsmc: Fix timing computation" failed to apply to 4.19-stable tree
To:     herve.codina@bootlin.com, miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:35:38 +0100
Message-ID: <163931973817769@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 9472335eaa1452b51dc8e8edaa1a342997cb80c7 Mon Sep 17 00:00:00 2001
From: Herve Codina <herve.codina@bootlin.com>
Date: Fri, 19 Nov 2021 16:03:16 +0100
Subject: [PATCH] mtd: rawnand: fsmc: Fix timing computation

Under certain circumstances, the timing settings calculated by
the FSMC NAND controller driver were inaccurate.
These settings led to incorrect data reads or fallback to
timing mode 0 depending on the NAND chip used.

The timing computation did not take into account the following
constraint given in SPEAr3xx reference manual:
  twait >= tCEA - (tset * TCLK) + TOUTDEL + TINDEL

Enhance the timings calculation by taking into account this
additional constraint.

This change has no impact on slow timing modes such as mode 0.
Indeed, on mode 0, computed values are the same with and
without the patch.

NANDs which previously stayed in mode 0 because of fallback to
mode 0 can now work at higher speeds and NANDs which were not
working at all because of the corrupted data work at high
speeds without troubles.

Overall improvement on a Micron/MT29F1G08 (flash_speed tool):
                        mode0       mode3
eraseblock write speed  3220 KiB/s  4511 KiB/s
eraseblock read speed   4491 KiB/s  7529 KiB/s

Fixes: d9fb079571833 ("mtd: nand: fsmc: add support for SDR timings")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211119150316.43080-5-herve.codina@bootlin.com

diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index 0a6c9ef0ea8b..6b2bda815b88 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -94,6 +94,14 @@
 
 #define FSMC_BUSY_WAIT_TIMEOUT	(1 * HZ)
 
+/*
+ * According to SPEAr300 Reference Manual (RM0082)
+ *  TOUDEL = 7ns (Output delay from the flip-flops to the board)
+ *  TINDEL = 5ns (Input delay from the board to the flipflop)
+ */
+#define TOUTDEL	7000
+#define TINDEL	5000
+
 struct fsmc_nand_timings {
 	u8 tclr;
 	u8 tar;
@@ -278,7 +286,7 @@ static int fsmc_calc_timings(struct fsmc_nand_data *host,
 {
 	unsigned long hclk = clk_get_rate(host->clk);
 	unsigned long hclkn = NSEC_PER_SEC / hclk;
-	u32 thiz, thold, twait, tset;
+	u32 thiz, thold, twait, tset, twait_min;
 
 	if (sdrt->tRC_min < 30000)
 		return -EOPNOTSUPP;
@@ -310,13 +318,6 @@ static int fsmc_calc_timings(struct fsmc_nand_data *host,
 	else if (tims->thold > FSMC_THOLD_MASK)
 		tims->thold = FSMC_THOLD_MASK;
 
-	twait = max(sdrt->tRP_min, sdrt->tWP_min);
-	tims->twait = DIV_ROUND_UP(twait / 1000, hclkn) - 1;
-	if (tims->twait == 0)
-		tims->twait = 1;
-	else if (tims->twait > FSMC_TWAIT_MASK)
-		tims->twait = FSMC_TWAIT_MASK;
-
 	tset = max(sdrt->tCS_min - sdrt->tWP_min,
 		   sdrt->tCEA_max - sdrt->tREA_max);
 	tims->tset = DIV_ROUND_UP(tset / 1000, hclkn) - 1;
@@ -325,6 +326,21 @@ static int fsmc_calc_timings(struct fsmc_nand_data *host,
 	else if (tims->tset > FSMC_TSET_MASK)
 		tims->tset = FSMC_TSET_MASK;
 
+	/*
+	 * According to SPEAr300 Reference Manual (RM0082) which gives more
+	 * information related to FSMSC timings than the SPEAr600 one (RM0305),
+	 *   twait >= tCEA - (tset * TCLK) + TOUTDEL + TINDEL
+	 */
+	twait_min = sdrt->tCEA_max - ((tims->tset + 1) * hclkn * 1000)
+		    + TOUTDEL + TINDEL;
+	twait = max3(sdrt->tRP_min, sdrt->tWP_min, twait_min);
+
+	tims->twait = DIV_ROUND_UP(twait / 1000, hclkn) - 1;
+	if (tims->twait == 0)
+		tims->twait = 1;
+	else if (tims->twait > FSMC_TWAIT_MASK)
+		tims->twait = FSMC_TWAIT_MASK;
+
 	return 0;
 }
 

