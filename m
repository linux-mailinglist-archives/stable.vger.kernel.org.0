Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCACA21723A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgGGPa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbgGGPYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DD74207D0;
        Tue,  7 Jul 2020 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135452;
        bh=2ZNNi2geWKQy6z4LM6BHlQI2VVnnJCfcD3MR22KGryc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0s2KL7/RzkEETxZudWzUtJ8oPnk+cVQDDlBFIBgHHvZ1bMQfVheN11r/dh5FIIbSc
         ylFef4JRHu3l5lU1eKgXqTfWcIRfSqbt4X0rAF58qkqKLfFAbkpjLCj4sFgiZ0+vsQ
         ijX+1FRInubWhIU805eoZ7+5Xql6i8hnmhTsxyho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 046/112] io_uring: use signal based task_work running
Date:   Tue,  7 Jul 2020 17:16:51 +0200
Message-Id: <20200707145803.190649104@linuxfoundation.org>
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

[ Upstream commit ce593a6c480a22acba08795be313c0c6d49dd35d ]

Since 5.7, we've been using task_work to trigger async running of
requests in the context of the original task. This generally works
great, but there's a case where if the task is currently blocked
in the kernel waiting on a condition to become true, it won't process
task_work. Even though the task is woken, it just checks whatever
condition it's waiting on, and goes back to sleep if it's still false.

This is a problem if that very condition only becomes true when that
task_work is run. An example of that is the task registering an eventfd
with io_uring, and it's now blocked waiting on an eventfd read. That
read could depend on a completion event, and that completion event
won't get trigged until task_work has been run.

Use the TWA_SIGNAL notification for task_work, so that we ensure that
the task always runs the work when queued.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 71d281f68ed83..51362a619fd50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4136,6 +4136,21 @@ struct io_poll_table {
 	int error;
 };
 
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				int notify)
+{
+	struct task_struct *tsk = req->task;
+	int ret;
+
+	if (req->ctx->flags & IORING_SETUP_SQPOLL)
+		notify = 0;
+
+	ret = task_work_add(tsk, cb, notify);
+	if (!ret)
+		wake_up_process(tsk);
+	return ret;
+}
+
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
@@ -4159,13 +4174,13 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = task_work_add(tsk, &req->task_work, true);
+	ret = io_req_task_work_add(req, &req->task_work, TWA_SIGNAL);
 	if (unlikely(ret)) {
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, true);
+		task_work_add(tsk, &req->task_work, 0);
+		wake_up_process(tsk);
 	}
-	wake_up_process(tsk);
 	return 1;
 }
 
@@ -6260,19 +6275,20 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
+		/* make sure we run task_work before checking for signals */
 		if (current->task_works)
 			task_work_run();
-		if (io_should_wake(&iowq, false))
-			break;
-		schedule();
 		if (signal_pending(current)) {
-			ret = -EINTR;
+			ret = -ERESTARTSYS;
 			break;
 		}
+		if (io_should_wake(&iowq, false))
+			break;
+		schedule();
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-	restore_saved_sigmask_unless(ret == -EINTR);
+	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
-- 
2.25.1



