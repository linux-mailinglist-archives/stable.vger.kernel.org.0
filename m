Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4BF1990AA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgCaJN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730519AbgCaJNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:13:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C57220675;
        Tue, 31 Mar 2020 09:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646005;
        bh=7JpCD9VtIEeJ6UaCsPkEJZJ8P/6gANcJ4xXWAYDo6/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pd4CXrD4ZTdF7vdq68hz0tBSPJmkyz/oWDj1DjtjPG8rzfeEBSLqtK23/dMosi/ga
         v4ut0e2vROdPkdycxEzRm9qCLs8DJHnxhwRsj4rqRtusMClf7/t3/hBk6IuHxKQBpA
         t5IQbyZhpBaqLKFDC8HmmRZKYvJVwAY6pzCVnOIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 052/155] net/mlx5e: Fix ICOSQ recovery flow with Striding RQ
Date:   Tue, 31 Mar 2020 10:58:12 +0200
Message-Id: <20200331085424.365457865@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit e239c6d686e1c37fb2ab143162dfb57471a8643f ]

In striding RQ mode, the buffers of an RX WQE are first
prepared and posted to the HW using a UMR WQEs via the ICOSQ.
We maintain the state of these in-progress WQEs in the RQ
SW struct.

In the flow of ICOSQ recovery, the corresponding RQ is not
in error state, hence:

- The buffers of the in-progress WQEs must be released
  and the RQ metadata should reflect it.
- Existing RX WQEs in the RQ should not be affected.

For this, wrap the dealloc of the in-progress WQEs in
a function, and use it in the ICOSQ recovery flow
instead of mlx5e_free_rx_descs().

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |   31 +++++++++++----
 3 files changed, 26 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1059,6 +1059,7 @@ int mlx5e_modify_rq_state(struct mlx5e_r
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
+void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -90,7 +90,7 @@ static int mlx5e_rx_reporter_err_icosq_c
 		goto out;
 
 	mlx5e_reset_icosq_cc_pc(icosq);
-	mlx5e_free_rx_descs(rq);
+	mlx5e_free_rx_in_progress_descs(rq);
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
 	mlx5e_activate_icosq(icosq);
 	mlx5e_activate_rq(rq);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -824,6 +824,29 @@ int mlx5e_wait_for_min_rx_wqes(struct ml
 	return -ETIMEDOUT;
 }
 
+void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq)
+{
+	struct mlx5_wq_ll *wq;
+	u16 head;
+	int i;
+
+	if (rq->wq_type != MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+		return;
+
+	wq = &rq->mpwqe.wq;
+	head = wq->head;
+
+	/* Outstanding UMR WQEs (in progress) start at wq->head */
+	for (i = 0; i < rq->mpwqe.umr_in_progress; i++) {
+		rq->dealloc_wqe(rq, head);
+		head = mlx5_wq_ll_get_wqe_next_ix(wq, head);
+	}
+
+	rq->mpwqe.actual_wq_head = wq->head;
+	rq->mpwqe.umr_in_progress = 0;
+	rq->mpwqe.umr_completed = 0;
+}
+
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 {
 	__be16 wqe_ix_be;
@@ -831,14 +854,8 @@ void mlx5e_free_rx_descs(struct mlx5e_rq
 
 	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
-		u16 head = wq->head;
-		int i;
 
-		/* Outstanding UMR WQEs (in progress) start at wq->head */
-		for (i = 0; i < rq->mpwqe.umr_in_progress; i++) {
-			rq->dealloc_wqe(rq, head);
-			head = mlx5_wq_ll_get_wqe_next_ix(wq, head);
-		}
+		mlx5e_free_rx_in_progress_descs(rq);
 
 		while (!mlx5_wq_ll_is_empty(wq)) {
 			struct mlx5e_rx_wqe_ll *wqe;


