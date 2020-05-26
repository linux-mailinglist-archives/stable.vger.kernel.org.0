Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651701E2EC0
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389662AbgEZS6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390361AbgEZS6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D712D20849;
        Tue, 26 May 2020 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519520;
        bh=8E0sLew2Jr0zphB0VSQglmqOBcvFzFjkzDJzRHNfIl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmM10XjTyTH1D3Z8b4hrDBVrEgvF78vLUZorH9I3rwoo5HMWmS0bMDbQVWGFX0INZ
         Npjz37/uARqQqwEdHlV0mRPWDPZtb/PQirnTkaUvAqC1u+BBhrMCZtntZq2NedDoYX
         x5JjVIa4VIB3Ds/ogGoJO/GLqsGLPxk+ferG9Sqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 04/64] padata: ensure the reorder timer callback runs on the correct CPU
Date:   Tue, 26 May 2020 20:52:33 +0200
Message-Id: <20200526183914.658367770@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/padata.h |    2 ++
 kernel/padata.c        |   43 ++++++++++++++++++++++++++++++++++++++++++-
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
@@ -282,11 +282,51 @@ static void padata_reorder(struct parall
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
@@ -413,6 +453,7 @@ static void padata_init_pqueues(struct p
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
+		INIT_WORK(&pqueue->reorder_work, invoke_padata_reorder);
 		atomic_set(&pqueue->num_obj, 0);
 	}
 }


