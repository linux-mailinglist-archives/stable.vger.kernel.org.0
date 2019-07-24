Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89257399F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387671AbfGXTmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389834AbfGXTmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F4822ADA;
        Wed, 24 Jul 2019 19:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997321;
        bh=SId4K2cFmjdhd5VZIhsrvgrFi1MmSX8Rc8Y7/PgXWpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uR+VmuOI0bqScZEXBZlXAYRAgjOedYLij4+qFt0OSZCA8y8vIrpDDNuiC+Qb54e0p
         KhSWMHMfLiOU2AVNTJZaMWsrDZORtn1KJSVj2Ei84iL6HYv/VB56ZvQ9zR8Bpq/kg0
         /uDWkBFAwtZqMOGLYQK6l6OQXAdG1R/FLWHsrpNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Li <xiaolei.li@mediatek.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.2 397/413] mtd: rawnand: mtk: Correct low level time calculation of r/w cycle
Date:   Wed, 24 Jul 2019 21:21:28 +0200
Message-Id: <20190724191803.335129516@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolei Li <xiaolei.li@mediatek.com>

commit e1884ffddacc0424d7e785e6f8087bd12f7196db upstream.

At present, the flow of calculating AC timing of read/write cycle in SDR
mode is that:
At first, calculate high hold time which is valid for both read and write
cycle using the max value between tREH_min and tWH_min.
Secondly, calculate WE# pulse width using tWP_min.
Thridly, calculate RE# pulse width using the bigger one between tREA_max
and tRP_min.

But NAND SPEC shows that Controller should also meet write/read cycle time.
That is write cycle time should be more than tWC_min and read cycle should
be more than tRC_min. Obviously, we do not achieve that now.

This patch corrects the low level time calculation to meet minimum
read/write cycle time required. After getting the high hold time, WE# low
level time will be promised to meet tWP_min and tWC_min requirement,
and RE# low level time will be promised to meet tREA_max, tRP_min and
tRC_min requirement.

Fixes: edfee3619c49 ("mtd: nand: mtk: add ->setup_data_interface() hook")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Xiaolei Li <xiaolei.li@mediatek.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/mtk_nand.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -500,7 +500,8 @@ static int mtk_nfc_setup_data_interface(
 {
 	struct mtk_nfc *nfc = nand_get_controller_data(chip);
 	const struct nand_sdr_timings *timings;
-	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst, trlt;
+	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst = 0, trlt = 0;
+	u32 thold;
 
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
@@ -536,11 +537,28 @@ static int mtk_nfc_setup_data_interface(
 	twh = DIV_ROUND_UP(twh * rate, 1000000) - 1;
 	twh &= 0xf;
 
-	twst = timings->tWP_min / 1000;
+	/* Calculate real WE#/RE# hold time in nanosecond */
+	thold = (twh + 1) * 1000000 / rate;
+	/* nanosecond to picosecond */
+	thold *= 1000;
+
+	/*
+	 * WE# low level time should be expaned to meet WE# pulse time
+	 * and WE# cycle time at the same time.
+	 */
+	if (thold < timings->tWC_min)
+		twst = timings->tWC_min - thold;
+	twst = max(timings->tWP_min, twst) / 1000;
 	twst = DIV_ROUND_UP(twst * rate, 1000000) - 1;
 	twst &= 0xf;
 
-	trlt = max(timings->tREA_max, timings->tRP_min) / 1000;
+	/*
+	 * RE# low level time should be expaned to meet RE# pulse time,
+	 * RE# access time and RE# cycle time at the same time.
+	 */
+	if (thold < timings->tRC_min)
+		trlt = timings->tRC_min - thold;
+	trlt = max3(trlt, timings->tREA_max, timings->tRP_min) / 1000;
 	trlt = DIV_ROUND_UP(trlt * rate, 1000000) - 1;
 	trlt &= 0xf;
 


