Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE52B642F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgKQNiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732516AbgKQNiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF3622467A;
        Tue, 17 Nov 2020 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620289;
        bh=r1l6VpMHl4LT2wpy1CIy1ZrDkRuIB2yk8/82xH6+dGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVgBGGMjacrmXNHO3EVqiZZPvX9KfaZWfmlWsqetdmPGTpMZSWPj6vupo48kK/DMS
         aMuEvTbflzrH0D+fLGw3lX5EskSLlmiddgZi0lLI1sQa+6R036EYVICdLBoHBwpTKV
         pSQocnCVN/F7QFY1GSz9hG9KuRgwxsjgmIsZejHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 170/255] vrf: Fix fast path output packet handling with async Netfilter rules
Date:   Tue, 17 Nov 2020 14:05:10 +0100
Message-Id: <20201117122147.211623472@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 9e2b7fa2df4365e99934901da4fb4af52d81e820 ]

VRF devices use an optimized direct path on output if a default qdisc
is involved, calling Netfilter hooks directly. This path, however, does
not consider Netfilter rules completing asynchronously, such as with
NFQUEUE. The Netfilter okfn() is called for asynchronously accepted
packets, but the VRF never passes that packet down the stack to send
it out over the slave device. Using the slower redirect path for this
seems not feasible, as we do not know beforehand if a Netfilter hook
has asynchronously completing rules.

Fix the use of asynchronously completing Netfilter rules in OUTPUT and
POSTROUTING by using a special completion function that additionally
calls dst_output() to pass the packet down the stack. Also, slightly
adjust the use of nf_reset_ct() so that is called in the asynchronous
case, too.

Fixes: dcdd43c41e60 ("net: vrf: performance improvements for IPv4")
Fixes: a9ec54d1b0cd ("net: vrf: performance improvements for IPv6")
Signed-off-by: Martin Willi <martin@strongswan.org>
Link: https://lore.kernel.org/r/20201106073030.3974927-1-martin@strongswan.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 92 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 23 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 60c1aadece89a..f2793ffde1913 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -608,8 +608,7 @@ static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-static int vrf_finish_direct(struct net *net, struct sock *sk,
-			     struct sk_buff *skb)
+static void vrf_finish_direct(struct sk_buff *skb)
 {
 	struct net_device *vrf_dev = skb->dev;
 
@@ -628,7 +627,8 @@ static int vrf_finish_direct(struct net *net, struct sock *sk,
 		skb_pull(skb, ETH_HLEN);
 	}
 
-	return 1;
+	/* reset skb device */
+	nf_reset_ct(skb);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -707,15 +707,41 @@ static struct sk_buff *vrf_ip6_out_redirect(struct net_device *vrf_dev,
 	return skb;
 }
 
+static int vrf_output6_direct_finish(struct net *net, struct sock *sk,
+				     struct sk_buff *skb)
+{
+	vrf_finish_direct(skb);
+
+	return vrf_ip6_local_out(net, sk, skb);
+}
+
 static int vrf_output6_direct(struct net *net, struct sock *sk,
 			      struct sk_buff *skb)
 {
+	int err = 1;
+
 	skb->protocol = htons(ETH_P_IPV6);
 
-	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, skb->dev,
-			    vrf_finish_direct,
-			    !(IPCB(skb)->flags & IPSKB_REROUTED));
+	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
+		err = nf_hook(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
+			      NULL, skb->dev, vrf_output6_direct_finish);
+
+	if (likely(err == 1))
+		vrf_finish_direct(skb);
+
+	return err;
+}
+
+static int vrf_ip6_out_direct_finish(struct net *net, struct sock *sk,
+				     struct sk_buff *skb)
+{
+	int err;
+
+	err = vrf_output6_direct(net, sk, skb);
+	if (likely(err == 1))
+		err = vrf_ip6_local_out(net, sk, skb);
+
+	return err;
 }
 
 static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
@@ -728,18 +754,15 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
 	skb->dev = vrf_dev;
 
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
-		      skb, NULL, vrf_dev, vrf_output6_direct);
+		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
 
 	if (likely(err == 1))
 		err = vrf_output6_direct(net, sk, skb);
 
-	/* reset skb device */
 	if (likely(err == 1))
-		nf_reset_ct(skb);
-	else
-		skb = NULL;
+		return skb;
 
-	return skb;
+	return NULL;
 }
 
 static struct sk_buff *vrf_ip6_out(struct net_device *vrf_dev,
@@ -919,15 +942,41 @@ static struct sk_buff *vrf_ip_out_redirect(struct net_device *vrf_dev,
 	return skb;
 }
 
+static int vrf_output_direct_finish(struct net *net, struct sock *sk,
+				    struct sk_buff *skb)
+{
+	vrf_finish_direct(skb);
+
+	return vrf_ip_local_out(net, sk, skb);
+}
+
 static int vrf_output_direct(struct net *net, struct sock *sk,
 			     struct sk_buff *skb)
 {
+	int err = 1;
+
 	skb->protocol = htons(ETH_P_IP);
 
-	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, skb->dev,
-			    vrf_finish_direct,
-			    !(IPCB(skb)->flags & IPSKB_REROUTED));
+	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
+		err = nf_hook(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, sk, skb,
+			      NULL, skb->dev, vrf_output_direct_finish);
+
+	if (likely(err == 1))
+		vrf_finish_direct(skb);
+
+	return err;
+}
+
+static int vrf_ip_out_direct_finish(struct net *net, struct sock *sk,
+				    struct sk_buff *skb)
+{
+	int err;
+
+	err = vrf_output_direct(net, sk, skb);
+	if (likely(err == 1))
+		err = vrf_ip_local_out(net, sk, skb);
+
+	return err;
 }
 
 static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
@@ -940,18 +989,15 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
 	skb->dev = vrf_dev;
 
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
-		      skb, NULL, vrf_dev, vrf_output_direct);
+		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
 
 	if (likely(err == 1))
 		err = vrf_output_direct(net, sk, skb);
 
-	/* reset skb device */
 	if (likely(err == 1))
-		nf_reset_ct(skb);
-	else
-		skb = NULL;
+		return skb;
 
-	return skb;
+	return NULL;
 }
 
 static struct sk_buff *vrf_ip_out(struct net_device *vrf_dev,
-- 
2.27.0



