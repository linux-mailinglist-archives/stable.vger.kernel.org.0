Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00568548F92
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352402AbiFMLQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352551AbiFMLN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F4D36161;
        Mon, 13 Jun 2022 03:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCF0DB80E93;
        Mon, 13 Jun 2022 10:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAFFC34114;
        Mon, 13 Jun 2022 10:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116585;
        bh=gJV/Dd5leOXeTUIaJ5WEAtiBjlOWMbXoC66IahCIXf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdQrBXYMMycVrKG7NVHWbc1uvy7lmNCIo1/K6j6OreRalkU0Qfe68C8NjuOv7YPs1
         /Lta6i/CEJ9fJIMKBG3nC1jH1TWXs7AqATPRj42ljv1C2oQIU25GM7wph1QdnXm9Em
         FikE+LN8ibP7Ds5P5R9zhCAmH3lDMyS/XFlzIByA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tokunori Ikegami <ikegami.t@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.14 217/218] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Mon, 13 Jun 2022 12:11:15 +0200
Message-Id: <20220613094927.210294807@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

commit 0a8e98305f63deaf0a799d5cf5532cc83af035d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |   42 +++++++++++++++++++++++++++++-------
 include/linux/mtd/cfi.h             |    1 
 2 files changed, 35 insertions(+), 8 deletions(-)

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
@@ -365,6 +369,15 @@ static void fixup_s29ns512p_sectors(stru
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
@@ -403,6 +416,7 @@ static struct cfi_fixup cfi_fixup_table[
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
 #endif
+	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_quirks },
 	{ 0, 0, NULL }
 };
 static struct cfi_fixup jedec_fixup_table[] = {
@@ -760,6 +774,18 @@ static int __xipram chip_ready(struct ma
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
@@ -1612,11 +1638,11 @@ static int __xipram do_write_oneword(str
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
@@ -1624,7 +1650,7 @@ static int __xipram do_write_oneword(str
 			break;
 		}
 
-		if (chip_ready(map, adr, &datum))
+		if (chip_good(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1868,13 +1894,13 @@ static int __xipram do_write_buffer(stru
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
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -293,6 +293,7 @@ struct cfi_private {
 	map_word sector_erase_cmd;
 	unsigned long chipshift; /* Because they're of the same type */
 	const char *im_name;	 /* inter_module name for cmdset_setup */
+	unsigned long quirks;
 	struct flchip chips[0];  /* per-chip data structure for each chip */
 };
 


