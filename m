Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5292ABB98
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgKINMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732530AbgKINMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52E332083B;
        Mon,  9 Nov 2020 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927522;
        bh=lt5oKQFQOGzq15uQBXdGdsuwBvzOBaHjB9Lqet8QaCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJrPIA+paJjGTlXADKVOGlV0TjIiq3yLJ7PSfbQM/E5a3NlHceLQSGcp1eNzNVwNv
         y9yr12nONGxdl4Zs4CR0wc3DAHh2MeOHv78m6D0dQRpB1LL3szmOV7iJPQxkWh41UD
         VxojRVx424zIyEkQfK70PaC/Dej4hnzroCNfhOb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 17/85] ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags
Date:   Mon,  9 Nov 2020 13:55:14 +0100
Message-Id: <20201109125023.415219038@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit 20149e9eb68c003eaa09e7c9a49023df40779552 ]

The tunnel device such as vxlan, bareudp and geneve in the lwt mode set
the outer df only based TUNNEL_DONT_FRAGMENT.
And this was also the behavior for gre device before switching to use
ip_md_tunnel_xmit in commit 962924fa2b7a ("ip_gre: Refactor collect
metatdata mode tunnel xmit to ip_md_tunnel_xmit")

When the ip_gre in lwt mode xmit with ip_md_tunnel_xmi changed the rule and
make the discrepancy between handling of DF by different tunnels. So in the
ip_md_tunnel_xmit should follow the same rule like other tunnels.

Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Link: https://lore.kernel.org/r/1604028728-31100-1-git-send-email-wenxu@ucloud.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -614,9 +614,6 @@ void ip_md_tunnel_xmit(struct sk_buff *s
 			ttl = ip4_dst_hoplimit(&rt->dst);
 	}
 
-	if (!df && skb->protocol == htons(ETH_P_IP))
-		df = inner_iph->frag_off & htons(IP_DF);
-
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
 	if (headroom > dev->needed_headroom)
 		dev->needed_headroom = headroom;


