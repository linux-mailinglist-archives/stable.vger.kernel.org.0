Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90521C146B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgEANjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731143AbgEANjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346B7205C9;
        Fri,  1 May 2020 13:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340346;
        bh=smIr3Dk84ov3hd0kaKlm6PPoxLkLUXPpwI22bYV8MWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kz5Cd8Y/WbZ7fQFPJ/9JjZmAhhtcfniNj6TTAhuPlYIwf5h0s7ozI8qqFUxrSrNwq
         qY+kvkCQiGOpXyIoctHcH7r6ai+OFNbsWB8ZnRf2cROZ34XaTHC50mzeTe1EGwPqR8
         DKJnPGQpU7cFKuPXj8tnjUMg6eY4NTOrCowhqw6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 28/83] net/mlx5e: Dont trigger IRQ multiple times on XSK wakeup to avoid WQ overruns
Date:   Fri,  1 May 2020 15:23:07 +0200
Message-Id: <20200501131531.021459156@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

commit e7e0004abdd6f83ae4be5613b29ed396beff576c upstream.

XSK wakeup function triggers NAPI by posting a NOP WQE to a special XSK
ICOSQ. When the application floods the driver with wakeup requests by
calling sendto() in a certain pattern that ends up in mlx5e_trigger_irq,
the XSK ICOSQ may overflow.

Multiple NOPs are not required and won't accelerate the process, so
avoid posting a second NOP if there is one already on the way. This way
we also avoid increasing the queue size (which might not help anyway).

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |    3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c |    3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |    8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c   |    6 +++++-
 4 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -367,6 +367,7 @@ enum {
 	MLX5E_SQ_STATE_AM,
 	MLX5E_SQ_STATE_TLS,
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
+	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
 
 struct mlx5e_sq_wqe_info {
@@ -948,7 +949,7 @@ void mlx5e_page_release_dynamic(struct m
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
-void mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
 void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix);
 void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -33,6 +33,9 @@ int mlx5e_xsk_wakeup(struct net_device *
 		if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &c->xskicosq.state)))
 			return 0;
 
+		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state))
+			return 0;
+
 		spin_lock(&c->xskicosq_lock);
 		mlx5e_trigger_irq(&c->xskicosq);
 		spin_unlock(&c->xskicosq_lock);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -587,7 +587,7 @@ bool mlx5e_post_rx_wqes(struct mlx5e_rq
 	return !!err;
 }
 
-void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
 	struct mlx5_cqe64 *cqe;
@@ -595,11 +595,11 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *
 	int i;
 
 	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
-		return;
+		return 0;
 
 	cqe = mlx5_cqwq_get_cqe(&cq->wq);
 	if (likely(!cqe))
-		return;
+		return 0;
 
 	/* sq->cc must be updated only after mlx5_cqwq_update_db_record(),
 	 * otherwise a cq overrun may occur
@@ -646,6 +646,8 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *
 	sq->cc = sqcc;
 
 	mlx5_cqwq_update_db_record(&cq->wq);
+
+	return i;
 }
 
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -145,7 +145,11 @@ int mlx5e_napi_poll(struct napi_struct *
 
 	busy |= rq->post_wqes(rq);
 	if (xsk_open) {
-		mlx5e_poll_ico_cq(&c->xskicosq.cq);
+		if (mlx5e_poll_ico_cq(&c->xskicosq.cq))
+			/* Don't clear the flag if nothing was polled to prevent
+			 * queueing more WQEs and overflowing XSKICOSQ.
+			 */
+			clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state);
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
 		busy_xsk |= mlx5e_napi_xsk_post(xsksq, xskrq);
 	}


