Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80E1456AF
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgAVN2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgAVN2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:37 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5AF24125;
        Wed, 22 Jan 2020 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699716;
        bh=TGuXL6s+0RJa0Y2azBHFW2QmuRBKDpL1QqTQOuHqbrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pl8Uzpk5yPtolsKN+4Ut6O48GLGD5Dwm0UgCwuuGMW4YIhDEoiK2kBUweRHcR5iRp
         2Ld75h1zUXCuhCUf4UEertHmxa4LK870iTkYZe+Xoo2OeUmgFakuRv95UFta0x/zUr
         Hj9G5wwzwXZsCFXhhoPWhUjh3OIlnHgsWs5meB88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 5.4 195/222] mtd: cfi_cmdset_0002: fix delayed error detection on HyperFlash
Date:   Wed, 22 Jan 2020 10:29:41 +0100
Message-Id: <20200122092847.677954139@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit c15995695ea971253ea9507f6732c8cd35384e01 upstream.

The commit 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling
status register") added checking for the status register error bits into
chip_good() to only return 1 if these bits are 0s.  Unfortunately, this
means that polling using chip_good() always reaches a timeout condition
when erase or program failure bits are set. Let's fully delegate the task
of determining the error conditions to cfi_check_err_status() and make
chip_good() only look for the Device Ready/Busy condition.

Fixes: 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/chips/cfi_cmdset_0002.c |   58 ++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 25 deletions(-)

--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -123,14 +123,14 @@ static int cfi_use_status_reg(struct cfi
 		(extp->SoftwareFeatures & poll_mask) == CFI_POLL_STATUS_REG;
 }
 
-static void cfi_check_err_status(struct map_info *map, struct flchip *chip,
-				 unsigned long adr)
+static int cfi_check_err_status(struct map_info *map, struct flchip *chip,
+				unsigned long adr)
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	map_word status;
 
 	if (!cfi_use_status_reg(cfi))
-		return;
+		return 0;
 
 	cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
 			 cfi->device_type, NULL);
@@ -138,7 +138,7 @@ static void cfi_check_err_status(struct
 
 	/* The error bits are invalid while the chip's busy */
 	if (!map_word_bitsset(map, status, CMD(CFI_SR_DRB)))
-		return;
+		return 0;
 
 	if (map_word_bitsset(map, status, CMD(0x3a))) {
 		unsigned long chipstatus = MERGESTATUS(status);
@@ -155,7 +155,12 @@ static void cfi_check_err_status(struct
 		if (chipstatus & CFI_SR_SLSB)
 			pr_err("%s sector write protected, status %lx\n",
 			       map->name, chipstatus);
+
+		/* Erase/Program status bits are set on the operation failure */
+		if (chipstatus & (CFI_SR_ESB | CFI_SR_PSB))
+			return 1;
 	}
+	return 0;
 }
 
 /* #define DEBUG_CFI_FEATURES */
@@ -852,20 +857,16 @@ static int __xipram chip_good(struct map
 
 	if (cfi_use_status_reg(cfi)) {
 		map_word ready = CMD(CFI_SR_DRB);
-		map_word err = CMD(CFI_SR_PSB | CFI_SR_ESB);
+
 		/*
 		 * For chips that support status register, check device
-		 * ready bit and Erase/Program status bit to know if
-		 * operation succeeded.
+		 * ready bit
 		 */
 		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
 				 cfi->device_type, NULL);
 		curd = map_read(map, addr);
 
-		if (map_word_andequal(map, curd, ready, ready))
-			return !map_word_bitsset(map, curd, err);
-
-		return 0;
+		return map_word_andequal(map, curd, ready, ready);
 	}
 
 	oldd = map_read(map, addr);
@@ -1703,8 +1704,11 @@ static int __xipram do_write_oneword_onc
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum))
+		if (chip_good(map, chip, adr, datum)) {
+			if (cfi_check_err_status(map, chip, adr))
+				ret = -EIO;
 			break;
+		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
 		UDELAY(map, chip, adr, 1);
@@ -1777,7 +1781,6 @@ static int __xipram do_write_oneword_ret
 	ret = do_write_oneword_once(map, chip, adr, datum, mode, cfi);
 	if (ret) {
 		/* reset on all failures. */
-		cfi_check_err_status(map, chip, adr);
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
 
@@ -1974,12 +1977,17 @@ static int __xipram do_write_buffer_wait
 		 */
 		if (time_after(jiffies, timeo) &&
 		    !chip_good(map, chip, adr, datum)) {
+			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
+			       __func__, adr);
 			ret = -EIO;
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum))
+		if (chip_good(map, chip, adr, datum)) {
+			if (cfi_check_err_status(map, chip, adr))
+				ret = -EIO;
 			break;
+		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
 		UDELAY(map, chip, adr, 1);
@@ -2075,12 +2083,8 @@ static int __xipram do_write_buffer(stru
 				chip->word_write_time);
 
 	ret = do_write_buffer_wait(map, chip, adr, datum);
-	if (ret) {
-		cfi_check_err_status(map, chip, adr);
+	if (ret)
 		do_write_buffer_reset(map, chip, cfi);
-		pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
-		       __func__, adr);
-	}
 
 	xip_enable(map, chip, adr);
 
@@ -2275,9 +2279,9 @@ retry:
 		udelay(1);
 	}
 
-	if (!chip_good(map, chip, adr, datum)) {
+	if (!chip_good(map, chip, adr, datum) ||
+	    cfi_check_err_status(map, chip, adr)) {
 		/* reset on all failures. */
-		cfi_check_err_status(map, chip, adr);
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
 
@@ -2471,8 +2475,11 @@ static int __xipram do_erase_chip(struct
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, chip, adr, map_word_ff(map)))
+		if (chip_good(map, chip, adr, map_word_ff(map))) {
+			if (cfi_check_err_status(map, chip, adr))
+				ret = -EIO;
 			break;
+		}
 
 		if (time_after(jiffies, timeo)) {
 			printk(KERN_WARNING "MTD %s(): software timeout\n",
@@ -2487,7 +2494,6 @@ static int __xipram do_erase_chip(struct
 	/* Did we succeed? */
 	if (ret) {
 		/* reset on all failures. */
-		cfi_check_err_status(map, chip, adr);
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
 
@@ -2568,8 +2574,11 @@ static int __xipram do_erase_oneblock(st
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, chip, adr, map_word_ff(map)))
+		if (chip_good(map, chip, adr, map_word_ff(map))) {
+			if (cfi_check_err_status(map, chip, adr))
+				ret = -EIO;
 			break;
+		}
 
 		if (time_after(jiffies, timeo)) {
 			printk(KERN_WARNING "MTD %s(): software timeout\n",
@@ -2584,7 +2593,6 @@ static int __xipram do_erase_oneblock(st
 	/* Did we succeed? */
 	if (ret) {
 		/* reset on all failures. */
-		cfi_check_err_status(map, chip, adr);
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
 


