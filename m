Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4E21990AB
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbgCaJNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbgCaJNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:13:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7867420675;
        Tue, 31 Mar 2020 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645997;
        bh=f98q2bHOB/Zv/40H9W+WM3nJadh8ZSBI7JD+eH8uzwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhZXF/lR5oE4SU9j+svd+PpxKAK3ezAnPquQmdd/QJU40c5bjFHs1zeef89BEfQpM
         XujkgCqLkk6wcwUDvV34z8ijCkp/dIUPlyelyTdrsjxO1jX+H1Npan3fIgsPnU9ooJ
         b9k36TkhRYSikm8GHGE3jY3qypw6TYIL8s3Lubow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 050/155] net/mlx5e: Enhance ICOSQ WQE info fields
Date:   Tue, 31 Mar 2020 10:58:10 +0200
Message-Id: <20200331085424.115467794@linuxfoundation.org>
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

[ Upstream commit 1de0306c3a05d305e45b1f1fabe2f4e94222eb6b ]

Add number of WQEBBs (WQE's Basic Block) to WQE info struct. Set the
number of WQEBBs on WQE post, and increment the consumer counter (cc)
on completion.

In case of error completions, the cc was mistakenly not incremented,
keeping a gap between cc and pc (producer counter). This failed the
recovery flow on the ICOSQ from a CQE error which timed-out waiting for
the cc and pc to meet.

Fixes: be5323c8379f ("net/mlx5e: Report and recover from CQE error on ICOSQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |   11 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |    1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -371,6 +371,7 @@ enum {
 
 struct mlx5e_sq_wqe_info {
 	u8  opcode;
+	u8 num_wqebbs;
 
 	/* Auxiliary data for different opcodes. */
 	union {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -477,6 +477,7 @@ static inline void mlx5e_fill_icosq_frag
 	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
 	for (; wi < edge_wi; wi++) {
 		wi->opcode = MLX5_OPCODE_NOP;
+		wi->num_wqebbs = 1;
 		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	}
 }
@@ -525,6 +526,7 @@ static int mlx5e_alloc_rx_mpwqe(struct m
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
 
 	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_UMR;
+	sq->db.ico_wqe[pi].num_wqebbs = MLX5E_UMR_WQEBBS;
 	sq->db.ico_wqe[pi].umr.rq = rq;
 	sq->pc += MLX5E_UMR_WQEBBS;
 
@@ -628,17 +630,14 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *
 
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi = &sq->db.ico_wqe[ci];
+			sqcc += wi->num_wqebbs;
 
-			if (likely(wi->opcode == MLX5_OPCODE_UMR)) {
-				sqcc += MLX5E_UMR_WQEBBS;
+			if (likely(wi->opcode == MLX5_OPCODE_UMR))
 				wi->umr.rq->mpwqe.umr_completed++;
-			} else if (likely(wi->opcode == MLX5_OPCODE_NOP)) {
-				sqcc++;
-			} else {
+			else if (unlikely(wi->opcode != MLX5_OPCODE_NOP))
 				netdev_WARN_ONCE(cq->channel->netdev,
 						 "Bad OPCODE in ICOSQ WQE info: 0x%x\n",
 						 wi->opcode);
-			}
 
 		} while (!last_wqe);
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -78,6 +78,7 @@ void mlx5e_trigger_irq(struct mlx5e_icos
 	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 
 	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_NOP;
+	sq->db.ico_wqe[pi].num_wqebbs = 1;
 	nopwqe = mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nopwqe->ctrl);
 }


