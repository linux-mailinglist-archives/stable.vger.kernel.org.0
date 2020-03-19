Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA718B66D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbgCSN0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbgCSN0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0681F20658;
        Thu, 19 Mar 2020 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624413;
        bh=jOu0x2Mbdw6pEMZFB90RebM+Cfpi3qwKNruuiqi6zOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+ab043VDEMMCJ/oL+nqSMpdWt+znxgGfVpi2HMx08UWDDDNDOYCiDOnA0zQlD9LH
         fXGkX2GtgDxrVnjYsznHKuKsQcVN93w1gj/eHs8T2VYqFkITp/pye5My2mIwz/mzao
         guA8pDIyBrbpEhH3zbXzAmxbqoxNJWlaphi7MErM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 34/65] io_uring: fix poll_list race for SETUP_IOPOLL|SETUP_SQPOLL
Date:   Thu, 19 Mar 2020 14:04:16 +0100
Message-Id: <20200319123937.204774554@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit bdcd3eab2a9ae0ac93f27275b6895dd95e5bf360 ]

After making ext4 support iopoll method:
  let ext4_file_operations's iopoll method be iomap_dio_iopoll(),
we found fio can easily hang in fio_ioring_getevents() with below fio
job:
    rm -f testfile; sync;
    sudo fio -name=fiotest -filename=testfile -iodepth=128 -thread
-rw=write -ioengine=io_uring  -hipri=1 -sqthread_poll=1 -direct=1
-bs=4k -size=10G -numjobs=8 -runtime=2000 -group_reporting
with IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL enabled.

There are two issues that results in this hang, one reason is that
when IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL are enabled, fio
does not use io_uring_enter to get completed events, it relies on
kernel io_sq_thread to poll for completed events.

Another reason is that there is a race: when io_submit_sqes() in
io_sq_thread() submits a batch of sqes, variable 'inflight' will
record the number of submitted reqs, then io_sq_thread will poll for
reqs which have been added to poll_list. But note, if some previous
reqs have been punted to io worker, these reqs will won't be in
poll_list timely. io_sq_thread() will only poll for a part of previous
submitted reqs, and then find poll_list is empty, reset variable
'inflight' to be zero. If app just waits these deferred reqs and does
not wake up io_sq_thread again, then hang happens.

For app that entirely relies on io_sq_thread to poll completed requests,
let io_iopoll_req_issued() wake up io_sq_thread properly when adding new
element to poll_list, and when io_sq_thread prepares to sleep, check
whether poll_list is empty again, if not empty, continue to poll.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 59 +++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 60a4832089982..c8f8cc2463986 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1435,6 +1435,10 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 		list_add(&req->list, &ctx->poll_list);
 	else
 		list_add_tail(&req->list, &ctx->poll_list);
+
+	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
+	    wq_has_sleeper(&ctx->sqo_wait))
+		wake_up(&ctx->sqo_wait);
 }
 
 static void io_file_put(struct io_submit_state *state)
@@ -3857,9 +3861,8 @@ static int io_sq_thread(void *data)
 	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
-	unsigned inflight;
 	unsigned long timeout;
-	int ret;
+	int ret = 0;
 
 	complete(&ctx->completions[1]);
 
@@ -3867,39 +3870,19 @@ static int io_sq_thread(void *data)
 	set_fs(USER_DS);
 	old_cred = override_creds(ctx->creds);
 
-	ret = timeout = inflight = 0;
+	timeout = jiffies + ctx->sq_thread_idle;
 	while (!kthread_should_park()) {
 		unsigned int to_submit;
 
-		if (inflight) {
+		if (!list_empty(&ctx->poll_list)) {
 			unsigned nr_events = 0;
 
-			if (ctx->flags & IORING_SETUP_IOPOLL) {
-				/*
-				 * inflight is the count of the maximum possible
-				 * entries we submitted, but it can be smaller
-				 * if we dropped some of them. If we don't have
-				 * poll entries available, then we know that we
-				 * have nothing left to poll for. Reset the
-				 * inflight count to zero in that case.
-				 */
-				mutex_lock(&ctx->uring_lock);
-				if (!list_empty(&ctx->poll_list))
-					io_iopoll_getevents(ctx, &nr_events, 0);
-				else
-					inflight = 0;
-				mutex_unlock(&ctx->uring_lock);
-			} else {
-				/*
-				 * Normal IO, just pretend everything completed.
-				 * We don't have to poll completions for that.
-				 */
-				nr_events = inflight;
-			}
-
-			inflight -= nr_events;
-			if (!inflight)
+			mutex_lock(&ctx->uring_lock);
+			if (!list_empty(&ctx->poll_list))
+				io_iopoll_getevents(ctx, &nr_events, 0);
+			else
 				timeout = jiffies + ctx->sq_thread_idle;
+			mutex_unlock(&ctx->uring_lock);
 		}
 
 		to_submit = io_sqring_entries(ctx);
@@ -3928,7 +3911,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (inflight ||
+			if (!list_empty(&ctx->poll_list) ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				cond_resched();
@@ -3938,6 +3921,19 @@ static int io_sq_thread(void *data)
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 
+			/*
+			 * While doing polled IO, before going to sleep, we need
+			 * to check if there are new reqs added to poll_list, it
+			 * is because reqs may have been punted to io worker and
+			 * will be added to poll_list later, hence check the
+			 * poll_list again.
+			 */
+			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
+			    !list_empty_careful(&ctx->poll_list)) {
+				finish_wait(&ctx->sqo_wait, &wait);
+				continue;
+			}
+
 			/* Tell userspace we may need a wakeup call */
 			ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
 			/* make sure to read SQ tail after writing flags */
@@ -3966,8 +3962,7 @@ static int io_sq_thread(void *data)
 		mutex_lock(&ctx->uring_lock);
 		ret = io_submit_sqes(ctx, to_submit, NULL, -1, &cur_mm, true);
 		mutex_unlock(&ctx->uring_lock);
-		if (ret > 0)
-			inflight += ret;
+		timeout = jiffies + ctx->sq_thread_idle;
 	}
 
 	set_fs(old_fs);
-- 
2.20.1



