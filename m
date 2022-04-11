Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A244FB4EF
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245500AbiDKHfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbiDKHfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E31C3D4A0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D462761461
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5888C385AB;
        Mon, 11 Apr 2022 07:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649662377;
        bh=tIdDCI2G4as91J9BECIs7r0WatPS1RNW7r25zEvnrJo=;
        h=Subject:To:Cc:From:Date:From;
        b=sVEAzCMUccV+nPnBfd5dq34Tby+6m3NVr8I6dZQW6AaW41ro8YSAohhSMJXP9kptl
         7coU8jDbQtYIrHIyw+xK5u46il2XAu7vuLJoR7DskeZnS43YkAIfjStBpQEq//m04D
         D4fWIQDQCcY6PHKiQUNNqJcP3JIc1+aq2/8q9p+E=
Subject: FAILED: patch "[PATCH] mmc: block: Check for errors after write on SPI" failed to apply to 5.10-stable tree
To:     CLoehle@hyperstone.com, andriy.shevchenko@linux.intel.com,
        cloehle@hyperstone.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 09:32:54 +0200
Message-ID: <1649662374172121@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5d435933376962b107bd76970912e7e80247dcc7 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>
Date: Thu, 24 Mar 2022 14:18:41 +0000
Subject: [PATCH] mmc: block: Check for errors after write on SPI

Introduce a SEND_STATUS check for writes through SPI to not mark
an unsuccessful write as successful.

Since SPI SD/MMC does not have states, after a write, the card will
just hold the line LOW until it is ready again. The driver marks the
write therefore as completed as soon as it reads something other than
all zeroes.
The driver does not distinguish from a card no longer signalling busy
and it being disconnected (and the line being pulled-up by the host).
This lead to writes being marked as successful when disconnecting
a busy card.
Now the card is ensured to be still connected by an additional CMD13,
just like non-SPI is ensured to go back to TRAN state.

While at it and since we already poll for the post-write status anyway,
we might as well check for SPIs error bits (any of them).

The disconnecting card problem is reproducable for me after continuous
write activity and randomly disconnecting, around every 20-50 tries
on SPI DS for some card.

Fixes: 7213d175e3b6f ("MMC/SD card driver learns SPI")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/76f6f5d2b35543bab3dfe438f268609c@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 4e67c1403cc9..be2078684417 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1880,6 +1880,31 @@ static inline bool mmc_blk_rq_error(struct mmc_blk_request *brq)
 	       brq->data.error || brq->cmd.resp[0] & CMD_ERRORS;
 }
 
+static int mmc_spi_err_check(struct mmc_card *card)
+{
+	u32 status = 0;
+	int err;
+
+	/*
+	 * SPI does not have a TRAN state we have to wait on, instead the
+	 * card is ready again when it no longer holds the line LOW.
+	 * We still have to ensure two things here before we know the write
+	 * was successful:
+	 * 1. The card has not disconnected during busy and we actually read our
+	 * own pull-up, thinking it was still connected, so ensure it
+	 * still responds.
+	 * 2. Check for any error bits, in particular R1_SPI_IDLE to catch a
+	 * just reconnected card after being disconnected during busy.
+	 */
+	err = __mmc_send_status(card, &status, 0);
+	if (err)
+		return err;
+	/* All R1 and R2 bits of SPI are errors in our case */
+	if (status)
+		return -EIO;
+	return 0;
+}
+
 static int mmc_blk_busy_cb(void *cb_data, bool *busy)
 {
 	struct mmc_blk_busy_data *data = cb_data;
@@ -1903,9 +1928,16 @@ static int mmc_blk_card_busy(struct mmc_card *card, struct request *req)
 	struct mmc_blk_busy_data cb_data;
 	int err;
 
-	if (mmc_host_is_spi(card->host) || rq_data_dir(req) == READ)
+	if (rq_data_dir(req) == READ)
 		return 0;
 
+	if (mmc_host_is_spi(card->host)) {
+		err = mmc_spi_err_check(card);
+		if (err)
+			mqrq->brq.data.bytes_xfered = 0;
+		return err;
+	}
+
 	cb_data.card = card;
 	cb_data.status = 0;
 	err = __mmc_poll_for_busy(card->host, 0, MMC_BLK_TIMEOUT_MS,

