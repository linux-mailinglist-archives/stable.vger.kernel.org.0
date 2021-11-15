Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0211D451EB5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347201AbhKPAhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344936AbhKOTZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99EF8636F9;
        Mon, 15 Nov 2021 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003226;
        bh=DyiEg/cv15DnuYy2ZqnNimNbsbpFg6yfctqrHf6X79A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHH7MLNuSUZjlO/1HLyITr8twmM/DbR6uEuivrx4EM//dI2pa2b8SkYy8MXRFlNjw
         CGoX5rXQ4O/JMeE6pEHYpkIKI3YWUbVWQKlImFoMSDYCfWq4p+1uBiuweTfzX+L1r6
         VUceQAzino/WI/fxHf6iiLAmbyhgWz8HcPFDcBQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rhys Hiltner <rhys@justin.tv>,
        Michael Pratt <mpratt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 858/917] posix-cpu-timers: Clear task::posix_cputimers_work in copy_process()
Date:   Mon, 15 Nov 2021 18:05:53 +0100
Message-Id: <20211115165458.129939374@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Pratt <mpratt@google.com>

commit ca7752caeaa70bd31d1714af566c9809688544af upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/posix-timers.h   |    2 ++
 kernel/fork.c                  |    1 +
 kernel/time/posix-cpu-timers.c |   19 +++++++++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -184,8 +184,10 @@ static inline void posix_cputimers_group
 #endif
 
 #ifdef CONFIG_POSIX_CPU_TIMERS_TASK_WORK
+void clear_posix_cputimers_work(struct task_struct *p);
 void posix_cputimers_init_work(void);
 #else
+static inline void clear_posix_cputimers_work(struct task_struct *p) { }
 static inline void posix_cputimers_init_work(void) { }
 #endif
 
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2280,6 +2280,7 @@ static __latent_entropy struct task_stru
 	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
+	clear_posix_cputimers_work(p);
 
 #ifdef CONFIG_KRETPROBES
 	p->kretprobe_instances.first = NULL;
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1159,13 +1159,28 @@ static void posix_cpu_timers_work(struct
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


