Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663293A02A9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhFHTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237819AbhFHTFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD3D861928;
        Tue,  8 Jun 2021 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177983;
        bh=OxsU/x4thrKuArgpO9ucwWkTW4DsEGaeQbd2P5vQhnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cR507kVDBvkbNdbC7nkyq91qedS2A96r7Dji5ApkPBsVfrxeVgIoZ0tdJnrkgfHyA
         xWZ6koCtZ7kSdue1wbKboPBZ3KousdRHrYG8+EBq1VCZ1WO/+3jT4CHxye0Ngq8ZHy
         CBzDlFgqVRelNWSknux2QEJ03WdLm3FnZXs+rLJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 033/161] net/tls: Fix use-after-free after the TLS device goes down and up
Date:   Tue,  8 Jun 2021 20:26:03 +0200
Message-Id: <20210608175946.571569455@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit c55dcdd435aa6c6ad6ccac0a4c636d010ee367a4 ]

When a netdev with active TLS offload goes down, tls_device_down is
called to stop the offload and tear down the TLS context. However, the
socket stays alive, and it still points to the TLS context, which is now
deallocated. If a netdev goes up, while the connection is still active,
and the data flow resumes after a number of TCP retransmissions, it will
lead to a use-after-free of the TLS context.

This commit addresses this bug by keeping the context alive until its
normal destruction, and implements the necessary fallbacks, so that the
connection can resume in software (non-offloaded) kTLS mode.

On the TX side tls_sw_fallback is used to encrypt all packets. The RX
side already has all the necessary fallbacks, because receiving
non-decrypted packets is supported. The thing needed on the RX side is
to block resync requests, which are normally produced after receiving
non-decrypted packets.

The necessary synchronization is implemented for a graceful teardown:
first the fallbacks are deployed, then the driver resources are released
(it used to be possible to have a tls_dev_resync after tls_dev_del).

A new flag called TLS_RX_DEV_DEGRADED is added to indicate the fallback
mode. It's used to skip the RX resync logic completely, as it becomes
useless, and some objects may be released (for example, resync_async,
which is allocated and freed by the driver).

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h             |  9 ++++++
 net/tls/tls_device.c          | 52 +++++++++++++++++++++++++++++++----
 net/tls/tls_device_fallback.c |  7 +++++
 net/tls/tls_main.c            |  1 +
 4 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 6531ace2a68b..8341a8d1e807 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -193,6 +193,11 @@ struct tls_offload_context_tx {
 	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
 
 enum tls_context_flags {
+	/* tls_device_down was called after the netdev went down, device state
+	 * was released, and kTLS works in software, even though rx_conf is
+	 * still TLS_HW (needed for transition).
+	 */
+	TLS_RX_DEV_DEGRADED = 0,
 	/* Unlike RX where resync is driven entirely by the core in TX only
 	 * the driver knows when things went out of sync, so we need the flag
 	 * to be atomic.
@@ -265,6 +270,7 @@ struct tls_context {
 
 	/* cache cold stuff */
 	struct proto *sk_proto;
+	struct sock *sk;
 
 	void (*sk_destruct)(struct sock *sk);
 
@@ -447,6 +453,9 @@ static inline u16 tls_user_config(struct tls_context *ctx, bool tx)
 struct sk_buff *
 tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
 		      struct sk_buff *skb);
+struct sk_buff *
+tls_validate_xmit_skb_sw(struct sock *sk, struct net_device *dev,
+			 struct sk_buff *skb);
 
 static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 2602d61a8d28..9b1ea17f3b1d 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -50,6 +50,7 @@ static void tls_device_gc_task(struct work_struct *work);
 static DECLARE_WORK(tls_device_gc_work, tls_device_gc_task);
 static LIST_HEAD(tls_device_gc_list);
 static LIST_HEAD(tls_device_list);
+static LIST_HEAD(tls_device_down_list);
 static DEFINE_SPINLOCK(tls_device_lock);
 
 static void tls_device_free_ctx(struct tls_context *ctx)
@@ -759,6 +760,8 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 
 	if (tls_ctx->rx_conf != TLS_HW)
 		return;
+	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags)))
+		return;
 
 	prot = &tls_ctx->prot_info;
 	rx_ctx = tls_offload_ctx_rx(tls_ctx);
@@ -961,6 +964,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 
 	ctx->sw.decrypted |= is_decrypted;
 
+	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
+		if (likely(is_encrypted || is_decrypted))
+			return 0;
+
+		/* After tls_device_down disables the offload, the next SKB will
+		 * likely have initial fragments decrypted, and final ones not
+		 * decrypted. We need to reencrypt that single SKB.
+		 */
+		return tls_device_reencrypt(sk, skb);
+	}
+
 	/* Return immediately if the record is either entirely plaintext or
 	 * entirely ciphertext. Otherwise handle reencrypt partially decrypted
 	 * record.
@@ -1290,6 +1304,26 @@ static int tls_device_down(struct net_device *netdev)
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 
 	list_for_each_entry_safe(ctx, tmp, &list, list)	{
+		/* Stop offloaded TX and switch to the fallback.
+		 * tls_is_sk_tx_device_offloaded will return false.
+		 */
+		WRITE_ONCE(ctx->sk->sk_validate_xmit_skb, tls_validate_xmit_skb_sw);
+
+		/* Stop the RX and TX resync.
+		 * tls_dev_resync must not be called after tls_dev_del.
+		 */
+		WRITE_ONCE(ctx->netdev, NULL);
+
+		/* Start skipping the RX resync logic completely. */
+		set_bit(TLS_RX_DEV_DEGRADED, &ctx->flags);
+
+		/* Sync with inflight packets. After this point:
+		 * TX: no non-encrypted packets will be passed to the driver.
+		 * RX: resync requests from the driver will be ignored.
+		 */
+		synchronize_net();
+
+		/* Release the offload context on the driver side. */
 		if (ctx->tx_conf == TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_TX);
@@ -1297,13 +1331,21 @@ static int tls_device_down(struct net_device *netdev)
 		    !test_bit(TLS_RX_DEV_CLOSED, &ctx->flags))
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
-		WRITE_ONCE(ctx->netdev, NULL);
-		synchronize_net();
+
 		dev_put(netdev);
-		list_del_init(&ctx->list);
 
-		if (refcount_dec_and_test(&ctx->refcount))
-			tls_device_free_ctx(ctx);
+		/* Move the context to a separate list for two reasons:
+		 * 1. When the context is deallocated, list_del is called.
+		 * 2. It's no longer an offloaded context, so we don't want to
+		 *    run offload-specific code on this context.
+		 */
+		spin_lock_irqsave(&tls_device_lock, flags);
+		list_move_tail(&ctx->list, &tls_device_down_list);
+		spin_unlock_irqrestore(&tls_device_lock, flags);
+
+		/* Device contexts for RX and TX will be freed in on sk_destruct
+		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
+		 */
 	}
 
 	up_write(&device_offload_lock);
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index cacf040872c7..e40bedd112b6 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -431,6 +431,13 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(tls_validate_xmit_skb);
 
+struct sk_buff *tls_validate_xmit_skb_sw(struct sock *sk,
+					 struct net_device *dev,
+					 struct sk_buff *skb)
+{
+	return tls_sw_fallback(sk, skb);
+}
+
 struct sk_buff *tls_encrypt_skb(struct sk_buff *skb)
 {
 	return tls_sw_fallback(skb->sk, skb);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 47b7c5334c34..fde56ff49163 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -636,6 +636,7 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 	mutex_init(&ctx->tx_lock);
 	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	ctx->sk_proto = READ_ONCE(sk->sk_prot);
+	ctx->sk = sk;
 	return ctx;
 }
 
-- 
2.30.2



