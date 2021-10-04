Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4C420E4A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbhJDNYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236479AbhJDNWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0705861BD2;
        Mon,  4 Oct 2021 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352975;
        bh=SdjwD7Uy9flU8vFEpDopo0tZXR63B0bDZ1HgOybrmYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDu2GvwPV4oNQeTyAA2XSX4FWJGBTWfpLjO5nqg+vvUOczAIzEt9Gz1PgiFl8zW2E
         JYwIZk1RvT7ngSwwXpYNSmbE20QFMqjK3FjDooFOo9rzOKKpemafbfnb3M/yfw0fBU
         96w0F5DieK2rqzZJpMs38qc4A2RK0y+Qh2fD9rhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Liang <shaw.leon@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/93] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Mon,  4 Oct 2021 14:52:38 +0200
Message-Id: <20211004125035.887392274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 597aa16c782496bf74c5dc3b45ff472ade6cee64 ]

Multipath RTA_FLOW is embedded in nexthop. Dump it in fib_add_nexthop()
to get the length of rtnexthop correct.

Fixes: b0f60193632e ("ipv4: Refactor nexthop attributes in fib_dump_info")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h     |  2 +-
 include/net/nexthop.h    |  2 +-
 net/ipv4/fib_semantics.c | 16 +++++++++-------
 net/ipv6/route.c         |  5 +++--
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 2ec062aaa978..4d431d7b4415 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -553,5 +553,5 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
 		     u8 rt_family, unsigned char *flags, bool skip_oif);
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
-		    int nh_weight, u8 rt_family);
+		    int nh_weight, u8 rt_family, u32 nh_tclassid);
 #endif  /* _NET_FIB_H */
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 4c8c9fe9a3f0..fd87d727aa21 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -211,7 +211,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
 
-		if (fib_add_nexthop(skb, nhc, weight, rt_family) < 0)
+		if (fib_add_nexthop(skb, nhc, weight, rt_family, 0) < 0)
 			return -EMSGSIZE;
 	}
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 1f75dc686b6b..642503e89924 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1663,7 +1663,7 @@ EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight, u8 rt_family)
+		    int nh_weight, u8 rt_family, u32 nh_tclassid)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1681,6 +1681,9 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 
 	rtnh->rtnh_flags = flags;
 
+	if (nh_tclassid && nla_put_u32(skb, RTA_FLOW, nh_tclassid))
+		goto nla_put_failure;
+
 	/* length of rtnetlink header + attributes */
 	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
 
@@ -1708,14 +1711,13 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	}
 
 	for_nexthops(fi) {
-		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
-				    AF_INET) < 0)
-			goto nla_put_failure;
+		u32 nh_tclassid = 0;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		if (nh->nh_tclassid &&
-		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
-			goto nla_put_failure;
+		nh_tclassid = nh->nh_tclassid;
 #endif
+		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
+				    AF_INET, nh_tclassid) < 0)
+			goto nla_put_failure;
 	} endfor_nexthops(fi);
 
 mp_end:
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 168a7b4d957a..a68a7d7c0728 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5566,14 +5566,15 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 
 		if (fib_add_nexthop(skb, &rt->fib6_nh->nh_common,
-				    rt->fib6_nh->fib_nh_weight, AF_INET6) < 0)
+				    rt->fib6_nh->fib_nh_weight, AF_INET6,
+				    0) < 0)
 			goto nla_put_failure;
 
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
 			if (fib_add_nexthop(skb, &sibling->fib6_nh->nh_common,
 					    sibling->fib6_nh->fib_nh_weight,
-					    AF_INET6) < 0)
+					    AF_INET6, 0) < 0)
 				goto nla_put_failure;
 		}
 
-- 
2.33.0



