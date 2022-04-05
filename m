Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CBF4F2F74
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiDEJjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244506AbiDEJKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:10:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4067F29CBD;
        Tue,  5 Apr 2022 01:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F60EB81A12;
        Tue,  5 Apr 2022 08:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA050C385A1;
        Tue,  5 Apr 2022 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149177;
        bh=60e7xbI6l1AgworDfHKiS/uO80AU3QEf7uiVgTT5KeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAVCYcgXfu3JC0nTpW+d83UKmp8GFSPLPqbeiK2m2xhkJePRCk44Ya8XBBB3wuXtT
         9VWhJjBBEFUjK3GQabxKqKHaMTRuisMliQtQpi4M7zNubmcMwnFVnPsS1KqALtF6dK
         gHLVaQDy7/NLiYrX3GfW5JmVwB8gyLGwiA457Vnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0621/1017] ipv4: Fix route lookups when handling ICMP redirects and PMTU updates
Date:   Tue,  5 Apr 2022 09:25:34 +0200
Message-Id: <20220405070412.716397649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 544b4dd568e3b09c1ab38a759d3187e7abda11a0 ]

The PMTU update and ICMP redirect helper functions initialise their fl4
variable with either __build_flow_key() or build_sk_flow_key(). These
initialisation functions always set ->flowi4_scope with
RT_SCOPE_UNIVERSE and might set the ECN bits of ->flowi4_tos. This is
not a problem when the route lookup is later done via
ip_route_output_key_hash(), which properly clears the ECN bits from
->flowi4_tos and initialises ->flowi4_scope based on the RTO_ONLINK
flag. However, some helpers call fib_lookup() directly, without
sanitising the tos and scope fields, so the route lookup can fail and,
as a result, the ICMP redirect or PMTU update aren't taken into
account.

Fix this by extracting the ->flowi4_tos and ->flowi4_scope sanitisation
code into ip_rt_fix_tos(), then use this function in handlers that call
fib_lookup() directly.

Note 1: We can't sanitise ->flowi4_tos and ->flowi4_scope in a central
place (like __build_flow_key() or flowi4_init_output()), because
ip_route_output_key_hash() expects non-sanitised values. When called
with sanitised values, it can erroneously overwrite RT_SCOPE_LINK with
RT_SCOPE_UNIVERSE in ->flowi4_scope. Therefore we have to be careful to
sanitise the values only for those paths that don't call
ip_route_output_key_hash().

Note 2: The problem is mostly about sanitising ->flowi4_tos. Having
->flowi4_scope initialised with RT_SCOPE_UNIVERSE instead of
RT_SCOPE_LINK probably wasn't really a problem: sockets with the
SOCK_LOCALROUTE flag set (those that'd result in RTO_ONLINK being set)
normally shouldn't receive ICMP redirects or PMTU updates.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2c30c599cc16..750e229b7c49 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -498,6 +498,15 @@ void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
 }
 EXPORT_SYMBOL(__ip_select_ident);
 
+static void ip_rt_fix_tos(struct flowi4 *fl4)
+{
+	__u8 tos = RT_FL_TOS(fl4);
+
+	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
+	fl4->flowi4_scope = tos & RTO_ONLINK ?
+			    RT_SCOPE_LINK : RT_SCOPE_UNIVERSE;
+}
+
 static void __build_flow_key(const struct net *net, struct flowi4 *fl4,
 			     const struct sock *sk,
 			     const struct iphdr *iph,
@@ -823,6 +832,7 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 	rt = (struct rtable *) dst;
 
 	__build_flow_key(net, &fl4, sk, iph, oif, tos, prot, mark, 0);
+	ip_rt_fix_tos(&fl4);
 	__ip_do_redirect(rt, skb, &fl4, true);
 }
 
@@ -1047,6 +1057,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
+	ip_rt_fix_tos(&fl4);
 
 	/* Don't make lookup fail for bridged encapsulations */
 	if (skb && netif_is_any_bridge_port(skb->dev))
@@ -1121,6 +1132,8 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 			goto out;
 
 		new = true;
+	} else {
+		ip_rt_fix_tos(&fl4);
 	}
 
 	__ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
@@ -2601,7 +2614,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
 					const struct sk_buff *skb)
 {
-	__u8 tos = RT_FL_TOS(fl4);
 	struct fib_result res = {
 		.type		= RTN_UNSPEC,
 		.fi		= NULL,
@@ -2611,9 +2623,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
 	struct rtable *rth;
 
 	fl4->flowi4_iif = LOOPBACK_IFINDEX;
-	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
-	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
-			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
+	ip_rt_fix_tos(fl4);
 
 	rcu_read_lock();
 	rth = ip_route_output_key_hash_rcu(net, fl4, &res, skb);
-- 
2.34.1



