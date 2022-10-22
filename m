Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFF4608650
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiJVHrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiJVHrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:47:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFFE15FCD;
        Sat, 22 Oct 2022 00:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAC4AB82E13;
        Sat, 22 Oct 2022 07:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3AFC433C1;
        Sat, 22 Oct 2022 07:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424616;
        bh=yVMy2NWsVdNDP54jbBTFxUQN5uZNosG28yGa4Gw8At0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6SYq41iOjb1giQvKHakgz8nr/MnGMX2770riDDAzMbXgU8G2y/I8M+kgwUCPFSJU
         TbbSjxyFTnntLMa7kvAL9yQR2qgoDbKtsMEFup5Dvq+O1qfsciIy/qaFh8WFeTpEbQ
         Uovn9LI5j0atNhgtn/ppfAaFNy3RlH39kSI2OHJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 213/717] esp: choose the correct inner protocol for GSO on inter address family tunnels
Date:   Sat, 22 Oct 2022 09:21:32 +0200
Message-Id: <20221022072452.962173379@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 26dbd66eab8080be51759e48280da04015221e22 ]

Commit 23c7f8d7989e ("net: Fix esp GSO on inter address family
tunnels.") is incomplete. It passes to skb_eth_gso_segment the
protocol for the outer IP version, instead of the inner IP version, so
we end up calling inet_gso_segment on an inner IPv6 packet and
ipv6_gso_segment on an inner IPv4 packet and the packets are dropped.

This patch completes the fix by selecting the correct protocol based
on the inner mode's family.

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 5 ++++-
 net/ipv6/esp6_offload.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 935026f4c807..170152772d33 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -110,7 +110,10 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	return skb_eth_gso_segment(skb, features, htons(ETH_P_IP));
+	__be16 type = x->inner_mode.family == AF_INET6 ? htons(ETH_P_IPV6)
+						       : htons(ETH_P_IP);
+
+	return skb_eth_gso_segment(skb, features, type);
 }
 
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 3a293838a91d..79d43548279c 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -145,7 +145,10 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	return skb_eth_gso_segment(skb, features, htons(ETH_P_IPV6));
+	__be16 type = x->inner_mode.family == AF_INET ? htons(ETH_P_IP)
+						      : htons(ETH_P_IPV6);
+
+	return skb_eth_gso_segment(skb, features, type);
 }
 
 static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
-- 
2.35.1



