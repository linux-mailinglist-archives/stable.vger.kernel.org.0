Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B291A51DF
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDKMKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgDKMKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:10:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893BF21655;
        Sat, 11 Apr 2020 12:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607049;
        bh=VjfUFGR/xtBTcnZy5bIR28Rr7orkr52e/SB573hhVPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrJc+CrD6lgXUr1Q54jsW6YHUKUcu1tWrF1+7GhfQRSiYqtsphCQ58F/3qZ045sxD
         zD16KB1Al5R89BnZfWyDPe4T3KrtV6rV0xP9BMSFHpMCCQy5NH81mNthgdSdTfCvY2
         jhn36vEqlP0syVg1HaTQH1a1uTtGcJFx1Ol47K9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.4 06/29] net: l2tp: Make l2tp_ip6 namespace aware
Date:   Sat, 11 Apr 2020 14:08:36 +0200
Message-Id: <20200411115408.535065386@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

commit 0e6b5259824e97a0f7e7b450421ff12865d3b0e2 upstream.

l2tp_ip6 tunnel and session lookups were still using init_net, although
the l2tp core infrastructure already supports lookups keyed by 'net'.

As a result, l2tp_ip6_recv discarded packets for tunnels/sessions
created in namespaces other than the init_net.

Fix, by using dev_net(skb->dev) or sock_net(sk) where appropriate.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip6.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -127,6 +127,7 @@ static inline struct sock *l2tp_ip6_bind
  */
 static int l2tp_ip6_recv(struct sk_buff *skb)
 {
+	struct net *net = dev_net(skb->dev);
 	struct sock *sk;
 	u32 session_id;
 	u32 tunnel_id;
@@ -153,7 +154,7 @@ static int l2tp_ip6_recv(struct sk_buff
 	}
 
 	/* Ok, this is a data packet. Lookup the session. */
-	session = l2tp_session_find(&init_net, NULL, session_id);
+	session = l2tp_session_find(net, NULL, session_id);
 	if (session == NULL)
 		goto discard;
 
@@ -190,7 +191,7 @@ pass_up:
 		goto discard;
 
 	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
-	tunnel = l2tp_tunnel_find(&init_net, tunnel_id);
+	tunnel = l2tp_tunnel_find(net, tunnel_id);
 	if (tunnel) {
 		sk = tunnel->sock;
 		sock_hold(sk);
@@ -198,7 +199,7 @@ pass_up:
 		struct ipv6hdr *iph = ipv6_hdr(skb);
 
 		read_lock_bh(&l2tp_ip6_lock);
-		sk = __l2tp_ip6_bind_lookup(&init_net, &iph->daddr,
+		sk = __l2tp_ip6_bind_lookup(net, &iph->daddr,
 					    0, tunnel_id);
 		if (!sk) {
 			read_unlock_bh(&l2tp_ip6_lock);
@@ -267,6 +268,7 @@ static int l2tp_ip6_bind(struct sock *sk
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sockaddr_l2tpip6 *addr = (struct sockaddr_l2tpip6 *) uaddr;
+	struct net *net = sock_net(sk);
 	__be32 v4addr = 0;
 	int addr_type;
 	int err;
@@ -288,7 +290,7 @@ static int l2tp_ip6_bind(struct sock *sk
 
 	err = -EADDRINUSE;
 	read_lock_bh(&l2tp_ip6_lock);
-	if (__l2tp_ip6_bind_lookup(&init_net, &addr->l2tp_addr,
+	if (__l2tp_ip6_bind_lookup(net, &addr->l2tp_addr,
 				   sk->sk_bound_dev_if, addr->l2tp_conn_id))
 		goto out_in_use;
 	read_unlock_bh(&l2tp_ip6_lock);
@@ -461,7 +463,7 @@ static int l2tp_ip6_backlog_recv(struct
 	return 0;
 
 drop:
-	IP_INC_STATS(&init_net, IPSTATS_MIB_INDISCARDS);
+	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_INDISCARDS);
 	kfree_skb(skb);
 	return -1;
 }


