Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA0F7E43
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfKKSr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbfKKSr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7002C20674;
        Mon, 11 Nov 2019 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498077;
        bh=X1tKbfo/tuQF/XTXNXBwQTDlzsKrcIwpWLfElsYbQXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkdtYywWrsmy+1FMGcJ57DinMK5b7Wqx5TU55A70hU/EU8z/VLLSnEZzyH3hTdDT+
         ojEWXlJZsejiW1DVf+lQn7oKeAQCxp268IH8bUNCGAL6M0xDs8PmpXM2tgUW/vXmbO
         Tu8u49AgefJ1sIilfYj3M9wucTZ21+ocEI3VXSKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mallesham Jatharakonda <mallesh537@gmail.com>,
        Pooja Trivedi <poojatrivedi@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 016/193] net/tls: add a TX lock
Date:   Mon, 11 Nov 2019 19:26:38 +0100
Message-Id: <20191111181501.296176521@linuxfoundation.org>
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

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 79ffe6087e9145d2377385cac48d0d6a6b4225a5 ]

TLS TX needs to release and re-acquire the socket lock if send buffer
fills up.

TLS SW TX path currently depends on only allowing one thread to enter
the function by the abuse of sk_write_pending. If another writer is
already waiting for memory no new ones are allowed in.

This has two problems:
 - writers don't wake other threads up when they leave the kernel;
   meaning that this scheme works for single extra thread (second
   application thread or delayed work) because memory becoming
   available will send a wake up request, but as Mallesham and
   Pooja report with larger number of threads it leads to threads
   being put to sleep indefinitely;
 - the delayed work does not get _scheduled_ but it may _run_ when
   other writers are present leading to crashes as writers don't
   expect state to change under their feet (same records get pushed
   and freed multiple times); it's hard to reliably bail from the
   work, however, because the mere presence of a writer does not
   guarantee that the writer will push pending records before exiting.

Ensuring wakeups always happen will make the code basically open
code a mutex. Just use a mutex.

The TLS HW TX path does not have any locking (not even the
sk_write_pending hack), yet it uses a per-socket sg_tx_data
array to push records.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Reported-by: Mallesham  Jatharakonda <mallesh537@gmail.com>
Reported-by: Pooja Trivedi <poojatrivedi@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h    |    5 +++++
 net/tls/tls_device.c |    6 ++++++
 net/tls/tls_main.c   |    2 ++
 net/tls/tls_sw.c     |   21 +++++++--------------
 4 files changed, 20 insertions(+), 14 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -40,6 +40,7 @@
 #include <linux/socket.h>
 #include <linux/tcp.h>
 #include <linux/skmsg.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 
 #include <net/tcp.h>
@@ -268,6 +269,10 @@ struct tls_context {
 
 	bool in_tcp_sendpages;
 	bool pending_open_record_frags;
+
+	struct mutex tx_lock; /* protects partially_sent_* fields and
+			       * per-type TX fields
+			       */
 	unsigned long flags;
 
 	/* cache cold stuff */
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -482,8 +482,10 @@ last_record:
 int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	int rc;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -497,12 +499,14 @@ int tls_device_sendmsg(struct sock *sk,
 
 out:
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return rc;
 }
 
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct iov_iter	msg_iter;
 	char *kaddr = kmap(page);
 	struct kvec iov;
@@ -511,6 +515,7 @@ int tls_device_sendpage(struct sock *sk,
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
 	if (flags & MSG_OOB) {
@@ -527,6 +532,7 @@ int tls_device_sendpage(struct sock *sk,
 
 out:
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return rc;
 }
 
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -258,6 +258,7 @@ void tls_ctx_free(struct tls_context *ct
 
 	memzero_explicit(&ctx->crypto_send, sizeof(ctx->crypto_send));
 	memzero_explicit(&ctx->crypto_recv, sizeof(ctx->crypto_recv));
+	mutex_destroy(&ctx->tx_lock);
 	kfree(ctx);
 }
 
@@ -615,6 +616,7 @@ static struct tls_context *create_ctx(st
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
 	ctx->unhash = sk->sk_prot->unhash;
+	mutex_init(&ctx->tx_lock);
 	return ctx;
 }
 
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -897,15 +897,9 @@ int tls_sw_sendmsg(struct sock *sk, stru
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -ENOTSUPP;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
-	/* Wait till there is any pending write on socket */
-	if (unlikely(sk->sk_write_pending)) {
-		ret = wait_on_pending_writer(sk, &timeo);
-		if (unlikely(ret))
-			goto send_end;
-	}
-
 	if (unlikely(msg->msg_controllen)) {
 		ret = tls_proccess_cmsg(sk, msg, &record_type);
 		if (ret) {
@@ -1091,6 +1085,7 @@ send_end:
 	ret = sk_stream_error(sk, msg->msg_flags, ret);
 
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return copied ? copied : ret;
 }
 
@@ -1114,13 +1109,6 @@ static int tls_sw_do_sendpage(struct soc
 	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
-	/* Wait till there is any pending write on socket */
-	if (unlikely(sk->sk_write_pending)) {
-		ret = wait_on_pending_writer(sk, &timeo);
-		if (unlikely(ret))
-			goto sendpage_end;
-	}
-
 	/* Call the sk_stream functions to manage the sndbuf mem. */
 	while (size > 0) {
 		size_t copy, required_size;
@@ -1219,15 +1207,18 @@ sendpage_end:
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags)
 {
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	int ret;
 
 	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -ENOTSUPP;
 
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 	return ret;
 }
 
@@ -2172,9 +2163,11 @@ static void tx_work_handler(struct work_
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
+	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 	tls_tx_records(sk, -1);
 	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
 }
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)


