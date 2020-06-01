Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1358B1EACFD
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbgFASMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbgFASMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73975207D0;
        Mon,  1 Jun 2020 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035138;
        bh=0P0f2uWiBY7wYHUj9mF4lF2+aflS/pEr08cxh52VTUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMHrOXsY0wj1T+DZMvLX9KvFzumOTIF4GFNrAwUHisExoAZs5P6YHvzl8nAo5ZYBs
         4u2B3RX8WUPXdlK3GOUu0MLlD0aJjUN8pF9Zh0BDA0lSlVkuRqcVy5tnAyigvwLqI5
         LmmDVuTCYWRGEUj/VDqo2rCprpbF9vWMtpZSE2bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 026/177] net/mlx5e: Update netdev txq on completions during closure
Date:   Mon,  1 Jun 2020 19:52:44 +0200
Message-Id: <20200601174051.013234568@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -538,10 +538,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *c
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
+	u32 dma_fifo_cc, nbytes = 0;
+	u16 ci, sqcc, npkts = 0;
 	struct sk_buff *skb;
-	u32 dma_fifo_cc;
-	u16 sqcc;
-	u16 ci;
 	int i;
 
 	sqcc = sq->cc;
@@ -566,11 +565,15 @@ void mlx5e_free_txqsq_descs(struct mlx5e
 		}
 
 		dev_kfree_skb_any(skb);
+		npkts++;
+		nbytes += wi->num_bytes;
 		sqcc += wi->num_wqebbs;
 	}
 
 	sq->dma_fifo_cc = dma_fifo_cc;
 	sq->cc = sqcc;
+
+	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 }
 
 #ifdef CONFIG_MLX5_CORE_IPOIB


