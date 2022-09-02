Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E705AAFE8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbiIBMpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbiIBMoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E186F0749;
        Fri,  2 Sep 2022 05:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89AC6620DF;
        Fri,  2 Sep 2022 12:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F88C4314D;
        Fri,  2 Sep 2022 12:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121864;
        bh=8ODdqTd+v0WsZUklPqyfqcZn5VuE1zGzqEnCocUfZoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wB8V+YJDNzoDHwQAQ2EoHDI3JwRNOSkcvYdcIu89WgnaJhzaX7oO8UGxsCX+ydHbN
         IXWICC6t7iD35gv+0NBmtH6RSla7MKpNR6r4EwtMIRSoAhXSAo4wfP7/T1cO2KqzDM
         eCBXjDTE/nGPJCjwY+x7Ud4xKh0qPvCSmqqzhTkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 12/73] io_uring: clean cqe filling functions
Date:   Fri,  2 Sep 2022 14:18:36 +0200
Message-Id: <20220902121404.838425619@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commmit 913a571affedd17239c4d4ea90c8874b32fc2191 ]

Split io_cqring_fill_event() into a couple of more targeted functions.
The first on is io_fill_cqe_aux() for completions that are not
associated with request completions and doing the ->cq_extra accounting.
Examples are additional CQEs from multishot poll and rsrc notifications.

The second is io_fill_cqe_req(), should be called when it's a normal
request completion. Nothing more to it at the moment, will be used in
later patches.

The last one is inlined __io_fill_cqe() for a finer grained control,
should be used with caution and in hottest places.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/59a9117a4a44fc9efcf04b3afa51e0d080f5943c.1636559119.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   57 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1079,8 +1079,8 @@ static void io_uring_try_cancel_requests
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 s32 res, u32 cflags);
+static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
+
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1515,7 +1515,7 @@ static void io_kill_timeout(struct io_ki
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
+		io_fill_cqe_req(req, status, 0);
 		io_put_req_deferred(req);
 	}
 }
@@ -1790,8 +1790,8 @@ static bool io_cqring_event_overflow(str
 	return true;
 }
 
-static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  s32 res, u32 cflags)
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1812,11 +1812,16 @@ static inline bool __io_cqring_fill_even
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
-/* not as hot to bloat with inlining */
-static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  s32 res, u32 cflags)
+static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
+{
+	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+}
+
+static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
+				     s32 res, u32 cflags)
 {
-	return __io_cqring_fill_event(ctx, user_data, res, cflags);
+	ctx->cq_extra++;
+	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
 static void io_req_complete_post(struct io_kiocb *req, s32 res,
@@ -1825,7 +1830,7 @@ static void io_req_complete_post(struct
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
+	__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2051,8 +2056,7 @@ static bool io_kill_linked_timeout(struc
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
 		}
@@ -2076,7 +2080,7 @@ static void io_fail_links(struct io_kioc
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
+		io_fill_cqe_req(link, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2093,8 +2097,7 @@ static bool io_disarm_next(struct io_kio
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
 		}
@@ -2370,8 +2373,8 @@ static void io_submit_flush_completions(
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2482,8 +2485,7 @@ static void io_iopoll_complete(struct io
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					io_put_rw_kbuf(req));
+		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -5413,13 +5415,13 @@ static bool __io_poll_complete(struct io
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
+
+	if (!(flags & IORING_CQE_F_MORE)) {
+		io_fill_cqe_req(req, error, flags);
+	} else if (!io_fill_cqe_aux(ctx, req->user_data, error, flags)) {
 		req->poll.events |= EPOLLONESHOT;
 		flags = 0;
 	}
-	if (flags & IORING_CQE_F_MORE)
-		ctx->cq_extra++;
-
 	return !(flags & IORING_CQE_F_MORE);
 }
 
@@ -5746,9 +5748,9 @@ static bool io_poll_remove_one(struct io
 	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
 	if (do_complete) {
-		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
-		io_commit_cqring(req->ctx);
 		req_set_fail(req);
+		io_fill_cqe_req(req, -ECANCELED, 0);
+		io_commit_cqring(req->ctx);
 		io_put_req_deferred(req);
 	}
 	return do_complete;
@@ -6045,7 +6047,7 @@ static int io_timeout_cancel(struct io_r
 		return PTR_ERR(req);
 
 	req_set_fail(req);
-	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
+	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
 	return 0;
 }
@@ -8271,8 +8273,7 @@ static void __io_rsrc_put_work(struct io
 
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock(&ctx->completion_lock);
-			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
-			ctx->cq_extra++;
+			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);


