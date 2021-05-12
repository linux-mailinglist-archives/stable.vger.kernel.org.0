Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7C137CD6D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbhELQzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243891AbhELQmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A8061C5F;
        Wed, 12 May 2021 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835686;
        bh=O3iqQKkp/2XeSaGj/PCaKbkXMDqSstklYa7eVDsuQj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvIEKBgAYzHAZJ/L+w+mafxVJQsVPWhc5SzyPzQYgq/A0dJyqZ39Gh2cGRfp2yEcV
         12y4R41DMVrwwTwgEIBDMGKeUv89rBd/7OFFS7r+HKHarJ8gzwRDXJorgB2qYKm7wT
         0Br/4qu5jy7KyrFgii1tNjvrvAujisjbDfJ8Iark=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 443/677] RDMA/mlx5: Fix query RoCE port
Date:   Wed, 12 May 2021 16:48:09 +0200
Message-Id: <20210512144852.061071730@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 7852546f524595245382a919e752468f73421451 ]

mlx5_is_roce_enabled returns the devlink RoCE init value, therefore it
should be used only when driver is loaded. Instead we just need to read
the roce_en field.

In addition, rename mlx5_is_roce_enabled to mlx5_is_roce_init_enabled.

Fixes: 7a58779edd75 ("IB/mlx5: Improve query port for representor port")
Link: https://lore.kernel.org/r/20210304124517.1100608-2-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 +++---
 include/linux/mlx5/driver.h       | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0d69a697d75f..4be7bccefaa4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -499,7 +499,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
 				 &props->active_width, ext);
 
-	if (!dev->is_rep && mlx5_is_roce_enabled(mdev)) {
+	if (!dev->is_rep && dev->mdev->roce.roce_en) {
 		u16 qkey_viol_cntr;
 
 		props->port_cap_flags |= IB_PORT_CM_SUP;
@@ -4174,7 +4174,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 
 		/* Register only for native ports */
 		err = mlx5_add_netdev_notifier(dev, port_num);
-		if (err || dev->is_rep || !mlx5_is_roce_enabled(mdev))
+		if (err || dev->is_rep || !mlx5_is_roce_init_enabled(mdev))
 			/*
 			 * We don't enable ETH interface for
 			 * 1. IB representors
@@ -4711,7 +4711,7 @@ static int mlx5r_probe(struct auxiliary_device *adev,
 	dev->mdev = mdev;
 	dev->num_ports = num_ports;
 
-	if (ll == IB_LINK_LAYER_ETHERNET && !mlx5_is_roce_enabled(mdev))
+	if (ll == IB_LINK_LAYER_ETHERNET && !mlx5_is_roce_init_enabled(mdev))
 		profile = &raw_eth_profile;
 	else
 		profile = &pf_profile;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 53b89631a1d9..ab07f09f2bad 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1226,7 +1226,7 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
 
-static inline bool mlx5_is_roce_enabled(struct mlx5_core_dev *dev)
+static inline bool mlx5_is_roce_init_enabled(struct mlx5_core_dev *dev)
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	union devlink_param_value val;
-- 
2.30.2



