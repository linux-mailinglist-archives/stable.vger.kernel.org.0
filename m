Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8601A10AD49
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 11:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfK0KKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 05:10:21 -0500
Received: from mail.avm.de ([212.42.244.94]:50692 "EHLO mail.avm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfK0KKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 05:10:20 -0500
Received: from mail-notes.avm.de (unknown [172.16.0.1])
        by mail.avm.de (Postfix) with ESMTP;
        Wed, 27 Nov 2019 11:02:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1574848976; bh=xuETXxlsDVW1SR9RRejhuTraJnE3uAPUPmjVYd9yZ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqw0++Fo+ScN6BJ3y8KxJl3mRsaDVOzBsqkcGkFLK7N4068zMrebeTjsv9xH8vLpZ
         u0MBBc3kUqAhHtAYqvM7Itp+IpmD563PChPsCvfsvQfvqdBHcq1cCXsGk+qR1SPFFb
         8cjM3SlBXKHaS4OBkHhTLmFc+2pta4YruCW2lfEE=
Received: from buildd.avm.de. ([172.16.0.225])
          by mail-notes.avm.de (IBM Domino Release 10.0.1FP3)
          with ESMTP id 2019112711025606-4799 ;
          Wed, 27 Nov 2019 11:02:56 +0100 
From:   Nicolas Schier <n.schier@avm.de>
To:     stable@vger.kernel.org
Cc:     Nicolas Schier <n.schier@avm.de>,
        Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6
Date:   Wed, 27 Nov 2019 11:02:49 +0100
Message-Id: <bd3a519ba6770a838d09550f1a6602d5fb7e80cb.1574846983.git.n.schier@avm.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1574846983.git.n.schier@avm.de>
References: <cover.1574846983.git.n.schier@avm.de>
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ANIS1/AVM(Release 10.0.1FP3|August 09, 2019) at
 27.11.2019 11:02:56,
        Serialize by Router on ANIS1/AVM(Release 10.0.1FP3|August 09, 2019) at
 27.11.2019 11:02:56,
        Serialize complete at 27.11.2019 11:02:56
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1574848976-000004EC-CB64EA4C/0/0
X-purgate-type: clean
X-purgate-size: 4338
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
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
Signed-off-by: Nicolas Schier <n.schier@avm.de>
---
Please consider queuing this patch for v4.9.y.

 net/l2tp/l2tp_ip.c  | 24 +++++++++---------------
 net/l2tp/l2tp_ip6.c | 24 +++++++++---------------
 2 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 03a696d3bcd9..4a88c4eb2301 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -116,6 +116,7 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct iphdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -174,24 +175,17 @@ static int l2tp_ip_recv(struct sk_buff *skb)
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
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 8d412b9b0214..423cb095ad37 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -128,6 +128,7 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	unsigned char *ptr, *optr;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
+	struct ipv6hdr *iph;
 	int length;
 
 	if (!pskb_may_pull(skb, 4))
@@ -187,24 +188,17 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
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
-- 
2.24.0

