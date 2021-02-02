Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461AE30C019
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhBBNtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:49:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhBBNrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF7964F8B;
        Tue,  2 Feb 2021 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273304;
        bh=jP7fZIXhdK5COjES+69/BN7RqLDAwdvlJFvS6c+pagU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkU/AHOSDRm+6qPzF6OqbKU8OKrALMJ+juLYPy5MoZIvfkDSC88e0WfMS5BJPnwIT
         n6dJXuMNLgNK8LJOpjHz2bCD44eGSitrFch27eDckxT3WjohuUJjQdogWfcIXH4oYp
         03wGroB8Dv/rAdcAm4ihmoGeJdKm2SnRloIcyVIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Raed Salem <raeds@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 057/142] net/mlx5e: Fix IPSEC stats
Date:   Tue,  2 Feb 2021 14:37:00 +0100
Message-Id: <20210202133000.071154537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

commit 45c9a30835d84009dfe711f5c8836720767c286e upstream.

When IPSEC offload isn't active, the number of stats is not zero, but
the strings are not filled, leading to exposing stats with empty names.
Fix this by using the same condition for NUM_STATS and FILL_STRS.

Fixes: 0aab3e1b04ae ("net/mlx5e: IPSec, Expose IPsec HW stat only for supporting HW")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -76,7 +76,7 @@ static const struct counter_desc mlx5e_i
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_sw)
 {
-	return NUM_IPSEC_SW_COUNTERS;
+	return priv->ipsec ? NUM_IPSEC_SW_COUNTERS : 0;
 }
 
 static inline MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_sw) {}
@@ -105,7 +105,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_S
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_hw)
 {
-	return (mlx5_fpga_ipsec_device_caps(priv->mdev)) ? NUM_IPSEC_HW_COUNTERS : 0;
+	return (priv->ipsec && mlx5_fpga_ipsec_device_caps(priv->mdev)) ? NUM_IPSEC_HW_COUNTERS : 0;
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_hw)


