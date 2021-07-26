Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421C73D61EF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhGZPda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhGZPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B0E36101B;
        Mon, 26 Jul 2021 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315954;
        bh=I+j1R7JFes5EQdh/y4KW7KPcG3dh0Su3NbH2GfjzllU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCXWKFzkDgpce5jG6DfPGU1XSHLXUg/Dw3kVz5CV2Av6sW3vDklzC86Ie8a0Wh/cV
         aPYFXMBqnVk6oBzsHxe8OrZRTrP2nMfOgP7RWXap1AecRerUUSbcSNcoUXpwdhxGrl
         x6e98JUpcnVCoCErDauxhhIsYRSdJC5ptvNGAITQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 131/223] udp: check encap socket in __udp_lib_err
Date:   Mon, 26 Jul 2021 17:38:43 +0200
Message-Id: <20210726153850.535441761@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 9bfce73c8921c92a9565562e6e7d458d37b7ce80 ]

Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
added checks for encapsulated sockets but it broke cases when there is
no implementation of encap_err_lookup for encapsulation, i.e. ESP in
UDP encapsulation. Fix it by calling encap_err_lookup only if socket
implements this method otherwise treat it as legal socket.

Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 25 +++++++++++++++++++------
 net/ipv6/udp.c | 25 +++++++++++++++++++------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ca9cf1051b1e..568dc31a0467 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -645,10 +645,12 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 					 const struct iphdr *iph,
 					 struct udphdr *uh,
 					 struct udp_table *udptable,
+					 struct sock *sk,
 					 struct sk_buff *skb, u32 info)
 {
+	int (*lookup)(struct sock *sk, struct sk_buff *skb);
 	int network_offset, transport_offset;
-	struct sock *sk;
+	struct udp_sock *up;
 
 	network_offset = skb_network_offset(skb);
 	transport_offset = skb_transport_offset(skb);
@@ -659,18 +661,28 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
 	/* Transport header needs to point to the UDP header */
 	skb_set_transport_header(skb, iph->ihl << 2);
 
+	if (sk) {
+		up = udp_sk(sk);
+
+		lookup = READ_ONCE(up->encap_err_lookup);
+		if (lookup && lookup(sk, skb))
+			sk = NULL;
+
+		goto out;
+	}
+
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->source,
 			       iph->saddr, uh->dest, skb->dev->ifindex, 0,
 			       udptable, NULL);
 	if (sk) {
-		int (*lookup)(struct sock *sk, struct sk_buff *skb);
-		struct udp_sock *up = udp_sk(sk);
+		up = udp_sk(sk);
 
 		lookup = READ_ONCE(up->encap_err_lookup);
 		if (!lookup || lookup(sk, skb))
 			sk = NULL;
 	}
 
+out:
 	if (!sk)
 		sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
 
@@ -707,15 +719,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
+
 	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
-		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
-			sk = __udp4_lib_err_encap(net, iph, uh, udptable, skb,
+			sk = __udp4_lib_err_encap(net, iph, uh, udptable, sk, skb,
 						  info);
 			if (!sk)
 				return 0;
-		}
+		} else
+			sk = ERR_PTR(-ENOENT);
 
 		if (IS_ERR(sk)) {
 			__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6774e776228c..2d3bd4a9b0d0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -502,12 +502,14 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 					 const struct ipv6hdr *hdr, int offset,
 					 struct udphdr *uh,
 					 struct udp_table *udptable,
+					 struct sock *sk,
 					 struct sk_buff *skb,
 					 struct inet6_skb_parm *opt,
 					 u8 type, u8 code, __be32 info)
 {
+	int (*lookup)(struct sock *sk, struct sk_buff *skb);
 	int network_offset, transport_offset;
-	struct sock *sk;
+	struct udp_sock *up;
 
 	network_offset = skb_network_offset(skb);
 	transport_offset = skb_transport_offset(skb);
@@ -518,18 +520,28 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	/* Transport header needs to point to the UDP header */
 	skb_set_transport_header(skb, offset);
 
+	if (sk) {
+		up = udp_sk(sk);
+
+		lookup = READ_ONCE(up->encap_err_lookup);
+		if (lookup && lookup(sk, skb))
+			sk = NULL;
+
+		goto out;
+	}
+
 	sk = __udp6_lib_lookup(net, &hdr->daddr, uh->source,
 			       &hdr->saddr, uh->dest,
 			       inet6_iif(skb), 0, udptable, skb);
 	if (sk) {
-		int (*lookup)(struct sock *sk, struct sk_buff *skb);
-		struct udp_sock *up = udp_sk(sk);
+		up = udp_sk(sk);
 
 		lookup = READ_ONCE(up->encap_err_lookup);
 		if (!lookup || lookup(sk, skb))
 			sk = NULL;
 	}
 
+out:
 	if (!sk) {
 		sk = ERR_PTR(__udp6_lib_err_encap_no_sk(skb, opt, type, code,
 							offset, info));
@@ -558,16 +570,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
+
 	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
-		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
 			sk = __udp6_lib_err_encap(net, hdr, offset, uh,
-						  udptable, skb,
+						  udptable, sk, skb,
 						  opt, type, code, info);
 			if (!sk)
 				return 0;
-		}
+		} else
+			sk = ERR_PTR(-ENOENT);
 
 		if (IS_ERR(sk)) {
 			__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev),
-- 
2.30.2



