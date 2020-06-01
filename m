Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7936B1EAD11
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgFASmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731168AbgFASL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC95D2065C;
        Mon,  1 Jun 2020 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035116;
        bh=KZlEEY7ERLE/snobI+OK7O45L0UKmDSQQWsTBWH3inA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMNcymfei1I+E/zPTsOrIjIci7GOCEHhY5DMkxzngqZHnPA+6wMLBq8y5O4FH0OlV
         kSzI6+iZwtujT+T2Rx11xkG+g3kLcXFl1lq49KopI8nfYKLShVXCy60bQoHTUjEjE+
         MmflURqKKAbxtpW8WP8kD1o+9cgBcj6IyrhHytHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 017/177] net/tls: fix race condition causing kernel panic
Date:   Mon,  1 Jun 2020 19:52:35 +0200
Message-Id: <20200601174050.119946311@linuxfoundation.org>
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

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 0cada33241d9de205522e3858b18e506ca5cce2c ]

tls_sw_recvmsg() and tls_decrypt_done() can be run concurrently.
// tls_sw_recvmsg()
	if (atomic_read(&ctx->decrypt_pending))
		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
	else
		reinit_completion(&ctx->async_wait.completion);

//tls_decrypt_done()
  	pending = atomic_dec_return(&ctx->decrypt_pending);

  	if (!pending && READ_ONCE(ctx->async_notify))
  		complete(&ctx->async_wait.completion);

Consider the scenario tls_decrypt_done() is about to run complete()

	if (!pending && READ_ONCE(ctx->async_notify))

and tls_sw_recvmsg() reads decrypt_pending == 0, does reinit_completion(),
then tls_decrypt_done() runs complete(). This sequence of execution
results in wrong completion. Consequently, for next decrypt request,
it will not wait for completion, eventually on connection close, crypto
resources freed, there is no way to handle pending decrypt response.

This race condition can be avoided by having atomic_read() mutually
exclusive with atomic_dec_return(),complete().Intoduced spin lock to
ensure the mutual exclution.

Addressed similar problem in tx direction.

v1->v2:
- More readable commit message.
- Corrected the lock to fix new race scenario.
- Removed barrier which is not needed now.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h |    4 ++++
 net/tls/tls_sw.c  |   33 +++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -135,6 +135,8 @@ struct tls_sw_context_tx {
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
 	atomic_t encrypt_pending;
+	/* protect crypto_wait with encrypt_pending */
+	spinlock_t encrypt_compl_lock;
 	int async_notify;
 	u8 async_capable:1;
 
@@ -155,6 +157,8 @@ struct tls_sw_context_rx {
 	u8 async_capable:1;
 	u8 decrypted:1;
 	atomic_t decrypt_pending;
+	/* protect crypto_wait with decrypt_pending*/
+	spinlock_t decrypt_compl_lock;
 	bool async_notify;
 };
 
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -206,10 +206,12 @@ static void tls_decrypt_done(struct cryp
 
 	kfree(aead_req);
 
+	spin_lock_bh(&ctx->decrypt_compl_lock);
 	pending = atomic_dec_return(&ctx->decrypt_pending);
 
-	if (!pending && READ_ONCE(ctx->async_notify))
+	if (!pending && ctx->async_notify)
 		complete(&ctx->async_wait.completion);
+	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
 
 static int tls_do_decryption(struct sock *sk,
@@ -467,10 +469,12 @@ static void tls_encrypt_done(struct cryp
 			ready = true;
 	}
 
+	spin_lock_bh(&ctx->encrypt_compl_lock);
 	pending = atomic_dec_return(&ctx->encrypt_pending);
 
-	if (!pending && READ_ONCE(ctx->async_notify))
+	if (!pending && ctx->async_notify)
 		complete(&ctx->async_wait.completion);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
 
 	if (!ready)
 		return;
@@ -926,6 +930,7 @@ int tls_sw_sendmsg(struct sock *sk, stru
 	int num_zc = 0;
 	int orig_size;
 	int ret = 0;
+	int pending;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
@@ -1092,13 +1097,19 @@ trim_sgl:
 		goto send_end;
 	} else if (num_zc) {
 		/* Wait for pending encryptions to get completed */
-		smp_store_mb(ctx->async_notify, true);
+		spin_lock_bh(&ctx->encrypt_compl_lock);
+		ctx->async_notify = true;
 
-		if (atomic_read(&ctx->encrypt_pending))
+		pending = atomic_read(&ctx->encrypt_pending);
+		spin_unlock_bh(&ctx->encrypt_compl_lock);
+		if (pending)
 			crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 		else
 			reinit_completion(&ctx->async_wait.completion);
 
+		/* There can be no concurrent accesses, since we have no
+		 * pending encrypt operations
+		 */
 		WRITE_ONCE(ctx->async_notify, false);
 
 		if (ctx->async_wait.err) {
@@ -1729,6 +1740,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	int num_async = 0;
+	int pending;
 
 	flags |= nonblock;
 
@@ -1891,8 +1903,11 @@ pick_next_record:
 recv_end:
 	if (num_async) {
 		/* Wait for all previously submitted records to be decrypted */
-		smp_store_mb(ctx->async_notify, true);
-		if (atomic_read(&ctx->decrypt_pending)) {
+		spin_lock_bh(&ctx->decrypt_compl_lock);
+		ctx->async_notify = true;
+		pending = atomic_read(&ctx->decrypt_pending);
+		spin_unlock_bh(&ctx->decrypt_compl_lock);
+		if (pending) {
 			err = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 			if (err) {
 				/* one of async decrypt failed */
@@ -1904,6 +1919,10 @@ recv_end:
 		} else {
 			reinit_completion(&ctx->async_wait.completion);
 		}
+
+		/* There can be no concurrent accesses, since we have no
+		 * pending decrypt operations
+		 */
 		WRITE_ONCE(ctx->async_notify, false);
 
 		/* Drain records from the rx_list & copy if required */
@@ -2290,6 +2309,7 @@ int tls_set_sw_offload(struct sock *sk,
 
 	if (tx) {
 		crypto_init_wait(&sw_ctx_tx->async_wait);
+		spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
 		crypto_info = &ctx->crypto_send.info;
 		cctx = &ctx->tx;
 		aead = &sw_ctx_tx->aead_send;
@@ -2298,6 +2318,7 @@ int tls_set_sw_offload(struct sock *sk,
 		sw_ctx_tx->tx_work.sk = sk;
 	} else {
 		crypto_init_wait(&sw_ctx_rx->async_wait);
+		spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
 		skb_queue_head_init(&sw_ctx_rx->rx_list);


