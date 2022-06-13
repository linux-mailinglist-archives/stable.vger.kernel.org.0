Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE606548F98
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354033AbiFML1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353848AbiFMLZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:25:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63313CFFA;
        Mon, 13 Jun 2022 03:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2471B80D3A;
        Mon, 13 Jun 2022 10:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F558C3411E;
        Mon, 13 Jun 2022 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116953;
        bh=JXGmPGfuIxVnVfbaHBzLdU8nrx6hyq3Fd6Fa/1LQNo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMWi16KrMuY8EELBQVVrSjMBSHSsYNbD9VKGogDCc0jEV6M9yvckgHbeFzu5z/w29
         dKGe346RE2N5hjWpzbibysTHz63Ve+4CJPW+5EKhs8R4c2mkzFdwmgP8qyQbCqoQ0J
         yu9ApbFZkFfhE6yF/xM5cv0Ekfik82xSC8Rftseo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tokunori Ikegami <ikegami.t@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 245/411] mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
Date:   Mon, 13 Jun 2022 12:08:38 +0200
Message-Id: <20220613094936.121895817@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tokunori Ikegami <ikegami.t@gmail.com>

commit 083084df578a8bdb18334f69e7b32d690aaa3247 upstream.

This is a preparation patch for the S29GL064N buffer writes fix. There
is no functional change.

Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220323170458.5608-2-ikegami.t@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |   95 ++++++++++++------------------------
 1 file changed, 32 insertions(+), 63 deletions(-)

--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -798,21 +798,25 @@ static struct mtd_info *cfi_amdstd_setup
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
@@ -822,57 +826,20 @@ static int __xipram chip_ready(struct ma
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
@@ -889,7 +856,7 @@ static int get_chip(struct map_info *map
 
 	case FL_STATUS:
 		for (;;) {
-			if (chip_ready(map, chip, adr))
+			if (chip_ready(map, chip, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -927,7 +894,7 @@ static int get_chip(struct map_info *map
 		chip->state = FL_ERASE_SUSPENDING;
 		chip->erase_suspended = 1;
 		for (;;) {
-			if (chip_ready(map, chip, adr))
+			if (chip_ready(map, chip, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -1459,7 +1426,7 @@ static int do_otp_lock(struct map_info *
 	/* wait for chip to become ready */
 	timeo = jiffies + msecs_to_jiffies(2);
 	for (;;) {
-		if (chip_ready(map, chip, adr))
+		if (chip_ready(map, chip, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -1691,11 +1658,11 @@ static int __xipram do_write_oneword_onc
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
@@ -1703,7 +1670,7 @@ static int __xipram do_write_oneword_onc
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -1971,18 +1938,18 @@ static int __xipram do_write_buffer_wait
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
@@ -2191,7 +2158,7 @@ static int cfi_amdstd_panic_wait(struct
 	 * If the driver thinks the chip is idle, and no toggle bits
 	 * are changing, then the chip is actually idle for sure.
 	 */
-	if (chip->state == FL_READY && chip_ready(map, chip, adr))
+	if (chip->state == FL_READY && chip_ready(map, chip, adr, NULL))
 		return 0;
 
 	/*
@@ -2208,7 +2175,7 @@ static int cfi_amdstd_panic_wait(struct
 
 		/* wait for the chip to become ready */
 		for (i = 0; i < jiffies_to_usecs(timeo); i++) {
-			if (chip_ready(map, chip, adr))
+			if (chip_ready(map, chip, adr, NULL))
 				return 0;
 
 			udelay(1);
@@ -2272,13 +2239,13 @@ retry:
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
@@ -2420,6 +2387,7 @@ static int __xipram do_erase_chip(struct
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr = cfi->addr_unlock1;
 
@@ -2474,7 +2442,7 @@ static int __xipram do_erase_chip(struct
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, chip, adr, map_word_ff(map))) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -2519,6 +2487,7 @@ static int __xipram do_erase_oneblock(st
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr += chip->start;
 
@@ -2573,7 +2542,7 @@ static int __xipram do_erase_oneblock(st
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, chip, adr, map_word_ff(map))) {
+		if (chip_ready(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -2767,7 +2736,7 @@ static int __maybe_unused do_ppb_xxlock(
 	 */
 	timeo = jiffies + msecs_to_jiffies(2000);	/* 2s max (un)locking */
 	for (;;) {
-		if (chip_ready(map, chip, adr))
+		if (chip_ready(map, chip, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {


