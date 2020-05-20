Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF651DB624
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgETOWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:22:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60916 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbgETOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:21 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-000353-Ed; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DOY-Ui; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 20 May 2020 15:13:37 +0100
Message-ID: <lsq.1589984008.794612154@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/99] padata: Replace delayed timer with immediate
 workqueue in padata_reorder
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 6fc4dbcf0276279d488c5fbbfabe94734134f4fa upstream.

The function padata_reorder will use a timer when it cannot progress
while completed jobs are outstanding (pd->reorder_objects > 0).  This
is suboptimal as if we do end up using the timer then it would have
introduced a gratuitous delay of one second.

In fact we can easily distinguish between whether completed jobs
are outstanding and whether we can make progress.  All we have to
do is look at the next pqueue list.

This patch does that by replacing pd->processed with pd->cpu so
that the next pqueue is more accessible.

A work queue is used instead of the original try_again to avoid
hogging the CPU.

Note that we don't bother removing the work queue in
padata_flush_queues because the whole premise is broken.  You
cannot flush async crypto requests so it makes no sense to even
try.  A subsequent patch will fix it by replacing it with a ref
counting scheme.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[bwh: Backported to 3.16:
 - Deleted code used the old timer API here
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/padata.h | 13 ++----
 kernel/padata.c        | 97 ++++++++----------------------------------
 2 files changed, 22 insertions(+), 88 deletions(-)

--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -24,7 +24,6 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/timer.h>
 #include <linux/notifier.h>
 #include <linux/kobject.h>
 
@@ -85,18 +84,14 @@ struct padata_serial_queue {
  * @serial: List to wait for serialization after reordering.
  * @pwork: work struct for parallelization.
  * @swork: work struct for serialization.
- * @pd: Backpointer to the internal control structure.
  * @work: work struct for parallelization.
- * @reorder_work: work struct for reordering.
  * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
  */
 struct padata_parallel_queue {
        struct padata_list    parallel;
        struct padata_list    reorder;
-       struct parallel_data *pd;
        struct work_struct    work;
-       struct work_struct    reorder_work;
        atomic_t              num_obj;
        int                   cpu_index;
 };
@@ -122,10 +117,10 @@ struct padata_cpumask {
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
+ * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
+ * @reorder_work: work struct for reordering.
  * @lock: Reorder lock.
- * @processed: Number of already processed objects.
- * @timer: Reorder timer.
  */
 struct parallel_data {
 	struct padata_instance		*pinst;
@@ -134,10 +129,10 @@ struct parallel_data {
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
 	atomic_t			seq_nr;
+	int				cpu;
 	struct padata_cpumask		cpumask;
+	struct work_struct		reorder_work;
 	spinlock_t                      lock ____cacheline_aligned;
-	unsigned int			processed;
-	struct timer_list		timer;
 };
 
 /**
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -163,23 +163,12 @@ EXPORT_SYMBOL(padata_do_parallel);
  */
 static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
-	int cpu, num_cpus;
-	unsigned int next_nr, next_index;
 	struct padata_parallel_queue *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
+	int cpu = pd->cpu;
 
-	num_cpus = cpumask_weight(pd->cpumask.pcpu);
-
-	/*
-	 * Calculate the percpu reorder queue and the sequence
-	 * number of the next object.
-	 */
-	next_nr = pd->processed;
-	next_index = next_nr % num_cpus;
-	cpu = padata_index_to_cpu(pd, next_index);
 	next_queue = per_cpu_ptr(pd->pqueue, cpu);
-
 	reorder = &next_queue->reorder;
 
 	spin_lock(&reorder->lock);
@@ -190,7 +179,8 @@ static struct padata_priv *padata_get_ne
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
 
-		pd->processed++;
+		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
+					    false);
 
 		spin_unlock(&reorder->lock);
 		goto out;
@@ -213,6 +203,7 @@ static void padata_reorder(struct parall
 	struct padata_priv *padata;
 	struct padata_serial_queue *squeue;
 	struct padata_instance *pinst = pd->pinst;
+	struct padata_parallel_queue *next_queue;
 
 	/*
 	 * We need to ensure that only one cpu can work on dequeueing of
@@ -244,7 +235,6 @@ static void padata_reorder(struct parall
 		 * so exit immediately.
 		 */
 		if (PTR_ERR(padata) == -ENODATA) {
-			del_timer(&pd->timer);
 			spin_unlock_bh(&pd->lock);
 			return;
 		}
@@ -263,70 +253,29 @@ static void padata_reorder(struct parall
 
 	/*
 	 * The next object that needs serialization might have arrived to
-	 * the reorder queues in the meantime, we will be called again
-	 * from the timer function if no one else cares for it.
+	 * the reorder queues in the meantime.
 	 *
-	 * Ensure reorder_objects is read after pd->lock is dropped so we see
-	 * an increment from another task in padata_do_serial.  Pairs with
+	 * Ensure reorder queue is read after pd->lock is dropped so we see
+	 * new objects from another task in padata_do_serial.  Pairs with
 	 * smp_mb__after_atomic in padata_do_serial.
 	 */
 	smp_mb();
-	if (atomic_read(&pd->reorder_objects)
-			&& !(pinst->flags & PADATA_RESET))
-		mod_timer(&pd->timer, jiffies + HZ);
-	else
-		del_timer(&pd->timer);
 
-	return;
+	next_queue = per_cpu_ptr(pd->pqueue, pd->cpu);
+	if (!list_empty(&next_queue->reorder.list))
+		queue_work(pinst->wq, &pd->reorder_work);
 }
 
 static void invoke_padata_reorder(struct work_struct *work)
 {
-	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
 
 	local_bh_disable();
-	pqueue = container_of(work, struct padata_parallel_queue, reorder_work);
-	pd = pqueue->pd;
+	pd = container_of(work, struct parallel_data, reorder_work);
 	padata_reorder(pd);
 	local_bh_enable();
 }
 
-static void padata_reorder_timer(unsigned long arg)
-{
-	struct parallel_data *pd = (struct parallel_data *)arg;
-	unsigned int weight;
-	int target_cpu, cpu;
-
-	cpu = get_cpu();
-
-	/* We don't lock pd here to not interfere with parallel processing
-	 * padata_reorder() calls on other CPUs. We just need any CPU out of
-	 * the cpumask.pcpu set. It would be nice if it's the right one but
-	 * it doesn't matter if we're off to the next one by using an outdated
-	 * pd->processed value.
-	 */
-	weight = cpumask_weight(pd->cpumask.pcpu);
-	target_cpu = padata_index_to_cpu(pd, pd->processed % weight);
-
-	/* ensure to call the reorder callback on the correct CPU */
-	if (cpu != target_cpu) {
-		struct padata_parallel_queue *pqueue;
-		struct padata_instance *pinst;
-
-		/* The timer function is serialized wrt itself -- no locking
-		 * needed.
-		 */
-		pinst = pd->pinst;
-		pqueue = per_cpu_ptr(pd->pqueue, target_cpu);
-		queue_work_on(target_cpu, pinst->wq, &pqueue->reorder_work);
-	} else {
-		padata_reorder(pd);
-	}
-
-	put_cpu();
-}
-
 static void padata_serial_worker(struct work_struct *serial_work)
 {
 	struct padata_serial_queue *squeue;
@@ -374,9 +323,8 @@ void padata_do_serial(struct padata_priv
 
 	cpu = get_cpu();
 
-	/* We need to run on the same CPU padata_do_parallel(.., padata, ..)
-	 * was called on -- or, at least, enqueue the padata object into the
-	 * correct per-cpu queue.
+	/* We need to enqueue the padata object into the correct
+	 * per-cpu queue.
 	 */
 	if (cpu != padata->cpu) {
 		reorder_via_wq = 1;
@@ -386,12 +334,12 @@ void padata_do_serial(struct padata_priv
 	pqueue = per_cpu_ptr(pd->pqueue, cpu);
 
 	spin_lock(&pqueue->reorder.lock);
-	atomic_inc(&pd->reorder_objects);
 	list_add_tail(&padata->list, &pqueue->reorder.list);
+	atomic_inc(&pd->reorder_objects);
 	spin_unlock(&pqueue->reorder.lock);
 
 	/*
-	 * Ensure the atomic_inc of reorder_objects above is ordered correctly
+	 * Ensure the addition to the reorder list is ordered correctly
 	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
 	 * in padata_reorder.
 	 */
@@ -399,13 +347,7 @@ void padata_do_serial(struct padata_priv
 
 	put_cpu();
 
-	/* If we're running on the wrong CPU, call padata_reorder() via a
-	 * kernel worker.
-	 */
-	if (reorder_via_wq)
-		queue_work_on(cpu, pd->pinst->wq, &pqueue->reorder_work);
-	else
-		padata_reorder(pd);
+	padata_reorder(pd);
 }
 EXPORT_SYMBOL(padata_do_serial);
 
@@ -455,14 +397,12 @@ static void padata_init_pqueues(struct p
 	cpu_index = 0;
 	for_each_cpu(cpu, pd->cpumask.pcpu) {
 		pqueue = per_cpu_ptr(pd->pqueue, cpu);
-		pqueue->pd = pd;
 		pqueue->cpu_index = cpu_index;
 		cpu_index++;
 
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
-		INIT_WORK(&pqueue->reorder_work, invoke_padata_reorder);
 		atomic_set(&pqueue->num_obj, 0);
 	}
 }
@@ -490,12 +430,13 @@ static struct parallel_data *padata_allo
 
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
-	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 0);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
+	pd->cpu = cpumask_first(pcpumask);
+	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
 
@@ -530,8 +471,6 @@ static void padata_flush_queues(struct p
 		flush_work(&pqueue->work);
 	}
 
-	del_timer_sync(&pd->timer);
-
 	if (atomic_read(&pd->reorder_objects))
 		padata_reorder(pd);
 

