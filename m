Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5145BAA81
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIPKZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiIPKW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84CB14D5;
        Fri, 16 Sep 2022 03:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4AB62A30;
        Fri, 16 Sep 2022 10:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201BC433C1;
        Fri, 16 Sep 2022 10:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323241;
        bh=W44Slu9eH0mSP7OmDkx/8OSNh3zd3onwObzTdf2VhQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kO9EacOQl4HMhqH54e7z/oRfcAQEF6qOjATeYcV+PnToVxOCU6khuLWFJJb/Z5LVO
         xC1B0KlS0BnP/4F5EQIb+BPBFDGaWh2cVbgMFVH8HPpufE4qFUfY3nkBUnsesQi5bC
         4OiE/pRuDsTAv3cxVKl/xs10XsXjFyYjFzQb3/YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 05/38] RDMA/mlx5: Add a umr recovery flow
Date:   Fri, 16 Sep 2022 12:08:39 +0200
Message-Id: <20220916100448.664816105@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit 158e71bb69e368b8b33e8b7c4ac8c111da0c1ae2 ]

When a UMR fails, the UMR QP state changes to an error state. Therefore,
all the further UMR operations will fail too.

Add a recovery flow to the UMR QP, and repost the flushed WQEs.

Link: https://lore.kernel.org/r/6cc24816cca049bd8541317f5e41d3ac659445d3.1652588303.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 9b7d4be967f1 ("RDMA/mlx5: Fix UMR cleanup on error flow of driver init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c      |  4 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 12 ++++-
 drivers/infiniband/hw/mlx5/umr.c     | 78 ++++++++++++++++++++++++----
 3 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 08371a80fdc26..be189e0525de6 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -523,6 +523,10 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 			    "Requestor" : "Responder", cq->mcq.cqn);
 		mlx5_ib_dbg(dev, "syndrome 0x%x, vendor syndrome 0x%x\n",
 			    err_cqe->syndrome, err_cqe->vendor_err_synd);
+		if (wc->status != IB_WC_WR_FLUSH_ERR &&
+		    (*cur_qp)->type == MLX5_IB_QPT_REG_UMR)
+			dev->umrc.state = MLX5_UMR_STATE_RECOVER;
+
 		if (opcode == MLX5_CQE_REQ_ERR) {
 			wq = &(*cur_qp)->sq;
 			wqe_ctr = be16_to_cpu(cqe64->wqe_counter);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 998b67509a533..7460e0dfe6db4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -717,13 +717,23 @@ struct mlx5_ib_umr_context {
 	struct completion	done;
 };
 
+enum {
+	MLX5_UMR_STATE_ACTIVE,
+	MLX5_UMR_STATE_RECOVER,
+	MLX5_UMR_STATE_ERR,
+};
+
 struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
 	struct ib_qp	*qp;
-	/* control access to UMR QP
+	/* Protects from UMR QP overflow
 	 */
 	struct semaphore	sem;
+	/* Protects from using UMR while the UMR is not active
+	 */
+	struct mutex lock;
+	unsigned int state;
 };
 
 struct mlx5_cache_ent {
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 3a48364c09181..e00b94d1b1ea1 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -176,6 +176,7 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 	dev->umrc.pd = pd;
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
+	mutex_init(&dev->umrc.lock);
 
 	return 0;
 
@@ -195,6 +196,31 @@ void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev)
 	ib_dealloc_pd(dev->umrc.pd);
 }
 
+static int mlx5r_umr_recover(struct mlx5_ib_dev *dev)
+{
+	struct umr_common *umrc = &dev->umrc;
+	struct ib_qp_attr attr;
+	int err;
+
+	attr.qp_state = IB_QPS_RESET;
+	err = ib_modify_qp(umrc->qp, &attr, IB_QP_STATE);
+	if (err) {
+		mlx5_ib_dbg(dev, "Couldn't modify UMR QP\n");
+		goto err;
+	}
+
+	err = mlx5r_umr_qp_rst2rts(dev, umrc->qp);
+	if (err)
+		goto err;
+
+	umrc->state = MLX5_UMR_STATE_ACTIVE;
+	return 0;
+
+err:
+	umrc->state = MLX5_UMR_STATE_ERR;
+	return err;
+}
+
 static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 			       struct mlx5r_umr_wqe *wqe, bool with_data)
 {
@@ -231,7 +257,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 
 	id.ib_cqe = cqe;
 	mlx5r_finish_wqe(qp, ctrl, seg, size, cur_edge, idx, id.wr_id, 0,
-			 MLX5_FENCE_MODE_NONE, MLX5_OPCODE_UMR);
+			 MLX5_FENCE_MODE_INITIATOR_SMALL, MLX5_OPCODE_UMR);
 
 	mlx5r_ring_db(qp, 1, ctrl);
 
@@ -270,17 +296,49 @@ static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
 	mlx5r_umr_init_context(&umr_context);
 
 	down(&umrc->sem);
-	err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context.cqe, wqe,
-				  with_data);
-	if (err)
-		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
-	else {
-		wait_for_completion(&umr_context.done);
-		if (umr_context.status != IB_WC_SUCCESS) {
-			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
-				     umr_context.status);
+	while (true) {
+		mutex_lock(&umrc->lock);
+		if (umrc->state == MLX5_UMR_STATE_ERR) {
+			mutex_unlock(&umrc->lock);
 			err = -EFAULT;
+			break;
+		}
+
+		if (umrc->state == MLX5_UMR_STATE_RECOVER) {
+			mutex_unlock(&umrc->lock);
+			usleep_range(3000, 5000);
+			continue;
+		}
+
+		err = mlx5r_umr_post_send(umrc->qp, mkey, &umr_context.cqe, wqe,
+					  with_data);
+		mutex_unlock(&umrc->lock);
+		if (err) {
+			mlx5_ib_warn(dev, "UMR post send failed, err %d\n",
+				     err);
+			break;
 		}
+
+		wait_for_completion(&umr_context.done);
+
+		if (umr_context.status == IB_WC_SUCCESS)
+			break;
+
+		if (umr_context.status == IB_WC_WR_FLUSH_ERR)
+			continue;
+
+		WARN_ON_ONCE(1);
+		mlx5_ib_warn(dev,
+			"reg umr failed (%u). Trying to recover and resubmit the flushed WQEs\n",
+			umr_context.status);
+		mutex_lock(&umrc->lock);
+		err = mlx5r_umr_recover(dev);
+		mutex_unlock(&umrc->lock);
+		if (err)
+			mlx5_ib_warn(dev, "couldn't recover UMR, err %d\n",
+				     err);
+		err = -EFAULT;
+		break;
 	}
 	up(&umrc->sem);
 	return err;
-- 
2.35.1



