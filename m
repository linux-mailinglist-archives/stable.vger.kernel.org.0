Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFF713F6E3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgAPRBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388012AbgAPRBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 512F420728;
        Thu, 16 Jan 2020 17:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194068;
        bh=X5VRyzQa3hJjfuhA6NJZowxobC1AwamiQve1T3J5FX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQe7ER0lJaOKlesYPLdSPPYW/Bv5sXMdEdAKQpxPvlnDbfD2uN2+BAnSxUyWt432F
         RyoJdZ5HcJwLPyla3WcjIhjOyT2iMCKSqTaoGYLjNMk8Je/VsbQIs5PbAInAbSYoux
         cJcNw6W2ovVKBX1f9TTfkrEP9+p1mjtwjl8I9l28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bloch <markb@mellanox.com>, Bodong Wang <bodong@mellanox.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 178/671] RDMA/mlx5: Fix memory leak in case we fail to add an IB device
Date:   Thu, 16 Jan 2020 11:51:27 -0500
Message-Id: <20200116165940.10720-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

[ Upstream commit fc9e4477f924e84d7798f7a1d41401d699de1219 ]

Make sure the IB device is freed on failure.

Fixes: b5ca15ad7e61 ("IB/mlx5: Add proper representors support")
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 35a0e04c38f2..b841589c27c9 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -69,8 +69,10 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	ibdev->mdev = dev;
 	ibdev->num_ports = max(MLX5_CAP_GEN(dev, num_ports),
 			       MLX5_CAP_GEN(dev, num_vhca_ports));
-	if (!__mlx5_ib_add(ibdev, &rep_profile))
+	if (!__mlx5_ib_add(ibdev, &rep_profile)) {
+		ib_dealloc_device(&ibdev->ib_dev);
 		return -EINVAL;
+	}
 
 	rep->rep_if[REP_IB].priv = ibdev;
 
-- 
2.20.1

