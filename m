Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBB4ACE0D
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfIHMuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbfIHMt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:59 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032F8218AF;
        Sun,  8 Sep 2019 12:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946998;
        bh=rgOL4NPiC/hkYKl5aZH8hax7VlWtjwmjNx7MfqoK1Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHteFJpsUTfstPoojzG7b4Z869JSZw5LRFI8iw+NtkNPiSdb80RDF8Sff9dUbW/V3
         iKyNJFdIR3CZsoJ67eZPs45nUjRbjnBY2EhDWW9Mfu3XdJJPRSGvik9Mpit+uH12Gk
         wRo25ta22hA8GT/l2rHEbbThFhwIuQ232COMm/aI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 23/94] netfilter: nf_flow_table: fix offload for flows that are subject to xfrm
Date:   Sun,  8 Sep 2019 13:41:19 +0100
Message-Id: <20190908121151.102445506@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 589b474a4b7ce409d6821ef17234a995841bd131 ]

This makes the previously added 'encap test' pass.
Because its possible that the xfrm dst entry becomes stale while such
a flow is offloaded, we need to call dst_check() -- the notifier that
handles this for non-tunneled traffic isn't sufficient, because SA or
or policies might have changed.

If dst becomes stale the flow offload entry will be tagged for teardown
and packets will be passed to 'classic' forwarding path.

Removing the entry right away is problematic, as this would
introduce a race condition with the gc worker.

In case flow is long-lived, it could eventually be offloaded again
once the gc worker removes the entry from the flow table.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 43 ++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index cdfc33517e85b..d68c801dd614b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -214,6 +214,25 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static int nf_flow_offload_dst_check(struct dst_entry *dst)
+{
+	if (unlikely(dst_xfrm(dst)))
+		return dst_check(dst, 0) ? 0 : -1;
+
+	return 0;
+}
+
+static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
+				      const struct nf_hook_state *state,
+				      struct dst_entry *dst)
+{
+	skb_orphan(skb);
+	skb_dst_set_noref(skb, dst);
+	skb->tstamp = 0;
+	dst_output(state->net, state->sk, skb);
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -254,6 +273,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -261,6 +285,13 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
 
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+		IPCB(skb)->iif = skb->dev->ifindex;
+		IPCB(skb)->flags = IPSKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
 	skb->dev = outdev;
 	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 	skb_dst_set_noref(skb, &rt->dst);
@@ -467,6 +498,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
@@ -477,6 +513,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
 
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
+		IP6CB(skb)->iif = skb->dev->ifindex;
+		IP6CB(skb)->flags = IP6SKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
 	skb->dev = outdev;
 	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 	skb_dst_set_noref(skb, &rt->dst);
-- 
2.20.1



