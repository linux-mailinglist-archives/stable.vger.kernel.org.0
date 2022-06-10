Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621DB546973
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbiFJPfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239979AbiFJPfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:35:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F71022BB84
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:35:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso2597437pjk.5
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IDEWR0juc60EXCI9w0E4Pmy03UD3nw20KjZu5O3Jrio=;
        b=oeogw6whqUHyZ4iDwPLFWze3IoUnPXMDOTVuOD4Q6mCzUCwJzexkorTJAEVPiPrBfv
         YwRKoA2+ptia8wMYVIPm/dnAzTb+D1q3C5E/wWItkKu4YPdnFCGHKW7ZfTWCj9BdOart
         u4W4KCE6a8OcC+1aev8fbsH0cA+1YVudRoGY8x8YWbvy+seuT4nyGQmskjWNBm1Qy25b
         xAQBpBDjNCXUiw8LRnlMNZrBc+5WjmZuEU+dTjGcJ7h6kXItvAFJ0HAoTGV6jbG5Lr8d
         bzhwuUjI+tNEx1NncnzTZ4E+erHql9P749l/9sYiPgZU5HxfDMPNA3kWrARhtQoU7DIN
         gkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IDEWR0juc60EXCI9w0E4Pmy03UD3nw20KjZu5O3Jrio=;
        b=emO5T05p7JVBSTQHTGhC03b02q/LFNZEgjfRgpoBnCuA8mcCZMDfLhvZRGbMp3i+Ys
         Gq6UujZinyisoMX+gxbmMOafq1i4ltjIGdIP7l24Qa1Ble1RJJXOwsqIt3HNInPBqmkV
         LLD+yQO/6gWDckbsLml6pEwraqWYpxEm0dGwtG8wcPaa8TymZWM/jHP1yppcrp52aj8f
         0d2vD4DPxcy6CSph/6AXWyIpjzUMAzwOFiZgApLwv+Bbd/jRtsag6VRwr184UAAyLnfw
         7OQlFcxaH23Az/bSQul9YzhfF9ZeMtVdesXH8u5UDK3/uTvcn+yiKcjgqAO7OSyQ1hRC
         3uNA==
X-Gm-Message-State: AOAM5308IuyliOW4oKJS576ZI+hh6xkBcvJQlhGwIbZovFgCNsZQ6ihz
        7IAFdPP1wHYFuGyU8+wX/ZxGdMMbogo=
X-Google-Smtp-Source: ABdhPJzTU40kSBVLia5CbDzOGOlqr8r8phDF5ypDr/gZJBoRz9nsxSKBMUlISuWvEyXc4II7pklDGQ==
X-Received: by 2002:a17:903:234a:b0:167:997f:bc53 with SMTP id c10-20020a170903234a00b00167997fbc53mr18320206plh.47.1654875339481;
        Fri, 10 Jun 2022 08:35:39 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:2f3e:9a91:223c:1860])
        by smtp.gmail.com with ESMTPSA id ca16-20020a056a00419000b00518d06efbc8sm10964153pfb.98.2022.06.10.08.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:35:39 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH for 4.14.y 2/2] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Sat, 11 Jun 2022 00:35:09 +0900
Message-Id: <20220610153509.1024375-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610153509.1024375-1-ikegami.t@gmail.com>
References: <20220610153509.1024375-1-ikegami.t@gmail.com>
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
index a8e1a961e844..e3477b5bceaf 100644
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
@@ -760,6 +774,18 @@ static int __xipram chip_ready(struct map_info *map, unsigned long addr,
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
@@ -1612,11 +1638,11 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
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
@@ -1624,7 +1650,7 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			break;
 		}
 
-		if (chip_ready(map, adr, &datum))
+		if (chip_good(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1868,13 +1894,13 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
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

