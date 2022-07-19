Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C16579B3A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiGSMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbiGSMY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8317D5071E;
        Tue, 19 Jul 2022 05:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 306EEB81B32;
        Tue, 19 Jul 2022 12:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BB6C36AE5;
        Tue, 19 Jul 2022 12:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232550;
        bh=hPEDbcvAPKZfOqkxksytzGutu2Ale869Ev1r8RuDN8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPmnYLYLxNabr/MVQKjUuQW0kryQhNSZgi2ScT/oFdKu18bAT+x++DBHwPTAm/fKo
         QXIshbO68YpUVAnBQcUiaQp9rHA5QgaTT+wHyJC/QzSPdAuC2Lg4AuD2SgSawwrKi2
         RVz26R8HkOYL5+cmO25c/w6fZQza3gWzrpGgpmyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/112] nexthop: Fix data-races around nexthop_compat_mode.
Date:   Tue, 19 Jul 2022 13:53:56 +0200
Message-Id: <20220719114632.594100958@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
 net/ipv4/fib_semantics.c |    2 +-
 net/ipv4/nexthop.c       |    5 +++--
 net/ipv6/route.c         |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1831,7 +1831,7 @@ int fib_dump_info(struct sk_buff *skb, u
 			goto nla_put_failure;
 		if (nexthop_is_blackhole(fi->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
-		if (!fi->fib_net->ipv4.sysctl_nexthop_compat_mode)
+		if (!READ_ONCE(fi->fib_net->ipv4.sysctl_nexthop_compat_mode))
 			goto offload;
 	}
 
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -882,7 +882,7 @@ static void __remove_nexthop_fib(struct
 		/* __ip6_del_rt does a release, so do a hold here */
 		fib6_info_hold(f6i);
 		ipv6_stub->ip6_del_rt(net, f6i,
-				      !net->ipv4.sysctl_nexthop_compat_mode);
+				      !READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode));
 	}
 }
 
@@ -1194,7 +1194,8 @@ out:
 	if (!rc) {
 		nh_base_seq_inc(net);
 		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
-		if (replace_notify && net->ipv4.sysctl_nexthop_compat_mode)
+		if (replace_notify &&
+		    READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode))
 			nexthop_replace_notify(net, new_nh, &cfg->nlinfo);
 	}
 
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5641,7 +5641,7 @@ static int rt6_fill_node(struct net *net
 		if (nexthop_is_blackhole(rt->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
 
-		if (net->ipv4.sysctl_nexthop_compat_mode &&
+		if (READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode) &&
 		    rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
 			goto nla_put_failure;
 


