Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA22833B652
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhCON5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhCON5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5218064F2A;
        Mon, 15 Mar 2021 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816626;
        bh=1qkicVdTJAhRNQZu9LqfjfsLRgL3aLMZPWlzvhucciE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uubwlLNwpKMbSDFoxl8Y7AgIEplg4We7f3E6XVk+sq/IgHCau/ac7XZzYRIwNyjiu
         XwqYA4FQlk8jh1qL1aQ6GOOq+n8UGZgsE81xGRRmzYSMxlaxrHPV41GtW9iT3YAdCQ
         qxqIYE3zAt/CwJQxlEx5v9KqjToLM79b+4sFnKF0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 020/290] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
Date:   Mon, 15 Mar 2021 14:51:53 +0100
Message-Id: <20210315135542.613146474@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 4372339efc06bc2a796f4cc9d0a7a929dfda4967 upstream.

There were a few remaining tunnel drivers that didn't receive the prior
conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
icmp{,v6}_ndo_send before sending") for details), there's even more
imperative to have these all converted. So this commit goes through the
remaining cases that I could find and does a boring translation to the
ndo variety.

The Fixes: line below is the merge that originally added icmp{,v6}_
ndo_send and converted the first batch of icmp{,v6}_send users. The
rationale then for the change applies equally to this patch. It's just
that these drivers were left out of the initial conversion because these
network devices are hiding in net/ rather than in drivers/net/.

Cc: Florian Westphal <fw@strlen.de>
Cc: Willem de Bruijn <willemb@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Fixes: 803381f9f117 ("Merge branch 'icmp-account-for-NAT-when-sending-icmps-from-ndo-layer'")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c  |    5 ++---
 net/ipv4/ip_vti.c     |    6 +++---
 net/ipv6/ip6_gre.c    |   16 ++++++++--------
 net/ipv6/ip6_tunnel.c |   10 +++++-----
 net/ipv6/ip6_vti.c    |    6 +++---
 net/ipv6/sit.c        |    2 +-
 6 files changed, 22 insertions(+), 23 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -502,8 +502,7 @@ static int tnl_update_pmtu(struct net_de
 		if (!skb_is_gso(skb) &&
 		    (inner_iph->frag_off & htons(IP_DF)) &&
 		    mtu < pkt_size) {
-			memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, htonl(mtu));
 			return -E2BIG;
 		}
 	}
@@ -527,7 +526,7 @@ static int tnl_update_pmtu(struct net_de
 
 		if (!skb_is_gso(skb) && mtu >= IPV6_MIN_MTU &&
 					mtu < pkt_size) {
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 			return -E2BIG;
 		}
 	}
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -238,13 +238,13 @@ static netdev_tx_t vti_xmit(struct sk_bu
 	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 		if (skb->protocol == htons(ETH_P_IP)) {
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		} else {
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		}
 
 		dst_release(dst);
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -678,8 +678,8 @@ static int prepare_ip6gre_xmit_ipv6(stru
 
 		tel = (struct ipv6_tlv_tnl_enc_lim *)&skb_network_header(skb)[offset];
 		if (tel->encap_limit == 0) {
-			icmpv6_send(skb, ICMPV6_PARAMPROB,
-				    ICMPV6_HDR_FIELD, offset + 2);
+			icmpv6_ndo_send(skb, ICMPV6_PARAMPROB,
+					ICMPV6_HDR_FIELD, offset + 2);
 			return -1;
 		}
 		*encap_limit = tel->encap_limit - 1;
@@ -805,8 +805,8 @@ static inline int ip6gre_xmit_ipv4(struc
 	if (err != 0) {
 		/* XXX: send ICMP error even if DF is not set. */
 		if (err == -EMSGSIZE)
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		return -1;
 	}
 
@@ -837,7 +837,7 @@ static inline int ip6gre_xmit_ipv6(struc
 			  &mtu, skb->protocol);
 	if (err != 0) {
 		if (err == -EMSGSIZE)
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		return -1;
 	}
 
@@ -1063,10 +1063,10 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 		/* XXX: send ICMP error even if DF is not set. */
 		if (err == -EMSGSIZE) {
 			if (skb->protocol == htons(ETH_P_IP))
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED, htonl(mtu));
+				icmp_ndo_send(skb, ICMP_DEST_UNREACH,
+					      ICMP_FRAG_NEEDED, htonl(mtu));
 			else
-				icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+				icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		}
 
 		goto tx_err;
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1363,8 +1363,8 @@ ipxip6_tnl_xmit(struct sk_buff *skb, str
 
 				tel = (void *)&skb_network_header(skb)[offset];
 				if (tel->encap_limit == 0) {
-					icmpv6_send(skb, ICMPV6_PARAMPROB,
-						ICMPV6_HDR_FIELD, offset + 2);
+					icmpv6_ndo_send(skb, ICMPV6_PARAMPROB,
+							ICMPV6_HDR_FIELD, offset + 2);
 					return -1;
 				}
 				encap_limit = tel->encap_limit - 1;
@@ -1416,11 +1416,11 @@ ipxip6_tnl_xmit(struct sk_buff *skb, str
 		if (err == -EMSGSIZE)
 			switch (protocol) {
 			case IPPROTO_IPIP:
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED, htonl(mtu));
+				icmp_ndo_send(skb, ICMP_DEST_UNREACH,
+					      ICMP_FRAG_NEEDED, htonl(mtu));
 				break;
 			case IPPROTO_IPV6:
-				icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+				icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 				break;
 			default:
 				break;
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -520,10 +520,10 @@ vti6_xmit(struct sk_buff *skb, struct ne
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		}
 
 		err = -EMSGSIZE;
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -987,7 +987,7 @@ static netdev_tx_t ipip6_tunnel_xmit(str
 			skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->len > mtu && !skb_is_gso(skb)) {
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 			ip_rt_put(rt);
 			goto tx_error;
 		}


