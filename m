Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE933C4A63
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbhGLGwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238622AbhGLGs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCF5C60FE3;
        Mon, 12 Jul 2021 06:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072276;
        bh=x4JNba6xjjfVLQxm/JV0FfLpvnEaE+SAqmEXK4EIb5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vz8agWNXFRVVcPGc3iAMcx9PbdhBb+fNTiB4HbCZH5Z1qHLcDN1aoGmfCuj/+EzSV
         fYfGBai9JPz/oF3MrgKBvKiVTCiJHXfuaoUNEkLLZdIA9JPzo3qpe1tJT2eRf7lgRh
         S2c3/hS3I49EtZFSQm2k+03ke0kMfD7yy46WXg/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/593] net: lwtunnel: handle MTU calculation in forwading
Date:   Mon, 12 Jul 2021 08:09:47 +0200
Message-Id: <20210712060935.386975841@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit fade56410c22cacafb1be9f911a0afd3701d8366 ]

Commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") moved
fragmentation logic away from lwtunnel by carry encap headroom and
use it in output MTU calculation. But the forwarding part was not
covered and created difference in MTU for output and forwarding and
further to silent drops on ipv4 forwarding path. Fix it by taking
into account lwtunnel encap headroom.

The same commit also introduced difference in how to treat RTAX_MTU
in IPv4 and IPv6 where latter explicitly removes lwtunnel encap
headroom from route MTU. Make IPv4 version do the same.

Fixes: 14972cbd34ff ("net: lwtunnel: Handle fragmentation")
Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h        | 12 ++++++++----
 include/net/ip6_route.h | 16 ++++++++++++----
 net/ipv4/route.c        |  3 ++-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d6b985d11cc..5538e54d4620 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -31,6 +31,7 @@
 #include <net/flow.h>
 #include <net/flow_dissector.h>
 #include <net/netns/hash.h>
+#include <net/lwtunnel.h>
 
 #define IPV4_MAX_PMTU		65535U		/* RFC 2675, Section 5.1 */
 #define IPV4_MIN_MTU		68			/* RFC 791 */
@@ -445,22 +446,25 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 
 	/* 'forwarding = true' case should always honour route mtu */
 	mtu = dst_metric_raw(dst, RTAX_MTU);
-	if (mtu)
-		return mtu;
+	if (!mtu)
+		mtu = min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
 
-	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
+	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 					  const struct sk_buff *skb)
 {
+	unsigned int mtu;
+
 	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
 		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
 
 		return ip_dst_mtu_maybe_forward(skb_dst(skb), forwarding);
 	}
 
-	return min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
+	mtu = min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
+	return mtu - lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
 }
 
 struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2a5277758379..37a7fb1969d6 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -264,11 +264,18 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
+	int mtu;
+
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
 
-	return (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) ?
-	       skb_dst(skb)->dev->mtu : dst_mtu(skb_dst(skb));
+	if (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) {
+		mtu = READ_ONCE(skb_dst(skb)->dev->mtu);
+		mtu -= lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
+	} else
+		mtu = dst_mtu(skb_dst(skb));
+
+	return mtu;
 }
 
 static inline bool ip6_sk_accept_pmtu(const struct sock *sk)
@@ -316,7 +323,7 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 	if (dst_metric_locked(dst, RTAX_MTU)) {
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 		if (mtu)
-			return mtu;
+			goto out;
 	}
 
 	mtu = IPV6_MIN_MTU;
@@ -326,7 +333,8 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 		mtu = idev->cnf.mtu6;
 	rcu_read_unlock();
 
-	return mtu;
+out:
+	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
 u32 ip6_mtu_from_fib6(const struct fib6_result *res,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e968bb47d5bd..e15c1d8b7c8d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1327,7 +1327,7 @@ static unsigned int ipv4_mtu(const struct dst_entry *dst)
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 
 	if (mtu)
-		return mtu;
+		goto out;
 
 	mtu = READ_ONCE(dst->dev->mtu);
 
@@ -1336,6 +1336,7 @@ static unsigned int ipv4_mtu(const struct dst_entry *dst)
 			mtu = 576;
 	}
 
+out:
 	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
-- 
2.30.2



