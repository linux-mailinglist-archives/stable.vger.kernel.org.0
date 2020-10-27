Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC1529B8DB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802046AbgJ0Pp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801056AbgJ0PiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81DF8207C3;
        Tue, 27 Oct 2020 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813082;
        bh=IE0GKyTGJPRHfPPRcTd70G9kg5mZaXeBDVRMNmZojnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pptCm3MBbC76jxnN0EqzVyClegctrUi7gIeX8eJzx2hPCwTQ5R+o5mLqAoL2LcOcS
         tyGhV5sP+rHATuG5Sd/6G7GzqWyRaA9RIJNFQMcCSuIxLEb9jEJNZ/M1rsgtrk/XkI
         h8mEG0AmueMirLUoUn0ERDtHrcxvYceZiBzzcC4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 431/757] RDMA: Restore ability to return error for destroy WQ
Date:   Tue, 27 Oct 2020 14:51:21 +0100
Message-Id: <20201027135510.780319151@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit add53535fb3033c249d9327ae3e7c36d3382bbd1 ]

Make this interface symmetrical to other destroy paths.

Fixes: a49b1dc7ae44 ("RDMA: Convert destroy_wq to be void")
Link: https://lore.kernel.org/r/20200907120921.476363-9-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_wq.c |  2 +-
 drivers/infiniband/core/verbs.c               | 15 +++++++++------
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |  2 +-
 drivers/infiniband/hw/mlx4/qp.c               |  3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  2 +-
 drivers/infiniband/hw/mlx5/qp.c               |  8 ++++++--
 drivers/infiniband/hw/mlx5/qp.h               |  4 ++--
 drivers/infiniband/hw/mlx5/qpc.c              |  5 +++--
 include/rdma/ib_verbs.h                       |  4 ++--
 9 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_wq.c b/drivers/infiniband/core/uverbs_std_types_wq.c
index cad842ede077d..f2e6a625724a4 100644
--- a/drivers/infiniband/core/uverbs_std_types_wq.c
+++ b/drivers/infiniband/core/uverbs_std_types_wq.c
@@ -16,7 +16,7 @@ static int uverbs_free_wq(struct ib_uobject *uobject,
 		container_of(uobject, struct ib_uwq_object, uevent.uobject);
 	int ret;
 
-	ret = ib_destroy_wq(wq, &attrs->driver_udata);
+	ret = ib_destroy_wq_user(wq, &attrs->driver_udata);
 	if (ib_is_destroy_retryable(ret, why, uobject))
 		return ret;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b411be9321bdf..6653f92f2df99 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2387,25 +2387,28 @@ struct ib_wq *ib_create_wq(struct ib_pd *pd,
 EXPORT_SYMBOL(ib_create_wq);
 
 /**
- * ib_destroy_wq - Destroys the specified user WQ.
+ * ib_destroy_wq_user - Destroys the specified user WQ.
  * @wq: The WQ to destroy.
  * @udata: Valid user data
  */
-int ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
+int ib_destroy_wq_user(struct ib_wq *wq, struct ib_udata *udata)
 {
 	struct ib_cq *cq = wq->cq;
 	struct ib_pd *pd = wq->pd;
+	int ret;
 
 	if (atomic_read(&wq->usecnt))
 		return -EBUSY;
 
-	wq->device->ops.destroy_wq(wq, udata);
+	ret = wq->device->ops.destroy_wq(wq, udata);
+	if (ret)
+		return ret;
+
 	atomic_dec(&pd->usecnt);
 	atomic_dec(&cq->usecnt);
-
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL(ib_destroy_wq);
+EXPORT_SYMBOL(ib_destroy_wq_user);
 
 /**
  * ib_modify_wq - Modifies the specified WQ.
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 41d8dcd005c0b..bb64f6d9421c2 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -892,7 +892,7 @@ void mlx4_ib_sl2vl_update(struct mlx4_ib_dev *mdev, int port);
 struct ib_wq *mlx4_ib_create_wq(struct ib_pd *pd,
 				struct ib_wq_init_attr *init_attr,
 				struct ib_udata *udata);
-void mlx4_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata);
+int mlx4_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata);
 int mlx4_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata);
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2975f350b9fd1..b7a0c3f977131 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -4327,7 +4327,7 @@ int mlx4_ib_modify_wq(struct ib_wq *ibwq, struct ib_wq_attr *wq_attr,
 	return err;
 }
 
-void mlx4_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata)
+int mlx4_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibwq->device);
 	struct mlx4_ib_qp *qp = to_mqp((struct ib_qp *)ibwq);
@@ -4338,6 +4338,7 @@ void mlx4_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata)
 	destroy_qp_common(dev, qp, MLX4_IB_RWQ_SRC, udata);
 
 	kfree(qp);
+	return 0;
 }
 
 struct ib_rwq_ind_table
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2f06677adaa2a..884cc7c731253 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1238,7 +1238,7 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 				struct ib_wq_init_attr *init_attr,
 				struct ib_udata *udata);
-void mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata);
+int mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata);
 int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata);
 struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index cda7608b6f2d9..7a3e8e6598d34 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5056,14 +5056,18 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 	return ERR_PTR(err);
 }
 
-void mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
+int mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(wq->device);
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
+	int ret;
 
-	mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
+	ret = mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
+	if (ret)
+		return ret;
 	destroy_user_rq(dev, wq->pd, rwq, udata);
 	kfree(rwq);
+	return 0;
 }
 
 struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index ba899df44c5b4..5d4e140db99ce 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -26,8 +26,8 @@ int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 
 int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev, u32 timeout_usec);
 
-void mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
-				  struct mlx5_core_qp *rq);
+int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
+				 struct mlx5_core_qp *rq);
 int mlx5_core_create_sq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 				struct mlx5_core_qp *sq);
 void mlx5_core_destroy_sq_tracked(struct mlx5_ib_dev *dev,
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 7c3968ef9cd10..c683d7000168d 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -576,11 +576,12 @@ int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 	return err;
 }
 
-void mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
-				  struct mlx5_core_qp *rq)
+int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
+				 struct mlx5_core_qp *rq)
 {
 	destroy_resource_common(dev, rq);
 	destroy_rq_tracked(dev, rq->qpn, rq->uid);
+	return 0;
 }
 
 static void destroy_sq_tracked(struct mlx5_ib_dev *dev, u32 sqn, u16 uid)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8cccbdef5de2a..5b4f0efc4241f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2496,7 +2496,7 @@ struct ib_device_ops {
 	struct ib_wq *(*create_wq)(struct ib_pd *pd,
 				   struct ib_wq_init_attr *init_attr,
 				   struct ib_udata *udata);
-	void (*destroy_wq)(struct ib_wq *wq, struct ib_udata *udata);
+	int (*destroy_wq)(struct ib_wq *wq, struct ib_udata *udata);
 	int (*modify_wq)(struct ib_wq *wq, struct ib_wq_attr *attr,
 			 u32 wq_attr_mask, struct ib_udata *udata);
 	struct ib_rwq_ind_table *(*create_rwq_ind_table)(
@@ -4331,7 +4331,7 @@ struct net_device *ib_device_netdev(struct ib_device *dev, u8 port);
 
 struct ib_wq *ib_create_wq(struct ib_pd *pd,
 			   struct ib_wq_init_attr *init_attr);
-int ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata);
+int ib_destroy_wq_user(struct ib_wq *wq, struct ib_udata *udata);
 int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *attr,
 		 u32 wq_attr_mask);
 int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
-- 
2.25.1



