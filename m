Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB74E5722
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 18:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiCWRHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 13:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245673AbiCWRHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 13:07:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E615775C3C
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 10:05:40 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j13so2112065plj.8
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/nPaaSxMF+oMbJ1b8ycGXIGlnF01X/wLsUX+PxH/BTQ=;
        b=eTg0QR4I6vaVGQgiwxhhWzjHLX5LC/NpJkAWNvwSNLJuoN9Dn2+4CG+35wKi4RrQTL
         EmrZauvKASUysm4vCaKCGCA+N39dhaAN127oQ6WmUb+iBFKFpESpjJKmn5MjrsO/WkUY
         aIS7DHv3EUe75kv0yeWYpDn6kiM043t2+BumCT2ZCtyrfmu5m1Are2spbO/xDo+sJxVl
         SWQdLCadzaeXb21o2w/qX1wJSyGm94XFdUA+hc6OuiSDJsyFwPFnYLFrHw8xGD9K5d6d
         pq8MIymyo89jXdszxKYXM8NqWDwG4zTloqlwoMDLM8+FoR+yUbe8ygPwe/yXOpDIyOkc
         tg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/nPaaSxMF+oMbJ1b8ycGXIGlnF01X/wLsUX+PxH/BTQ=;
        b=ZLvp4/eFtePmOfUZGh+R6KgaXUZQcjz8ZsiFFSXK5mok07tstMJtut2SChAIvtMl6W
         W0lrP5qj6Aj8dBNKOpZyms/3Jr5aFv0fVbUvC3njchUDMlJxxXxf7mVCvqQ1LQiRIgKU
         OZlmiQ0BL66R6hrh87dxdUlWJEsnYvh2/jaLpA6Xsmts83KzBCEuPcEwBO+bq5PxL01w
         kBTgtMHaBm3VejPdYqM8uJWxADp7F5ATeO4U2gr7FuYmswMwknSrtZHiMLqNrbKvFocI
         HqTK6Q/we3lMzxjDuoKuXdTbcnN2thbA8tr9/gXu+ZgGieS4zP2a7ZWxzyokwSEN1lrf
         TYaA==
X-Gm-Message-State: AOAM532nNpVwh/d768fdIfYzJyHQ/9Nh+s7I2AhFXep0oS5yu4ewv5EC
        JODzLgGFhPwnh9R145LOAoU=
X-Google-Smtp-Source: ABdhPJxifua7HddAusKeThMtzkh7d/9vEjJtKx/PaoRbpdRv+4/AtGOG0fBCPVEFPueWK/f8Z0YuEw==
X-Received: by 2002:a17:902:bc4a:b0:153:e123:e169 with SMTP id t10-20020a170902bc4a00b00153e123e169mr897212plz.54.1648055140133;
        Wed, 23 Mar 2022 10:05:40 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:98c:eff5:b721:5f7b])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm6649709pjn.14.2022.03.23.10.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:05:39 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v7 1/4] mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
Date:   Thu, 24 Mar 2022 02:04:55 +0900
Message-Id: <20220323170458.5608-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220323170458.5608-1-ikegami.t@gmail.com>
References: <20220323170458.5608-1-ikegami.t@gmail.com>
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

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 95 ++++++++++-------------------
 1 file changed, 32 insertions(+), 63 deletions(-)

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
-- 
2.32.0

