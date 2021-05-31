Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9823960F3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhEaOdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233082AbhEaOba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6115061C32;
        Mon, 31 May 2021 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468959;
        bh=m8GyJ6vYnlj/C+JS2q6XGm+9EgnK27aB38QqozgurWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IuyJ0QTz7HS1I0auJOU7oDDfUYTSLZhE0naO/chQOOKugy6tVyCqLq5Y5sbLJLWO
         IKfsJHMASC9cJ9kjHAiLISFv85DKtal1cfWln2KQ47GxkBYqBQkM9Y0JzsVdwKKZT8
         +zBpJNuPy+ZmfrcovSS3bCQLO+EZIlXPA2ifwpYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Trevor Woerner <twoerner@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 016/296] mtd: rawnand: lpc32xx_slc: Fix external use of SW Hamming ECC helper
Date:   Mon, 31 May 2021 15:11:11 +0200
Message-Id: <20210531130704.304367597@linuxfoundation.org>
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

commit c4b7d7c480d607e4f52d310d9d16b194868d0917 upstream.

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Cc: Vladimir Zapolskiy <vz@mleia.com>
Reported-by: Trevor Woerner <twoerner@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Trevor Woerner <twoerner@gmail.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://lore.kernel.org/linux-mtd/20210413161840.345208-4-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/lpc32xx_slc.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -27,6 +27,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/mtd/lpc32xx_slc.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 
 #define LPC32XX_MODNAME		"lpc32xx-nand"
 
@@ -345,6 +346,18 @@ static int lpc32xx_nand_ecc_calculate(st
 }
 
 /*
+ * Corrects the data
+ */
+static int lpc32xx_nand_ecc_correct(struct nand_chip *chip,
+				    unsigned char *buf,
+				    unsigned char *read_ecc,
+				    unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
+/*
  * Read a single byte from NAND device
  */
 static uint8_t lpc32xx_nand_read_byte(struct nand_chip *chip)
@@ -802,7 +815,7 @@ static int lpc32xx_nand_attach_chip(stru
 	chip->ecc.write_oob = lpc32xx_nand_write_oob_syndrome;
 	chip->ecc.read_oob = lpc32xx_nand_read_oob_syndrome;
 	chip->ecc.calculate = lpc32xx_nand_ecc_calculate;
-	chip->ecc.correct = rawnand_sw_hamming_correct;
+	chip->ecc.correct = lpc32xx_nand_ecc_correct;
 	chip->ecc.hwctl = lpc32xx_nand_ecc_enable;
 
 	/*


