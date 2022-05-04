Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA751A8D6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356449AbiEDRRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355910AbiEDRMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:12:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4174BFD2;
        Wed,  4 May 2022 09:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1245B82795;
        Wed,  4 May 2022 16:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EA7C385A5;
        Wed,  4 May 2022 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683460;
        bh=0iMNgaBjHtLS3t6I6ylp1+Pz9b/WoZlybeTCOb/kz44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUwCwVu1MGx29cqZYbcnBZAvVhN0y30drRtLJjgxzjxvAhj9SvpNsrar0GueoOrxn
         qi6GJHi3475+XK6ev9vafsiUNNmhwBdPVipwPull5kRVTdQx/4biTqU1HNVUfP0cse
         gPyGs1jCUrq/kc2ExzveWAp+FsWrnY/BqQSXrKWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 122/225] ip6_gre: Make o_seqno start from 0 in native mode
Date:   Wed,  4 May 2022 18:46:00 +0200
Message-Id: <20220504153121.344531416@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

[ Upstream commit fde98ae91f79cab4e020f40c35ed23cbdc59661c ]

For IP6GRE and IP6GRETAP devices, currently o_seqno starts from 1 in
native mode.  According to RFC 2890 2.2., "The first datagram is sent
with a sequence number of 0."  Fix it.

It is worth mentioning that o_seqno already starts from 0 in collect_md
mode, see the "if (tunnel->parms.collect_md)" clause in __gre6_xmit(),
where tunnel->o_seqno is passed to gre_build_header() before getting
incremented.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 976236736146..d9e4ac94eab4 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -724,6 +724,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 {
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	__be16 protocol;
+	__be16 flags;
 
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
@@ -739,7 +740,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	if (tunnel->parms.collect_md) {
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
-		__be16 flags;
 		int tun_hlen;
 
 		tun_info = skb_tunnel_info_txcheck(skb);
@@ -770,15 +770,14 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 						      : 0);
 
 	} else {
-		if (tunnel->parms.o_flags & TUNNEL_SEQ)
-			tunnel->o_seqno++;
-
 		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
 			return -ENOMEM;
 
-		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
+		flags = tunnel->parms.o_flags;
+
+		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 htonl(tunnel->o_seqno));
+				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
-- 
2.35.1



