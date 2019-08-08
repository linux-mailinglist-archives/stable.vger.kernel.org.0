Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9E86A6A
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404196AbfHHTGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404287AbfHHTGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD162173E;
        Thu,  8 Aug 2019 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291169;
        bh=1BPWILtyFlZToqbgUm83lbRlwVUgzwSddzBOEJUaD5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2J4Sblsmadak0f0fnbDARb6WdyD7jzYOMErEse7OcNT+xWpKG3/u9PN+KgJQvcdg4
         nN6iv2KLJd6gjm5X+jZu2iHBAWF3HkWlbmKigX+gyAQPTlFC3/xOnsEgcOZCEOnhlb
         jm1VRyFSi5I8WXNzR90Be4sXPCa4EDwqOXUH4wLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 13/56] ip6_tunnel: fix possible use-after-free on xmit
Date:   Thu,  8 Aug 2019 21:04:39 +0200
Message-Id: <20190808190453.392619038@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 01f5bffad555f8e22a61f4b1261fe09cf1b96994 ]

ip4ip6/ip6ip6 tunnels run iptunnel_handle_offloads on xmit which
can cause a possible use-after-free accessing iph/ipv6h pointer
since the packet will be 'uncloned' running pskb_expand_head if
it is a cloned gso skb.

Fixes: 0e9a709560db ("ip6_tunnel, ip6_gre: fix setting of DSCP on encapsulated packets")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1278,12 +1278,11 @@ ip4ip6_tnl_xmit(struct sk_buff *skb, str
 	}
 
 	fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+	dsfield = INET_ECN_encapsulate(dsfield, ipv4_get_dsfield(iph));
 
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	dsfield = INET_ECN_encapsulate(dsfield, ipv4_get_dsfield(iph));
-
 	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
@@ -1367,12 +1366,11 @@ ip6ip6_tnl_xmit(struct sk_buff *skb, str
 	}
 
 	fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+	dsfield = INET_ECN_encapsulate(dsfield, ipv6_get_dsfield(ipv6h));
 
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	dsfield = INET_ECN_encapsulate(dsfield, ipv6_get_dsfield(ipv6h));
-
 	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,


