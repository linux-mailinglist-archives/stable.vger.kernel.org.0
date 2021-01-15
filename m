Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D512F7B9D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733241AbhAONEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:04:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732762AbhAOMbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 434D8239D0;
        Fri, 15 Jan 2021 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713885;
        bh=1saCcVLhoLc7kxDg4py+J6DxUvLBCh6SIjzoNJqgJD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLyBSxd1CYOIQzfAKx/1tCSV/EoFbHq6x628j9TVrFdJWj4DrKWk3CSm/w/vdV1hW
         df8KsVTin0toUsxmYAiI2Om4nkGoP661Bvct05DjMN2dS7VGULL/6Xfqo3M0WZa6oW
         aKfqybPNeEQ0/RpldS05M+xoztIdw9SlDE8eeFaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 05/28] net: fix pmtu check in nopmtudisc mode
Date:   Fri, 15 Jan 2021 13:27:42 +0100
Message-Id: <20210115121957.006577531@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 50c661670f6a3908c273503dfa206dfc7aa54c07 ]

For some reason ip_tunnel insist on setting the DF bit anyway when the
inner header has the DF bit set, EVEN if the tunnel was configured with
'nopmtudisc'.

This means that the script added in the previous commit
cannot be made to work by adding the 'nopmtudisc' flag to the
ip tunnel configuration. Doing so breaks connectivity even for the
without-conntrack/netfilter scenario.

When nopmtudisc is set, the tunnel will skip the mtu check, so no
icmp error is sent to client. Then, because inner header has DF set,
the outer header gets added with DF bit set as well.

IP stack then sends an error to itself because the packet exceeds
the device MTU.

Fixes: 23a3647bc4f93 ("ip_tunnels: Use skb-len to PMTU check.")
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -752,7 +752,11 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 		goto tx_error;
 	}
 
-	if (tnl_update_pmtu(dev, skb, rt, tnl_params->frag_off, inner_iph)) {
+	df = tnl_params->frag_off;
+	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
+		df |= (inner_iph->frag_off & htons(IP_DF));
+
+	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph)) {
 		ip_rt_put(rt);
 		goto tx_error;
 	}
@@ -780,10 +784,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 			ttl = ip4_dst_hoplimit(&rt->dst);
 	}
 
-	df = tnl_params->frag_off;
-	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
-		df |= (inner_iph->frag_off&htons(IP_DF));
-
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
 	if (max_headroom > dev->needed_headroom)


