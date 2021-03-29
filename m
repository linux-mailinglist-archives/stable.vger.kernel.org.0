Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D8E34C8FD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhC2IZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhC2IYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2389661613;
        Mon, 29 Mar 2021 08:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006246;
        bh=A+J6a3yoK0zjhH69Ld2rTJGXFsaXp/84hjC1JUYiDn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAWk0p4MLUtTAvmmmkujpabe6yWBFYzJJ2j13Tuszxma7Bebg0UzH2DGhsUwUsNHs
         g5njAwq68J0sICRPXQIAo68xMiwtobROabMLN/Z4wYzKTdCbQOvDuiBUlBDqJJOuD+
         NLWvVnj6fEbLDuNfzSydBS+rqV/1FnpmEWD+/mUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Nguyen <huyn@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/221] net/mlx5: Add back multicast stats for uplink representor
Date:   Mon, 29 Mar 2021 09:58:21 +0200
Message-Id: <20210329075634.824293479@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

[ Upstream commit a07231084da2207629b42244380ae2f1e10bd9b4 ]

The multicast counter got removed from uplink representor due to the
cited patch.

Fixes: 47c97e6b10a1 ("net/mlx5e: Fix multicast counter not up-to-date in "ip -s"")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0dc572aaf177..e2006c6053c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3666,10 +3666,17 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	}
 
 	if (mlx5e_is_uplink_rep(priv)) {
+		struct mlx5e_vport_stats *vstats = &priv->stats.vport;
+
 		stats->rx_packets = PPORT_802_3_GET(pstats, a_frames_received_ok);
 		stats->rx_bytes   = PPORT_802_3_GET(pstats, a_octets_received_ok);
 		stats->tx_packets = PPORT_802_3_GET(pstats, a_frames_transmitted_ok);
 		stats->tx_bytes   = PPORT_802_3_GET(pstats, a_octets_transmitted_ok);
+
+		/* vport multicast also counts packets that are dropped due to steering
+		 * or rx out of buffer
+		 */
+		stats->multicast = VPORT_COUNTER_GET(vstats, received_eth_multicast.packets);
 	} else {
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
-- 
2.30.1



