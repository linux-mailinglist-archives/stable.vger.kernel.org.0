Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B646AF3AB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 12:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfD3KEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 06:04:14 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:61467 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726262AbfD3KEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 06:04:13 -0400
X-UUID: 0734807c873c4bb391afb6ba665d9690-20190430
X-UUID: 0734807c873c4bb391afb6ba665d9690-20190430
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <xiaolei.li@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1887702244; Tue, 30 Apr 2019 18:04:01 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 30 Apr 2019 18:04:00 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 30 Apr 2019 18:04:00 +0800
From:   Xiaolei Li <xiaolei.li@mediatek.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>
CC:     <linux-mtd@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, <xiaolei.li@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/5] mtd: rawnand: mtk: Correct low level time calculation of r/w cycle
Date:   Tue, 30 Apr 2019 18:02:46 +0800
Message-ID: <20190430100250.28083-2-xiaolei.li@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190430100250.28083-1-xiaolei.li@mediatek.com>
References: <20190430100250.28083-1-xiaolei.li@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Li <xiaolei.li@mediatek.com>
---
 drivers/mtd/nand/raw/mtk_nand.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index b6b4602f5132..4fbb0c6ecae3 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -508,7 +508,8 @@ static int mtk_nfc_setup_data_interface(struct nand_chip *chip, int csline,
 {
 	struct mtk_nfc *nfc = nand_get_controller_data(chip);
 	const struct nand_sdr_timings *timings;
-	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst, trlt;
+	u32 rate, tpoecs, tprecs, tc2r, tw2r, twh, twst = 0, trlt = 0;
+	u32 thold;
 
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
@@ -544,11 +545,28 @@ static int mtk_nfc_setup_data_interface(struct nand_chip *chip, int csline,
 	twh = DIV_ROUND_UP(twh * rate, 1000000) - 1;
 	twh &= 0xf;
 
-	twst = timings->tWP_min / 1000;
+	/* Calculate real WE#/RE# hold time in nanosecond */
+	thold = (twh + 1) * 1000000 / rate;
+	/* nanosecond to picosecond */
+	thold *= 1000;
+
+	/**
+	 * WE# low level time should be expaned to meet WE# pulse time
+	 * and WE# cycle time at the same time.
+	 */
+	if (thold < timings->tWC_min)
+		twst = timings->tWC_min - thold;
+	twst = max(timings->tWP_min, twst) / 1000;
 	twst = DIV_ROUND_UP(twst * rate, 1000000) - 1;
 	twst &= 0xf;
 
-	trlt = max(timings->tREA_max, timings->tRP_min) / 1000;
+	/**
+	 * RE# low level time should be expaned to meet RE# pulse time,
+	 * RE# access time and RE# cycle time at the same time.
+	 */
+	if (thold < timings->tRC_min)
+		trlt = timings->tRC_min - thold;
+	trlt = max3(trlt, timings->tREA_max, timings->tRP_min) / 1000;
 	trlt = DIV_ROUND_UP(trlt * rate, 1000000) - 1;
 	trlt &= 0xf;
 
-- 
2.18.0

