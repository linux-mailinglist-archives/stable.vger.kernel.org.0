Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8579B1E2F03
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389716AbgEZS4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389025AbgEZS4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1514720870;
        Tue, 26 May 2020 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519370;
        bh=482FbuVT8uo5gio2dKAXnzKNgKMw3aBVeeXFUSUVQP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CF069xn7+wUgN0IzFjri18sf8y+6FsotjSXS/RYnVCpGEh5jLUtyT9vBzjjMUp2w
         CMACA9+zPEvNeCi99Z04Y7gnNd5I//vk2a6aFZk9EfSZuhn9urpLUVtn3RPe26m3fQ
         LNhzxQP3g+TaxO+DezpanjptaHEoM2qY05I9dJzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 05/65] padata: ensure padata_do_serial() runs on the correct CPU
Date:   Tue, 26 May 2020 20:52:24 +0200
Message-Id: <20200526183908.131959919@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/padata.h |    2 ++
 kernel/padata.c        |   20 +++++++++++++++++++-
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
@@ -132,6 +132,7 @@ int padata_do_parallel(struct padata_ins
 	padata->cb_cpu = cb_cpu;
 
 	target_cpu = padata_cpu_hash(pd);
+	padata->cpu = target_cpu;
 	queue = per_cpu_ptr(pd->pqueue, target_cpu);
 
 	spin_lock(&queue->parallel.lock);
@@ -375,10 +376,21 @@ void padata_do_serial(struct padata_priv
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
@@ -395,7 +407,13 @@ void padata_do_serial(struct padata_priv
 
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
 


