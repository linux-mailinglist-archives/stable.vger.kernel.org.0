Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB276577A2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiL1OUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiL1OUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:20:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60AC11156
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F283B816E1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D84DC433D2;
        Wed, 28 Dec 2022 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672237204;
        bh=ebO4Jf3D+phFerszCGq9AD0Xv7BpKgheNXbvFZ3G9X8=;
        h=Subject:To:Cc:From:Date:From;
        b=WBWE9ebyWnLclzr6tZc8uvRO3s8lDYk9K72MevNLjxJYsu9dY3zkqvf9xlOLt3K0x
         PEqRxIb/H/lF56gLxNjL+4lYI26bln/8lQ+XKpdojtJD/1Eho7W3ZOEoE35pr/wis2
         /8vOKd6EzBUxvmHTgxQ8hYqfwUas3Upp2StE84co=
Subject: FAILED: patch "[PATCH] io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and" failed to apply to 6.1-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 15:20:01 +0100
Message-ID: <167223720143199@kroah.com>
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

4464853277d0 ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")

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

