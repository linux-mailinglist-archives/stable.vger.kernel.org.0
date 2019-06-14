Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442E646438
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfFNQcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 12:32:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:19226 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbfFNQce (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 12:32:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 09:32:34 -0700
X-ExtLoop1: 1
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jun 2019 09:32:33 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x5EGWXuD060977;
        Fri, 14 Jun 2019 09:32:33 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x5EGWWM7045026;
        Fri, 14 Jun 2019 12:32:32 -0400
Subject: [PATCH for-rc 2/7] IB/hfi1: Silence txreq allocation warnings
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org
Date:   Fri, 14 Jun 2019 12:32:32 -0400
Message-ID: <20190614163231.44927.3897.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20190614163146.44927.95985.stgit@awfm-01.aw.intel.com>
References: <20190614163146.44927.95985.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

The following warning can happen when a memory shortage
occurs during txreq allocation:

[10220.939246] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
[10220.939246] Hardware name: Intel Corporation S2600WT2R/S2600WT2R, BIOS SE5C610.86B.01.01.0018.C4.072020161249 07/20/2016
[10220.939247]   cache: mnt_cache, object size: 384, buffer size: 384, default order: 2, min order: 0
[10220.939260] Workqueue: hfi0_0 _hfi1_do_send [hfi1]
[10220.939261]   node 0: slabs: 1026568, objs: 43115856, free: 0
[10220.939262] Call Trace:
[10220.939262]   node 1: slabs: 820872, objs: 34476624, free: 0
[10220.939263]  dump_stack+0x5a/0x73
[10220.939265]  warn_alloc+0x103/0x190
[10220.939267]  ? wake_all_kswapds+0x54/0x8b
[10220.939268]  __alloc_pages_slowpath+0x86c/0xa2e
[10220.939270]  ? __alloc_pages_nodemask+0x2fe/0x320
[10220.939271]  __alloc_pages_nodemask+0x2fe/0x320
[10220.939273]  new_slab+0x475/0x550
[10220.939275]  ___slab_alloc+0x36c/0x520
[10220.939287]  ? hfi1_make_rc_req+0x90/0x18b0 [hfi1]
[10220.939299]  ? __get_txreq+0x54/0x160 [hfi1]
[10220.939310]  ? hfi1_make_rc_req+0x90/0x18b0 [hfi1]
[10220.939312]  __slab_alloc+0x40/0x61
[10220.939323]  ? hfi1_make_rc_req+0x90/0x18b0 [hfi1]
[10220.939325]  kmem_cache_alloc+0x181/0x1b0
[10220.939336]  hfi1_make_rc_req+0x90/0x18b0 [hfi1]
[10220.939348]  ? hfi1_verbs_send_dma+0x386/0xa10 [hfi1]
[10220.939359]  ? find_prev_entry+0xb0/0xb0 [hfi1]
[10220.939371]  hfi1_do_send+0x1d9/0x3f0 [hfi1]
[10220.939372]  process_one_work+0x171/0x380
[10220.939374]  worker_thread+0x49/0x3f0
[10220.939375]  kthread+0xf8/0x130
[10220.939377]  ? max_active_store+0x80/0x80
[10220.939378]  ? kthread_bind+0x10/0x10
[10220.939379]  ret_from_fork+0x35/0x40
[10220.939381] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)

The shortage is handled properly so the message isn't needed. Silence by
adding the no warn option to the slab allocation.

Fixes: 45842abbb292 ("staging/rdma/hfi1: move txreq header code")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/verbs_txreq.c |    2 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.c b/drivers/infiniband/hw/hfi1/verbs_txreq.c
index c4ab2d5..8f766dd 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.c
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.c
@@ -100,7 +100,7 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		struct hfi1_qp_priv *priv;
 
-		tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
+		tx = kmem_cache_alloc(dev->verbs_txreq_cache, VERBS_TXREQ_GFP);
 		if (tx)
 			goto out;
 		priv = qp->priv;
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
index b002e96..bfa6e08 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -72,6 +72,7 @@ struct verbs_txreq {
 struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 				struct rvt_qp *qp);
 
+#define VERBS_TXREQ_GFP (GFP_ATOMIC | __GFP_NOWARN)
 static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 					    struct rvt_qp *qp)
 	__must_hold(&qp->slock)
@@ -79,7 +80,7 @@ static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 	struct verbs_txreq *tx;
 	struct hfi1_qp_priv *priv = qp->priv;
 
-	tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
+	tx = kmem_cache_alloc(dev->verbs_txreq_cache, VERBS_TXREQ_GFP);
 	if (unlikely(!tx)) {
 		/* call slow path to get the lock */
 		tx = __get_txreq(dev, qp);

