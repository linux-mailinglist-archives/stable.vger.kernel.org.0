Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E2F3147B2
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhBIExO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhBIExK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E42C061793
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s11so21911797edd.5
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlyPUBvUbF5QnEV1U8KR/goAzRJMhixprLiEdyWE1ME=;
        b=NW5oKcDPAn47pWFU92/BPmra2SmPpTPHB/ZeOnCNoA4+iRqmrOZqFvmYqO39Qc0QcZ
         9z295a7Ukq0LwVUmuFKD0ghEanqJetX4W0uX68byFXlLGbOc+uuHQwnqMtaeqopNvcmO
         44tyQZo46U1Jac2tJTmE7m9+NKdQWMya4bauQlIy1YnERqgoDm74uiJJAQi1wEH6B3yx
         qnTYbPygBxaoqZGsvg1sylEfDSE2UMREdtHHKulJYm59qw6mVcwOUM7LUDKPwuik0Jem
         QHAjNBhX+xy2T8oCslFSajp6LaNue5JARix7kxBsQvec1ESPuFe9+rtyYzZzo7iHo3Tz
         nwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlyPUBvUbF5QnEV1U8KR/goAzRJMhixprLiEdyWE1ME=;
        b=t8tBAEfzIV82UYG9BUwP+DSGHaM06O5rbBjw7z6mNAWr8N9I0BfFW+Lpr+W6QSJHin
         tBraQikpttgjlIcfzKHCmwgjiyckkPer114WrEAylkse2Pc/FCMd3Ym5Rxj/7OUHoy8g
         2HwUNhsR5D7qDz8she+/5DNbWKAbhF/XV+3aTM/pJ42/0EaG1d1PlhSXKEy52Ka1RrTz
         KfgM0QYR/O41VWhYR8lhmaE464S99sMbA3K5a7QcxfoqDo1MnJzKL5JQxLvSfA/QYMPC
         L0qE/hlzyaBrDR+fi+xWiL0P8VuwgS9qATJE49uar7ifR6kwPTUYd0pTWENLNL4nF/hh
         KeSA==
X-Gm-Message-State: AOAM533RFZTIBYGkX5fdi2CwkgAvLxgHUAyITes+q50JJaG8wJiQ0QgH
        0ilMO3FJ9+QaO1jTPpIB7awRq7lOhTg=
X-Google-Smtp-Source: ABdhPJzQrjHyXx8zh5iyxMfarhuLwOkS9ArgWwsmtACHYt8hGgDtko4Y/RJkUuRkKwRXl/1ViRZ0UQ==
X-Received: by 2002:a50:cbc7:: with SMTP id l7mr14651168edi.134.1612846309129;
        Mon, 08 Feb 2021 20:51:49 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/16] io_uring: always batch cancel in *cancel_files()
Date:   Tue,  9 Feb 2021 04:47:39 +0000
Message-Id: <9f10a4fb3f492aedfaccfbe631ef884fa4874e1a.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f6edbabb8359798c541b0776616c5eab3a840d3d ]

Instead of iterating over each request and cancelling it individually in
io_uring_cancel_files(), try to cancel all matching requests and use
->inflight_list only to check if there anything left.

In many cases it should be faster, and we can reuse a lot of code from
task cancellation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    |  10 ----
 fs/io-wq.h    |   1 -
 fs/io_uring.c | 139 ++++++++------------------------------------------
 3 files changed, 20 insertions(+), 130 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b53c055bea6a..f72d53848dcb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1078,16 +1078,6 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
-static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
-{
-	return work == data;
-}
-
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
-{
-	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
-}
-
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index aaa363f35891..75113bcd5889 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -130,7 +130,6 @@ static inline bool io_wq_is_hashed(struct io_wq_work *work)
 }
 
 void io_wq_cancel_all(struct io_wq *wq);
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0a9f938ac3a1..44b859456ef6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1496,15 +1496,6 @@ static void io_kill_timeout(struct io_kiocb *req)
 	}
 }
 
-static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!tsk || req->task == tsk)
-		return true;
-	return (ctx->flags & IORING_SETUP_SQPOLL);
-}
-
 /*
  * Returns true if we found and killed one or more timeouts
  */
@@ -8524,112 +8515,31 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-/*
- * Returns true if 'preq' is the link parent of 'req'
- */
-static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
-{
-	struct io_kiocb *link;
-
-	if (!(preq->flags & REQ_F_LINK_HEAD))
-		return false;
-
-	list_for_each_entry(link, &preq->link_list, link_list) {
-		if (link == req)
-			return true;
-	}
-
-	return false;
-}
-
-/*
- * We're looking to cancel 'req' because it's holding on to our files, but
- * 'req' could be a link to another request. See if it is, and cancel that
- * parent request if so.
- */
-static bool io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
-{
-	struct hlist_node *tmp;
-	struct io_kiocb *preq;
-	bool found = false;
-	int i;
-
-	spin_lock_irq(&ctx->completion_lock);
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list;
-
-		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
-			found = io_match_link(preq, req);
-			if (found) {
-				io_poll_remove_one(preq);
-				break;
-			}
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return found;
-}
-
-static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	struct io_kiocb *preq;
-	bool found = false;
-
-	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry(preq, &ctx->timeout_list, timeout.list) {
-		found = io_match_link(preq, req);
-		if (found) {
-			__io_timeout_cancel(preq);
-			break;
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return found;
-}
+struct io_task_cancel {
+	struct task_struct *task;
+	struct files_struct *files;
+};
 
-static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
+static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_task_cancel *cancel = data;
 	bool ret;
 
-	if (req->flags & REQ_F_LINK_TIMEOUT) {
+	if (cancel->files && (req->flags & REQ_F_LINK_TIMEOUT)) {
 		unsigned long flags;
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
 		spin_lock_irqsave(&ctx->completion_lock, flags);
-		ret = io_match_link(req, data);
+		ret = io_match_task(req, cancel->task, cancel->files);
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	} else {
-		ret = io_match_link(req, data);
+		ret = io_match_task(req, cancel->task, cancel->files);
 	}
 	return ret;
 }
 
-static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
-{
-	enum io_wq_cancel cret;
-
-	/* cancel this particular work, if it's running */
-	cret = io_wq_cancel_work(ctx->io_wq, &req->work);
-	if (cret != IO_WQ_CANCEL_NOTFOUND)
-		return;
-
-	/* find links that hold this pending, cancel those */
-	cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_link_cb, req, true);
-	if (cret != IO_WQ_CANCEL_NOTFOUND)
-		return;
-
-	/* if we have a poll link holding this pending, cancel that */
-	if (io_poll_remove_link(ctx, req))
-		return;
-
-	/* final option, timeout link is holding this req pending */
-	io_timeout_remove_link(ctx, req);
-}
-
 static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
@@ -8661,8 +8571,10 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_kiocb *cancel_req = NULL, *req;
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
+		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
@@ -8670,25 +8582,21 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			    (req->work.flags & IO_WQ_WORK_FILES) &&
 			    req->work.identity->files != files)
 				continue;
-			/* req is being completed, ignore */
-			if (!refcount_inc_not_zero(&req->refs))
-				continue;
-			cancel_req = req;
+			found = true;
 			break;
 		}
-		if (cancel_req)
+		if (found)
 			prepare_to_wait(&ctx->inflight_wait, &wait,
 						TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&ctx->inflight_lock);
 
 		/* We need to keep going until we don't find a matching req */
-		if (!cancel_req)
+		if (!found)
 			break;
-		/* cancel this request, or head link requests */
-		io_attempt_cancel(ctx, cancel_req);
-		io_cqring_overflow_flush(ctx, true, task, files);
 
-		io_put_req(cancel_req);
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
+		io_poll_remove_all(ctx, task, files);
+		io_kill_timeouts(ctx, task, files);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
@@ -8696,22 +8604,15 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct task_struct *task = data;
-
-	return io_task_match(req, task);
-}
-
 static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 					    struct task_struct *task)
 {
 	while (1) {
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
+		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
 		if (cret != IO_WQ_CANCEL_NOTFOUND)
 			ret = true;
 
-- 
2.24.0

