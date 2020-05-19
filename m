Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AE61D96DD
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 15:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgESNAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 09:00:52 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:40327 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgESNAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 09:00:52 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 06028FF80B;
        Tue, 19 May 2020 13:00:50 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        Harvey Hunt <harveyhuntnexus@gmail.com>
Subject: [PATCH v2 21/62] mtd: rawnand: ingenic: Fix the probe error path
Date:   Tue, 19 May 2020 14:59:54 +0200
Message-Id: <20200519130035.1883-22-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519130035.1883-1-miquel.raynal@bootlin.com>
References: <20200519130035.1883-1-miquel.raynal@bootlin.com>
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
which makes this change possible. Hence, pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug makes sense.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Harvey Hunt <harveyhuntnexus@gmail.com>
---
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
index e7bd845fdbf5..3bfb6fa8bad9 100644
--- a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
@@ -376,7 +376,7 @@ static int ingenic_nand_init_chip(struct platform_device *pdev,
 
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
-		nand_release(chip);
+		nand_cleanup(chip);
 		return ret;
 	}
 
-- 
2.20.1

