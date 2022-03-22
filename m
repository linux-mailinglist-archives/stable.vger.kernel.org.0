Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0206B4E366E
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiCVCMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiCVCMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:12:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3891E1CFC1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:10:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gb19so14529379pjb.1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j0NQxKjly0nqK+Zg1+EsccxDdb8ufucNliJsJwxIFJ0=;
        b=AjSbFypixNHgd6glOF4XCOxL55EIecI8X/ZAsz/glwzNf7ytgP5uj0+oAGewOuv1i6
         UzxxRPkqOvxgpY01wHt7aX5FVJDE6/y16KUqfjAeiC15M4mTcmXZTEEuGxAd2UdqBByf
         raREGCkx4bllIB0TkhsxPSnd797FDP9eP7UXtd5f3OPbaw0fJ0F20fgcqk6ycf3pSz/C
         v/YONjti9+ms/thzSEDoJhmVbKx7ytZ742TknuUW20PKKfKzEcZLW7DfkC5Lq1Skl8+H
         jHQ3WWxuOzMgqmrJ0uX2tijX15VgXX8cGrSOvkdomafcSLMtaVI0zpkGcY1DFLhHjz5F
         WOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j0NQxKjly0nqK+Zg1+EsccxDdb8ufucNliJsJwxIFJ0=;
        b=VPF+3MA6sORdt2uV63renN8mwQ60u9Q7I5A5OHaLynvBwQy7jPT3FwT+IQB8EIHej4
         9v7H+uNBSZ/1NM8ZBvy9hkytNl7vlq85WikTbU++RAyNXtny6BSIpFaHBKqv3/Pr0uqs
         RFzQsiJiMMWg/cJSdJQVmsYbqqPM81WMaM4LaDVHjL0N/XysI+8Pi228m2fvy0KtsyVC
         6m+ltufSpIDHVvN1f6QFD6wAzUMcftuGBee+e03Cid3sjacjV/6wM2f0sYW28X6rBW8G
         l5/2lze420rb1ONzlEAB+6+vf86dD7+xzt1MHGn/4JamVFLVrovoMro8upGbFAdbQPJK
         J5zg==
X-Gm-Message-State: AOAM5319HokYKV4DrEKRiHYz1rW62U2rCID86mKRYJV6n5tgvvivtmwF
        CzQorW5sURWr5s3veLrELDA=
X-Google-Smtp-Source: ABdhPJwLyb6N0/nqD9s7kNXVw4oaMnIZnEFhjII5jgFgCwYZzvxMgAiy0HKSwqbh++Q0EYxMnV6img==
X-Received: by 2002:a17:90b:250f:b0:1b8:f257:c39 with SMTP id ns15-20020a17090b250f00b001b8f2570c39mr2261902pjb.135.1647915038566;
        Mon, 21 Mar 2022 19:10:38 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:1847:b4dd:1227:a1f6])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm15673579pgr.37.2022.03.21.19.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:10:38 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v5 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Tue, 22 Mar 2022 11:10:00 +0900
Message-Id: <20220322021001.138206-3-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220322021001.138206-1-ikegami.t@gmail.com>
References: <20220322021001.138206-1-ikegami.t@gmail.com>
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

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 42 +++++++++++++++++++++++------
 include/linux/mtd/cfi.h             |  1 +
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 9ccde90dc180..59334530dd46 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -59,6 +59,10 @@
 #define CFI_SR_WBASB		BIT(3)
 #define CFI_SR_SLSB		BIT(1)
 
+enum cfi_quirks {
+	CFI_QUIRK_DQ_TRUE_DATA = BIT(0),
+};
+
 static int cfi_amdstd_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int cfi_amdstd_write_words(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 #if !FORCE_WORD_WRITE
@@ -436,6 +440,15 @@ static void fixup_s29ns512p_sectors(struct mtd_info *mtd)
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
@@ -474,6 +487,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
 #endif
+	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_quirks },
 	{ 0, 0, NULL }
 };
 static struct cfi_fixup jedec_fixup_table[] = {
@@ -846,6 +860,18 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
 	return map_word_equal(map, t, *expected);
 }
 
+static int __xipram chip_good(struct map_info *map, struct flchip *chip,
+			      unsigned long addr, map_word *expected)
+{
+	struct cfi_private *cfi = map->fldrv_priv;
+	map_word *datum = expected;
+
+	if (cfi->quirks & CFI_QUIRK_DQ_TRUE_DATA)
+		datum = NULL;
+
+	return chip_ready(map, chip, addr, datum);
+}
+
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -1662,11 +1688,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_ready" before checking
-		 * "chip_ready" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_ready(map, chip, adr, &datum)) {
+		    !chip_good(map, chip, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1674,7 +1700,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 			break;
 		}
 
-		if (chip_ready(map, chip, adr, &datum)) {
+		if (chip_good(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -1942,18 +1968,18 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_ready" before checking
-		 * "chip_ready" to avoid the failure due to scheduling.
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_ready(map, chip, adr, &datum)) {
+		    !chip_good(map, chip, adr, &datum)) {
 			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
 			       __func__, adr);
 			ret = -EIO;
 			break;
 		}
 
-		if (chip_ready(map, chip, adr, &datum)) {
+		if (chip_good(map, chip, adr, &datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index fd1ecb821106..d88bb56c18e2 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -286,6 +286,7 @@ struct cfi_private {
 	map_word sector_erase_cmd;
 	unsigned long chipshift; /* Because they're of the same type */
 	const char *im_name;	 /* inter_module name for cmdset_setup */
+	unsigned long quirks;
 	struct flchip chips[];  /* per-chip data structure for each chip */
 };
 
-- 
2.32.0

