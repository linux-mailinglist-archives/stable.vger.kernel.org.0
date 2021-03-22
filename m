Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A83D34425A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhCVMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231963AbhCVMjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F20C619C4;
        Mon, 22 Mar 2021 12:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416693;
        bh=GaYubZUfGfHNa855R3fiJFI6qyDaYzuNHGaK9TiWbuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXzqREBB3Brk87pTKn2BnQgLLvTmkMC3qm2knhfBmKZBsc49TU/3xOr0jZWjcEYeG
         GpvH2hVgnuUCI7u9RgrAq6M7odM0cenJ1uXERVTiToxDFyPm13QQFeY8nlfjjmxqn8
         l5yegfPPOdfcXL70EO1JH4GcitsdxSi4D8UjsDSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/157] RDMA/mlx5: Allow creating all QPs even when non RDMA profile is used
Date:   Mon, 22 Mar 2021 13:27:22 +0100
Message-Id: <20210322121936.486843189@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 2614488d1f3cd5989375042286b11424208e20c8 ]

The cited commit disallowed creating any QP which isn't raw ethernet, reg
umr or the special UD qp for testing WC, this proved too strict.

While modify can't be done (no GIDS/GID table for example) just creating a
QP is okay.

This patch partially reverts the bellow mentioned commit and places the
restriction at the modify QP stage and not at the creation.  DEVX commands
should be used to manipulate such QPs.

Fixes: 42caf9cb5937 ("RDMA/mlx5: Allow only raw Ethernet QPs when RoCE isn't enabled")
Link: https://lore.kernel.org/r/20210125120709.836718-1-leon@kernel.org
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 600e056798c0..75caeec378bd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2458,8 +2458,6 @@ static int check_qp_type(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	case MLX5_IB_QPT_HW_GSI:
 	case IB_QPT_DRIVER:
 	case IB_QPT_GSI:
-		if (dev->profile == &raw_eth_profile)
-			goto out;
 	case IB_QPT_RAW_PACKET:
 	case IB_QPT_UD:
 	case MLX5_IB_QPT_REG_UMR:
@@ -2654,10 +2652,6 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	int create_flags = attr->create_flags;
 	bool cond;
 
-	if (qp->type == IB_QPT_UD && dev->profile == &raw_eth_profile)
-		if (create_flags & ~MLX5_IB_QP_CREATE_WC_TEST)
-			return -EINVAL;
-
 	if (qp_type == MLX5_IB_QPT_DCT)
 		return (create_flags) ? -EINVAL : 0;
 
@@ -4235,6 +4229,23 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return 0;
 }
 
+static bool mlx5_ib_modify_qp_allowed(struct mlx5_ib_dev *dev,
+				      struct mlx5_ib_qp *qp,
+				      enum ib_qp_type qp_type)
+{
+	if (dev->profile != &raw_eth_profile)
+		return true;
+
+	if (qp_type == IB_QPT_RAW_PACKET || qp_type == MLX5_IB_QPT_REG_UMR)
+		return true;
+
+	/* Internal QP used for wc testing, with NOPs in wq */
+	if (qp->flags & MLX5_IB_QP_CREATE_WC_TEST)
+		return true;
+
+	return false;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -4247,6 +4258,9 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int err = -EINVAL;
 	int port;
 
+	if (!mlx5_ib_modify_qp_allowed(dev, qp, ibqp->qp_type))
+		return -EOPNOTSUPP;
+
 	if (ibqp->rwq_ind_tbl)
 		return -ENOSYS;
 
-- 
2.30.1



