Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D6023A6BF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHCMX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgHCMX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B43D0204EC;
        Mon,  3 Aug 2020 12:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457406;
        bh=wUGwfYYUp+m6tPyzzV64uHY20TtTjscM989H6gUPW8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpgHjDDSmqiqJp/XprRGGF0dhxRQjhPaDwlVsqEuhFv+fav6mJpxdqrn8wlySm4VP
         EOfNvijto2E56LFQ9zJQyA9AvAg07wcWbE0aA7GlroabJen8ceYqPTmq1PvFWd0KQT
         6FVdPU/zDjaCPJsLU4g2nU8LFmU2auzK4VrJjSWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 055/120] net/mlx5: E-switch, Destroy TSAR after reload interface
Date:   Mon,  3 Aug 2020 14:18:33 +0200
Message-Id: <20200803121905.474985067@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 0c2600c619578f759cf3d5192b01bd14e281f24c ]

When eswitch offloads is enabled, TSAR is created before reloading
the interfaces.
However when eswitch offloads mode is disabled, TSAR is disabled before
reloading the interfaces.

To keep the eswitch enable/disable sequence as mirror, destroy TSAR
after reloading the interfaces.

Fixes: 1bd27b11c1df ("net/mlx5: Introduce E-switch QoS management")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 459cd668b9e2f..3bb4f72b76da2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2206,8 +2206,6 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 	else if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		esw_offloads_disable(esw);
 
-	esw_destroy_tsar(esw);
-
 	old_mode = esw->mode;
 	esw->mode = MLX5_ESWITCH_NONE;
 
@@ -2217,6 +2215,8 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
+	esw_destroy_tsar(esw);
+
 	if (clear_vf)
 		mlx5_eswitch_clear_vf_vports_info(esw);
 }
-- 
2.25.1



