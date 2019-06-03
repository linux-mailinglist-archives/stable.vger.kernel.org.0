Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E88C32BA2
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfFCJKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfFCJKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4CC27E2B;
        Mon,  3 Jun 2019 09:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553012;
        bh=OkSZOmrzbRtglGgaWTCASBVMjYEU2o0yP0IEyf5sVKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGXnNZwjGw8zthhsQSjYJLs7dW5l2929U+eneJ9oHEXDolUiffKQj78E261l08P8E
         NJLxrXMVPvDo9X1Pd7nCC3TbqJZqMkABWxTXYxKP3mqceRWeCAqYWMZ043cLPbH4xk
         DCYh83ibvQ2dTVbfEtvPVtPK+9lkZh+oLbqG5TCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 21/32] net/mlx5e: Disable rxhash when CQE compress is enabled
Date:   Mon,  3 Jun 2019 11:08:15 +0200
Message-Id: <20190603090313.925496353@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit c0194e2d0ef0e5ce5e21a35640d23a706827ae28 ]

When CQE compression is enabled (Multi-host systems), compressed CQEs
might arrive to the driver rx, compressed CQEs don't have a valid hash
offload and the driver already reports a hash value of 0 and invalid hash
type on the skb for compressed CQEs, but this is not good enough.

On a congested PCIe, where CQE compression will kick in aggressively,
gro will deliver lots of out of order packets due to the invalid hash
and this might cause a serious performance drop.

The only valid solution, is to disable rxhash offload at all when CQE
compression is favorable (Multi-host systems).

Fixes: 7219ab34f184 ("net/mlx5e: CQE compression")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3734,6 +3734,12 @@ static netdev_features_t mlx5e_fix_featu
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
 	}
 
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
+		features &= ~NETIF_F_RXHASH;
+		if (netdev->features & NETIF_F_RXHASH)
+			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
+	}
+
 	mutex_unlock(&priv->state_lock);
 
 	return features;
@@ -3860,6 +3866,9 @@ int mlx5e_hwstamp_set(struct mlx5e_priv
 	memcpy(&priv->tstamp, &config, sizeof(config));
 	mutex_unlock(&priv->state_lock);
 
+	/* might need to fix some features */
+	netdev_update_features(priv->netdev);
+
 	return copy_to_user(ifr->ifr_data, &config,
 			    sizeof(config)) ? -EFAULT : 0;
 }
@@ -4702,6 +4711,10 @@ static void mlx5e_build_nic_netdev(struc
 	if (!priv->channels.params.scatter_fcs_en)
 		netdev->features  &= ~NETIF_F_RXFCS;
 
+	/* prefere CQE compression over rxhash */
+	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
+		netdev->features &= ~NETIF_F_RXHASH;
+
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
 	if (FT_CAP(flow_modify_en) &&
 	    FT_CAP(modify_root) &&


