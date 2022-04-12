Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2F74FD699
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbiDLH60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358806AbiDLHmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6D34A908;
        Tue, 12 Apr 2022 00:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7096153F;
        Tue, 12 Apr 2022 07:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC04C385A5;
        Tue, 12 Apr 2022 07:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747959;
        bh=ryXW29UIxyqDCL7e/UGe8sw6Wfpmv8xiOwJCs+jjb0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEzo9ExNjoKFsXzwJo98Qlq27/piN7vsYX8wvHHYLL58mAHWPNYISj2b45qpd2mrW
         vl5Gk3NoM8zDFVeEzPwTQQGQGqW8VCgayLfd+Pm+S6ceE6gQPRLFHragW4FkS8lExq
         1AR/EuFXvfzLsYQ8Xiuvx0LDFjY7zp/o4e9D4NZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Loehle <cloehle@hyperstone.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.17 267/343] mmc: block: Check for errors after write on SPI
Date:   Tue, 12 Apr 2022 08:31:25 +0200
Message-Id: <20220412062959.030600828@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian Löhle <CLoehle@hyperstone.com>

commit 5d435933376962b107bd76970912e7e80247dcc7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1880,6 +1880,31 @@ static inline bool mmc_blk_rq_error(stru
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
@@ -1903,9 +1928,16 @@ static int mmc_blk_card_busy(struct mmc_
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


