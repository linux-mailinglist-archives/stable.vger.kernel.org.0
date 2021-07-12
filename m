Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2863C4C3B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbhGLHCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241185AbhGLHB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8668E613C2;
        Mon, 12 Jul 2021 06:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073146;
        bh=SodTYBS+nkhTYIaTFCakuqhJ3rhlLOR54Z4vuce8TuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V30ug1F6Akoe8+nFMpYHIAn2yZS2m+WQrW6MMuObsy2JuzhaABcJ/p8cSoGepjkI0
         la8fat042JvX2/rjPBMBusTSwhnkhMrC3bhdo/sZ0GZt8WRxjpQsMWwOxmnuDLCYqg
         8sJhT7xlDVLpFIaSr4iolkNhfyOdz1lwgBj/GUro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 142/700] sched: Make the idle task quack like a per-CPU kthread
Date:   Mon, 12 Jul 2021 08:03:45 +0200
Message-Id: <20210712060945.607511725@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 00b89fe0197f0c55a045775c11553c0cdb7082fe ]

For all intents and purposes, the idle task is a per-CPU kthread. It isn't
created via the same route as other pcpu kthreads however, and as a result
it is missing a few bells and whistles: it fails kthread_is_per_cpu() and
it doesn't have PF_NO_SETAFFINITY set.

Fix the former by giving the idle task a kthread struct along with the
KTHREAD_IS_PER_CPU flag. This requires some extra iffery as init_idle()
call be called more than once on the same idle task.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210510151024.2448573-2-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kthread.h |  2 ++
 kernel/kthread.c        | 30 ++++++++++++++++++------------
 kernel/sched/core.c     | 21 +++++++++++++++------
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 2484ed97e72f..d9133d6db308 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -33,6 +33,8 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 					  unsigned int cpu,
 					  const char *namefmt);
 
+void set_kthread_struct(struct task_struct *p);
+
 void kthread_set_per_cpu(struct task_struct *k, int cpu);
 bool kthread_is_per_cpu(struct task_struct *k);
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4fdf2bd9b558..e8da89c714f5 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -68,16 +68,6 @@ enum KTHREAD_BITS {
 	KTHREAD_SHOULD_PARK,
 };
 
-static inline void set_kthread_struct(void *kthread)
-{
-	/*
-	 * We abuse ->set_child_tid to avoid the new member and because it
-	 * can't be wrongly copied by copy_process(). We also rely on fact
-	 * that the caller can't exec, so PF_KTHREAD can't be cleared.
-	 */
-	current->set_child_tid = (__force void __user *)kthread;
-}
-
 static inline struct kthread *to_kthread(struct task_struct *k)
 {
 	WARN_ON(!(k->flags & PF_KTHREAD));
@@ -103,6 +93,22 @@ static inline struct kthread *__to_kthread(struct task_struct *p)
 	return kthread;
 }
 
+void set_kthread_struct(struct task_struct *p)
+{
+	struct kthread *kthread;
+
+	if (__to_kthread(p))
+		return;
+
+	kthread = kzalloc(sizeof(*kthread), GFP_KERNEL);
+	/*
+	 * We abuse ->set_child_tid to avoid the new member and because it
+	 * can't be wrongly copied by copy_process(). We also rely on fact
+	 * that the caller can't exec, so PF_KTHREAD can't be cleared.
+	 */
+	p->set_child_tid = (__force void __user *)kthread;
+}
+
 void free_kthread_struct(struct task_struct *k)
 {
 	struct kthread *kthread;
@@ -272,8 +278,8 @@ static int kthread(void *_create)
 	struct kthread *self;
 	int ret;
 
-	self = kzalloc(sizeof(*self), GFP_KERNEL);
-	set_kthread_struct(self);
+	set_kthread_struct(current);
+	self = to_kthread(current);
 
 	/* If user was SIGKILLed, I release the structure. */
 	done = xchg(&create->done, NULL);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e25b2d8ec18d..17f612045271 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7435,12 +7435,25 @@ void __init init_idle(struct task_struct *idle, int cpu)
 
 	__sched_fork(0, idle);
 
+	/*
+	 * The idle task doesn't need the kthread struct to function, but it
+	 * is dressed up as a per-CPU kthread and thus needs to play the part
+	 * if we want to avoid special-casing it in code that deals with per-CPU
+	 * kthreads.
+	 */
+	set_kthread_struct(idle);
+
 	raw_spin_lock_irqsave(&idle->pi_lock, flags);
 	raw_spin_lock(&rq->lock);
 
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
-	idle->flags |= PF_IDLE;
+	/*
+	 * PF_KTHREAD should already be set at this point; regardless, make it
+	 * look like a proper per-CPU kthread.
+	 */
+	idle->flags |= PF_IDLE | PF_KTHREAD | PF_NO_SETAFFINITY;
+	kthread_set_per_cpu(idle, cpu);
 
 	scs_task_reset(idle);
 	kasan_unpoison_task_stack(idle);
@@ -7647,12 +7660,8 @@ static void balance_push(struct rq *rq)
 	/*
 	 * Both the cpu-hotplug and stop task are in this case and are
 	 * required to complete the hotplug process.
-	 *
-	 * XXX: the idle task does not match kthread_is_per_cpu() due to
-	 * histerical raisins.
 	 */
-	if (rq->idle == push_task ||
-	    kthread_is_per_cpu(push_task) ||
+	if (kthread_is_per_cpu(push_task) ||
 	    is_migration_disabled(push_task)) {
 
 		/*
-- 
2.30.2



