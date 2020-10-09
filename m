Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD32882E8
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 08:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgJIGoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 02:44:54 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:41640 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgJIGoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 02:44:54 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 0996igPN025929; Fri, 9 Oct 2020 15:44:42 +0900
X-Iguazu-Qid: 2wHHD8Mc17XC3cZTTb
X-Iguazu-QSIG: v=2; s=0; t=1602225882; q=2wHHD8Mc17XC3cZTTb; m=rUrAivIZA9c2LQVto0njDDDKPO3KOkW7EMaTrksoUfg=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1110) id 0996ie1l016282;
        Fri, 9 Oct 2020 15:44:41 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0996ierr022666;
        Fri, 9 Oct 2020 15:44:40 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0996ieHO006075;
        Fri, 9 Oct 2020 15:44:40 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.19] mtd: rawnand: sunxi: Fix the probe error path
Date:   Fri,  9 Oct 2020 15:44:30 +0900
X-TSB-HOP: ON
Message-Id: <20201009064430.549678-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 5b8502fd50cbc6..88075e420f907c 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1947,7 +1947,7 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "failed to register mtd device: %d\n", ret);
-		nand_release(nand);
+		nand_cleanup(nand);
 		return ret;
 	}
 
-- 
2.28.0

