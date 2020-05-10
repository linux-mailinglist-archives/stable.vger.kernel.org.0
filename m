Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C45A1CCAB1
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 14:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgEJMMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 08:12:53 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:50933 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgEJMMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 08:12:53 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 823C320010;
        Sun, 10 May 2020 12:12:51 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org, Xiaolei Li <xiaolei.li@mediatek.com>
Subject: [PATCH 27/62] mtd: rawnand: mtk: Fix the probe error path
Date:   Sun, 10 May 2020 14:11:45 +0200
Message-Id: <20200510121220.18042-28-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200510121220.18042-1-miquel.raynal@bootlin.com>
References: <20200510121220.18042-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Cc: Xiaolei Li <xiaolei.li@mediatek.com>
---
 drivers/mtd/nand/raw/mtk_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index e7ec30e784fd..9dad08bed2bb 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1419,7 +1419,7 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "mtd parse partition error\n");
-		nand_release(nand);
+		nand_cleanup(nand);
 		return ret;
 	}
 
-- 
2.20.1

