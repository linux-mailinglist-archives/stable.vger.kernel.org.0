Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27921FB17
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgGNS6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731224AbgGNS6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC9F207F5;
        Tue, 14 Jul 2020 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753116;
        bh=ZRVe7wtzGG6LClUzL+VdbD6hONZdEGckQng5JJBKQms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkVANOgpzAoK1eVJBpJC1aTGmXXJxPlYi0X+DB1C1DgQFHu7d2blLHBQEShdvfPK/
         RFKD/We6vkZXHuL8AO0Ge4Xk+9cWUMiTR1NP7MhqY/oW7O1ZV1B3JwSjLmESvpmLaw
         AxiEQpLxUS8oY3Jmn1AzPrfDeFl3wntofP1xFC5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 095/166] net/mlx5e: Fix VXLAN configuration restore after function reload
Date:   Tue, 14 Jul 2020 20:44:20 +0200
Message-Id: <20200714184120.394132366@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit b3c2ed21c0bdf35ba498a9974aa587f99a03b658 ]

When detaching netdev, remove vxlan port configuration using
udp_tunnel_drop_rx_info. During function reload, configuration will be
restored using udp_tunnel_get_rx_info. This ensures sync between
firmware and driver. Use udp_tunnel_get_rx_info even if its physical
interface is down.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bd8d0e0960857..02f6b6bd2847c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3076,9 +3076,6 @@ int mlx5e_open(struct net_device *netdev)
 		mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_UP);
 	mutex_unlock(&priv->state_lock);
 
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_get_rx_info(netdev);
-
 	return err;
 }
 
@@ -5207,6 +5204,8 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
+	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
+		udp_tunnel_get_rx_info(netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -5223,6 +5222,8 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(priv->netdev))
 		mlx5e_close(priv->netdev);
+	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
+		udp_tunnel_drop_rx_info(priv->netdev);
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
-- 
2.25.1



