Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C0A5469E0
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbiFJP4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiFJP4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:56:15 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06669317146
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:56:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r1so5855716plo.10
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Bzqu1LIvuWQIdqIY6UYs6zKE8HUuue1rfDj3nxsNEo=;
        b=E25w+IlUgtk/i2Q0QN+XknLKPq1UApK51yWAVTiBVQizEBnUE/n6oUtbB3ITUZcrr0
         6Qqy15r/RIWB58iZ7K/lppzgAhhB44MgFqTrkFnxWNOqUtTeiPB24g/xlo0qjEwLmOj3
         8l0lovhPbjHbnNCU2BtQAXuZS5tFV1ABd38rgVuj2V+x7jLyvjtVSK9Xzmn8qP6ofroP
         f2+aWI1+yVZBbllGe0hMyoojEZMXrcS/WqFTXqUo1gmTppOUAGfgilMXV1Tiwi3Ihd1n
         JU0dRfS0YM4hCXcjiHXNkR7ipjfRJ99uhSgTrSD4IFwcab3LEaplw7asVWCzBQRAhyq8
         Wh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Bzqu1LIvuWQIdqIY6UYs6zKE8HUuue1rfDj3nxsNEo=;
        b=trw1PZdL8/rdhN320Msyu4fYHveAytj8pkLDJ+2BosmPCj2EtLaiHgyd7fX60ldv4Q
         rOOicfxuRWZTy8uOAzpVpqqsjHT6blK4b3Jf4gFFPh3OJ9VJ11Zo0IZcy9lOJiZ8lNJm
         sr907mnzwGw0fPmDWDlZ9P+YR6/U+Kydb7dn0CnJdnP0JR2Hu7IRIZ8VHmo/fSX8kb8c
         8v531oev+UfFrLny4JWd90xQpwxmEEe0mqe//F58bzQ0qa1scCF+Z/fW+eGiUrGtKWvB
         FVbro3H7GTmYm2sezJSS0yoIZe47x96dE+WbKVo8otx6+QLMhB8CpYYWzrumW1hXQ308
         scnA==
X-Gm-Message-State: AOAM5301nPYkC6C8pCrD7AJfn6mmwEUbjiBdruCoI5ztTC9vRNz5hNlu
        6mNMxFZ8JuhDf9CWfjkG1zKrczIWCvc=
X-Google-Smtp-Source: ABdhPJwS0JrHYRk9eWv4lg7VqlSreiM+3jce5vRuPMoSAoI1OXFZ3ddF4HoXIqqILK8dT7mqG1FLHw==
X-Received: by 2002:a17:90b:4d11:b0:1e8:436b:a9cc with SMTP id mw17-20020a17090b4d1100b001e8436ba9ccmr437928pjb.40.1654876572214;
        Fri, 10 Jun 2022 08:56:12 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:2f3e:9a91:223c:1860])
        by smtp.gmail.com with ESMTPSA id b63-20020a62cf42000000b0051ba2c0ff24sm20112293pfg.144.2022.06.10.08.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:56:11 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH for 4.9.y 1/2] mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
Date:   Sat, 11 Jun 2022 00:56:03 +0900
Message-Id: <20220610155604.1342511-1-ikegami.t@gmail.com>
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
index 3c4819a05bf0..bcc2ce67c996 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -726,50 +726,34 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
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
@@ -786,7 +770,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 
 	case FL_STATUS:
 		for (;;) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -824,7 +808,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		chip->state = FL_ERASE_SUSPENDING;
 		chip->erase_suspended = 1;
 		for (;;) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -1357,7 +1341,7 @@ static int do_otp_lock(struct map_info *map, struct flchip *chip, loff_t adr,
 	/* wait for chip to become ready */
 	timeo = jiffies + msecs_to_jiffies(2);
 	for (;;) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -1624,10 +1608,11 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
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
@@ -1635,7 +1620,7 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			break;
 		}
 
-		if (chip_good(map, adr, datum))
+		if (chip_ready(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1879,13 +1864,13 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
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
@@ -2019,7 +2004,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 	 * If the driver thinks the chip is idle, and no toggle bits
 	 * are changing, then the chip is actually idle for sure.
 	 */
-	if (chip->state == FL_READY && chip_ready(map, adr))
+	if (chip->state == FL_READY && chip_ready(map, adr, NULL))
 		return 0;
 
 	/*
@@ -2036,7 +2021,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 
 		/* wait for the chip to become ready */
 		for (i = 0; i < jiffies_to_usecs(timeo); i++) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				return 0;
 
 			udelay(1);
@@ -2100,13 +2085,13 @@ static int do_panic_write_oneword(struct map_info *map, struct flchip *chip,
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
@@ -2247,6 +2232,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr = cfi->addr_unlock1;
 
@@ -2301,7 +2287,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, adr, map_word_ff(map)))
+		if (chip_ready(map, adr, &datum))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -2343,6 +2329,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr += chip->start;
 
@@ -2397,7 +2384,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, adr, map_word_ff(map))) {
+		if (chip_ready(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			break;
 		}
@@ -2612,7 +2599,7 @@ static int __maybe_unused do_ppb_xxlock(struct map_info *map,
 	 */
 	timeo = jiffies + msecs_to_jiffies(2000);	/* 2s max (un)locking */
 	for (;;) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
-- 
2.34.1

