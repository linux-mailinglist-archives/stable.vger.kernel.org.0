Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFAD3960F2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhEaOdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233374AbhEaOb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A1961624;
        Mon, 31 May 2021 13:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468951;
        bh=57mus0dGnXJhnois5zRxOYyJ+59inXy3QF90V2hIR3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcmF6MYckd6o9Q8T27mJZA3/fkkd/PtxlPEN+NdqxlH/SmFLxhuvZdyYntnQLjGlH
         i5iy54ZuBqmGNcrkDrcF2LMKk1U3JpsH4Erji5xCg4j4r+moVG4jBpwmjZjEbwfLvY
         T2JnEjh7FvsXb8ViMY4LI+vmdP7pG6qrz12WA2ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 013/296] mtd: rawnand: cs553x: Fix external use of SW Hamming ECC helper
Date:   Mon, 31 May 2021 15:11:08 +0200
Message-Id: <20210531130704.213640507@linuxfoundation.org>
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

commit 56a8d3fd1f342d10ee7b27e9ac0f4d00b5fbb91c upstream.

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210413161840.345208-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cs553x_nand.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/cs553x_nand.c
+++ b/drivers/mtd/nand/raw/cs553x_nand.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/iopoll.h>
@@ -240,6 +241,15 @@ static int cs_calculate_ecc(struct nand_
 	return 0;
 }
 
+static int cs553x_ecc_correct(struct nand_chip *chip,
+			      unsigned char *buf,
+			      unsigned char *read_ecc,
+			      unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 static struct cs553x_nand_controller *controllers[4];
 
 static int cs553x_attach_chip(struct nand_chip *chip)
@@ -251,7 +261,7 @@ static int cs553x_attach_chip(struct nan
 	chip->ecc.bytes = 3;
 	chip->ecc.hwctl  = cs_enable_hwecc;
 	chip->ecc.calculate = cs_calculate_ecc;
-	chip->ecc.correct  = rawnand_sw_hamming_correct;
+	chip->ecc.correct  = cs553x_ecc_correct;
 	chip->ecc.strength = 1;
 
 	return 0;


