Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB7A2474BA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgHQTOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730340AbgHQPkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F8CC23343;
        Mon, 17 Aug 2020 15:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678815;
        bh=OcRL81cZfVRoE/k4wxL8Y+ucO+Gbpj6KCXAPEkW9zzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPP6nFFwshbLWyiMKm+i453zewa/Oc2++k1+lqXEkinH4GkgaTfbuUPjG0Lbp399v
         0mFRL+cpTviGgGoY6n89ID9ZYrpdRfhQ5CZHmZl1nNhJkBlz1wGmzhDak2UUiG9jmA
         mtM29L5oZS2TXjQS+zrtCUfMFc+tpguZ/uFWnork=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 464/464] task_work: only grab task signal lock when needed
Date:   Mon, 17 Aug 2020 17:16:57 +0200
Message-Id: <20200817143856.004716384@linuxfoundation.org>
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

commit ebf0d100df0731901c16632f78d78d35f4123bc4 upstream.

If JOBCTL_TASK_WORK is already set on the targeted task, then we need
not go through {lock,unlock}_task_sighand() to set it again and queue
a signal wakeup. This is safe as we're checking it _after_ adding the
new task_work with cmpxchg().

The ordering is as follows:

task_work_add()				get_signal()
--------------------------------------------------------------
STORE(task->task_works, new_work);	STORE(task->jobctl);
mb();					mb();
LOAD(task->jobctl);			LOAD(task->task_works);

This speeds up TWA_SIGNAL handling quite a bit, which is important now
that io_uring is relying on it for all task_work deliveries.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c    |   16 +++++++++++++++-
 kernel/task_work.c |    8 +++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2541,7 +2541,21 @@ bool get_signal(struct ksignal *ksig)
 
 relock:
 	spin_lock_irq(&sighand->siglock);
-	current->jobctl &= ~JOBCTL_TASK_WORK;
+	/*
+	 * Make sure we can safely read ->jobctl() in task_work add. As Oleg
+	 * states:
+	 *
+	 * It pairs with mb (implied by cmpxchg) before READ_ONCE. So we
+	 * roughly have
+	 *
+	 *	task_work_add:				get_signal:
+	 *	STORE(task->task_works, new_work);	STORE(task->jobctl);
+	 *	mb();					mb();
+	 *	LOAD(task->jobctl);			LOAD(task->task_works);
+	 *
+	 * and we can rely on STORE-MB-LOAD [ in task_work_add].
+	 */
+	smp_store_mb(current->jobctl, current->jobctl & ~JOBCTL_TASK_WORK);
 	if (unlikely(current->task_works)) {
 		spin_unlock_irq(&sighand->siglock);
 		task_work_run();
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -42,7 +42,13 @@ task_work_add(struct task_struct *task,
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		if (lock_task_sighand(task, &flags)) {
+		/*
+		 * Only grab the sighand lock if we don't already have some
+		 * task_work pending. This pairs with the smp_store_mb()
+		 * in get_signal(), see comment there.
+		 */
+		if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
+		    lock_task_sighand(task, &flags)) {
 			task->jobctl |= JOBCTL_TASK_WORK;
 			signal_wake_up(task, 0);
 			unlock_task_sighand(task, &flags);


