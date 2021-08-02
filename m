Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBBE3DD9E6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhHBOFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236236AbhHBODR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C50260FC4;
        Mon,  2 Aug 2021 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912635;
        bh=kd1hLX4M11TjdQFXZ/rH+ZxQIOVwfDD6rtdOon9Y/vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiZXediVyRrZLdyc8GEiNflAsgTRI/npJRkMKG46jWpTNMJ4a+EWB42+mlbnmBpVR
         3Zl8pyPWHzjkXjeurA6FT15ulQhOBGnETgQm6H78WloZrsKmzuhmoQ5a4pU7UeEcJS
         TkfdHqgz5rpP608RbgpjfN9nMWdPxc+8NP9J+aPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 081/104] net/mlx5e: Fix page allocation failure for trap-RQ over SF
Date:   Mon,  2 Aug 2021 15:45:18 +0200
Message-Id: <20210802134346.676325181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 497008e783452a2ec45c7ec5835cfe6950dcb097 ]

Set the correct device pointer to the trap-RQ, to allow access to
dma_mask and avoid allocation request with the wrong pci-dev.

WARNING: CPU: 1 PID: 12005 at kernel/dma/mapping.c:151 dma_map_page_attrs+0x139/0x1c0
...
all Trace:
<IRQ>
? __page_pool_alloc_pages_slow+0x5a/0x210
mlx5e_post_rx_wqes+0x258/0x400 [mlx5_core]
mlx5e_trap_napi_poll+0x44/0xc0 [mlx5_core]
__napi_poll+0x24/0x150
net_rx_action+0x22b/0x280
__do_softirq+0xc7/0x27e
do_softirq+0x61/0x80
</IRQ>
__local_bh_enable_ip+0x4b/0x50
mlx5e_handle_action_trap+0x2dd/0x4d0 [mlx5_core]
blocking_notifier_call_chain+0x5a/0x80
mlx5_devlink_trap_action_set+0x8b/0x100 [mlx5_core]

Fixes: 5543e989fe5e ("net/mlx5e: Add trap entity to ETH driver")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 86ab4e864fe6..7f94508594fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -37,7 +37,7 @@ static void mlx5e_init_trap_rq(struct mlx5e_trap *t, struct mlx5e_params *params
 	struct mlx5e_priv *priv = t->priv;
 
 	rq->wq_type      = params->rq_wq_type;
-	rq->pdev         = mdev->device;
+	rq->pdev         = t->pdev;
 	rq->netdev       = priv->netdev;
 	rq->priv         = priv;
 	rq->clock        = &mdev->clock;
-- 
2.30.2



