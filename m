Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9659A396199
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbhEaOns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233673AbhEaOli (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:41:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796E861919;
        Mon, 31 May 2021 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469229;
        bh=ar+aDV48hz+TlJIly4vTP7FKaU4frXR+kFh9l1z7fSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7fRD+1jcpKX9um6wEPC7NExmyvL9lAFC4/jJrifUFpB5E1/JxClXlNHGQ1kHW2XO
         9kWqkqZCLZ7gm8KGQ79myPddhnZtE22tdLUNj00wMlkG2DjYI8zxV1pqIv0LM2y1gs
         3uixIvDmAOeDetJQ+fqNhO0FdPAvteICoWQvCUgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH 5.12 118/296] net/mlx5e: reset XPS on error flow if netdev isnt registered yet
Date:   Mon, 31 May 2021 15:12:53 +0200
Message-Id: <20210531130707.885383533@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

commit 77ecd10d0a8aaa6e4871d8c63626e4c9fc5e47db upstream.

mlx5e_attach_netdev can be called prior to registering the netdevice:
Example stack:

ipoib_new_child_link ->
ipoib_intf_init->
rdma_init_netdev->
mlx5_rdma_setup_rn->

mlx5e_attach_netdev->
mlx5e_num_channels_changed ->
mlx5e_set_default_xps_cpumasks ->
netif_set_xps_queue ->
__netif_set_xps_queue -> kmalloc

If any later stage fails at any point after mlx5e_num_channels_changed()
returns, XPS allocated maps will never be freed as they
are only freed during netdev unregistration, which will never happen for
yet to be registered netdevs.

Fixes: 3909a12e7913 ("net/mlx5e: Fix configuration of XPS cpumasks and netdev queues in corner cases")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5604,6 +5604,11 @@ static void mlx5e_update_features(struct
 	rtnl_unlock();
 }
 
+static void mlx5e_reset_channels(struct net_device *netdev)
+{
+	netdev_reset_tc(netdev);
+}
+
 int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
 	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
@@ -5658,6 +5663,7 @@ err_cleanup_tx:
 	profile->cleanup_tx(priv);
 
 out:
+	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
@@ -5675,6 +5681,7 @@ void mlx5e_detach_netdev(struct mlx5e_pr
 
 	profile->cleanup_rx(priv);
 	profile->cleanup_tx(priv);
+	mlx5e_reset_channels(priv->netdev);
 	cancel_work_sync(&priv->update_stats_work);
 }
 


