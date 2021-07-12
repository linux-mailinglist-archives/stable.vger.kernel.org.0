Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00083C55AB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhGLILe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353843AbhGLIDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A42619A0;
        Mon, 12 Jul 2021 07:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076684;
        bh=eeuZgFZqXknJk8cKZAzKEHL+972qgorEnHz1+s2Cng8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyEWQW6HqMvlW3HFiWwPbXALQGv5bh/vZXsaYb87B2alpj1HclRN0uCXiQqwPLFWX
         oMSyGVEtRHoFZrnCvB1COQSTP/6SW1GayLP+9u2oDBYIJRI8Xj9ISjwodrGPrPSKf2
         b8+COvKXHp1PnFwEoRjdC/MJ7ckuif9jEB+rHXSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YouChing Lin <ycllin@mxic.com.tw>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 706/800] mtd: spinand: Fix double counting of ECC stats
Date:   Mon, 12 Jul 2021 08:12:09 +0200
Message-Id: <20210712061041.883346725@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit c93081b265735db2417f0964718516044d06b1a2 ]

In the raw NAND world, ECC engines increment ecc_stats and the final
caller is responsible for returning -EBADMSG if the verification
failed.

In the SPI-NAND world it was a bit different until now because there was
only one possible ECC engine: the on-die one. Indeed, the
spinand_mtd_read() call was incrementing the ecc_stats counters
depending on the outcome of spinand_check_ecc_status() directly.

So now let's split the logic like this:
- spinand_check_ecc_status() is specific to the SPI-NAND on-die engine
  and is kept very simple: it just returns the ECC status (bonus point:
  the content of this helper can be overloaded).
- spinand_ondie_ecc_finish_io_req() is the caller of
  spinand_check_ecc_status() and will increment the counters and
  eventually return -EBADMSG.
- spinand_mtd_read() is not tied to the on-die ECC implementation and
  should be able to handle results coming from other ECC engines: it has
  the responsibility of returning the maximum number of bitflips which
  happened during the entire operation as this is the only helper that
  is aware that several pages may be read in a row.

Fixes: 945845b54c9c ("mtd: spinand: Instantiate a SPI-NAND on-die ECC engine")
Reported-by: YouChing Lin <ycllin@mxic.com.tw>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: YouChing Lin <ycllin@mxic.com.tw>
Link: https://lore.kernel.org/linux-mtd/20210527084345.208215-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 17f63f95f4a2..54ae540bc66b 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -290,6 +290,8 @@ static int spinand_ondie_ecc_finish_io_req(struct nand_device *nand,
 {
 	struct spinand_ondie_ecc_conf *engine_conf = nand->ecc.ctx.priv;
 	struct spinand_device *spinand = nand_to_spinand(nand);
+	struct mtd_info *mtd = spinand_to_mtd(spinand);
+	int ret;
 
 	if (req->mode == MTD_OPS_RAW)
 		return 0;
@@ -299,7 +301,13 @@ static int spinand_ondie_ecc_finish_io_req(struct nand_device *nand,
 		return 0;
 
 	/* Finish a page write: check the status, report errors/bitflips */
-	return spinand_check_ecc_status(spinand, engine_conf->status);
+	ret = spinand_check_ecc_status(spinand, engine_conf->status);
+	if (ret == -EBADMSG)
+		mtd->ecc_stats.failed++;
+	else if (ret > 0)
+		mtd->ecc_stats.corrected += ret;
+
+	return ret;
 }
 
 static struct nand_ecc_engine_ops spinand_ondie_ecc_engine_ops = {
@@ -620,13 +628,10 @@ static int spinand_mtd_read(struct mtd_info *mtd, loff_t from,
 		if (ret < 0 && ret != -EBADMSG)
 			break;
 
-		if (ret == -EBADMSG) {
+		if (ret == -EBADMSG)
 			ecc_failed = true;
-			mtd->ecc_stats.failed++;
-		} else {
-			mtd->ecc_stats.corrected += ret;
+		else
 			max_bitflips = max_t(unsigned int, max_bitflips, ret);
-		}
 
 		ret = 0;
 		ops->retlen += iter.req.datalen;
-- 
2.30.2



