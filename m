Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE64965D584
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbjADOWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjADOWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:22:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C983AA92
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:22:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EFF61426
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0CDC433EF;
        Wed,  4 Jan 2023 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672842155;
        bh=Mp3LrQs0xKf6zIuh6TgjT1prQAlcwvqRajfgKvrjybI=;
        h=Subject:To:Cc:From:Date:From;
        b=AhWPWAjCeEre+tqtkqiIx0bu47tHrvjrRVXJkA8ZdFJGfr18oIlcpJKvnCyl340yW
         unmBCvp216V/rBbb9HrHM5XNEiAGH4z5YyN1hrnLy+7w1hYzsAfyg6EXpNpbuvcSg1
         uVZ/pCSuLqUuM6B49nsx7vOsmvLbjaOxsEFIszUE=
Subject: FAILED: patch "[PATCH] block: mq-deadline: Fix dd_finish_request() for zoned devices" failed to apply to 5.15-stable tree
To:     damien.lemoal@opensource.wdc.com, axboe@kernel.dk,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:21:43 +0100
Message-ID: <167284210313124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2820e5d0820a ("block: mq-deadline: Fix dd_finish_request() for zoned devices")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2820e5d0820ac4daedff1272616a53d9c7682fd2 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Thu, 24 Nov 2022 11:12:07 +0900
Subject: [PATCH] block: mq-deadline: Fix dd_finish_request() for zoned devices

dd_finish_request() tests if the per prio fifo_list is not empty to
determine if request dispatching must be restarted for handling blocked
write requests to zoned devices with a call to
blk_mq_sched_mark_restart_hctx(). While simple, this implementation has
2 problems:

1) Only the priority level of the completed request is considered.
   However, writes to a zone may be blocked due to other writes to the
   same zone using a different priority level. While this is unlikely to
   happen in practice, as writing a zone with different IO priorirites
   does not make sense, nothing in the code prevents this from
   happening.
2) The use of list_empty() is dangerous as dd_finish_request() does not
   take dd->lock and may run concurrently with the insert and dispatch
   code.

Fix these 2 problems by testing the write fifo list of all priority
levels using the new helper dd_has_write_work(), and by testing each
fifo list using list_empty_careful().

Fixes: c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20221124021208.242541-2-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 5639921dfa92..36374481cb87 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -789,6 +789,18 @@ static void dd_prepare_request(struct request *rq)
 	rq->elv.priv[0] = NULL;
 }
 
+static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
+{
+	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
+	enum dd_prio p;
+
+	for (p = 0; p <= DD_PRIO_MAX; p++)
+		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
+			return true;
+
+	return false;
+}
+
 /*
  * Callback from inside blk_mq_free_request().
  *
@@ -828,9 +840,10 @@ static void dd_finish_request(struct request *rq)
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
-		if (!list_empty(&per_prio->fifo_list[DD_WRITE]))
-			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+		if (dd_has_write_work(rq->mq_hctx))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 	}
 }
 

