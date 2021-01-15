Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D1B2F7976
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732588AbhAOMgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387898AbhAOMgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A0723136;
        Fri, 15 Jan 2021 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714198;
        bh=GtH3/GZAGYXQAAGaJeAAz6W8rBPwVv2wVLPjhOZUReg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6ZGRaitaA5cTjtDDnXvFwJEwrM0fV5GO6eHElQqRy8es3dcp1J7GQ3kTTQQGAyXv
         dCztLA+KUBPpG/qXNd/faN36xlfto/cEspdu58yQnl7pITYXtZncWdvasQj39iHKVt
         qa1euMM7jQCkL8G8t2e14USaIsQnSfrd4GQQr4bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 027/103] net: fix pmtu check in nopmtudisc mode
Date:   Fri, 15 Jan 2021 13:27:20 +0100
Message-Id: <20210115122007.370847830@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
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
 net/ipv4/ip_tunnel.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -759,8 +759,11 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 		goto tx_error;
 	}
 
-	if (tnl_update_pmtu(dev, skb, rt, tnl_params->frag_off, inner_iph,
-			    0, 0, false)) {
+	df = tnl_params->frag_off;
+	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
+		df |= (inner_iph->frag_off & htons(IP_DF));
+
+	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, 0, 0, false)) {
 		ip_rt_put(rt);
 		goto tx_error;
 	}
@@ -788,10 +791,6 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 			ttl = ip4_dst_hoplimit(&rt->dst);
 	}
 
-	df = tnl_params->frag_off;
-	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
-		df |= (inner_iph->frag_off&htons(IP_DF));
-
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
 	if (max_headroom > dev->needed_headroom)


