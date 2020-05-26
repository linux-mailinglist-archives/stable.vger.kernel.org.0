Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B2B1D8658
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgERRoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbgERRoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEA5E207C4;
        Mon, 18 May 2020 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823858;
        bh=ni61Lb3so+c94aGxBZ5mBAfGTe6FDyHyWoY6Aynl3Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjjSt6j8YnnzFW66HJ0wfubnDxAQvS8LMZkQ9F54amqiJcoAM733str61lvNX2JMr
         p2c0z/yhDyCWvnQSUojaseFeEd7lNkRY9gVmvI9RA/Mw3/iJBvEcxDvocl5RG4qEsv
         9kSZMt9GK/EWnavRtJm/3QziAWX5e4cC0zhhN5K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 27/90] net: ipv6: add net argument to ip6_dst_lookup_flow
Date:   Mon, 18 May 2020 19:36:05 +0200
Message-Id: <20200518173456.741150185@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit c4e85f73afb6384123e5ef1bba3315b2e3ad031e upstream.

This will be used in the conversion of ipv6_stub to ip6_dst_lookup_flow,
as some modules currently pass a net argument without a socket to
ip6_dst_lookup. This is equivalent to commit 343d60aada5a ("ipv6: change
ipv6_stub_impl.ipv6_dst_lookup to take net argument").

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h               | 2 +-
 net/dccp/ipv6.c                  | 6 +++---
 net/ipv6/af_inet6.c              | 2 +-
 net/ipv6/datagram.c              | 2 +-
 net/ipv6/inet6_connection_sock.c | 4 ++--
 net/ipv6/ip6_output.c            | 8 ++++----
 net/ipv6/raw.c                   | 2 +-
 net/ipv6/syncookies.c            | 2 +-
 net/ipv6/tcp_ipv6.c              | 4 ++--
 net/l2tp/l2tp_ip6.c              | 2 +-
 net/sctp/ipv6.c                  | 4 ++--
 11 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 168009eef5e42..1a48e10ec617d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -856,7 +856,7 @@ static inline struct sk_buff *ip6_finish_skb(struct sock *sk)
 
 int ip6_dst_lookup(struct net *net, struct sock *sk, struct dst_entry **dst,
 		   struct flowi6 *fl6);
-struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
+struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, struct flowi6 *fl6,
 				      const struct in6_addr *final_dst);
 struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 					 const struct in6_addr *final_dst);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 87c513b5ff2eb..9438873fc3c87 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -209,7 +209,7 @@ static int dccp_v6_send_response(const struct sock *sk, struct request_sock *req
 	final_p = fl6_update_dst(&fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
@@ -280,7 +280,7 @@ static void dccp_v6_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	security_skb_classify_flow(rxskb, flowi6_to_flowi(&fl6));
 
 	/* sk = NULL, but it is safe for now. RST socket required. */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(skb, dst);
 		ip6_xmit(ctl_sk, skb, &fl6, 0, NULL, 0);
@@ -889,7 +889,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
 	final_p = fl6_update_dst(&fl6, opt, &final);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 8885dbad217b1..2e91637c9d491 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -702,7 +702,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 					 &final);
 		rcu_read_unlock();
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
 			sk->sk_route_caps = 0;
 			sk->sk_err_soft = -PTR_ERR(dst);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 956af11e9ba3e..58929622de0ea 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -87,7 +87,7 @@ int ip6_datagram_dst_update(struct sock *sk, bool fix_sk_saddr)
 	final_p = fl6_update_dst(&fl6, opt, &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 798a0950e9a62..b760ccec44d3c 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -90,7 +90,7 @@ struct dst_entry *inet6_csk_route_req(const struct sock *sk,
 	fl6->fl6_sport = htons(ireq->ir_num);
 	security_req_classify_flow(req, flowi6_to_flowi(fl6));
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (IS_ERR(dst))
 		return NULL;
 
@@ -144,7 +144,7 @@ static struct dst_entry *inet6_csk_route_socket(struct sock *sk,
 
 	dst = __inet6_csk_dst_check(sk, np->dst_cookie);
 	if (!dst) {
-		dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (!IS_ERR(dst))
 			ip6_dst_store(sk, dst, NULL, NULL);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 11407dd6bc7c0..d93a98dfe52df 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1075,19 +1075,19 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup);
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
 
@@ -1112,7 +1112,7 @@ struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 
 	dst = ip6_sk_dst_check(sk, dst, fl6);
 	if (!dst)
-		dst = ip6_dst_lookup_flow(sk, fl6, final_dst);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_dst);
 
 	return dst;
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 301978df650e6..47acd20d4e1fc 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -920,7 +920,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 7a86433d8896b..4834015b27f49 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -230,7 +230,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		fl6.fl6_sport = inet_sk(sk)->inet_sport;
 		security_req_classify_flow(req, flowi6_to_flowi(&fl6));
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst))
 			goto out_free;
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4953466cf98f0..7b336b7803ffa 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -244,7 +244,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
@@ -841,7 +841,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 423cb095ad37c..28274f397c55e 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -620,7 +620,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 34ab7f92f0643..50bc8c4ca9068 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -269,7 +269,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (!asoc || saddr) {
 		t->dst = dst;
 		memcpy(fl, &_fl, sizeof(_fl));
@@ -327,7 +327,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		fl6->saddr = laddr->a.v6.sin6_addr;
 		fl6->fl6_sport = laddr->a.v6.sin6_port;
 		final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
-		bdst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		bdst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (IS_ERR(bdst))
 			continue;
-- 
2.20.1



