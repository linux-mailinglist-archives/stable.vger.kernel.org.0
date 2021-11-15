Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EE545138F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348418AbhKOTwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343657AbhKOTVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A4C661B73;
        Mon, 15 Nov 2021 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001831;
        bh=jgtdFHWad0yJAjM7WHVurYxDgjs3ar6sNYcAa6QGDec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4dgVx57DMFfIupaV68wjD2GXX+OA+dMs59KpT8HoxBu0cQ7bMO79sR/neKCT8GNN
         EeVH69gU6vPXAlFlmTdse1lMls05amKyG1dE/jSq4mX3QxNOM365hLn88ege9NvSaQ
         bEBWuWesrC9eC4Twa4URWDntmdr9I1Qprgpi7UUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/917] net/mlx5: Publish and unpublish all devlink parameters at once
Date:   Mon, 15 Nov 2021 17:57:11 +0100
Message-Id: <20211115165440.148870423@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e9310aed8e6a5003abb2aa6b9229d2fb9ceb9e85 ]

The devlink parameters were published in two steps despite being static
and known in advance.

First step was to use devlink_params_publish() which iterated over all
known up to that point parameters and sent notification messages.
In second step, the call was devlink_param_publish() that looped over
same parameters list and sent notification for new parameters.

In order to simplify the API, move devlink_params_publish() to be called
when all parameters were already added and save the need to iterate over
parameters list again.

As a side effect, this change fixes the error unwind flow in which
parameters were not marked as unpublished.

Fixes: 82e6c96f04e1 ("net/mlx5: Register to devlink ingress VLAN filter trap")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index dcf9f27ba2efd..7d56a927081d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -625,7 +625,6 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 					   value);
-	devlink_param_publish(devlink, &enable_eth_param);
 	return 0;
 }
 
@@ -636,7 +635,6 @@ static void mlx5_devlink_eth_param_unregister(struct devlink *devlink)
 	if (!mlx5_eth_supported(dev))
 		return;
 
-	devlink_param_unpublish(devlink, &enable_eth_param);
 	devlink_param_unregister(devlink, &enable_eth_param);
 }
 
@@ -672,7 +670,6 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 					   value);
-	devlink_param_publish(devlink, &enable_rdma_param);
 	return 0;
 }
 
@@ -681,7 +678,6 @@ static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return;
 
-	devlink_param_unpublish(devlink, &enable_rdma_param);
 	devlink_param_unregister(devlink, &enable_rdma_param);
 }
 
@@ -706,7 +702,6 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 					   value);
-	devlink_param_publish(devlink, &enable_rdma_param);
 	return 0;
 }
 
@@ -717,7 +712,6 @@ static void mlx5_devlink_vnet_param_unregister(struct devlink *devlink)
 	if (!mlx5_vnet_supported(dev))
 		return;
 
-	devlink_param_unpublish(devlink, &enable_vnet_param);
 	devlink_param_unregister(devlink, &enable_vnet_param);
 }
 
@@ -808,7 +802,6 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
-	devlink_params_publish(devlink);
 
 	err = mlx5_devlink_auxdev_params_register(devlink);
 	if (err)
@@ -818,6 +811,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	devlink_params_publish(devlink);
 	return 0;
 
 traps_reg_err:
@@ -832,9 +826,9 @@ params_reg_err:
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_params_unpublish(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
-	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
-- 
2.33.0



