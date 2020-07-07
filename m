Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4212171C9
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgGGPZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbgGGPZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3BE92065D;
        Tue,  7 Jul 2020 15:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135547;
        bh=0FKU8CzWdHgKgcmcyG4su7ho8QOKuw0YpyhgYdqI3TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmXodH2BvQnicCDshTOZN/fhFwHOTQ+Xu4CG+/6AxfrCMa213pCkLjZxzzLiPTuUa
         207DCxl+kEYJcPe5icfdUz7fcVK53MVtqW779pBHu4iXcPMQ/va21ZJWRHLj6HXTTr
         ZaJFq0YEYyFSd09CnxBGijcZsm7963UIvMuD3F8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 084/112] io_uring: fix regression with always ignoring signals in io_cqring_wait()
Date:   Tue,  7 Jul 2020 17:17:29 +0200
Message-Id: <20200707145804.978657030@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b7db41c9e03b5189bc94993bd50e4506ac9e34c1 ]

When switching to TWA_SIGNAL for task_work notifications, we also made
any signal based condition in io_cqring_wait() return -ERESTARTSYS.
This breaks applications that rely on using signals to abort someone
waiting for events.

Check if we have a signal pending because of queued task_work, and
repeat the signal check once we've run the task_work. This provides a
reliable way of telling the two apart.

Additionally, only use TWA_SIGNAL if we are using an eventfd. If not,
we don't have the dependency situation described in the original commit,
and we can get by with just using TWA_RESUME like we previously did.

Fixes: ce593a6c480a ("io_uring: use signal based task_work running")
Cc: stable@vger.kernel.org # v5.7
Reported-by: Andres Freund <andres@anarazel.de>
Tested-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51362a619fd50..2be6ea0103405 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4136,14 +4136,22 @@ struct io_poll_table {
 	int error;
 };
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
-				int notify)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 {
 	struct task_struct *tsk = req->task;
-	int ret;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret, notify = TWA_RESUME;
 
-	if (req->ctx->flags & IORING_SETUP_SQPOLL)
+	/*
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
+	 * If we're not using an eventfd, then TWA_RESUME is always fine,
+	 * as we won't have dependencies between request completions for
+	 * other kernel wait conditions.
+	 */
+	if (ctx->flags & IORING_SETUP_SQPOLL)
 		notify = 0;
+	else if (ctx->cq_ev_fd)
+		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
 	if (!ret)
@@ -4174,7 +4182,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work, TWA_SIGNAL);
+	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
@@ -6279,7 +6287,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		if (current->task_works)
 			task_work_run();
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			if (current->jobctl & JOBCTL_TASK_WORK) {
+				spin_lock_irq(&current->sighand->siglock);
+				current->jobctl &= ~JOBCTL_TASK_WORK;
+				recalc_sigpending();
+				spin_unlock_irq(&current->sighand->siglock);
+				continue;
+			}
+			ret = -EINTR;
 			break;
 		}
 		if (io_should_wake(&iowq, false))
@@ -6288,7 +6303,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
+	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
-- 
2.25.1



