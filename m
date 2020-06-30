Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1D20FBFD
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgF3Sph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 14:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgF3Sp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 14:45:27 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD1CC03E97B
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 11:45:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f6so5781537pjq.5
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6mvVREkDVIeNCrD7qi8PMtAVT+USyRgLji8dDcK1MZI=;
        b=tM+dHm+GPgciq6qnWfKbJo4Kq5Tayh8q0IFFz6A7wCZjuzwVo/FSrLEbDCu/fnQyBQ
         jqsvcSJWViFdBp1grNeoyvO7uDBJqWq551Ws9xRJ4INAtpeDu14PXZD4DTga/5DppuZ/
         JGneIRzbaZq5NBpkuP4eRsx52aJsUUWyO3n0AFdbCyM4AFTjnYBY8SpWrfh6R8G7P8s5
         zLO6a0RrsmwbyZ7b4KwKEQhXLgFxo9rfv/nod+0In7WVqCKZj5EzcL7UkqwEmFU8/bHH
         Ct2lJoZQXQvMzl/3hHA4JdyGPr8pudetykENgjEM3wfLX5z9C24aUMVSzFVD70zO47wi
         1Rzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6mvVREkDVIeNCrD7qi8PMtAVT+USyRgLji8dDcK1MZI=;
        b=QIR+/SxIekIEfDnCT3IWJrta+6aU1zZw8a7xTjK0sHVAJociCG2WPgRQHcTW/+OD9j
         Ww5Y3gmOnPq14cI5rQRoyc0KgeuYbS97RNEdPmJnP6u6B7UJ/tu+0H0M7dgNb3Ti8p7k
         t4Ut1rHBCzc5viFzyPsBeWSrFP+g1MZq7C2Kpso4mlpIU+C1l7Lq8wzLZdzfc8v3664F
         KQyrG9K9vsXwpnbqGS3PXf8FPwA25HgNdvfktM0DMD+BUM/Ucpd+eTnjAPexRguQq+hh
         6WID8InsApdxIfkl5BtrAJ5drsDmvK3n5lY2nJeBvS+cJye7SDGkPlS4ARH+m1P7LopP
         xydA==
X-Gm-Message-State: AOAM531O955fnEuOFipAq0Mn8OjSBt4briwxY4zE7MSka4tvBZwLyr9D
        hXwdg0ChpLC+aTqCnmrWfBgcTw==
X-Google-Smtp-Source: ABdhPJyq42/4G38YKmmdE3qsIa6PN0u2bg0XuBD4ozWyinzBPeXVqQCsyzLFwjhKG9yVm+5zjUzYnQ==
X-Received: by 2002:a17:90a:1ac3:: with SMTP id p61mr24724332pjp.23.1593542726013;
        Tue, 30 Jun 2020 11:45:26 -0700 (PDT)
Received: from localhost.localdomain ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id n7sm2898108pjq.22.2020.06.30.11.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:45:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     oleg@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] task_work: teach task_work_add() to do signal_wake_up()
Date:   Tue, 30 Jun 2020 12:45:17 -0600
Message-Id: <20200630184518.696101-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630184518.696101-1-axboe@kernel.dk>
References: <20200630184518.696101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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
---
 include/linux/sched/jobctl.h |  4 +++-
 include/linux/task_work.h    |  5 ++++-
 kernel/signal.c              | 10 +++++++---
 kernel/task_work.c           | 16 ++++++++++++++--
 4 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/jobctl.h b/include/linux/sched/jobctl.h
index fa067de9f1a9..d2b4204ba4d3 100644
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
index bd9a6a91c097..0fb93aafa478 100644
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
index 5ca48cc5da76..ee22ec78fd6d 100644
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
index 825f28259a19..5c0848ca1287 100644
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
2.27.0

