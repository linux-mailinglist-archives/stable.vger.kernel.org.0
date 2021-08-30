Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E89B3FB6AA
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 15:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhH3NDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 09:03:16 -0400
Received: from mail.fris.de ([116.203.77.234]:60030 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhH3NDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 09:03:12 -0400
X-Greylist: delayed 20336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2021 09:03:12 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6AAF1BFAE8;
        Mon, 30 Aug 2021 15:02:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1630328536; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding; bh=J8EqyEThj2vYt1gLlGWAPjy92OKvfcflpYFCLx+6AN0=;
        b=0X5h4VsLaT3N7aHJkLXg5ZWUaii9HEHqc2H6UtAQqPuU/nWkmjqDalkyMY/kG3sjLyGIjz
        +Lv9BFISoFwHKJ3FYY5fsJmDjsg0Vnm8ddkYxnbUHLMIjlPj9nCnNFmsBdOY+dVHpAGYnc
        dxx+1ZWQD1Eq/JGXw6Brhm9F2chkjMdHfRFObkRfowKpDp6L6jmX5cOWT5Yu317iFtj8BX
        PmoRVoPWtoQdwwLjujQ0uHMGX/K1BqjUtMnVS06NGiydYbyDCEGCP2CnXsJysnKgAOI82j
        JCLzKNhC/QI9AJLkvaCV/84KV+KqrBPg/avn2yJgyfSwqmCA59lEctL0YZIOXA==
From:   Frieder Schrempf <frieder@fris.de>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        stable@vger.kernel.org,
        voice INTER connect GmbH <developer@voiceinterconnect.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Felix Fietkau <nbd@nbd.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>,
        YouChing Lin <ycllin@mxic.com.tw>
Subject: [PATCH v2 5.10.x] mtd: spinand: Fix incorrect parameters for on-die ECC
Date:   Mon, 30 Aug 2021 15:02:10 +0200
Message-Id: <20210830130211.445728-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The new generic NAND ECC framework stores the configuration and
requirements in separate places since commit 93ef92f6f422 ("mtd: nand: Use
the new generic ECC object"). In 5.10.x The SPI NAND layer still uses only
the requirements to track the ECC properties. This mismatch leads to
values of zero being used for ECC strength and step_size in the SPI NAND
layer wherever nanddev_get_ecc_conf() is used and therefore breaks the SPI
NAND on-die ECC support in 5.10.x.

By using nanddev_get_ecc_requirements() instead of nanddev_get_ecc_conf()
for SPI NAND, we make sure that the correct parameters for the detected
chip are used. In later versions (5.11.x) this is fixed anyway with the
implementation of the SPI NAND on-die ECC engine.

Cc: stable@vger.kernel.org # 5.10.x
Reported-by: voice INTER connect GmbH <developer@voiceinterconnect.de>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
Changes in v2:
  * Fix checkpatch error/warnings for commit message style
  * Add Miquel's A-b tag
---
 drivers/mtd/nand/spi/core.c     | 6 +++---
 drivers/mtd/nand/spi/macronix.c | 6 +++---
 drivers/mtd/nand/spi/toshiba.c  | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 558d8a14810b..8794a1f6eacd 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -419,7 +419,7 @@ static int spinand_check_ecc_status(struct spinand_device *spinand, u8 status)
 		 * fixed, so let's return the maximum possible value so that
 		 * wear-leveling layers move the data immediately.
 		 */
-		return nanddev_get_ecc_conf(nand)->strength;
+		return nanddev_get_ecc_requirements(nand)->strength;
 
 	case STATUS_ECC_UNCOR_ERROR:
 		return -EBADMSG;
@@ -1090,8 +1090,8 @@ static int spinand_init(struct spinand_device *spinand)
 	mtd->oobavail = ret;
 
 	/* Propagate ECC information to mtd_info */
-	mtd->ecc_strength = nanddev_get_ecc_conf(nand)->strength;
-	mtd->ecc_step_size = nanddev_get_ecc_conf(nand)->step_size;
+	mtd->ecc_strength = nanddev_get_ecc_requirements(nand)->strength;
+	mtd->ecc_step_size = nanddev_get_ecc_requirements(nand)->step_size;
 
 	return 0;
 
diff --git a/drivers/mtd/nand/spi/macronix.c b/drivers/mtd/nand/spi/macronix.c
index 8e801e4c3a00..cd7a9cacc3fb 100644
--- a/drivers/mtd/nand/spi/macronix.c
+++ b/drivers/mtd/nand/spi/macronix.c
@@ -84,11 +84,11 @@ static int mx35lf1ge4ab_ecc_get_status(struct spinand_device *spinand,
 		 * data around if it's not necessary.
 		 */
 		if (mx35lf1ge4ab_get_eccsr(spinand, &eccsr))
-			return nanddev_get_ecc_conf(nand)->strength;
+			return nanddev_get_ecc_requirements(nand)->strength;
 
-		if (WARN_ON(eccsr > nanddev_get_ecc_conf(nand)->strength ||
+		if (WARN_ON(eccsr > nanddev_get_ecc_requirements(nand)->strength ||
 			    !eccsr))
-			return nanddev_get_ecc_conf(nand)->strength;
+			return nanddev_get_ecc_requirements(nand)->strength;
 
 		return eccsr;
 
diff --git a/drivers/mtd/nand/spi/toshiba.c b/drivers/mtd/nand/spi/toshiba.c
index 21fde2875674..6fe7bd2a94d2 100644
--- a/drivers/mtd/nand/spi/toshiba.c
+++ b/drivers/mtd/nand/spi/toshiba.c
@@ -90,12 +90,12 @@ static int tx58cxgxsxraix_ecc_get_status(struct spinand_device *spinand,
 		 * data around if it's not necessary.
 		 */
 		if (spi_mem_exec_op(spinand->spimem, &op))
-			return nanddev_get_ecc_conf(nand)->strength;
+			return nanddev_get_ecc_requirements(nand)->strength;
 
 		mbf >>= 4;
 
-		if (WARN_ON(mbf > nanddev_get_ecc_conf(nand)->strength || !mbf))
-			return nanddev_get_ecc_conf(nand)->strength;
+		if (WARN_ON(mbf > nanddev_get_ecc_requirements(nand)->strength || !mbf))
+			return nanddev_get_ecc_requirements(nand)->strength;
 
 		return mbf;
 
-- 
2.32.0

