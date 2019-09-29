Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517A7C14C8
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfI2N6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB533218AC;
        Sun, 29 Sep 2019 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765485;
        bh=9yPm1IJyCjBeuT1DNNd+4QnQf1LL8wT5YuQd7tmix7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=areWyMVAuL/DxvGNBz0YYp4CZb3yCgQbNCzCByIpNSIfz35eJYrMqlEscRjvAoBMu
         Zh2sgKcTEmMfnT+J4Yr9dLBwDL7o2/d1SrvUjlN0nUuvY8QoVlutdlRLPRztMdDrRG
         I2fliySoXLUdBq9FLgNJ4DJ9LF/mxXy75qYpgILA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 18/63] net/mlx5e: Allow reporting of checksum unnecessary
Date:   Sun, 29 Sep 2019 15:53:51 +0200
Message-Id: <20190929135035.463440362@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit b856df28f9230a47669efbdd57896084caadb2b3 ]

Currently we practically never report checksum unnecessary, because
for all IP packets we take the checksum complete path.

Enable non-default runs with reprorting checksum unnecessary, using
an ethtool private flag. This can be useful for performance evals
and other explorations.

Required by downstream patch which fixes XDP checksum.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |    3 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   27 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    4 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      |    3 ++
 4 files changed, 37 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -210,6 +210,7 @@ static const char mlx5e_priv_flags[][ETH
 	"tx_cqe_moder",
 	"rx_cqe_compress",
 	"rx_striding_rq",
+	"rx_no_csum_complete",
 };
 
 enum mlx5e_priv_flag {
@@ -217,6 +218,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_TX_CQE_BASED_MODER = (1 << 1),
 	MLX5E_PFLAG_RX_CQE_COMPRESS = (1 << 2),
 	MLX5E_PFLAG_RX_STRIDING_RQ = (1 << 3),
+	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE = (1 << 4),
 };
 
 #define MLX5E_SET_PFLAG(params, pflag, enable)			\
@@ -298,6 +300,7 @@ struct mlx5e_dcbx_dp {
 enum {
 	MLX5E_RQ_STATE_ENABLED,
 	MLX5E_RQ_STATE_AM,
+	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 };
 
 struct mlx5e_cq {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1510,6 +1510,27 @@ static int set_pflag_rx_striding_rq(stru
 	return 0;
 }
 
+static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_channels *channels = &priv->channels;
+	struct mlx5e_channel *c;
+	int i;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	for (i = 0; i < channels->num; i++) {
+		c = channels->c[i];
+		if (enable)
+			__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+		else
+			__clear_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+	}
+
+	return 0;
+}
+
 static int mlx5e_handle_pflag(struct net_device *netdev,
 			      u32 wanted_flags,
 			      enum mlx5e_priv_flag flag,
@@ -1561,6 +1582,12 @@ static int mlx5e_set_priv_flags(struct n
 	err = mlx5e_handle_pflag(netdev, pflags,
 				 MLX5E_PFLAG_RX_STRIDING_RQ,
 				 set_pflag_rx_striding_rq);
+	if (err)
+		goto out;
+
+	err = mlx5e_handle_pflag(netdev, pflags,
+				 MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
+				 set_pflag_rx_no_csum_complete);
 
 out:
 	mutex_unlock(&priv->state_lock);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -934,6 +934,9 @@ static int mlx5e_open_rq(struct mlx5e_ch
 	if (params->rx_dim_enabled)
 		__set_bit(MLX5E_RQ_STATE_AM, &c->rq.state);
 
+	if (params->pflags & MLX5E_PFLAG_RX_NO_CSUM_COMPLETE)
+		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
+
 	return 0;
 
 err_destroy_rq:
@@ -4533,6 +4536,7 @@ void mlx5e_build_nic_params(struct mlx5_
 		params->rx_cqe_compress_def = slow_pci_heuristic(mdev);
 
 	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS, params->rx_cqe_compress_def);
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE, false);
 
 	/* RQ */
 	/* Prefer Striding RQ, unless any of the following holds:
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -754,6 +754,9 @@ static inline void mlx5e_handle_csum(str
 		return;
 	}
 
+	if (unlikely(test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state)))
+		goto csum_unnecessary;
+
 	/* CQE csum doesn't cover padding octets in short ethernet
 	 * frames. And the pad field is appended prior to calculating
 	 * and appending the FCS field.


