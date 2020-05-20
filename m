Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC041DB700
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgETO26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60914 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgETOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:21 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-000351-Aq; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DOT-TE; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mathias Krause" <minipli@googlemail.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 20 May 2020 15:13:36 +0100
Message-ID: <lsq.1589984008.54165052@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/99] padata: ensure padata_do_serial() runs on the
 correct CPU
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

From: Mathias Krause <minipli@googlemail.com>

commit 350ef88e7e922354f82a931897ad4a4ce6c686ff upstream.

If the algorithm we're parallelizing is asynchronous we might change
CPUs between padata_do_parallel() and padata_do_serial(). However, we
don't expect this to happen as we need to enqueue the padata object into
the per-cpu reorder queue we took it from, i.e. the same-cpu's parallel
queue.

Ensure we're not switching CPUs for a given padata object by tracking
the CPU within the padata object. If the serial callback gets called on
the wrong CPU, defer invoking padata_reorder() via a kernel worker on
the CPU we're expected to run on.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/padata.h |  2 ++
 kernel/padata.c        | 20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -37,6 +37,7 @@
  * @list: List entry, to attach to the padata lists.
  * @pd: Pointer to the internal control structure.
  * @cb_cpu: Callback cpu for serializatioon.
+ * @cpu: Cpu for parallelization.
  * @seq_nr: Sequence number of the parallelized data object.
  * @info: Used to pass information from the parallel to the serial function.
  * @parallel: Parallel execution function.
@@ -46,6 +47,7 @@ struct padata_priv {
 	struct list_head	list;
 	struct parallel_data	*pd;
 	int			cb_cpu;
+	int			cpu;
 	int			info;
 	void                    (*parallel)(struct padata_priv *padata);
 	void                    (*serial)(struct padata_priv *padata);
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -130,6 +130,7 @@ int padata_do_parallel(struct padata_ins
 	padata->cb_cpu = cb_cpu;
 
 	target_cpu = padata_cpu_hash(pd);
+	padata->cpu = target_cpu;
 	queue = per_cpu_ptr(pd->pqueue, target_cpu);
 
 	spin_lock(&queue->parallel.lock);
@@ -367,10 +368,21 @@ void padata_do_serial(struct padata_priv
 	int cpu;
 	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
+	int reorder_via_wq = 0;
 
 	pd = padata->pd;
 
 	cpu = get_cpu();
+
+	/* We need to run on the same CPU padata_do_parallel(.., padata, ..)
+	 * was called on -- or, at least, enqueue the padata object into the
+	 * correct per-cpu queue.
+	 */
+	if (cpu != padata->cpu) {
+		reorder_via_wq = 1;
+		cpu = padata->cpu;
+	}
+
 	pqueue = per_cpu_ptr(pd->pqueue, cpu);
 
 	spin_lock(&pqueue->reorder.lock);
@@ -387,7 +399,13 @@ void padata_do_serial(struct padata_priv
 
 	put_cpu();
 
-	padata_reorder(pd);
+	/* If we're running on the wrong CPU, call padata_reorder() via a
+	 * kernel worker.
+	 */
+	if (reorder_via_wq)
+		queue_work_on(cpu, pd->pinst->wq, &pqueue->reorder_work);
+	else
+		padata_reorder(pd);
 }
 EXPORT_SYMBOL(padata_do_serial);
 

