Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE314EEB60
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiDAKfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344064AbiDAKfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4ECE76
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34DD61740
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9445C340F2;
        Fri,  1 Apr 2022 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648809203;
        bh=smTsikKECcMYny/QbK5eyk7CDE+/US9qDJF4Gw0XPGE=;
        h=Subject:To:Cc:From:Date:From;
        b=CX3CLuNuKIyLmYipjyTk9MsXi2DjF7uJ3VhLiUbxoQMGQ0K7ZOHLuCb1Ys85Nux0X
         7Ihi5mSfTto2QLxiCIKoBC831XAVpl8gHa5/3FE5yFTfeDRLNN7n1LtKTStM6Zn1o+
         92KOOBW/XBIQ88u/MGsmGoDgN9aa2F423cvmmhRo=
Subject: FAILED: patch "[PATCH] mtd: rawnand: protect access to rawnand devices while in" failed to apply to 5.4-stable tree
To:     sean@geanix.com, boris.brezillon@collabora.com,
        miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 12:33:16 +0200
Message-ID: <164880919617154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8cba323437a49a45756d661f500b324fc2d486fe Mon Sep 17 00:00:00 2001
From: Sean Nyekjaer <sean@geanix.com>
Date: Tue, 8 Feb 2022 09:52:13 +0100
Subject: [PATCH] mtd: rawnand: protect access to rawnand devices while in
 suspend

Prevent rawnand access while in a suspended state.

Commit 013e6292aaf5 ("mtd: rawnand: Simplify the locking") allows the
rawnand layer to return errors rather than waiting in a blocking wait.

Tested on a iMX6ULL.

Fixes: 013e6292aaf5 ("mtd: rawnand: Simplify the locking")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220208085213.1838273-1-sean@geanix.com

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 3e4a525ac3ca..612ae60e9763 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -338,16 +338,19 @@ static int nand_isbad_bbm(struct nand_chip *chip, loff_t ofs)
  *
  * Return: -EBUSY if the chip has been suspended, 0 otherwise
  */
-static int nand_get_device(struct nand_chip *chip)
+static void nand_get_device(struct nand_chip *chip)
 {
-	mutex_lock(&chip->lock);
-	if (chip->suspended) {
+	/* Wait until the device is resumed. */
+	while (1) {
+		mutex_lock(&chip->lock);
+		if (!chip->suspended) {
+			mutex_lock(&chip->controller->lock);
+			return;
+		}
 		mutex_unlock(&chip->lock);
-		return -EBUSY;
-	}
-	mutex_lock(&chip->controller->lock);
 
-	return 0;
+		wait_event(chip->resume_wq, !chip->suspended);
+	}
 }
 
 /**
@@ -576,9 +579,7 @@ static int nand_block_markbad_lowlevel(struct nand_chip *chip, loff_t ofs)
 		nand_erase_nand(chip, &einfo, 0);
 
 		/* Write bad block marker to OOB */
-		ret = nand_get_device(chip);
-		if (ret)
-			return ret;
+		nand_get_device(chip);
 
 		ret = nand_markbad_bbm(chip, ofs);
 		nand_release_device(chip);
@@ -3826,9 +3827,7 @@ static int nand_read_oob(struct mtd_info *mtd, loff_t from,
 	    ops->mode != MTD_OPS_RAW)
 		return -ENOTSUPP;
 
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	if (!ops->datbuf)
 		ret = nand_do_read_oob(chip, from, ops);
@@ -4415,13 +4414,11 @@ static int nand_write_oob(struct mtd_info *mtd, loff_t to,
 			  struct mtd_oob_ops *ops)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
-	int ret;
+	int ret = 0;
 
 	ops->retlen = 0;
 
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	switch (ops->mode) {
 	case MTD_OPS_PLACE_OOB:
@@ -4481,9 +4478,7 @@ int nand_erase_nand(struct nand_chip *chip, struct erase_info *instr,
 		return -EIO;
 
 	/* Grab the lock and see if the device is available */
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	/* Shift to get first page */
 	page = (int)(instr->addr >> chip->page_shift);
@@ -4570,7 +4565,7 @@ static void nand_sync(struct mtd_info *mtd)
 	pr_debug("%s: called\n", __func__);
 
 	/* Grab the lock and see if the device is available */
-	WARN_ON(nand_get_device(chip));
+	nand_get_device(chip);
 	/* Release it and go back */
 	nand_release_device(chip);
 }
@@ -4587,9 +4582,7 @@ static int nand_block_isbad(struct mtd_info *mtd, loff_t offs)
 	int ret;
 
 	/* Select the NAND device */
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	nand_select_target(chip, chipnr);
 
@@ -4660,6 +4653,8 @@ static void nand_resume(struct mtd_info *mtd)
 			__func__);
 	}
 	mutex_unlock(&chip->lock);
+
+	wake_up_all(&chip->resume_wq);
 }
 
 /**
@@ -5438,6 +5433,7 @@ static int nand_scan_ident(struct nand_chip *chip, unsigned int maxchips,
 	chip->cur_cs = -1;
 
 	mutex_init(&chip->lock);
+	init_waitqueue_head(&chip->resume_wq);
 
 	/* Enforce the right timings for reset/detection */
 	chip->current_interface_config = nand_get_reset_interface_config();
diff --git a/include/linux/mtd/rawnand.h b/include/linux/mtd/rawnand.h
index 5b88cd51fadb..dcf90144d70b 100644
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -1240,6 +1240,7 @@ struct nand_secure_region {
  * @lock: Lock protecting the suspended field. Also used to serialize accesses
  *        to the NAND device
  * @suspended: Set to 1 when the device is suspended, 0 when it's not
+ * @resume_wq: wait queue to sleep if rawnand is in suspended state.
  * @cur_cs: Currently selected target. -1 means no target selected, otherwise we
  *          should always have cur_cs >= 0 && cur_cs < nanddev_ntargets().
  *          NAND Controller drivers should not modify this value, but they're
@@ -1294,6 +1295,7 @@ struct nand_chip {
 	/* Internals */
 	struct mutex lock;
 	unsigned int suspended : 1;
+	wait_queue_head_t resume_wq;
 	int cur_cs;
 	int read_retries;
 	struct nand_secure_region *secure_regions;

