Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83270664AA7
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbjAJSeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbjAJSdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:33:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85BC9152F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D472B81904
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDC3C433EF;
        Tue, 10 Jan 2023 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375387;
        bh=1ubklAFHVW7csSkJ3bvFLHU+IWuN6cvvHpOO6KJwJ8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3TEdio0Hy1nu4PU/x6cYFeW2BO3dKkIuzP58Qj5vPHyJq1mAkh43VTWTTLkV/gte
         eiHQyVwdhJZH97T+NRuQuEDc16pEFBW0ayAMGxlB1VYLiuiRAy8ek8t1BA291+t5tq
         iE7M5BfU+BbTtkcXwIzXt5Ja0MQVLyjw8z1hCXRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 165/290] block: mq-deadline: Fix dd_finish_request() for zoned devices
Date:   Tue, 10 Jan 2023 19:04:17 +0100
Message-Id: <20230110180037.599451655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 2820e5d0820ac4daedff1272616a53d9c7682fd2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -791,6 +791,18 @@ static void dd_prepare_request(struct re
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
@@ -813,7 +825,6 @@ static void dd_finish_request(struct req
 	struct deadline_data *dd = q->elevator->elevator_data;
 	const u8 ioprio_class = dd_rq_ioclass(rq);
 	const enum dd_prio prio = ioprio_class_to_prio[ioprio_class];
-	struct dd_per_prio *per_prio = &dd->per_prio[prio];
 
 	/*
 	 * The block layer core may call dd_finish_request() without having
@@ -829,9 +840,10 @@ static void dd_finish_request(struct req
 
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
 


