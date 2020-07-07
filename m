Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD42171B1
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgGGPYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730042AbgGGPYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8387C20874;
        Tue,  7 Jul 2020 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135450;
        bh=aTGjenq/tu0G7rMwGC06gN5xtWY1BhX/OfIMCVEvxSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWyHLBRrmxDDSMX2+0Z581Ta12s4vMO7BhpkZT1WLi2S+Hmty6zpYcOBZfzLPcWv1
         /+9EYgcRTKVj3gWjmhSAQECi4a1ufOO2ghe/X/a9SLZQen3lPVFDaIlWDTRYBjZgb/
         4b90e9kX5QOkq1MDebbMGCblXvcDn/2/Xxc5INeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 045/112] task_work: teach task_work_add() to do signal_wake_up()
Date:   Tue,  7 Jul 2020 17:16:50 +0200
Message-Id: <20200707145803.144105968@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit e91b48162332480f5840902268108bb7fb7a44c7 ]

So that the target task will exit the wait_event_interruptible-like
loop and call task_work_run() asap.

The patch turns "bool notify" into 0,TWA_RESUME,TWA_SIGNAL enum, the
new TWA_SIGNAL flag implies signal_wake_up().  However, it needs to
avoid the race with recalc_sigpending(), so the patch also adds the
new JOBCTL_TASK_WORK bit included in JOBCTL_PENDING_MASK.

TODO: once this patch is merged we need to change all current users
of task_work_add(notify = true) to use TWA_RESUME.

Cc: stable@vger.kernel.org # v5.7
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/jobctl.h |  4 +++-
 include/linux/task_work.h    |  5 ++++-
 kernel/signal.c              | 10 +++++++---
 kernel/task_work.c           | 16 ++++++++++++++--
 4 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/jobctl.h b/include/linux/sched/jobctl.h
index fa067de9f1a94..d2b4204ba4d34 100644
--- a/include/linux/sched/jobctl.h
+++ b/include/linux/sched/jobctl.h
@@ -19,6 +19,7 @@ struct task_struct;
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
 #define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
+#define JOBCTL_TASK_WORK_BIT	24	/* set by TWA_SIGNAL */
 
 #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
@@ -28,9 +29,10 @@ struct task_struct;
 #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
 #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
 #define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
+#define JOBCTL_TASK_WORK	(1UL << JOBCTL_TASK_WORK_BIT)
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
-#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
+#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK | JOBCTL_TASK_WORK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask);
 extern void task_clear_jobctl_trapping(struct task_struct *task);
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index bd9a6a91c097e..0fb93aafa4785 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -13,7 +13,10 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 	twork->func = func;
 }
 
-int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
+#define TWA_RESUME	1
+#define TWA_SIGNAL	2
+int task_work_add(struct task_struct *task, struct callback_head *twork, int);
+
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 284fc1600063b..d5feb34b5e158 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2529,9 +2529,6 @@ bool get_signal(struct ksignal *ksig)
 	struct signal_struct *signal = current->signal;
 	int signr;
 
-	if (unlikely(current->task_works))
-		task_work_run();
-
 	if (unlikely(uprobe_deny_signal()))
 		return false;
 
@@ -2544,6 +2541,13 @@ bool get_signal(struct ksignal *ksig)
 
 relock:
 	spin_lock_irq(&sighand->siglock);
+	current->jobctl &= ~JOBCTL_TASK_WORK;
+	if (unlikely(current->task_works)) {
+		spin_unlock_irq(&sighand->siglock);
+		task_work_run();
+		goto relock;
+	}
+
 	/*
 	 * Every stopped thread goes here after wakeup. Check to see if
 	 * we should notify the parent, prepare_signal(SIGCONT) encodes
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 825f28259a19a..5c0848ca1287d 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -25,9 +25,10 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
  * 0 if succeeds or -ESRCH.
  */
 int
-task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
+task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 {
 	struct callback_head *head;
+	unsigned long flags;
 
 	do {
 		head = READ_ONCE(task->task_works);
@@ -36,8 +37,19 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
 
-	if (notify)
+	switch (notify) {
+	case TWA_RESUME:
 		set_notify_resume(task);
+		break;
+	case TWA_SIGNAL:
+		if (lock_task_sighand(task, &flags)) {
+			task->jobctl |= JOBCTL_TASK_WORK;
+			signal_wake_up(task, 0);
+			unlock_task_sighand(task, &flags);
+		}
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.25.1



