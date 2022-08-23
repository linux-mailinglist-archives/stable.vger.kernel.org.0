Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A759D9A9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiHWJ70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbiHWJ5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:57:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9866FA1D;
        Tue, 23 Aug 2022 01:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4923CB8105C;
        Tue, 23 Aug 2022 08:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A344DC433B5;
        Tue, 23 Aug 2022 08:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244469;
        bh=9bfEdUFBJTQnJfMCOi4M5qH+7o9+Sj9i5MJBurE2cSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tfn+fyLxuEYOFcpzhX6QrtvWANqt/PwxICxvVpO0iCqLzlUDnLAia6QvlpoQxQMc6
         8+DlHTZFbnvIOnyGEoJsbvu4ApS+BqG7XtOaUpYRE+0PhRPm/dP5f08p+2FnhQ7xtP
         hxBC218xI4kSx6a2FIgIeAyheKSVbsT3CDHlkuaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias May <matthias.may@westermo.com>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 098/244] geneve: fix TOS inheriting for ipv4
Date:   Tue, 23 Aug 2022 10:24:17 +0200
Message-Id: <20220823080102.300085902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -774,7 +774,8 @@ static struct rtable *geneve_get_v4_rt(s
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
 				       const struct ip_tunnel_info *info,
-				       __be16 dport, __be16 sport)
+				       __be16 dport, __be16 sport,
+				       __u8 *full_tos)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -799,6 +800,8 @@ static struct rtable *geneve_get_v4_rt(s
 		use_cache = false;
 	}
 	fl4->flowi4_tos = RT_TOS(tos);
+	if (full_tos)
+		*full_tos = tos;
 
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
@@ -886,6 +889,7 @@ static int geneve_xmit_skb(struct sk_buf
 	const struct ip_tunnel_key *key = &info->key;
 	struct rtable *rt;
 	struct flowi4 fl4;
+	__u8 full_tos;
 	__u8 tos, ttl;
 	__be16 df = 0;
 	__be16 sport;
@@ -896,7 +900,7 @@ static int geneve_xmit_skb(struct sk_buf
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-			      geneve->cfg.info.key.tp_dst, sport);
+			      geneve->cfg.info.key.tp_dst, sport, &full_tos);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -940,7 +944,7 @@ static int geneve_xmit_skb(struct sk_buf
 
 		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	} else {
-		tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);
+		tos = ip_tunnel_ecn_encap(full_tos, ip_hdr(skb), skb);
 		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
@@ -1122,7 +1126,7 @@ static int geneve_fill_metadata_dst(stru
 					  1, USHRT_MAX, true);
 
 		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-				      geneve->cfg.info.key.tp_dst, sport);
+				      geneve->cfg.info.key.tp_dst, sport, NULL);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 


