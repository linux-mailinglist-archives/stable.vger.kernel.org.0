Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539571B0AE4
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgDTMr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgDTMr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:47:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D17920735;
        Mon, 20 Apr 2020 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386877;
        bh=tb3CnhTugsxZ6NffsdRP741CxsICEx1/rAvamSN6nAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKsFVnDSqCpgxmsMTB1yKuOIx4+YZOraTs4kbuGd9mtYHIzfzEHF48fsEfU0kTFDL
         enMTO3mdw6/h1nLbsfKST0HdNWV12D59X3CV7LDCwKXRIpWZg2Axuf3tEyuL3Coj4M
         /qWeoY9Jk7XFn8noueRZ8VFKUsuqEuoj4kgmVcPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/60] net/mlx5e: Encapsulate updating netdev queues into a function
Date:   Mon, 20 Apr 2020 14:39:26 +0200
Message-Id: <20200420121513.432501744@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit c2c95271f9f39ea9b34db2301b3b6c5105cdb447 ]

As a preparation for one of the following commits, create a function to
encapsulate the code that notifies the kernel about the new amount of
RX and TX queues. The code will be called multiple times in the next
commit.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ee7c753e9ea04..dc456a222c48d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2897,6 +2897,17 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
+static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
+{
+	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
+	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
+	struct net_device *netdev = priv->netdev;
+
+	mlx5e_netdev_set_tcs(netdev);
+	netif_set_real_num_tx_queues(netdev, num_txqs);
+	netif_set_real_num_rx_queues(netdev, num_rxqs);
+}
+
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
 	int i, ch;
@@ -2918,13 +2929,7 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
-	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
-	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
-	struct net_device *netdev = priv->netdev;
-
-	mlx5e_netdev_set_tcs(netdev);
-	netif_set_real_num_tx_queues(netdev, num_txqs);
-	netif_set_real_num_rx_queues(netdev, num_rxqs);
+	mlx5e_update_netdev_queues(priv);
 
 	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
-- 
2.20.1



