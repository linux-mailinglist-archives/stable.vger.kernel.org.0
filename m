Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9103039615A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhEaOkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbhEaOhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 549E961C51;
        Mon, 31 May 2021 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469083;
        bh=Yij9AYDeavoAhzFiZR7co5W/gtlRzghlzkpTvWbeV3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQ3BuRypTzzuUwgK5Fk0EDtjOqmILxPWyDQQSqwv57dWI4Km0Dnujsz6Kve2X3AtL
         kCbi1yZSKTCIIIjX6DdKVNESfo3EDm++VpjcHIT/cUx02XDZzNp+BzF6RaTqc1iXYn
         vDaxxLSw6saYxyZvU5YS1VKYcasL1pipBfX59dcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 018/296] mtd: rawnand: tmio: Fix external use of SW Hamming ECC helper
Date:   Mon, 31 May 2021 15:11:13 +0200
Message-Id: <20210531130704.375707167@linuxfoundation.org>
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

commit 6a4c5ada577467a5f79e06f2c5e69c09983c22fb upstream.

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210413161840.345208-7-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/tmio_nand.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/tmio_nand.c
+++ b/drivers/mtd/nand/raw/tmio_nand.c
@@ -34,6 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/slab.h>
@@ -292,11 +293,12 @@ static int tmio_nand_correct_data(struct
 	int r0, r1;
 
 	/* assume ecc.size = 512 and ecc.bytes = 6 */
-	r0 = rawnand_sw_hamming_correct(chip, buf, read_ecc, calc_ecc);
+	r0 = ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				    chip->ecc.size, false);
 	if (r0 < 0)
 		return r0;
-	r1 = rawnand_sw_hamming_correct(chip, buf + 256, read_ecc + 3,
-					calc_ecc + 3);
+	r1 = ecc_sw_hamming_correct(buf + 256, read_ecc + 3, calc_ecc + 3,
+				    chip->ecc.size, false);
 	if (r1 < 0)
 		return r1;
 	return r0 + r1;


