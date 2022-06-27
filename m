Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BCA55C82C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbiF0LtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiF0Ls0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A6DBE5;
        Mon, 27 Jun 2022 04:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED3C61150;
        Mon, 27 Jun 2022 11:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7846BC3411D;
        Mon, 27 Jun 2022 11:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330086;
        bh=4iS3yIV4a+2i40s0BOVe8M5NXjklo6bssC1oiYORHgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm/ChJPifYpwhtkBv/+7D+akcXHG1kp1H4lQWiswKg80AJ8J9gGHiTsPBUgIovg1P
         qWK9qSLYYn/fVS42tYrVQj/5H/B4VKHiusf4EpZ9oPvGq0zNUWO29GsIEqXv8DhjXV
         SPISBH2gyYZugqfiMQT6Z+hUO1BjKbwLR+Bma0lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 078/181] netfilter: nf_dup_netdev: do not push mac header a second time
Date:   Mon, 27 Jun 2022 13:20:51 +0200
Message-Id: <20220627111946.823982964@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 574a5b85dc3b9ab672ff3fba0ee020f927960648 ]

Eric reports skb_under_panic when using dup/fwd via bond+egress hook.
Before pushing mac header, we should make sure that we're called from
ingress to put back what was pulled earlier.

In egress case, the MAC header is already there; we should leave skb
alone.

While at it be more careful here: skb might have been altered and
headroom reduced, so add a skb_cow() before so that headroom is
increased if necessary.

nf_do_netdev_egress() assumes skb ownership (it normally ends with
a call to dev_queue_xmit), so we must free the packet on error.

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_dup_netdev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 7873bd1389c3..13b7f6a66086 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,10 +13,16 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
+static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
+				enum nf_dev_hooks hook)
 {
-	if (skb_mac_header_was_set(skb))
+	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
+		if (skb_cow_head(skb, skb->mac_len)) {
+			kfree_skb(skb);
+			return;
+		}
 		skb_push(skb, skb->mac_len);
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
@@ -33,7 +39,7 @@ void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 		return;
 	}
 
-	nf_do_netdev_egress(pkt->skb, dev);
+	nf_do_netdev_egress(pkt->skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_fwd_netdev_egress);
 
@@ -48,7 +54,7 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
 	if (skb)
-		nf_do_netdev_egress(skb, dev);
+		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
-- 
2.35.1



