Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B2A10B889
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfK0Uo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbfK0Uo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16D542158A;
        Wed, 27 Nov 2019 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887466;
        bh=qgj2vyTA3YFVevW3R4p4edeEoRJfzSV9gm9IqOFXZLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF6oiRkCpnl8StmBjVNSy7/0iSTX1DRcjgc8oM6V4VERlxrg/1fLdwF7ABgPJwluA
         nOGXER6867HN37ITp+xhXMT51tPWCaJsOdFpOlYAGehmjCMvSxyDW+btjL0vKEbl28
         LkLHF1Xxb39yn4IN0Lxr6Zc1lpm30Ud5u3kZmdqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Schier <n.schier@avm.de>
Subject: [PATCH 4.9 123/151] l2tp: dont use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6
Date:   Wed, 27 Nov 2019 21:31:46 +0100
Message-Id: <20191127203045.193982777@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 8f7dc9ae4a7aece9fbc3e6637bdfa38b36bcdf09 upstream.

Using l2tp_tunnel_find() in l2tp_ip_recv() is wrong for two reasons:

  * It doesn't take a reference on the returned tunnel, which makes the
    call racy wrt. concurrent tunnel deletion.

  * The lookup is only based on the tunnel identifier, so it can return
    a tunnel that doesn't match the packet's addresses or protocol.

For example, a packet sent to an L2TPv3 over IPv6 tunnel can be
delivered to an L2TPv2 over UDPv4 tunnel. This is worse than a simple
cross-talk: when delivering the packet to an L2TP over UDP tunnel, the
corresponding socket is UDP, where ->sk_backlog_rcv() is NULL. Calling
sk_receive_skb() will then crash the kernel by trying to execute this
callback.

And l2tp_tunnel_find() isn't even needed here. __l2tp_ip_bind_lookup()
properly checks the socket binding and connection settings. It was used
as a fallback mechanism for finding tunnels that didn't have their data
path registered yet. But it's not limited to this case and can be used
to replace l2tp_tunnel_find() in the general case.

Fix l2tp_ip6 in the same way.

Fixes: 0d76751fad77 ("l2tp: Add L2TPv3 IP encapsulation (no UDP) support")
Fixes: a32e0eec7042 ("l2tp: introduce L2TPv3 IP encapsulation support for IPv6")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_ip.c  |   24 +++++++++---------------
 net/l2tp/l2tp_ip6.c |   24 +++++++++---------------
 2 files changed, 18 insertions(+), 30 deletions(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -116,6 +116,7 @@ static int l2tp_ip_recv(struct sk_buff *
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct iphdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -174,24 +175,17 @@ pass_up:
 		goto discard;
 
 	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel) {
-		sk = tunnel->sock;
-		sock_hold(sk);
-	} else {
-		struct iphdr *iph = (struct iphdr *) skb_network_header(skb);
-
-		read_lock_bh(&l2tp_ip_lock);
-		sk = __l2tp_ip_bind_lookup(net, iph->daddr, iph->saddr,
-					   inet_iif(skb), tunnel_id);
-		if (!sk) {
-			read_unlock_bh(&l2tp_ip_lock);
-			goto discard;
-		}
+	iph = (struct iphdr *)skb_network_header(skb);
 
-		sock_hold(sk);
+	read_lock_bh(&l2tp_ip_lock);
+	sk = __l2tp_ip_bind_lookup(net, iph->daddr, iph->saddr, inet_iif(skb),
+				   tunnel_id);
+	if (!sk) {
 		read_unlock_bh(&l2tp_ip_lock);
+		goto discard;
 	}
+	sock_hold(sk);
+	read_unlock_bh(&l2tp_ip_lock);
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -128,6 +128,7 @@ static int l2tp_ip6_recv(struct sk_buff
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct ipv6hdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -187,24 +188,17 @@ pass_up:
 		goto discard;
 
 	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel) {
-		sk = tunnel->sock;
-		sock_hold(sk);
-	} else {
-		struct ipv6hdr *iph = ipv6_hdr(skb);
-
-		read_lock_bh(&l2tp_ip6_lock);
-		sk = __l2tp_ip6_bind_lookup(net, &iph->daddr, &iph->saddr,
-					    inet6_iif(skb), tunnel_id);
-		if (!sk) {
-			read_unlock_bh(&l2tp_ip6_lock);
-			goto discard;
-		}
+	iph = ipv6_hdr(skb);
 
-		sock_hold(sk);
+	read_lock_bh(&l2tp_ip6_lock);
+	sk = __l2tp_ip6_bind_lookup(net, &iph->daddr, &iph->saddr,
+				    inet6_iif(skb), tunnel_id);
+	if (!sk) {
 		read_unlock_bh(&l2tp_ip6_lock);
+		goto discard;
 	}
+	sock_hold(sk);
+	read_unlock_bh(&l2tp_ip6_lock);
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;


