Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2272653E859
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbiFFNqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239038AbiFFNqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 09:46:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E09C1B1865
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 06:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC5B612EA
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 13:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12534C385A9;
        Mon,  6 Jun 2022 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654523165;
        bh=Iil6lLZZDL0JzwwxBoP2a2PE4v16GXRg7WCa5guA5Is=;
        h=Subject:To:Cc:From:Date:From;
        b=WIEXy4bvqHyXCqJwz5Hr7TvHgPguBtvupZfK14QoGcX4kfG3IGEwposakjBxvFeDl
         mYgq6LQ2v+XJ/GvK0qGbxFmbI1ehYociyF3J4lUNNUY8AkDD5U0MNnny7Gle056w5C
         D9Nta6FzG+wgTwOB2NMdMC4vxD7OrgZ9WV2Q0MVg=
Subject: FAILED: patch "[PATCH] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N" failed to apply to 4.19-stable tree
To:     ikegami.t@gmail.com, miquel.raynal@bootlin.com, vigneshr@ti.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 15:45:52 +0200
Message-ID: <16545231528365@kroah.com>
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

From 0a8e98305f63deaf0a799d5cf5532cc83af035d1 Mon Sep 17 00:00:00 2001
From: Tokunori Ikegami <ikegami.t@gmail.com>
Date: Thu, 24 Mar 2022 02:04:56 +0900
Subject: [PATCH] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

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
 

