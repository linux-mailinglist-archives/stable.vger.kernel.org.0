Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278E35AED1C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiIFN5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239694AbiIFNz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:55:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA782771;
        Tue,  6 Sep 2022 06:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CD9AB818C2;
        Tue,  6 Sep 2022 13:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EF1C433B5;
        Tue,  6 Sep 2022 13:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471718;
        bh=peJCUCPW5ynryEAfWIi/9si/ifz63uPjfizjrhUdKYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tg6n4Ug0vlfADzbTAATmFZD+MevRRK7P6PIUHrdZ0OLqc8MHdrHiJ8enR8fZZdLO0
         zdL4xhjWvvvPerdG20SbnMFJcG+XWtgVMIyNmLyvlOmngfDhmJnz7LF+5jaFbXiHj0
         gnylEOfSWzZw0Amr4Tp0+c46qfzKNmE8RjBaMy5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paul Chaignon <paul@isovalent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 015/155] ip_tunnel: Respect tunnel keys "flow_flags" in IP tunnels
Date:   Tue,  6 Sep 2022 15:29:23 +0200
Message-Id: <20220906132830.066867248@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 7ec9fce4b31604f8415136a4c07f7dc8ad431aec ]

Commit 451ef36bd229 ("ip_tunnels: Add new flow flags field to ip_tunnel_key")
added a "flow_flags" member to struct ip_tunnel_key which was later used by
the commit in the fixes tag to avoid dropping packets with sources that
aren't locally configured when set in bpf_set_tunnel_key().

VXLAN and GENEVE were made to respect this flag, ip tunnels like IPIP and GRE
were not.

This commit fixes this omission by making ip_tunnel_init_flow() receive
the flow flags from the tunnel key in the relevant collect_md paths.

Fixes: b8fff748521c ("bpf: Set flow flag to allow any source IP in bpf_tunnel_key")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Paul Chaignon <paul@isovalent.com>
Link: https://lore.kernel.org/bpf/20220818074118.726639-1-eyal.birger@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 ++-
 include/net/ip_tunnels.h                            | 4 +++-
 net/ipv4/ip_gre.c                                   | 2 +-
 net/ipv4/ip_tunnel.c                                | 7 ++++---
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index fe663b0ab7086..68d87e61bdc05 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -423,7 +423,8 @@ mlxsw_sp_span_gretap4_route(const struct net_device *to_dev,
 
 	parms = mlxsw_sp_ipip_netdev_parms4(to_dev);
 	ip_tunnel_init_flow(&fl4, parms.iph.protocol, *daddrp, *saddrp,
-			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0);
+			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0,
+			    0);
 
 	rt = ip_route_output_key(tun->net, &fl4);
 	if (IS_ERR(rt))
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 20f60d9da7418..cf1f22c01ed3d 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -246,7 +246,8 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 				       __be32 daddr, __be32 saddr,
 				       __be32 key, __u8 tos,
 				       struct net *net, int oif,
-				       __u32 mark, __u32 tun_inner_hash)
+				       __u32 mark, __u32 tun_inner_hash,
+				       __u8 flow_flags)
 {
 	memset(fl4, 0, sizeof(*fl4));
 
@@ -263,6 +264,7 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 	fl4->fl4_gre_key = key;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_multipath_hash = tun_inner_hash;
+	fl4->flowi4_flags = flow_flags;
 }
 
 int ip_tunnel_init(struct net_device *dev);
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 5c58e21f724e9..f866d6282b2b3 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -609,7 +609,7 @@ static int gre_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 	ip_tunnel_init_flow(&fl4, IPPROTO_GRE, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id),
 			    key->tos & ~INET_ECN_MASK, dev_net(dev), 0,
-			    skb->mark, skb_get_hash(skb));
+			    skb->mark, skb_get_hash(skb), key->flow_flags);
 	rt = ip_route_output_key(dev_net(dev), &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 94017a8c39945..1ad8809fc2e3b 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -295,7 +295,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
 				    RT_TOS(iph->tos), dev_net(dev),
-				    tunnel->parms.link, tunnel->fwmark, 0);
+				    tunnel->parms.link, tunnel->fwmark, 0, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
 		if (!IS_ERR(rt)) {
@@ -570,7 +570,8 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
-			    dev_net(dev), 0, skb->mark, skb_get_hash(skb));
+			    dev_net(dev), 0, skb->mark, skb_get_hash(skb),
+			    key->flow_flags);
 	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		goto tx_error;
 
@@ -728,7 +729,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
 			    tunnel->parms.o_key, RT_TOS(tos),
 			    dev_net(dev), tunnel->parms.link,
-			    tunnel->fwmark, skb_get_hash(skb));
+			    tunnel->fwmark, skb_get_hash(skb), 0);
 
 	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)
 		goto tx_error;
-- 
2.35.1



