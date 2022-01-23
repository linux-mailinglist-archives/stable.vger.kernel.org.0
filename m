Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54C5497358
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbiAWRDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:03:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59720 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiAWRDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:03:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D955060FBC
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB1EC340E2;
        Sun, 23 Jan 2022 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642957391;
        bh=NOUuQsF0EF4K4eg0M93tS0joSVzMrAYJG3HsWknN/zs=;
        h=Subject:To:Cc:From:Date:From;
        b=tyrREtKatsSASOVN4DHtwt2aiYO9o3bO2isYExcbDxtc7kltg5GXIAsTbwNxb+VzX
         zOw8vQzcM/g/f42kdQ0Y/VNUia79tWMcaefskHGgvOq1bgRxI1a0ZndGtbEvVsHcKe
         nvQVKICYvXwWErV6lAdu/3/Ep4hFgr8vhmuxQhx8=
Subject: FAILED: patch "[PATCH] xfrm: fix policy lookup for ipv6 gre packets" failed to apply to 4.9-stable tree
To:     ghalem.boudour@6wind.com, nicolas.dichtel@6wind.com,
        steffen.klassert@secunet.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 18:02:55 +0100
Message-ID: <164295737514487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bcf141b2eb551b3477b24997ebc09c65f117a803 Mon Sep 17 00:00:00 2001
From: Ghalem Boudour <ghalem.boudour@6wind.com>
Date: Fri, 19 Nov 2021 18:20:16 +0100
Subject: [PATCH] xfrm: fix policy lookup for ipv6 gre packets

On egress side, xfrm lookup is called from __gre6_xmit() with the
fl6_gre_key field not initialized leading to policies selectors check
failure. Consequently, gre packets are sent without encryption.

On ingress side, INET6_PROTO_NOPOLICY was set, thus packets were not
checked against xfrm policies. Like for egress side, fl6_gre_key should be
correctly set, this is now done in decode_session6().

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Cc: stable@vger.kernel.org
Signed-off-by: Ghalem Boudour <ghalem.boudour@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d831d2439693..f5a511c57aa2 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -755,6 +755,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		fl6->daddr = key->u.ipv6.dst;
 		fl6->flowlabel = key->label;
 		fl6->flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+		fl6->fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
 		flags = key->tun_flags &
@@ -990,6 +991,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		fl6.daddr = key->u.ipv6.dst;
 		fl6.flowlabel = key->label;
 		fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+		fl6.fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
 		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
@@ -1098,6 +1100,7 @@ static void ip6gre_tnl_link_config_common(struct ip6_tnl *t)
 	fl6->flowi6_oif = p->link;
 	fl6->flowlabel = 0;
 	fl6->flowi6_proto = IPPROTO_GRE;
+	fl6->fl6_gre_key = t->parms.o_key;
 
 	if (!(p->flags&IP6_TNL_F_USE_ORIG_TCLASS))
 		fl6->flowlabel |= IPV6_TCLASS_MASK & p->flowinfo;
@@ -1544,7 +1547,7 @@ static void ip6gre_fb_tunnel_init(struct net_device *dev)
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
 	.handler     = gre_rcv,
 	.err_handler = ip6gre_err,
-	.flags       = INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
+	.flags       = INET6_PROTO_FINAL,
 };
 
 static void ip6gre_destroy_tunnels(struct net *net, struct list_head *head)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1a06585022ab..84d2361da015 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -33,6 +33,7 @@
 #include <net/flow.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
+#include <net/gre.h>
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 #include <net/mip6.h>
 #endif
@@ -3422,6 +3423,26 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			}
 			fl6->flowi6_proto = nexthdr;
 			return;
+		case IPPROTO_GRE:
+			if (!onlyproto &&
+			    (nh + offset + 12 < skb->data ||
+			     pskb_may_pull(skb, nh + offset + 12 - skb->data))) {
+				struct gre_base_hdr *gre_hdr;
+				__be32 *gre_key;
+
+				nh = skb_network_header(skb);
+				gre_hdr = (struct gre_base_hdr *)(nh + offset);
+				gre_key = (__be32 *)(gre_hdr + 1);
+
+				if (gre_hdr->flags & GRE_KEY) {
+					if (gre_hdr->flags & GRE_CSUM)
+						gre_key++;
+					fl6->fl6_gre_key = *gre_key;
+				}
+			}
+			fl6->flowi6_proto = nexthdr;
+			return;
+
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 		case IPPROTO_MH:
 			offset += ipv6_optlen(exthdr);

