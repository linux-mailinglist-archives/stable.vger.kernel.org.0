Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A9D1CCAB6
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 14:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgEJMNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 08:13:06 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:44123 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgEJMNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 08:13:05 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id CD6662000D;
        Sun, 10 May 2020 12:13:03 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH 42/62] mtd: rawnand: plat_nand: Fix the probe error path
Date:   Sun, 10 May 2020 14:12:00 +0200
Message-Id: <20200510121220.18042-43-miquel.raynal@bootlin.com>
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
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible, hence pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/nand/raw/plat_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/plat_nand.c b/drivers/mtd/nand/raw/plat_nand.c
index dc0f3074ddbf..3a495b233443 100644
--- a/drivers/mtd/nand/raw/plat_nand.c
+++ b/drivers/mtd/nand/raw/plat_nand.c
@@ -92,7 +92,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 	if (!err)
 		return err;
 
-	nand_release(&data->chip);
+	nand_cleanup(&data->chip);
 out:
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);
-- 
2.20.1

