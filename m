Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6F3FDBB2
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbhIAMnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345185AbhIAMkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1256611C8;
        Wed,  1 Sep 2021 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499840;
        bh=v4m37Mcdj3/PAUrDBqe/P3b9LrKCm9UQl7lYH54LLsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiQEcSWDANqzxz60bru22Fg0Z7PbRO6mSlO7TlNSY0H98pzRw6Sa8kmB/GmfI2EDR
         Yrmq36MmwYBMeVXXoN4GV7gBdgMKGwEgy5CQDFwKY3fpjFwOiKmvzkQfteJVbhFev5
         uCn2kiOL0iLY5L578InUe1YOMPIk6KJNm9EBLI+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 099/103] kthread: Fix PF_KTHREAD vs to_kthread() race
Date:   Wed,  1 Sep 2021 14:28:49 +0200
Message-Id: <20210901122303.861890601@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 3a7956e25e1d7b3c148569e78895e1f3178122a9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kthread.c    |   33 +++++++++++++++++++++++++++------
 kernel/sched/fair.c |    2 +-
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -84,6 +84,25 @@ static inline struct kthread *to_kthread
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
@@ -168,8 +187,9 @@ EXPORT_SYMBOL_GPL(kthread_freezable_shou
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
 
@@ -514,9 +535,9 @@ void kthread_set_per_cpu(struct task_str
 	set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
 }
 
-bool kthread_is_per_cpu(struct task_struct *k)
+bool kthread_is_per_cpu(struct task_struct *p)
 {
-	struct kthread *kthread = to_kthread(k);
+	struct kthread *kthread = __to_kthread(p);
 	if (!kthread)
 		return false;
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7569,7 +7569,7 @@ int can_migrate_task(struct task_struct
 		return 0;
 
 	/* Disregard pcpu kthreads; they are where they need to be. */
-	if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+	if (kthread_is_per_cpu(p))
 		return 0;
 
 	if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {


