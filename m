Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA69579C91
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241231AbiGSMkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiGSMjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2BB4E86B;
        Tue, 19 Jul 2022 05:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 582ACB81B2C;
        Tue, 19 Jul 2022 12:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E55C341C6;
        Tue, 19 Jul 2022 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232931;
        bh=CEtsbmYi11VwkTcpvylIh79Ne3MbyQX0beNtqeTNKN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=km0aq/8F5L7cGrKSlOICzvFrC1KS6vCYM1QGNMNH/mjYOVBaISc+lAzMGnnth1qWg
         HuuJmT7H3QiO6Qey7tD8D3qM42jpndrbl1LK2JJdvaW2fkHNd8OUw5zQbmHtch/ibq
         zfbX6qYvc1nK1rddLRcZLUxDXLTN1E44qUmUMTEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/167] nexthop: Fix data-races around nexthop_compat_mode.
Date:   Tue, 19 Jul 2022 13:53:44 +0200
Message-Id: <20220719114705.410986956@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit bdf00bf24bef9be1ca641a6390fd5487873e0d2e ]

While reading nexthop_compat_mode, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 4f80116d3df3 ("net: ipv4: add sysctl for nexthop api compatibility mode")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 2 +-
 net/ipv4/nexthop.c       | 5 +++--
 net/ipv6/route.c         | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a98350dacbc3..674694d8ac61 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1829,7 +1829,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 		if (nexthop_is_blackhole(fi->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
-		if (!fi->fib_net->ipv4.sysctl_nexthop_compat_mode)
+		if (!READ_ONCE(fi->fib_net->ipv4.sysctl_nexthop_compat_mode))
 			goto offload;
 	}
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5dbd4b5505eb..cc8f120149f6 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1857,7 +1857,7 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 		/* __ip6_del_rt does a release, so do a hold here */
 		fib6_info_hold(f6i);
 		ipv6_stub->ip6_del_rt(net, f6i,
-				      !net->ipv4.sysctl_nexthop_compat_mode);
+				      !READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode));
 	}
 }
 
@@ -2362,7 +2362,8 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	if (!rc) {
 		nh_base_seq_inc(net);
 		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
-		if (replace_notify && net->ipv4.sysctl_nexthop_compat_mode)
+		if (replace_notify &&
+		    READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode))
 			nexthop_replace_notify(net, new_nh, &cfg->nlinfo);
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4ca754c360a3..27274fc3619a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5756,7 +5756,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (nexthop_is_blackhole(rt->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
 
-		if (net->ipv4.sysctl_nexthop_compat_mode &&
+		if (READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode) &&
 		    rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
 			goto nla_put_failure;
 
-- 
2.35.1



