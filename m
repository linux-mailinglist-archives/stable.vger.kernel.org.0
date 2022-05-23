Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606AF531A0A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbiEWROs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiEWRNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7B76A403;
        Mon, 23 May 2022 10:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46093614E5;
        Mon, 23 May 2022 17:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33210C385A9;
        Mon, 23 May 2022 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325879;
        bh=GY5t5gSGIgwFJw1Zoyi4T5JunrK3iFdiudg0HXBPuLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rW+R7GRqFKyWTdIW9dg2p4FGkDNxJ36s7N/aeo1u1svSsdRwRqklSvlq62n6Imh2Z
         dk9POhAWEzOblDiPt6/kFlW4PNt88OKW9R2KlLCXKm0Ncdwlcrupfv4wcoVhmZs31Q
         845GjptmG2xZH5XSfs+BSxjJiGIzkhp2bXKygWQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.19 17/44] mmc: core: Cleanup BKOPS support
Date:   Mon, 23 May 2022 19:05:01 +0200
Message-Id: <20220523165756.390857345@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 0c204979c691f05666ecfb74501e7adfdde8fbf9 upstream

It's been ~6 years ago since we introduced the BKOPS support for eMMC
cards. The current code is a bit messy and primarily that's because it
prepares to support running BKOPS in an asynchronous mode. However, that
mode has never been fully implemented/enabled. Instead BKOPS is always
executed in synchronously, when the card has reported an urgent BKOPS
level.

For these reasons, let's make the code more readable by dropping the unused
parts. Let's also rename mmc_start_bkops() to mmc_run_bkops(), as to make
it more descriptive.

Cc: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c   |    2 -
 drivers/mmc/core/card.h    |    6 ---
 drivers/mmc/core/mmc.c     |    6 ---
 drivers/mmc/core/mmc_ops.c |   87 +++++++++------------------------------------
 drivers/mmc/core/mmc_ops.h |    3 -
 5 files changed, 21 insertions(+), 83 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1944,7 +1944,7 @@ static void mmc_blk_urgent_bkops(struct
 				 struct mmc_queue_req *mqrq)
 {
 	if (mmc_blk_urgent_bkops_needed(mq, mqrq))
-		mmc_start_bkops(mq->card, true);
+		mmc_run_bkops(mq->card);
 }
 
 void mmc_blk_mq_complete(struct request *req)
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -23,15 +23,13 @@
 #define MMC_STATE_BLOCKADDR	(1<<2)		/* card uses block-addressing */
 #define MMC_CARD_SDXC		(1<<3)		/* card is SDXC */
 #define MMC_CARD_REMOVED	(1<<4)		/* card has been removed */
-#define MMC_STATE_DOING_BKOPS	(1<<5)		/* card is doing BKOPS */
-#define MMC_STATE_SUSPENDED	(1<<6)		/* card is suspended */
+#define MMC_STATE_SUSPENDED	(1<<5)		/* card is suspended */
 
 #define mmc_card_present(c)	((c)->state & MMC_STATE_PRESENT)
 #define mmc_card_readonly(c)	((c)->state & MMC_STATE_READONLY)
 #define mmc_card_blockaddr(c)	((c)->state & MMC_STATE_BLOCKADDR)
 #define mmc_card_ext_capacity(c) ((c)->state & MMC_CARD_SDXC)
 #define mmc_card_removed(c)	((c) && ((c)->state & MMC_CARD_REMOVED))
-#define mmc_card_doing_bkops(c)	((c)->state & MMC_STATE_DOING_BKOPS)
 #define mmc_card_suspended(c)	((c)->state & MMC_STATE_SUSPENDED)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
@@ -39,8 +37,6 @@
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 #define mmc_card_set_ext_capacity(c) ((c)->state |= MMC_CARD_SDXC)
 #define mmc_card_set_removed(c) ((c)->state |= MMC_CARD_REMOVED)
-#define mmc_card_set_doing_bkops(c)	((c)->state |= MMC_STATE_DOING_BKOPS)
-#define mmc_card_clr_doing_bkops(c)	((c)->state &= ~MMC_STATE_DOING_BKOPS)
 #define mmc_card_set_suspended(c) ((c)->state |= MMC_STATE_SUSPENDED)
 #define mmc_card_clr_suspended(c) ((c)->state &= ~MMC_STATE_SUSPENDED)
 
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -2026,12 +2026,6 @@ static int _mmc_suspend(struct mmc_host
 	if (mmc_card_suspended(host->card))
 		goto out;
 
-	if (mmc_card_doing_bkops(host->card)) {
-		err = mmc_stop_bkops(host->card);
-		if (err)
-			goto out;
-	}
-
 	err = mmc_flush_cache(host->card);
 	if (err)
 		goto out;
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -899,34 +899,6 @@ int mmc_can_ext_csd(struct mmc_card *car
 	return (card && card->csd.mmca_vsn > CSD_SPEC_VER_3);
 }
 
-/**
- *	mmc_stop_bkops - stop ongoing BKOPS
- *	@card: MMC card to check BKOPS
- *
- *	Send HPI command to stop ongoing background operations to
- *	allow rapid servicing of foreground operations, e.g. read/
- *	writes. Wait until the card comes out of the programming state
- *	to avoid errors in servicing read/write requests.
- */
-int mmc_stop_bkops(struct mmc_card *card)
-{
-	int err = 0;
-
-	err = mmc_interrupt_hpi(card);
-
-	/*
-	 * If err is EINVAL, we can't issue an HPI.
-	 * It should complete the BKOPS.
-	 */
-	if (!err || (err == -EINVAL)) {
-		mmc_card_clr_doing_bkops(card);
-		mmc_retune_release(card->host);
-		err = 0;
-	}
-
-	return err;
-}
-
 static int mmc_read_bkops_status(struct mmc_card *card)
 {
 	int err;
@@ -943,22 +915,17 @@ static int mmc_read_bkops_status(struct
 }
 
 /**
- *	mmc_start_bkops - start BKOPS for supported cards
- *	@card: MMC card to start BKOPS
- *	@from_exception: A flag to indicate if this function was
- *			 called due to an exception raised by the card
+ *	mmc_run_bkops - Run BKOPS for supported cards
+ *	@card: MMC card to run BKOPS for
  *
- *	Start background operations whenever requested.
- *	When the urgent BKOPS bit is set in a R1 command response
- *	then background operations should be started immediately.
+ *	Run background operations synchronously for cards having manual BKOPS
+ *	enabled and in case it reports urgent BKOPS level.
 */
-void mmc_start_bkops(struct mmc_card *card, bool from_exception)
+void mmc_run_bkops(struct mmc_card *card)
 {
 	int err;
-	int timeout;
-	bool use_busy_signal;
 
-	if (!card->ext_csd.man_bkops_en || mmc_card_doing_bkops(card))
+	if (!card->ext_csd.man_bkops_en)
 		return;
 
 	err = mmc_read_bkops_status(card);
@@ -968,44 +935,26 @@ void mmc_start_bkops(struct mmc_card *ca
 		return;
 	}
 
-	if (!card->ext_csd.raw_bkops_status)
+	if (!card->ext_csd.raw_bkops_status ||
+	    card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2)
 		return;
 
-	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
-	    from_exception)
-		return;
-
-	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
-		timeout = MMC_OPS_TIMEOUT_MS;
-		use_busy_signal = true;
-	} else {
-		timeout = 0;
-		use_busy_signal = false;
-	}
-
 	mmc_retune_hold(card->host);
 
-	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, timeout, 0,
-			use_busy_signal, true, false);
-	if (err) {
+	/*
+	 * For urgent BKOPS status, LEVEL_2 and higher, let's execute
+	 * synchronously. Future wise, we may consider to start BKOPS, for less
+	 * urgent levels by using an asynchronous background task, when idle.
+	 */
+	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+			EXT_CSD_BKOPS_START, 1, MMC_OPS_TIMEOUT_MS);
+	if (err)
 		pr_warn("%s: Error %d starting bkops\n",
 			mmc_hostname(card->host), err);
-		mmc_retune_release(card->host);
-		return;
-	}
 
-	/*
-	 * For urgent bkops status (LEVEL_2 and more)
-	 * bkops executed synchronously, otherwise
-	 * the operation is in progress
-	 */
-	if (!use_busy_signal)
-		mmc_card_set_doing_bkops(card);
-	else
-		mmc_retune_release(card->host);
+	mmc_retune_release(card->host);
 }
-EXPORT_SYMBOL(mmc_start_bkops);
+EXPORT_SYMBOL(mmc_run_bkops);
 
 /*
  * Flush the cache to the non-volatile storage.
--- a/drivers/mmc/core/mmc_ops.h
+++ b/drivers/mmc/core/mmc_ops.h
@@ -40,8 +40,7 @@ int __mmc_switch(struct mmc_card *card,
 		bool use_busy_signal, bool send_status,	bool retry_crc_err);
 int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 		unsigned int timeout_ms);
-int mmc_stop_bkops(struct mmc_card *card);
-void mmc_start_bkops(struct mmc_card *card, bool from_exception);
+void mmc_run_bkops(struct mmc_card *card);
 int mmc_flush_cache(struct mmc_card *card);
 int mmc_cmdq_enable(struct mmc_card *card);
 int mmc_cmdq_disable(struct mmc_card *card);


