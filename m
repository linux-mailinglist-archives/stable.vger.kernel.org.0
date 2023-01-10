Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18EF663A9F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbjAJILY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237956AbjAJIKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:10:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81FD48825
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54D77B810FE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D733C433F0;
        Tue, 10 Jan 2023 08:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338184;
        bh=ah29m7k7pTrCDGJTbD7DmNFPTTH4Li67tUW0B8G91V4=;
        h=Subject:To:Cc:From:Date:From;
        b=KaIyZeniqihzyIl0WU9gMcZrvNXA4mpdrY2X1luTXMFcENHjUzesI3/Ns00+U6f/n
         7bUQZSJuAG5BfntqvItxehZA60XNMfFAaJI+I5+PUYWgUzK+Y1GrDgO3RIQzxa5GIp
         ybvxYbvT4NocPZp+43r+fAQtfKu33AleAFitvuSg=
Subject: FAILED: patch "[PATCH] io_uring: fix CQ waiting timeout handling" failed to apply to 6.1-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 09:09:40 +0100
Message-ID: <1673338180150159@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

12521a5d5cb7 ("io_uring: fix CQ waiting timeout handling")
35d90f95cfa7 ("io_uring: include task_work run after scheduling in wait for events")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12521a5d5cb7ff0ad43eadfc9c135d86e1131fa8 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 5 Jan 2023 10:49:15 +0000
Subject: [PATCH] io_uring: fix CQ waiting timeout handling

Jiffy to ktime CQ waiting conversion broke how we treat timeouts, in
particular we rearm it anew every time we get into
io_cqring_wait_schedule() without adjusting the timeout. Waiting for 2
CQEs and getting a task_work in the middle may double the timeout value,
or even worse in some cases task may wait indefinitely.

Cc: stable@vger.kernel.org
Fixes: 228339662b398 ("io_uring: don't convert to jiffies for waiting on timeouts")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f7bffddd71b08f28a877d44d37ac953ddb01590d.1672915663.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 472574192dd6..2ac1cd8d23ea 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2470,7 +2470,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 	unsigned long check_cq;
@@ -2488,7 +2488,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
 			return -EBADR;
 	}
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 
 	/*
@@ -2564,7 +2564,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		if (__io_cqring_events_user(ctx) >= min_events)
 			break;
 		cond_resched();

