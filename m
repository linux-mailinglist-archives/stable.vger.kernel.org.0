Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9B3FB458
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 13:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhH3LG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 07:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbhH3LG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 07:06:26 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB38C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 04:05:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b3b00d3b4792b4d2f5d4a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:3b00:d3b4:792b:4d2f:5d4a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF2591EC047D;
        Mon, 30 Aug 2021 13:05:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1630321526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=wDMnoW6daYd5rFh4ggH4vRCJT3b2E6Dl00LeHT92XBk=;
        b=Qlx2sdTlqR1A5ZNN1AiBfMCT8lZ6XdV/ASBJ+yuWMCH6bkQqw4JPOFcvhaIeSS18Xq6s1/
        brMczbxoHNbPafmUIq7yZbElgxbBep0K3APXeSQnsz/wmc9KCDnsCGoDZU9B2CMKjJGrMe
        H1uBRQiZoGFUViG95WuuH4K4KsYq5Bc=
Date:   Mon, 30 Aug 2021 13:05:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     stable@vger.kernel.org
Cc:     bugzilla.kernel.org@e3q.eu
Subject: [PATCH] kthread: Fix PF_KTHREAD vs to_kthread() race
Message-ID: <YSy7lOd+qB7LXq1n@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable folks,

please queue for 5.10-stable.

See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.

---
Commit 3a7956e25e1d7b3c148569e78895e1f3178122a9 upstream.

The kthread_is_per_cpu() construct relies on only being called on
PF_KTHREAD tasks (per the WARN in to_kthread). This gives rise to the
following usage pattern:

	if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))

However, as reported by syzcaller, this is broken. The scenario is:

	CPU0				CPU1 (running p)

	(p->flags & PF_KTHREAD) // true

					begin_new_exec()
					  me->flags &= ~(PF_KTHREAD|...);
	kthread_is_per_cpu(p)
	  to_kthread(p)
	    WARN(!(p->flags & PF_KTHREAD) <-- *SPLAT*

Introduce __to_kthread() that omits the WARN and is sure to check both
values.

Use this to remove the problematic pattern for kthread_is_per_cpu()
and fix a number of other kthread_*() functions that have similar
issues but are currently not used in ways that would expose the
problem.

Notably kthread_func() is only ever called on 'current', while
kthread_probe_data() is only used for PF_WQ_WORKER, which implies the
task is from kthread_create*().

Fixes: ac687e6e8c26 ("kthread: Extract KTHREAD_IS_PER_CPU")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <Valentin.Schneider@arm.com>
Link: https://lkml.kernel.org/r/YH6WJc825C4P0FCK@hirez.programming.kicks-ass.net
[ Drop the balance_push() hunk as it is not needed. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 kernel/kthread.c    | 33 +++++++++++++++++++++++++++------
 kernel/sched/fair.c |  2 +-
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9825cf89c614..508fe5278285 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -84,6 +84,25 @@ static inline struct kthread *to_kthread(struct task_struct *k)
 	return (__force void *)k->set_child_tid;
 }
 
+/*
+ * Variant of to_kthread() that doesn't assume @p is a kthread.
+ *
+ * Per construction; when:
+ *
+ *   (p->flags & PF_KTHREAD) && p->set_child_tid
+ *
+ * the task is both a kthread and struct kthread is persistent. However
+ * PF_KTHREAD on it's own is not, kernel_thread() can exec() (See umh.c and
+ * begin_new_exec()).
+ */
+static inline struct kthread *__to_kthread(struct task_struct *p)
+{
+	void *kthread = (__force void *)p->set_child_tid;
+	if (kthread && !(p->flags & PF_KTHREAD))
+		kthread = NULL;
+	return kthread;
+}
+
 void free_kthread_struct(struct task_struct *k)
 {
 	struct kthread *kthread;
@@ -168,8 +187,9 @@ EXPORT_SYMBOL_GPL(kthread_freezable_should_stop);
  */
 void *kthread_func(struct task_struct *task)
 {
-	if (task->flags & PF_KTHREAD)
-		return to_kthread(task)->threadfn;
+	struct kthread *kthread = __to_kthread(task);
+	if (kthread)
+		return kthread->threadfn;
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(kthread_func);
@@ -199,10 +219,11 @@ EXPORT_SYMBOL_GPL(kthread_data);
  */
 void *kthread_probe_data(struct task_struct *task)
 {
-	struct kthread *kthread = to_kthread(task);
+	struct kthread *kthread = __to_kthread(task);
 	void *data = NULL;
 
-	copy_from_kernel_nofault(&data, &kthread->data, sizeof(data));
+	if (kthread)
+		copy_from_kernel_nofault(&data, &kthread->data, sizeof(data));
 	return data;
 }
 
@@ -514,9 +535,9 @@ void kthread_set_per_cpu(struct task_struct *k, int cpu)
 	set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
 }
 
-bool kthread_is_per_cpu(struct task_struct *k)
+bool kthread_is_per_cpu(struct task_struct *p)
 {
-	struct kthread *kthread = to_kthread(k);
+	struct kthread *kthread = __to_kthread(p);
 	if (!kthread)
 		return false;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 262b02d75007..bad97d35684d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7569,7 +7569,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		return 0;
 
 	/* Disregard pcpu kthreads; they are where they need to be. */
-	if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+	if (kthread_is_per_cpu(p))
 		return 0;
 
 	if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {
-- 
2.29.2


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
