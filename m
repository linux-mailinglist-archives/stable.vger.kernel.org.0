Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D25049943D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388864AbiAXUkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385571AbiAXUdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1785CC07E2A9;
        Mon, 24 Jan 2022 11:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8051B8122F;
        Mon, 24 Jan 2022 19:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE064C340E5;
        Mon, 24 Jan 2022 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053602;
        bh=HQ6B0uKdxL/T2Pekmm6f9Rm+C360B4Crjd3KMEbBmYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+mBNKsnK7zi3GY5PlMIffyBvBXiayVO//CGFQIFXzqcPys0ISHpeNiDUp4hzZ7bo
         Asr/lOUQBYFyZYAoUAWZHNsdo8LMwnfqb/5ntG4QyvoTdHCqubUegZuq4vTUy81r2T
         v37sA9Cs4zZsZ+GyBLcDE/JXIBc1fSaZLV9jbePI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, Amish Chana <amish@3g.co.za>
Subject: [PATCH 5.10 118/563] netfilter: bridge: add support for pppoe filtering
Date:   Mon, 24 Jan 2022 19:38:03 +0100
Message-Id: <20220124184028.496002608@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 8edfb98ae1d58..68c0d0f928908 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -743,6 +743,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
 		mtu = nf_bridge->frag_max_size;
 
+	nf_bridge_update_protocol(skb);
+	nf_bridge_push_encap_header(skb);
+
 	if (skb_is_gso(skb) || skb->len + mtu_reserved <= mtu) {
 		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(net, sk, skb);
@@ -760,8 +763,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 
 		if (skb_vlan_tag_present(skb)) {
@@ -789,8 +790,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 		data->encap_size = nf_bridge_encap_header_len(skb);
 		data->size = ETH_HLEN + data->encap_size;
-- 
2.34.1



