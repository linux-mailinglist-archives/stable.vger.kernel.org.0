Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907083FFB79
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 10:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348115AbhICIEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 04:04:08 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:35666 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348097AbhICIDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 04:03:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id 151A181129
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 10:02:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630656140; bh=7sxlm7nJbtlV7Nt4e6oXIOnl/RObgDVNSgWjfz5AQq0=;
        h=From:Date:Subject:To;
        b=vel3tP+rev6vV5yk4OQVIqiNTJU1hIkWx1F4btHI0YXJJY03nLOmskQDaq2o7Zoej
         0qChWQWtjbGtDltCTYZLzDA/CGYRGfWoqJxQxeflPwD2L2Krr3lbnimbnDx/Xf5guB
         LMXz2pwNYn8Vapo3C2UtLegc9DzryfSOBi/897YM=
Received: from mail-lj1-f182.google.com (unknown [162.158.183.104])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id 9D3948106F
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 10:02:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630656139; bh=7sxlm7nJbtlV7Nt4e6oXIOnl/RObgDVNSgWjfz5AQq0=;
        h=From:Date:Subject:To;
        b=t21DfmiAq/wlRHuGx0Ai0CHI5SaKK6uPq4dYJFpOY0oj5KUMDp6vNI75Tkg1Pg3si
         AOZYL0Br9mGXiYY8GBFXmuTEdNN2sXv/pkmoHBcdqE7NqsE3TknVl845xc2m9WWzDT
         hSWtJi1oQiisg3KC9GenKUkfH2vc2j1K+7sSVk5g=
Received: by mail-lj1-f182.google.com with SMTP id q21so8304929ljj.6
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 01:02:19 -0700 (PDT)
X-Gm-Message-State: AOAM53223mMEkt9NMriURjnBtqZncxkE0irV1t9f3ljRMRL71J7MByMp
        aHpx8yYwYsfQY5+5+cqudXjJ11lA3WlKqfihuQw=
X-Google-Smtp-Source: ABdhPJxmSiLEOLN78tct60+IXIHEqkW9q4lhD1rEAEBMnZD54LXGpnlv/OVTj74bqSNe3yEwklLzyfzaTBxH5eZFc2Q=
X-Received: by 2002:a2e:960c:: with SMTP id v12mr1926576ljh.300.1630656139111;
 Fri, 03 Sep 2021 01:02:19 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Schaaf <bof@bof.de>
Date:   Fri, 3 Sep 2021 10:02:02 +0200
X-Gmail-Original-Message-ID: <CAJ26g5THH5uZW2D86H64TXBE-OhdSLva8vGwF7Sdak1_R6PmRw@mail.gmail.com>
Message-ID: <CAJ26g5THH5uZW2D86H64TXBE-OhdSLva8vGwF7Sdak1_R6PmRw@mail.gmail.com>
Subject: [PATCH] for 5.4 : kthread: Fix PF_KTHREAD vs to_kthread() race
To:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -76,6 +76,25 @@ static inline struct kthread *to_kthread(struct
task_struct *k)
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
+       void *kthread = (__force void *)p->set_child_tid;
+       if (kthread && !(p->flags & PF_KTHREAD))
+               kthread = NULL;
+       return kthread;
+}
+
 void free_kthread_struct(struct task_struct *k)
 {
        struct kthread *kthread;
@@ -176,10 +195,11 @@ void *kthread_data(struct task_struct *task)
  */
 void *kthread_probe_data(struct task_struct *task)
 {
-       struct kthread *kthread = to_kthread(task);
+       struct kthread *kthread = __to_kthread(task);
        void *data = NULL;

-       probe_kernel_read(&data, &kthread->data, sizeof(data));
+       if (kthread)
+               probe_kernel_read(&data, &kthread->data, sizeof(data));
        return data;
 }

@@ -490,9 +510,9 @@ void kthread_set_per_cpu(struct task_struct *k, int cpu)
        set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
 }

-bool kthread_is_per_cpu(struct task_struct *k)
+bool kthread_is_per_cpu(struct task_struct *p)
 {
-       struct kthread *kthread = to_kthread(k);
+       struct kthread *kthread = __to_kthread(p);
        if (!kthread)
                return false;

@@ -1272,11 +1292,9 @@ EXPORT_SYMBOL(kthread_destroy_worker);
  */
 void kthread_associate_blkcg(struct cgroup_subsys_state *css)
 {
-       struct kthread *kthread;
+       struct kthread *kthread = __to_kthread(current);
+

-       if (!(current->flags & PF_KTHREAD))
-               return;
-       kthread = to_kthread(current);
        if (!kthread)
                return;

@@ -1298,13 +1316,10 @@ EXPORT_SYMBOL(kthread_associate_blkcg);
  */
 struct cgroup_subsys_state *kthread_blkcg(void)
 {
-       struct kthread *kthread;
+       struct kthread *kthread = __to_kthread(current);

-       if (current->flags & PF_KTHREAD) {
-               kthread = to_kthread(current);
-               if (kthread)
-                       return kthread->blkcg_css;
-       }
+       if (kthread)
+               return kthread->blkcg_css;
        return NULL;
 }
 EXPORT_SYMBOL(kthread_blkcg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 74cb20f32f72..87d9fad9d01d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7301,7 +7301,7 @@ int can_migrate_task(struct task_struct *p,
struct lb_env *env)
                return 0;

        /* Disregard pcpu kthreads; they are where they need to be. */
-       if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+       if (kthread_is_per_cpu(p))
                return 0;

        if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {
