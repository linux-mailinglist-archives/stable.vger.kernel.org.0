Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB70759E13A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351606AbiHWMNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbiHWMMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9147F7170A;
        Tue, 23 Aug 2022 02:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9208161467;
        Tue, 23 Aug 2022 09:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9D0C433D6;
        Tue, 23 Aug 2022 09:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247518;
        bh=T4UVlykg/Vhq8l4HUOnnq5HvNS5LO+d2RyBZBPX+Mm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsjP8uPBY9WGXDHJ2tESNraWQkCma6VNGEcHhtup/6bctsHiRHJrfbdBbAE0hYKes
         m7HTZdzHGAbrEJVsi1fbW67TJ6r/7MP0sSPa6x344jBe8UZpMiy4IAnO+uTpJNc+no
         z8osbdfl+IDJR2HcAK6APCDp8RBb6ybpQPQzxLk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias May <matthias.may@westermo.com>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 061/158] geneve: fix TOS inheriting for ipv4
Date:   Tue, 23 Aug 2022 10:26:33 +0200
Message-Id: <20220823080048.541363442@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Matthias May <matthias.may@westermo.com>

commit b4ab94d6adaa5cf842b68bd28f4b50bc774496bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -772,7 +772,8 @@ static struct rtable *geneve_get_v4_rt(s
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
 				       const struct ip_tunnel_info *info,
-				       __be16 dport, __be16 sport)
+				       __be16 dport, __be16 sport,
+				       __u8 *full_tos)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -797,6 +798,8 @@ static struct rtable *geneve_get_v4_rt(s
 		use_cache = false;
 	}
 	fl4->flowi4_tos = RT_TOS(tos);
+	if (full_tos)
+		*full_tos = tos;
 
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
@@ -884,6 +887,7 @@ static int geneve_xmit_skb(struct sk_buf
 	const struct ip_tunnel_key *key = &info->key;
 	struct rtable *rt;
 	struct flowi4 fl4;
+	__u8 full_tos;
 	__u8 tos, ttl;
 	__be16 df = 0;
 	__be16 sport;
@@ -894,7 +898,7 @@ static int geneve_xmit_skb(struct sk_buf
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-			      geneve->cfg.info.key.tp_dst, sport);
+			      geneve->cfg.info.key.tp_dst, sport, &full_tos);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -938,7 +942,7 @@ static int geneve_xmit_skb(struct sk_buf
 
 		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	} else {
-		tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);
+		tos = ip_tunnel_ecn_encap(full_tos, ip_hdr(skb), skb);
 		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
@@ -1120,7 +1124,7 @@ static int geneve_fill_metadata_dst(stru
 					  1, USHRT_MAX, true);
 
 		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-				      geneve->cfg.info.key.tp_dst, sport);
+				      geneve->cfg.info.key.tp_dst, sport, NULL);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 


