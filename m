Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4234653EBCC
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbiFFNpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 09:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239059AbiFFNph (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 09:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399F12755AF
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 06:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C801D6123C
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 13:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA38DC385A9;
        Mon,  6 Jun 2022 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654523135;
        bh=VjCb+nFZNUO1Pdn3djQNaTVW03kyn9Z3QvrJvRlh59s=;
        h=Subject:To:Cc:From:Date:From;
        b=mzhOFaNKcbd655yObt9Ddmk2hwvcfNeT+7hpd6olKOIXIVJj86452JV5Mk7jJ719J
         wLT2mSpwz2X3owMIkyjK9WBSN3FhwmDXCL2a0CLdWaXe80+CaxLK7jGqFkxO41qjXx
         aoJ5AEcJIfHqXbD6maC3mCAyX4DdMvHnPRBsnJvU=
Subject: FAILED: patch "[PATCH] mtd: cfi_cmdset_0002: Move and rename" failed to apply to 4.19-stable tree
To:     ikegami.t@gmail.com, miquel.raynal@bootlin.com, vigneshr@ti.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 15:45:32 +0200
Message-ID: <165452313220680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 083084df578a8bdb18334f69e7b32d690aaa3247 Mon Sep 17 00:00:00 2001
From: Tokunori Ikegami <ikegami.t@gmail.com>
Date: Thu, 24 Mar 2022 02:04:55 +0900
Subject: [PATCH] mtd: cfi_cmdset_0002: Move and rename
 chip_check/chip_ready/chip_good_for_write

This is a preparation patch for the S29GL064N buffer writes fix. There
is no functional change.

Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220323170458.5608-2-ikegami.t@gmail.com

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index a761134fd3be..9ccde90dc180 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -802,21 +802,25 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 }
 
 /*
- * Return true if the chip is ready.
+ * Return true if the chip is ready and has the correct value.
  *
  * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
  * non-suspended sector) and is indicated by no toggle bits toggling.
  *
+ * Error are indicated by toggling bits or bits held with the wrong value,
+ * or with bits toggling.
+ *
  * Note that anything more complicated than checking if no bits are toggling
  * (including checking DQ5 for an error status) is tricky to get working
  * correctly and is therefore not done	(particularly with interleaved chips
  * as each chip must be checked independently of the others).
  */
 static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
-			       unsigned long addr)
+			       unsigned long addr, map_word *expected)
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	map_word d, t;
+	int ret;
 
 	if (cfi_use_status_reg(cfi)) {
 		map_word ready = CMD(CFI_SR_DRB);
@@ -826,57 +830,20 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
 		 */
 		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
 				 cfi->device_type, NULL);
-		d = map_read(map, addr);
+		t = map_read(map, addr);
 
-		return map_word_andequal(map, d, ready, ready);
+		return map_word_andequal(map, t, ready, ready);
 	}
 
 	d = map_read(map, addr);
 	t = map_read(map, addr);
 
-	return map_word_equal(map, d, t);
-}
-
-/*
- * Return true if the chip is ready and has the correct value.
- *
- * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
- * non-suspended sector) and it is indicated by no bits toggling.
- *
- * Error are indicated by toggling bits or bits held with the wrong value,
- * or with bits toggling.
- *
- * Note that anything more complicated than checking if no bits are toggling
- * (including checking DQ5 for an error status) is tricky to get working
- * correctly and is therefore not done	(particularly with interleaved chips
- * as each chip must be checked independently of the others).
- *
- */
-static int __xipram chip_good(struct map_info *map, struct flchip *chip,
-			      unsigned long addr, map_word expected)
-{
-	struct cfi_private *cfi = map->fldrv_priv;
-	map_word oldd, curd;
-
-	if (cfi_use_status_reg(cfi)) {
-		map_word ready = CMD(CFI_SR_DRB);
-
-		/*
-		 * For chips that support status register, check device
-		 * ready bit
-		 */
-		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
-				 cfi->device_type, NULL);
-		curd = map_read(map, addr);
-
-		return map_word_andequal(map, curd, ready, ready);
-	}
+	ret = map_word_equal(map, d, t);
 
-	oldd = map_read(map, addr);
-	curd = map_read(map, addr);
+	if (!ret || !expected)
+		return ret;
 
-	return	map_word_equal(map, oldd, curd) &&
-		map_word_equal(map, curd, expected);
+	return map_word_equal(map, t, *expected);
 }
 
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
@@ -893,7 +860,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 
 	case FL_STATUS:
 		for (;;) {
-			if (chip_ready(map, chip, adr))
+			if (chip_ready(map, chip, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -932,7 +899,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		chip->state = FL_ERASE_SUSPENDING;
 		chip->erase_suspended = 1;
 		for (;;) {
-			if (chip_ready(map, chip, adr))
+			if (chip_ready(map, chip, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -1463,7 +1430,7 @@ static int do_otp_lock(struct map_info *map, struct flchip *chip, loff_t adr,
 	/* wait for chip to become ready */
 	timeo = jiffies + msecs_to_jiffies(2);
 	for (;;) {
-		if (chip_ready(map, chip, adr))
+		if (chip_ready(map, chip, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -1695,11 +1662,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_good" before checking
-		 * "chip_good" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_ready" before checking
+		 * "chip_ready" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_good(map, chip, adr, datum)) {
+		    !chip_ready(map, chip, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1707,7 +1674,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -1975,18 +1942,18 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_good" before checking
-		 * "chip_good" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_ready" before checking
+		 * "chip_ready" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_good(map, chip, adr, datum)) {
+		    !chip_ready(map, chip, adr, &datum)) {
 			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
 			       __func__, adr);
 			ret = -EIO;
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -2195,7 +2162,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 	 * If the driver thinks the chip is idle, and no toggle bits
 	 * are changing, then the chip is actually idle for sure.
 	 */
-	if (chip->state == FL_READY && chip_ready(map, chip, adr))
+	if (chip->state == FL_READY && chip_ready(map, chip, adr, NULL))
 		return 0;
 
 	/*
@@ -2212,7 +2179,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 
 		/* wait for the chip to become ready */
 		for (i = 0; i < jiffies_to_usecs(timeo); i++) {
-			if (chip_ready(map, chip, adr))
+			if (chip_ready(map, chip, adr, NULL))
 				return 0;
 
 			udelay(1);
@@ -2276,13 +2243,13 @@ static int do_panic_write_oneword(struct map_info *map, struct flchip *chip,
 	map_write(map, datum, adr);
 
 	for (i = 0; i < jiffies_to_usecs(uWriteTimeout); i++) {
-		if (chip_ready(map, chip, adr))
+		if (chip_ready(map, chip, adr, NULL))
 			break;
 
 		udelay(1);
 	}
 
-	if (!chip_good(map, chip, adr, datum) ||
+	if (!chip_ready(map, chip, adr, &datum) ||
 	    cfi_check_err_status(map, chip, adr)) {
 		/* reset on all failures. */
 		map_write(map, CMD(0xF0), chip->start);
@@ -2424,6 +2391,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 	DECLARE_WAITQUEUE(wait, current);
 	int ret;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr = cfi->addr_unlock1;
 
@@ -2478,7 +2446,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, chip, adr, map_word_ff(map))) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -2523,6 +2491,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 	DECLARE_WAITQUEUE(wait, current);
 	int ret;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr += chip->start;
 
@@ -2577,7 +2546,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, chip, adr, map_word_ff(map))) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -2771,7 +2740,7 @@ static int __maybe_unused do_ppb_xxlock(struct map_info *map,
 	 */
 	timeo = jiffies + msecs_to_jiffies(2000);	/* 2s max (un)locking */
 	for (;;) {
-		if (chip_ready(map, chip, adr))
+		if (chip_ready(map, chip, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {

