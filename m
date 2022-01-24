Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478A0498EED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350296AbiAXTtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35146 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349781AbiAXThq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 703CA6121F;
        Mon, 24 Jan 2022 19:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C46C340E7;
        Mon, 24 Jan 2022 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053064;
        bh=MIGW9zqQbSvj2OlFGfCSxrMOEsdVAhrTP4QjjKHJvW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vj5Mw5ANtqiY38w62AUWKq9+JVFFonVMzu4duPEw436q/t47DbN1V35DDSCorICH
         iuhKLkG6KqGgLREWtCIJrkGayoZxTVNofY+mAURx7+1vnNVSK2OJwBgoy8Dmy28RiR
         t4l0peha02TlFHBts1UmmPmMzNqy5bqZWiBYE6EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ghalem Boudour <ghalem.boudour@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 264/320] xfrm: fix policy lookup for ipv6 gre packets
Date:   Mon, 24 Jan 2022 19:44:08 +0100
Message-Id: <20220124184002.961580557@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ghalem Boudour <ghalem.boudour@6wind.com>

commit bcf141b2eb551b3477b24997ebc09c65f117a803 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c     |    5 ++++-
 net/xfrm/xfrm_policy.c |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -743,6 +743,7 @@ static netdev_tx_t __gre6_xmit(struct sk
 		fl6->daddr = key->u.ipv6.dst;
 		fl6->flowlabel = key->label;
 		fl6->flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+		fl6->fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
 		flags = key->tun_flags &
@@ -978,6 +979,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 		fl6.daddr = key->u.ipv6.dst;
 		fl6.flowlabel = key->label;
 		fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+		fl6.fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
 		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
@@ -1085,6 +1087,7 @@ static void ip6gre_tnl_link_config_commo
 	fl6->flowi6_oif = p->link;
 	fl6->flowlabel = 0;
 	fl6->flowi6_proto = IPPROTO_GRE;
+	fl6->fl6_gre_key = t->parms.o_key;
 
 	if (!(p->flags&IP6_TNL_F_USE_ORIG_TCLASS))
 		fl6->flowlabel |= IPV6_TCLASS_MASK & p->flowinfo;
@@ -1530,7 +1533,7 @@ static void ip6gre_fb_tunnel_init(struct
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
 	.handler     = gre_rcv,
 	.err_handler = ip6gre_err,
-	.flags       = INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
+	.flags       = INET6_PROTO_FINAL,
 };
 
 static void ip6gre_destroy_tunnels(struct net *net, struct list_head *head)
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
@@ -3443,6 +3444,26 @@ decode_session6(struct sk_buff *skb, str
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


