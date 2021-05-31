Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01A39610C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhEaOfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233790AbhEaOdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039B76103E;
        Mon, 31 May 2021 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468987;
        bh=u6TgoZ0K28l+UN68umsfGYwPBSs31uoQ2h/44usjM7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hu5bFKMgpi9nwPZfWEwMXIbEQO+K6pl1Ee1VWs/DWjbnQwsiUNXCL11YvWmrR70qQ
         LUc6+h+a80dqqCC5L0+8iVvjruvgcmxgv/k2txn7G5MqmzhfUaJc98CSwpPc7nMT+a
         YTo35hm5RpZbrHJ+fYfrkIPAhXTBJvd90gn56PvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 019/296] mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper
Date:   Mon, 31 May 2021 15:11:14 +0200
Message-Id: <20210531130704.407146577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit ad9ffdce453934cdc22fac0a0268119bd630260f upstream.

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210413161840.345208-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
@@ -432,6 +433,15 @@ static int fsmc_read_hwecc_ecc1(struct n
 	return 0;
 }
 
+static int fsmc_correct_ecc1(struct nand_chip *chip,
+			     unsigned char *buf,
+			     unsigned char *read_ecc,
+			     unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 /* Count the number of 0's in buff upto a max of max_bits */
 static int count_written_bits(u8 *buff, int size, int max_bits)
 {
@@ -917,7 +927,7 @@ static int fsmc_nand_attach_chip(struct
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		dev_info(host->dev, "Using 1-bit HW ECC scheme\n");
 		nand->ecc.calculate = fsmc_read_hwecc_ecc1;
-		nand->ecc.correct = rawnand_sw_hamming_correct;
+		nand->ecc.correct = fsmc_correct_ecc1;
 		nand->ecc.hwctl = fsmc_enable_hwecc;
 		nand->ecc.bytes = 3;
 		nand->ecc.strength = 1;


