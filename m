Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5AA29BF4F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793655AbgJ0PHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790968AbgJ0PFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9FD21707;
        Tue, 27 Oct 2020 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811121;
        bh=XRWy2QwBtKv0+SiGIvl4jK6Gry7e5n+hn+5YliPx8m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfFF1u5/y3mNdueBD2NbPbCZsJvrKZCZOBQl7pCI0b4i08EeIrEILFp1PIYt4QPrz
         gLIf3iSZbsDowFruVmodpjo8UxXDyt0TwKwo77jBKR1rndA/sMLjMYFLNXumlULjSB
         wB1fL1NrhxKf1O/+kNG6mypZLBQypZxnvR+tketc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 350/633] RDMA/core: Delete function indirection for alloc/free kernel CQ
Date:   Tue, 27 Oct 2020 14:51:33 +0100
Message-Id: <20201027135539.106690141@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 7e3c66c9a989d5b53387ceebc88b9e4a9b1d6434 ]

The ib_alloc_cq*() and ib_free_cq*() are solely kernel verbs to manage CQs
and doesn't need extra indirection just to call same functions with
constant parameter NULL as udata.

Link: https://lore.kernel.org/r/20200907120921.476363-6-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c | 27 +++++++---------
 include/rdma/ib_verbs.h      | 62 ++++--------------------------------
 2 files changed, 18 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index a92fc3f90bb5b..2efe825689e3e 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -197,24 +197,22 @@ static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
 }
 
 /**
- * __ib_alloc_cq_user - allocate a completion queue
+ * __ib_alloc_cq        allocate a completion queue
  * @dev:		device to allocate the CQ for
  * @private:		driver private data, accessible from cq->cq_context
  * @nr_cqe:		number of CQEs to allocate
  * @comp_vector:	HCA completion vectors for this CQ
  * @poll_ctx:		context to poll the CQ from.
  * @caller:		module owner name.
- * @udata:		Valid user data or NULL for kernel object
  *
  * This is the proper interface to allocate a CQ for in-kernel users. A
  * CQ allocated with this interface will automatically be polled from the
  * specified context. The ULP must use wr->wr_cqe instead of wr->wr_id
  * to use this CQ abstraction.
  */
-struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
-				 int nr_cqe, int comp_vector,
-				 enum ib_poll_context poll_ctx,
-				 const char *caller, struct ib_udata *udata)
+struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
+			    int comp_vector, enum ib_poll_context poll_ctx,
+			    const char *caller)
 {
 	struct ib_cq_init_attr cq_attr = {
 		.cqe		= nr_cqe,
@@ -277,7 +275,7 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
 out_destroy_cq:
 	rdma_dim_destroy(cq);
 	rdma_restrack_del(&cq->res);
-	cq->device->ops.destroy_cq(cq, udata);
+	cq->device->ops.destroy_cq(cq, NULL);
 out_free_wc:
 	kfree(cq->wc);
 out_free_cq:
@@ -285,7 +283,7 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
 	trace_cq_alloc_error(nr_cqe, comp_vector, poll_ctx, ret);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL(__ib_alloc_cq_user);
+EXPORT_SYMBOL(__ib_alloc_cq);
 
 /**
  * __ib_alloc_cq_any - allocate a completion queue
@@ -310,17 +308,16 @@ struct ib_cq *__ib_alloc_cq_any(struct ib_device *dev, void *private,
 			atomic_inc_return(&counter) %
 			min_t(int, dev->num_comp_vectors, num_online_cpus());
 
-	return __ib_alloc_cq_user(dev, private, nr_cqe, comp_vector, poll_ctx,
-				  caller, NULL);
+	return __ib_alloc_cq(dev, private, nr_cqe, comp_vector, poll_ctx,
+			     caller);
 }
 EXPORT_SYMBOL(__ib_alloc_cq_any);
 
 /**
- * ib_free_cq_user - free a completion queue
+ * ib_free_cq - free a completion queue
  * @cq:		completion queue to free.
- * @udata:	User data or NULL for kernel object
  */
-void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata)
+void ib_free_cq(struct ib_cq *cq)
 {
 	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
 		return;
@@ -344,11 +341,11 @@ void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 	rdma_dim_destroy(cq);
 	trace_cq_free(cq);
 	rdma_restrack_del(&cq->res);
-	cq->device->ops.destroy_cq(cq, udata);
+	cq->device->ops.destroy_cq(cq, NULL);
 	kfree(cq->wc);
 	kfree(cq);
 }
-EXPORT_SYMBOL(ib_free_cq_user);
+EXPORT_SYMBOL(ib_free_cq);
 
 void ib_cq_pool_init(struct ib_device *dev)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ef2f3986c4933..bfd1f38c495c7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3834,46 +3834,15 @@ static inline int ib_post_recv(struct ib_qp *qp,
 	return qp->device->ops.post_recv(qp, recv_wr, bad_recv_wr ? : &dummy);
 }
 
-struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
-				 int nr_cqe, int comp_vector,
-				 enum ib_poll_context poll_ctx,
-				 const char *caller, struct ib_udata *udata);
-
-/**
- * ib_alloc_cq_user: Allocate kernel/user CQ
- * @dev: The IB device
- * @private: Private data attached to the CQE
- * @nr_cqe: Number of CQEs in the CQ
- * @comp_vector: Completion vector used for the IRQs
- * @poll_ctx: Context used for polling the CQ
- * @udata: Valid user data or NULL for kernel objects
- */
-static inline struct ib_cq *ib_alloc_cq_user(struct ib_device *dev,
-					     void *private, int nr_cqe,
-					     int comp_vector,
-					     enum ib_poll_context poll_ctx,
-					     struct ib_udata *udata)
-{
-	return __ib_alloc_cq_user(dev, private, nr_cqe, comp_vector, poll_ctx,
-				  KBUILD_MODNAME, udata);
-}
-
-/**
- * ib_alloc_cq: Allocate kernel CQ
- * @dev: The IB device
- * @private: Private data attached to the CQE
- * @nr_cqe: Number of CQEs in the CQ
- * @comp_vector: Completion vector used for the IRQs
- * @poll_ctx: Context used for polling the CQ
- *
- * NOTE: for user cq use ib_alloc_cq_user with valid udata!
- */
+struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
+			    int comp_vector, enum ib_poll_context poll_ctx,
+			    const char *caller);
 static inline struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 					int nr_cqe, int comp_vector,
 					enum ib_poll_context poll_ctx)
 {
-	return ib_alloc_cq_user(dev, private, nr_cqe, comp_vector, poll_ctx,
-				NULL);
+	return __ib_alloc_cq(dev, private, nr_cqe, comp_vector, poll_ctx,
+			     KBUILD_MODNAME);
 }
 
 struct ib_cq *__ib_alloc_cq_any(struct ib_device *dev, void *private,
@@ -3895,26 +3864,7 @@ static inline struct ib_cq *ib_alloc_cq_any(struct ib_device *dev,
 				 KBUILD_MODNAME);
 }
 
-/**
- * ib_free_cq_user - Free kernel/user CQ
- * @cq: The CQ to free
- * @udata: Valid user data or NULL for kernel objects
- *
- * NOTE: This function shouldn't be called on shared CQs.
- */
-void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata);
-
-/**
- * ib_free_cq - Free kernel CQ
- * @cq: The CQ to free
- *
- * NOTE: for user cq use ib_free_cq_user with valid udata!
- */
-static inline void ib_free_cq(struct ib_cq *cq)
-{
-	ib_free_cq_user(cq, NULL);
-}
-
+void ib_free_cq(struct ib_cq *cq);
 int ib_process_cq_direct(struct ib_cq *cq, int budget);
 
 /**
-- 
2.25.1



