Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F027D16324B
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgBRT4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgBRT4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:56:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBBE624654;
        Tue, 18 Feb 2020 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055801;
        bh=vPcEZZZzt3R3MjjbO+mBOCVnXZNtssLo+oinALCor9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAxi5J2Q/4Bz9/8Sms8T42JLPdOIPiJR3NW0Tp6sgjVGK/XZ2ePAHLOUdU9ZqlK88
         9TD/xzVhXEfzj1RYk03zzzzZg6uJDu7Py7v9ISK8Ck5CA8t+gpzDlXhhiJ4gna2/UA
         oIb6Y3Y2zsN6UL/lYa4H5WOp9QhltVB6LZqVNKKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 26/38] IB/hfi1: Close window for pq and request coliding
Date:   Tue, 18 Feb 2020 20:55:12 +0100
Message-Id: <20200218190421.735335192@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
References: <20200218190418.536430858@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit be8638344c70bf492963ace206a9896606b6922d upstream.

Cleaning up a pq can result in the following warning and panic:

  WARNING: CPU: 52 PID: 77418 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0
  list_del corruption, ffff88cb2c6ac068->next is LIST_POISON1 (dead000000000100)
  Modules linked in: mmfs26(OE) mmfslinux(OE) tracedev(OE) 8021q garp mrp ib_isert iscsi_target_mod target_core_mod crc_t10dif crct10dif_generic opa_vnic rpcrdma ib_iser libiscsi scsi_transport_iscsi ib_ipoib(OE) bridge stp llc iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crct10dif_pclmul crct10dif_common crc32_pclmul ghash_clmulni_intel ast aesni_intel ttm lrw gf128mul glue_helper ablk_helper drm_kms_helper cryptd syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr joydev lpc_ich mei_me drm_panel_orientation_quirks i2c_i801 mei wmi ipmi_si ipmi_devintf ipmi_msghandler nfit libnvdimm acpi_power_meter acpi_pad hfi1(OE) rdmavt(OE) rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_core binfmt_misc numatools(OE) xpmem(OE) ip_tables
   nfsv3 nfs_acl nfs lockd grace sunrpc fscache igb ahci i2c_algo_bit libahci dca ptp libata pps_core crc32c_intel [last unloaded: i2c_algo_bit]
  CPU: 52 PID: 77418 Comm: pvbatch Kdump: loaded Tainted: G           OE  ------------   3.10.0-957.38.3.el7.x86_64 #1
  Hardware name: HPE.COM HPE SGI 8600-XA730i Gen10/X11DPT-SB-SG007, BIOS SBED1229 01/22/2019
  Call Trace:
   [<ffffffff90365ac0>] dump_stack+0x19/0x1b
   [<ffffffff8fc98b78>] __warn+0xd8/0x100
   [<ffffffff8fc98bff>] warn_slowpath_fmt+0x5f/0x80
   [<ffffffff8ff970c3>] __list_del_entry+0x63/0xd0
   [<ffffffff8ff9713d>] list_del+0xd/0x30
   [<ffffffff8fddda70>] kmem_cache_destroy+0x50/0x110
   [<ffffffffc0328130>] hfi1_user_sdma_free_queues+0xf0/0x200 [hfi1]
   [<ffffffffc02e2350>] hfi1_file_close+0x70/0x1e0 [hfi1]
   [<ffffffff8fe4519c>] __fput+0xec/0x260
   [<ffffffff8fe453fe>] ____fput+0xe/0x10
   [<ffffffff8fcbfd1b>] task_work_run+0xbb/0xe0
   [<ffffffff8fc2bc65>] do_notify_resume+0xa5/0xc0
   [<ffffffff90379134>] int_signal+0x12/0x17
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
  IP: [<ffffffff8fe1f93e>] kmem_cache_close+0x7e/0x300
  PGD 2cdab19067 PUD 2f7bfdb067 PMD 0
  Oops: 0000 [#1] SMP
  Modules linked in: mmfs26(OE) mmfslinux(OE) tracedev(OE) 8021q garp mrp ib_isert iscsi_target_mod target_core_mod crc_t10dif crct10dif_generic opa_vnic rpcrdma ib_iser libiscsi scsi_transport_iscsi ib_ipoib(OE) bridge stp llc iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crct10dif_pclmul crct10dif_common crc32_pclmul ghash_clmulni_intel ast aesni_intel ttm lrw gf128mul glue_helper ablk_helper drm_kms_helper cryptd syscopyarea sysfillrect sysimgblt fb_sys_fops drm pcspkr joydev lpc_ich mei_me drm_panel_orientation_quirks i2c_i801 mei wmi ipmi_si ipmi_devintf ipmi_msghandler nfit libnvdimm acpi_power_meter acpi_pad hfi1(OE) rdmavt(OE) rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_core binfmt_misc numatools(OE) xpmem(OE) ip_tables
   nfsv3 nfs_acl nfs lockd grace sunrpc fscache igb ahci i2c_algo_bit libahci dca ptp libata pps_core crc32c_intel [last unloaded: i2c_algo_bit]
  CPU: 52 PID: 77418 Comm: pvbatch Kdump: loaded Tainted: G        W  OE  ------------   3.10.0-957.38.3.el7.x86_64 #1
  Hardware name: HPE.COM HPE SGI 8600-XA730i Gen10/X11DPT-SB-SG007, BIOS SBED1229 01/22/2019
  task: ffff88cc26db9040 ti: ffff88b5393a8000 task.ti: ffff88b5393a8000
  RIP: 0010:[<ffffffff8fe1f93e>]  [<ffffffff8fe1f93e>] kmem_cache_close+0x7e/0x300
  RSP: 0018:ffff88b5393abd60  EFLAGS: 00010287
  RAX: 0000000000000000 RBX: ffff88cb2c6ac000 RCX: 0000000000000003
  RDX: 0000000000000400 RSI: 0000000000000400 RDI: ffffffff9095b800
  RBP: ffff88b5393abdb0 R08: ffffffff9095b808 R09: ffffffff8ff77c19
  R10: ffff88b73ce1f160 R11: ffffddecddde9800 R12: ffff88cb2c6ac000
  R13: 000000000000000c R14: ffff88cf3fdca780 R15: 0000000000000000
  FS:  00002aaaaab52500(0000) GS:ffff88b73ce00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000010 CR3: 0000002d27664000 CR4: 00000000007607e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   [<ffffffff8fe20d44>] __kmem_cache_shutdown+0x14/0x80
   [<ffffffff8fddda78>] kmem_cache_destroy+0x58/0x110
   [<ffffffffc0328130>] hfi1_user_sdma_free_queues+0xf0/0x200 [hfi1]
   [<ffffffffc02e2350>] hfi1_file_close+0x70/0x1e0 [hfi1]
   [<ffffffff8fe4519c>] __fput+0xec/0x260
   [<ffffffff8fe453fe>] ____fput+0xe/0x10
   [<ffffffff8fcbfd1b>] task_work_run+0xbb/0xe0
   [<ffffffff8fc2bc65>] do_notify_resume+0xa5/0xc0
   [<ffffffff90379134>] int_signal+0x12/0x17
  Code: 00 00 ba 00 04 00 00 0f 4f c2 3d 00 04 00 00 89 45 bc 0f 84 e7 01 00 00 48 63 45 bc 49 8d 04 c4 48 89 45 b0 48 8b 80 c8 00 00 00 <48> 8b 78 10 48 89 45 c0 48 83 c0 10 48 89 45 d0 48 8b 17 48 39
  RIP  [<ffffffff8fe1f93e>] kmem_cache_close+0x7e/0x300
   RSP <ffff88b5393abd60>
  CR2: 0000000000000010

The panic is the result of slab entries being freed during the destruction
of the pq slab.

The code attempts to quiesce the pq, but looking for n_req == 0 doesn't
account for new requests.

Fix the issue by using SRCU to get a pq pointer and adjust the pq free
logic to NULL the fd pq pointer prior to the quiesce.

Fixes: e87473bc1b6c ("IB/hfi1: Only set fd pointer when base context is completely initialized")
Link: https://lore.kernel.org/r/20200210131033.87408.81174.stgit@awfm-01.aw.intel.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/file_ops.c     |   52 ++++++++++++++++++------------
 drivers/infiniband/hw/hfi1/hfi.h          |    5 ++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    3 -
 drivers/infiniband/hw/hfi1/user_sdma.c    |   17 ++++++---
 4 files changed, 48 insertions(+), 29 deletions(-)

--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -200,23 +200,24 @@ static int hfi1_file_open(struct inode *
 
 	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
 
-	if (fd) {
-		fd->rec_cpu_num = -1; /* no cpu affinity by default */
-		fd->mm = current->mm;
-		mmgrab(fd->mm);
-		fd->dd = dd;
-		kobject_get(&fd->dd->kobj);
-		fp->private_data = fd;
-	} else {
-		fp->private_data = NULL;
-
-		if (atomic_dec_and_test(&dd->user_refcount))
-			complete(&dd->user_comp);
-
-		return -ENOMEM;
-	}
-
+	if (!fd || init_srcu_struct(&fd->pq_srcu))
+		goto nomem;
+	spin_lock_init(&fd->pq_rcu_lock);
+	spin_lock_init(&fd->tid_lock);
+	spin_lock_init(&fd->invalid_lock);
+	fd->rec_cpu_num = -1; /* no cpu affinity by default */
+	fd->mm = current->mm;
+	mmgrab(fd->mm);
+	fd->dd = dd;
+	kobject_get(&fd->dd->kobj);
+	fp->private_data = fd;
 	return 0;
+nomem:
+	kfree(fd);
+	fp->private_data = NULL;
+	if (atomic_dec_and_test(&dd->user_refcount))
+		complete(&dd->user_comp);
+	return -ENOMEM;
 }
 
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
@@ -301,21 +302,30 @@ static long hfi1_file_ioctl(struct file
 static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 {
 	struct hfi1_filedata *fd = kiocb->ki_filp->private_data;
-	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
+	struct hfi1_user_sdma_pkt_q *pq;
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	int done = 0, reqs = 0;
 	unsigned long dim = from->nr_segs;
+	int idx;
 
-	if (!cq || !pq)
+	idx = srcu_read_lock(&fd->pq_srcu);
+	pq = srcu_dereference(fd->pq, &fd->pq_srcu);
+	if (!cq || !pq) {
+		srcu_read_unlock(&fd->pq_srcu, idx);
 		return -EIO;
+	}
 
-	if (!iter_is_iovec(from) || !dim)
+	if (!iter_is_iovec(from) || !dim) {
+		srcu_read_unlock(&fd->pq_srcu, idx);
 		return -EINVAL;
+	}
 
 	trace_hfi1_sdma_request(fd->dd, fd->uctxt->ctxt, fd->subctxt, dim);
 
-	if (atomic_read(&pq->n_reqs) == pq->n_max_reqs)
+	if (atomic_read(&pq->n_reqs) == pq->n_max_reqs) {
+		srcu_read_unlock(&fd->pq_srcu, idx);
 		return -ENOSPC;
+	}
 
 	while (dim) {
 		int ret;
@@ -333,6 +343,7 @@ static ssize_t hfi1_write_iter(struct ki
 		reqs++;
 	}
 
+	srcu_read_unlock(&fd->pq_srcu, idx);
 	return reqs;
 }
 
@@ -706,6 +717,7 @@ done:
 	if (atomic_dec_and_test(&dd->user_refcount))
 		complete(&dd->user_comp);
 
+	cleanup_srcu_struct(&fdata->pq_srcu);
 	kfree(fdata);
 	return 0;
 }
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1376,10 +1376,13 @@ struct mmu_rb_handler;
 
 /* Private data for file operations */
 struct hfi1_filedata {
+	struct srcu_struct pq_srcu;
 	struct hfi1_devdata *dd;
 	struct hfi1_ctxtdata *uctxt;
 	struct hfi1_user_sdma_comp_q *cq;
-	struct hfi1_user_sdma_pkt_q *pq;
+	/* update side lock for SRCU */
+	spinlock_t pq_rcu_lock;
+	struct hfi1_user_sdma_pkt_q __rcu *pq;
 	u16 subctxt;
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -90,9 +90,6 @@ int hfi1_user_exp_rcv_init(struct hfi1_f
 	struct hfi1_devdata *dd = uctxt->dd;
 	int ret = 0;
 
-	spin_lock_init(&fd->tid_lock);
-	spin_lock_init(&fd->invalid_lock);
-
 	fd->entry_to_rb = kcalloc(uctxt->expected_count,
 				  sizeof(struct rb_node *),
 				  GFP_KERNEL);
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -179,7 +179,6 @@ int hfi1_user_sdma_alloc_queues(struct h
 	pq = kzalloc(sizeof(*pq), GFP_KERNEL);
 	if (!pq)
 		return -ENOMEM;
-
 	pq->dd = dd;
 	pq->ctxt = uctxt->ctxt;
 	pq->subctxt = fd->subctxt;
@@ -236,7 +235,7 @@ int hfi1_user_sdma_alloc_queues(struct h
 		goto pq_mmu_fail;
 	}
 
-	fd->pq = pq;
+	rcu_assign_pointer(fd->pq, pq);
 	fd->cq = cq;
 
 	return 0;
@@ -264,8 +263,14 @@ int hfi1_user_sdma_free_queues(struct hf
 
 	trace_hfi1_sdma_user_free_queues(uctxt->dd, uctxt->ctxt, fd->subctxt);
 
-	pq = fd->pq;
+	spin_lock(&fd->pq_rcu_lock);
+	pq = srcu_dereference_check(fd->pq, &fd->pq_srcu,
+				    lockdep_is_held(&fd->pq_rcu_lock));
 	if (pq) {
+		rcu_assign_pointer(fd->pq, NULL);
+		spin_unlock(&fd->pq_rcu_lock);
+		synchronize_srcu(&fd->pq_srcu);
+		/* at this point there can be no more new requests */
 		if (pq->handler)
 			hfi1_mmu_rb_unregister(pq->handler);
 		iowait_sdma_drain(&pq->busy);
@@ -277,7 +282,8 @@ int hfi1_user_sdma_free_queues(struct hf
 		kfree(pq->req_in_use);
 		kmem_cache_destroy(pq->txreq_cache);
 		kfree(pq);
-		fd->pq = NULL;
+	} else {
+		spin_unlock(&fd->pq_rcu_lock);
 	}
 	if (fd->cq) {
 		vfree(fd->cq->comps);
@@ -321,7 +327,8 @@ int hfi1_user_sdma_process_request(struc
 {
 	int ret = 0, i;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
+	struct hfi1_user_sdma_pkt_q *pq =
+		srcu_dereference(fd->pq, &fd->pq_srcu);
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
 	struct hfi1_devdata *dd = pq->dd;
 	unsigned long idx = 0;


