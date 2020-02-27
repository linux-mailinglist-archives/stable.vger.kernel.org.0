Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE955171980
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgB0Np3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730361AbgB0Np0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 472CE21D7E;
        Thu, 27 Feb 2020 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811125;
        bh=K3Ra+BUQ5/jp2bDVeFTc3iJxPIsTfY1Xe7A0eQdM7K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fp4G6Qx9hVAJ/7akNmfwbfD8dsFph477ZVhwzS5RJD9pPNWBqd48QqEnuNYO3r4A
         fNVYa2VqdHYObeLxyBwKdxRp1BbPkTaLMy6JrF/n2weg0PbKzk/FLKuTZZVtorGc3y
         KiDjPevOlAAroTo73GRJ5VsH96UUtnWbG7rL6Q4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 4.9 013/165] padata: Remove broken queue flushing
Date:   Thu, 27 Feb 2020 14:34:47 +0100
Message-Id: <20200227132232.980629716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 07928d9bfc81640bab36f5190e8725894d93b659 upstream.

The function padata_flush_queues is fundamentally broken because
it cannot force padata users to complete the request that is
underway.  IOW padata has to passively wait for the completion
of any outstanding work.

As it stands flushing is used in two places.  Its use in padata_stop
is simply unnecessary because nothing depends on the queues to
be flushed afterwards.

The other use in padata_replace is more substantial as we depend
on it to free the old pd structure.  This patch instead uses the
pd->refcnt to dynamically free the pd structure once all requests
are complete.

Fixes: 2b73b07ab8a4 ("padata: Flush the padata queues actively")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[dj: leave "pd->pinst = pinst" assignment in padata_alloc_pd()]
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/padata.c |   45 ++++++++++++---------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -34,6 +34,8 @@
 
 #define MAX_OBJ_NUM 1000
 
+static void padata_free_pd(struct parallel_data *pd);
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -301,6 +303,7 @@ static void padata_serial_worker(struct
 	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
 	LIST_HEAD(local_list);
+	int cnt;
 
 	local_bh_disable();
 	squeue = container_of(serial_work, struct padata_serial_queue, work);
@@ -310,6 +313,8 @@ static void padata_serial_worker(struct
 	list_replace_init(&squeue->serial.list, &local_list);
 	spin_unlock(&squeue->serial.lock);
 
+	cnt = 0;
+
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
 
@@ -319,9 +324,12 @@ static void padata_serial_worker(struct
 		list_del_init(&padata->list);
 
 		padata->serial(padata);
-		atomic_dec(&pd->refcnt);
+		cnt++;
 	}
 	local_bh_enable();
+
+	if (atomic_sub_and_test(cnt, &pd->refcnt))
+		padata_free_pd(pd);
 }
 
 /**
@@ -444,7 +452,7 @@ static struct parallel_data *padata_allo
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
-	atomic_set(&pd->refcnt, 0);
+	atomic_set(&pd->refcnt, 1);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 
@@ -469,31 +477,6 @@ static void padata_free_pd(struct parall
 	kfree(pd);
 }
 
-/* Flush all objects out of the padata queues. */
-static void padata_flush_queues(struct parallel_data *pd)
-{
-	int cpu;
-	struct padata_parallel_queue *pqueue;
-	struct padata_serial_queue *squeue;
-
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
-		pqueue = per_cpu_ptr(pd->pqueue, cpu);
-		flush_work(&pqueue->work);
-	}
-
-	del_timer_sync(&pd->timer);
-
-	if (atomic_read(&pd->reorder_objects))
-		padata_reorder(pd);
-
-	for_each_cpu(cpu, pd->cpumask.cbcpu) {
-		squeue = per_cpu_ptr(pd->squeue, cpu);
-		flush_work(&squeue->work);
-	}
-
-	BUG_ON(atomic_read(&pd->refcnt) != 0);
-}
-
 static void __padata_start(struct padata_instance *pinst)
 {
 	pinst->flags |= PADATA_INIT;
@@ -507,10 +490,6 @@ static void __padata_stop(struct padata_
 	pinst->flags &= ~PADATA_INIT;
 
 	synchronize_rcu();
-
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
 
 /* Replace the internal control structure with a new one. */
@@ -531,8 +510,8 @@ static void padata_replace(struct padata
 	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
-	padata_flush_queues(pd_old);
-	padata_free_pd(pd_old);
+	if (atomic_dec_and_test(&pd_old->refcnt))
+		padata_free_pd(pd_old);
 
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,


