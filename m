Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7835469E1
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiFJP4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243645AbiFJP4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:56:20 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFBC31D9CC
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:56:19 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c196so24220728pfb.1
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O1ThfUeFZqRqm5mI3XpxWcOpwtqSTN5U9LtVJiwFIPk=;
        b=VQtDsYiqsv4E9uH30HjdyYBgDoLZiUdfdrsYx7H1sL0kwoES1iVyXbuAE8iEY4qdpB
         Z+TJSVDV3IGCU9ra1QwIIdIe7HWUsi78lohurltjlqF/+fX3vLMosv32tCivMBqwoUmd
         onVgSycJRnV/ObtND05R6JO6lJ+taZxz4OGdmaTYVcYKfwb5G1NfzW1hCaw7Pehb000C
         FOEzD4JbhQG0BumkjH5yTk7in0TUyW2wn0Ma91qpNDr+wrTSFA6xppkrVFxUWzyWwlEo
         FJhGeayc8JhNGcnrpVkPeCsZUasAIVF7Ts5MhqqZbxwnFYtjrbH4swBwNeM+YfJVYuiU
         oh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O1ThfUeFZqRqm5mI3XpxWcOpwtqSTN5U9LtVJiwFIPk=;
        b=u/w9CAS9WZ8c2DFPYIloRZ0OAX0Qbu7i8QKqzZvOUsP3tjCJkg0TekbQDczEP44UMe
         tDT69fI9EZCaPmp1U9YDKQ6vWr/VDWxleqOTagZQ+xvwPSihuztjbTCAMwXm6zlNmfkx
         4f1lgehjFHRKgOS8iJtdOJggfVItVsPV3tplB4l5/Op26acaxnpl0kL64NpFa3byMVry
         DbjcBBDjOwW9DShyzC3DTrTGQ/YHcr8EMIqxMkKsk5YcPq36LmRmYnYk+8A5k21U9XT6
         +SWGJyW+XMu/QpJo6xnaBHBA3rGNcHK0NqV/g0jRwJOnjI2Cq9M4CF9XMilZn3N1/18Y
         SJFA==
X-Gm-Message-State: AOAM530FQal8V/JjIvEbhTOxj7Hkcd7WOhZFTZJWaTUFoU8rMV3EYMv7
        qLr5K5jvgJUvVyOEZN4Gq04=
X-Google-Smtp-Source: ABdhPJwlpLKnWYsm1kkHBO9HV1LrVC6Xa4mOX2bNrVQ8cGr6Zj7BN5STjI6nwI8tmXejlQRjFtA/qA==
X-Received: by 2002:a05:6a00:1513:b0:51c:3ca8:47a4 with SMTP id q19-20020a056a00151300b0051c3ca847a4mr20226594pfu.48.1654876578904;
        Fri, 10 Jun 2022 08:56:18 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:2f3e:9a91:223c:1860])
        by smtp.gmail.com with ESMTPSA id b63-20020a62cf42000000b0051ba2c0ff24sm20112293pfg.144.2022.06.10.08.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:56:18 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH for 4.9.y 2/2] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Sat, 11 Jun 2022 00:56:04 +0900
Message-Id: <20220610155604.1342511-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610155604.1342511-1-ikegami.t@gmail.com>
References: <20220610155604.1342511-1-ikegami.t@gmail.com>
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

Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
check correct value") buffered writes fail on S29GL064N. This is
because, on S29GL064N, reads return 0xFF at the end of DQ polling for
write completion, where as, chip_good() check expects actual data
written to the last location to be returned post DQ polling completion.
Fix is to revert to using chip_good() for S29GL064N which only checks
for DQ lines to settle down to determine write completion.

Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Cc: stable@vger.kernel.org
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Acked-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220323170458.5608-3-ikegami.t@gmail.com
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 42 +++++++++++++++++++++++------
 include/linux/mtd/cfi.h             |  1 +
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index bcc2ce67c996..a2b12d347f4d 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -49,6 +49,10 @@
 #define SST49LF008A		0x005a
 #define AT49BV6416		0x00d6
 
+enum cfi_quirks {
+	CFI_QUIRK_DQ_TRUE_DATA = BIT(0),
+};
+
 static int cfi_amdstd_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int cfi_amdstd_write_words(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 static int cfi_amdstd_write_buffers(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
@@ -361,6 +365,15 @@ static void fixup_s29ns512p_sectors(struct mtd_info *mtd)
 	pr_warning("%s: Bad S29NS512P CFI data; adjust to 512 sectors\n", mtd->name);
 }
 
+static void fixup_quirks(struct mtd_info *mtd)
+{
+	struct map_info *map = mtd->priv;
+	struct cfi_private *cfi = map->fldrv_priv;
+
+	if (cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01)
+		cfi->quirks |= CFI_QUIRK_DQ_TRUE_DATA;
+}
+
 /* Used to fix CFI-Tables of chips without Extended Query Tables */
 static struct cfi_fixup cfi_nopri_fixup_table[] = {
 	{ CFI_MFR_SST, 0x234a, fixup_sst39vf }, /* SST39VF1602 */
@@ -399,6 +412,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
 #endif
+	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_quirks },
 	{ 0, 0, NULL }
 };
 static struct cfi_fixup jedec_fixup_table[] = {
@@ -756,6 +770,18 @@ static int __xipram chip_ready(struct map_info *map, unsigned long addr,
 	return map_word_equal(map, t, *expected);
 }
 
+static int __xipram chip_good(struct map_info *map, unsigned long addr,
+			      map_word *expected)
+{
+	struct cfi_private *cfi = map->fldrv_priv;
+	map_word *datum = expected;
+
+	if (cfi->quirks & CFI_QUIRK_DQ_TRUE_DATA)
+		datum = NULL;
+
+	return chip_ready(map, addr, datum);
+}
+
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -1608,11 +1634,11 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_ready" before checking
-		 * "chip_ready" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_ready(map, adr, &datum)) {
+		    !chip_good(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1620,7 +1646,7 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			break;
 		}
 
-		if (chip_ready(map, adr, &datum))
+		if (chip_good(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1864,13 +1890,13 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_ready" before checking
-		 * "chip_ready" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
 		 */
-		if (time_after(jiffies, timeo) && !chip_ready(map, adr, &datum))
+		if (time_after(jiffies, timeo) && !chip_good(map, adr, &datum))
 			break;
 
-		if (chip_ready(map, adr, &datum)) {
+		if (chip_good(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			goto op_done;
 		}
diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index 9b57a9b1b081..4ead3d1559f5 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -293,6 +293,7 @@ struct cfi_private {
 	map_word sector_erase_cmd;
 	unsigned long chipshift; /* Because they're of the same type */
 	const char *im_name;	 /* inter_module name for cmdset_setup */
+	unsigned long quirks;
 	struct flchip chips[0];  /* per-chip data structure for each chip */
 };
 
-- 
2.34.1

