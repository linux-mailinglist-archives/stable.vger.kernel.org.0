Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653D329B8D6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802033AbgJ0PpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801053AbgJ0Ph6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBB9207C3;
        Tue, 27 Oct 2020 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813076;
        bh=XEVg5gQyrA5swh1ZDt9YP1e1OogVvD18q8RCmEyWr8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5Ri7IBnlHfPriXQNfiVNv/JUp89L//gpcjlhqHcdEV295vC8KZtVWz9saHw1hOrn
         c4RhE+yXH4cMkI3Db5EUM8B6J/ldcvroMZz/RKtSNVH8JevUI1O4Q5LJmWdt1HzH1E
         YpWhogtL0/8f+J+oQ3heih6KsTtBKYw2BlZiufo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 429/757] RDMA: Allow fail of destroy CQ
Date:   Tue, 27 Oct 2020 14:51:19 +0100
Message-Id: <20201027135510.695315392@linuxfoundation.org>
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

[ Upstream commit 43d781b9fa562f0c6e50f62c870fbfeb9dc85213 ]

Like any other verbs objects, CQ shouldn't fail during destroy, but
mlx5_ib didn't follow this contract with mixed IB verbs objects with
DEVX. Such mix causes to the situation where FW and kernel are fully
interdependent on the reference counting of each side.

Kernel verbs and drivers that don't have DEVX flows shouldn't fail.

Fixes: e39afe3d6dbd ("RDMA: Convert CQ allocations to be under core responsibility")
Link: https://lore.kernel.org/r/20200907120921.476363-7-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c                    | 5 ++++-
 drivers/infiniband/core/verbs.c                 | 9 +++++++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c        | 3 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h        | 2 +-
 drivers/infiniband/hw/cxgb4/cq.c                | 3 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h          | 2 +-
 drivers/infiniband/hw/efa/efa.h                 | 2 +-
 drivers/infiniband/hw/efa/efa_verbs.c           | 3 ++-
 drivers/infiniband/hw/hns/hns_roce_cq.c         | 3 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h     | 4 ++--
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c      | 3 ++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       | 3 ++-
 drivers/infiniband/hw/mlx4/cq.c                 | 3 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h            | 2 +-
 drivers/infiniband/hw/mlx5/cq.c                 | 9 +++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h            | 2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c    | 3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     | 3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h     | 2 +-
 drivers/infiniband/hw/qedr/verbs.c              | 5 +++--
 drivers/infiniband/hw/qedr/verbs.h              | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    | 4 ++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h    | 2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c    | 3 ++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h | 2 +-
 drivers/infiniband/sw/rdmavt/cq.c               | 3 ++-
 drivers/infiniband/sw/rdmavt/cq.h               | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c           | 3 ++-
 drivers/infiniband/sw/siw/siw_verbs.c           | 3 ++-
 drivers/infiniband/sw/siw/siw_verbs.h           | 2 +-
 include/rdma/ib_verbs.h                         | 6 ++++--
 31 files changed, 66 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 2efe825689e3e..19e36e52181be 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -319,6 +319,8 @@ EXPORT_SYMBOL(__ib_alloc_cq_any);
  */
 void ib_free_cq(struct ib_cq *cq)
 {
+	int ret;
+
 	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
 		return;
 	if (WARN_ON_ONCE(cq->cqe_used))
@@ -340,8 +342,9 @@ void ib_free_cq(struct ib_cq *cq)
 
 	rdma_dim_destroy(cq);
 	trace_cq_free(cq);
+	ret = cq->device->ops.destroy_cq(cq, NULL);
+	WARN_ONCE(ret, "Destroy of kernel CQ shouldn't fail");
 	rdma_restrack_del(&cq->res);
-	cq->device->ops.destroy_cq(cq, NULL);
 	kfree(cq->wc);
 	kfree(cq);
 }
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 307886737646e..c8b650f240d5f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2011,16 +2011,21 @@ EXPORT_SYMBOL(rdma_set_cq_moderation);
 
 int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 {
+	int ret;
+
 	if (WARN_ON_ONCE(cq->shared))
 		return -EOPNOTSUPP;
 
 	if (atomic_read(&cq->usecnt))
 		return -EBUSY;
 
+	ret = cq->device->ops.destroy_cq(cq, udata);
+	if (ret)
+		return ret;
+
 	rdma_restrack_del(&cq->res);
-	cq->device->ops.destroy_cq(cq, udata);
 	kfree(cq);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(ib_destroy_cq_user);
 
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 1d7a9ca5240c5..e0d06899ad4f4 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2800,7 +2800,7 @@ int bnxt_re_post_recv(struct ib_qp *ib_qp, const struct ib_recv_wr *wr,
 }
 
 /* Completion Queues */
-void bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
+int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 {
 	struct bnxt_re_cq *cq;
 	struct bnxt_qplib_nq *nq;
@@ -2816,6 +2816,7 @@ void bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	atomic_dec(&rdev->cq_count);
 	nq->budget--;
 	kfree(cq->cql);
+	return 0;
 }
 
 int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 1daeb30e06fda..f1d98540fede5 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -193,7 +193,7 @@ int bnxt_re_post_recv(struct ib_qp *qp, const struct ib_recv_wr *recv_wr,
 		      const struct ib_recv_wr **bad_recv_wr);
 int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct ib_udata *udata);
-void bnxt_re_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int bnxt_re_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int bnxt_re_poll_cq(struct ib_cq *cq, int num_entries, struct ib_wc *wc);
 int bnxt_re_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 struct ib_mr *bnxt_re_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 352b8af1998a5..28349ed508854 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -967,7 +967,7 @@ int c4iw_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	return !err || err == -ENODATA ? npolled : err;
 }
 
-void c4iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
+int c4iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 {
 	struct c4iw_cq *chp;
 	struct c4iw_ucontext *ucontext;
@@ -985,6 +985,7 @@ void c4iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 		   ucontext ? &ucontext->uctx : &chp->cq.rdev->uctx,
 		   chp->destroy_skb, chp->wr_waitp);
 	c4iw_put_wr_wait(chp->wr_waitp);
+	return 0;
 }
 
 int c4iw_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 2b2b009b371af..a5975119b0d4c 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -992,7 +992,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
 					   struct ib_udata *udata);
 struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc);
 int c4iw_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata);
-void c4iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata);
+int c4iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata);
 int c4iw_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		   struct ib_udata *udata);
 int c4iw_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
index 1889dd172a252..05f593940e7b0 100644
--- a/drivers/infiniband/hw/efa/efa.h
+++ b/drivers/infiniband/hw/efa/efa.h
@@ -139,7 +139,7 @@ int efa_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata);
 struct ib_qp *efa_create_qp(struct ib_pd *ibpd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata);
-void efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
+int efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
 int efa_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		  struct ib_udata *udata);
 struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 9e201f1692892..61520521baccd 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -843,7 +843,7 @@ static int efa_destroy_cq_idx(struct efa_dev *dev, int cq_idx)
 	return efa_com_destroy_cq(&dev->edev, &params);
 }
 
-void efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+int efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 {
 	struct efa_dev *dev = to_edev(ibcq->device);
 	struct efa_cq *cq = to_ecq(ibcq);
@@ -856,6 +856,7 @@ void efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	efa_destroy_cq_idx(dev, cq->cq_idx);
 	efa_free_mapped(dev, cq->cpu_addr, cq->dma_addr, cq->size,
 			DMA_FROM_DEVICE);
+	return 0;
 }
 
 static int cq_mmap_entries_setup(struct efa_dev *dev, struct efa_cq *cq,
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index e87d616f79882..c5acf3332519b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -311,7 +311,7 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 	return ret;
 }
 
-void hns_roce_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
+int hns_roce_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ib_cq->device);
 	struct hns_roce_cq *hr_cq = to_hr_cq(ib_cq);
@@ -322,6 +322,7 @@ void hns_roce_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	free_cq_buf(hr_dev, hr_cq);
 	free_cq_db(hr_dev, hr_cq, udata);
 	free_cqc(hr_dev, hr_cq);
+	return 0;
 }
 
 void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn)
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 6edcbdcd8f432..6dc07bfb4daad 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -930,7 +930,7 @@ struct hns_roce_hw {
 	int (*poll_cq)(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 	int (*dereg_mr)(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr,
 			struct ib_udata *udata);
-	void (*destroy_cq)(struct ib_cq *ibcq, struct ib_udata *udata);
+	int (*destroy_cq)(struct ib_cq *ibcq, struct ib_udata *udata);
 	int (*modify_cq)(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 	int (*init_eq)(struct hns_roce_dev *hr_dev);
 	void (*cleanup_eq)(struct hns_roce_dev *hr_dev);
@@ -1247,7 +1247,7 @@ int to_hr_qp_type(int qp_type);
 int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 		       struct ib_udata *udata);
 
-void hns_roce_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata);
+int hns_roce_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata);
 int hns_roce_db_map_user(struct hns_roce_ucontext *context,
 			 struct ib_udata *udata, unsigned long virt,
 			 struct hns_roce_db *db);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index aeb3a6fa7d472..109f42458c026 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3572,7 +3572,7 @@ int hns_roce_v1_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	return 0;
 }
 
-static void hns_roce_v1_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+static int hns_roce_v1_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibcq->device);
 	struct hns_roce_cq *hr_cq = to_hr_cq(ibcq);
@@ -3603,6 +3603,7 @@ static void hns_roce_v1_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 		}
 		wait_time++;
 	}
+	return 0;
 }
 
 static void set_eq_cons_index_v1(struct hns_roce_eq *eq, int req_not)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index b51339328a51e..1321e3a36491b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1052,7 +1052,7 @@ void i40iw_cq_wq_destroy(struct i40iw_device *iwdev, struct i40iw_sc_cq *cq)
  * @ib_cq: cq pointer
  * @udata: user data or NULL for kernel object
  */
-static void i40iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
+static int i40iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 {
 	struct i40iw_cq *iwcq;
 	struct i40iw_device *iwdev;
@@ -1064,6 +1064,7 @@ static void i40iw_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	i40iw_cq_wq_destroy(iwdev, cq);
 	cq_free_resources(iwdev, iwcq);
 	i40iw_rem_devusecount(iwdev);
+	return 0;
 }
 
 /**
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 8a3436994f809..ee50dd823a8e8 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -475,7 +475,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 	return err;
 }
 
-void mlx4_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+int mlx4_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(cq->device);
 	struct mlx4_ib_cq *mcq = to_mcq(cq);
@@ -495,6 +495,7 @@ void mlx4_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 		mlx4_db_free(dev->dev, &mcq->db);
 	}
 	ib_umem_release(mcq->umem);
+	return 0;
 }
 
 static void dump_cqe(void *cqe)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 75af838365c93..41d8dcd005c0b 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -738,7 +738,7 @@ int mlx4_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
 int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct ib_udata *udata);
-void mlx4_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int mlx4_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int mlx4_ib_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b318bde2e565f..35e5bbb44d3d8 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1024,16 +1024,21 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	return err;
 }
 
-void mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
+	int ret;
+
+	ret = mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
+	if (ret)
+		return ret;
 
-	mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 	if (udata)
 		destroy_cq_user(mcq, udata);
 	else
 		destroy_cq_kernel(dev, mcq);
+	return 0;
 }
 
 static int is_equal_rsn(struct mlx5_cqe64 *cqe64, u32 rsn)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5287fc8686627..0d4b88389beb8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1148,7 +1148,7 @@ int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
 			 size_t buflen, size_t *bc);
 int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct ib_udata *udata);
-void mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
 int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 9fa2f9164a47b..2ad15adf304e5 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -789,7 +789,7 @@ static int mthca_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *uda
 	return ret;
 }
 
-static void mthca_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+static int mthca_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 {
 	if (udata) {
 		struct mthca_ucontext *context =
@@ -808,6 +808,7 @@ static void mthca_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 				    to_mcq(cq)->set_ci_db_index);
 	}
 	mthca_free_cq(to_mdev(cq->device), to_mcq(cq));
+	return 0;
 }
 
 static inline u32 convert_access(int acc)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index c1751c9a0f625..4ef5298247fcf 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1056,7 +1056,7 @@ static void ocrdma_flush_cq(struct ocrdma_cq *cq)
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 }
 
-void ocrdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+int ocrdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 {
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
 	struct ocrdma_eq *eq = NULL;
@@ -1081,6 +1081,7 @@ void ocrdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 				ocrdma_get_db_addr(dev, pdid),
 				dev->nic_info.db_page_size);
 	}
+	return 0;
 }
 
 static int ocrdma_add_qpn_map(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index df8e3b923a440..4322b5d792608 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -72,7 +72,7 @@ void ocrdma_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 int ocrdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		     struct ib_udata *udata);
 int ocrdma_resize_cq(struct ib_cq *, int cqe, struct ib_udata *);
-void ocrdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
+int ocrdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
 
 struct ib_qp *ocrdma_create_qp(struct ib_pd *,
 			       struct ib_qp_init_attr *attrs,
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index b49bef94637e5..9141a77534c7d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1051,7 +1051,7 @@ int qedr_resize_cq(struct ib_cq *ibcq, int new_cnt, struct ib_udata *udata)
 #define QEDR_DESTROY_CQ_MAX_ITERATIONS		(10)
 #define QEDR_DESTROY_CQ_ITER_DURATION		(10)
 
-void qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+int qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 {
 	struct qedr_dev *dev = get_qedr_dev(ibcq->device);
 	struct qed_rdma_destroy_cq_out_params oparams;
@@ -1066,7 +1066,7 @@ void qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	/* GSIs CQs are handled by driver, so they don't exist in the FW */
 	if (cq->cq_type == QEDR_CQ_TYPE_GSI) {
 		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
-		return;
+		return 0;
 	}
 
 	iparams.icid = cq->icid;
@@ -1114,6 +1114,7 @@ void qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	 * Since the destroy CQ ramrod has also been received on the EQ we can
 	 * be certain that there's no event handler in process.
 	 */
+	return 0;
 }
 
 static inline int get_gid_info_from_table(struct ib_qp *ibqp,
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 39dd6286ba395..b6d09f5376d81 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -52,7 +52,7 @@ void qedr_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		   struct ib_udata *udata);
 int qedr_resize_cq(struct ib_cq *, int cqe, struct ib_udata *);
-void qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
+int qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
 int qedr_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
 struct ib_qp *qedr_create_qp(struct ib_pd *, struct ib_qp_init_attr *attrs,
 			     struct ib_udata *);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index b8a77ce115908..586ff16be1bb3 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -596,9 +596,9 @@ int usnic_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	return 0;
 }
 
-void usnic_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+int usnic_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 {
-	return;
+	return 0;
 }
 
 struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 2aedf78c13cf2..f13b08c59b9a3 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -60,7 +60,7 @@ int usnic_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				int attr_mask, struct ib_udata *udata);
 int usnic_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		       struct ib_udata *udata);
-void usnic_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int usnic_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 				u64 virt_addr, int access_flags,
 				struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index 4f6cc0de7ef95..6d3e6389e47da 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -235,7 +235,7 @@ static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
  * @cq: the completion queue to destroy.
  * @udata: user data or null for kernel object
  */
-void pvrdma_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+int pvrdma_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 {
 	struct pvrdma_cq *vcq = to_vcq(cq);
 	union pvrdma_cmd_req req;
@@ -261,6 +261,7 @@ void pvrdma_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
 
 	pvrdma_free_cq(dev, vcq);
 	atomic_dec(&dev->num_cqs);
+	return 0;
 }
 
 static inline struct pvrdma_cqe *get_cqe(struct pvrdma_cq *cq, int i)
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
index 699b20849a7ef..61b8425d92c5e 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -411,7 +411,7 @@ int pvrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		     int sg_nents, unsigned int *sg_offset);
 int pvrdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		     struct ib_udata *udata);
-void pvrdma_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int pvrdma_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int pvrdma_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 int pvrdma_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 04d2e72017fed..19248be140933 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -315,7 +315,7 @@ int rvt_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
  *
  * Called by ib_destroy_cq() in the generic verbs code.
  */
-void rvt_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+int rvt_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 {
 	struct rvt_cq *cq = ibcq_to_rvtcq(ibcq);
 	struct rvt_dev_info *rdi = cq->rdi;
@@ -328,6 +328,7 @@ void rvt_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 		kref_put(&cq->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(cq->kqueue);
+	return 0;
 }
 
 /**
diff --git a/drivers/infiniband/sw/rdmavt/cq.h b/drivers/infiniband/sw/rdmavt/cq.h
index 5e26a2eb19a4c..feb01e7ee0044 100644
--- a/drivers/infiniband/sw/rdmavt/cq.h
+++ b/drivers/infiniband/sw/rdmavt/cq.h
@@ -53,7 +53,7 @@
 
 int rvt_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		  struct ib_udata *udata);
-void rvt_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
+int rvt_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
 int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags);
 int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 8522e9a3e9140..cfe115d64cb88 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -803,13 +803,14 @@ static int rxe_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	return rxe_add_to_pool(&rxe->cq_pool, &cq->pelem);
 }
 
-static void rxe_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+static int rxe_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 {
 	struct rxe_cq *cq = to_rcq(ibcq);
 
 	rxe_cq_disable(cq);
 
 	rxe_drop_ref(cq);
+	return 0;
 }
 
 static int rxe_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index adafa1b8bebe3..60271c30e7de5 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1055,7 +1055,7 @@ int siw_post_receive(struct ib_qp *base_qp, const struct ib_recv_wr *wr,
 	return rv > 0 ? 0 : rv;
 }
 
-void siw_destroy_cq(struct ib_cq *base_cq, struct ib_udata *udata)
+int siw_destroy_cq(struct ib_cq *base_cq, struct ib_udata *udata)
 {
 	struct siw_cq *cq = to_siw_cq(base_cq);
 	struct siw_device *sdev = to_siw_dev(base_cq->device);
@@ -1073,6 +1073,7 @@ void siw_destroy_cq(struct ib_cq *base_cq, struct ib_udata *udata)
 	atomic_dec(&sdev->num_cq);
 
 	vfree(cq->queue);
+	return 0;
 }
 
 /*
diff --git a/drivers/infiniband/sw/siw/siw_verbs.h b/drivers/infiniband/sw/siw/siw_verbs.h
index d9572275a6b69..476e9283fce25 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.h
+++ b/drivers/infiniband/sw/siw/siw_verbs.h
@@ -62,7 +62,7 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 		  const struct ib_send_wr **bad_wr);
 int siw_post_receive(struct ib_qp *base_qp, const struct ib_recv_wr *wr,
 		     const struct ib_recv_wr **bad_wr);
-void siw_destroy_cq(struct ib_cq *base_cq, struct ib_udata *udata);
+int siw_destroy_cq(struct ib_cq *base_cq, struct ib_udata *udata);
 int siw_poll_cq(struct ib_cq *base_cq, int num_entries, struct ib_wc *wc);
 int siw_req_notify_cq(struct ib_cq *base_cq, enum ib_cq_notify_flags flags);
 struct ib_mr *siw_reg_user_mr(struct ib_pd *base_pd, u64 start, u64 len,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1a3ef718c30b4..f64c1d02b9350 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2439,7 +2439,7 @@ struct ib_device_ops {
 	int (*create_cq)(struct ib_cq *cq, const struct ib_cq_init_attr *attr,
 			 struct ib_udata *udata);
 	int (*modify_cq)(struct ib_cq *cq, u16 cq_count, u16 cq_period);
-	void (*destroy_cq)(struct ib_cq *cq, struct ib_udata *udata);
+	int (*destroy_cq)(struct ib_cq *cq, struct ib_udata *udata);
 	int (*resize_cq)(struct ib_cq *cq, int cqe, struct ib_udata *udata);
 	struct ib_mr *(*get_dma_mr)(struct ib_pd *pd, int mr_access_flags);
 	struct ib_mr *(*reg_user_mr)(struct ib_pd *pd, u64 start, u64 length,
@@ -3905,7 +3905,9 @@ int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata);
  */
 static inline void ib_destroy_cq(struct ib_cq *cq)
 {
-	ib_destroy_cq_user(cq, NULL);
+	int ret = ib_destroy_cq_user(cq, NULL);
+
+	WARN_ONCE(ret, "Destroy of kernel CQ shouldn't fail");
 }
 
 /**
-- 
2.25.1



