Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D80432BDC
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbfFCJMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbfFCJMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC50D27E5C;
        Mon,  3 Jun 2019 09:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553128;
        bh=MivKhZFqyVucaP+giaGMPW53cagxJeI36GhOt82tA+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkNtJuwk7f7LnHVvn5QigPj9kX9MUNYv989ArGYwXOV03dmGTPl8RUTi0u4QEWE0L
         GwRY6jt+X22CaXn+tbDW48feu4oAmos+Wthgx90EW665I0L1ZEu8yl/wPONaWsaXe/
         6h3YyVAMu3pdXPWhKNw+b22qvAW4X5McHfyqUDUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.0 23/36] net/mlx5e: Disable rxhash when CQE compress is enabled
Date:   Mon,  3 Jun 2019 11:09:11 +0200
Message-Id: <20190603090522.514888806@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
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
@@ -3789,6 +3789,12 @@ static netdev_features_t mlx5e_fix_featu
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
@@ -3915,6 +3921,9 @@ int mlx5e_hwstamp_set(struct mlx5e_priv
 	memcpy(&priv->tstamp, &config, sizeof(config));
 	mutex_unlock(&priv->state_lock);
 
+	/* might need to fix some features */
+	netdev_update_features(priv->netdev);
+
 	return copy_to_user(ifr->ifr_data, &config,
 			    sizeof(config)) ? -EFAULT : 0;
 }
@@ -4744,6 +4753,10 @@ static void mlx5e_build_nic_netdev(struc
 	if (!priv->channels.params.scatter_fcs_en)
 		netdev->features  &= ~NETIF_F_RXFCS;
 
+	/* prefere CQE compression over rxhash */
+	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
+		netdev->features &= ~NETIF_F_RXHASH;
+
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
 	if (FT_CAP(flow_modify_en) &&
 	    FT_CAP(modify_root) &&


