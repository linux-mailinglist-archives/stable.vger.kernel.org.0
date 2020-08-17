Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E15246FED
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388884AbgHQRzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388555AbgHQQKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB2420658;
        Mon, 17 Aug 2020 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680632;
        bh=X/AmkpeP84gXjeZ1Eof7O1L/MDM7kjeyU2skjL17yr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHzX6Xxmk1tIIyaeW/608iaeGWAJH8ODZ/ITRf9kOI095l2lSUQrOPgOVPlDSSD8N
         ljx0FjELeOnYm4JkKRtcyniE+V7bVoUsIWWeA3bkCy3xuPxfrSvIe6kQvBRXnIj1qs
         UeUQsNYq19KseYnkmnQNytc3vN/NCSwT6m2uw3A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 5.4 224/270] tcp: correct read of TFO keys on big endian systems
Date:   Mon, 17 Aug 2020 17:17:05 +0200
Message-Id: <20200817143806.927252565@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>

[ Upstream commit f19008e676366c44e9241af57f331b6c6edf9552 ]

When TFO keys are read back on big endian systems either via the global
sysctl interface or via getsockopt() using TCP_FASTOPEN_KEY, the values
don't match what was written.

For example, on s390x:

# echo "1-2-3-4" > /proc/sys/net/ipv4/tcp_fastopen_key
# cat /proc/sys/net/ipv4/tcp_fastopen_key
02000000-01000000-04000000-03000000

Instead of:

# cat /proc/sys/net/ipv4/tcp_fastopen_key
00000001-00000002-00000003-00000004

Fix this by converting to the correct endianness on read. This was
reported by Colin Ian King when running the 'tcp_fastopen_backup_key' net
selftest on s390x, which depends on the read value matching what was
written. I've confirmed that the test now passes on big and little endian
systems.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Fixes: 438ac88009bc ("net: fastopen: robustness and endianness fixes for SipHash")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Eric Dumazet <edumazet@google.com>
Reported-and-tested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h          |    2 ++
 net/ipv4/sysctl_net_ipv4.c |   16 ++++------------
 net/ipv4/tcp.c             |   16 ++++------------
 net/ipv4/tcp_fastopen.c    |   23 +++++++++++++++++++++++
 4 files changed, 33 insertions(+), 24 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1650,6 +1650,8 @@ void tcp_fastopen_destroy_cipher(struct
 void tcp_fastopen_ctx_destroy(struct net *net);
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 			      void *primary_key, void *backup_key);
+int tcp_fastopen_get_cipher(struct net *net, struct inet_connection_sock *icsk,
+			    u64 *key);
 void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb);
 struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      struct request_sock *req,
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -307,24 +307,16 @@ static int proc_tcp_fastopen_key(struct
 	struct ctl_table tbl = { .maxlen = ((TCP_FASTOPEN_KEY_LENGTH *
 					    2 * TCP_FASTOPEN_KEY_MAX) +
 					    (TCP_FASTOPEN_KEY_MAX * 5)) };
-	struct tcp_fastopen_context *ctx;
-	u32 user_key[TCP_FASTOPEN_KEY_MAX * 4];
-	__le32 key[TCP_FASTOPEN_KEY_MAX * 4];
+	u32 user_key[TCP_FASTOPEN_KEY_BUF_LENGTH / sizeof(u32)];
+	__le32 key[TCP_FASTOPEN_KEY_BUF_LENGTH / sizeof(__le32)];
 	char *backup_data;
-	int ret, i = 0, off = 0, n_keys = 0;
+	int ret, i = 0, off = 0, n_keys;
 
 	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
 	if (!tbl.data)
 		return -ENOMEM;
 
-	rcu_read_lock();
-	ctx = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
-	if (ctx) {
-		n_keys = tcp_fastopen_context_len(ctx);
-		memcpy(&key[0], &ctx->key[0], TCP_FASTOPEN_KEY_LENGTH * n_keys);
-	}
-	rcu_read_unlock();
-
+	n_keys = tcp_fastopen_get_cipher(net, NULL, (u64 *)key);
 	if (!n_keys) {
 		memset(&key[0], 0, TCP_FASTOPEN_KEY_LENGTH);
 		n_keys = 1;
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3527,22 +3527,14 @@ static int do_tcp_getsockopt(struct sock
 		return 0;
 
 	case TCP_FASTOPEN_KEY: {
-		__u8 key[TCP_FASTOPEN_KEY_BUF_LENGTH];
-		struct tcp_fastopen_context *ctx;
-		unsigned int key_len = 0;
+		u64 key[TCP_FASTOPEN_KEY_BUF_LENGTH / sizeof(u64)];
+		unsigned int key_len;
 
 		if (get_user(len, optlen))
 			return -EFAULT;
 
-		rcu_read_lock();
-		ctx = rcu_dereference(icsk->icsk_accept_queue.fastopenq.ctx);
-		if (ctx) {
-			key_len = tcp_fastopen_context_len(ctx) *
-					TCP_FASTOPEN_KEY_LENGTH;
-			memcpy(&key[0], &ctx->key[0], key_len);
-		}
-		rcu_read_unlock();
-
+		key_len = tcp_fastopen_get_cipher(net, icsk, key) *
+				TCP_FASTOPEN_KEY_LENGTH;
 		len = min_t(unsigned int, len, key_len);
 		if (put_user(len, optlen))
 			return -EFAULT;
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -108,6 +108,29 @@ out:
 	return err;
 }
 
+int tcp_fastopen_get_cipher(struct net *net, struct inet_connection_sock *icsk,
+			    u64 *key)
+{
+	struct tcp_fastopen_context *ctx;
+	int n_keys = 0, i;
+
+	rcu_read_lock();
+	if (icsk)
+		ctx = rcu_dereference(icsk->icsk_accept_queue.fastopenq.ctx);
+	else
+		ctx = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
+	if (ctx) {
+		n_keys = tcp_fastopen_context_len(ctx);
+		for (i = 0; i < n_keys; i++) {
+			put_unaligned_le64(ctx->key[i].key[0], key + (i * 2));
+			put_unaligned_le64(ctx->key[i].key[1], key + (i * 2) + 1);
+		}
+	}
+	rcu_read_unlock();
+
+	return n_keys;
+}
+
 static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 					     struct sk_buff *syn,
 					     const siphash_key_t *key,


