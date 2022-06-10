Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E205468DA
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiFJOzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiFJOzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 10:55:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2BF25F8
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:55:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u2so24075533pfc.2
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgMEQ3ZipxPOjZ+e73k4NqGunb13HHNETLbPFj6PNZE=;
        b=lCOgWX3YaTKAtgoaFcbziF65qr4Ot7v5OBEGMyvT3aUiHkylQeosSp4hZUJ8uL0aW8
         N15pyv2AUNCMAB/XBQupXa5E1syrAMGhFfQZaNgP7Bbqm2SzEhT9wr78vpfEwzrho8Qy
         VLy5a5agmuI3DGDD139paXt12mjUEksGt6Q7QlfTE0156bWnjMSUA0SGAv+KQTipEJBx
         FNruJ1oGF3wREHU3qGj5mHO2xSEDeZUrIuQBvUmrxx4feL1qRVM3uMOmZ0g61JRRdU1w
         ORH9J/zVSy8jg7VH5jwMZ1M4buMnNZJYpwJOzYLwh0ZqvtFcliPKBXdZBW+4yHn8VQVX
         1mZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgMEQ3ZipxPOjZ+e73k4NqGunb13HHNETLbPFj6PNZE=;
        b=faOhr90sfawIW27LFIRD9fQEt8WAmrOayceeKin8mA4u89+5Bnuwz9x+ndOQJwTIdT
         fyUU/gl+vieasiC3LRfPsT6Px0GtwstLDi3BffoeleLTEXUBnxpeNWqiJd3yWEUX3Vhr
         PQ7WV/m9wP8Im0x3cb0/uoZ+LQqMCbMN5Kqf+EmkLO9FARVlgpDL0lQ/OuDiSvCtzYM3
         adbmLjdhIynIVJhXo8BJ1MceYUI3mIbcH43h8qUctg1zCQpKfWLa3/tV4/1BfP6IPyGQ
         Ynxh70KHrkOZ8clU2cj2ehuasxE+qj4ifby/3AMbloHavXXp1ZkDETpB6MdGsVMHJBqn
         yMmQ==
X-Gm-Message-State: AOAM532jmkftTNvHzbwkyQBBLG6CM2fAffNN4wMquP6Wclo5SxJp495/
        jjNFSz3W4kVHmlRB0jriPVM=
X-Google-Smtp-Source: ABdhPJzK+H585Ep/N9c3MLO/OEi+i8yEbHHAVjI2naHYhWpkPU6mCXQ+iQqypRWHsYsBSOPmHxH49Q==
X-Received: by 2002:a62:d40c:0:b0:51b:bc02:703b with SMTP id a12-20020a62d40c000000b0051bbc02703bmr45885621pfh.65.1654872910090;
        Fri, 10 Jun 2022 07:55:10 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:2f3e:9a91:223c:1860])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902d04400b00161ac982b52sm18792892pll.95.2022.06.10.07.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:55:09 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH for 4.19.y 1/2] mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
Date:   Fri, 10 Jun 2022 23:55:00 +0900
Message-Id: <20220610145501.624242-1-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a preparation patch for the S29GL064N buffer writes fix. There
is no functional change.

Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220323170458.5608-2-ikegami.t@gmail.com
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 77 ++++++++++++-----------------
 1 file changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 3ab75d3e2ce3..51442a189701 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -731,50 +731,34 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
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
-static int __xipram chip_ready(struct map_info *map, unsigned long addr)
+static int __xipram chip_ready(struct map_info *map, unsigned long addr,
+			       map_word *expected)
 {
 	map_word d, t;
+	int ret;
 
 	d = map_read(map, addr);
 	t = map_read(map, addr);
 
-	return map_word_equal(map, d, t);
-}
+	ret = map_word_equal(map, d, t);
 
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
-static int __xipram chip_good(struct map_info *map, unsigned long addr, map_word expected)
-{
-	map_word oldd, curd;
-
-	oldd = map_read(map, addr);
-	curd = map_read(map, addr);
+	if (!ret || !expected)
+		return ret;
 
-	return	map_word_equal(map, oldd, curd) &&
-		map_word_equal(map, curd, expected);
+	return map_word_equal(map, t, *expected);
 }
 
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
@@ -791,7 +775,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 
 	case FL_STATUS:
 		for (;;) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -829,7 +813,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		chip->state = FL_ERASE_SUSPENDING;
 		chip->erase_suspended = 1;
 		for (;;) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -1360,7 +1344,7 @@ static int do_otp_lock(struct map_info *map, struct flchip *chip, loff_t adr,
 	/* wait for chip to become ready */
 	timeo = jiffies + msecs_to_jiffies(2);
 	for (;;) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -1627,10 +1611,11 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_good" before checking
-		 * "chip_good" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_ready" before checking
+		 * "chip_ready" to avoid the failure due to scheduling.
 		 */
-		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum)) {
+		if (time_after(jiffies, timeo) &&
+		    !chip_ready(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1638,7 +1623,7 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			break;
 		}
 
-		if (chip_good(map, adr, datum))
+		if (chip_ready(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1882,13 +1867,13 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_good" before checking "chip_good" to avoid
-		 * the failure due to scheduling.
+		 * We check "time_after" and "!chip_ready" before checking
+		 * "chip_ready" to avoid the failure due to scheduling.
 		 */
-		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum))
+		if (time_after(jiffies, timeo) && !chip_ready(map, adr, &datum))
 			break;
 
-		if (chip_good(map, adr, datum)) {
+		if (chip_ready(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			goto op_done;
 		}
@@ -2022,7 +2007,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 	 * If the driver thinks the chip is idle, and no toggle bits
 	 * are changing, then the chip is actually idle for sure.
 	 */
-	if (chip->state == FL_READY && chip_ready(map, adr))
+	if (chip->state == FL_READY && chip_ready(map, adr, NULL))
 		return 0;
 
 	/*
@@ -2039,7 +2024,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 
 		/* wait for the chip to become ready */
 		for (i = 0; i < jiffies_to_usecs(timeo); i++) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				return 0;
 
 			udelay(1);
@@ -2103,13 +2088,13 @@ static int do_panic_write_oneword(struct map_info *map, struct flchip *chip,
 	map_write(map, datum, adr);
 
 	for (i = 0; i < jiffies_to_usecs(uWriteTimeout); i++) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		udelay(1);
 	}
 
-	if (!chip_good(map, adr, datum)) {
+	if (!chip_ready(map, adr, &datum)) {
 		/* reset on all failures. */
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
@@ -2250,6 +2235,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr = cfi->addr_unlock1;
 
@@ -2304,7 +2290,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, adr, map_word_ff(map)))
+		if (chip_ready(map, adr, &datum))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -2346,6 +2332,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr += chip->start;
 
@@ -2400,7 +2387,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, adr, map_word_ff(map)))
+		if (chip_ready(map, adr, &datum))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -2593,7 +2580,7 @@ static int __maybe_unused do_ppb_xxlock(struct map_info *map,
 	 */
 	timeo = jiffies + msecs_to_jiffies(2000);	/* 2s max (un)locking */
 	for (;;) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
-- 
2.34.1

