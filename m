Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F555468DB
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiFJOzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 10:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiFJOzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 10:55:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B301255B3
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:55:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o33-20020a17090a0a2400b001ea806e48c6so1419926pjo.1
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PaNpQDcnsA3HJ7m58pqRg70sSSb/rmi5GzWOFByASQ0=;
        b=DOvRo1VEJUrCBC3sZHwDyzK5bPUjefZVL8s5MNUsbzdi0GIUThL4C9VH6aXjkdWacP
         o3PC4kxaX/W1dGHl7nMwv22UWBLolKhGYv7KopVInGqqZL8k+dagajcdsxuPKyhZSms4
         9I4kqICxjsDuPpVWjBC8v73oQoLNocCdzDNHMOAIWNnk0BUGMmK8Ii5sq6iZE+VbNedp
         c2TpnKe7qcvOWQiJ26DTIzHlwZXHI4NPgJ/IhP7+f7s80peaN2g1/B9VP774EFEDD7Df
         bPB/Y1zZMHeDxHpF/AyzrxlGudJxS5FZXo/VSUXrG4TEQ2OT4RVtLnXiisBiJukskIUq
         k4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PaNpQDcnsA3HJ7m58pqRg70sSSb/rmi5GzWOFByASQ0=;
        b=FFOfbQzF0PE0BUnqmc/ydSuuTZ5tmsW8eyNJ7CCX7njcweuQT5x/cUV1N7vXsqxGWc
         SvLVDS2kYvNQgzKQTD9qIGFfYDzgtgK9Ie6hNEMp9kEuB3eMueCWy0GlT5UP7EoeXXxe
         jyU02OGJkVjGbgev8qk739wLg/fnkGdf4SL5XRNV8x4jwie9+h7SzV+vCppq3Ryj53Wr
         zeBqxfasb7JMsolp29GaR838NNQ0cYTjBj3JQa5FhhxynRHDcbNraRw+insRzv30jAY7
         W5GnHo83ttDpDRs2e+OOuePVzHevvogDfB34tFFaPNGPvFqQqhl6jplas6HB3wpkSVxT
         UkSQ==
X-Gm-Message-State: AOAM53095yACgHZcgEr4WldgqjAlyC/WLZckc+iCtWnIJtyVIq6NMxPD
        HJmQCYmdLRQlBygkCy4b8wUsvGRJoRQ=
X-Google-Smtp-Source: ABdhPJyJBOcjj5zDPhnwAEvpEH+fh6Kh4YgZ+tw7afGAt5bCSgvoF6YecMBzAWQA+H4yAFjQ9yO9kQ==
X-Received: by 2002:a17:902:e84b:b0:164:8ba3:9cd9 with SMTP id t11-20020a170902e84b00b001648ba39cd9mr45442520plg.49.1654872914099;
        Fri, 10 Jun 2022 07:55:14 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:2f3e:9a91:223c:1860])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902d04400b00161ac982b52sm18792892pll.95.2022.06.10.07.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:55:13 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH for 4.19.y 2/2] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Fri, 10 Jun 2022 23:55:01 +0900
Message-Id: <20220610145501.624242-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610145501.624242-1-ikegami.t@gmail.com>
References: <20220610145501.624242-1-ikegami.t@gmail.com>
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
index 51442a189701..fd1814111086 100644
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
@@ -365,6 +369,15 @@ static void fixup_s29ns512p_sectors(struct mtd_info *mtd)
 		mtd->name);
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
@@ -403,6 +416,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
 #endif
+	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_quirks },
 	{ 0, 0, NULL }
 };
 static struct cfi_fixup jedec_fixup_table[] = {
@@ -761,6 +775,18 @@ static int __xipram chip_ready(struct map_info *map, unsigned long addr,
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
@@ -1611,11 +1637,11 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
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
@@ -1623,7 +1649,7 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			break;
 		}
 
-		if (chip_ready(map, adr, &datum))
+		if (chip_good(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1867,13 +1893,13 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
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

