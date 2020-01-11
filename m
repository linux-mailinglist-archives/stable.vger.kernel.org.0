Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51163137F5B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgAKKTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:19:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgAKKTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:19:06 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA1A20848;
        Sat, 11 Jan 2020 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737946;
        bh=Epy2AVSRPrGX+adJKfWEZxus0kcmh24fSIlMWJ7fvZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MEOP75ekrNn0MGJaRlSqVwoAaM8aUlf2pK8d3IZIzBxXblPwWByTXH6EsD1B6wi9
         nuFmhLs89QUlxcSLv0yrL46CeMCGut9wAnabuAtD0t6+1sC/le9MJ9lWHpwPaQgsp6
         Smk4wuApD6P1RfKrLaDKf5UpWjHXeECM9XPQtUfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 76/84] vxlan: fix tos value before xmit
Date:   Sat, 11 Jan 2020 10:50:53 +0100
Message-Id: <20200111094912.133854188@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 71130f29979c7c7956b040673e6b9d5643003176 ]

Before ip_tunnel_ecn_encap() and udp_tunnel_xmit_skb() we should filter
tos value by RT_TOS() instead of using config tos directly.

vxlan_get_route() would filter the tos to fl4.flowi4_tos but we didn't
return it back, as geneve_get_v4_rt() did. So we have to use RT_TOS()
directly in function ip_tunnel_ecn_encap().

Fixes: 206aaafcd279 ("VXLAN: Use IP Tunnels tunnel ENC encap API")
Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2217,7 +2217,7 @@ static void vxlan_xmit_one(struct sk_buf
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2254,7 +2254,7 @@ static void vxlan_xmit_one(struct sk_buf
 
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),


