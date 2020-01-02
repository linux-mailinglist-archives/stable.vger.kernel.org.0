Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A95212ECF0
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgABWX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbgABWX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:23:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED84620866;
        Thu,  2 Jan 2020 22:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003807;
        bh=BSA/pcBUGl1nwFwAirAYzR7/hzKPhS7OOnadprGSpm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uZfoBniFXz62yG8/sK2J1ehnxOaqnwTRuF3vp6GUZgD3n6qMoKXnM3IjgjmYaXet
         ZZ/s/rotmmUt/t9+cWCaiyDr050eeaXrY5sV2Dw530iu6fzj/eim+oCGSWl01raIZh
         Y9lWKD9zwEoFhPOYUpiDllAvjWIaXrXiyyQiE/kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 101/114] tunnel: do not confirm neighbor when do pmtu update
Date:   Thu,  2 Jan 2020 23:07:53 +0100
Message-Id: <20200102220039.383709605@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 7a1592bcb15d71400a98632727791d1e68ea0ee8 ]

When do tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

v5: No Change.
v4: Update commit description
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c  |    2 +-
 net/ipv6/ip6_tunnel.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -513,7 +513,7 @@ static int tnl_update_pmtu(struct net_de
 	else
 		mtu = skb_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
-	skb_dst_update_pmtu(skb, mtu);
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		if (!skb_is_gso(skb) &&
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -645,7 +645,7 @@ ip4ip6_err(struct sk_buff *skb, struct i
 		if (rel_info > dst_mtu(skb_dst(skb2)))
 			goto out;
 
-		skb_dst_update_pmtu(skb2, rel_info);
+		skb_dst_update_pmtu_no_confirm(skb2, rel_info);
 	}
 
 	icmp_send(skb2, rel_type, rel_code, htonl(rel_info));
@@ -1137,7 +1137,7 @@ route_lookup:
 	mtu = max(mtu, skb->protocol == htons(ETH_P_IPV6) ?
 		       IPV6_MIN_MTU : IPV4_MIN_MTU);
 
-	skb_dst_update_pmtu(skb, mtu);
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
 	if (skb->len - t->tun_hlen - eth_hlen > mtu && !skb_is_gso(skb)) {
 		*pmtu = mtu;
 		err = -EMSGSIZE;


