Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7442C110F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgKWQug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:50:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:42033 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbgKWQug (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 11:50:36 -0500
IronPort-SDR: lEZaMrOByW62cxf9uBQL8pFsqdpdrJiAisPid4UNbiWhNUx0v7UbxNhW83Hz2hU2gmNsQvdMJn
 zwIuFcM7zBVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="171959473"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="171959473"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 08:50:34 -0800
IronPort-SDR: 3k8UNNingIB0sbPvDdWDDg9icRdFGlCkP/MBqnE6kXOhOuu10bweAtBZTqg8b4NKs39F6QlLUD
 NWArUKgmzrhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="361510475"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2020 08:50:29 -0800
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 0ANGoRCv032095;
        Mon, 23 Nov 2020 09:50:27 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 0ANGoO6X158936;
        Mon, 23 Nov 2020 11:50:25 -0500
Subject: [PATCH for-rc v4] IB/hfi1: Ensure correct mm is used at all times
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>
Date:   Mon, 23 Nov 2020 11:50:24 -0500
Message-ID: <20201123165024.158913.71029.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Note the check in the unregister is not needed in the event that
current->mm is empty. This means the tear down is happening due to a
SigKill or OOM Killer, something along those lines. If current->mm has a
value then it must be checked and only the task that did the register
can do the unregister.

Since in do_exit() the exit_mm() is called before exit_files(), which
would call our close routine a reference is needed on the mm. We rely on
the mmgrab done by the registration of the notifier, whereas before it
was explicit.

Also of note is we do not do any explicit work to protect the interval
tree notifier. It doesn't seem that this is going to be needed since we
aren't actually doing anything with current->mm. The interval tree
notifier stuff still has a FIXME noted from a previous commit that will
be addressed in a follow on patch.

Fixes: e0cf75deab81 ("IB/hfi1: Fix mm_struct use after free")
Fixes: 3faa3d9a308e ("IB/hfi1: Make use of mm consistent")
Cc: <stable@vger.kernel.org>
Suggested-by: Jann Horn <jannh@google.com>
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>

---

Changes since v0:
----------------
Removed the checking of the pid and limitation that
whatever task opens the dev is the only one that can do write() or
ioctl(). While this limitation is OK it doesn't appear to be strictly
necessary.

Rebased on top of 5.10-rc1. Testing has been done on 5.9 due to a bug in
5.10 that is being worked (separate issue).

Changes since v1:
----------------
Remove explicit mmget/put to rely on the notifier register's mmgrab
instead.

Fixed missing check in rb_unregister to only check current->mm if its
actually valid.

Moved mm_from_tid_node to exp_rcv header and use it

Changes since v2:
----------------
Change Reported-by to Suggested-by for Jann

Commit msg updates

Remove private mm pointer and use notifier's

Changes since v3:
-----------------
Added Ira's RB and Cc stable list

Updated commit message

Added comment to mmu_rb_unregister

Renamed confusing variable in mmu_rb_register
---
 drivers/infiniband/hw/hfi1/file_ops.c     |    4 --
 drivers/infiniband/hw/hfi1/hfi.h          |    2 -
 drivers/infiniband/hw/hfi1/mmu_rb.c       |   76 ++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/mmu_rb.h       |   16 ++++++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   12 +++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |    6 ++
 drivers/infiniband/hw/hfi1/user_sdma.c    |   13 +++--
 drivers/infiniband/hw/hfi1/user_sdma.h    |    7 ++-
 8 files changed, 87 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 8ca51e4..329ee4f 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2015-2020 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -206,8 +207,6 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 	spin_lock_init(&fd->tid_lock);
 	spin_lock_init(&fd->invalid_lock);
 	fd->rec_cpu_num = -1; /* no cpu affinity by default */
-	fd->mm = current->mm;
-	mmgrab(fd->mm);
 	fd->dd = dd;
 	fp->private_data = fd;
 	return 0;
@@ -711,7 +710,6 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 
 	deallocate_ctxt(uctxt);
 done:
-	mmdrop(fdata->mm);
 
 	if (atomic_dec_and_test(&dd->user_refcount))
 		complete(&dd->user_comp);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index b4c6bff..e09e824 100644
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
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 24ca17b..06a422c 100644
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
@@ -92,37 +81,36 @@ static unsigned long mmu_node_last(struct mmu_rb_node *node)
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
-
-	ret = mmu_notifier_register(&handlr->mn, handlr->mm);
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
+
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
 
@@ -133,8 +121,16 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 	unsigned long flags;
 	struct list_head del_list;
 
+	/*
+	 * do_exit() calls exit_mm() before exit_files() which would call close
+	 * and end up in here. If there is no mm, then its a kernel thread and
+	 * we need to let it continue the removal.
+	 */
+	if (current->mm && (handler->mn.mm != current->mm))
+		return;
+
 	/* Unregister first so we don't get any more notifications. */
-	mmu_notifier_unregister(&handler->mn, handler->mm);
+	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
 
 	/*
 	 * Make sure the wq delete handler is finished running.  It will not
@@ -166,6 +162,10 @@ int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
 	int ret = 0;
 
 	trace_hfi1_mmu_rb_insert(mnode->addr, mnode->len);
+
+	if (current->mm != handler->mn.mm)
+		return -EPERM;
+
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, mnode->addr, mnode->len);
 	if (node) {
@@ -180,6 +180,7 @@ int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
 		__mmu_int_rb_remove(mnode, &handler->root);
 		list_del(&mnode->list); /* remove from LRU list */
 	}
+	mnode->handler = handler;
 unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
@@ -217,6 +218,9 @@ bool hfi1_mmu_rb_remove_unless_exact(struct mmu_rb_handler *handler,
 	unsigned long flags;
 	bool ret = false;
 
+	if (current->mm != handler->mn.mm)
+		return ret;
+
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
 	if (node) {
@@ -239,6 +243,9 @@ void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
 	unsigned long flags;
 	bool stop = false;
 
+	if (current->mm != handler->mn.mm)
+		return;
+
 	INIT_LIST_HEAD(&del_list);
 
 	spin_lock_irqsave(&handler->lock, flags);
@@ -272,6 +279,9 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 {
 	unsigned long flags;
 
+	if (current->mm != handler->mn.mm)
+		return;
+
 	/* Validity of handler and node pointers has been checked by caller. */
 	trace_hfi1_mmu_rb_remove(node->addr, node->len);
 	spin_lock_irqsave(&handler->lock, flags);
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index f04cec1..423aacc 100644
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
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index f81ca20..b94fc7f 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 Cornelis Networks, Inc.
  * Copyright(c) 2015-2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -173,15 +174,18 @@ static void unpin_rcv_pages(struct hfi1_filedata *fd,
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
 
@@ -216,12 +220,12 @@ static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
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
@@ -756,7 +760,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 
 	if (fd->use_mn) {
 		ret = mmu_interval_notifier_insert(
-			&node->notifier, fd->mm,
+			&node->notifier, current->mm,
 			tbuf->vaddr + (pageidx * PAGE_SIZE), npages * PAGE_SIZE,
 			&tid_mn_ops);
 		if (ret)
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 332abb4..d45c7b6 100644
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
@@ -95,4 +96,9 @@ int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
 int hfi1_user_exp_rcv_invalid(struct hfi1_filedata *fd,
 			      struct hfi1_tid_info *tinfo);
 
+static inline struct mm_struct *mm_from_tid_node(struct tid_rb_node *node)
+{
+	return node->notifier.mm;
+}
+
 #endif /* _HFI1_USER_EXP_RCV_H */
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index a92346e..4a4956f9 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright(c) 2020 - Cornelis Networks, Inc.
  * Copyright(c) 2015 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
@@ -188,7 +189,6 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	atomic_set(&pq->n_reqs, 0);
 	init_waitqueue_head(&pq->wait);
 	atomic_set(&pq->n_locked, 0);
-	pq->mm = fd->mm;
 
 	iowait_init(&pq->busy, 0, NULL, NULL, defer_packet_queue,
 		    activate_packet_queue, NULL, NULL);
@@ -230,7 +230,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 
 	cq->nentries = hfi1_sdma_comp_ring_size;
 
-	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, dd->pport->hfi1_wq,
+	ret = hfi1_mmu_rb_register(pq, &sdma_rb_ops, dd->pport->hfi1_wq,
 				   &pq->handler);
 	if (ret) {
 		dd_dev_err(dd, "Failed to register with MMU %d", ret);
@@ -980,13 +980,13 @@ static int pin_sdma_pages(struct user_sdma_request *req,
 
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
@@ -995,7 +995,7 @@ static int pin_sdma_pages(struct user_sdma_request *req,
 		return pinned;
 	}
 	if (pinned != npages) {
-		unpin_vector_pages(pq->mm, pages, node->npages, pinned);
+		unpin_vector_pages(current->mm, pages, node->npages, pinned);
 		return -EFAULT;
 	}
 	kfree(node->pages);
@@ -1008,7 +1008,8 @@ static int pin_sdma_pages(struct user_sdma_request *req,
 static void unpin_sdma_pages(struct sdma_mmu_node *node)
 {
 	if (node->npages) {
-		unpin_vector_pages(node->pq->mm, node->pages, 0, node->npages);
+		unpin_vector_pages(mm_from_sdma_node(node), node->pages, 0,
+				   node->npages);
 		atomic_sub(node->npages, &node->pq->n_locked);
 	}
 }
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 9972e0e..1e8c02f 100644
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
@@ -250,4 +250,9 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 				   struct iovec *iovec, unsigned long dim,
 				   unsigned long *count);
 
+static inline struct mm_struct *mm_from_sdma_node(struct sdma_mmu_node *node)
+{
+	return node->rb.handler->mn.mm;
+}
+
 #endif /* _HFI1_USER_SDMA_H */

