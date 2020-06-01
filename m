Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A4F1EA92D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgFAR65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbgFAR6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D7A2073B;
        Mon,  1 Jun 2020 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034333;
        bh=Rz5GFTWAqAb/svBU1Gfq7zU9CSxClfWuCP+GYeAStIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QChmiIoOHpmxk43BVCwDNYaQfCTsKi79i734oJ9FfLcjofTBiXnBMz2UiYMiFnSyW
         f2UtGul+hqkXGramADnfhpTxPxBuTRSB1t4NKOqEWAUFe9HO/3bRb5+tv/OYjNEC6d
         QCZxmTwLreQQVx9m+X2pj1O/NQKd3AqBSAz8bJ9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.9 06/61] net/mlx5e: Update netdev txq on completions during closure
Date:   Mon,  1 Jun 2020 19:53:13 +0200
Message-Id: <20200601174012.554462717@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 5e911e2c06bd8c17df29147a5e2d4b17fafda024 ]

On sq closure when we free its descriptors, we should also update netdev
txq on completions which would not arrive. Otherwise if we reopen sqs
and attach them back, for example on fw fatal recovery flow, we may get
tx timeout.

Fixes: 29429f3300a3 ("net/mlx5e: Timeout if SQ doesn't flush during close")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -499,8 +499,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *c
 static void mlx5e_free_txq_sq_descs(struct mlx5e_sq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
+	u32 nbytes = 0;
+	u16 ci, npkts = 0;
 	struct sk_buff *skb;
-	u16 ci;
 	int i;
 
 	while (sq->cc != sq->pc) {
@@ -521,8 +522,11 @@ static void mlx5e_free_txq_sq_descs(stru
 		}
 
 		dev_kfree_skb_any(skb);
+		npkts++;
+		nbytes += wi->num_bytes;
 		sq->cc += wi->num_wqebbs;
 	}
+	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 }
 
 static void mlx5e_free_xdp_sq_descs(struct mlx5e_sq *sq)


