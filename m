Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CDC1DB6F9
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgETO2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60932 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbgETOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:21 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-000350-9E; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DOO-Rr; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Mathias Krause" <minipli@googlemail.com>
Date:   Wed, 20 May 2020 15:13:35 +0100
Message-ID: <lsq.1589984008.277855522@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/99] padata: ensure the reorder timer callback runs
 on the correct CPU
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

commit cf5868c8a22dc2854b96e9569064bb92365549ca upstream.

The reorder timer function runs on the CPU where the timer interrupt was
handled which is not necessarily one of the CPUs of the 'pcpu' CPU mask
set.

Ensure the padata_reorder() callback runs on the correct CPU, which is
one in the 'pcpu' CPU mask set and, preferrably, the next expected one.
Do so by comparing the current CPU with the expected target CPU. If they
match, call padata_reorder() right away. If they differ, schedule a work
item on the target CPU that does the padata_reorder() call for us.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/padata.h |  2 ++
 kernel/padata.c        | 43 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -85,6 +85,7 @@ struct padata_serial_queue {
  * @swork: work struct for serialization.
  * @pd: Backpointer to the internal control structure.
  * @work: work struct for parallelization.
+ * @reorder_work: work struct for reordering.
  * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
  */
@@ -93,6 +94,7 @@ struct padata_parallel_queue {
        struct padata_list    reorder;
        struct parallel_data *pd;
        struct work_struct    work;
+       struct work_struct    reorder_work;
        atomic_t              num_obj;
        int                   cpu_index;
 };
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -279,11 +279,51 @@ static void padata_reorder(struct parall
 	return;
 }
 
+static void invoke_padata_reorder(struct work_struct *work)
+{
+	struct padata_parallel_queue *pqueue;
+	struct parallel_data *pd;
+
+	local_bh_disable();
+	pqueue = container_of(work, struct padata_parallel_queue, reorder_work);
+	pd = pqueue->pd;
+	padata_reorder(pd);
+	local_bh_enable();
+}
+
 static void padata_reorder_timer(unsigned long arg)
 {
 	struct parallel_data *pd = (struct parallel_data *)arg;
+	unsigned int weight;
+	int target_cpu, cpu;
 
-	padata_reorder(pd);
+	cpu = get_cpu();
+
+	/* We don't lock pd here to not interfere with parallel processing
+	 * padata_reorder() calls on other CPUs. We just need any CPU out of
+	 * the cpumask.pcpu set. It would be nice if it's the right one but
+	 * it doesn't matter if we're off to the next one by using an outdated
+	 * pd->processed value.
+	 */
+	weight = cpumask_weight(pd->cpumask.pcpu);
+	target_cpu = padata_index_to_cpu(pd, pd->processed % weight);
+
+	/* ensure to call the reorder callback on the correct CPU */
+	if (cpu != target_cpu) {
+		struct padata_parallel_queue *pqueue;
+		struct padata_instance *pinst;
+
+		/* The timer function is serialized wrt itself -- no locking
+		 * needed.
+		 */
+		pinst = pd->pinst;
+		pqueue = per_cpu_ptr(pd->pqueue, target_cpu);
+		queue_work_on(target_cpu, pinst->wq, &pqueue->reorder_work);
+	} else {
+		padata_reorder(pd);
+	}
+
+	put_cpu();
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
@@ -404,6 +444,7 @@ static void padata_init_pqueues(struct p
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
+		INIT_WORK(&pqueue->reorder_work, invoke_padata_reorder);
 		atomic_set(&pqueue->num_obj, 0);
 	}
 }

