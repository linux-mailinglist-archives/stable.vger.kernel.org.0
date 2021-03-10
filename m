Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9433D333B8B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhCJLhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbhCJLf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:35:29 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073D3C0613D9
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:35:01 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l22so6892099wme.1
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e0qX8oRYdOPph/4W4xmNZG5c74khoGvEvzU/QA9qYKA=;
        b=gapA0ca+Y1SYDDu0q4iL1GSJyQEqoFiBYp+6/trl34fq+fFu8/9572B62oZzyxXoVg
         ulqgpwsI4wzVbcCf/OxoWDb1KCDr9UznA28t7aRMOb7I8VeERQ2ZYR4aXlGcPiwHTVOa
         YteYMMD7WSvixOHGOK6m17W7RVA8qVCB51argq7ePWEKIgEbUPzzdalrjhI+gIJdw55t
         23I1Ilg9oweAwA33jSkCjHGzs3ox7JiY9Wv6Iy4vHQsVvJCm+WJO7Ynns0udL1n4utN/
         0krx3nusSmntQ2KF+EZhxP+ojvMhWZBAV6ss4vOIr0gQzag5LO+FZS0d9HqmebsjGkxW
         6gYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e0qX8oRYdOPph/4W4xmNZG5c74khoGvEvzU/QA9qYKA=;
        b=GV51U82BnsWN7XpUoVCcNhxGKpZPjXIQn//1NJ5fQQC/iZgEJXBIT4AMJFQwmCdkwm
         ZjpUQsZ+nhQ2B4q/7q1Phdgp6O8KeWBR9SoxlnThH4TAG1nKuZ7wIdEN8ZryJuACmXI9
         x2LslwnWaITit/e1oYqxQe5uPKzaorwUrqBaVYCALdyukHkbO2K8ZdY8gIYpVNiKlsNh
         0M+tBXZ58aS6TKaumy4jPFNuBoC44EJ+u++tdOafbAGlXqJXckdscmeDWHkXr+VlAval
         lDxeSifqciBhU5ou0zByFV2dvwfLosEeq54zBLPtovJQLheXmSua27r3ZjfOseAFf11S
         eeOw==
X-Gm-Message-State: AOAM533tkRwBXeNAFAD8Ud4TGoMQVHVACFXVqNxIWAY5FOZ1VE+6jnN5
        +Zl7xFlKQevB7stTNgVRxraZV6/I9Bxf4A==
X-Google-Smtp-Source: ABdhPJzs2JetqZRH5lfH9FA7LkbfVfyHhsyLQ2ngSF2AUbKJyuXXPvoZlAqNbBnOTgP8sV0sNgOHcA==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr2885355wmq.60.1615376099417;
        Wed, 10 Mar 2021 03:34:59 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring/io-wq: return 2-step work swap scheme
Date:   Wed, 10 Mar 2021 11:30:44 +0000
Message-Id: <506ec0ce0b991836bb5132840fd1889126c86c8e.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5280f7e530f71ba85baf90169393196976ad0e52 upstream

Saving one lock/unlock for io-wq is not super important, but adds some
ugliness in the code. More important, atomic decs not turning it to zero
for some archs won't give the right ordering/barriers so the
io_steal_work() may pretty easily get subtly and completely broken.

Return back 2-step io-wq work exchange and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 16 ++++++----------
 fs/io-wq.h    |  4 ++--
 fs/io_uring.c | 26 ++++----------------------
 3 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2e2f14f42bf2..63ef195b1acb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -555,23 +555,21 @@ static void io_worker_handle_work(struct io_worker *worker)
 
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
 
@@ -850,11 +848,9 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
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
 
diff --git a/fs/io-wq.h b/fs/io-wq.h
index e1ffb80a4a1d..e37a0f217cc8 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -106,8 +106,8 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 	return container_of(work->list.next, struct io_wq_work, list);
 }
 
-typedef void (free_work_fn)(struct io_wq_work *);
-typedef struct io_wq_work *(io_wq_work_fn)(struct io_wq_work *);
+typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+typedef void (io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
 	struct user_struct *user;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ebc05f41c19..5e9bff1eeaa0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2365,22 +2365,6 @@ static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
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
@@ -6378,7 +6362,7 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
-static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
+static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *timeout;
@@ -6429,8 +6413,6 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 		if (lock_ctx)
 			mutex_unlock(&lock_ctx->uring_lock);
 	}
-
-	return io_steal_work(req);
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
@@ -8062,12 +8044,12 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
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
-- 
2.24.0

