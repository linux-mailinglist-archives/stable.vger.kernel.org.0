Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5802A45C53D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349237AbhKXNzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354946AbhKXNxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:53:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02B6613BD;
        Wed, 24 Nov 2021 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759134;
        bh=vFWHXoUKoZuVIQdbVNlvJF6CP13I3Fuew/yVWzsUYV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncwWd/pBf/DU7N+jLtg84oqOcUIH7OGQObuK+qBCQJUCZiCO7R1ZbsVGT6wJNSyUa
         n843M4tfzla+gcGBMTg9XJrMoB/ZSJ5AyjlcMdP7GMQEQexju9Nd/7NOS8ogunPUyS
         Z14rGQDnYsSA+ln4j/w7i5AKWEacv1qT7wRClBRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/279] net/mlx5e: kTLS, Fix crash in RX resync flow
Date:   Wed, 24 Nov 2021 12:57:10 +0100
Message-Id: <20211124115723.721582529@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit cc4a9cc03faa6d8db1a6954bb536f2c1e63bdff6 ]

For the TLS RX resync flow, we maintain a list of TLS contexts
that require some attention, to communicate their resync information
to the HW.
Here we fix list corruptions, by protecting the entries against
movements coming from resync_handle_seq_match(), until their resync
handling in napi is fully completed.

Fixes: e9ce991bce5b ("net/mlx5e: kTLS, Add resiliency to RX resync failures")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 62abce008c7b8..a2a9f68579dd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -55,6 +55,7 @@ struct mlx5e_ktls_offload_context_rx {
 	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
 
 	/* resync */
+	spinlock_t lock; /* protects resync fields */
 	struct mlx5e_ktls_rx_resync_ctx resync;
 	struct list_head list;
 };
@@ -386,14 +387,18 @@ static void resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_r
 	struct mlx5e_icosq *sq;
 	bool trigger_poll;
 
-	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
-
 	sq = &c->async_icosq;
 	ktls_resync = sq->ktls_resync;
+	trigger_poll = false;
 
 	spin_lock_bh(&ktls_resync->lock);
-	list_add_tail(&priv_rx->list, &ktls_resync->list);
-	trigger_poll = !test_and_set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+	spin_lock_bh(&priv_rx->lock);
+	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
+	if (list_empty(&priv_rx->list)) {
+		list_add_tail(&priv_rx->list, &ktls_resync->list);
+		trigger_poll = !test_and_set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+	}
+	spin_unlock_bh(&priv_rx->lock);
 	spin_unlock_bh(&ktls_resync->lock);
 
 	if (!trigger_poll)
@@ -617,6 +622,8 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	if (err)
 		goto err_create_key;
 
+	INIT_LIST_HEAD(&priv_rx->list);
+	spin_lock_init(&priv_rx->lock);
 	priv_rx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 
@@ -730,10 +737,14 @@ bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
 		priv_rx = list_first_entry(&local_list,
 					   struct mlx5e_ktls_offload_context_rx,
 					   list);
+		spin_lock(&priv_rx->lock);
 		cseg = post_static_params(sq, priv_rx);
-		if (IS_ERR(cseg))
+		if (IS_ERR(cseg)) {
+			spin_unlock(&priv_rx->lock);
 			break;
-		list_del(&priv_rx->list);
+		}
+		list_del_init(&priv_rx->list);
+		spin_unlock(&priv_rx->lock);
 		db_cseg = cseg;
 	}
 	if (db_cseg)
-- 
2.33.0



