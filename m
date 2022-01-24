Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A296C49938B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385848AbiAXUel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34374 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383245AbiAXU1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:27:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26994B8122F;
        Mon, 24 Jan 2022 20:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD38C340E5;
        Mon, 24 Jan 2022 20:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056019;
        bh=yaoW4loiKLDQ8TDhfuDaLdRXEdMfMbdMT7Bt3+YHHRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvhvfVrj83MQP2VMTGXyCcOGJ4M6MtAzlBzUDZNOVNlMMBhaznDF9vsrOn2ff9Enx
         UPNXtYq38NJ6jpTkvuCQVecfFsI+FpeHrjYSkWyrGaggEs1QfbBeJfeyujmuMoX43i
         xknBfTzcWj09vpKA6I8Yx8vpRq/7RVQc8hTpjhiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 344/846] net/mlx5e: Sync VXLAN udp ports during uplink representor profile change
Date:   Mon, 24 Jan 2022 19:37:41 +0100
Message-Id: <20220124184112.796364992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 07f6dc4024ea1d2314b9c8b81fd4e492864fcca1 ]

Currently during NIC profile disablement all VXLAN udp ports offloaded to the
HW are flushed and during its enablement the driver send notification to
the stack to inform the core that the entire UDP tunnel port state has been
lost, uplink representor doesn't have the same behavior which can cause
VXLAN udp ports offload to be in bad state while moving between modes while
VXLAN interface exist.

Fixed by aligning the uplink representor profile behavior to the NIC behavior.

Fixes: 84db66124714 ("net/mlx5e: Move set vxlan nic info to profile init")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index edecd149dcab3..161b60e1139b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -50,6 +50,7 @@
 #include "fs_core.h"
 #include "lib/mlx5.h"
 #include "lib/devcom.h"
+#include "lib/vxlan.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
 #include "en_accel/ipsec.h"
@@ -1016,6 +1017,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
+	udp_tunnel_nic_reset_ntf(priv->netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -1037,6 +1039,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	mlx5e_rep_tc_disable(priv);
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
+	mlx5_vxlan_reset_to_default(mdev->vxlan);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
-- 
2.34.1



