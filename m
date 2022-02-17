Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEFB4BA960
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbiBQTOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:14:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiBQTOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:14:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4F58D697
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE168B820E1
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 19:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD69C340E8;
        Thu, 17 Feb 2022 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645125253;
        bh=izndXc0qrmYSnilFVtThrDdm+M6SWElt4WWQYXK+VDs=;
        h=Subject:To:Cc:From:Date:From;
        b=UQADytxYUIecdcoadkFMOddiZvOMaohyM+l6xF5D4Q3dS+IYft6iuQUbpwLb4ijud
         UwnRJb7Zct7fVXMkb2tAN6Mt8o4crYERLCM98f6N24kImMl6CZM8NVka2CTsF2nEzG
         MBp1e/51dJW2J6sBr6ICcuccUKeSKgTVWFCsoyRY=
Subject: FAILED: patch "[PATCH] mmc: block: fix read single on recovery logic" failed to apply to 5.4-stable tree
To:     CLoehle@hyperstone.com, adrian.hunter@intel.com,
        cloehle@hyperstone.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Feb 2022 20:14:10 +0100
Message-ID: <16451252501696@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 54309fde1a352ad2674ebba004a79f7d20b9f037 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>
Date: Fri, 4 Feb 2022 15:11:37 +0000
Subject: [PATCH] mmc: block: fix read single on recovery logic

On reads with MMC_READ_MULTIPLE_BLOCK that fail,
the recovery handler will use MMC_READ_SINGLE_BLOCK for
each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
The logic for this is fixed to never report unsuccessful reads
as success to the block layer.

On command error with retries remaining, blk_update_request was
called with whatever value error was set last to.
In case it was last set to BLK_STS_OK (default), the read will be
reported as success, even though there was no data read from the device.
This could happen on a CRC mismatch for the response,
a card rejecting the command (e.g. again due to a CRC mismatch).
In case it was last set to BLK_STS_IOERR, the error is reported correctly,
but no retries will be attempted.

Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/bc706a6ab08c4fe2834ba0c05a804672@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 4e61b28a002f..8d718aa56d33 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1682,31 +1682,31 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = mq->card;
 	struct mmc_host *host = card->host;
 	blk_status_t error = BLK_STS_OK;
-	int retries = 0;
 
 	do {
 		u32 status;
 		int err;
+		int retries = 0;
 
-		mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
+		while (retries++ <= MMC_READ_SINGLE_RETRIES) {
+			mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
 
-		mmc_wait_for_req(host, mrq);
+			mmc_wait_for_req(host, mrq);
 
-		err = mmc_send_status(card, &status);
-		if (err)
-			goto error_exit;
-
-		if (!mmc_host_is_spi(host) &&
-		    !mmc_ready_for_data(status)) {
-			err = mmc_blk_fix_state(card, req);
+			err = mmc_send_status(card, &status);
 			if (err)
 				goto error_exit;
-		}
 
-		if (mrq->cmd->error && retries++ < MMC_READ_SINGLE_RETRIES)
-			continue;
+			if (!mmc_host_is_spi(host) &&
+			    !mmc_ready_for_data(status)) {
+				err = mmc_blk_fix_state(card, req);
+				if (err)
+					goto error_exit;
+			}
 
-		retries = 0;
+			if (!mrq->cmd->error)
+				break;
+		}
 
 		if (mrq->cmd->error ||
 		    mrq->data->error ||

