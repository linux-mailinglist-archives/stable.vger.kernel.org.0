Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E7242100C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhJDNkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238484AbhJDNig (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD97561425;
        Mon,  4 Oct 2021 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353456;
        bh=Wt+sMAr+8EWBwBlCy8flEu8hW9jDBkUc8TR4Jc87d98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MN8kfICaXH7ipD2z4ciaHMGjc+ZjG/s0f7CB5HE3krefTT9uE3K/4KaMkNH44+jhO
         tb15yCMsb0+lpiZFMuDTh0zFC5o/zp0AkwfOeR/1JweOep3pAXRlP3jXzGg/MxAin5
         R1l/JjNWJvv5wbBDQ6CQZlXBbR+zo1yjC21WmCFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Liang <shaw.leon@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 102/172] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Mon,  4 Oct 2021 14:52:32 +0200
Message-Id: <20211004125048.278818865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
index 3ab2563b1a23..7fd7f6093612 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -597,5 +597,5 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
 		     u8 rt_family, unsigned char *flags, bool skip_oif);
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
-		    int nh_weight, u8 rt_family);
+		    int nh_weight, u8 rt_family, u32 nh_tclassid);
 #endif  /* _NET_FIB_H */
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 10e1777877e6..28085b995ddc 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -325,7 +325,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
 
-		if (fib_add_nexthop(skb, nhc, weight, rt_family) < 0)
+		if (fib_add_nexthop(skb, nhc, weight, rt_family, 0) < 0)
 			return -EMSGSIZE;
 	}
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4c0c33e4710d..27fdd86b9cee 100644
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
index 603340302101..0aeff2ce17b9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5700,14 +5700,15 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
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



