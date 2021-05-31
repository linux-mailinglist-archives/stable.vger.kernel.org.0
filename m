Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF9D395E54
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhEaN5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhEaNzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0DC6143E;
        Mon, 31 May 2021 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468048;
        bh=auPDlSkBHh/2qxmhAoXyu3jcfuFKyKBpO/M1guYP74M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a64ifoQ+VbWJRFJsHbJewTcYjQ8yH4RqsZhDwSt4iYzsET5NvJCIW2rsVu5mbWqvB
         3t29czVB90n5kt7DBH/VvavPjpaJ60VH/cLRBlbreBF9d+VZUFmg8Ynfq7G38ONiJe
         FYMoB2nn+iR7WKVG6koKxO5vYuCzzKg3FmPeuDDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH 5.10 097/252] net/mlx5e: reset XPS on error flow if netdev isnt registered yet
Date:   Mon, 31 May 2021 15:12:42 +0200
Message-Id: <20210531130701.279525401@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -5385,6 +5385,11 @@ err_free_netdev:
 	return NULL;
 }
 
+static void mlx5e_reset_channels(struct net_device *netdev)
+{
+	netdev_reset_tc(netdev);
+}
+
 int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
 	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
@@ -5438,6 +5443,7 @@ err_cleanup_tx:
 	profile->cleanup_tx(priv);
 
 out:
+	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
@@ -5455,6 +5461,7 @@ void mlx5e_detach_netdev(struct mlx5e_pr
 
 	profile->cleanup_rx(priv);
 	profile->cleanup_tx(priv);
+	mlx5e_reset_channels(priv->netdev);
 	cancel_work_sync(&priv->update_stats_work);
 }
 


