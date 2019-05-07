Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7453815C7D
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfEGGEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfEGFex (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92CD82087F;
        Tue,  7 May 2019 05:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207292;
        bh=a4H5CULv39sp8KR00NtKyYMyaXkXDngsu3n7oRSTwMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj2DNQ9TRAVzZLRKTVKps2X1+PN/phXjR0cf/tkd3BjRK9bvjwJM3oAh9ibZ2eEHO
         aZ8Rxim8lHmZmUrqL9zqNWbsx/iJ7nbDNwD6q907K+O5t9UTLXzRaMOvIMpMsXULYz
         oJOL0pcUs/iMgiB2cO08Z/iPf8CyvXoCncVHLNN4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guy Levi <guyle@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 67/99] IB/mlx5: Fix scatter to CQE in DCT QP creation
Date:   Tue,  7 May 2019 01:32:01 -0400
Message-Id: <20190507053235.29900-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guy Levi <guyle@mellanox.com>

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
index 497181f5ba09..c6bdd0d16c4b 100644
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
index 7db778d96ef5..afc88e6e172e 100644
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
index 87b3198f4b5d..f4d4010b7e3e 100644
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

