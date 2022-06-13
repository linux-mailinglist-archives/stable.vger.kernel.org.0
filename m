Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E24548E3D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383022AbiFMO0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383551AbiFMOXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1D246669;
        Mon, 13 Jun 2022 04:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0440AB80D3A;
        Mon, 13 Jun 2022 11:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49454C34114;
        Mon, 13 Jun 2022 11:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120661;
        bh=fyF6ZafSSVtoQczLF3XDgEWBjw8lV67X+kwcOUhgbEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN2xXYAXEACKW8KbmHeKBC96V+frycE+1dq4NaniIKBe7h2jRwxzFLww/2sdAdLXA
         ywr+FmQFoQmXtKD1Q+LGU3eZchzRj8T7aSwn55uzfMvQY0BRD0MbwwkDi14szjLR9j
         zI1JNxm1K0Q1GG7cvT+7qSfzQAn1W28ErXPzWsjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Karsten Nielsen <karsten@foo-bar.dk>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 111/298] net/mlx5e: Disable softirq in mlx5e_activate_rq to avoid race condition
Date:   Mon, 13 Jun 2022 12:10:05 +0200
Message-Id: <20220613094928.313983168@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 2e642afb61b24401a7ec819d27ddcd69c7c29784 ]

When the driver activates the channels, it assumes NAPI isn't running
yet. mlx5e_activate_rq posts a NOP WQE to ICOSQ to trigger a hardware
interrupt and start NAPI, which will run mlx5e_alloc_rx_mpwqe and post
UMR WQEs to ICOSQ to be able to receive packets with striding RQ.

Unfortunately, a race condition is possible if NAPI is triggered by
something else (for example, TX) at a bad timing, before
mlx5e_activate_rq finishes. In this case, mlx5e_alloc_rx_mpwqe may post
UMR WQEs to ICOSQ, and with the bad timing, the wqe_info of the first
UMR may be overwritten by the wqe_info of the NOP posted by
mlx5e_activate_rq.

The consequence is that icosq->db.wqe_info[0].num_wqebbs will be changed
from MLX5E_UMR_WQEBBS to 1, disrupting the integrity of the array-based
linked list in wqe_info[]. mlx5e_poll_ico_cq will hang in an infinite
loop after processing wqe_info[0], because after the corruption, the
next item to be processed will be wqe_info[1], which is filled with
zeros, and `sqcc += wi->num_wqebbs` will never move further.

This commit fixes this race condition by using async_icosq to post the
NOP and trigger the interrupt. async_icosq is always protected with a
spinlock, eliminating the race condition.

Fixes: bc77b240b3c5 ("net/mlx5e: Add fragmented memory support for RX multi packet WQE")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reported-by: Karsten Nielsen <karsten@foo-bar.dk>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |  6 +++++
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.c |  1 +
 .../mellanox/mlx5/core/en/xsk/setup.c         |  5 +---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++++++++++++------
 7 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5ccd6c634274..4c8c8e4c1ef3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -730,6 +730,7 @@ struct mlx5e_rq {
 	u8                     wq_type;
 	u32                    rqn;
 	struct mlx5_core_dev  *mdev;
+	struct mlx5e_channel  *channel;
 	u32  umr_mkey;
 	struct mlx5e_dma_info  wqe_overflow;
 
@@ -1044,6 +1045,9 @@ void mlx5e_close_cq(struct mlx5e_cq *cq);
 int mlx5e_open_locked(struct net_device *netdev);
 int mlx5e_close_locked(struct net_device *netdev);
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c);
+void mlx5e_trigger_napi_sched(struct napi_struct *napi);
+
 int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs);
 void mlx5e_close_channels(struct mlx5e_channels *chs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 82baafd3c00c..fdb82f2b0130 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -737,6 +737,7 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		mlx5e_ptp_rx_set_fs(c->priv);
 		mlx5e_activate_rq(&c->rq);
+		mlx5e_trigger_napi_sched(&c->napi);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 2684e9da9f41..fc366e66d0b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -123,6 +123,8 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		xskrq->stats->recover++;
 	}
 
+	mlx5e_trigger_napi_icosq(icosq->channel);
+
 	mutex_unlock(&icosq->channel->icosq_recovery_lock);
 
 	return 0;
@@ -166,6 +168,10 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
+	if (rq->channel)
+		mlx5e_trigger_napi_icosq(rq->channel);
+	else
+		mlx5e_trigger_napi_sched(rq->cq.napi);
 	return 0;
 out:
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index a55b066746cb..6dd36e3cf425 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -172,6 +172,7 @@ static void mlx5e_activate_trap(struct mlx5e_trap *trap)
 {
 	napi_enable(&trap->napi);
 	mlx5e_activate_rq(&trap->rq);
+	mlx5e_trigger_napi_sched(&trap->napi);
 }
 
 void mlx5e_deactivate_trap(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 279cd8f4e79f..2c520394aa1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -117,6 +117,7 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 		goto err_remove_pool;
 
 	mlx5e_activate_xsk(c);
+	mlx5e_trigger_napi_icosq(c);
 
 	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
 	 * any Fill Ring entries at the setup stage.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 25eac9e20342..5a2cd15e245d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -64,6 +64,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	rq->clock        = &mdev->clock;
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
+	rq->channel      = c;
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
@@ -179,10 +180,6 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	mlx5e_reporter_icosq_resume_recovery(c);
 
 	/* TX queue is created active. */
-
-	spin_lock_bh(&c->async_icosq_lock);
-	mlx5e_trigger_irq(&c->async_icosq);
-	spin_unlock_bh(&c->async_icosq_lock);
 }
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 531fffe1abe3..9730bd96d0de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -477,6 +477,7 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->clock        = &mdev->clock;
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
+	rq->channel      = c;
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
@@ -1070,13 +1071,6 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	if (rq->icosq) {
-		mlx5e_trigger_irq(rq->icosq);
-	} else {
-		local_bh_disable();
-		napi_schedule(rq->cq.napi);
-		local_bh_enable();
-	}
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
@@ -2218,6 +2212,20 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 	return 0;
 }
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+{
+	spin_lock_bh(&c->async_icosq_lock);
+	mlx5e_trigger_irq(&c->async_icosq);
+	spin_unlock_bh(&c->async_icosq_lock);
+}
+
+void mlx5e_trigger_napi_sched(struct napi_struct *napi)
+{
+	local_bh_disable();
+	napi_schedule(napi);
+	local_bh_enable();
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -2299,6 +2307,8 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_activate_xsk(c);
+
+	mlx5e_trigger_napi_icosq(c);
 }
 
 static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
-- 
2.35.1



