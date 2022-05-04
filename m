Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A43551A7FE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354885AbiEDRHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356450AbiEDRFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF9550E31;
        Wed,  4 May 2022 09:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECAE861794;
        Wed,  4 May 2022 16:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45874C385AF;
        Wed,  4 May 2022 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683247;
        bh=JGN1aSur651jL6VwygsDUq9AQEFBdmvTSDtGQpbExFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9WgwEL2il2L3W4R7Ti7PiiXtlvVBgkF09goNDJqRNRf+DkTxXcjDsCWmyI+6L44L
         e2xW3soFIp9JBZJVp75cDsI6cuglfOUUkflCrCFQ4a4vIBLqs1lpcOIbgjTX/szBrZ
         hvnnhbSMoihes3JvXYIFAL0NK/doTaZ4RgoVZeYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/177] ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode
Date:   Wed,  4 May 2022 18:44:53 +0200
Message-Id: <20220504153102.099314214@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit 31c417c948d7f6909cb63f0ac3298f3c38f8ce20 ]

As pointed out by Jakub Kicinski, currently using TUNNEL_SEQ in
collect_md mode is racy for [IP6]GRE[TAP] devices.  Consider the
following sequence of events:

1. An [IP6]GRE[TAP] device is created in collect_md mode using "ip link
   add ... external".  "ip" ignores "[o]seq" if "external" is specified,
   so TUNNEL_SEQ is off, and the device is marked as NETIF_F_LLTX (i.e.
   it uses lockless TX);
2. Someone sets TUNNEL_SEQ on outgoing skb's, using e.g.
   bpf_skb_set_tunnel_key() in an eBPF program attached to this device;
3. gre_fb_xmit() or __gre6_xmit() processes these skb's:

	gre_build_header(skb, tun_hlen,
			 flags, protocol,
			 tunnel_id_to_key32(tun_info->key.tun_id),
			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
					      : 0);   ^^^^^^^^^^^^^^^^^

Since we are not using the TX lock (&txq->_xmit_lock), multiple CPUs may
try to do this tunnel->o_seqno++ in parallel, which is racy.  Fix it by
making o_seqno atomic_t.

As mentioned by Eric Dumazet in commit b790e01aee74 ("ip_gre: lockless
xmit"), making o_seqno atomic_t increases "chance for packets being out
of order at receiver" when NETIF_F_LLTX is on.

Maybe a better fix would be:

1. Do not ignore "oseq" in external mode.  Users MUST specify "oseq" if
   they want the kernel to allow sequencing of outgoing packets;
2. Reject all outgoing TUNNEL_SEQ packets if the device was not created
   with "oseq".

Unfortunately, that would break userspace.

We could now make [IP6]GRE[TAP] devices always NETIF_F_LLTX, but let us
do it in separate patches to keep this fix minimal.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 77a5196a804e ("gre: add sequence number for collect md mode.")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_tunnel.h | 2 +-
 include/net/ip_tunnels.h | 2 +-
 net/ipv4/ip_gre.c        | 6 +++---
 net/ipv6/ip6_gre.c       | 7 ++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 028eaea1c854..42d50856fcf2 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -57,7 +57,7 @@ struct ip6_tnl {
 
 	/* These fields used only by GRE */
 	__u32 i_seqno;	/* The last seen seqno	*/
-	__u32 o_seqno;	/* The last output seqno */
+	atomic_t o_seqno;	/* The last output seqno */
 	int hlen;       /* tun_hlen + encap_hlen */
 	int tun_hlen;	/* Precalculated header length */
 	int encap_hlen; /* Encap header length (FOU,GUE) */
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index bc3b13ec93c9..37d5d4968e20 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -113,7 +113,7 @@ struct ip_tunnel {
 
 	/* These four fields used only by GRE */
 	u32		i_seqno;	/* The last seen seqno	*/
-	u32		o_seqno;	/* The last output seqno */
+	atomic_t	o_seqno;	/* The last output seqno */
 	int		tun_hlen;	/* Precalculated header length */
 
 	/* These four fields used only by ERSPAN */
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 4b7d7ed4bab8..276a3b7b0e9c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -464,7 +464,7 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
 			 flags, proto, tunnel->parms.o_key,
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
@@ -502,7 +502,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 		(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
 	gre_build_header(skb, tunnel_hlen, flags, proto,
 			 tunnel_id_to_key32(tun_info->key.tun_id),
-			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
@@ -579,7 +579,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	gre_build_header(skb, 8, TUNNEL_SEQ,
-			 proto, 0, htonl(tunnel->o_seqno++));
+			 proto, 0, htonl(atomic_fetch_inc(&tunnel->o_seqno)));
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 4ccbee5e7526..a817ac6d9759 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -766,7 +766,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
 						      : 0);
 
 	} else {
@@ -777,7 +777,8 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 
 		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
+				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
+						      : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
@@ -1055,7 +1056,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	/* Push GRE header. */
 	proto = (t->parms.erspan_ver == 1) ? htons(ETH_P_ERSPAN)
 					   : htons(ETH_P_ERSPAN2);
-	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(t->o_seqno++));
+	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-- 
2.35.1



