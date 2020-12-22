Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9779F2DEF49
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgLSM7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgLSM7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:12 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.9 26/49] net/mlx4_en: Handle TX error CQE
Date:   Sat, 19 Dec 2020 13:58:30 +0100
Message-Id: <20201219125345.958958829@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit ba603d9d7b1215c72513d7c7aa02b6775fd4891b ]

In case error CQE was found while polling TX CQ, the QP is in error
state and all posted WQEs will generate error CQEs without any data
transmitted. Fix it by reopening the channels, via same method used for
TX timeout handling.

In addition add some more info on error CQE and WQE for debug.

Fixes: bd2f631d7c60 ("net/mlx4_en: Notify user when TX ring in error state")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    1 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c     |   40 ++++++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    5 +++
 3 files changed, 39 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1735,6 +1735,7 @@ int mlx4_en_start_port(struct net_device
 				mlx4_en_deactivate_cq(priv, cq);
 				goto tx_err;
 			}
+			clear_bit(MLX4_EN_TX_RING_STATE_RECOVERING, &tx_ring->state);
 			if (t != TX_XDP) {
 				tx_ring->tx_queue = netdev_get_tx_queue(dev, i);
 				tx_ring->recycle_ring = NULL;
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -392,6 +392,35 @@ int mlx4_en_free_tx_buf(struct net_devic
 	return cnt;
 }
 
+static void mlx4_en_handle_err_cqe(struct mlx4_en_priv *priv, struct mlx4_err_cqe *err_cqe,
+				   u16 cqe_index, struct mlx4_en_tx_ring *ring)
+{
+	struct mlx4_en_dev *mdev = priv->mdev;
+	struct mlx4_en_tx_info *tx_info;
+	struct mlx4_en_tx_desc *tx_desc;
+	u16 wqe_index;
+	int desc_size;
+
+	en_err(priv, "CQE error - cqn 0x%x, ci 0x%x, vendor syndrome: 0x%x syndrome: 0x%x\n",
+	       ring->sp_cqn, cqe_index, err_cqe->vendor_err_syndrome, err_cqe->syndrome);
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, err_cqe, sizeof(*err_cqe),
+		       false);
+
+	wqe_index = be16_to_cpu(err_cqe->wqe_index) & ring->size_mask;
+	tx_info = &ring->tx_info[wqe_index];
+	desc_size = tx_info->nr_txbb << LOG_TXBB_SIZE;
+	en_err(priv, "Related WQE - qpn 0x%x, wqe index 0x%x, wqe size 0x%x\n", ring->qpn,
+	       wqe_index, desc_size);
+	tx_desc = ring->buf + (wqe_index << LOG_TXBB_SIZE);
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, tx_desc, desc_size, false);
+
+	if (test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state))
+		return;
+
+	en_err(priv, "Scheduling port restart\n");
+	queue_work(mdev->workqueue, &priv->restart_task);
+}
+
 int mlx4_en_process_tx_cq(struct net_device *dev,
 			  struct mlx4_en_cq *cq, int napi_budget)
 {
@@ -438,13 +467,10 @@ int mlx4_en_process_tx_cq(struct net_dev
 		dma_rmb();
 
 		if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
-			     MLX4_CQE_OPCODE_ERROR)) {
-			struct mlx4_err_cqe *cqe_err = (struct mlx4_err_cqe *)cqe;
-
-			en_err(priv, "CQE error - vendor syndrome: 0x%x syndrome: 0x%x\n",
-			       cqe_err->vendor_err_syndrome,
-			       cqe_err->syndrome);
-		}
+			     MLX4_CQE_OPCODE_ERROR))
+			if (!test_and_set_bit(MLX4_EN_TX_RING_STATE_RECOVERING, &ring->state))
+				mlx4_en_handle_err_cqe(priv, (struct mlx4_err_cqe *)cqe, index,
+						       ring);
 
 		/* Skip over last polled CQE */
 		new_index = be16_to_cpu(cqe->wqe_index) & size_mask;
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -271,6 +271,10 @@ struct mlx4_en_page_cache {
 	} buf[MLX4_EN_CACHE_SIZE];
 };
 
+enum {
+	MLX4_EN_TX_RING_STATE_RECOVERING,
+};
+
 struct mlx4_en_priv;
 
 struct mlx4_en_tx_ring {
@@ -317,6 +321,7 @@ struct mlx4_en_tx_ring {
 	 * Only queue_stopped might be used if BQL is not properly working.
 	 */
 	unsigned long		queue_stopped;
+	unsigned long		state;
 	struct mlx4_hwq_resources sp_wqres;
 	struct mlx4_qp		sp_qp;
 	struct mlx4_qp_context	sp_context;


