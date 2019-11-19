Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B851C1013E8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfKSF23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbfKSF22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9695D222A2;
        Tue, 19 Nov 2019 05:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141307;
        bh=6RLUYOd+55BxiGAIQcw1vnmloKHU8KBxLRqVQlwftq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGsZ6ziA38RsxwXpelPhrd8vfhRnlIF2K/T9azcMpuCEsdfDX2VlheBqUzUBzZWos
         xd9+raXUL6reKgTvA4x58BmS2XUASbzcOOrAFjV7x6WBsgZXwjdnvdowQUSiIG4E+S
         l2nYM66yZv4XDf1XVAauzUfhP13veTW9A+qT42lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/422] IB/mlx5: Change TX affinity assignment in RoCE LAG mode
Date:   Tue, 19 Nov 2019 06:15:13 +0100
Message-Id: <20191119051406.602047533@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Majd Dibbiny <majd@mellanox.com>

[ Upstream commit c6a21c3864fc7f5febae7d096cd136f397c791f2 ]

In the current code, the TX affinity is per RoCE device, which can cause
unfairness between different contexts. e.g. if we open two contexts, and
each open 10 QPs concurrently, all of the QPs of the first context might
end up on the first port instead of distributed on the two ports as
expected

To overcome this unfairness between processes, we maintain per device TX
affinity, and per process TX affinity.

The allocation algorithm is as follow:

1. Hold two tx_port_affinity atomic variables, one per RoCE device and one
   per ucontext. Both initialized to 0.

2. In mlx5_ib_alloc_ucontext do:
 2.1. ucontext.tx_port_affinity = device.tx_port_affinity
 2.2. device.tx_port_affinity += 1

3. In modify QP INIT2RST:
 3.1. qp.tx_port_affinity = ucontext.tx_port_affinity % MLX5_PORT_NUM
 3.2. ucontext.tx_port_affinity += 1

Signed-off-by: Majd Dibbiny <majd@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  8 ++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 ++-
 drivers/infiniband/hw/mlx5/qp.c      | 37 +++++++++++++++++++++++++---
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c05eae93170eb..f4ffdc588ea07 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1823,6 +1823,14 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	context->lib_caps = req.lib_caps;
 	print_lib_caps(dev, context->lib_caps);
 
+	if (mlx5_lag_is_active(dev->mdev)) {
+		u8 port = mlx5_core_native_port_num(dev->mdev);
+
+		atomic_set(&context->tx_port_affinity,
+			   atomic_add_return(
+				   1, &dev->roce[port].tx_port_affinity));
+	}
+
 	return &context->ibucontext;
 
 out_mdev:
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 941d1df54631a..6a060c84598fe 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -139,6 +139,8 @@ struct mlx5_ib_ucontext {
 	u64			lib_caps;
 	DECLARE_BITMAP(dm_pages, MLX5_MAX_MEMIC_PAGES);
 	u16			devx_uid;
+	/* For RoCE LAG TX affinity */
+	atomic_t		tx_port_affinity;
 };
 
 static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibucontext)
@@ -700,7 +702,7 @@ struct mlx5_roce {
 	rwlock_t		netdev_lock;
 	struct net_device	*netdev;
 	struct notifier_block	nb;
-	atomic_t		next_port;
+	atomic_t		tx_port_affinity;
 	enum ib_port_state last_port_state;
 	struct mlx5_ib_dev	*dev;
 	u8			native_port_num;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 900f85ce0fb08..2e7230392a498 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2910,6 +2910,37 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return 0;
 }
 
+static unsigned int get_tx_affinity(struct mlx5_ib_dev *dev,
+				    struct mlx5_ib_pd *pd,
+				    struct mlx5_ib_qp_base *qp_base,
+				    u8 port_num)
+{
+	struct mlx5_ib_ucontext *ucontext = NULL;
+	unsigned int tx_port_affinity;
+
+	if (pd && pd->ibpd.uobject && pd->ibpd.uobject->context)
+		ucontext = to_mucontext(pd->ibpd.uobject->context);
+
+	if (ucontext) {
+		tx_port_affinity = (unsigned int)atomic_add_return(
+					   1, &ucontext->tx_port_affinity) %
+					   MLX5_MAX_PORTS +
+				   1;
+		mlx5_ib_dbg(dev, "Set tx affinity 0x%x to qpn 0x%x ucontext %p\n",
+				tx_port_affinity, qp_base->mqp.qpn, ucontext);
+	} else {
+		tx_port_affinity =
+			(unsigned int)atomic_add_return(
+				1, &dev->roce[port_num].tx_port_affinity) %
+				MLX5_MAX_PORTS +
+			1;
+		mlx5_ib_dbg(dev, "Set tx affinity 0x%x to qpn 0x%x\n",
+				tx_port_affinity, qp_base->mqp.qpn);
+	}
+
+	return tx_port_affinity;
+}
+
 static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state,
@@ -2975,6 +3006,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (!context)
 		return -ENOMEM;
 
+	pd = get_pd(qp);
 	context->flags = cpu_to_be32(mlx5_st << 16);
 
 	if (!(attr_mask & IB_QP_PATH_MIG_STATE)) {
@@ -3003,9 +3035,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		    (ibqp->qp_type == IB_QPT_XRC_TGT)) {
 			if (mlx5_lag_is_active(dev->mdev)) {
 				u8 p = mlx5_core_native_port_num(dev->mdev);
-				tx_affinity = (unsigned int)atomic_add_return(1,
-						&dev->roce[p].next_port) %
-						MLX5_MAX_PORTS + 1;
+				tx_affinity = get_tx_affinity(dev, pd, base, p);
 				context->flags |= cpu_to_be32(tx_affinity << 24);
 			}
 		}
@@ -3063,7 +3093,6 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			goto out;
 	}
 
-	pd = get_pd(qp);
 	get_cqs(qp->ibqp.qp_type, qp->ibqp.send_cq, qp->ibqp.recv_cq,
 		&send_cq, &recv_cq);
 
-- 
2.20.1



