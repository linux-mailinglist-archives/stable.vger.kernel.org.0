Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BFD2C9B6C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388749AbgLAJIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388729AbgLAJIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C80B21D7F;
        Tue,  1 Dec 2020 09:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813652;
        bh=8GKWu/4LYBYq5AsDoah7lPohk1XZMhF8SEiz13SDbm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA+60U+MLhHKBfdjj/z9B/IDlThCNUKjmaIArJdc91rO/wTZVX1oGyWda74UPszQ6
         WS1gdFZRXH9+dKKBg/W08hEfsBwEwquPUxGSLO7LA8tTi5GasZErLCNErhXzasvTYU
         tAxsggOMKcHtkwOwf30tC+R0Ii1KWp03Y+ZMBJTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: [PATCH 5.9 006/152] IB/hfi1: Ensure correct mm is used at all times
Date:   Tue,  1 Dec 2020 09:52:01 +0100
Message-Id: <20201201084712.667869578@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>

commit 3d2a9d642512c21a12d19b9250e7a835dcb41a79 upstream.

Two earlier bug fixes have created a security problem in the hfi1
driver. One fix aimed to solve an issue where current->mm was not valid
when closing the hfi1 cdev. It attempted to do this by saving a cached
value of the current->mm pointer at file open time. This is a problem if
another process with access to the FD calls in via write() or ioctl() to
pin pages via the hfi driver. The other fix tried to solve a use after
free by taking a reference on the mm.

To fix this correctly we use the existing cached value of the mm in the
mmu notifier. Now we can check in the insert, evict, etc. routines that
current->mm matched what the notifier was registered for. If not, then
don't allow access. The register of the mmu notifier will save the mm
pointer.

Since in do_exit() the exit_mm() is called before exit_files(), which
would call our close routine a reference is needed on the mm. We rely on
the mmgrab done by the registration of the notifier, whereas before it was
explicit. The mmu notifier deregistration happens when the user context is
torn down, the creation of which triggered the registration.

Also of note is we do not do any explicit work to protect the interval
tree notifier. It doesn't seem that this is going to be needed since we
aren't actually doing anything with current->mm. The interval tree
notifier stuff still has a FIXME noted from a previous commit that will be
addressed in a follow on patch.

Cc: <stable@vger.kernel.org>
Fixes: e0cf75deab81 ("IB/hfi1: Fix mm_struct use after free")
Fixes: 3faa3d9a308e ("IB/hfi1: Make use of mm consistent")
Link: https://lore.kernel.org/r/20201125210112.104301.51331.stgit@awfm-01.aw.intel.com
Suggested-by: Jann Horn <jannh@google.com>
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/file_ops.c     |    4 -
 drivers/infiniband/hw/hfi1/hfi.h          |    2 
 drivers/infiniband/hw/hfi1/mmu_rb.c       |   66 +++++++++++++++---------------
 drivers/infiniband/hw/hfi1/mmu_rb.h       |   16 ++++++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   12 +++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |    6 ++
 drivers/infiniband/hw/hfi1/user_sdma.c    |   13 +++--
 drivers/infiniband/hw/hfi1/user_sdma.h    |    7 ++-
 8 files changed, 78 insertions(+), 48 deletions(-)

--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2015-2020 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -206,8 +207,6 @@ static int hfi1_file_open(struct inode *
 	spin_lock_init(&fd->tid_lock);
 	spin_lock_init(&fd->invalid_lock);
 	fd->rec_cpu_num = -1; /* no cpu affinity by default */
-	fd->mm = current->mm;
-	mmgrab(fd->mm);
 	fd->dd = dd;
 	fp->private_data = fd;
 	return 0;
@@ -711,7 +710,6 @@ static int hfi1_file_close(struct inode
 
 	deallocate_ctxt(uctxt);
 done:
-	mmdrop(fdata->mm);
 
 	if (atomic_dec_and_test(&dd->user_refcount))
 		complete(&dd->user_comp);
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1,6 +1,7 @@
 #ifndef _HFI1_KERNEL_H
 #define _HFI1_KERNEL_H
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2015-2020 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -1451,7 +1452,6 @@ struct hfi1_filedata {
 	u32 invalid_tid_idx;
 	/* protect invalid_tids array and invalid_tid_idx */
 	spinlock_t invalid_lock;
-	struct mm_struct *mm;
 };
 
 extern struct xarray hfi1_dev_table;
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2016 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -48,23 +49,11 @@
 #include <linux/rculist.h>
 #include <linux/mmu_notifier.h>
 #include <linux/interval_tree_generic.h>
+#include <linux/sched/mm.h>
 
 #include "mmu_rb.h"
 #include "trace.h"
 
-struct mmu_rb_handler {
-	struct mmu_notifier mn;
-	struct rb_root_cached root;
-	void *ops_arg;
-	spinlock_t lock;        /* protect the RB tree */
-	struct mmu_rb_ops *ops;
-	struct mm_struct *mm;
-	struct list_head lru_list;
-	struct work_struct del_work;
-	struct list_head del_list;
-	struct workqueue_struct *wq;
-};
-
 static unsigned long mmu_node_start(struct mmu_rb_node *);
 static unsigned long mmu_node_last(struct mmu_rb_node *);
 static int mmu_notifier_range_start(struct mmu_notifier *,
@@ -92,37 +81,36 @@ static unsigned long mmu_node_last(struc
 	return PAGE_ALIGN(node->addr + node->len) - 1;
 }
 
-int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
+int hfi1_mmu_rb_register(void *ops_arg,
 			 struct mmu_rb_ops *ops,
 			 struct workqueue_struct *wq,
 			 struct mmu_rb_handler **handler)
 {
-	struct mmu_rb_handler *handlr;
+	struct mmu_rb_handler *h;
 	int ret;
 
-	handlr = kmalloc(sizeof(*handlr), GFP_KERNEL);
-	if (!handlr)
+	h = kmalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
 		return -ENOMEM;
 
-	handlr->root = RB_ROOT_CACHED;
-	handlr->ops = ops;
-	handlr->ops_arg = ops_arg;
-	INIT_HLIST_NODE(&handlr->mn.hlist);
-	spin_lock_init(&handlr->lock);
-	handlr->mn.ops = &mn_opts;
-	handlr->mm = mm;
-	INIT_WORK(&handlr->del_work, handle_remove);
-	INIT_LIST_HEAD(&handlr->del_list);
-	INIT_LIST_HEAD(&handlr->lru_list);
-	handlr->wq = wq;
+	h->root = RB_ROOT_CACHED;
+	h->ops = ops;
+	h->ops_arg = ops_arg;
+	INIT_HLIST_NODE(&h->mn.hlist);
+	spin_lock_init(&h->lock);
+	h->mn.ops = &mn_opts;
+	INIT_WORK(&h->del_work, handle_remove);
+	INIT_LIST_HEAD(&h->del_list);
+	INIT_LIST_HEAD(&h->lru_list);
+	h->wq = wq;
 
-	ret = mmu_notifier_register(&handlr->mn, handlr->mm);
+	ret = mmu_notifier_register(&h->mn, current->mm);
 	if (ret) {
-		kfree(handlr);
+		kfree(h);
 		return ret;
 	}
 
-	*handler = handlr;
+	*handler = h;
 	return 0;
 }
 
@@ -134,7 +122,7 @@ void hfi1_mmu_rb_unregister(struct mmu_r
 	struct list_head del_list;
 
 	/* Unregister first so we don't get any more notifications. */
-	mmu_notifier_unregister(&handler->mn, handler->mm);
+	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
 
 	/*
 	 * Make sure the wq delete handler is finished running.  It will not
@@ -166,6 +154,10 @@ int hfi1_mmu_rb_insert(struct mmu_rb_han
 	int ret = 0;
 
 	trace_hfi1_mmu_rb_insert(mnode->addr, mnode->len);
+
+	if (current->mm != handler->mn.mm)
+		return -EPERM;
+
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, mnode->addr, mnode->len);
 	if (node) {
@@ -180,6 +172,7 @@ int hfi1_mmu_rb_insert(struct mmu_rb_han
 		__mmu_int_rb_remove(mnode, &handler->root);
 		list_del(&mnode->list); /* remove from LRU list */
 	}
+	mnode->handler = handler;
 unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
@@ -217,6 +210,9 @@ bool hfi1_mmu_rb_remove_unless_exact(str
 	unsigned long flags;
 	bool ret = false;
 
+	if (current->mm != handler->mn.mm)
+		return ret;
+
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
 	if (node) {
@@ -239,6 +235,9 @@ void hfi1_mmu_rb_evict(struct mmu_rb_han
 	unsigned long flags;
 	bool stop = false;
 
+	if (current->mm != handler->mn.mm)
+		return;
+
 	INIT_LIST_HEAD(&del_list);
 
 	spin_lock_irqsave(&handler->lock, flags);
@@ -272,6 +271,9 @@ void hfi1_mmu_rb_remove(struct mmu_rb_ha
 {
 	unsigned long flags;
 
+	if (current->mm != handler->mn.mm)
+		return;
+
 	/* Validity of handler and node pointers has been checked by caller. */
 	trace_hfi1_mmu_rb_remove(node->addr, node->len);
 	spin_lock_irqsave(&handler->lock, flags);
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -54,6 +55,7 @@ struct mmu_rb_node {
 	unsigned long len;
 	unsigned long __last;
 	struct rb_node node;
+	struct mmu_rb_handler *handler;
 	struct list_head list;
 };
 
@@ -71,7 +73,19 @@ struct mmu_rb_ops {
 		     void *evict_arg, bool *stop);
 };
 
-int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
+struct mmu_rb_handler {
+	struct mmu_notifier mn;
+	struct rb_root_cached root;
+	void *ops_arg;
+	spinlock_t lock;        /* protect the RB tree */
+	struct mmu_rb_ops *ops;
+	struct list_head lru_list;
+	struct work_struct del_work;
+	struct list_head del_list;
+	struct workqueue_struct *wq;
+};
+
+int hfi1_mmu_rb_register(void *ops_arg,
 			 struct mmu_rb_ops *ops,
 			 struct workqueue_struct *wq,
 			 struct mmu_rb_handler **handler);
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2015-2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -173,15 +174,18 @@ static void unpin_rcv_pages(struct hfi1_
 {
 	struct page **pages;
 	struct hfi1_devdata *dd = fd->uctxt->dd;
+	struct mm_struct *mm;
 
 	if (mapped) {
 		pci_unmap_single(dd->pcidev, node->dma_addr,
 				 node->npages * PAGE_SIZE, PCI_DMA_FROMDEVICE);
 		pages = &node->pages[idx];
+		mm = mm_from_tid_node(node);
 	} else {
 		pages = &tidbuf->pages[idx];
+		mm = current->mm;
 	}
-	hfi1_release_user_pages(fd->mm, pages, npages, mapped);
+	hfi1_release_user_pages(mm, pages, npages, mapped);
 	fd->tid_n_pinned -= npages;
 }
 
@@ -216,12 +220,12 @@ static int pin_rcv_pages(struct hfi1_fil
 	 * pages, accept the amount pinned so far and program only that.
 	 * User space knows how to deal with partially programmed buffers.
 	 */
-	if (!hfi1_can_pin_pages(dd, fd->mm, fd->tid_n_pinned, npages)) {
+	if (!hfi1_can_pin_pages(dd, current->mm, fd->tid_n_pinned, npages)) {
 		kfree(pages);
 		return -ENOMEM;
 	}
 
-	pinned = hfi1_acquire_user_pages(fd->mm, vaddr, npages, true, pages);
+	pinned = hfi1_acquire_user_pages(current->mm, vaddr, npages, true, pages);
 	if (pinned <= 0) {
 		kfree(pages);
 		return pinned;
@@ -756,7 +760,7 @@ static int set_rcvarray_entry(struct hfi
 
 	if (fd->use_mn) {
 		ret = mmu_interval_notifier_insert(
-			&node->notifier, fd->mm,
+			&node->notifier, current->mm,
 			tbuf->vaddr + (pageidx * PAGE_SIZE), npages * PAGE_SIZE,
 			&tid_mn_ops);
 		if (ret)
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -1,6 +1,7 @@
 #ifndef _HFI1_USER_EXP_RCV_H
 #define _HFI1_USER_EXP_RCV_H
 /*
+ * Copyright(c) 2020 - Cornelis Networks, Inc.
  * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -95,4 +96,9 @@ int hfi1_user_exp_rcv_clear(struct hfi1_
 int hfi1_user_exp_rcv_invalid(struct hfi1_filedata *fd,
 			      struct hfi1_tid_info *tinfo);
 
+static inline struct mm_struct *mm_from_tid_node(struct tid_rb_node *node)
+{
+	return node->notifier.mm;
+}
+
 #endif /* _HFI1_USER_EXP_RCV_H */
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 - Cornelis Networks, Inc.
  * Copyright(c) 2015 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -188,7 +189,6 @@ int hfi1_user_sdma_alloc_queues(struct h
 	atomic_set(&pq->n_reqs, 0);
 	init_waitqueue_head(&pq->wait);
 	atomic_set(&pq->n_locked, 0);
-	pq->mm = fd->mm;
 
 	iowait_init(&pq->busy, 0, NULL, NULL, defer_packet_queue,
 		    activate_packet_queue, NULL, NULL);
@@ -230,7 +230,7 @@ int hfi1_user_sdma_alloc_queues(struct h
 
 	cq->nentries = hfi1_sdma_comp_ring_size;
 
-	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, dd->pport->hfi1_wq,
+	ret = hfi1_mmu_rb_register(pq, &sdma_rb_ops, dd->pport->hfi1_wq,
 				   &pq->handler);
 	if (ret) {
 		dd_dev_err(dd, "Failed to register with MMU %d", ret);
@@ -980,13 +980,13 @@ static int pin_sdma_pages(struct user_sd
 
 	npages -= node->npages;
 retry:
-	if (!hfi1_can_pin_pages(pq->dd, pq->mm,
+	if (!hfi1_can_pin_pages(pq->dd, current->mm,
 				atomic_read(&pq->n_locked), npages)) {
 		cleared = sdma_cache_evict(pq, npages);
 		if (cleared >= npages)
 			goto retry;
 	}
-	pinned = hfi1_acquire_user_pages(pq->mm,
+	pinned = hfi1_acquire_user_pages(current->mm,
 					 ((unsigned long)iovec->iov.iov_base +
 					 (node->npages * PAGE_SIZE)), npages, 0,
 					 pages + node->npages);
@@ -995,7 +995,7 @@ retry:
 		return pinned;
 	}
 	if (pinned != npages) {
-		unpin_vector_pages(pq->mm, pages, node->npages, pinned);
+		unpin_vector_pages(current->mm, pages, node->npages, pinned);
 		return -EFAULT;
 	}
 	kfree(node->pages);
@@ -1008,7 +1008,8 @@ retry:
 static void unpin_sdma_pages(struct sdma_mmu_node *node)
 {
 	if (node->npages) {
-		unpin_vector_pages(node->pq->mm, node->pages, 0, node->npages);
+		unpin_vector_pages(mm_from_sdma_node(node), node->pages, 0,
+				   node->npages);
 		atomic_sub(node->npages, &node->pq->n_locked);
 	}
 }
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -1,6 +1,7 @@
 #ifndef _HFI1_USER_SDMA_H
 #define _HFI1_USER_SDMA_H
 /*
+ * Copyright(c) 2020 - Cornelis Networks, Inc.
  * Copyright(c) 2015 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -133,7 +134,6 @@ struct hfi1_user_sdma_pkt_q {
 	unsigned long unpinned;
 	struct mmu_rb_handler *handler;
 	atomic_t n_locked;
-	struct mm_struct *mm;
 };
 
 struct hfi1_user_sdma_comp_q {
@@ -250,4 +250,9 @@ int hfi1_user_sdma_process_request(struc
 				   struct iovec *iovec, unsigned long dim,
 				   unsigned long *count);
 
+static inline struct mm_struct *mm_from_sdma_node(struct sdma_mmu_node *node)
+{
+	return node->rb.handler->mn.mm;
+}
+
 #endif /* _HFI1_USER_SDMA_H */


