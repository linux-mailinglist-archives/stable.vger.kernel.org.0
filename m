Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBFD400264
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 17:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhICPfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 11:35:21 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:51082 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbhICPfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 11:35:21 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2021 11:35:20 EDT
Received: by mo1.intermailgate.com (Postfix, from userid 0)
        id 10CFE8203D; Fri,  3 Sep 2021 17:25:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630682708; bh=2GIHJA/3lyNi+7/2IoUOj/Dv7KIn9NgP93ah0a6C05w=;
        h=Date:From:To:Cc:Subject;
        b=KRZhpNvT/hQmp8OeOlV0pywADJZ89QlnWlQCk1alAix1jXSVUB6/XNrms0pPGlFEk
         x1CWmx90C5F94Lwd1aAQmAMxanmwZ6Tb8iOK+iqGTGunHNqzdJjUvvR5AN3M9Xyq/8
         QvNeG538d9XJ1MTSoWO09RG26K05E2RJkXcYt0x8=
Date:   Fri, 03 Sep 2021 17:25:08 +0200
From:   Patrick Schaaf <bof@bof.de>
To:     Greg KH <greg@kroah.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] for 5.4 : kthread: Fix PF_KTHREAD vs to_kthread() race
Message-ID: <61323e54.evOabX7OaRBtxnNj%bof@bof.de>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(second try, sending with mailx...)

After 3 days of successfully running 5.4.143 with this patch attached
and no issues, on a production workload (host + vms) of a busy
webserver and mysql database, I request queueing this for a future 5.4
stable, like the 5.10 one requested by Borislav; copying his mail text
in the hope that this is best form.

please queue for 5.4 stable

See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.

---
Commit 3a7956e25e1d7b3c148569e78895e1f3178122a9 upstream.

The kthread_is_per_cpu() construct relies on only being called on
PF_KTHREAD tasks (per the WARN in to_kthread). This gives rise to the
following usage pattern:

        if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))

However, as reported by syzcaller, this is broken. The scenario is:

        CPU0                            CPU1 (running p)

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
Signed-off-by: Patrick Schaaf <bof@bof.de>

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b2bac5d929d2..22750a8af83e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -76,6 +76,25 @@ static inline struct kthread *to_kthread(struct task_struct *k)
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
@@ -176,10 +195,11 @@ void *kthread_data(struct task_struct *task)
  */
 void *kthread_probe_data(struct task_struct *task)
 {
-	struct kthread *kthread = to_kthread(task);
+	struct kthread *kthread = __to_kthread(task);
 	void *data = NULL;
 
-	probe_kernel_read(&data, &kthread->data, sizeof(data));
+	if (kthread)
+		probe_kernel_read(&data, &kthread->data, sizeof(data));
 	return data;
 }
 
@@ -490,9 +510,9 @@ void kthread_set_per_cpu(struct task_struct *k, int cpu)
 	set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
 }
 
-bool kthread_is_per_cpu(struct task_struct *k)
+bool kthread_is_per_cpu(struct task_struct *p)
 {
-	struct kthread *kthread = to_kthread(k);
+	struct kthread *kthread = __to_kthread(p);
 	if (!kthread)
 		return false;
 
@@ -1272,11 +1292,9 @@ EXPORT_SYMBOL(kthread_destroy_worker);
  */
 void kthread_associate_blkcg(struct cgroup_subsys_state *css)
 {
-	struct kthread *kthread;
+	struct kthread *kthread = __to_kthread(current);
+
 
-	if (!(current->flags & PF_KTHREAD))
-		return;
-	kthread = to_kthread(current);
 	if (!kthread)
 		return;
 
@@ -1298,13 +1316,10 @@ EXPORT_SYMBOL(kthread_associate_blkcg);
  */
 struct cgroup_subsys_state *kthread_blkcg(void)
 {
-	struct kthread *kthread;
+	struct kthread *kthread = __to_kthread(current);
 
-	if (current->flags & PF_KTHREAD) {
-		kthread = to_kthread(current);
-		if (kthread)
-			return kthread->blkcg_css;
-	}
+	if (kthread)
+		return kthread->blkcg_css;
 	return NULL;
 }
 EXPORT_SYMBOL(kthread_blkcg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 74cb20f32f72..87d9fad9d01d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7301,7 +7301,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		return 0;
 
 	/* Disregard pcpu kthreads; they are where they need to be. */
-	if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+	if (kthread_is_per_cpu(p))
 		return 0;
 
 	if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {
