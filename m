Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C11517585
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 19:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386577AbiEBROG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 13:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386652AbiEBRNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 13:13:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FB260F7
        for <stable@vger.kernel.org>; Mon,  2 May 2022 10:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9670D6123D
        for <stable@vger.kernel.org>; Mon,  2 May 2022 17:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5FDC385AC;
        Mon,  2 May 2022 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651511421;
        bh=kSz5oEmjZBTjn3WtQkwib/FtzVGU67WJWCUXIcpI9yI=;
        h=Subject:To:Cc:From:Date:From;
        b=dVondXkGL0xdG5Nqy8Ym0+jFXAhnN+j27DgDT6gsUoIyL1WvFsMvWPFSSFv87I6aP
         AkV+chGiEtv7t492kmHukSyQUVPdbiNMcpqg+gncAo385fwZ083dZvBz0BohDPfmKZ
         FAb5GQPmrT2k0ijWLtVwbWin0BGyVq3WZIESyjhM=
Subject: FAILED: patch "[PATCH] netfilter: Update ip6_route_me_harder to consider L3 domain" failed to apply to 5.4-stable tree
To:     martin@strongswan.org, dsahern@kernel.org, pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 19:10:15 +0200
Message-ID: <1651511415124108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8ddffdb9442a9d60b4a6e679ac48d7d21403a674 Mon Sep 17 00:00:00 2001
From: Martin Willi <martin@strongswan.org>
Date: Tue, 19 Apr 2022 15:47:00 +0200
Subject: [PATCH] netfilter: Update ip6_route_me_harder to consider L3 domain

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

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 1da332450d98..8ce60ab89015 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,14 +24,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
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
@@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
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

