Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC6B24694B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgHQPTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgHQPS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:18:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9451B205CB;
        Mon, 17 Aug 2020 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677538;
        bh=05f5PZRuwDC/mom1h9uwyPyuPxYfXeHUdrdAXEAQb1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7QBrtMmhUnkUexxPJp5Q/5E2IHxczCe9sTsr2Od+/EVHryBBX+tgxyqeujRsaFGB
         ibfpuOs7Jg9HNhviOX4+q8C9GRZ/afv8PLAd9++vENpivz3Sz/B5Glv90/ViZ+34gq
         8VFoWGe4EvQUY5vZybjR41WQrsqWwRpFBcRofTIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 003/464] io_uring: abstract out task work running
Date:   Mon, 17 Aug 2020 17:09:16 +0200
Message-Id: <20200817143833.905935358@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4c6e277c4cc4a6b3b2b9c66a7b014787ae757cc1 ]

Provide a helper to run task_work instead of checking and running
manually in a bunch of different spots. While doing so, also move the
task run state setting where we run the task work. Then we can move it
out of the callback helpers. This also helps ensure we only do this once
per task_work list run, not per task_work item.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 493e5047e67c9..95bacab047ddb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1747,6 +1747,17 @@ static int io_put_kbuf(struct io_kiocb *req)
 	return cflags;
 }
 
+static inline bool io_run_task_work(void)
+{
+	if (current->task_works) {
+		__set_current_state(TASK_RUNNING);
+		task_work_run();
+		return true;
+	}
+
+	return false;
+}
+
 static void io_iopoll_queue(struct list_head *again)
 {
 	struct io_kiocb *req;
@@ -1936,6 +1947,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 		 */
 		if (!(++iters & 7)) {
 			mutex_unlock(&ctx->uring_lock);
+			io_run_task_work();
 			mutex_lock(&ctx->uring_lock);
 		}
 
@@ -4356,7 +4368,6 @@ static void io_async_task_func(struct callback_head *cb)
 	kfree(apoll);
 
 	if (!canceled) {
-		__set_current_state(TASK_RUNNING);
 		if (io_sq_thread_acquire_mm(ctx, req)) {
 			io_cqring_add_event(req, -EFAULT);
 			goto end_req;
@@ -6082,8 +6093,7 @@ static int io_sq_thread(void *data)
 			if (!list_empty(&ctx->poll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
-				if (current->task_works)
-					task_work_run();
+				io_run_task_work();
 				cond_resched();
 				continue;
 			}
@@ -6115,8 +6125,7 @@ static int io_sq_thread(void *data)
 					finish_wait(&ctx->sqo_wait, &wait);
 					break;
 				}
-				if (current->task_works) {
-					task_work_run();
+				if (io_run_task_work()) {
 					finish_wait(&ctx->sqo_wait, &wait);
 					continue;
 				}
@@ -6145,8 +6154,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
 
-	if (current->task_works)
-		task_work_run();
+	io_run_task_work();
 
 	io_sq_thread_drop_mm(ctx);
 	revert_creds(old_cred);
@@ -6211,9 +6219,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		if (io_cqring_events(ctx, false) >= min_events)
 			return 0;
-		if (!current->task_works)
+		if (!io_run_task_work())
 			break;
-		task_work_run();
 	} while (1);
 
 	if (sig) {
@@ -6235,8 +6242,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
-		if (current->task_works)
-			task_work_run();
+		if (io_run_task_work())
+			continue;
 		if (signal_pending(current)) {
 			if (current->jobctl & JOBCTL_TASK_WORK) {
 				spin_lock_irq(&current->sighand->siglock);
@@ -7655,8 +7662,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
-	if (current->task_works)
-		task_work_run();
+	io_run_task_work();
 
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
-- 
2.25.1



