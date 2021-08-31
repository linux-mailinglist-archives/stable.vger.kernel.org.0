Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58723FC310
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 09:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbhHaHC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 03:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhHaHC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 03:02:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E98C061575
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 00:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FClrlUF0Hb78xPiG0FP1E09AZCzNPt0C4Jjigzgw+aw=; b=JITqTsKr2olMYKKZcTMOjMJmzo
        CxcCqdloaYtRQDlLvs3URl/DyD1WkNxHNGHJ6QLYs2SYXnIGAJJGUiVa3jwNf8w/A7J5t2UGZo8ru
        4fBx17y8EvKr2TR4d39hkitudkmIKUGzyFn5Jthccjh2ZmBw06YUdVzAdJci05kXYWJIxz4luyyrp
        xkaoYeZnCwvUUVppZRW5zLjLpXfNxep0/V+dNItB9ue/LnyYWIkbF0XiJnUe6ZHogGQ+qirZmB1qK
        FxMPq4gKcR6TNDJAPwkeOyvnKr4tC9KrvBhzRft5tBQOiPel64D5ZUzzUdnNYsPbfNWaINAAiIVUO
        Zm9mZlhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKxlO-000wJS-Sm; Tue, 31 Aug 2021 07:01:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0941D3001F6;
        Tue, 31 Aug 2021 09:00:53 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DB6242028F032; Tue, 31 Aug 2021 09:00:52 +0200 (CEST)
Date:   Tue, 31 Aug 2021 09:00:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Patrick Schaaf <bof@bof.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        anubis@igorloncarevic.com
Subject: Re: stable 5.4.135 REGRESSION / once-a-day WARNING: at
 kthread_is_per_cpu+0x1c/0x20
Message-ID: <YS3TpF8B5TA2mGFr@hirez.programming.kicks-ass.net>
References: <61018d93.xsvXcO161PFLQFCX%bof@bof.de>
 <YQGXyiMb1IntqacG@kroah.com>
 <CAJ26g5S2tbDhRbWkcgRzAu0eX=FNk00P8srboOSn=jYp4saALA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ26g5S2tbDhRbWkcgRzAu0eX=FNk00P8srboOSn=jYp4saALA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 31, 2021 at 06:46:40AM +0200, Patrick Schaaf wrote:
> Looking into this again.
> 
> Unfortunately, couldn't see how I would do bisection on the issue, as
> it appears with that 5.4.118 commit implicated by the call stack,and
> with tha tremoved,is obviously gone(that I tested, 5.4.135 with
> b56ad4febe67b8c0647c0a3e427e935a76dedb59 reverted runs smoothly for
> me, while the original 5.4.135 with that 5.4.118 time commit in, now
> on a dozen machines, throws the WARNING.
> 
> I got email on the side of someone (Igor, on Cc) who sees the same
> with DELL servers, a newer 5.10 kernel, for him running IPVS + he sees
> actual operational impact there.
> 
> I just had a look at Linus mainlinetree, and see there is this
> followup / further fix from Peter Zijlstra,
> https://github.com/torvalds/linux/commit/3a7956e25e1d7b3c148569e78895e1f3178122a9
> ; now I'm much too incompetent to try and backport that, as it looks
> more involved, but I imagine such a backport would be needed to fix
> the WARNING (or IPVS breakage of Igor) we see.

3a7956e25e1d ("kthread: Fix PF_KTHREAD vs to_kthread() race") munged
into 5.4.135

Never even seen a compiler, please tests.

---
 kernel/kthread.c    | 43 +++++++++++++++++++++++++++++--------------
 kernel/sched/fair.c |  2 +-
 2 files changed, 30 insertions(+), 15 deletions(-)

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
+	struct kthread *kthread = __to_kthread(current)
 
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
