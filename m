Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961F6F7D19
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfKKSxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbfKKSxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8293B20818;
        Mon, 11 Nov 2019 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498387;
        bh=lwTFZ7ccN1LwjlZfvn5muDamt7xi4s5czdnU/1JsfDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Okvb9+WYbPT7OJr3WD9f3CJsi3Wzk1iqAANalmwJ0dc4/K6kuv/ALhAcBnhrUx+NL
         Yy8nFsjh2BJrUyDry6pvmBMkt+3Y6FbxjS2/XOS2jhZC/dgOW8QwOHPqf9XdEEyDkJ
         kZNM+5i14vwTn08CCYRDE1cifkcH2wVTighPYPdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 104/193] net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow
Date:   Mon, 11 Nov 2019 19:28:06 +0100
Message-Id: <20191111181508.801899723@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 0c258dec8d98af15b34dbffdb89c008b6da01ff8 ]

Cited patch removed the assumption only in datapath.
Here we remove it also form control/cleanup flow.

Fixes: 9ab0233728ca ("net/mlx5e: Tx, Don't implicitly assume SKB-less wqe has one WQEBB")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9d5f6e56188f8..f3a2970c3fcf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1347,9 +1347,13 @@ static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 	/* last doorbell out, godspeed .. */
 	if (mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, 1)) {
 		u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+		struct mlx5e_tx_wqe_info *wi;
 		struct mlx5e_tx_wqe *nop;
 
-		sq->db.wqe_info[pi].skb = NULL;
+		wi = &sq->db.wqe_info[pi];
+
+		memset(wi, 0, sizeof(*wi));
+		wi->num_wqebbs = 1;
 		nop = mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nop->ctrl);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 600e92cb629a2..9aaf74407a11f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -551,8 +551,8 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		wi = &sq->db.wqe_info[ci];
 		skb = wi->skb;
 
-		if (!skb) { /* nop */
-			sq->cc++;
+		if (!skb) {
+			sq->cc += wi->num_wqebbs;
 			continue;
 		}
 
-- 
2.20.1



