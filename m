Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2967558244
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiFWRN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiFWRLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:11:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDEF26E;
        Thu, 23 Jun 2022 09:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D64CCE25CA;
        Thu, 23 Jun 2022 16:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D36DC3411B;
        Thu, 23 Jun 2022 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003128;
        bh=vUxtEGawyv3TEXubFV5MwuZAHJF1ujvfsN/irCIm6us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGRUa3vToMqprlra9fjsB/yW0/8zVrtxEeed5dOdQTafeD1/ZqtK1FJv26mLLpGQO
         w/xxKsxQQ9ZruRLRVvi7OJN/im6JI2O9taufWfYlPOCevy4BZGIcDi4A2ssCTBfWPM
         K/aq3Xn0tYfrFCZCPyib+Dg1tuegVj/N6KOwBAho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 140/264] workqueue: make workqueue available early during boot
Date:   Thu, 23 Jun 2022 18:42:13 +0200
Message-Id: <20220623164348.027555223@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 3347fa0928210d96aaa2bd6cd5a8391d5e630873 upstream.

Workqueue is currently initialized in an early init call; however,
there are cases where early boot code has to be split and reordered to
come after workqueue initialization or the same code path which makes
use of workqueues is used both before workqueue initailization and
after.  The latter cases have to gate workqueue usages with
keventd_up() tests, which is nasty and easy to get wrong.

Workqueue usages have become widespread and it'd be a lot more
convenient if it can be used very early from boot.  This patch splits
workqueue initialization into two steps.  workqueue_init_early() which
sets up the basic data structures so that workqueues can be created
and work items queued, and workqueue_init() which actually brings up
workqueues online and starts executing queued work items.  The former
step can be done very early during boot once memory allocation,
cpumasks and idr are initialized.  The latter right after kthreads
become available.

This allows work item queueing and canceling from very early boot
which is what most of these use cases want.

* As systemd_wq being initialized doesn't indicate that workqueue is
  fully online anymore, update keventd_up() to test wq_online instead.
  The follow-up patches will get rid of all its usages and the
  function itself.

* Flushing doesn't make sense before workqueue is fully initialized.
  The flush functions trigger WARN and return immediately before fully
  online.

* Work items are never in-flight before fully online.  Canceling can
  always succeed by skipping the flush step.

* Some code paths can no longer assume to be called with irq enabled
  as irq is disabled during early boot.  Use irqsave/restore
  operations instead.

v2: Watchdog init, which requires timer to be running, moved from
    workqueue_init_early() to workqueue_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/CA+55aFx0vPuMuxn00rBSM192n-Du5uxy+4AvKa0SBSOVJeuCGg@mail.gmail.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/workqueue.h |    7 +++-
 init/main.c               |   10 ++++++
 kernel/workqueue.c        |   76 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 76 insertions(+), 17 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -359,6 +359,8 @@ extern struct workqueue_struct *system_f
 extern struct workqueue_struct *system_power_efficient_wq;
 extern struct workqueue_struct *system_freezable_power_efficient_wq;
 
+extern bool wq_online;
+
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	struct lock_class_key *key, const char *lock_name, ...) __printf(1, 6);
@@ -598,7 +600,7 @@ static inline bool schedule_delayed_work
  */
 static inline bool keventd_up(void)
 {
-	return system_wq != NULL;
+	return wq_online;
 }
 
 #ifndef CONFIG_SMP
@@ -635,4 +637,7 @@ int workqueue_online_cpu(unsigned int cp
 int workqueue_offline_cpu(unsigned int cpu);
 #endif
 
+int __init workqueue_init_early(void);
+int __init workqueue_init(void);
+
 #endif
--- a/init/main.c
+++ b/init/main.c
@@ -554,6 +554,14 @@ asmlinkage __visible void __init start_k
 		 "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
 	idr_init_cache();
+
+	/*
+	 * Allow workqueue creation and work item queueing/cancelling
+	 * early.  Work item execution depends on kthreads and starts after
+	 * workqueue_init().
+	 */
+	workqueue_init_early();
+
 	rcu_init();
 
 	/* trace_printk() and trace points may be used after this */
@@ -1026,6 +1034,8 @@ static noinline void __init kernel_init_
 
 	smp_prepare_cpus(setup_max_cpus);
 
+	workqueue_init();
+
 	do_pre_smp_initcalls();
 	lockup_detector_init();
 
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -292,6 +292,8 @@ module_param_named(disable_numa, wq_disa
 static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
 module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 
+bool wq_online;				/* can kworkers be created yet? */
+
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 
 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug exclusion */
@@ -2588,6 +2590,9 @@ void flush_workqueue(struct workqueue_st
 	};
 	int next_color;
 
+	if (WARN_ON(!wq_online))
+		return;
+
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
 
@@ -2848,6 +2853,9 @@ bool flush_work(struct work_struct *work
 {
 	struct wq_barrier barr;
 
+	if (WARN_ON(!wq_online))
+		return false;
+
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
@@ -2918,7 +2926,13 @@ static bool __cancel_work_timer(struct w
 	mark_work_canceling(work);
 	local_irq_restore(flags);
 
-	flush_work(work);
+	/*
+	 * This allows canceling during early boot.  We know that @work
+	 * isn't executing.
+	 */
+	if (wq_online)
+		flush_work(work);
+
 	clear_work_data(work);
 
 	/*
@@ -3368,7 +3382,7 @@ static struct worker_pool *get_unbound_p
 		goto fail;
 
 	/* create and start the initial worker */
-	if (!create_worker(pool))
+	if (wq_online && !create_worker(pool))
 		goto fail;
 
 	/* install */
@@ -3439,6 +3453,7 @@ static void pwq_adjust_max_active(struct
 {
 	struct workqueue_struct *wq = pwq->wq;
 	bool freezable = wq->flags & WQ_FREEZABLE;
+	unsigned long flags;
 
 	/* for @wq->saved_max_active */
 	lockdep_assert_held(&wq->mutex);
@@ -3447,7 +3462,8 @@ static void pwq_adjust_max_active(struct
 	if (!freezable && pwq->max_active == wq->saved_max_active)
 		return;
 
-	spin_lock_irq(&pwq->pool->lock);
+	/* this function can be called during early boot w/ irq disabled */
+	spin_lock_irqsave(&pwq->pool->lock, flags);
 
 	/*
 	 * During [un]freezing, the caller is responsible for ensuring that
@@ -3477,7 +3493,7 @@ static void pwq_adjust_max_active(struct
 		pwq->max_active = 0;
 	}
 
-	spin_unlock_irq(&pwq->pool->lock);
+	spin_unlock_irqrestore(&pwq->pool->lock, flags);
 }
 
 /* initialize newly alloced @pwq which is associated with @wq and @pool */
@@ -5550,7 +5566,17 @@ static void __init wq_numa_init(void)
 	wq_numa_enabled = true;
 }
 
-static int __init init_workqueues(void)
+/**
+ * workqueue_init_early - early init for workqueue subsystem
+ *
+ * This is the first half of two-staged workqueue subsystem initialization
+ * and invoked as soon as the bare basics - memory allocation, cpumasks and
+ * idr are up.  It sets up all the data structures and system workqueues
+ * and allows early boot code to create workqueues and queue/cancel work
+ * items.  Actual work item execution starts only after kthreads can be
+ * created and scheduled right before early initcalls.
+ */
+int __init workqueue_init_early(void)
 {
 	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
 	int i, cpu;
@@ -5583,16 +5609,6 @@ static int __init init_workqueues(void)
 		}
 	}
 
-	/* create the initial worker */
-	for_each_online_cpu(cpu) {
-		struct worker_pool *pool;
-
-		for_each_cpu_worker_pool(pool, cpu) {
-			pool->flags &= ~POOL_DISASSOCIATED;
-			BUG_ON(!create_worker(pool));
-		}
-	}
-
 	/* create default unbound and ordered wq attrs */
 	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
 		struct workqueue_attrs *attrs;
@@ -5629,8 +5645,36 @@ static int __init init_workqueues(void)
 	       !system_power_efficient_wq ||
 	       !system_freezable_power_efficient_wq);
 
+	return 0;
+}
+
+/**
+ * workqueue_init - bring workqueue subsystem fully online
+ *
+ * This is the latter half of two-staged workqueue subsystem initialization
+ * and invoked as soon as kthreads can be created and scheduled.
+ * Workqueues have been created and work items queued on them, but there
+ * are no kworkers executing the work items yet.  Populate the worker pools
+ * with the initial workers and enable future kworker creations.
+ */
+int __init workqueue_init(void)
+{
+	struct worker_pool *pool;
+	int cpu, bkt;
+
+	/* create the initial workers */
+	for_each_online_cpu(cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
+			pool->flags &= ~POOL_DISASSOCIATED;
+			BUG_ON(!create_worker(pool));
+		}
+	}
+
+	hash_for_each(unbound_pool_hash, bkt, pool, hash_node)
+		BUG_ON(!create_worker(pool));
+
+	wq_online = true;
 	wq_watchdog_init();
 
 	return 0;
 }
-early_initcall(init_workqueues);


