Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0344312370A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfLQUQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbfLQUQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:16:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118A62465E;
        Tue, 17 Dec 2019 20:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613805;
        bh=5DOOl48oe+n0c7T4N/dz7ASeKzuMOLDk+lKmqE4BVno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQTc/LHAJe7GXS2DES13WCkOMZVo97CU4xakgzRMB021ugI18c2OUZ/dv6ubiizJg
         7EEDl/a9Qb0KWFfr/IyXA3yBx5kJ2SD0PtHx5aH43yWOiXyDG1unkqFRwUCeYlVISL
         xPph/7Xs6zGr/thMxalv/TiEG2AA8ttZ04ZhHoy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 14/25] net: ipv6: add net argument to ip6_dst_lookup_flow
Date:   Tue, 17 Dec 2019 21:16:13 +0100
Message-Id: <20191217200908.844153513@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit c4e85f73afb6384123e5ef1bba3315b2e3ad031e ]

This will be used in the conversion of ipv6_stub to ip6_dst_lookup_flow,
as some modules currently pass a net argument without a socket to
ip6_dst_lookup. This is equivalent to commit 343d60aada5a ("ipv6: change
ipv6_stub_impl.ipv6_dst_lookup to take net argument").

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h               |    2 +-
 net/dccp/ipv6.c                  |    6 +++---
 net/ipv6/af_inet6.c              |    2 +-
 net/ipv6/datagram.c              |    2 +-
 net/ipv6/inet6_connection_sock.c |    4 ++--
 net/ipv6/ip6_output.c            |    8 ++++----
 net/ipv6/raw.c                   |    2 +-
 net/ipv6/syncookies.c            |    2 +-
 net/ipv6/tcp_ipv6.c              |    4 ++--
 net/l2tp/l2tp_ip6.c              |    2 +-
 net/sctp/ipv6.c                  |    4 ++--
 11 files changed, 19 insertions(+), 19 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1017,7 +1017,7 @@ static inline struct sk_buff *ip6_finish
 
 int ip6_dst_lookup(struct net *net, struct sock *sk, struct dst_entry **dst,
 		   struct flowi6 *fl6);
-struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
+struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, struct flowi6 *fl6,
 				      const struct in6_addr *final_dst);
 struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 					 const struct in6_addr *final_dst,
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -210,7 +210,7 @@ static int dccp_v6_send_response(const s
 	final_p = fl6_update_dst(&fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
@@ -281,7 +281,7 @@ static void dccp_v6_ctl_send_reset(const
 	security_skb_classify_flow(rxskb, flowi6_to_flowi(&fl6));
 
 	/* sk = NULL, but it is safe for now. RST socket required. */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(skb, dst);
 		ip6_xmit(ctl_sk, skb, &fl6, 0, NULL, 0);
@@ -911,7 +911,7 @@ static int dccp_v6_connect(struct sock *
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
 	final_p = fl6_update_dst(&fl6, opt, &final);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -765,7 +765,7 @@ int inet6_sk_rebuild_header(struct sock
 					 &final);
 		rcu_read_unlock();
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
 			sk->sk_route_caps = 0;
 			sk->sk_err_soft = -PTR_ERR(dst);
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -85,7 +85,7 @@ int ip6_datagram_dst_update(struct sock
 	final_p = fl6_update_dst(&fl6, opt, &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -48,7 +48,7 @@ struct dst_entry *inet6_csk_route_req(co
 	fl6->flowi6_uid = sk->sk_uid;
 	security_req_classify_flow(req, flowi6_to_flowi(fl6));
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (IS_ERR(dst))
 		return NULL;
 
@@ -103,7 +103,7 @@ static struct dst_entry *inet6_csk_route
 
 	dst = __inet6_csk_dst_check(sk, np->dst_cookie);
 	if (!dst) {
-		dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (!IS_ERR(dst))
 			ip6_dst_store(sk, dst, NULL, NULL);
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1144,19 +1144,19 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup);
  *	It returns a valid dst pointer on success, or a pointer encoded
  *	error code.
  */
-struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
+struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, struct flowi6 *fl6,
 				      const struct in6_addr *final_dst)
 {
 	struct dst_entry *dst = NULL;
 	int err;
 
-	err = ip6_dst_lookup_tail(sock_net(sk), sk, &dst, fl6);
+	err = ip6_dst_lookup_tail(net, sk, &dst, fl6);
 	if (err)
 		return ERR_PTR(err);
 	if (final_dst)
 		fl6->daddr = *final_dst;
 
-	return xfrm_lookup_route(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
+	return xfrm_lookup_route(net, dst, flowi6_to_flowi(fl6), sk, 0);
 }
 EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
 
@@ -1188,7 +1188,7 @@ struct dst_entry *ip6_sk_dst_lookup_flow
 	if (dst)
 		return dst;
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_dst);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_dst);
 	if (connected && !IS_ERR(dst))
 		ip6_sk_dst_store_flow(sk, dst_clone(dst), fl6);
 
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -923,7 +923,7 @@ static int rawv6_sendmsg(struct sock *sk
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -235,7 +235,7 @@ struct sock *cookie_v6_check(struct sock
 		fl6.flowi6_uid = sk->sk_uid;
 		security_req_classify_flow(req, flowi6_to_flowi(&fl6));
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst))
 			goto out_free;
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -275,7 +275,7 @@ static int tcp_v6_connect(struct sock *s
 
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
@@ -904,7 +904,7 @@ static void tcp_v6_send_response(const s
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass);
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -615,7 +615,7 @@ static int l2tp_ip6_sendmsg(struct sock
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -275,7 +275,7 @@ static void sctp_v6_get_dst(struct sctp_
 	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (!asoc || saddr)
 		goto out;
 
@@ -328,7 +328,7 @@ static void sctp_v6_get_dst(struct sctp_
 		fl6->saddr = laddr->a.v6.sin6_addr;
 		fl6->fl6_sport = laddr->a.v6.sin6_port;
 		final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
-		bdst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		bdst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (IS_ERR(bdst))
 			continue;


