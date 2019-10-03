Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF74CA789
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405134AbfJCQxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406276AbfJCQw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E541620862;
        Thu,  3 Oct 2019 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121577;
        bh=K5G7GDXtJXR1rzhqJ97858eW1SGJB8eZI708dTwNU90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1gr+i/tEDlUL9GnG9fmo0NVhBsLKfwpi5+EuD443Wk1WU/s/nc5DM79uxcUJpvEr
         WgRk3qbYwDRo8vlmJBzdzPD05heqqvVUkKu1dup+TccZOMiMmHvhS1cEy0K+gdknH0
         dS74ivCwuTWvsPeAq4Wv9aorAgbeMs4rzRrEYLh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@st.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.3 329/344] mtd: rawnand: stm32_fmc2: avoid warnings when building with W=1 option
Date:   Thu,  3 Oct 2019 17:54:54 +0200
Message-Id: <20191003154611.260887093@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@st.com>

commit b410f4eb01a1950ed73ae40859d0978b1a924380 upstream.

This patch solves warnings detected by setting W=1 when building.

Warnings type detected:
drivers/mtd/nand/raw/stm32_fmc2_nand.c: In function ‘stm32_fmc2_calc_timings’:
drivers/mtd/nand/raw/stm32_fmc2_nand.c:1417:23: warning: comparison is
always false due to limited range of data type [-Wtype-limits]
  else if (tims->twait > FMC2_PMEM_PATT_TIMING_MASK)

Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
Cc: stable@vger.kernel.org
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c |   88 ++++++++++-----------------------
 1 file changed, 28 insertions(+), 60 deletions(-)

--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1427,21 +1427,16 @@ static void stm32_fmc2_calc_timings(stru
 	struct stm32_fmc2_timings *tims = &nand->timings;
 	unsigned long hclk = clk_get_rate(fmc2->clk);
 	unsigned long hclkp = NSEC_PER_SEC / (hclk / 1000);
-	int tar, tclr, thiz, twait, tset_mem, tset_att, thold_mem, thold_att;
+	unsigned long timing, tar, tclr, thiz, twait;
+	unsigned long tset_mem, tset_att, thold_mem, thold_att;
 
-	tar = hclkp;
-	if (tar < sdrt->tAR_min)
-		tar = sdrt->tAR_min;
-	tims->tar = DIV_ROUND_UP(tar, hclkp) - 1;
-	if (tims->tar > FMC2_PCR_TIMING_MASK)
-		tims->tar = FMC2_PCR_TIMING_MASK;
-
-	tclr = hclkp;
-	if (tclr < sdrt->tCLR_min)
-		tclr = sdrt->tCLR_min;
-	tims->tclr = DIV_ROUND_UP(tclr, hclkp) - 1;
-	if (tims->tclr > FMC2_PCR_TIMING_MASK)
-		tims->tclr = FMC2_PCR_TIMING_MASK;
+	tar = max_t(unsigned long, hclkp, sdrt->tAR_min);
+	timing = DIV_ROUND_UP(tar, hclkp) - 1;
+	tims->tar = min_t(unsigned long, timing, FMC2_PCR_TIMING_MASK);
+
+	tclr = max_t(unsigned long, hclkp, sdrt->tCLR_min);
+	timing = DIV_ROUND_UP(tclr, hclkp) - 1;
+	tims->tclr = min_t(unsigned long, timing, FMC2_PCR_TIMING_MASK);
 
 	tims->thiz = FMC2_THIZ;
 	thiz = (tims->thiz + 1) * hclkp;
@@ -1451,18 +1446,11 @@ static void stm32_fmc2_calc_timings(stru
 	 * tWAIT > tWP
 	 * tWAIT > tREA + tIO
 	 */
-	twait = hclkp;
-	if (twait < sdrt->tRP_min)
-		twait = sdrt->tRP_min;
-	if (twait < sdrt->tWP_min)
-		twait = sdrt->tWP_min;
-	if (twait < sdrt->tREA_max + FMC2_TIO)
-		twait = sdrt->tREA_max + FMC2_TIO;
-	tims->twait = DIV_ROUND_UP(twait, hclkp);
-	if (tims->twait == 0)
-		tims->twait = 1;
-	else if (tims->twait > FMC2_PMEM_PATT_TIMING_MASK)
-		tims->twait = FMC2_PMEM_PATT_TIMING_MASK;
+	twait = max_t(unsigned long, hclkp, sdrt->tRP_min);
+	twait = max_t(unsigned long, twait, sdrt->tWP_min);
+	twait = max_t(unsigned long, twait, sdrt->tREA_max + FMC2_TIO);
+	timing = DIV_ROUND_UP(twait, hclkp);
+	tims->twait = clamp_val(timing, 1, FMC2_PMEM_PATT_TIMING_MASK);
 
 	/*
 	 * tSETUP_MEM > tCS - tWAIT
@@ -1477,20 +1465,15 @@ static void stm32_fmc2_calc_timings(stru
 	if (twait > thiz && (sdrt->tDS_min > twait - thiz) &&
 	    (tset_mem < sdrt->tDS_min - (twait - thiz)))
 		tset_mem = sdrt->tDS_min - (twait - thiz);
-	tims->tset_mem = DIV_ROUND_UP(tset_mem, hclkp);
-	if (tims->tset_mem == 0)
-		tims->tset_mem = 1;
-	else if (tims->tset_mem > FMC2_PMEM_PATT_TIMING_MASK)
-		tims->tset_mem = FMC2_PMEM_PATT_TIMING_MASK;
+	timing = DIV_ROUND_UP(tset_mem, hclkp);
+	tims->tset_mem = clamp_val(timing, 1, FMC2_PMEM_PATT_TIMING_MASK);
 
 	/*
 	 * tHOLD_MEM > tCH
 	 * tHOLD_MEM > tREH - tSETUP_MEM
 	 * tHOLD_MEM > max(tRC, tWC) - (tSETUP_MEM + tWAIT)
 	 */
-	thold_mem = hclkp;
-	if (thold_mem < sdrt->tCH_min)
-		thold_mem = sdrt->tCH_min;
+	thold_mem = max_t(unsigned long, hclkp, sdrt->tCH_min);
 	if (sdrt->tREH_min > tset_mem &&
 	    (thold_mem < sdrt->tREH_min - tset_mem))
 		thold_mem = sdrt->tREH_min - tset_mem;
@@ -1500,11 +1483,8 @@ static void stm32_fmc2_calc_timings(stru
 	if ((sdrt->tWC_min > tset_mem + twait) &&
 	    (thold_mem < sdrt->tWC_min - (tset_mem + twait)))
 		thold_mem = sdrt->tWC_min - (tset_mem + twait);
-	tims->thold_mem = DIV_ROUND_UP(thold_mem, hclkp);
-	if (tims->thold_mem == 0)
-		tims->thold_mem = 1;
-	else if (tims->thold_mem > FMC2_PMEM_PATT_TIMING_MASK)
-		tims->thold_mem = FMC2_PMEM_PATT_TIMING_MASK;
+	timing = DIV_ROUND_UP(thold_mem, hclkp);
+	tims->thold_mem = clamp_val(timing, 1, FMC2_PMEM_PATT_TIMING_MASK);
 
 	/*
 	 * tSETUP_ATT > tCS - tWAIT
@@ -1526,11 +1506,8 @@ static void stm32_fmc2_calc_timings(stru
 	if (twait > thiz && (sdrt->tDS_min > twait - thiz) &&
 	    (tset_att < sdrt->tDS_min - (twait - thiz)))
 		tset_att = sdrt->tDS_min - (twait - thiz);
-	tims->tset_att = DIV_ROUND_UP(tset_att, hclkp);
-	if (tims->tset_att == 0)
-		tims->tset_att = 1;
-	else if (tims->tset_att > FMC2_PMEM_PATT_TIMING_MASK)
-		tims->tset_att = FMC2_PMEM_PATT_TIMING_MASK;
+	timing = DIV_ROUND_UP(tset_att, hclkp);
+	tims->tset_att = clamp_val(timing, 1, FMC2_PMEM_PATT_TIMING_MASK);
 
 	/*
 	 * tHOLD_ATT > tALH
@@ -1545,17 +1522,11 @@ static void stm32_fmc2_calc_timings(stru
 	 * tHOLD_ATT > tRC - (tSETUP_ATT + tWAIT)
 	 * tHOLD_ATT > tWC - (tSETUP_ATT + tWAIT)
 	 */
-	thold_att = hclkp;
-	if (thold_att < sdrt->tALH_min)
-		thold_att = sdrt->tALH_min;
-	if (thold_att < sdrt->tCH_min)
-		thold_att = sdrt->tCH_min;
-	if (thold_att < sdrt->tCLH_min)
-		thold_att = sdrt->tCLH_min;
-	if (thold_att < sdrt->tCOH_min)
-		thold_att = sdrt->tCOH_min;
-	if (thold_att < sdrt->tDH_min)
-		thold_att = sdrt->tDH_min;
+	thold_att = max_t(unsigned long, hclkp, sdrt->tALH_min);
+	thold_att = max_t(unsigned long, thold_att, sdrt->tCH_min);
+	thold_att = max_t(unsigned long, thold_att, sdrt->tCLH_min);
+	thold_att = max_t(unsigned long, thold_att, sdrt->tCOH_min);
+	thold_att = max_t(unsigned long, thold_att, sdrt->tDH_min);
 	if ((sdrt->tWB_max + FMC2_TIO + FMC2_TSYNC > tset_mem) &&
 	    (thold_att < sdrt->tWB_max + FMC2_TIO + FMC2_TSYNC - tset_mem))
 		thold_att = sdrt->tWB_max + FMC2_TIO + FMC2_TSYNC - tset_mem;
@@ -1574,11 +1545,8 @@ static void stm32_fmc2_calc_timings(stru
 	if ((sdrt->tWC_min > tset_att + twait) &&
 	    (thold_att < sdrt->tWC_min - (tset_att + twait)))
 		thold_att = sdrt->tWC_min - (tset_att + twait);
-	tims->thold_att = DIV_ROUND_UP(thold_att, hclkp);
-	if (tims->thold_att == 0)
-		tims->thold_att = 1;
-	else if (tims->thold_att > FMC2_PMEM_PATT_TIMING_MASK)
-		tims->thold_att = FMC2_PMEM_PATT_TIMING_MASK;
+	timing = DIV_ROUND_UP(thold_att, hclkp);
+	tims->thold_att = clamp_val(timing, 1, FMC2_PMEM_PATT_TIMING_MASK);
 }
 
 static int stm32_fmc2_setup_interface(struct nand_chip *chip, int chipnr,


