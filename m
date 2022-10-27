Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091E260F145
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 09:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiJ0Hl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 03:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiJ0HlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 03:41:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E00F5B736
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 00:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0498DB8247C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 07:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAA7C433D6;
        Thu, 27 Oct 2022 07:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666856480;
        bh=wrblDm/NdPRbLIhaIn82DtnkbUmhG7r5RaIM7IMz1F0=;
        h=Subject:To:Cc:From:Date:From;
        b=pv1IyfEvRcqSblTbMZjrbGFduUBbG5F6p9VSe3zGBw3gq+LQk7Ruamw0a5wyrqDCr
         yuPPxyef8/tqSYnXJcfLzc5aP+BorzpNpfMg9ZKZv2rEIh3s3xGusWSUJJiygMPwrf
         b97CKSNCdTm9VnlDAWMVKYUM5mTID9nr7L9/H2Zo=
Subject: FAILED: patch "[PATCH] mmc: core: Add SD card quirk for broken discard" failed to apply to 5.10-stable tree
To:     avri.altman@wdc.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Oct 2022 09:41:17 +0200
Message-ID: <1666856477205128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

07d2872bf4c8 ("mmc: core: Add SD card quirk for broken discard")
f7b6fc327327 ("mmc: core: Support zeroout using TRIM for eMMC")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 07d2872bf4c864eb83d034263c155746a2fb7a3b Mon Sep 17 00:00:00 2001
From: Avri Altman <avri.altman@wdc.com>
Date: Wed, 28 Sep 2022 12:57:44 +0300
Subject: [PATCH] mmc: core: Add SD card quirk for broken discard

Some SD-cards from Sandisk that are SDA-6.0 compliant reports they supports
discard, while they actually don't. This might cause mk2fs to fail while
trying to format the card and revert it to a read-only mode.

To fix this problem, let's add a card quirk (MMC_QUIRK_BROKEN_SD_DISCARD)
to indicate that we shall fall-back to use the legacy erase command
instead.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220928095744.16455-1-avri.altman@wdc.com
[Ulf: Updated the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index ce89611a136e..54cd009aee50 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1140,8 +1140,12 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->blkdata;
 	struct mmc_card *card = md->queue.card;
+	unsigned int arg = card->erase_arg;
 
-	mmc_blk_issue_erase_rq(mq, req, MMC_BLK_DISCARD, card->erase_arg);
+	if (mmc_card_broken_sd_discard(card))
+		arg = SD_ERASE_ARG;
+
+	mmc_blk_issue_erase_rq(mq, req, MMC_BLK_DISCARD, arg);
 }
 
 static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 99045e138ba4..cfdd1ff40b86 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -73,6 +73,7 @@ struct mmc_fixup {
 #define EXT_CSD_REV_ANY (-1u)
 
 #define CID_MANFID_SANDISK      0x2
+#define CID_MANFID_SANDISK_SD   0x3
 #define CID_MANFID_ATP          0x9
 #define CID_MANFID_TOSHIBA      0x11
 #define CID_MANFID_MICRON       0x13
@@ -258,4 +259,9 @@ static inline int mmc_card_broken_hpi(const struct mmc_card *c)
 	return c->quirks & MMC_QUIRK_BROKEN_HPI;
 }
 
+static inline int mmc_card_broken_sd_discard(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BROKEN_SD_DISCARD;
+}
+
 #endif
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index be4393988086..29b9497936df 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -100,6 +100,12 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 	MMC_FIXUP("V10016", CID_MANFID_KINGSTON, CID_OEMID_ANY, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
 
+	/*
+	 * Some SD cards reports discard support while they don't
+	 */
+	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
+		  MMC_QUIRK_BROKEN_SD_DISCARD),
+
 	END_FIXUP
 };
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8a30de08e913..c726ea781255 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -293,6 +293,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_IRQ_POLLING	(1<<11)	/* Polling SDIO_CCCR_INTx could create a fake interrupt */
 #define MMC_QUIRK_TRIM_BROKEN	(1<<12)		/* Skip trim */
 #define MMC_QUIRK_BROKEN_HPI	(1<<13)		/* Disable broken HPI support */
+#define MMC_QUIRK_BROKEN_SD_DISCARD	(1<<14)	/* Disable broken SD discard support */
 
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
 

