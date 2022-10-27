Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8345A60FDD8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiJ0Q7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiJ0Q7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C042A11A31
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43F2B623ED
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5643EC433C1;
        Thu, 27 Oct 2022 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889972;
        bh=ng3zk0uMS0+QxZrMqw3LBU4S5AOd9LFlAlnc64HON7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+cg/6xg+oPj0MoDQZkvGkS+cQxMKmjrIut69dlfqc4zqlOlrDUFxlyQNo39WgFEW
         0JS3KH4WqjCadG0gF+H1uN7+WD+QePfF5rmCOrDiexmwaM2ZXFsJFFuGezSDXlOuhi
         kSjxu8JVJ6VXk9rEhGLUMCfG8YKCFATvzOwSU/5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guillaume Nault <gnault@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 69/94] netfilter: rpfilter/fib: Set ->flowic_uid correctly for user namespaces.
Date:   Thu, 27 Oct 2022 18:55:11 +0200
Message-Id: <20221027165059.976601060@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 1fcc064b305a1aadeff0d4bff961094d27660acd ]

Currently netfilter's rpfilter and fib modules implicitely initialise
->flowic_uid with 0. This is normally the root UID. However, this isn't
the case in user namespaces, where user ID 0 is mapped to a different
kernel UID. By initialising ->flowic_uid with sock_net_uid(), we get
the root UID of the user namespace, thus keeping the same behaviour
whether or not we're running in a user namepspace.

Note, this is similar to commit 8bcfd0925ef1 ("ipv4: add missing
initialization for flowi4_uid"), which fixed the rp_filter sysctl.

Fixes: 622ec2c9d524 ("net: core: add UID to flows, rules, and routes")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 1 +
 net/ipv4/netfilter/nft_fib_ipv4.c  | 1 +
 net/ipv6/netfilter/ip6t_rpfilter.c | 1 +
 net/ipv6/netfilter/nft_fib_ipv6.c  | 2 ++
 4 files changed, 5 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 63f3e8219dd5..26b3b0e2adcd 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -79,6 +79,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
 	flow.flowi4_l3mdev = l3mdev_master_ifindex_rcu(xt_in(par));
+	flow.flowi4_uid = sock_net_uid(xt_net(par), NULL);
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index e886147eed11..fc65d69f23e1 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -65,6 +65,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi4 fl4 = {
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
+		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 69d86b040a6a..a01d9b842bd0 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -40,6 +40,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev),
 		.flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,
 		.flowi6_proto = iph->nexthdr,
+		.flowi6_uid = sock_net_uid(net, NULL),
 		.daddr = iph->saddr,
 	};
 	int lookup_flags;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 91faac610e03..36dc14b34388 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -66,6 +66,7 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
+		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	u32 ret = 0;
 
@@ -163,6 +164,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
+		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
-- 
2.35.1



