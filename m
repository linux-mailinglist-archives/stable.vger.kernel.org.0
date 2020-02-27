Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC60B1718E6
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgB0NkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbgB0NkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:40:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590F9246A1;
        Thu, 27 Feb 2020 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810821;
        bh=wlmHFF8e4ovR79SPYhXqChEXu29os6aOOjJrd3IYGWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJzzhUDwQu182DosxyQM6StOXtlCabv2ygjXxP2zq77MXIFbaLJ/kZ+wP22tFDMSJ
         75rJGj5jA+/Xew+hxnTDdR+8X9Kt+Da3h4kiu4YQ9L8aoEHoUUL3TqYNQ0DHSUqWOn
         rhxJv6scL0OcHCexT5fHdKJCu9iyhN28oCibnmzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 4.4 011/113] padata: Remove broken queue flushing
Date:   Thu, 27 Feb 2020 14:35:27 +0100
Message-Id: <20200227132213.560633937@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
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
@@ -33,6 +33,8 @@
 
 #define MAX_OBJ_NUM 1000
 
+static void padata_free_pd(struct parallel_data *pd);
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -300,6 +302,7 @@ static void padata_serial_worker(struct
 	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
 	LIST_HEAD(local_list);
+	int cnt;
 
 	local_bh_disable();
 	squeue = container_of(serial_work, struct padata_serial_queue, work);
@@ -309,6 +312,8 @@ static void padata_serial_worker(struct
 	list_replace_init(&squeue->serial.list, &local_list);
 	spin_unlock(&squeue->serial.lock);
 
+	cnt = 0;
+
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
 
@@ -318,9 +323,12 @@ static void padata_serial_worker(struct
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
@@ -443,7 +451,7 @@ static struct parallel_data *padata_allo
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
-	atomic_set(&pd->refcnt, 0);
+	atomic_set(&pd->refcnt, 1);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 
@@ -468,31 +476,6 @@ static void padata_free_pd(struct parall
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
@@ -506,10 +489,6 @@ static void __padata_stop(struct padata_
 	pinst->flags &= ~PADATA_INIT;
 
 	synchronize_rcu();
-
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
 
 /* Replace the internal control structure with a new one. */
@@ -530,8 +509,8 @@ static void padata_replace(struct padata
 	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
-	padata_flush_queues(pd_old);
-	padata_free_pd(pd_old);
+	if (atomic_dec_and_test(&pd_old->refcnt))
+		padata_free_pd(pd_old);
 
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,


