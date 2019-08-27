Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0459E0F7
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfH0IH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732098AbfH0IHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:07:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB67206BA;
        Tue, 27 Aug 2019 08:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893240;
        bh=fF31NwNGz/LyJev1Z0ZoAVRLLR2MCbfYotjSbuxUV34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UK5IaVE8O4MgQWICGsDY6l1iTwUoAu9BxJfU8Wgbkf3qY9BC1uUPFehZQJzQd3d/C
         L1w9oQWMbMtUgcrKs05TnQeBjF/cgTwKo5TwtGD1qlr22iP7SWLSXfrlrcH/7833gN
         wIrd0AQPYfdEPtNvFU8l1ePNI7sezmIvFnyVLEaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jeffrey M. Birnbaum" <jmbnyc@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 157/162] io_uring: fix potential hang with polled IO
Date:   Tue, 27 Aug 2019 09:51:25 +0200
Message-Id: <20190827072744.281567437@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 500f9fbadef86466a435726192f4ca4df7d94236 ]

If a request issue ends up being punted to async context to avoid
blocking, we can get into a situation where the original application
enters the poll loop for that very request before it has been issued.
This should not be an issue, except that the polling will hold the
io_uring uring_ctx mutex for the duration of the poll. When the async
worker has actually issued the request, it needs to acquire this mutex
to add the request to the poll issued list. Since the application
polling is already holding this mutex, the workqueue sleeps on the
mutex forever, and the application thus never gets a chance to poll for
the very request it was interested in.

Fix this by ensuring that the polling drops the uring_ctx occasionally
if it's not making any progress.

Reported-by: Jeffrey M. Birnbaum <jmbnyc@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 61018559e8fe6..5bb01d84f38d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -743,11 +743,34 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 			   long min)
 {
-	int ret = 0;
+	int iters, ret = 0;
+
+	/*
+	 * We disallow the app entering submit/complete with polling, but we
+	 * still need to lock the ring to prevent racing with polled issue
+	 * that got punted to a workqueue.
+	 */
+	mutex_lock(&ctx->uring_lock);
 
+	iters = 0;
 	do {
 		int tmin = 0;
 
+		/*
+		 * If a submit got punted to a workqueue, we can have the
+		 * application entering polling for a command before it gets
+		 * issued. That app will hold the uring_lock for the duration
+		 * of the poll right here, so we need to take a breather every
+		 * now and then to ensure that the issue has a chance to add
+		 * the poll to the issued list. Otherwise we can spin here
+		 * forever, while the workqueue is stuck trying to acquire the
+		 * very same mutex.
+		 */
+		if (!(++iters & 7)) {
+			mutex_unlock(&ctx->uring_lock);
+			mutex_lock(&ctx->uring_lock);
+		}
+
 		if (*nr_events < min)
 			tmin = min - *nr_events;
 
@@ -757,6 +780,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 		ret = 0;
 	} while (min && !*nr_events && !need_resched());
 
+	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
 
@@ -2073,15 +2097,7 @@ static int io_sq_thread(void *data)
 			unsigned nr_events = 0;
 
 			if (ctx->flags & IORING_SETUP_IOPOLL) {
-				/*
-				 * We disallow the app entering submit/complete
-				 * with polling, but we still need to lock the
-				 * ring to prevent racing with polled issue
-				 * that got punted to a workqueue.
-				 */
-				mutex_lock(&ctx->uring_lock);
 				io_iopoll_check(ctx, &nr_events, 0);
-				mutex_unlock(&ctx->uring_lock);
 			} else {
 				/*
 				 * Normal IO, just pretend everything completed.
@@ -2978,9 +2994,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		min_complete = min(min_complete, ctx->cq_entries);
 
 		if (ctx->flags & IORING_SETUP_IOPOLL) {
-			mutex_lock(&ctx->uring_lock);
 			ret = io_iopoll_check(ctx, &nr_events, min_complete);
-			mutex_unlock(&ctx->uring_lock);
 		} else {
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
-- 
2.20.1



