Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EE63960F4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhEaOdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233381AbhEaOb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 423E461629;
        Mon, 31 May 2021 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468953;
        bh=6XlGExWuaiqzJEloSrf2Ut/W76vJdtpipp50LEhiXN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqVFDU2D5wVYm2RddC/VVKfc+nKzoFcXt8LF1RTpqLAXxECCVbRIasvtg38j8wPIF
         sBAUtPdTbi7BaRe1gfbiLprlPcWhXHumx4UA+/NUKNUEorUtH9jTbTGeMz9Sp5I3CR
         STnsr7mWt0z5gEiNQ1ljoaxWJA4DtCd7JWcATFQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 014/296] mtd: rawnand: txx9ndfmc: Fix external use of SW Hamming ECC helper
Date:   Mon, 31 May 2021 15:11:09 +0200
Message-Id: <20210531130704.242852585@linuxfoundation.org>
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

commit 3d227a0b0ce319edbff6fd0d8af4d66689e477cc upstream.

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210413161840.345208-8-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/txx9ndfmc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/txx9ndfmc.c
+++ b/drivers/mtd/nand/raw/txx9ndfmc.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>
@@ -193,8 +194,8 @@ static int txx9ndfmc_correct_data(struct
 	int stat;
 
 	for (eccsize = chip->ecc.size; eccsize > 0; eccsize -= 256) {
-		stat = rawnand_sw_hamming_correct(chip, buf, read_ecc,
-						  calc_ecc);
+		stat = ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+					      chip->ecc.size, false);
 		if (stat < 0)
 			return stat;
 		corrected += stat;


