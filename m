Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADAA59BBD6
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiHVIkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiHVIk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E952CDDF
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EABB461040
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A505BC433D6;
        Mon, 22 Aug 2022 08:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661157625;
        bh=k9Uu/XnxpRQTEP57nuqE0yXViCZNKtDy8WPkL1BJ01g=;
        h=Subject:To:Cc:From:Date:From;
        b=LzMecgY5xgPYN3vOuYhaPib+awuxchgxHsSV5rUqhfBvSde/3c3U3ixkS2EsvEB8G
         T0T3MLm86c3MKTgjehwL5Da6tPIXSmql9+rQ+S/aGZJ0PkPjiYKy6x486fXjrchSCu
         jJLznHSK/Zg4kbeAEE3KH+feXV9WTBp7BVuTCm1w=
Subject: FAILED: patch "[PATCH] net/tls: Use RCU API to access tls_ctx->netdev" failed to apply to 5.15-stable tree
To:     maximmi@nvidia.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:40:13 +0200
Message-ID: <1661157613178169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 94ce3b64c62d4b628cf85cd0d9a370aca8f7e43a Mon Sep 17 00:00:00 2001
From: Maxim Mikityanskiy <maximmi@nvidia.com>
Date: Wed, 10 Aug 2022 11:16:02 +0300
Subject: [PATCH] net/tls: Use RCU API to access tls_ctx->netdev

Currently, tls_device_down synchronizes with tls_device_resync_rx using
RCU, however, the pointer to netdev is stored using WRITE_ONCE and
loaded using READ_ONCE.

Although such approach is technically correct (rcu_dereference is
essentially a READ_ONCE, and rcu_assign_pointer uses WRITE_ONCE to store
NULL), using special RCU helpers for pointers is more valid, as it
includes additional checks and might change the implementation
transparently to the callers.

Mark the netdev pointer as __rcu and use the correct RCU helpers to
access it. For non-concurrent access pass the right conditions that
guarantee safe access (locks taken, refcount value). Also use the
correct helper in mlx5e, where even READ_ONCE was missing.

The transition to RCU exposes existing issues, fixed by this commit:

1. bond_tls_device_xmit could read netdev twice, and it could become
NULL the second time, after the NULL check passed.

2. Drivers shouldn't stop processing the last packet if tls_device_down
just set netdev to NULL, before tls_dev_del was called. This prevents a
possible packet drop when transitioning to the fallback software mode.

Fixes: 89df6a810470 ("net/bonding: Implement TLS TX device offload")
Fixes: c55dcdd435aa ("net/tls: Fix use-after-free after the TLS device goes down and up")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Link: https://lore.kernel.org/r/20220810081602.1435800-1-maximmi@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ab7fdbbc2530..50e60843020c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5338,8 +5338,14 @@ static struct net_device *bond_sk_get_lower_dev(struct net_device *dev,
 static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *skb,
 					struct net_device *dev)
 {
-	if (likely(bond_get_slave_by_dev(bond, tls_get_ctx(skb->sk)->netdev)))
-		return bond_dev_queue_xmit(bond, skb, tls_get_ctx(skb->sk)->netdev);
+	struct net_device *tls_netdev = rcu_dereference(tls_get_ctx(skb->sk)->netdev);
+
+	/* tls_netdev might become NULL, even if tls_is_sk_tx_device_offloaded
+	 * was true, if tls_device_down is running in parallel, but it's OK,
+	 * because bond_get_slave_by_dev has a NULL check.
+	 */
+	if (likely(bond_get_slave_by_dev(bond, tls_netdev)))
+		return bond_dev_queue_xmit(bond, skb, tls_netdev);
 	return bond_tx_drop(dev, skb);
 }
 #endif
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index bfee0e4e54b1..da9973b711f4 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1932,6 +1932,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	int data_len, qidx, ret = 0, mss;
 	struct tls_record_info *record;
 	struct chcr_ktls_info *tx_info;
+	struct net_device *tls_netdev;
 	struct tls_context *tls_ctx;
 	struct sge_eth_txq *q;
 	struct adapter *adap;
@@ -1945,7 +1946,12 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : data_len;
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (unlikely(tls_ctx->netdev != dev))
+	tls_netdev = rcu_dereference_bh(tls_ctx->netdev);
+	/* Don't quit on NULL: if tls_device_down is running in parallel,
+	 * netdev might become NULL, even if tls_is_sk_tx_device_offloaded was
+	 * true. Rather continue processing this packet.
+	 */
+	if (unlikely(tls_netdev && tls_netdev != dev))
 		goto out;
 
 	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 6b6c7044b64a..0aef69527226 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -808,6 +808,7 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
+	struct net_device *tls_netdev;
 	struct tls_context *tls_ctx;
 	int datalen;
 	u32 seq;
@@ -819,7 +820,12 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	mlx5e_tx_mpwqe_ensure_complete(sq);
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
+	tls_netdev = rcu_dereference_bh(tls_ctx->netdev);
+	/* Don't WARN on NULL: if tls_device_down is running in parallel,
+	 * netdev might become NULL, even if tls_is_sk_tx_device_offloaded was
+	 * true. Rather continue processing this packet.
+	 */
+	if (WARN_ON_ONCE(tls_netdev && tls_netdev != netdev))
 		goto err_out;
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
diff --git a/include/net/tls.h b/include/net/tls.h
index b75b5727abdb..cb205f9d9473 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -237,7 +237,7 @@ struct tls_context {
 	void *priv_ctx_tx;
 	void *priv_ctx_rx;
 
-	struct net_device *netdev;
+	struct net_device __rcu *netdev;
 
 	/* rw cache line */
 	struct cipher_context tx;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6ed41474bdf8..0f983e5f7dde 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -71,7 +71,13 @@ static void tls_device_tx_del_task(struct work_struct *work)
 	struct tls_offload_context_tx *offload_ctx =
 		container_of(work, struct tls_offload_context_tx, destruct_work);
 	struct tls_context *ctx = offload_ctx->ctx;
-	struct net_device *netdev = ctx->netdev;
+	struct net_device *netdev;
+
+	/* Safe, because this is the destroy flow, refcount is 0, so
+	 * tls_device_down can't store this field in parallel.
+	 */
+	netdev = rcu_dereference_protected(ctx->netdev,
+					   !refcount_read(&ctx->refcount));
 
 	netdev->tlsdev_ops->tls_dev_del(netdev, ctx, TLS_OFFLOAD_CTX_DIR_TX);
 	dev_put(netdev);
@@ -81,6 +87,7 @@ static void tls_device_tx_del_task(struct work_struct *work)
 
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 {
+	struct net_device *netdev;
 	unsigned long flags;
 	bool async_cleanup;
 
@@ -91,7 +98,14 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	}
 
 	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
-	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
+
+	/* Safe, because this is the destroy flow, refcount is 0, so
+	 * tls_device_down can't store this field in parallel.
+	 */
+	netdev = rcu_dereference_protected(ctx->netdev,
+					   !refcount_read(&ctx->refcount));
+
+	async_cleanup = netdev && ctx->tx_conf == TLS_HW;
 	if (async_cleanup) {
 		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
 
@@ -229,7 +243,8 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 
 	trace_tls_device_tx_resync_send(sk, seq, rcd_sn);
 	down_read(&device_offload_lock);
-	netdev = tls_ctx->netdev;
+	netdev = rcu_dereference_protected(tls_ctx->netdev,
+					   lockdep_is_held(&device_offload_lock));
 	if (netdev)
 		err = netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq,
 							 rcd_sn,
@@ -710,7 +725,7 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 
 	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
 	rcu_read_lock();
-	netdev = READ_ONCE(tls_ctx->netdev);
+	netdev = rcu_dereference(tls_ctx->netdev);
 	if (netdev)
 		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
 						   TLS_OFFLOAD_CTX_DIR_RX);
@@ -1035,7 +1050,7 @@ static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 	if (sk->sk_destruct != tls_device_sk_destruct) {
 		refcount_set(&ctx->refcount, 1);
 		dev_hold(netdev);
-		ctx->netdev = netdev;
+		RCU_INIT_POINTER(ctx->netdev, netdev);
 		spin_lock_irq(&tls_device_lock);
 		list_add_tail(&ctx->list, &tls_device_list);
 		spin_unlock_irq(&tls_device_lock);
@@ -1306,7 +1321,8 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 	struct net_device *netdev;
 
 	down_read(&device_offload_lock);
-	netdev = tls_ctx->netdev;
+	netdev = rcu_dereference_protected(tls_ctx->netdev,
+					   lockdep_is_held(&device_offload_lock));
 	if (!netdev)
 		goto out;
 
@@ -1315,7 +1331,7 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 
 	if (tls_ctx->tx_conf != TLS_HW) {
 		dev_put(netdev);
-		tls_ctx->netdev = NULL;
+		rcu_assign_pointer(tls_ctx->netdev, NULL);
 	} else {
 		set_bit(TLS_RX_DEV_CLOSED, &tls_ctx->flags);
 	}
@@ -1335,7 +1351,11 @@ static int tls_device_down(struct net_device *netdev)
 
 	spin_lock_irqsave(&tls_device_lock, flags);
 	list_for_each_entry_safe(ctx, tmp, &tls_device_list, list) {
-		if (ctx->netdev != netdev ||
+		struct net_device *ctx_netdev =
+			rcu_dereference_protected(ctx->netdev,
+						  lockdep_is_held(&device_offload_lock));
+
+		if (ctx_netdev != netdev ||
 		    !refcount_inc_not_zero(&ctx->refcount))
 			continue;
 
@@ -1352,7 +1372,7 @@ static int tls_device_down(struct net_device *netdev)
 		/* Stop the RX and TX resync.
 		 * tls_dev_resync must not be called after tls_dev_del.
 		 */
-		WRITE_ONCE(ctx->netdev, NULL);
+		rcu_assign_pointer(ctx->netdev, NULL);
 
 		/* Start skipping the RX resync logic completely. */
 		set_bit(TLS_RX_DEV_DEGRADED, &ctx->flags);
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 618cee704217..7dfc8023e0f1 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -426,7 +426,8 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 				      struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	if (dev == tls_get_ctx(sk)->netdev || netif_is_bond_master(dev))
+	if (dev == rcu_dereference_bh(tls_get_ctx(sk)->netdev) ||
+	    netif_is_bond_master(dev))
 		return skb;
 
 	return tls_sw_fallback(sk, skb);

