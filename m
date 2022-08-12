Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE85A590E0F
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 11:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbiHLJ33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 05:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbiHLJ31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 05:29:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD5BA99E3;
        Fri, 12 Aug 2022 02:29:23 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s11so603140edd.13;
        Fri, 12 Aug 2022 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=ksqCh+DwQ4OG+m1GBnggrJTevXMngJQF4xa8AJ59WN8=;
        b=N8i6upHOUpYcNxjfBYarPpRbrDy1t8waot7Izjm+AtwUJLXIuHs3TKINnvZqcyGIsB
         ThHIWuP9qGOSCvRi3dZNDcygJR3sDAa18A9FQKe9TWAMt2s3FZ8wRhBsakyaNe1uIp79
         stEd+SFKnGjC31d0fIycEswAHjeGQ4rK76g9vKlrdUB4nzQV2GNqFdNzl1IzX019tfx0
         ulMHZzGCHH3VLY1GRYAeNYYFc3CivhaQHUGwbGwMwYFPIc7b0PpB/ALaQ3SanQ0bDNAq
         qrCmbxo5/CrHFMVrXc3qYU8IQHe7z39HzArlrLT5gcie1si+IPOlbBOzWyycJ25knD3v
         Ez/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc;
        bh=ksqCh+DwQ4OG+m1GBnggrJTevXMngJQF4xa8AJ59WN8=;
        b=o5uUZ8cRJ8LdA764eskUUE0uteylkqs29fHr+Bs09RYqFn6+JIK936s+/D4e5pYSy5
         3Q6zvyuSOXRVCtF5oNgHVFX+ydSgURO5qm99loUhAZqjvWU3xL5BY2MoFrDzeQOhR3MO
         ut62uL2oC3/EHHXaefxdxqlxcBbxxqr87+LhlMbLJ+09qLLDb059g9LF1QURAo159juP
         EFd468ouMGRSXFHmDglLmHnERnOIyEesQXMksbtJXWB+3aZ/EDjm12xaHOyiAlmCttas
         TF4SJUa4o1bvzIqSD1gLjM7Q/f0yUrfy6hOIRMexCHbyd9C2OdOTbuxucr7mGOI23ZoE
         JKxw==
X-Gm-Message-State: ACgBeo01b2Ti1A4xtbYANUfNUgG1DMVbPmcTere9gBInu4azDS8T/JRp
        FbnTbh7lxI51cQ4eYwJ6nOE=
X-Google-Smtp-Source: AA6agR7W03sJtuHklxvfla84psKc/EBQSd9aaw0wUOy/Gz39ZdAU2eM7BtkbtcJPpLSLddh314qi9w==
X-Received: by 2002:a05:6402:369a:b0:43d:75c5:f16c with SMTP id ej26-20020a056402369a00b0043d75c5f16cmr2787684edb.57.1660296561651;
        Fri, 12 Aug 2022 02:29:21 -0700 (PDT)
Received: from gmail.com (84-236-113-143.pool.digikabel.hu. [84.236.113.143])
        by smtp.gmail.com with ESMTPSA id q3-20020a170906144300b007307c557e31sm589246ejc.106.2022.08.12.02.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 02:29:20 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Fri, 12 Aug 2022 11:29:18 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH v2] sched/all: Change all BUG_ON() instances in the scheduler
 to WARN_ON_ONCE()
Message-ID: <YvYdbn2GtTlCaand@gmail.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Aug 11, 2022 at 12:13 AM Ingo Molnar <mingo@kernel.org> wrote:
> >
> > By using a WARN_ON() we at least give the user a chance to report
> > any bugs triggered here - instead of getting silent hangs.
> >
> > None of these WARN_ON()s are supposed to trigger, ever - so we ignore
> > cases where a NULL check is done via a BUG_ON() and we let a NULL
> > pointer through after a WARN_ON().
> 
> May I suggest going one step further, and making these WARN_ON_ONCE() instead.

Ok, agreed.

> From personal experience, once some scheduler bug (or task struct 
> corruption) happens, ti often *keeps* happening, and the logs just fill 
> up with more and more data, to the point where you lose sight of the 
> original report (and the machine can even get unusable just from the 
> logging).
> 
> WARN_ON_ONCE() can help that situation.

Yeah, true.

> Now, obviously
> 
>  (a) WARN_ON_ONCE *can* also result in less information, and maybe there 
> are situations where having more - possibly different - cases of the same 
> thing triggering could be useful.

None of these warnings are supposed to happen absent serious random data 
corruption, ever™, so if against expectations they do happen once, 
somewhere, and its brevity makes it hard to figure out, we can still 
reconsider on a case by case basis & increase verbosity.

>  (b) WARN_ON_ONCE historically generated a bit bigger code than
> WARN_ON simply due to the extra "did this already trigger" check.
> 
> I *think* (b) is no longer true, and it's just a flag these days, but I 
> didn't actually check.

Yeah, so on architectures that implement a smart __WARN_FLAGS() primitive, 
such as x86, overhead is pretty good:

#define __WARN_FLAGS(flags)                                     \
do {                                                            \
        __auto_type __flags = BUGFLAG_WARNING|(flags);          \
        instrumentation_begin();                                \
        _BUG_FLAGS(ASM_UD2, __flags, ASM_REACHABLE);            \
        instrumentation_end();                                  \
} while (0)

For them the runtime overhead of a WARN_ON_ONCE() is basically just the 
check itself:

# no checks:

ffffffff810a3ae0 <check_preempt_curr>:
ffffffff810a3ae0:       48 8b 87 20 09 00 00    mov    0x920(%rdi),%rax
ffffffff810a3ae7:       48 8b 8e 90 02 00 00    mov    0x290(%rsi),%rcx
ffffffff810a3aee:       53                      push   %rbx
ffffffff810a3aef:       48 89 fb                mov    %rdi,%rbx
ffffffff810a3af2:       48 3b 88 90 02 00 00    cmp    0x290(%rax),%rcx

# Single-branch WARN_ON_ONCE():
#
#  void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
#  {
# +       WARN_ON_ONCE(!rq);
# +
#         if (p->sched_class == rq->curr->sched_class)
#                 rq->curr->sched_class->check_preempt_curr(rq, p, flags);
#         else if (sched_class_above(p->sched_class, rq->curr->sched_class))

ffffffff810a3ae0 <check_preempt_curr>:
ffffffff810a3ae0:       53                      push   %rbx
ffffffff810a3ae1:       48 89 fb                mov    %rdi,%rbx
ffffffff810a3ae4:  |    48 85 ff                test   %rdi,%rdi
ffffffff810a3ae7:  |    74 69                   je     ffffffff810a3b52 <check_preempt_curr+0x72>
ffffffff810a3ae9:       48 8b 83 20 09 00 00    mov    0x920(%rbx),%rax
ffffffff810a3af0:       48 8b 8e 90 02 00 00    mov    0x290(%rsi),%rcx
ffffffff810a3af7:       48 3b 88 90 02 00 00    cmp    0x290(%rax),%rcx
...
ffffffff810a3b50:       eb d1                   jmp    ffffffff810a3b23 <check_preempt_curr+0x43>    # tail-call
ffffffff810a3b52:  |    0f 0b                   ud2    

So it's a test instruction and an unlikely-forward-branch, plus a UD2 trap 
squeezed into the function epilogue, often hidden by alignment holes.

As lightweight as it gets, and no in-line penalty from being a 'once' 
warning.

> so it's not like there aren't potential downsides, but in general I think 
> the sanest and most natural thing is to have BUG_ON() translate to 
> WARN_ON_ONCE().
>
> For the "reboot-on-warn" people, it ends up being the same thing. And for 
> the rest of us, the "give me *one* warning" can end up making the 
> reporting a lot easier.

Agreed - updated v2 patch attached.

> Obviously, with the "this never actually happens", the whole "once or 
> many times" is kind of moot. But if it never happens at all, to the point 
> where it doesn't even add a chance of helping debugging, maybe the whole 
> test should be removed entirely...

Yeah.

Thanks,

	Ingo

========================================

From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 11 Aug 2022 08:54:52 +0200
Subject: [PATCH] sched/all: Change all BUG_ON() instances in the scheduler to WARN_ON_ONCE()

There's no good reason to crash a user's system with a BUG_ON(),
chances are high that they'll never even see the crash message on
Xorg, and it won't make it into the syslog either.

By using a WARN_ON_ONCE() we at least give the user a chance to report
any bugs triggered here - instead of getting silent hangs.

None of these WARN_ON_ONCE()s are supposed to trigger, ever - so we ignore
cases where a NULL check is done via a BUG_ON() and we let a NULL
pointer through after a WARN_ON_ONCE().

There's one exception: WARN_ON_ONCE() arguments with side-effects,
such as locking - in this case we use the return value of the
WARN_ON_ONCE(), such as in:

 -       BUG_ON(!lock_task_sighand(p, &flags));
 +       if (WARN_ON_ONCE(!lock_task_sighand(p, &flags)))
 +               return;

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/YvSsKcAXISmshtHo@gmail.com
---
 kernel/sched/autogroup.c |  3 ++-
 kernel/sched/core.c      |  2 +-
 kernel/sched/cpupri.c    |  2 +-
 kernel/sched/deadline.c  | 26 +++++++++++++-------------
 kernel/sched/fair.c      | 10 +++++-----
 kernel/sched/rt.c        |  2 +-
 kernel/sched/sched.h     |  6 +++---
 7 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
index 4ebaf97f7bd8..991fc9002535 100644
--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -161,7 +161,8 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 	struct task_struct *t;
 	unsigned long flags;
 
-	BUG_ON(!lock_task_sighand(p, &flags));
+	if (WARN_ON_ONCE(!lock_task_sighand(p, &flags)))
+		return;
 
 	prev = p->signal->autogroup;
 	if (prev == ag) {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee28253c9ac0..813687a5f5cf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2328,7 +2328,7 @@ static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 	rq = cpu_rq(new_cpu);
 
 	rq_lock(rq, rf);
-	BUG_ON(task_cpu(p) != new_cpu);
+	WARN_ON_ONCE(task_cpu(p) != new_cpu);
 	activate_task(rq, p, 0);
 	check_preempt_curr(rq, p, 0);
 
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index fa9ce9d83683..a286e726eb4b 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -147,7 +147,7 @@ int cpupri_find_fitness(struct cpupri *cp, struct task_struct *p,
 	int task_pri = convert_prio(p->prio);
 	int idx, cpu;
 
-	BUG_ON(task_pri >= CPUPRI_NR_PRIORITIES);
+	WARN_ON_ONCE(task_pri >= CPUPRI_NR_PRIORITIES);
 
 	for (idx = 0; idx < task_pri; idx++) {
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0ab79d819a0d..962b169b05cf 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -310,7 +310,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
 	struct rq *rq;
 
-	BUG_ON(p->dl.flags & SCHED_FLAG_SUGOV);
+	WARN_ON_ONCE(p->dl.flags & SCHED_FLAG_SUGOV);
 
 	if (task_on_rq_queued(p))
 		return;
@@ -607,7 +607,7 @@ static void enqueue_pushable_dl_task(struct rq *rq, struct task_struct *p)
 {
 	struct rb_node *leftmost;
 
-	BUG_ON(!RB_EMPTY_NODE(&p->pushable_dl_tasks));
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&p->pushable_dl_tasks));
 
 	leftmost = rb_add_cached(&p->pushable_dl_tasks,
 				 &rq->dl.pushable_dl_tasks_root,
@@ -684,7 +684,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			 * Failed to find any suitable CPU.
 			 * The task will never come back!
 			 */
-			BUG_ON(dl_bandwidth_enabled());
+			WARN_ON_ONCE(dl_bandwidth_enabled());
 
 			/*
 			 * If admission control is disabled we
@@ -830,7 +830,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	BUG_ON(pi_of(dl_se)->dl_runtime <= 0);
+	WARN_ON_ONCE(pi_of(dl_se)->dl_runtime <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
@@ -1616,7 +1616,7 @@ static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 
-	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&dl_se->rb_node));
 
 	rb_add_cached(&dl_se->rb_node, &dl_rq->root, __dl_less);
 
@@ -1640,7 +1640,7 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
-	BUG_ON(on_dl_rq(dl_se));
+	WARN_ON_ONCE(on_dl_rq(dl_se));
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -2017,7 +2017,7 @@ static struct task_struct *pick_task_dl(struct rq *rq)
 		return NULL;
 
 	dl_se = pick_next_dl_entity(dl_rq);
-	BUG_ON(!dl_se);
+	WARN_ON_ONCE(!dl_se);
 	p = dl_task_of(dl_se);
 
 	return p;
@@ -2277,12 +2277,12 @@ static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
 
 	p = __node_2_pdl(rb_first_cached(&rq->dl.pushable_dl_tasks_root));
 
-	BUG_ON(rq->cpu != task_cpu(p));
-	BUG_ON(task_current(rq, p));
-	BUG_ON(p->nr_cpus_allowed <= 1);
+	WARN_ON_ONCE(rq->cpu != task_cpu(p));
+	WARN_ON_ONCE(task_current(rq, p));
+	WARN_ON_ONCE(p->nr_cpus_allowed <= 1);
 
-	BUG_ON(!task_on_rq_queued(p));
-	BUG_ON(!dl_task(p));
+	WARN_ON_ONCE(!task_on_rq_queued(p));
+	WARN_ON_ONCE(!dl_task(p));
 
 	return p;
 }
@@ -2492,7 +2492,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	struct root_domain *src_rd;
 	struct rq *rq;
 
-	BUG_ON(!dl_task(p));
+	WARN_ON_ONCE(!dl_task(p));
 
 	rq = task_rq(p);
 	src_rd = rq->rd;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 914096c5b1ae..28f10dccd194 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2600,7 +2600,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	if (!join)
 		return;
 
-	BUG_ON(irqs_disabled());
+	WARN_ON_ONCE(irqs_disabled());
 	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
@@ -7279,7 +7279,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	find_matching_se(&se, &pse);
-	BUG_ON(!pse);
+	WARN_ON_ONCE(!pse);
 
 	cse_is_idle = se_is_idle(se);
 	pse_is_idle = se_is_idle(pse);
@@ -8159,7 +8159,7 @@ static void attach_task(struct rq *rq, struct task_struct *p)
 {
 	lockdep_assert_rq_held(rq);
 
-	BUG_ON(task_rq(p) != rq);
+	WARN_ON_ONCE(task_rq(p) != rq);
 	activate_task(rq, p, ENQUEUE_NOCLOCK);
 	check_preempt_curr(rq, p, 0);
 }
@@ -10134,7 +10134,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		goto out_balanced;
 	}
 
-	BUG_ON(busiest == env.dst_rq);
+	WARN_ON_ONCE(busiest == env.dst_rq);
 
 	schedstat_add(sd->lb_imbalance[idle], env.imbalance);
 
@@ -10430,7 +10430,7 @@ static int active_load_balance_cpu_stop(void *data)
 	 * we need to fix it. Originally reported by
 	 * Bjorn Helgaas on a 128-CPU setup.
 	 */
-	BUG_ON(busiest_rq == target_rq);
+	WARN_ON_ONCE(busiest_rq == target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 55f39c8f4203..2936fe55cef7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -843,7 +843,7 @@ static void __disable_runtime(struct rq *rq)
 		 * We cannot be left wanting - that would mean some runtime
 		 * leaked out of the system.
 		 */
-		BUG_ON(want);
+		WARN_ON_ONCE(want);
 balanced:
 		/*
 		 * Disable all the borrow logic by pretending we have inf
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e26688d387ae..7a44dceeb50a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2709,8 +2709,8 @@ static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
-	BUG_ON(!irqs_disabled());
-	BUG_ON(rq1 != rq2);
+	WARN_ON_ONCE(!irqs_disabled());
+	WARN_ON_ONCE(rq1 != rq2);
 	raw_spin_rq_lock(rq1);
 	__acquire(rq2->lock);	/* Fake it out ;) */
 	double_rq_clock_clear_update(rq1, rq2);
@@ -2726,7 +2726,7 @@ static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 	__releases(rq1->lock)
 	__releases(rq2->lock)
 {
-	BUG_ON(rq1 != rq2);
+	WARN_ON_ONCE(rq1 != rq2);
 	raw_spin_rq_unlock(rq1);
 	__release(rq2->lock);
 }
