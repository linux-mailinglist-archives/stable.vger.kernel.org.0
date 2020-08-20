Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B086524B7C9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbgHTKNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731063AbgHTKMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:12:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED42A2067C;
        Thu, 20 Aug 2020 10:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918362;
        bh=Keo6OZ8vC0rp+95v2eqm9/aj7XkRtXvNFbrDYtiPdiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOYUwlflw0fSEoHHBK3QMI2n/e55k7lb/AF5ttWdD1yabS+uQ+Ys5KN0O7DWAEUzp
         QugVoKMNxCFNYyvpJNwMqLMX0IX+fv12Ye4SB0reBRQTxoJrdKwPVeyndrjhdLmSRT
         qh8qTog1L0ZzxvjL9IClI9HHdnM4kQySLXQUG11s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 142/228] net: refactor bind_bucket fastreuse into helper
Date:   Thu, 20 Aug 2020 11:21:57 +0200
Message-Id: <20200820091614.684508567@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Froidcoeur <tim.froidcoeur@tessares.net>

[ Upstream commit 62ffc589abb176821662efc4525ee4ac0b9c3894 ]

Refactor the fastreuse update code in inet_csk_get_port into a small
helper function that can be called from other places.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_connection_sock.h |    4 +
 net/ipv4/inet_connection_sock.c    |   93 ++++++++++++++++++++-----------------
 2 files changed, 55 insertions(+), 42 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -321,5 +321,9 @@ int inet_csk_compat_getsockopt(struct so
 int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
 			       char __user *optval, unsigned int optlen);
 
+/* update the fast reuse flag when adding a socket */
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk);
+
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 #endif /* _INET_CONNECTION_SOCK_H */
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -276,51 +276,12 @@ static inline int sk_reuseport_match(str
 				    ipv6_only_sock(sk), true);
 }
 
-/* Obtain a reference to a local port for the given sock,
- * if snum is zero it means select any available local port.
- * We try to allocate an odd port (and leave even ports for connect())
- */
-int inet_csk_get_port(struct sock *sk, unsigned short snum)
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk)
 {
-	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
-	int ret = 1, port = snum;
-	struct inet_bind_hashbucket *head;
-	struct net *net = sock_net(sk);
-	struct inet_bind_bucket *tb = NULL;
 	kuid_t uid = sock_i_uid(sk);
+	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 
-	if (!port) {
-		head = inet_csk_find_open_port(sk, &tb, &port);
-		if (!head)
-			return ret;
-		if (!tb)
-			goto tb_not_found;
-		goto success;
-	}
-	head = &hinfo->bhash[inet_bhashfn(net, port,
-					  hinfo->bhash_size)];
-	spin_lock_bh(&head->lock);
-	inet_bind_bucket_for_each(tb, &head->chain)
-		if (net_eq(ib_net(tb), net) && tb->port == port)
-			goto tb_found;
-tb_not_found:
-	tb = inet_bind_bucket_create(hinfo->bind_bucket_cachep,
-				     net, head, port);
-	if (!tb)
-		goto fail_unlock;
-tb_found:
-	if (!hlist_empty(&tb->owners)) {
-		if (sk->sk_reuse == SK_FORCE_REUSE)
-			goto success;
-
-		if ((tb->fastreuse > 0 && reuse) ||
-		    sk_reuseport_match(tb, sk))
-			goto success;
-		if (inet_csk_bind_conflict(sk, tb, true, true))
-			goto fail_unlock;
-	}
-success:
 	if (hlist_empty(&tb->owners)) {
 		tb->fastreuse = reuse;
 		if (sk->sk_reuseport) {
@@ -364,6 +325,54 @@ success:
 			tb->fastreuseport = 0;
 		}
 	}
+}
+
+/* Obtain a reference to a local port for the given sock,
+ * if snum is zero it means select any available local port.
+ * We try to allocate an odd port (and leave even ports for connect())
+ */
+int inet_csk_get_port(struct sock *sk, unsigned short snum)
+{
+	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
+	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	int ret = 1, port = snum;
+	struct inet_bind_hashbucket *head;
+	struct net *net = sock_net(sk);
+	struct inet_bind_bucket *tb = NULL;
+
+	if (!port) {
+		head = inet_csk_find_open_port(sk, &tb, &port);
+		if (!head)
+			return ret;
+		if (!tb)
+			goto tb_not_found;
+		goto success;
+	}
+	head = &hinfo->bhash[inet_bhashfn(net, port,
+					  hinfo->bhash_size)];
+	spin_lock_bh(&head->lock);
+	inet_bind_bucket_for_each(tb, &head->chain)
+		if (net_eq(ib_net(tb), net) && tb->port == port)
+			goto tb_found;
+tb_not_found:
+	tb = inet_bind_bucket_create(hinfo->bind_bucket_cachep,
+				     net, head, port);
+	if (!tb)
+		goto fail_unlock;
+tb_found:
+	if (!hlist_empty(&tb->owners)) {
+		if (sk->sk_reuse == SK_FORCE_REUSE)
+			goto success;
+
+		if ((tb->fastreuse > 0 && reuse) ||
+		    sk_reuseport_match(tb, sk))
+			goto success;
+		if (inet_csk_bind_conflict(sk, tb, true, true))
+			goto fail_unlock;
+	}
+success:
+	inet_csk_update_fastreuse(tb, sk);
+
 	if (!inet_csk(sk)->icsk_bind_hash)
 		inet_bind_hash(sk, tb, port);
 	WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);


