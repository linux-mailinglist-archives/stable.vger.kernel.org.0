Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737892882B2
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 08:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgJIGjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 02:39:06 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:35080 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732347AbgJIGiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 02:38:54 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 0996ciMf028150; Fri, 9 Oct 2020 15:38:45 +0900
X-Iguazu-Qid: 34trqomzZ2JOhJF1Xm
X-Iguazu-QSIG: v=2; s=0; t=1602225524; q=34trqomzZ2JOhJF1Xm; m=m6RqMdum43n0hgZxchU687yGaZ4urRDqph02Deb7vsY=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 0996chb9026014;
        Fri, 9 Oct 2020 15:38:44 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0996chx8019500;
        Fri, 9 Oct 2020 15:38:43 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0996chnw000445;
        Fri, 9 Oct 2020 15:38:43 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.9, 4.14] mtd: rawnand: sunxi: Fix the probe error path
Date:   Fri,  9 Oct 2020 15:38:37 +0900
X-TSB-HOP: ON
Message-Id: <20201009063837.549356-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 3d84515ffd8fb657e10fa5b1215e9f095fa7efca upstream.

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

Fixes: 1fef62c1423b ("mtd: nand: add sunxi NAND flash controller support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-54-miquel.raynal@bootlin.com
[iwamatsu: adjust filename]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/mtd/nand/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index ddf3e24cc2898d..2cf19372efb90a 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -2108,7 +2108,7 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(nand);
+		nand_cleanup(nand);
 		return ret;
 	}

--
2.28.0

