Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D413813806F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgAKK3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731272AbgAKK3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:29:38 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD7520880;
        Sat, 11 Jan 2020 10:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738577;
        bh=eey/jIOQdDv4cfBwSo8CUBqPBv1XGXv1qTVhHdX9euA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oXReLlWjuJvGIyJEXQeG4cdBvHw/IfUY1vwGhIYw8pgVRn9cgPmIxwluwV4CuS/T
         UK4+cugxz8gBQL5ffWhPV+4x0+gqlyHCdYmlDEU3Q/um2YU8qjp48icywxPqun77na
         MKkwMkAg8PoZU5rtoIbgruhjkOQeFZizYA9/d5SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/165] net/mlx5e: Fix concurrency issues between config flow and XSK
Date:   Sat, 11 Jan 2020 10:50:39 +0100
Message-Id: <20200111094933.573141698@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 9cf88808ad6a0f1e958e00abd9a081295fe6da0c ]

After disabling resources necessary for XSK (the XDP program, channels,
XSK queues), use synchronize_rcu to wait until the XSK wakeup function
finishes, before freeing the resources.

Suspend XSK wakeups during switching channels. If the XDP program is
being removed, synchronize_rcu before closing the old channels to allow
XSK wakeup to complete.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191217162023.16011-3-maximmi@mellanox.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 22 ++++++++-----------
 .../mellanox/mlx5/core/en/xsk/setup.c         |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +---------------
 5 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2c16add0b642..9c8427698238 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -760,7 +760,7 @@ enum {
 	MLX5E_STATE_OPENED,
 	MLX5E_STATE_DESTROYING,
 	MLX5E_STATE_XDP_TX_ENABLED,
-	MLX5E_STATE_XDP_OPEN,
+	MLX5E_STATE_XDP_ACTIVE,
 };
 
 struct mlx5e_rqt {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 36ac1e3816b9..d7587f40ecae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -75,12 +75,18 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 static inline void mlx5e_xdp_tx_enable(struct mlx5e_priv *priv)
 {
 	set_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
+
+	if (priv->channels.params.xdp_prog)
+		set_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 }
 
 static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
 {
+	if (priv->channels.params.xdp_prog)
+		clear_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
+
 	clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
-	/* let other device's napi(s) see our new state */
+	/* Let other device's napi(s) and XSK wakeups see our new state. */
 	synchronize_rcu();
 }
 
@@ -89,19 +95,9 @@ static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
 	return test_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
 }
 
-static inline void mlx5e_xdp_set_open(struct mlx5e_priv *priv)
-{
-	set_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
-}
-
-static inline void mlx5e_xdp_set_closed(struct mlx5e_priv *priv)
-{
-	clear_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
-}
-
-static inline bool mlx5e_xdp_is_open(struct mlx5e_priv *priv)
+static inline bool mlx5e_xdp_is_active(struct mlx5e_priv *priv)
 {
-	return test_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
+	return test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 }
 
 static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 631af8dee517..c28cbae42331 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -144,6 +144,7 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with the XSK wakeup. */
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 87827477d38c..fe2d596cb361 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -14,7 +14,7 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 	struct mlx5e_channel *c;
 	u16 ix;
 
-	if (unlikely(!mlx5e_xdp_is_open(priv)))
+	if (unlikely(!mlx5e_xdp_is_active(priv)))
 		return -ENETDOWN;
 
 	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6abd4ed5b69b..29a5a8c894e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3002,12 +3002,9 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
 int mlx5e_open_locked(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	bool is_xdp = priv->channels.params.xdp_prog;
 	int err;
 
 	set_bit(MLX5E_STATE_OPENED, &priv->state);
-	if (is_xdp)
-		mlx5e_xdp_set_open(priv);
 
 	err = mlx5e_open_channels(priv, &priv->channels);
 	if (err)
@@ -3022,8 +3019,6 @@ int mlx5e_open_locked(struct net_device *netdev)
 	return 0;
 
 err_clear_state_opened_flag:
-	if (is_xdp)
-		mlx5e_xdp_set_closed(priv);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 	return err;
 }
@@ -3055,8 +3050,6 @@ int mlx5e_close_locked(struct net_device *netdev)
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
-	if (priv->channels.params.xdp_prog)
-		mlx5e_xdp_set_closed(priv);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 
 	netif_carrier_off(priv->netdev);
@@ -4373,16 +4366,6 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 	return 0;
 }
 
-static int mlx5e_xdp_update_state(struct mlx5e_priv *priv)
-{
-	if (priv->channels.params.xdp_prog)
-		mlx5e_xdp_set_open(priv);
-	else
-		mlx5e_xdp_set_closed(priv);
-
-	return 0;
-}
-
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4422,7 +4405,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
 		old_prog = priv->channels.params.xdp_prog;
 
-		err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_xdp_update_state);
+		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
 		if (err)
 			goto unlock;
 	} else {
-- 
2.20.1



