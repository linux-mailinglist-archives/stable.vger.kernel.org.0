Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17AA34C95E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhC2I3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233878AbhC2I11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C49D6195B;
        Mon, 29 Mar 2021 08:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006367;
        bh=RIN9B/lrw7aUr8PxLfFP2LIfvARXvQfXK0qxFh3lhPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3qWCZuOCKp1KUv0Bsu5+xfSeLQh9/saF+qsM2qys8s3LOnjJYztDfZ9Nv0MfM7OM
         c+cRp9noVfly5ahg9QcVrbH+PB4O8Yr785JP/ithnuVROwK44QYuh3dLAxITdun8qL
         GXFtD4GfrulDnjYAAp7v/LMY7BBFk9yqELlUBtz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/221] net: Consolidate common blackhole dst ops
Date:   Mon, 29 Mar 2021 09:58:31 +0200
Message-Id: <20210329075635.153894071@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit c4c877b2732466b4c63217baad05c96f775912c7 ]

Move generic blackhole dst ops to the core and use them from both
ipv4_dst_blackhole_ops and ip6_dst_blackhole_ops where possible. No
functional change otherwise. We need these also in other locations
and having to define them over and over again is not great.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 11 +++++++++++
 net/core/dst.c    | 38 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/route.c  | 45 ++++++++-------------------------------------
 net/ipv6/route.c  | 36 +++++++++---------------------------
 4 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 8ea8812b0b41..acd15c544cf3 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -535,4 +535,15 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 }
 
+struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
+void dst_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
+			       struct sk_buff *skb, u32 mtu, bool confirm_neigh);
+void dst_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
+			    struct sk_buff *skb);
+u32 *dst_blackhole_cow_metrics(struct dst_entry *dst, unsigned long old);
+struct neighbour *dst_blackhole_neigh_lookup(const struct dst_entry *dst,
+					     struct sk_buff *skb,
+					     const void *daddr);
+unsigned int dst_blackhole_mtu(const struct dst_entry *dst);
+
 #endif /* _NET_DST_H */
diff --git a/net/core/dst.c b/net/core/dst.c
index 0c01bd8d9d81..5f6315601776 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -237,6 +237,44 @@ void __dst_destroy_metrics_generic(struct dst_entry *dst, unsigned long old)
 }
 EXPORT_SYMBOL(__dst_destroy_metrics_generic);
 
+struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie)
+{
+	return NULL;
+}
+
+u32 *dst_blackhole_cow_metrics(struct dst_entry *dst, unsigned long old)
+{
+	return NULL;
+}
+
+struct neighbour *dst_blackhole_neigh_lookup(const struct dst_entry *dst,
+					     struct sk_buff *skb,
+					     const void *daddr)
+{
+	return NULL;
+}
+
+void dst_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
+			       struct sk_buff *skb, u32 mtu,
+			       bool confirm_neigh)
+{
+}
+EXPORT_SYMBOL_GPL(dst_blackhole_update_pmtu);
+
+void dst_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
+			    struct sk_buff *skb)
+{
+}
+EXPORT_SYMBOL_GPL(dst_blackhole_redirect);
+
+unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
+{
+	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
+
+	return mtu ? : dst->dev->mtu;
+}
+EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
+
 static struct dst_ops md_dst_ops = {
 	.family =		AF_UNSPEC,
 };
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9f43abeac3a8..50a6d935376f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2682,44 +2682,15 @@ out:
 	return rth;
 }
 
-static struct dst_entry *ipv4_blackhole_dst_check(struct dst_entry *dst, u32 cookie)
-{
-	return NULL;
-}
-
-static unsigned int ipv4_blackhole_mtu(const struct dst_entry *dst)
-{
-	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
-
-	return mtu ? : dst->dev->mtu;
-}
-
-static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					  struct sk_buff *skb, u32 mtu,
-					  bool confirm_neigh)
-{
-}
-
-static void ipv4_rt_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
-				       struct sk_buff *skb)
-{
-}
-
-static u32 *ipv4_rt_blackhole_cow_metrics(struct dst_entry *dst,
-					  unsigned long old)
-{
-	return NULL;
-}
-
 static struct dst_ops ipv4_dst_blackhole_ops = {
-	.family			=	AF_INET,
-	.check			=	ipv4_blackhole_dst_check,
-	.mtu			=	ipv4_blackhole_mtu,
-	.default_advmss		=	ipv4_default_advmss,
-	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
-	.redirect		=	ipv4_rt_blackhole_redirect,
-	.cow_metrics		=	ipv4_rt_blackhole_cow_metrics,
-	.neigh_lookup		=	ipv4_neigh_lookup,
+	.family			= AF_INET,
+	.default_advmss		= ipv4_default_advmss,
+	.neigh_lookup		= ipv4_neigh_lookup,
+	.check			= dst_blackhole_check,
+	.cow_metrics		= dst_blackhole_cow_metrics,
+	.update_pmtu		= dst_blackhole_update_pmtu,
+	.redirect		= dst_blackhole_redirect,
+	.mtu			= dst_blackhole_mtu,
 };
 
 struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_orig)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7e0ce7af8234..fa276448d5a2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -258,34 +258,16 @@ static struct dst_ops ip6_dst_ops_template = {
 	.confirm_neigh		=	ip6_confirm_neigh,
 };
 
-static unsigned int ip6_blackhole_mtu(const struct dst_entry *dst)
-{
-	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
-
-	return mtu ? : dst->dev->mtu;
-}
-
-static void ip6_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					 struct sk_buff *skb, u32 mtu,
-					 bool confirm_neigh)
-{
-}
-
-static void ip6_rt_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
-				      struct sk_buff *skb)
-{
-}
-
 static struct dst_ops ip6_dst_blackhole_ops = {
-	.family			=	AF_INET6,
-	.destroy		=	ip6_dst_destroy,
-	.check			=	ip6_dst_check,
-	.mtu			=	ip6_blackhole_mtu,
-	.default_advmss		=	ip6_default_advmss,
-	.update_pmtu		=	ip6_rt_blackhole_update_pmtu,
-	.redirect		=	ip6_rt_blackhole_redirect,
-	.cow_metrics		=	dst_cow_metrics_generic,
-	.neigh_lookup		=	ip6_dst_neigh_lookup,
+	.family			= AF_INET6,
+	.default_advmss		= ip6_default_advmss,
+	.neigh_lookup		= ip6_dst_neigh_lookup,
+	.check			= ip6_dst_check,
+	.destroy		= ip6_dst_destroy,
+	.cow_metrics		= dst_cow_metrics_generic,
+	.update_pmtu		= dst_blackhole_update_pmtu,
+	.redirect		= dst_blackhole_redirect,
+	.mtu			= dst_blackhole_mtu,
 };
 
 static const u32 ip6_template_metrics[RTAX_MAX] = {
-- 
2.30.1



