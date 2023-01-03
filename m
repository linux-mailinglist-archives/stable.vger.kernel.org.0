Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24B265BC09
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbjACISj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbjACISU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DE0DF9F
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 21FACCE0CEF
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DDEC433EF;
        Tue,  3 Jan 2023 08:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733871;
        bh=ihi5dK572bB8B+u5OYM4yU4Oi1ttT6unGgWTVLAI3qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qA27O+OqIJeBU7YxHvMfymAznq7lRNA5amT30vikOd0pISjSzljevIk+0LeHoZY2R
         hAC6QWt3uIHECwJw8LXGfIH2X1UXPcb4MqDrhIvgAnicjvHNFTb4qgeFQ1PKeLpjuJ
         c7YOKnlgm5dN+rPNAXUavqdlYpian5afa6X2P5v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 63/63] io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups
Date:   Tue,  3 Jan 2023 09:14:33 +0100
Message-Id: <20230103081312.413447786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4464853277d0ccdb9914608dd1332f0fa2f9846f ]

Pass in EPOLL_URING_WAKE when signaling eventfd or doing poll related
wakups, so that we can check for a circular event dependency between
eventfd and epoll. If this flag is set when our wakeup handlers are
called, then we know we have a dependency that needs to terminate
multishot requests.

eventfd and epoll are the only such possible dependencies.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1626,13 +1626,15 @@ static void io_cqring_ev_posted(struct i
 	 * wake as many waiters as we need to.
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
+		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+		eventfd_signal_mask(ctx->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
+		__wake_up(&ctx->poll_wait, TASK_INTERRUPTIBLE, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1642,12 +1644,14 @@ static void io_cqring_ev_posted_iopoll(s
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (waitqueue_active(&ctx->cq_wait))
-			wake_up_all(&ctx->cq_wait);
+			__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				  poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 	}
 	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+		eventfd_signal_mask(ctx->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
+		__wake_up(&ctx->poll_wait, TASK_INTERRUPTIBLE, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -5477,8 +5481,17 @@ static int io_poll_wake(struct wait_queu
 	if (mask && !(mask & poll->events))
 		return 0;
 
-	if (io_poll_get_ownership(req))
+	if (io_poll_get_ownership(req)) {
+		/*
+		 * If we trigger a multishot poll off our own wakeup path,
+		 * disable multishot as there is a circular dependency between
+		 * CQ posting and triggering the event.
+		 */
+		if (mask & EPOLL_URING_WAKE)
+			poll->events |= EPOLLONESHOT;
+
 		__io_poll_execute(req, mask);
+	}
 	return 1;
 }
 


