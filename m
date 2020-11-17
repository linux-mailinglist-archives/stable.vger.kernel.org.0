Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8488F2B6343
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732606AbgKQNgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732594AbgKQNge (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9625020780;
        Tue, 17 Nov 2020 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620194;
        bh=KDaJ36HOU0J+L38cDQxvmXcf1S9qQ7cSSxD1VqPiRik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRSmQhEyVvZjERBTYPTo+MteHUAv+hx5d9qHHowpdOb+ZYCSwjTQRO4DsOYOMvI+t
         lFYczbLifbD9ysxA6MjUoq5RmmAxtk47i3ff9Vf3L0nwORSKRdUQUpK3RS7LK8fVd3
         4gvnBnumUj3xWfbTw+IKoWeTI6UPkK+BrbLgF83k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 138/255] net/mlx5e: Use spin_lock_bh for async_icosq_lock
Date:   Tue, 17 Nov 2020 14:04:38 +0100
Message-Id: <20201117122145.660947175@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit f42139ba49791ab6b12443c60044872705b74a1e ]

async_icosq_lock may be taken from softirq and non-softirq contexts. It
requires protection with spin_lock_bh, otherwise a softirq may be
triggered in the middle of the critical section, and it may deadlock if
it tries to take the same lock. This patch fixes such a scenario by
using spin_lock_bh to disable softirqs on that CPU while inside the
critical section.

Fixes: 8d94b590f1e4 ("net/mlx5e: Turn XSK ICOSQ into a general asynchronous one")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  4 ++--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 55e65a438de70..fcaeb30778bc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -122,9 +122,9 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	/* TX queue is created active. */
 
-	spin_lock(&c->async_icosq_lock);
+	spin_lock_bh(&c->async_icosq_lock);
 	mlx5e_trigger_irq(&c->async_icosq);
-	spin_unlock(&c->async_icosq_lock);
+	spin_unlock_bh(&c->async_icosq_lock);
 }
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 4d892f6cecb3e..4de70cee80c0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -36,9 +36,9 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state))
 			return 0;
 
-		spin_lock(&c->async_icosq_lock);
+		spin_lock_bh(&c->async_icosq_lock);
 		mlx5e_trigger_irq(&c->async_icosq);
-		spin_unlock(&c->async_icosq_lock);
+		spin_unlock_bh(&c->async_icosq_lock);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 6bbfcf18107d2..979ff5658a3f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -188,7 +188,7 @@ static int post_rx_param_wqes(struct mlx5e_channel *c,
 
 	err = 0;
 	sq = &c->async_icosq;
-	spin_lock(&c->async_icosq_lock);
+	spin_lock_bh(&c->async_icosq_lock);
 
 	cseg = post_static_params(sq, priv_rx);
 	if (IS_ERR(cseg))
@@ -199,7 +199,7 @@ static int post_rx_param_wqes(struct mlx5e_channel *c,
 
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
 unlock:
-	spin_unlock(&c->async_icosq_lock);
+	spin_unlock_bh(&c->async_icosq_lock);
 
 	return err;
 
@@ -265,10 +265,10 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 
 	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
 
-	spin_lock(&sq->channel->async_icosq_lock);
+	spin_lock_bh(&sq->channel->async_icosq_lock);
 
 	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
-		spin_unlock(&sq->channel->async_icosq_lock);
+		spin_unlock_bh(&sq->channel->async_icosq_lock);
 		err = -ENOSPC;
 		goto err_dma_unmap;
 	}
@@ -299,7 +299,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	icosq_fill_wi(sq, pi, &wi);
 	sq->pc++;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
-	spin_unlock(&sq->channel->async_icosq_lock);
+	spin_unlock_bh(&sq->channel->async_icosq_lock);
 
 	return 0;
 
@@ -360,7 +360,7 @@ static int resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx
 	err = 0;
 
 	sq = &c->async_icosq;
-	spin_lock(&c->async_icosq_lock);
+	spin_lock_bh(&c->async_icosq_lock);
 
 	cseg = post_static_params(sq, priv_rx);
 	if (IS_ERR(cseg)) {
@@ -372,7 +372,7 @@ static int resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
 	priv_rx->stats->tls_resync_res_ok++;
 unlock:
-	spin_unlock(&c->async_icosq_lock);
+	spin_unlock_bh(&c->async_icosq_lock);
 
 	return err;
 }
-- 
2.27.0



