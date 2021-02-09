Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBF83147B5
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBIExW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhBIExL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:11 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EABEC0617AA
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:56 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c6so21941960ede.0
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rt370esnuADUefsiWYnI1R1WhmUpjsYoeHqIaxpeDNs=;
        b=cigbUItwr6gx/k5+EGmxS1giHH4J14o9rcezrd2qcv99sOqnuX+rpQ20j8narEq1Bt
         pTs+62q9NeqaEG0oq6a8Wb/JhJzY8252g0Kpb8VL1ZaiDj5XMcr3wC7gG5RKI3M6jzTB
         Ci970JpW7x45DNiHKBsPSrbPtyblpMB1b3ISjLB+rLsx+PtE3tI651bz778LanauNeiS
         VJt2cRRXO59lo0eShLwYaB53dE5hIIbgj8wOCks4M6q/LT0ULjEfNrjXmUn3fJa+gh9Q
         uDyvsvERXsmSAggq0W2vhehvi6PlgUanC8FqFSy7+Lr5A3XpkGE8OATZqUkMRBUmaa2B
         FYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rt370esnuADUefsiWYnI1R1WhmUpjsYoeHqIaxpeDNs=;
        b=qQc0B5TTyIcB2LAvxZF28AjyUvsg1/Ej71c+V5XsZSe10FLmcR8DRqBmnQaFR/Djvw
         7cv89YZuE3uNWI6/AdqDvDTHgwfoAMjs8sNnVkkApu4YRjzxpcpy9DPaj2h7oSOYA0lY
         Oym3CwJXRMdomVDY/TQArpB9ZC5aW6kYyrsdB7dw2D9JjVsbj1mqeYtU0PBlyFQDqGY7
         SPMlo7sYjbUNUt69D8ICWNFCOeR+ZTrBVWkLA+d0oQhl1snmjyJuvp2a+YmaOUH7JAbb
         AbwdyRA+6rLincV14FB66xfW+kGS71mECOriXA6orTXv0jtJDae5uIa8mvJgTFQCTN6O
         tUJA==
X-Gm-Message-State: AOAM533A+Kcn9z5trHJk/COn1+AoJIWdHCQV0NEmbKMbh0DORlBSkhuK
        3J0Q0gTDMDdkX9T38yEwI//eE0x1uBE=
X-Google-Smtp-Source: ABdhPJz7z7jV7xr5JjqNxQDtmshgPEIWcJpwj07BB/ViW0AoP+LAj7x53jr5BDGSYBVfzrW09C7eEg==
X-Received: by 2002:a05:6402:3069:: with SMTP id bs9mr19368299edb.151.1612846314919;
        Mon, 08 Feb 2021 20:51:54 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/16] io_uring: replace inflight_wait with tctx->wait
Date:   Tue,  9 Feb 2021 04:47:44 +0000
Message-Id: <fee63dd8715ae9891757899a9cdff67e04817871.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c98de08c990e190fc7cc3aaf8079b4a0674c6425 ]

As tasks now cancel only theirs requests, and inflight_wait is awaited
only in io_uring_cancel_files(), which should be called with ->in_idle
set, instead of keeping a separate inflight_wait use tctx->wait.

That will add some spurious wakeups but actually is safer from point of
not hanging the task.

e.g.
task1                   | IRQ
                        | *start* io_complete_rw_common(link)
                        |        link: req1 -> req2 -> req3(with files)
*cancel_files()         |
io_wq_cancel(), etc.    |
                        | put_req(link), adds to io-wq req2
schedule()              |

So, task1 will never try to cancel req2 or req3. If req2 is
long-standing (e.g. read(empty_pipe)), this may hang.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 170f980c3243..e3ae0daf97f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -286,7 +286,6 @@ struct io_ring_ctx {
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
 
-		wait_queue_head_t	inflight_wait;
 		struct io_uring_sqe	*sq_sqes;
 	} ____cacheline_aligned_in_smp;
 
@@ -1220,7 +1219,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
-	init_waitqueue_head(&ctx->inflight_wait);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
 	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
@@ -5894,6 +5892,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static void io_req_drop_files(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_task *tctx = req->task->io_uring;
 	unsigned long flags;
 
 	if (req->work.flags & IO_WQ_WORK_FILES) {
@@ -5905,8 +5904,8 @@ static void io_req_drop_files(struct io_kiocb *req)
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	req->work.flags &= ~IO_WQ_WORK_FILES;
-	if (waitqueue_active(&ctx->inflight_wait))
-		wake_up(&ctx->inflight_wait);
+	if (atomic_read(&tctx->in_idle))
+		wake_up(&tctx->wait);
 }
 
 static void __io_clean_op(struct io_kiocb *req)
@@ -8605,8 +8604,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			break;
 		}
 		if (found)
-			prepare_to_wait(&ctx->inflight_wait, &wait,
-						TASK_UNINTERRUPTIBLE);
+			prepare_to_wait(&task->io_uring->wait, &wait,
+					TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&ctx->inflight_lock);
 
 		/* We need to keep going until we don't find a matching req */
@@ -8619,7 +8618,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
-		finish_wait(&ctx->inflight_wait, &wait);
+		finish_wait(&task->io_uring->wait, &wait);
 	}
 }
 
-- 
2.24.0

