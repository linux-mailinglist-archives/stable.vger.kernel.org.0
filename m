Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1C255D980
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbiF0LuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238438AbiF0Ls2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56181101CB;
        Mon, 27 Jun 2022 04:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 019D5B81133;
        Mon, 27 Jun 2022 11:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53739C3411D;
        Mon, 27 Jun 2022 11:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330089;
        bh=bIk9Q7VcFXsMwf8IGfP7CkYICv0X5GEIx0fS2MXlC5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojkDUD3DyPHMsSk+xN2mgYyUkO7OsbByeQsZIrUzrkFInbD2DJVlVx+qM0evCu5nd
         XjtKuRvdEjBu+GMZXwPQ9GRD+JYpwXZA0AkAaJdkRZSRE6ZDrOUG4fKt+ekzZycrO3
         HfkQy/7sf/k3EJ34oVG93PHlWDN1YXEEtJj+5Kus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 079/181] netfilter: nf_dup_netdev: add and use recursion counter
Date:   Mon, 27 Jun 2022 13:20:52 +0200
Message-Id: <20220627111946.852848720@linuxfoundation.org>
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

[ Upstream commit fcd53c51d03709bc429822086f1e9b3e88904284 ]

Now that the egress function can be called from egress hook, we need
to avoid recursive calls into the nf_tables traverser, else crash.

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_dup_netdev.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 13b7f6a66086..a8e2425e43b0 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,20 +13,31 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
+#define NF_RECURSION_LIMIT	2
+
+static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
+	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+		goto err;
+
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
-		if (skb_cow_head(skb, skb->mac_len)) {
-			kfree_skb(skb);
-			return;
-		}
+		if (skb_cow_head(skb, skb->mac_len))
+			goto err;
+
 		skb_push(skb, skb->mac_len);
 	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	__this_cpu_inc(nf_dup_skb_recursion);
 	dev_queue_xmit(skb);
+	__this_cpu_dec(nf_dup_skb_recursion);
+	return;
+err:
+	kfree_skb(skb);
 }
 
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
-- 
2.35.1



