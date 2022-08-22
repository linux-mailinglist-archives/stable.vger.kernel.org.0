Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2964F59BCA5
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiHVJTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiHVJS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:18:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A431174
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 02:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 382F8B80F3B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9350AC433D6;
        Mon, 22 Aug 2022 09:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661159930;
        bh=CqXG6RuYS1YxnnBh4qbvqVvIon+Ecy7ZWD9g15i8lsQ=;
        h=Subject:To:Cc:From:Date:From;
        b=tS/kC1yIYaR1x8cNUhMFS500Q99OaCi5J236jha1zeRK5KQSSqf2zTvvsm45ps51q
         sdYp87kWnUi/gAySgwRrEjXwDBaFQDRC+1bUoS+VOnkkYN3mXE3lan/LQ2W4HdgCXD
         9fapHon/BYHTOtaZF+dZauZMK1Nnuq5eddIIf0FQ=
Subject: FAILED: patch "[PATCH] geneve: fix TOS inheriting for ipv4" failed to apply to 4.9-stable tree
To:     matthias.may@westermo.com, gnault@redhat.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 11:18:34 +0200
Message-ID: <16611599147101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b4ab94d6adaa5cf842b68bd28f4b50bc774496bd Mon Sep 17 00:00:00 2001
From: Matthias May <matthias.may@westermo.com>
Date: Fri, 5 Aug 2022 21:00:06 +0200
Subject: [PATCH] geneve: fix TOS inheriting for ipv4

The current code retrieves the TOS field after the lookup
on the ipv4 routing table. The routing process currently
only allows routing based on the original 3 TOS bits, and
not on the full 6 DSCP bits.
As a result the retrieved TOS is cut to the 3 bits.
However for inheriting purposes the full 6 bits should be used.

Extract the full 6 bits before the route lookup and use
that instead of the cut off 3 TOS bits.

Fixes: e305ac6cf5a1 ("geneve: Add support to collect tunnel metadata.")
Signed-off-by: Matthias May <matthias.may@westermo.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/20220805190006.8078-1-matthias.may@westermo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 018d365f9deb..fafe7dea2227 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -797,7 +797,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
 				       const struct ip_tunnel_info *info,
-				       __be16 dport, __be16 sport)
+				       __be16 dport, __be16 sport,
+				       __u8 *full_tos)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -823,6 +824,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 		use_cache = false;
 	}
 	fl4->flowi4_tos = RT_TOS(tos);
+	if (full_tos)
+		*full_tos = tos;
 
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
@@ -911,6 +914,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	const struct ip_tunnel_key *key = &info->key;
 	struct rtable *rt;
 	struct flowi4 fl4;
+	__u8 full_tos;
 	__u8 tos, ttl;
 	__be16 df = 0;
 	__be16 sport;
@@ -921,7 +925,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-			      geneve->cfg.info.key.tp_dst, sport);
+			      geneve->cfg.info.key.tp_dst, sport, &full_tos);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -965,7 +969,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	} else {
-		tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);
+		tos = ip_tunnel_ecn_encap(full_tos, ip_hdr(skb), skb);
 		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
@@ -1149,7 +1153,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 					  1, USHRT_MAX, true);
 
 		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-				      geneve->cfg.info.key.tp_dst, sport);
+				      geneve->cfg.info.key.tp_dst, sport, NULL);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 

