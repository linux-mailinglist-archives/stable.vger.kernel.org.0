Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE8C6339A
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 11:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfGIJmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 05:42:51 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:5568 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbfGIJmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 05:42:50 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x699cLYh003072;
        Tue, 9 Jul 2019 11:42:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=Hhmk6iW9AOz9YZht32O3NNPIHCz1mwLLYsAq3kZA/eQ=;
 b=NOa5eozY9SNJGT1VQCEUJRBC+EASTP/H01RPGT9EJiKuqy+jrUk+OzqJmqzp4zGXBoUC
 v/oTa9UjqFmZ+E5UXYVCVpEwTeIWzBOCgTFTw1oX9FwmCm4acMd2JzS/KWLxPgorvEIN
 lEUBWGV/pkMmwrSABRLD9mdvoyxqCixbJbupuhl3OpsYduWGuGXngRjccj+a9ubnZCY5
 K/Npm7q/rWObonHPpB69dnZ0XWuhxI7jOSjqwNb78uyMYj/DMYIwtk1vlQM00/FQnrmg
 wESPGThwGouh10OIcUiJTdTOvuv2OwMj4PHUJgvGSKsFBLtOWll2UibDTaIrii0jphlm SA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2tjgs9vnex-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 09 Jul 2019 11:42:27 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 47D2E34;
        Tue,  9 Jul 2019 09:42:26 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag6node2.st.com [10.75.127.17])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 173FF2CE4;
        Tue,  9 Jul 2019 09:42:26 +0000 (GMT)
Received: from localhost (10.75.127.45) by SFHDAG6NODE2.st.com (10.75.127.17)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 9 Jul 2019 11:42:25
 +0200
From:   Christophe Kerello <christophe.kerello@st.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <marek.vasut@gmail.com>, <vigneshr@ti.com>
CC:     <bbrezillon@kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Christophe Kerello <christophe.kerello@st.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] mtd: rawnand: stm32_fmc2: avoid warnings when building with W=1 option
Date:   Tue, 9 Jul 2019 11:41:45 +0200
Message-ID: <1562665305-31031-1-git-send-email-christophe.kerello@st.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.45]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG6NODE2.st.com
 (10.75.127.17)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch solves warnings detected by setting W=1 when building.

Warnings type detected:
drivers/mtd/nand/raw/stm32_fmc2_nand.c: In function ‘stm32_fmc2_calc_timings’:
drivers/mtd/nand/raw/stm32_fmc2_nand.c:1417:23: warning: comparison is
always false due to limited range of data type [-Wtype-limits]
  else if (tims->twait > FMC2_PMEM_PATT_TIMING_MASK)

Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
Cc: stable@vger.kernel.org
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash
controller driver")
---
Changes in v2:
  - Fixes/stable tag added

 drivers/mtd/nand/raw/stm32_fmc2_nand.c | 90 +++++++++++-----------------------
 1 file changed, 29 insertions(+), 61 deletions(-)

diff --git a/drivers/mtd/nand/raw/stm32_fmc2_nand.c b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
index e63acc0..8cc852d 100644
--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1427,21 +1427,16 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
 	struct stm32_fmc2_timings *tims = &nand->timings;
 	unsigned long hclk = clk_get_rate(fmc2->clk);
 	unsigned long hclkp = NSEC_PER_SEC / (hclk / 1000);
-	int tar, tclr, thiz, twait, tset_mem, tset_att, thold_mem, thold_att;
-
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
+	unsigned long timing, tar, tclr, thiz, twait;
+	unsigned long tset_mem, tset_att, thold_mem, thold_att;
+
+	tar = max_t(unsigned long, hclkp, sdrt->tAR_min);
+	timing = DIV_ROUND_UP(tar, hclkp) - 1;
+	tims->tar = min_t(unsigned long, timing, FMC2_PCR_TIMING_MASK);
+
+	tclr = max_t(unsigned long, hclkp, sdrt->tCLR_min);
+	timing = DIV_ROUND_UP(tclr, hclkp) - 1;
+	tims->tclr = min_t(unsigned long, timing, FMC2_PCR_TIMING_MASK);
 
 	tims->thiz = FMC2_THIZ;
 	thiz = (tims->thiz + 1) * hclkp;
@@ -1451,18 +1446,11 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
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
@@ -1477,20 +1465,15 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
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
@@ -1500,11 +1483,8 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
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
@@ -1526,11 +1506,8 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
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
@@ -1545,17 +1522,11 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
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
@@ -1574,11 +1545,8 @@ static void stm32_fmc2_calc_timings(struct nand_chip *chip,
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
-- 
1.9.1

