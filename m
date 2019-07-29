Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F05785D8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 09:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfG2HHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 03:07:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38165 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfG2HHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 03:07:34 -0400
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1hrzkq-0001rk-1M; Mon, 29 Jul 2019 09:07:32 +0200
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1hrzkp-0003Ts-6M; Mon, 29 Jul 2019 09:07:31 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     richard.weinberger@gmail.com, boris.brezillon@collabora.com,
        miquel.raynal@bootlin.com
Cc:     kernel@pengutronix.de, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH v2] mtd: rawnand: micron: handle on-die "ECC-off" devices correctly
Date:   Mon, 29 Jul 2019 09:06:52 +0200
Message-Id: <20190729070652.12629-1-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some devices are supposed to do not support on-die ECC but experience
shows that internal ECC machinery can actually be enabled through the
"SET FEATURE (EFh)" command, even if a read of the "READ ID Parameter
Tables" returns that it is not.

Currently, the driver checks the "READ ID Parameter" field directly
after having enabled the feature. If the check fails it returns
immediately but leaves the ECC on. When using buggy chips like
MT29F2G08ABAGA and MT29F2G08ABBGA, all future read/program cycles will
go through the on-die ECC, confusing the host controller which is
supposed to be the one handling correction.

To address this in a common way we need to turn off the on-die ECC
directly after reading the "READ ID Parameter" and before checking the
"ECC status".

Cc: stable@vger.kernel.org
Fixes: dbc44edbf833 ("mtd: rawnand: micron: Fix on-die ECC detection logic")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
v2:
- adapt commit message according Miquel comments
- add fixes, stable tags
- add Boris rb-tag

 drivers/mtd/nand/raw/nand_micron.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_micron.c b/drivers/mtd/nand/raw/nand_micron.c
index 1622d3145587..fb199ad2f1a6 100644
--- a/drivers/mtd/nand/raw/nand_micron.c
+++ b/drivers/mtd/nand/raw/nand_micron.c
@@ -390,6 +390,14 @@ static int micron_supports_on_die_ecc(struct nand_chip *chip)
 	    (chip->id.data[4] & MICRON_ID_INTERNAL_ECC_MASK) != 0x2)
 		return MICRON_ON_DIE_UNSUPPORTED;
 
+	/*
+	 * It seems that there are devices which do not support ECC official.
+	 * At least the MT29F2G08ABAGA / MT29F2G08ABBGA devices supports
+	 * enabling the ECC feature but don't reflect that to the READ_ID table.
+	 * So we have to guarantee that we disable the ECC feature directly
+	 * after we did the READ_ID table command. Later we can evaluate the
+	 * ECC_ENABLE support.
+	 */
 	ret = micron_nand_on_die_ecc_setup(chip, true);
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
@@ -398,13 +406,13 @@ static int micron_supports_on_die_ecc(struct nand_chip *chip)
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
 
-	if (!(id[4] & MICRON_ID_ECC_ENABLED))
-		return MICRON_ON_DIE_UNSUPPORTED;
-
 	ret = micron_nand_on_die_ecc_setup(chip, false);
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
 
+	if (!(id[4] & MICRON_ID_ECC_ENABLED))
+		return MICRON_ON_DIE_UNSUPPORTED;
+
 	ret = nand_readid_op(chip, 0, id, sizeof(id));
 	if (ret)
 		return MICRON_ON_DIE_UNSUPPORTED;
-- 
2.20.1

