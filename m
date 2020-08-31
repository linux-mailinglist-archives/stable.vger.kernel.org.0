Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B620257702
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgHaJ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:58:19 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41457 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgHaJ6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:58:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D4F7567F;
        Mon, 31 Aug 2020 05:58:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1kSGmD
        RJI3hlRDOoWCF94HPr+nyinrTJ7f76mFZD1fk=; b=Qkj8mSwyNv6FLtfDmn4Bk/
        +11ztT5vZNjlgFmz1djDPZmdZyQ8o1WoGJ4Qq8XeuSIrEBBEvXNUu5qbNFEZOWUA
        FFYDcK7ihGB/BxApGoOLlV6b3TNJNSbgB9GXJ8L8yC1iQjA21G6mIpYtNVOoWaCe
        vPaHOEgs0zuVydcBkoUvw7SKmCoqJp/f+ygeDGYeb6lkvgg17poLW8+Uwr/tG1z/
        tHNAgEg33n6NqV22gGacEcrmxNZDbOoWav/aZI91kWbkTBx6YAJFayiEFTx/BsOj
        WcWV9Y1LKUHeLsHHTbGyZPxWe70VSka4MNwV9hR/d+rqlAZtJ+Qm3UW7e1umhLLw
        ==
X-ME-Sender: <xms:uclMX50PGZ6qttlM9P7_TsBujCivbOHqLEvNaRynOe6bywWWkAOG9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:uclMXwHQZKeirOqNGRSrlWGuZFtAyBkTsz_BSzVswYL-EMng_iSJSg>
    <xmx:uclMX57OGW9cMT987hgf_yMh4PLE_7guub4JoSdEVkKzo6vN2iKbrQ>
    <xmx:uclMX21ZKkC8FOx1-9zVAk9t6-SSULDi1eX3sg4x4dLcSLlydMQIKA>
    <xmx:uclMXwTx7kL_VcJM19hEpJ7MrSucBIPP06FCxxAq6NTIl8p8mEbPh5O8B2o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3D88328005D;
        Mon, 31 Aug 2020 05:58:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: don't recurse on tsk->sighand->siglock with" failed to apply to 5.8-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:58:25 +0200
Message-ID: <1598867905173168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd7d6de2241453fc7d042336d366a939a25bc5a9 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 23 Aug 2020 11:00:37 -0600
Subject: [PATCH] io_uring: don't recurse on tsk->sighand->siglock with
 signalfd

If an application is doing reads on signalfd, and we arm the poll handler
because there's no data available, then the wakeup can recurse on the
tasks sighand->siglock as the signal delivery from task_work_add() will
use TWA_SIGNAL and that attempts to lock it again.

We can detect the signalfd case pretty easily by comparing the poll->head
wait_queue_head_t with the target task signalfd wait queue. Just use
normal task wakeup for this case.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e2cc8414f9..c9d526ff55e0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1746,7 +1746,8 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				bool twa_signal_ok)
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1759,7 +1760,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 * will do the job.
 	 */
 	notify = 0;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
@@ -1819,7 +1820,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	init_task_work(&req->task_work, io_req_task_submit);
 	percpu_ref_get(&req->ctx->refs);
 
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, true);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
@@ -2322,7 +2323,7 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	init_task_work(&req->task_work, io_rw_resubmit);
 	percpu_ref_get(&req->ctx->refs);
 
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, true);
 	if (!ret)
 		return true;
 #endif
@@ -3044,7 +3045,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, true);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
@@ -4566,6 +4567,7 @@ struct io_poll_table {
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
+	bool twa_signal_ok;
 	int ret;
 
 	/* for instances that support it check for an event match first: */
@@ -4580,13 +4582,21 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	init_task_work(&req->task_work, func);
 	percpu_ref_get(&req->ctx->refs);
 
+	/*
+	 * If we using the signalfd wait_queue_head for this wakeup, then
+	 * it's not safe to use TWA_SIGNAL as we could be recursing on the
+	 * tsk->sighand->siglock on doing the wakeup. Should not be needed
+	 * either, as the normal wakeup will suffice.
+	 */
+	twa_signal_ok = (poll->head != &req->task->sighand->signalfd_wqh);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, twa_signal_ok);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 

