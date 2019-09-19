Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3261AB86FD
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405898AbfISWL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbfISWL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:11:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF93921907;
        Thu, 19 Sep 2019 22:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931118;
        bh=iJiYBylmBVU7bUMfyMLcsvFBF4/8vYy8SG45FdeNJSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpugMNtYrphuKeIhxDIfm6lq9VS7YelwehNATVHUHXtubXhpoO0DwZWueJQOsiR/u
         SWCAB5U+muyNtlw/XAzIbXtrIjb9Egv1RPkcL+D0sIM9uopJtgc1juKuaK4u/Qo2iM
         0A+NV+rKXWrQNp28pnOVzP6ogNABnphTkeELqUmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Craig Gallek <kraig@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/79] udp: correct reuseport selection with connected sockets
Date:   Fri, 20 Sep 2019 00:02:55 +0200
Message-Id: <20190919214808.734045565@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit acdcecc61285faed359f1a3568c32089cc3a8329 ]

UDP reuseport groups can hold a mix unconnected and connected sockets.
Ensure that connections only receive all traffic to their 4-tuple.

Fast reuseport returns on the first reuseport match on the assumption
that all matches are equal. Only if connections are present, return to
the previous behavior of scoring all sockets.

Record if connections are present and if so (1) treat such connected
sockets as an independent match from the group, (2) only return
2-tuple matches from reuseport and (3) do not return on the first
2-tuple reuseport match to allow for a higher scoring match later.

New field has_conns is set without locks. No other fields in the
bitmap are modified at runtime and the field is only ever set
unconditionally, so an RMW cannot miss a change.

Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
Link: http://lkml.kernel.org/r/CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Craig Gallek <kraig@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock_reuseport.h |   21 ++++++++++++++++++++-
 net/core/sock_reuseport.c    |   15 +++++++++++++--
 net/ipv4/datagram.c          |    2 ++
 net/ipv4/udp.c               |    5 +++--
 net/ipv6/datagram.c          |    2 ++
 net/ipv6/udp.c               |    5 +++--
 6 files changed, 43 insertions(+), 7 deletions(-)

--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -21,7 +21,8 @@ struct sock_reuseport {
 	unsigned int		synq_overflow_ts;
 	/* ID stays the same even after the size of socks[] grows. */
 	unsigned int		reuseport_id;
-	bool			bind_inany;
+	unsigned int		bind_inany:1;
+	unsigned int		has_conns:1;
 	struct bpf_prog __rcu	*prog;		/* optional BPF sock selector */
 	struct sock		*socks[0];	/* array of sock pointers */
 };
@@ -35,6 +36,24 @@ extern struct sock *reuseport_select_soc
 					  struct sk_buff *skb,
 					  int hdr_len);
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
+
+static inline bool reuseport_has_conns(struct sock *sk, bool set)
+{
+	struct sock_reuseport *reuse;
+	bool ret = false;
+
+	rcu_read_lock();
+	reuse = rcu_dereference(sk->sk_reuseport_cb);
+	if (reuse) {
+		if (set)
+			reuse->has_conns = 1;
+		ret = reuse->has_conns;
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 int reuseport_get_id(struct sock_reuseport *reuse);
 
 #endif  /* _SOCK_REUSEPORT_H */
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -292,8 +292,19 @@ struct sock *reuseport_select_sock(struc
 
 select_by_hash:
 		/* no bpf or invalid bpf result: fall back to hash usage */
-		if (!sk2)
-			sk2 = reuse->socks[reciprocal_scale(hash, socks)];
+		if (!sk2) {
+			int i, j;
+
+			i = j = reciprocal_scale(hash, socks);
+			while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
+				i++;
+				if (i >= reuse->num_socks)
+					i = 0;
+				if (i == j)
+					goto out;
+			}
+			sk2 = reuse->socks[i];
+		}
 	}
 
 out:
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -19,6 +19,7 @@
 #include <net/sock.h>
 #include <net/route.h>
 #include <net/tcp_states.h>
+#include <net/sock_reuseport.h>
 
 int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
@@ -73,6 +74,7 @@ int __ip4_datagram_connect(struct sock *
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
+	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = jiffies;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -443,12 +443,13 @@ static struct sock *udp4_lib_lookup2(str
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif, exact_dif);
 		if (score > badness) {
-			if (sk->sk_reuseport) {
+			if (sk->sk_reuseport &&
+			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp_ehashfn(net, daddr, hnum,
 						   saddr, sport);
 				result = reuseport_select_sock(sk, hash, skb,
 							sizeof(struct udphdr));
-				if (result)
+				if (result && !reuseport_has_conns(sk, false))
 					return result;
 			}
 			badness = score;
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -31,6 +31,7 @@
 #include <net/ip6_route.h>
 #include <net/tcp_states.h>
 #include <net/dsfield.h>
+#include <net/sock_reuseport.h>
 
 #include <linux/errqueue.h>
 #include <linux/uaccess.h>
@@ -258,6 +259,7 @@ ipv4_connected:
 		goto out;
 	}
 
+	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -177,13 +177,14 @@ static struct sock *udp6_lib_lookup2(str
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif, exact_dif);
 		if (score > badness) {
-			if (sk->sk_reuseport) {
+			if (sk->sk_reuseport &&
+			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp6_ehashfn(net, daddr, hnum,
 						    saddr, sport);
 
 				result = reuseport_select_sock(sk, hash, skb,
 							sizeof(struct udphdr));
-				if (result)
+				if (result && !reuseport_has_conns(sk, false))
 					return result;
 			}
 			result = sk;


