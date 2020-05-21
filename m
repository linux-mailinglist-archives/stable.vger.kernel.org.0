Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF161DD8B8
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgEUUtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:49:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730104AbgEUUtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:49:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKlpJE118259;
        Thu, 21 May 2020 20:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=5RF03mLVfv2mJ4q7F1rX4ONplJwlTy9QEH6IhworlEA=;
 b=p3wf8Pt8hp7ruhAl4oQFe4jIjwkFr+7SxhsiP5pMgkj95BVD/2FPmaXJURTW/h2mI1M1
 uE5veQKTfNFceAEjZW8KeHxBDd9AjFw1paN3tIsEcRFOoA8NvjuKeCvqjPiH4gbxsf/7
 WBJrWVzUAhz6hshTTU7r85zU2bCtzqalSR7ZdvYYsufYj9hS3GMwyi2wWFHys/Gflb/h
 fPq1Gh9LPfMqIj60GUicmdItnk7/VbKRSa6KJSaQwHAoFhrXCoJ5vywRO4+MbM+wCznN
 pLiSUjpXUva6VOFVufPDCca+JB2vGcUAdcfPJAW2nsirTfgr+riIQS5Y5i1FVIB39RPc 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284map6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 20:48:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LKhGJq073002;
        Thu, 21 May 2020 20:48:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3capsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 20:48:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04LKmrmE017531;
        Thu, 21 May 2020 20:48:53 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 13:48:52 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [stable-4.9 2/4] padata: Replace delayed timer with immediate workqueue in padata_reorder
Date:   Thu, 21 May 2020 16:48:45 -0400
Message-Id: <20200521204847.1953064-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521204847.1953064-1-daniel.m.jordan@oracle.com>
References: <20200521204847.1953064-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6fc4dbcf0276279d488c5fbbfabe94734134f4fa ]

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
[dj: - adjust context
     - corrected setup_timer -> timer_setup to delete hunk
     - skip padata_flush_queues() hunk, function already removed
       in 4.9]
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/padata.h | 13 ++----
 kernel/padata.c        | 95 ++++++++----------------------------------
 2 files changed, 22 insertions(+), 86 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 86c885f90878..3afa17ed59da 100644
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
diff --git a/kernel/padata.c b/kernel/padata.c
index 52a1d3fd13b5..0b9c39730d6d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -166,23 +166,12 @@ EXPORT_SYMBOL(padata_do_parallel);
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
@@ -193,7 +182,8 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
 
-		pd->processed++;
+		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
+					    false);
 
 		spin_unlock(&reorder->lock);
 		goto out;
@@ -216,6 +206,7 @@ static void padata_reorder(struct parallel_data *pd)
 	struct padata_priv *padata;
 	struct padata_serial_queue *squeue;
 	struct padata_instance *pinst = pd->pinst;
+	struct padata_parallel_queue *next_queue;
 
 	/*
 	 * We need to ensure that only one cpu can work on dequeueing of
@@ -247,7 +238,6 @@ static void padata_reorder(struct parallel_data *pd)
 		 * so exit immediately.
 		 */
 		if (PTR_ERR(padata) == -ENODATA) {
-			del_timer(&pd->timer);
 			spin_unlock_bh(&pd->lock);
 			return;
 		}
@@ -266,70 +256,29 @@ static void padata_reorder(struct parallel_data *pd)
 
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
@@ -383,9 +332,8 @@ void padata_do_serial(struct padata_priv *padata)
 
 	cpu = get_cpu();
 
-	/* We need to run on the same CPU padata_do_parallel(.., padata, ..)
-	 * was called on -- or, at least, enqueue the padata object into the
-	 * correct per-cpu queue.
+	/* We need to enqueue the padata object into the correct
+	 * per-cpu queue.
 	 */
 	if (cpu != padata->cpu) {
 		reorder_via_wq = 1;
@@ -395,12 +343,12 @@ void padata_do_serial(struct padata_priv *padata)
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
@@ -408,13 +356,7 @@ void padata_do_serial(struct padata_priv *padata)
 
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
 
@@ -470,14 +412,12 @@ static void padata_init_pqueues(struct parallel_data *pd)
 			continue;
 		}
 
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
@@ -505,12 +445,13 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
-	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 1);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
+	pd->cpu = cpumask_first(pcpumask);
+	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
 
-- 
2.26.2

