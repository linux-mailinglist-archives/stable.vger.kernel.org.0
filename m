Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0581B50681
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfFXJ7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729155AbfFXJ7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:59:11 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C127F2173C;
        Mon, 24 Jun 2019 09:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370350;
        bh=RrDzfyGthtF5raNEydbiuzy84TWzT8OuuZw9M17TTDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgz7uD440vwoGGz+9Oze77xy6wEgrqDO685FdicDBr7pLumUXJVFdwbT2AE29z7+O
         R5SAPn5PdwfwxlA8kyMRroEcH7JXHVQYUslfj9tc0TUHVMvr8zEbiSQQHFj9MgSfiG
         pWkO1tnbIcg0yJmToSn00v8uYnVJyQi2tuCiWtvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 4.14 08/51] IB/hfi1: Silence txreq allocation warnings
Date:   Mon, 24 Jun 2019 17:56:26 +0800
Message-Id: <20190624092307.371292483@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 3230f4a8d44e4a0bb7afea814b280b5129521f52 upstream.

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
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/verbs_txreq.c |    2 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/hfi1/verbs_txreq.c
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.c
@@ -100,7 +100,7 @@ struct verbs_txreq *__get_txreq(struct h
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		struct hfi1_qp_priv *priv;
 
-		tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
+		tx = kmem_cache_alloc(dev->verbs_txreq_cache, VERBS_TXREQ_GFP);
 		if (tx)
 			goto out;
 		priv = qp->priv;
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -72,6 +72,7 @@ struct hfi1_ibdev;
 struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 				struct rvt_qp *qp);
 
+#define VERBS_TXREQ_GFP (GFP_ATOMIC | __GFP_NOWARN)
 static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 					    struct rvt_qp *qp)
 	__must_hold(&qp->slock)
@@ -79,7 +80,7 @@ static inline struct verbs_txreq *get_tx
 	struct verbs_txreq *tx;
 	struct hfi1_qp_priv *priv = qp->priv;
 
-	tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
+	tx = kmem_cache_alloc(dev->verbs_txreq_cache, VERBS_TXREQ_GFP);
 	if (unlikely(!tx)) {
 		/* call slow path to get the lock */
 		tx = __get_txreq(dev, qp);


