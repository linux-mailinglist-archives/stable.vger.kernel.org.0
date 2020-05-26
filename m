Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B51E2F17
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389732AbgEZTdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgEZS4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50847208B6;
        Tue, 26 May 2020 18:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519362;
        bh=O6m7d4JmFmQOQvDC8Pcbvpu1uaUd2naCs1xGgWdYlCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6Quc7gVAfUMX5EtuDQ6ssH1GpMw7uWfJqocw8hzSa2h9byQAuq4wCaF2hx6MxTLL
         plFz5+IO1FTluUn0Yi5xhu1A6Y5f72PB4wbwV3lL+dbgSdwEoHvAFylW8i+3bvUCQx
         +ZkPYlWZzGBoxsL6SXOQ3X/vcr7ndbEsg291Qug8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Schier <n.schier@avm.de>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 38/65] l2tp: dont use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6
Date:   Tue, 26 May 2020 20:52:57 +0200
Message-Id: <20200526183919.007164109@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
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
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip.c  |   22 ++++++++--------------
 net/l2tp/l2tp_ip6.c |   23 ++++++++---------------
 2 files changed, 16 insertions(+), 29 deletions(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -122,6 +122,7 @@ static int l2tp_ip_recv(struct sk_buff *
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct iphdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -180,23 +181,16 @@ pass_up:
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
-		sk = __l2tp_ip_bind_lookup(net, iph->daddr, 0, tunnel_id);
-		if (!sk) {
-			read_unlock_bh(&l2tp_ip_lock);
-			goto discard;
-		}
+	iph = (struct iphdr *)skb_network_header(skb);
 
-		sock_hold(sk);
+	read_lock_bh(&l2tp_ip_lock);
+	sk = __l2tp_ip_bind_lookup(net, iph->daddr, 0, tunnel_id);
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
@@ -134,6 +134,7 @@ static int l2tp_ip6_recv(struct sk_buff
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct ipv6hdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -193,24 +194,16 @@ pass_up:
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
-		sk = __l2tp_ip6_bind_lookup(net, &iph->daddr,
-					    0, tunnel_id);
-		if (!sk) {
-			read_unlock_bh(&l2tp_ip6_lock);
-			goto discard;
-		}
+	iph = ipv6_hdr(skb);
 
-		sock_hold(sk);
+	read_lock_bh(&l2tp_ip6_lock);
+	sk = __l2tp_ip6_bind_lookup(net, &iph->daddr, 0, tunnel_id);
+	if (!sk) {
 		read_unlock_bh(&l2tp_ip6_lock);
+		goto discard;
 	}
+	sock_hold(sk);
+	read_unlock_bh(&l2tp_ip6_lock);
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;


