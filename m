Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E11410B99F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfK0UzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbfK0UzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B5232070B;
        Wed, 27 Nov 2019 20:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888115;
        bh=blL2aDoHMdLG65fkrbWhUYWBxVjCgv/p6v3dzAKgrRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8xtkeL5mBBWqLctjXyfCJY9K0NZPBMLJLtPhoIguc9Ouhf6eOO4EBItB7FEIsS1+
         Ul+1EW1469TtwmdZhmQeTtp2dTNrOWSMuuSI2sFK4bmxOCJHLzhg+CWE3OSxv17CRH
         cFjqlzlLnrwNyVX9M9m2T9g0o5Uiixb1Iv+ZsbLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 003/306] net/mlx4_en: Fix wrong limitation for number of TX rings
Date:   Wed, 27 Nov 2019 21:27:33 +0100
Message-Id: <20191127203115.010578056@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 2744bf42680f64ebf2ee8a00354897857c073331 ]

XDP_TX rings should not be limited by max_num_tx_rings_p_up.
To make sure total number of TX rings never exceed MAX_TX_RINGS,
add similar check in mlx4_en_alloc_tx_queue_per_tc(), where
a new value is assigned for num_up.

Fixes: 7e1dc5e926d5 ("net/mlx4_en: Limit the number of TX rings")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    8 ++++----
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |    9 +++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1812,6 +1812,7 @@ static int mlx4_en_set_channels(struct n
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_en_port_profile new_prof;
 	struct mlx4_en_priv *tmp;
+	int total_tx_count;
 	int port_up = 0;
 	int xdp_count;
 	int err = 0;
@@ -1826,13 +1827,12 @@ static int mlx4_en_set_channels(struct n
 
 	mutex_lock(&mdev->state_lock);
 	xdp_count = priv->tx_ring_num[TX_XDP] ? channel->rx_count : 0;
-	if (channel->tx_count * priv->prof->num_up + xdp_count >
-	    priv->mdev->profile.max_num_tx_rings_p_up * priv->prof->num_up) {
+	total_tx_count = channel->tx_count * priv->prof->num_up + xdp_count;
+	if (total_tx_count > MAX_TX_RINGS) {
 		err = -EINVAL;
 		en_err(priv,
 		       "Total number of TX and XDP rings (%d) exceeds the maximum supported (%d)\n",
-		       channel->tx_count * priv->prof->num_up  + xdp_count,
-		       MAX_TX_RINGS);
+		       total_tx_count, MAX_TX_RINGS);
 		goto out;
 	}
 
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -92,6 +92,7 @@ int mlx4_en_alloc_tx_queue_per_tc(struct
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_en_port_profile new_prof;
 	struct mlx4_en_priv *tmp;
+	int total_count;
 	int port_up = 0;
 	int err = 0;
 
@@ -105,6 +106,14 @@ int mlx4_en_alloc_tx_queue_per_tc(struct
 				      MLX4_EN_NUM_UP_HIGH;
 	new_prof.tx_ring_num[TX] = new_prof.num_tx_rings_p_up *
 				   new_prof.num_up;
+	total_count = new_prof.tx_ring_num[TX] + new_prof.tx_ring_num[TX_XDP];
+	if (total_count > MAX_TX_RINGS) {
+		err = -EINVAL;
+		en_err(priv,
+		       "Total number of TX and XDP rings (%d) exceeds the maximum supported (%d)\n",
+		       total_count, MAX_TX_RINGS);
+		goto out;
+	}
 	err = mlx4_en_try_alloc_resources(priv, tmp, &new_prof, true);
 	if (err)
 		goto out;


