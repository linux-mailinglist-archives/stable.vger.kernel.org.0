Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3359214C02
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 13:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgGEL0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 07:26:54 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52163 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbgGEL0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jul 2020 07:26:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A1C56194077D;
        Sun,  5 Jul 2020 07:26:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 05 Jul 2020 07:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=E7a5NP
        RWrAHhdV1nBMIEEhjjUTicf2vakUmJtYHhgNE=; b=a2174DwnXyALbx+IQ45/za
        bbqd5fFvbxuWmEDnjaJfKyM2Tw0lmlkjASb+tEy3yY/tWxKscX19redpehqs1JWx
        PR/QaiGsx4eYY2Re/t6T0Y3juXBn4hgq3ijZ5suWiLOTpeRR4lDPINp80L1xtnMw
        W3HjdLLR7bh8mPoTp3rZp3umwilRF706ExjE8D9LAxfMgjB8cjw3u2KaN/aa8rci
        yPBYakJWFXNJN639JWAEVE24rwTJ4Lm7FfOvjfVpZ0Tj1ef3bHbhfPdAd8UipGZA
        /sCNAT5/nD7iH/oUohLsLGb2FsY4wtNVSKv4kOUPibBGelCVd7W/ZLjmxEZSnHdg
        ==
X-ME-Sender: <xms:_bgBXwxO1cN8TJ_6s7M8HQq2mFtrAFSj8pcpGSMyA_3AfenRKUjmRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddugdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_bgBX0Qf96gU6Fnf4iUsyI0uxJrOLht2vmyIv75ttKrp6JDhqnxsUA>
    <xmx:_bgBXyXAX7nzojAYNiH3M62bCukrSJe3PnFQJKwOLGOVyveXg6kA0g>
    <xmx:_bgBX-h5ZXHEWE-Y91v0Dfi3cEEUkgBlrR5T9X6d-vO8sru3O4xAZg>
    <xmx:_bgBX1PuBAImKsYJrBy4uqUfq0y_3e9Tq0eak5XU7upjOScNlNJnXg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 072ED328005E;
        Sun,  5 Jul 2020 07:26:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: use signal based task_work running" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Jul 2020 13:26:56 +0200
Message-ID: <15939484161622@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce593a6c480a22acba08795be313c0c6d49dd35d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 30 Jun 2020 12:39:05 -0600
Subject: [PATCH] io_uring: use signal based task_work running

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

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e507737f044e..700644a016a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4072,6 +4072,21 @@ struct io_poll_table {
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
@@ -4095,13 +4110,13 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
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
 
@@ -6182,19 +6197,20 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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

