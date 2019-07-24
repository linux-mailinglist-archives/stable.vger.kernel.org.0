Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B25745E7
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391525AbfGYFrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387580AbfGYFrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:47:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E932075C;
        Thu, 25 Jul 2019 05:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033640;
        bh=7h3xjwCuMzG9QgcuPlQaEu4Qk7po7mY7FzUvG8n8IzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ejf6VJkJi0iRRTcI3XWH+jhxOUzKAufMRdfEPjhZE2vw6PYUrYudlCLjTFkbzISSl
         iMAMqanGazazr+HHwWU065qAtNowsWBZHz4KdhFA7nlUF2dfKVTssKMEcxElo+odY2
         uZlnM8xFyLwpKaHcvu8YjXf+QAl+2H2ihUy4pvAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Li <xiaolei.li@mediatek.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 261/271] mtd: rawnand: mtk: Correct low level time calculation of r/w cycle
Date:   Wed, 24 Jul 2019 21:22:10 +0200
Message-Id: <20190724191717.570128067@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
@@ -509,7 +509,8 @@ static int mtk_nfc_setup_data_interface(
 {
 	struct mtk_nfc *nfc = nand_get_controller_data(mtd_to_nand(mtd));
 	const struct nand_sdr_timings *timings;
-	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst, trlt;
+	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst = 0, trlt = 0;
+	u32 thold;
 
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
@@ -545,11 +546,28 @@ static int mtk_nfc_setup_data_interface(
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
 


