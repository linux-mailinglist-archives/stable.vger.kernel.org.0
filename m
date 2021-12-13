Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31139472713
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhLMJ6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238907AbhLMJyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3C4C07E5E7;
        Mon, 13 Dec 2021 01:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96D54B80E0B;
        Mon, 13 Dec 2021 09:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF7DC00446;
        Mon, 13 Dec 2021 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388761;
        bh=CaGJg9L+b7+ixx5BF0mYsdNS66KsGLOlP7xuy9QgWP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGB1+sdNw8iEOLOho69itew7cM4sEGJrc9T5Y7S8GIxy9Ihmv3lDcehFElIVn0X07
         1yLfUJMBNv4w+147F0Qcw8WqczKlD3x9dvRgV043OvCyKdcu3giyXxl+Voxxsvlm5Q
         Fi/uZBzq3SaGV+FqHhtKZyVkop7Pgh+F7BDwMLBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 55/88] mtd: rawnand: fsmc: Fix timing computation
Date:   Mon, 13 Dec 2021 10:30:25 +0100
Message-Id: <20211213092935.163371544@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

commit 9472335eaa1452b51dc8e8edaa1a342997cb80c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

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
@@ -278,7 +286,7 @@ static int fsmc_calc_timings(struct fsmc
 {
 	unsigned long hclk = clk_get_rate(host->clk);
 	unsigned long hclkn = NSEC_PER_SEC / hclk;
-	u32 thiz, thold, twait, tset;
+	u32 thiz, thold, twait, tset, twait_min;
 
 	if (sdrt->tRC_min < 30000)
 		return -EOPNOTSUPP;
@@ -310,13 +318,6 @@ static int fsmc_calc_timings(struct fsmc
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
@@ -325,6 +326,21 @@ static int fsmc_calc_timings(struct fsmc
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
 


