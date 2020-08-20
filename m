Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3940724B568
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgHTKXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731742AbgHTKXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:23:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEADA20658;
        Thu, 20 Aug 2020 10:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597919002;
        bh=pLmtuxM2gLsgL9D/mBLQ9ugUl0WP6V1Qc0XaJ/eY1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvbUMv6KqL7HqiePIdWOJtxkwdkypzdecfgaWpQ2gP0j60AZGEboDTPWkrecPB1qu
         j7rqz2Ps8IpeQ6WFldDyClgAHusR2CtXXQVB4q2GxaNZxCXhg+2XpF8eGytyseKoi7
         X1Nw3vu+tyOfyuoP+BBJ+17SPzWSOUxj/tfh9VL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.4 149/149] ipv6: check skb->protocol before lookup for nexthop
Date:   Thu, 20 Aug 2020 11:23:46 +0200
Message-Id: <20200820092132.902693609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 199ab00f3cdb6f154ea93fa76fd80192861a821d upstream.

Andrey reported a out-of-bound access in ip6_tnl_xmit(), this
is because we use an ipv4 dst in ip6_tnl_xmit() and cast an IPv4
neigh key as an IPv6 address:

        neigh = dst_neigh_lookup(skb_dst(skb),
                                 &ipv6_hdr(skb)->daddr);
        if (!neigh)
                goto tx_err_link_failure;

        addr6 = (struct in6_addr *)&neigh->primary_key; // <=== HERE
        addr_type = ipv6_addr_type(addr6);

        if (addr_type == IPV6_ADDR_ANY)
                addr6 = &ipv6_hdr(skb)->daddr;

        memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));

Also the network header of the skb at this point should be still IPv4
for 4in6 tunnels, we shold not just use it as IPv6 header.

This patch fixes it by checking if skb->protocol is ETH_P_IPV6: if it
is, we are safe to do the nexthop lookup using skb_dst() and
ipv6_hdr(skb)->daddr; if not (aka IPv4), we have no clue about which
dest address we can pick here, we have to rely on callers to fill it
from tunnel config, so just fall to ip6_route_output() to make the
decision.

Fixes: ea3dc9601bda ("ip6_tunnel: Add support for wildcard tunnel endpoints.")
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/ip6_tunnel.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -972,26 +972,28 @@ static int ip6_tnl_xmit2(struct sk_buff
 
 	/* NBMA tunnel */
 	if (ipv6_addr_any(&t->parms.raddr)) {
-		struct in6_addr *addr6;
-		struct neighbour *neigh;
-		int addr_type;
-
-		if (!skb_dst(skb))
-			goto tx_err_link_failure;
-
-		neigh = dst_neigh_lookup(skb_dst(skb),
-					 &ipv6_hdr(skb)->daddr);
-		if (!neigh)
-			goto tx_err_link_failure;
-
-		addr6 = (struct in6_addr *)&neigh->primary_key;
-		addr_type = ipv6_addr_type(addr6);
-
-		if (addr_type == IPV6_ADDR_ANY)
-			addr6 = &ipv6_hdr(skb)->daddr;
-
-		memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
-		neigh_release(neigh);
+		if (skb->protocol == htons(ETH_P_IPV6)) {
+			struct in6_addr *addr6;
+			struct neighbour *neigh;
+			int addr_type;
+
+			if (!skb_dst(skb))
+				goto tx_err_link_failure;
+
+			neigh = dst_neigh_lookup(skb_dst(skb),
+						 &ipv6_hdr(skb)->daddr);
+			if (!neigh)
+				goto tx_err_link_failure;
+
+			addr6 = (struct in6_addr *)&neigh->primary_key;
+			addr_type = ipv6_addr_type(addr6);
+
+			if (addr_type == IPV6_ADDR_ANY)
+				addr6 = &ipv6_hdr(skb)->daddr;
+
+			memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
+			neigh_release(neigh);
+		}
 	} else if (!fl6->flowi6_mark)
 		dst = dst_cache_get(&t->dst_cache);
 


