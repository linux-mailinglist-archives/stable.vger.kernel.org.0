Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82ED1F029
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbfEOLl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731786AbfEOL2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:28:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EBF2084A;
        Wed, 15 May 2019 11:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919730;
        bh=KLC6BQWde4LBvhsgm4LS88CDcXSeNDvL6sN9ngIrdIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URAFFn8OGJ8CK8s8kR+B1dwQ9pAyjm7u+bUb52RncnlgfWUjKiAefCqXPen8YMKgS
         /XTEI6kzqIaipcVWyonNWKggQdBOfsRe3Gw0XKDPFftK7wvTcYknYEEKMidMz/E1/5
         NMIrYSsIavXzZYNQyNZlicpubCmfNemOPt+miLcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guy Levi <guyle@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 070/137] IB/mlx5: Fix scatter to CQE in DCT QP creation
Date:   Wed, 15 May 2019 12:55:51 +0200
Message-Id: <20190515090658.524283824@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7249c8ea227a582c14f63e9e8853eb7369122f10 ]

When scatter to CQE is enabled on a DCT QP it corrupts the mailbox command
since it tried to treat it as as QP create mailbox command instead of a
DCT create command.

The corrupted mailbox command causes userspace to malfunction as the
device doesn't create the QP as expected.

A new mlx5 capability is exposed to user-space which ensures that it will
not enable the feature on DCT without this fix in the kernel.

Fixes: 5d6ff1babe78 ("IB/mlx5: Support scatter to CQE for DC transport type")
Signed-off-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c |  2 ++
 drivers/infiniband/hw/mlx5/qp.c   | 11 +++++++----
 include/uapi/rdma/mlx5-abi.h      |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 497181f5ba091..c6bdd0d16c4b6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1025,6 +1025,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (MLX5_CAP_GEN(mdev, qp_packet_based))
 			resp.flags |=
 				MLX5_IB_QUERY_DEV_RESP_PACKET_BASED_CREDIT_MODE;
+
+		resp.flags |= MLX5_IB_QUERY_DEV_RESP_FLAGS_SCAT2CQE_DCT;
 	}
 
 	if (field_avail(typeof(resp), sw_parsing_caps,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7db778d96ef5c..afc88e6e172e7 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1724,13 +1724,16 @@ static void configure_responder_scat_cqe(struct ib_qp_init_attr *init_attr,
 
 	rcqe_sz = mlx5_ib_get_cqe_size(init_attr->recv_cq);
 
-	if (rcqe_sz == 128) {
-		MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
+	if (init_attr->qp_type == MLX5_IB_QPT_DCT) {
+		if (rcqe_sz == 128)
+			MLX5_SET(dctc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
+
 		return;
 	}
 
-	if (init_attr->qp_type != MLX5_IB_QPT_DCT)
-		MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA32_CQE);
+	MLX5_SET(qpc, qpc, cs_res,
+		 rcqe_sz == 128 ? MLX5_RES_SCAT_DATA64_CQE :
+				  MLX5_RES_SCAT_DATA32_CQE);
 }
 
 static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 87b3198f4b5d7..f4d4010b7e3e5 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -238,6 +238,7 @@ enum mlx5_ib_query_dev_resp_flags {
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
 	MLX5_IB_QUERY_DEV_RESP_PACKET_BASED_CREDIT_MODE = 1 << 2,
+	MLX5_IB_QUERY_DEV_RESP_FLAGS_SCAT2CQE_DCT = 1 << 3,
 };
 
 enum mlx5_ib_tunnel_offloads {
-- 
2.20.1



