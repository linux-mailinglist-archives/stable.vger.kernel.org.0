Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0833A036B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhFHTQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238314AbhFHTOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 317E161469;
        Tue,  8 Jun 2021 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178220;
        bh=XmGDcvBU6QyjbbQa+jlsHBVvtTddRpvqWJAwcfF5gGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4RcjhDWI4MwHQ7b2Jdv595YFZAtLHIVXk/h9AJTuLjbk9eX+dLvnPBZDkJ0knvfU
         mxohmBhPBIe27HRR/VIF+6n39mvBSyNJQMD5yzOwzLw10vgiENwA2SXLSxoUl+NZmt
         aWq0fb87p32pveOESdfRyyqupLqWArsF8iwMqrrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 087/161] io_uring: wrap io_kiocb reference count manipulation in helpers
Date:   Tue,  8 Jun 2021 20:26:57 +0200
Message-Id: <20210608175948.382041699@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit de9b4ccad750f216616730b74ed2be16c80892a4 ]

No functional changes in this patch, just in preparation for handling the
references a bit more efficiently.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 55 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5cc76fa9d4a1..dd8b3fac877c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1476,6 +1476,31 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return ret;
 }
 
+static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
+{
+	return refcount_inc_not_zero(&req->refs);
+}
+
+static inline bool req_ref_sub_and_test(struct io_kiocb *req, int refs)
+{
+	return refcount_sub_and_test(refs, &req->refs);
+}
+
+static inline bool req_ref_put_and_test(struct io_kiocb *req)
+{
+	return refcount_dec_and_test(&req->refs);
+}
+
+static inline void req_ref_put(struct io_kiocb *req)
+{
+	refcount_dec(&req->refs);
+}
+
+static inline void req_ref_get(struct io_kiocb *req)
+{
+	refcount_inc(&req->refs);
+}
+
 static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 				   unsigned int cflags)
 {
@@ -1512,7 +1537,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 		io_clean_op(req);
 		req->result = res;
 		req->compl.cflags = cflags;
-		refcount_inc(&req->refs);
+		req_ref_get(req);
 		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
 	}
 }
@@ -1534,7 +1559,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
 	 */
-	if (refcount_dec_and_test(&req->refs)) {
+	if (req_ref_put_and_test(req)) {
 		struct io_comp_state *cs = &ctx->submit_state.comp;
 
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
@@ -2113,7 +2138,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 		req = cs->reqs[i];
 
 		/* submission and completion refs */
-		if (refcount_sub_and_test(2, &req->refs))
+		if (req_ref_sub_and_test(req, 2))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -2129,7 +2154,7 @@ static struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = NULL;
 
-	if (refcount_dec_and_test(&req->refs)) {
+	if (req_ref_put_and_test(req)) {
 		nxt = io_req_find_next(req);
 		__io_free_req(req);
 	}
@@ -2138,7 +2163,7 @@ static struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 
 static void io_put_req(struct io_kiocb *req)
 {
-	if (refcount_dec_and_test(&req->refs))
+	if (req_ref_put_and_test(req))
 		io_free_req(req);
 }
 
@@ -2161,14 +2186,14 @@ static void io_free_req_deferred(struct io_kiocb *req)
 
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
 {
-	if (refcount_sub_and_test(refs, &req->refs))
+	if (req_ref_sub_and_test(req, refs))
 		io_free_req_deferred(req);
 }
 
 static void io_double_put_req(struct io_kiocb *req)
 {
 	/* drop both submit and complete references */
-	if (refcount_sub_and_test(2, &req->refs))
+	if (req_ref_sub_and_test(req, 2))
 		io_free_req(req);
 }
 
@@ -2254,7 +2279,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		__io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
 
-		if (refcount_dec_and_test(&req->refs))
+		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -2496,7 +2521,7 @@ static bool io_rw_reissue(struct io_kiocb *req)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	if (io_resubmit_prep(req)) {
-		refcount_inc(&req->refs);
+		req_ref_get(req);
 		io_queue_async_work(req);
 		return true;
 	}
@@ -3209,7 +3234,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	list_del_init(&wait->entry);
 
 	/* submit ref gets dropped, acquire a new one */
-	refcount_inc(&req->refs);
+	req_ref_get(req);
 	io_req_task_queue(req);
 	return 1;
 }
@@ -4954,7 +4979,7 @@ static void io_poll_remove_double(struct io_kiocb *req)
 		spin_lock(&head->lock);
 		list_del_init(&poll->wait.entry);
 		if (poll->wait.private)
-			refcount_dec(&req->refs);
+			req_ref_put(req);
 		poll->head = NULL;
 		spin_unlock(&head->lock);
 	}
@@ -5020,7 +5045,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			poll->wait.func(&poll->wait, mode, sync, key);
 		}
 	}
-	refcount_dec(&req->refs);
+	req_ref_put(req);
 	return 1;
 }
 
@@ -5063,7 +5088,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			return;
 		}
 		io_init_poll_iocb(poll, poll_one->events, io_poll_double_wake);
-		refcount_inc(&req->refs);
+		req_ref_get(req);
 		poll->wait.private = req;
 		*poll_ptr = poll;
 	}
@@ -6212,7 +6237,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	/* avoid locking problems by failing it from a clean context */
 	if (ret) {
 		/* io-wq is going to take one down */
-		refcount_inc(&req->refs);
+		req_ref_get(req);
 		io_req_task_queue_fail(req, ret);
 	}
 }
@@ -6264,7 +6289,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * We don't expect the list to be empty, that will only happen if we
 	 * race with the completion of the linked work.
 	 */
-	if (prev && refcount_inc_not_zero(&prev->refs))
+	if (prev && req_ref_inc_not_zero(prev))
 		io_remove_next_linked(prev);
 	else
 		prev = NULL;
-- 
2.30.2



