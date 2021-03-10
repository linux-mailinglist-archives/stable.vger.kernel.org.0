Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D20333DA9
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhCJNYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232775AbhCJNYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40DE764FD8;
        Wed, 10 Mar 2021 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382650;
        bh=KHkhqCTHzoARLpsg7NujAfuMlD/XneCIow5T3aalXrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrFluFGyVjzEREjtDjLOGwXWnGUQjxaz26XMYf9pNRx9UwAaIQnlB/CpTV/xzvhRe
         fIL3y+bNV0xkzkPn5Pj+fwQI4rNVuIWVV0Hxh1qhqD115SQJpkj/wOspQOVPD4/+7m
         YQa8Ev4JnKAVf0+QBXbL6m2ZIN/br6TlF+jhHy+E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.11 09/36] io_uring/io-wq: return 2-step work swap scheme
Date:   Wed, 10 Mar 2021 14:23:22 +0100
Message-Id: <20210310132320.812008964@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Begunkov <asml.silence@gmail.com>

commit 5280f7e530f71ba85baf90169393196976ad0e52 upstream

Saving one lock/unlock for io-wq is not super important, but adds some
ugliness in the code. More important, atomic decs not turning it to zero
for some archs won't give the right ordering/barriers so the
io_steal_work() may pretty easily get subtly and completely broken.

Return back 2-step io-wq work exchange and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c    |   16 ++++++----------
 fs/io-wq.h    |    4 ++--
 fs/io_uring.c |   26 ++++----------------------
 3 files changed, 12 insertions(+), 34 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -555,23 +555,21 @@ get_next:
 
 		/* handle a whole dependent link */
 		do {
-			struct io_wq_work *old_work, *next_hashed, *linked;
+			struct io_wq_work *next_hashed, *linked;
 			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
 			io_impersonate_work(worker, work);
+			wq->do_work(work);
+			io_assign_current_work(worker, NULL);
 
-			old_work = work;
-			linked = wq->do_work(work);
-
+			linked = wq->free_work(work);
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
 				linked = NULL;
 			}
 			io_assign_current_work(worker, work);
-			wq->free_work(old_work);
-
 			if (linked)
 				io_wqe_enqueue(wqe, linked);
 
@@ -850,11 +848,9 @@ static void io_run_cancel(struct io_wq_w
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		struct io_wq_work *old_work = work;
-
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work = wq->do_work(work);
-		wq->free_work(old_work);
+		wq->do_work(work);
+		work = wq->free_work(work);
 	} while (work);
 }
 
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -106,8 +106,8 @@ static inline struct io_wq_work *wq_next
 	return container_of(work->list.next, struct io_wq_work, list);
 }
 
-typedef void (free_work_fn)(struct io_wq_work *);
-typedef struct io_wq_work *(io_wq_work_fn)(struct io_wq_work *);
+typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+typedef void (io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
 	struct user_struct *user;
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2365,22 +2365,6 @@ static inline void io_put_req_deferred(s
 		io_free_req_deferred(req);
 }
 
-static struct io_wq_work *io_steal_work(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt;
-
-	/*
-	 * A ref is owned by io-wq in which context we're. So, if that's the
-	 * last one, it's safe to steal next work. False negatives are Ok,
-	 * it just will be re-punted async in io_put_work()
-	 */
-	if (refcount_read(&req->refs) != 1)
-		return NULL;
-
-	nxt = io_req_find_next(req);
-	return nxt ? &nxt->work : NULL;
-}
-
 static void io_double_put_req(struct io_kiocb *req)
 {
 	/* drop both submit and complete references */
@@ -6378,7 +6362,7 @@ static int io_issue_sqe(struct io_kiocb
 	return 0;
 }
 
-static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
+static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *timeout;
@@ -6429,8 +6413,6 @@ static struct io_wq_work *io_wq_submit_w
 		if (lock_ctx)
 			mutex_unlock(&lock_ctx->uring_lock);
 	}
-
-	return io_steal_work(req);
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
@@ -8062,12 +8044,12 @@ static int io_sqe_files_update(struct io
 	return __io_sqe_files_update(ctx, &up, nr_args);
 }
 
-static void io_free_work(struct io_wq_work *work)
+static struct io_wq_work *io_free_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
-	/* Consider that io_steal_work() relies on this ref */
-	io_put_req(req);
+	req = io_put_req_find_next(req);
+	return req ? &req->work : NULL;
 }
 
 static int io_init_wq_offload(struct io_ring_ctx *ctx,


