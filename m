Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECA51BCBC3
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgD1S1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729069AbgD1S1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB732085B;
        Tue, 28 Apr 2020 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098468;
        bh=Fb3sQa6OCs+P3URJNkaWDvAwPUCo6P0IAoeJ4lkfKvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqWeH/lTXU/5Y9Ymu4EHXaGt94xrXY1JIO3P/IacmHq/8KDGTVItEhBzJ311NJ2d6
         febw8nP/q+YzBopJ7bV6AVUviCYqAh7MLPFOxPUe1UGSRk+19/5DQqP4rEU3FzL3PB
         uJzsLRaUiO8PrMtIc90T2W8ld0ihfCHU+6GvCKfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 053/167] net/mlx4_en: avoid indirect call in TX completion
Date:   Tue, 28 Apr 2020 20:23:49 +0200
Message-Id: <20200428182231.705932896@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 310660a14b74c380b0ef5c12b66933d6a3d1b59f ]

Commit 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data write support")
brought another indirect call in fast path.

Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
when/if CONFIG_RETPOLINE=y

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -43,6 +43,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/moduleparam.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include "mlx4_en.h"
 
@@ -261,6 +262,10 @@ static void mlx4_en_stamp_wqe(struct mlx
 	}
 }
 
+INDIRECT_CALLABLE_DECLARE(u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
+						   struct mlx4_en_tx_ring *ring,
+						   int index, u64 timestamp,
+						   int napi_mode));
 
 u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 			 struct mlx4_en_tx_ring *ring,
@@ -329,6 +334,11 @@ u32 mlx4_en_free_tx_desc(struct mlx4_en_
 	return tx_info->nr_txbb;
 }
 
+INDIRECT_CALLABLE_DECLARE(u32 mlx4_en_recycle_tx_desc(struct mlx4_en_priv *priv,
+						      struct mlx4_en_tx_ring *ring,
+						      int index, u64 timestamp,
+						      int napi_mode));
+
 u32 mlx4_en_recycle_tx_desc(struct mlx4_en_priv *priv,
 			    struct mlx4_en_tx_ring *ring,
 			    int index, u64 timestamp,
@@ -449,7 +459,9 @@ bool mlx4_en_process_tx_cq(struct net_de
 				timestamp = mlx4_en_get_cqe_ts(cqe);
 
 			/* free next descriptor */
-			last_nr_txbb = ring->free_tx_desc(
+			last_nr_txbb = INDIRECT_CALL_2(ring->free_tx_desc,
+						       mlx4_en_free_tx_desc,
+						       mlx4_en_recycle_tx_desc,
 					priv, ring, ring_index,
 					timestamp, napi_budget);
 


