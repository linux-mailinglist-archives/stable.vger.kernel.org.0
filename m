Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1242251A9F9
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357109AbiEDRTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357782AbiEDRPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760C355489;
        Wed,  4 May 2022 09:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7E786195B;
        Wed,  4 May 2022 16:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731D3C385AA;
        Wed,  4 May 2022 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683517;
        bh=u9mrsRgfGoMizZbDVPeNz/JA+WQ2trwoY2joYBPE0rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iD4PtX5v94434qdQ3RhjrX0+x8BzqLpeLApCCkNhi3QWrre2Y8TIhMaf2NoosrkZ
         Hfx2Rjj8pEPD9TQiinfpZhbhrcve+jLHQcqnSSKYfzWtLu7aaeDLJdtq9b1SrpMFU9
         l/1mvVD5+lAQ7Xrx4oenBcngP9txpWKVtCqaVf/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.17 184/225] netfilter: Update ip6_route_me_harder to consider L3 domain
Date:   Wed,  4 May 2022 18:47:02 +0200
Message-Id: <20220504153126.822446878@linuxfoundation.org>
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

From: Martin Willi <martin@strongswan.org>

commit 8ddffdb9442a9d60b4a6e679ac48d7d21403a674 upstream.

The commit referenced below fixed packet re-routing if Netfilter mangles
a routing key property of a packet and the packet is routed in a VRF L3
domain. The fix, however, addressed IPv4 re-routing, only.

This commit applies the same behavior for IPv6. While at it, untangle
the nested ternary operator to make the code more readable.

Fixes: 6d8b49c3a3a3 ("netfilter: Update ip_route_me_harder to consider L3 domain")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Willi <martin@strongswan.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,14 +24,13 @@ int ip6_route_me_harder(struct net *net,
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sock *sk = sk_to_full_sk(sk_partial);
+	struct net_device *dev = skb_dst(skb)->dev;
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
 		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
 	struct flowi6 fl6 = {
-		.flowi6_oif = sk && sk->sk_bound_dev_if ? sk->sk_bound_dev_if :
-			strict ? skb_dst(skb)->dev->ifindex : 0,
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
@@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net,
 	};
 	int err;
 
+	if (sk && sk->sk_bound_dev_if)
+		fl6.flowi6_oif = sk->sk_bound_dev_if;
+	else if (strict)
+		fl6.flowi6_oif = dev->ifindex;
+	else
+		fl6.flowi6_oif = l3mdev_master_ifindex(dev);
+
 	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
 	dst = ip6_route_output(net, sk, &fl6);
 	err = dst->error;


