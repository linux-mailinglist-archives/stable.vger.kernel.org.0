Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACF114BBB7
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgA1OCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbgA1OCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB7B24685;
        Tue, 28 Jan 2020 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220131;
        bh=LCui2WNz6L9Whnfns1gfRNOoq1mN+c8iXpf0GRB9sWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqySbAbq7jA+jgl4lbuXoFd6Uo4/B5MLjlZnOPbhE9eifWhlu5Mu98EmSxPjh2ouJ
         4X99RG5aN/db9TWl5MnITgGZLY3UJ5IyL1ILki0FxYEU6NleTNr3lArzzJ4nbc0YRs
         YkF34kA7b3+QC51BjgWp13QuQCQBgv0EH6ckB3VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 029/104] net/mlx5e: kTLS, Fix corner-case checks in TX resync flow
Date:   Tue, 28 Jan 2020 14:59:50 +0100
Message-Id: <20200128135821.297322025@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

commit ffbd9ca94e2ebbfe802d4b28bab5ba19818de853 upstream.

There are the following cases:

1. Packet ends before start marker: bypass offload.
2. Packet starts before start marker and ends after it: drop,
   not supported, breaks contract with kernel.
3. packet ends before tls record info starts: drop,
   this packet was already acknowledged and its record info
   was released.

Add the above as comment in code.

Mind possible wraparounds of the TCP seq, replace the simple comparison
with a call to the TCP before() method.

In addition, remove logic that handles negative sync_len values,
as it became impossible.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   33 +++++++------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -180,7 +180,7 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx
 
 struct tx_sync_info {
 	u64 rcd_sn;
-	s32 sync_len;
+	u32 sync_len;
 	int nr_frags;
 	skb_frag_t frags[MAX_SKB_FRAGS];
 };
@@ -193,13 +193,14 @@ enum mlx5e_ktls_sync_retval {
 
 static enum mlx5e_ktls_sync_retval
 tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
-		 u32 tcp_seq, struct tx_sync_info *info)
+		 u32 tcp_seq, int datalen, struct tx_sync_info *info)
 {
 	struct tls_offload_context_tx *tx_ctx = priv_tx->tx_ctx;
 	enum mlx5e_ktls_sync_retval ret = MLX5E_KTLS_SYNC_DONE;
 	struct tls_record_info *record;
 	int remaining, i = 0;
 	unsigned long flags;
+	bool ends_before;
 
 	spin_lock_irqsave(&tx_ctx->lock, flags);
 	record = tls_get_record(tx_ctx, tcp_seq, &info->rcd_sn);
@@ -209,9 +210,21 @@ tx_sync_info_get(struct mlx5e_ktls_offlo
 		goto out;
 	}
 
-	if (unlikely(tcp_seq < tls_record_start_seq(record))) {
-		ret = tls_record_is_start_marker(record) ?
-			MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAIL;
+	/* There are the following cases:
+	 * 1. packet ends before start marker: bypass offload.
+	 * 2. packet starts before start marker and ends after it: drop,
+	 *    not supported, breaks contract with kernel.
+	 * 3. packet ends before tls record info starts: drop,
+	 *    this packet was already acknowledged and its record info
+	 *    was released.
+	 */
+	ends_before = before(tcp_seq + datalen, tls_record_start_seq(record));
+
+	if (unlikely(tls_record_is_start_marker(record))) {
+		ret = ends_before ? MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAIL;
+		goto out;
+	} else if (ends_before) {
+		ret = MLX5E_KTLS_SYNC_FAIL;
 		goto out;
 	}
 
@@ -337,7 +350,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_kt
 	u8 num_wqebbs;
 	int i = 0;
 
-	ret = tx_sync_info_get(priv_tx, seq, &info);
+	ret = tx_sync_info_get(priv_tx, seq, datalen, &info);
 	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE)) {
 		if (ret == MLX5E_KTLS_SYNC_SKIP_NO_DATA) {
 			stats->tls_skip_no_sync_data++;
@@ -351,14 +364,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_kt
 		goto err_out;
 	}
 
-	if (unlikely(info.sync_len < 0)) {
-		if (likely(datalen <= -info.sync_len))
-			return MLX5E_KTLS_SYNC_DONE;
-
-		stats->tls_drop_bypass_req++;
-		goto err_out;
-	}
-
 	stats->tls_ooo++;
 
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);


