Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5188D443142
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 16:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhKBPLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 11:11:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49542 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhKBPLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 11:11:51 -0400
Date:   Tue, 02 Nov 2021 15:09:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635865753;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15VzYUG4Tu7ISK4xnUctzikT/wvw61Aa9s3NHbWnv3c=;
        b=eib+bDeGPIqiETitc8b0aC22pCOIOW9p5UYX9WkYwCMRcOjq1bmMHcGNfzDqzo4K5NQlNS
        cDtwFOPsNpH62kcnn05e8cWhBBjwe/dIo01KURneciCbNvsNLv8P+mgkcqPLrgrHn1OtVi
        SALhs8gBT1PFROjyDDJxWj29L/6Sj3w6qNOi29ZM3Pddto7twcKvCGGTIauoau+xpTZsM+
        ZFQGpa6nNffxmqHiwmORGrn3HwilPidDxlkDNTsp3WgEIp6OrqcknIVeZp2icXKWaHwi3q
        SuQj6drtxu1aPwbbGWi2HY6KLjk1MWR2asQorqcufdM6+EwI8yoyCdWpz0AYEA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635865753;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15VzYUG4Tu7ISK4xnUctzikT/wvw61Aa9s3NHbWnv3c=;
        b=ty9oHGGsQtxQ1EqoxlyPVg17kwR8WvDrdk0QgjL1TcEF44rvqQA22CX+aBNBguFNe49rvq
        dnFYMXla1ps7alBw==
From:   "tip-bot2 for Michael Pratt" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] posix-cpu-timers: Clear
 task::posix_cputimers_work in copy_process()
Cc:     Rhys Hiltner <rhys@justin.tv>, Michael Pratt <mpratt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211101210615.716522-1-mpratt@google.com>
References: <20211101210615.716522-1-mpratt@google.com>
MIME-Version: 1.0
Message-ID: <163586575225.626.2794170078411470152.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     ca7752caeaa70bd31d1714af566c9809688544af
Gitweb:        https://git.kernel.org/tip/ca7752caeaa70bd31d1714af566c9809688544af
Author:        Michael Pratt <mpratt@google.com>
AuthorDate:    Mon, 01 Nov 2021 17:06:15 -04:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 02 Nov 2021 12:52:17 +01:00

posix-cpu-timers: Clear task::posix_cputimers_work in copy_process()

copy_process currently copies task_struct.posix_cputimers_work as-is. If a
timer interrupt arrives while handling clone and before dup_task_struct
completes then the child task will have:

1. posix_cputimers_work.scheduled = true
2. posix_cputimers_work.work queued.

copy_process clears task_struct.task_works, so (2) will have no effect and
posix_cpu_timers_work will never run (not to mention it doesn't make sense
for two tasks to share a common linked list).

Since posix_cpu_timers_work never runs, posix_cputimers_work.scheduled is
never cleared. Since scheduled is set, future timer interrupts will skip
scheduling work, with the ultimate result that the task will never receive
timer expirations.

Together, the complete flow is:

1. Task 1 calls clone(), enters kernel.
2. Timer interrupt fires, schedules task work on Task 1.
   2a. task_struct.posix_cputimers_work.scheduled = true
   2b. task_struct.posix_cputimers_work.work added to
       task_struct.task_works.
3. dup_task_struct() copies Task 1 to Task 2.
4. copy_process() clears task_struct.task_works for Task 2.
5. Future timer interrupts on Task 2 see
   task_struct.posix_cputimers_work.scheduled = true and skip scheduling
   work.

Fix this by explicitly clearing contents of task_struct.posix_cputimers_work
in copy_process(). This was never meant to be shared or inherited across
tasks in the first place.

Fixes: 1fb497dd0030 ("posix-cpu-timers: Provide mechanisms to defer timer handling to task_work")
Reported-by: Rhys Hiltner <rhys@justin.tv>
Signed-off-by: Michael Pratt <mpratt@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211101210615.716522-1-mpratt@google.com

---
 include/linux/posix-timers.h   |  2 ++
 kernel/fork.c                  |  1 +
 kernel/time/posix-cpu-timers.c | 19 +++++++++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 00fef00..5bbcd28 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -184,8 +184,10 @@ static inline void posix_cputimers_group_init(struct posix_cputimers *pct,
 #endif
 
 #ifdef CONFIG_POSIX_CPU_TIMERS_TASK_WORK
+void clear_posix_cputimers_work(struct task_struct *p);
 void posix_cputimers_init_work(void);
 #else
+static inline void clear_posix_cputimers_work(struct task_struct *p) { }
 static inline void posix_cputimers_init_work(void) { }
 #endif
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e9feee..8269ae2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2279,6 +2279,7 @@ static __latent_entropy struct task_struct *copy_process(
 	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
+	clear_posix_cputimers_work(p);
 
 #ifdef CONFIG_KRETPROBES
 	p->kretprobe_instances.first = NULL;
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 643d412..96b4e78 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1159,13 +1159,28 @@ static void posix_cpu_timers_work(struct callback_head *work)
 }
 
 /*
+ * Clear existing posix CPU timers task work.
+ */
+void clear_posix_cputimers_work(struct task_struct *p)
+{
+	/*
+	 * A copied work entry from the old task is not meaningful, clear it.
+	 * N.B. init_task_work will not do this.
+	 */
+	memset(&p->posix_cputimers_work.work, 0,
+	       sizeof(p->posix_cputimers_work.work));
+	init_task_work(&p->posix_cputimers_work.work,
+		       posix_cpu_timers_work);
+	p->posix_cputimers_work.scheduled = false;
+}
+
+/*
  * Initialize posix CPU timers task work in init task. Out of line to
  * keep the callback static and to avoid header recursion hell.
  */
 void __init posix_cputimers_init_work(void)
 {
-	init_task_work(&current->posix_cputimers_work.work,
-		       posix_cpu_timers_work);
+	clear_posix_cputimers_work(current);
 }
 
 /*
