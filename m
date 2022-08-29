Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E35A4E2F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiH2Ne2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiH2Ne0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:26 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A017187084
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:24 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bv25so3189830wrb.10
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ymz7n+vYDtWHb8/LZD8ou/wbUHIP597LB2j+L6it/3Q=;
        b=DiuFU/SsFlcVnWzswYLYKf/X4hcAHr8cs6CRY0msBGWE/HiY2VkjuXXKmhGrNt3ppo
         Oy9CAhlIhGqjZ8IS8L/99mHllSSfm9y8cs0NRWmk+qSBlhRc6u5UVEum+E/KHj9KuCWk
         QmlYPzmcLy2MAO1Tup5bSv4WKJtwuIlQzqzMno2eEKFTJqdmbvX4Pt58+3y9IZIx9yxx
         38cYsUkdxCfgMwsBNdwJMefNwBaI59Y3VaZyqE4knf06QJJ0nK7PIe3kWJAhnWL8/3el
         4qggavSc4QyXZrrM/zK18kOKCIk2svUcew+hsVgaUR/7dstsLGdOwfqGyGrcZOXBUlEe
         lUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ymz7n+vYDtWHb8/LZD8ou/wbUHIP597LB2j+L6it/3Q=;
        b=oKRF3pGJOhcdpVJRR3B/N3m+oz1UJexwsAkxZoY7yIN97Q0S1SUs3DqjvL7t3pj39C
         WHm/c9I6kgZdxK5q1hwoqWFRKQ5b0j68vz+AtZM3/LnVtNjTG66/ZSUbpSyWnGUHxE+U
         PXT+DP6VMdgHHqauCznpyuJcB9MPQo6ESPoTT3LFG+M/5NfgXXlbSnlOG0vJLn8AVM+6
         38kFRYEOJAgatBvbL4syqS0DxGzv2CwH3OIWTRPwDELofTrhqYMPnwH9TO3xK2rg7fcP
         LbaomfxSB3H9sSN+4yUrHDSkAiETkr7jvbXHzmNyBTkKHtr6MrDdM8RJvWUSjYJQjwiM
         5fWw==
X-Gm-Message-State: ACgBeo3rHaiPgEB7XSJEXnYCXgTNFLNSW5vxCXEueUQDiKeIlqnOSNHA
        rEFByYduvldyQ1gj+I9eLMrAxDJ9DAU=
X-Google-Smtp-Source: AA6agR6JL1y+xYXNwmkXw6wt4nReouwc3cuLJBQFJds3cOZYNZnKNLUBM5plZ2cO8NKWy7GOesiEGw==
X-Received: by 2002:a5d:68c9:0:b0:225:330b:2d0 with SMTP id p9-20020a5d68c9000000b00225330b02d0mr6013158wrw.243.1661780062835;
        Mon, 29 Aug 2022 06:34:22 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 02/13] io_uring: clean cqe filling functions
Date:   Mon, 29 Aug 2022 14:30:13 +0100
Message-Id: <ca69eee269c72bb415d2863408355504a10ab8c8.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 57 ++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b5718278ae61..7812a8e81f3e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1079,8 +1079,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 s32 res, u32 cflags);
+static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
+
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1515,7 +1515,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
+		io_fill_cqe_req(req, status, 0);
 		io_put_req_deferred(req);
 	}
 }
@@ -1790,8 +1790,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  s32 res, u32 cflags)
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1812,11 +1812,16 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
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
@@ -1825,7 +1830,7 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
+	__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2051,8 +2056,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
 		}
@@ -2076,7 +2080,7 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
+		io_fill_cqe_req(link, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2093,8 +2097,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
 		}
@@ -2370,8 +2373,8 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2482,8 +2485,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					io_put_rw_kbuf(req));
+		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -5407,13 +5409,13 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
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
 
@@ -5740,9 +5742,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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
@@ -6039,7 +6041,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail(req);
-	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
+	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
 	return 0;
 }
@@ -8265,8 +8267,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock(&ctx->completion_lock);
-			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
-			ctx->cq_extra++;
+			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
-- 
2.37.2

