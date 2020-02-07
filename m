Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5621553E3
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 09:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgBGIqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 03:46:35 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44171 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgBGIqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 03:46:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 76A8C21B55;
        Fri,  7 Feb 2020 03:46:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 03:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KrHE7H
        FyHQ5w1JJ9dfiVzpL770UGVXQcM42zk5qKZ3w=; b=38gmxBvUliHPrVjQ+oO5x5
        p7j0255pdXMKn6kRGEE13Phau7/QNlE++9dnVPDg1x+azvs0WzSHy/hxT3yr676M
        MZnVezLYiVawUGURYsVdeZuTdl9QizBPGI/Lx9sftJ2F18hjFbV6C3p0tsFUhCUL
        gAZhCj//BrUO1FDvTFyOFIWftbUB9PX3fPPJIDVl+djLImLKWfdEtdGeyB3rK2Iu
        sd491zCNrZMfW3Mju1kp55l1JU3rJ1M2qtavMe+9bOitssfK2MX5J7XLigShebLf
        jvFY/R0ypfIIw7bCFl66QNity2w7gN/kguH+cjccIijoMfC+CwQeRIp323ZV4WtA
        ==
X-ME-Sender: <xms:6SM9XskRPdbXFDbU9KOGWXEFGQtQZ4V5pnlxAtUnzgHwdK0DMM6Z7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheeggdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6SM9XjK-bv6ttKpvJaobYHhQzdGuhZvx3uHQTI0V5L5LE2n_qiwObQ>
    <xmx:6SM9XtRW5c-ZyX8Rdn4pf09qH4LxkP-w1jV2x3MXL_EFr60wYh4s2Q>
    <xmx:6SM9XiqVOtyn3NOcpVhgPJOP8BkfD1Y0v8v-sg2Ay-wd5-PF2EL9XA>
    <xmx:6iM9Xtl0wkjAFw2GhCc0k0-zkBNafayLTfBgLILRTapZT3vs0jkakQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61FC730605C8;
        Fri,  7 Feb 2020 03:46:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] padata: Remove broken queue flushing" failed to apply to 4.19-stable tree
To:     herbert@gondor.apana.org.au, daniel.m.jordan@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 09:46:31 +0100
Message-ID: <1581065191136112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

