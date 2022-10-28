Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F426110A7
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiJ1MHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiJ1MHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0011D3A41
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F30F9B829B9
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52661C433D6;
        Fri, 28 Oct 2022 12:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958857;
        bh=+42Tw2WE1z5rd+JAvD8/VHSMB+abUhfdYwvfiHqM//g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GyIV49qf6/vByioPm/poq5BLc2itVmWyEnaLAmU4clXjRRzx8pfiRX7Xn6bJpBpP
         7UlE1FCzI+zU77yfDkNG7zeEGSR1uPvwX4/9hXxrP3UkjfhT7SwidBFBXHl4o3Uh+8
         CkS3adldsIQ6NXRSC7/vVE3bHX92H65LNWPnyFO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 71/73] mmc: core: Add SD card quirk for broken discard
Date:   Fri, 28 Oct 2022 14:04:08 +0200
Message-Id: <20221028120235.450120903@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avri Altman <avri.altman@wdc.com>

commit 07d2872bf4c864eb83d034263c155746a2fb7a3b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c  |    7 ++++++-
 drivers/mmc/core/card.h   |    6 ++++++
 drivers/mmc/core/quirks.h |    6 ++++++
 include/linux/mmc/card.h  |    1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1069,6 +1069,11 @@ static void mmc_blk_issue_discard_rq(str
 	nr = blk_rq_sectors(req);
 
 	do {
+		unsigned int erase_arg = card->erase_arg;
+
+		if (mmc_card_broken_sd_discard(card))
+			erase_arg = SD_ERASE_ARG;
+
 		err = 0;
 		if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -1079,7 +1084,7 @@ static void mmc_blk_issue_discard_rq(str
 					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
-			err = mmc_erase(card, from, nr, card->erase_arg);
+			err = mmc_erase(card, from, nr, erase_arg);
 	} while (err == -EIO && !mmc_blk_reset(md, card->host, type));
 	if (err)
 		status = BLK_STS_IOERR;
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -70,6 +70,7 @@ struct mmc_fixup {
 #define EXT_CSD_REV_ANY (-1u)
 
 #define CID_MANFID_SANDISK      0x2
+#define CID_MANFID_SANDISK_SD   0x3
 #define CID_MANFID_ATP          0x9
 #define CID_MANFID_TOSHIBA      0x11
 #define CID_MANFID_MICRON       0x13
@@ -222,4 +223,9 @@ static inline int mmc_card_broken_hpi(co
 	return c->quirks & MMC_QUIRK_BROKEN_HPI;
 }
 
+static inline int mmc_card_broken_sd_discard(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BROKEN_SD_DISCARD;
+}
+
 #endif
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -99,6 +99,12 @@ static const struct mmc_fixup __maybe_un
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
 
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -270,6 +270,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_IRQ_POLLING	(1<<11)	/* Polling SDIO_CCCR_INTx could create a fake interrupt */
 #define MMC_QUIRK_TRIM_BROKEN	(1<<12)		/* Skip trim */
 #define MMC_QUIRK_BROKEN_HPI	(1<<13)		/* Disable broken HPI support */
+#define MMC_QUIRK_BROKEN_SD_DISCARD	(1<<14)	/* Disable broken SD discard support */
 
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
 


