Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C666576D6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 14:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiL1NMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 08:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiL1NLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 08:11:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8989911838
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 05:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBCF8CE12E3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D238C433EF;
        Wed, 28 Dec 2022 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672233103;
        bh=8vuFPe8exqfGSL5Zn+2FOHbriws4cgM7qprtftQykXg=;
        h=Subject:To:Cc:From:Date:From;
        b=xa8aiA2FFX2efU1IZZ2ChYdaCiHSseL2KVF0QmH5EpeQug7J2pGNUgfzhbI3UDwvw
         P/LP77XxMLKH/YX9qwX9fJY3UaB35Kmcf0fnoQXVmYFTRFYT9Z8JMaSoxp+bCSGPaI
         uOZzkWJL/lzRMXdKT8yHhPcB9I0fIiqMzMBHqstE=
Subject: FAILED: patch "[PATCH] io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and" failed to apply to 6.0-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 14:11:40 +0100
Message-ID: <16722331001489@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4464853277d0 ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")
fc86f9d3bb49 ("io_uring: remove redundant memory barrier in io_req_local_work_add")
21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
d8e9214f119d ("io_uring: move io_eventfd_put")
c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
b4c98d59a787 ("io_uring: introduce io_has_work")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4464853277d0ccdb9914608dd1332f0fa2f9846f Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 20 Nov 2022 10:18:45 -0700
Subject: [PATCH] io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and
 wakeups

Pass in EPOLL_URING_WAKE when signaling eventfd or doing poll related
wakups, so that we can check for a circular event dependency between
eventfd and epoll. If this flag is set when our wakeup handlers are
called, then we know we have a dependency that needs to terminate
multishot requests.

eventfd and epoll are the only such possible dependencies.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1299f9c8567a..762ecab801f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -495,7 +495,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 	int ops = atomic_xchg(&ev_fd->ops, 0);
 
 	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal(ev_fd->cq_ev_fd, 1);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
 
 	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
 	 * ordering in a race but if references are 0 we know we have to free
@@ -531,7 +531,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal(ev_fd->cq_ev_fd, 1);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 69fbd27c7577..83013ee584d6 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/lockdep.h>
 #include <linux/io_uring_types.h>
+#include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
@@ -211,12 +212,18 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
 	/*
-	 * wake_up_all() may seem excessive, but io_wake_function() and
-	 * io_should_wake() handle the termination of the loop and only
-	 * wake as many waiters as we need to.
+	 * Trigger waitqueue handler on all waiters on our waitqueue. This
+	 * won't necessarily wake up all the tasks, io_should_wake() will make
+	 * that decision.
+	 *
+	 * Pass in EPOLLIN|EPOLL_URING_WAKE as the poll wakeup key. The latter
+	 * set in the mask so that if we recurse back into our own poll
+	 * waitqueue handlers, we know we have a dependency between eventfd or
+	 * epoll and should terminate multishot poll at that point.
 	 */
 	if (waitqueue_active(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
+		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
 static inline void io_cqring_wake(struct io_ring_ctx *ctx)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8fb8e781c02d..22c9b2e0944a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -389,6 +389,14 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		return 0;
 
 	if (io_poll_get_ownership(req)) {
+		/*
+		 * If we trigger a multishot poll off our own wakeup path,
+		 * disable multishot as there is a circular dependency between
+		 * CQ posting and triggering the event.
+		 */
+		if (mask & EPOLL_URING_WAKE)
+			poll->events |= EPOLLONESHOT;
+
 		/* optional, saves extra locking for removal in tw handler */
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);

