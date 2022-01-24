Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757C44989B5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbiAXS5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:57:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53666 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbiAXSzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:55:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF87EB8121B;
        Mon, 24 Jan 2022 18:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22693C340E5;
        Mon, 24 Jan 2022 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050549;
        bh=tE9mdAFFt751Py3IuTt7RHTt7U7FMIfiWEJmBQ1SPbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtwbLCfT8QLj1eAKz0NgzU/yy2fZTYGLT7yCH8pF3Z6NxZd02P7UYJ3340GIbmCya
         Ky7p0Pg5RJdbALhJ+t0KzXyelYpVeJeqCGPvzhyQv9Va2V35pQFwCKOU8wKQRH21eD
         4cce7L5EqgYHpYmftVIart/OKLu2Ju2SCLkwmPN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, Amish Chana <amish@3g.co.za>
Subject: [PATCH 4.9 036/157] netfilter: bridge: add support for pppoe filtering
Date:   Mon, 24 Jan 2022 19:42:06 +0100
Message-Id: <20220124183933.950801836@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 28b78ecffea8078d81466b2e01bb5a154509f1ba ]

This makes 'bridge-nf-filter-pppoe-tagged' sysctl work for
bridged traffic.

Looking at the original commit it doesn't appear this ever worked:

 static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
[..]
        if (skb->protocol == htons(ETH_P_8021Q)) {
                skb_pull(skb, VLAN_HLEN);
                skb->network_header += VLAN_HLEN;
+       } else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+               skb_pull(skb, PPPOE_SES_HLEN);
+               skb->network_header += PPPOE_SES_HLEN;
        }
 [..]
	NF_HOOK(... POST_ROUTING, ...)

... but the adjusted offsets are never restored.

The alternative would be to rip this code out for good,
but otoh we'd have to keep this anyway for the vlan handling
(which works because vlan tag info is in the skb, not the packet
 payload).

Reported-and-tested-by: Amish Chana <amish@3g.co.za>
Fixes: 516299d2f5b6f97 ("[NETFILTER]: bridge-nf: filter bridged IPv4/IPv6 encapsulated in pppoe traffic")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 7104d5e64abb3..11d4d18012fed 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -724,6 +724,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
 		mtu = nf_bridge->frag_max_size;
 
+	nf_bridge_update_protocol(skb);
+	nf_bridge_push_encap_header(skb);
+
 	if (skb_is_gso(skb) || skb->len + mtu_reserved <= mtu) {
 		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(net, sk, skb);
@@ -741,8 +744,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 
 		data->vlan_tci = skb->vlan_tci;
@@ -765,8 +766,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 		data->encap_size = nf_bridge_encap_header_len(skb);
 		data->size = ETH_HLEN + data->encap_size;
-- 
2.34.1



