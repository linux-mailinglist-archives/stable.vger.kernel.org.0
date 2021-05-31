Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7D3960EF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhEaOde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhEaOb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB2E961C34;
        Mon, 31 May 2021 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468956;
        bh=YyASUXUCHmgilWg1zIfOBWhfzVuP9Gknhu1xgpljlY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJXjNK9AdM3FvO/Bxt8zeuo9zbuxG/8rbQwmCwljqDh5qDYX6kcpycTbwyo/gyYVT
         kad2taBFF0e28CuYUafL26whFCqUsJrzbUBjT/0T/jsC2+2wttyd6N4jicxdyyct9E
         +EBvO5KFkp2D7QhkEhAkSdWJ8K+Wle4iEIaLulH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 015/296] mtd: rawnand: sharpsl: Fix external use of SW Hamming ECC helper
Date:   Mon, 31 May 2021 15:11:10 +0200
Message-Id: <20210531130704.273314514@linuxfoundation.org>
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

commit 46fcb57e6b7283533ebf8ba17a6bd30fa88bdc9f upstream.

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210413161840.345208-6-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/sharpsl.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/sharpsl.c
+++ b/drivers/mtd/nand/raw/sharpsl.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/sharpsl.h>
@@ -96,6 +97,15 @@ static int sharpsl_nand_calculate_ecc(st
 	return readb(sharpsl->io + ECCCNTR) != 0;
 }
 
+static int sharpsl_nand_correct_ecc(struct nand_chip *chip,
+				    unsigned char *buf,
+				    unsigned char *read_ecc,
+				    unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 static int sharpsl_attach_chip(struct nand_chip *chip)
 {
 	if (chip->ecc.engine_type != NAND_ECC_ENGINE_TYPE_ON_HOST)
@@ -106,7 +116,7 @@ static int sharpsl_attach_chip(struct na
 	chip->ecc.strength = 1;
 	chip->ecc.hwctl = sharpsl_nand_enable_hwecc;
 	chip->ecc.calculate = sharpsl_nand_calculate_ecc;
-	chip->ecc.correct = rawnand_sw_hamming_correct;
+	chip->ecc.correct = sharpsl_nand_correct_ecc;
 
 	return 0;
 }


