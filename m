Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F111553E4
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 09:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgBGIqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 03:46:42 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58691 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgBGIqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 03:46:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BF73E21E97;
        Fri,  7 Feb 2020 03:46:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 03:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RGM9am
        QV19wcKHmcSbcwR2Dd7KRKvaUUsiKhFirwoeA=; b=bDlVKEluJil9xTE+ShR0yJ
        JEeWulgkvXRL/lDQMJf3weEuABaYnsba7HjaxarGeDVxwyzO+IPXj4rwfYCtXOdl
        eiLFl4KoNQuVqxH1e5LrrlgDqqRf3mbSkpMMHnP5kFfGsALvLZwo3Oj3Q/WHwMPA
        N90oFcZFKHLzeMANGHIHOjaDhAvaTRcyY78FpR4E3Yu91T/pLXT45zuK8GeWg74r
        4el1n5/IJ+21El/jKbmJUG8Moe3qKlLTXigP8704F+o6zL/Wzliex8eBknhas9Mf
        fK0PgPQwRY/xkIU3PT0beXnGBXziWy85/cqGrNF2dBxWYXY3lk7DDj+HjFfyhkJQ
        ==
X-ME-Sender: <xms:8SM9Xps56RCL3ncbPU4Nhp1dbSF6QtV8DXOLMd8ixAQKzTPKkViuAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheeggdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8SM9Xl-utKj3omaW_tZ4ByynI0tYj5y-o9nG02zIseXbgWsQPDTT0Q>
    <xmx:8SM9XlQ_PREETmJ899OZnwVMa0M5eN4-XfsS3qgqU8SGlzA__r8CbQ>
    <xmx:8SM9XjALZGWXXujDLYe-DiYi-4Kd_bpg0X_bAHRFzO-ZWko0RRkYsg>
    <xmx:8SM9XidzlQfqSDLHU0BZNXhAHgrSVJDydKe8Bmi1ic5EKcaB3baisQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 634E330607B0;
        Fri,  7 Feb 2020 03:46:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] padata: Remove broken queue flushing" failed to apply to 4.9-stable tree
To:     herbert@gondor.apana.org.au, daniel.m.jordan@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 09:46:32 +0100
Message-ID: <1581065192241173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 07928d9bfc81640bab36f5190e8725894d93b659 Mon Sep 17 00:00:00 2001
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 19 Nov 2019 13:17:31 +0800
Subject: [PATCH] padata: Remove broken queue flushing

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

diff --git a/kernel/padata.c b/kernel/padata.c
index c3fec1413295..da56a235a255 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -35,6 +35,8 @@
 
 #define MAX_OBJ_NUM 1000
 
+static void padata_free_pd(struct parallel_data *pd);
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -283,6 +285,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
 	LIST_HEAD(local_list);
+	int cnt;
 
 	local_bh_disable();
 	squeue = container_of(serial_work, struct padata_serial_queue, work);
@@ -292,6 +295,8 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	list_replace_init(&squeue->serial.list, &local_list);
 	spin_unlock(&squeue->serial.lock);
 
+	cnt = 0;
+
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
 
@@ -301,9 +306,12 @@ static void padata_serial_worker(struct work_struct *serial_work)
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
@@ -440,7 +448,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	padata_init_squeues(pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
-	atomic_set(&pd->refcnt, 0);
+	atomic_set(&pd->refcnt, 1);
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
@@ -466,29 +474,6 @@ static void padata_free_pd(struct parallel_data *pd)
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
@@ -502,10 +487,6 @@ static void __padata_stop(struct padata_instance *pinst)
 	pinst->flags &= ~PADATA_INIT;
 
 	synchronize_rcu();
-
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
 
 /* Replace the internal control structure with a new one. */
@@ -526,8 +507,8 @@ static void padata_replace(struct padata_instance *pinst,
 	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
-	padata_flush_queues(pd_old);
-	padata_free_pd(pd_old);
+	if (atomic_dec_and_test(&pd_old->refcnt))
+		padata_free_pd(pd_old);
 
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,

