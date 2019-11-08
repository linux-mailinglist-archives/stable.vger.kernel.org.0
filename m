Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C725AF56C8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbfKHTLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391965AbfKHTLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:11:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E6DE2196F;
        Fri,  8 Nov 2019 19:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240261;
        bh=gjoPCSILHwuU3y7q+K+akWUjlTpLkNP/LKI16h9REto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfPH63CU1mH2eNKhCzfOyiSRApUnuawHapFDje8X9wiX6Laa7p52xWRo+dODTpn6r
         wBpCecmfgfVsnmGNLg3XPyHXO2ZU13WgWWfJAZFwLM/MrunCMeiU+mfKi/py7taF2J
         6WBoLeBn58LMKb1/FX2BIEOBHfAru4RsWoJSq7iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Patrick=20Sch=C3=B6nthaler?= <patrick@notvads.ovh>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 120/140] ipv4: fix IPSKB_FRAG_PMTU handling with fragmentation
Date:   Fri,  8 Nov 2019 19:50:48 +0100
Message-Id: <20191108174912.324185143@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5 ]

This patch removes the iph field from the state structure, which is not
properly initialized. Instead, add a new field to make the "do we want
to set DF" be the state bit and move the code to set the DF flag from
ip_frag_next().

Joint work with Pablo and Linus.

Fixes: 19c3401a917b ("net: ipv4: place control buffer handling away from fragmentation iterators")
Reported-by: Patrick Schönthaler <patrick@notvads.ovh>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h                           |    4 ++--
 net/bridge/netfilter/nf_conntrack_bridge.c |    2 +-
 net/ipv4/ip_output.c                       |   11 ++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -184,7 +184,7 @@ static inline struct sk_buff *ip_fraglis
 }
 
 struct ip_frag_state {
-	struct iphdr	*iph;
+	bool		DF;
 	unsigned int	hlen;
 	unsigned int	ll_rs;
 	unsigned int	mtu;
@@ -195,7 +195,7 @@ struct ip_frag_state {
 };
 
 void ip_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int ll_rs,
-		  unsigned int mtu, struct ip_frag_state *state);
+		  unsigned int mtu, bool DF, struct ip_frag_state *state);
 struct sk_buff *ip_frag_next(struct sk_buff *skb,
 			     struct ip_frag_state *state);
 
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -94,7 +94,7 @@ slow_path:
 	 * This may also be a clone skbuff, we could preserve the geometry for
 	 * the copies but probably not worth the effort.
 	 */
-	ip_frag_init(skb, hlen, ll_rs, frag_max_size, &state);
+	ip_frag_init(skb, hlen, ll_rs, frag_max_size, false, &state);
 
 	while (state.left > 0) {
 		struct sk_buff *skb2;
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -645,11 +645,12 @@ void ip_fraglist_prepare(struct sk_buff
 EXPORT_SYMBOL(ip_fraglist_prepare);
 
 void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
-		  unsigned int ll_rs, unsigned int mtu,
+		  unsigned int ll_rs, unsigned int mtu, bool DF,
 		  struct ip_frag_state *state)
 {
 	struct iphdr *iph = ip_hdr(skb);
 
+	state->DF = DF;
 	state->hlen = hlen;
 	state->ll_rs = ll_rs;
 	state->mtu = mtu;
@@ -668,9 +669,6 @@ static void ip_frag_ipcb(struct sk_buff
 	/* Copy the flags to each fragment. */
 	IPCB(to)->flags = IPCB(from)->flags;
 
-	if (IPCB(from)->flags & IPSKB_FRAG_PMTU)
-		state->iph->frag_off |= htons(IP_DF);
-
 	/* ANK: dirty, but effective trick. Upgrade options only if
 	 * the segment to be fragmented was THE FIRST (otherwise,
 	 * options are already fixed) and make it ONCE
@@ -738,6 +736,8 @@ struct sk_buff *ip_frag_next(struct sk_b
 	 */
 	iph = ip_hdr(skb2);
 	iph->frag_off = htons((state->offset >> 3));
+	if (state->DF)
+		iph->frag_off |= htons(IP_DF);
 
 	/*
 	 *	Added AC : If we are fragmenting a fragment that's not the
@@ -881,7 +881,8 @@ slow_path:
 	 *	Fragment the datagram.
 	 */
 
-	ip_frag_init(skb, hlen, ll_rs, mtu, &state);
+	ip_frag_init(skb, hlen, ll_rs, mtu, IPCB(skb)->flags & IPSKB_FRAG_PMTU,
+		     &state);
 
 	/*
 	 *	Keep copying data until we run out.


