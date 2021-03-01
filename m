Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5680E328F13
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbhCATmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242150AbhCATf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFBCD64F81;
        Mon,  1 Mar 2021 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621081;
        bh=PTCBi/GVgem+Bk2B9zCfWIWjs1KVNTZ4eZHkt4j8MFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYrg8uXidP3fOuECjfQ6+LyaW0CjpA4NuFcwQHgIg7hitCdpCiyX46YwSu8uIkopf
         JscrV2Zbjl/xWxGFma82Tts4KKJo67ihROAakPM7vKdXcLf0GNsSXjOFGUjOTH4yjM
         E4m3o/KiZm0tkzVAgPOCl/7/r+wHHmRXUUDlbhsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 386/775] RDMA/mlx5: Allow creating all QPs even when non RDMA profile is used
Date:   Mon,  1 Mar 2021 17:09:14 +0100
Message-Id: <20210301161220.680978793@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
 drivers/infiniband/hw/mlx5/qp.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0cb7cc642d87d..bab40ad527dae 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2432,9 +2432,6 @@ static int check_qp_type(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	case MLX5_IB_QPT_HW_GSI:
 	case IB_QPT_DRIVER:
 	case IB_QPT_GSI:
-		if (dev->profile == &raw_eth_profile)
-			goto out;
-		fallthrough;
 	case IB_QPT_RAW_PACKET:
 	case IB_QPT_UD:
 	case MLX5_IB_QPT_REG_UMR:
@@ -2629,10 +2626,6 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	int create_flags = attr->create_flags;
 	bool cond;
 
-	if (qp->type == IB_QPT_UD && dev->profile == &raw_eth_profile)
-		if (create_flags & ~MLX5_IB_QP_CREATE_WC_TEST)
-			return -EINVAL;
-
 	if (qp_type == MLX5_IB_QPT_DCT)
 		return (create_flags) ? -EINVAL : 0;
 
@@ -4211,6 +4204,23 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
@@ -4223,6 +4233,9 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int err = -EINVAL;
 	int port;
 
+	if (!mlx5_ib_modify_qp_allowed(dev, qp, ibqp->qp_type))
+		return -EOPNOTSUPP;
+
 	if (attr_mask & ~(IB_QP_ATTR_STANDARD_BITS | IB_QP_RATE_LIMIT))
 		return -EOPNOTSUPP;
 
-- 
2.27.0



