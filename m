Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D2C14CA
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfI2N6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A9BC21882;
        Sun, 29 Sep 2019 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765489;
        bh=GdIffLFp64U+qmVRRNCys33kBb0lfwiyi8JcL2Ho3nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMH9AaGGtzkPxYdD7RuwUUyq5ddF7o+Lz98kfeLxdhaUYreqm9bGCadmrPfz8j/mq
         GKz+5JjYApggN8nO2U3hG6+5Cnvxwi8Mu/+fGpoApZ/wtTH39eBvNjXAuFOFWjn65F
         3VAXlULlccylxQkqzjFqSGtkWunyi8WY5v8iPHqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 19/63] net/mlx5e: XDP, Avoid checksum complete when XDP prog is loaded
Date:   Sun, 29 Sep 2019 15:53:52 +0200
Message-Id: <20190929135035.712772979@linuxfoundation.org>
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

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit 5d0bb3bac4b9f6c22280b04545626fdfd99edc6b ]

XDP programs might change packets data contents which will make the
reported skb checksum (checksum complete) invalid.

When XDP programs are loaded/unloaded set/clear rx RQs
MLX5E_RQ_STATE_NO_CSUM_COMPLETE flag.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1517,7 +1517,8 @@ static int set_pflag_rx_no_csum_complete
 	struct mlx5e_channel *c;
 	int i;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) ||
+	    priv->channels.params.xdp_prog)
 		return 0;
 
 	for (i = 0; i < channels->num; i++) {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -934,7 +934,11 @@ static int mlx5e_open_rq(struct mlx5e_ch
 	if (params->rx_dim_enabled)
 		__set_bit(MLX5E_RQ_STATE_AM, &c->rq.state);
 
-	if (params->pflags & MLX5E_PFLAG_RX_NO_CSUM_COMPLETE)
+	/* We disable csum_complete when XDP is enabled since
+	 * XDP programs might manipulate packets which will render
+	 * skb->checksum incorrect.
+	 */
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE) || c->xdp)
 		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
 
 	return 0;
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -754,7 +754,8 @@ static inline void mlx5e_handle_csum(str
 		return;
 	}
 
-	if (unlikely(test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state)))
+	/* True when explicitly set via priv flag, or XDP prog is loaded */
+	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state))
 		goto csum_unnecessary;
 
 	/* CQE csum doesn't cover padding octets in short ethernet


