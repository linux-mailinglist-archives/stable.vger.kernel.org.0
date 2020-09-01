Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9CC2595A6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgIAPqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731714AbgIAPqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DF012064B;
        Tue,  1 Sep 2020 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975190;
        bh=Pbri9CDBPSDx7Xm5ZDK7RtH/qY66Bu9nGn6eW7EUyDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbnzjd3X+ch2rk5wF4E2WdMCzWBgMWoHtKwWhKqrfbex5912PZtgt5IAH0ds2PIez
         1CJhbPasEaHsVe81Uz4E7NCUkFMwhQPIpc5TuG/9g2RF3fQJsPMpatxlUbzbO7Tbec
         dTdo4RmWYYtddEgsVIW2Gvqry7Uck94/CeQOvKcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 243/255] io_uring: dont recurse on tsk->sighand->siglock with signalfd
Date:   Tue,  1 Sep 2020 17:11:39 +0200
Message-Id: <20200901151012.394964999@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit fd7d6de2241453fc7d042336d366a939a25bc5a9 ]

If an application is doing reads on signalfd, and we arm the poll handler
because there's no data available, then the wakeup can recurse on the
tasks sighand->siglock as the signal delivery from task_work_add() will
use TWA_SIGNAL and that attempts to lock it again.

We can detect the signalfd case pretty easily by comparing the poll->head
wait_queue_head_t with the target task signalfd wait queue. Just use
normal task wakeup for this case.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b966e2b8a77da..c384caad64665 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4114,7 +4114,8 @@ struct io_poll_table {
 	int error;
 };
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				bool twa_signal_ok)
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4127,7 +4128,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 * will do the job.
 	 */
 	notify = 0;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
@@ -4141,6 +4142,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
 	struct task_struct *tsk;
+	bool twa_signal_ok;
 	int ret;
 
 	/* for instances that support it check for an event match first: */
@@ -4156,13 +4158,21 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
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
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-- 
2.25.1



