Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6058C4095F7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346444AbhIMOqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347929AbhIMOof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 656FF63221;
        Mon, 13 Sep 2021 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541478;
        bh=PXziJmtkl+XFcSM8POICp1CVLjPKdzoifA5qF9uW2m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1GmrfTuqYvP++Fz8kaU54Vi9yTt52L1sOa63iCjxtmZdLLeFqDeFjBZvUTgYS+Ai
         YsIb72PcnmzWiTMdZtBdezMgvJysAXAL5DAe7e+mebySboYUXW0lThEN7KbRvUyo42
         9D511tZMoQO1IoSIIk2eSIxq8O2n0whOsP490bd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 272/334] net/mlx5e: Use correct eswitch for stack devices with lag
Date:   Mon, 13 Sep 2021 15:15:26 +0200
Message-Id: <20210913131122.614610595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

[ Upstream commit f9d196bd632b8b79261ec3366c30ec3923ea9a02 ]

If link aggregation is used within stack devices driver rejects encap
rules if PF of the VF tunnel device is down. This happens because route
resolved for other PF and its eswitch instance is used to determine
correct vport.
To fix that use devcom feature to retrieve other eswitch instance if
failed to find vport for the 1st eswitch and LAG is active.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d273758255c3..6eba574c5a36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1338,6 +1338,7 @@ bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_
 int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev, u16 *vport)
 {
 	struct mlx5e_priv *out_priv, *route_priv;
+	struct mlx5_devcom *devcom = NULL;
 	struct mlx5_core_dev *route_mdev;
 	struct mlx5_eswitch *esw;
 	u16 vhca_id;
@@ -1349,7 +1350,24 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	route_mdev = route_priv->mdev;
 
 	vhca_id = MLX5_CAP_GEN(route_mdev, vhca_id);
+	if (mlx5_lag_is_active(out_priv->mdev)) {
+		/* In lag case we may get devices from different eswitch instances.
+		 * If we failed to get vport num, it means, mostly, that we on the wrong
+		 * eswitch.
+		 */
+		err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+		if (err != -ENOENT)
+			return err;
+
+		devcom = out_priv->mdev->priv.devcom;
+		esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		if (!esw)
+			return -ENODEV;
+	}
+
 	err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+	if (devcom)
+		mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 	return err;
 }
 
-- 
2.30.2



