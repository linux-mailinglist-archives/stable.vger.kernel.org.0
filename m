Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E7D1D8695
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgERSZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbgERRq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F7920835;
        Mon, 18 May 2020 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824018;
        bh=nHSQxOA4eFPm92ICM5ysEkiKPtETBhECb66sYho+7ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idh+Vzwr3rWJjYLOrl4WnCfsTR+OF4p4E3Dtev/lDXgVYdIqaEJ8xkhg0XzB6UA2e
         AG3y3SVKVU6+QeZe9aP8l9RO/FKu2WPSJM01eMtlzo0PEuq35vBM15fTywVMNPagD8
         xHpOM+xTFaansGD4rAd+whQ70HFG4ETUOqUsnUQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 037/114] net: ipv6: add net argument to ip6_dst_lookup_flow
Date:   Mon, 18 May 2020 19:36:09 +0200
Message-Id: <20200518173510.312452422@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
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
[bwh: Backported to 4.14: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
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
@@ -862,7 +862,7 @@ static inline struct sk_buff *ip6_finish
 
 int ip6_dst_lookup(struct net *net, struct sock *sk, struct dst_entry **dst,
 		   struct flowi6 *fl6);
-struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
+struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, struct flowi6 *fl6,
 				      const struct in6_addr *final_dst);
 struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 					 const struct in6_addr *final_dst);
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -211,7 +211,7 @@ static int dccp_v6_send_response(const s
 	final_p = fl6_update_dst(&fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
@@ -282,7 +282,7 @@ static void dccp_v6_ctl_send_reset(const
 	security_skb_classify_flow(rxskb, flowi6_to_flowi(&fl6));
 
 	/* sk = NULL, but it is safe for now. RST socket required. */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(skb, dst);
 		ip6_xmit(ctl_sk, skb, &fl6, 0, NULL, 0);
@@ -912,7 +912,7 @@ static int dccp_v6_connect(struct sock *
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
 	final_p = fl6_update_dst(&fl6, opt, &final);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -716,7 +716,7 @@ int inet6_sk_rebuild_header(struct sock
 					 &final);
 		rcu_read_unlock();
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
 			sk->sk_route_caps = 0;
 			sk->sk_err_soft = -PTR_ERR(dst);
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -88,7 +88,7 @@ int ip6_datagram_dst_update(struct sock
 	final_p = fl6_update_dst(&fl6, opt, &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -52,7 +52,7 @@ struct dst_entry *inet6_csk_route_req(co
 	fl6->flowi6_uid = sk->sk_uid;
 	security_req_classify_flow(req, flowi6_to_flowi(fl6));
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (IS_ERR(dst))
 		return NULL;
 
@@ -107,7 +107,7 @@ static struct dst_entry *inet6_csk_route
 
 	dst = __inet6_csk_dst_check(sk, np->dst_cookie);
 	if (!dst) {
-		dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (!IS_ERR(dst))
 			ip6_dst_store(sk, dst, NULL, NULL);
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1089,19 +1089,19 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup);
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
 
@@ -1126,7 +1126,7 @@ struct dst_entry *ip6_sk_dst_lookup_flow
 
 	dst = ip6_sk_dst_check(sk, dst, fl6);
 	if (!dst)
-		dst = ip6_dst_lookup_flow(sk, fl6, final_dst);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_dst);
 
 	return dst;
 }
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -929,7 +929,7 @@ static int rawv6_sendmsg(struct sock *sk
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -238,7 +238,7 @@ struct sock *cookie_v6_check(struct sock
 		fl6.flowi6_uid = sk->sk_uid;
 		security_req_classify_flow(req, flowi6_to_flowi(&fl6));
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst))
 			goto out_free;
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -252,7 +252,7 @@ static int tcp_v6_connect(struct sock *s
 
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
@@ -865,7 +865,7 @@ static void tcp_v6_send_response(const s
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
@@ -629,7 +629,7 @@ static int l2tp_ip6_sendmsg(struct sock
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -271,7 +271,7 @@ static void sctp_v6_get_dst(struct sctp_
 	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (!asoc || saddr) {
 		t->dst = dst;
 		memcpy(fl, &_fl, sizeof(_fl));
@@ -329,7 +329,7 @@ static void sctp_v6_get_dst(struct sctp_
 		fl6->saddr = laddr->a.v6.sin6_addr;
 		fl6->fl6_sport = laddr->a.v6.sin6_port;
 		final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
-		bdst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		bdst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (IS_ERR(bdst))
 			continue;


