Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E345461DFB
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378016AbhK2SbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:22 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49474 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352450AbhK2S3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B3ACCE140C;
        Mon, 29 Nov 2021 18:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4B6C53FAD;
        Mon, 29 Nov 2021 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210360;
        bh=U71gDbyoXRkwiVkWvWBr9SOM5/pKwlhOIdtzR8HagWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT85Oyf3qJq2oWIOQjYufhGFKRolunEvX9hrpvYvJFqZdwTHdMdlaB1Tg0YRRXAAP
         8ssy4tUBfBJdvDOV9NIZ6ukw+mS7mv1FcG2fWzOT1OwwTG3yc3GWcWqaC05O5pqzDn
         /2uzWsNxNT4d+vXJuQM+Lpv3emKC+9XX+8xPC1PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/92] net: ipv6: add fib6_nh_release_dsts stub
Date:   Mon, 29 Nov 2021 19:18:29 +0100
Message-Id: <20211129181709.415644674@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 8837cbbf854246f5f4d565f21e6baa945d37aded ]

We need a way to release a fib6_nh's per-cpu dsts when replacing
nexthops otherwise we can end up with stale per-cpu dsts which hold net
device references, so add a new IPv6 stub called fib6_nh_release_dsts.
It must be used after an RCU grace period, so no new dsts can be created
through a group's nexthop entry.
Similar to fib6_nh_release it shouldn't be used if fib6_nh_init has failed
so it doesn't need a dummy stub when IPv6 is not enabled.

Fixes: 7bf4796dd099 ("nexthops: add support for replace")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_fib.h    |  1 +
 include/net/ipv6_stubs.h |  1 +
 net/ipv6/af_inet6.c      |  1 +
 net/ipv6/route.c         | 19 +++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index bd0f1595bdc71..05ecaefeb6322 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -451,6 +451,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct fib6_config *cfg, gfp_t gfp_flags,
 		 struct netlink_ext_ack *extack);
 void fib6_nh_release(struct fib6_nh *fib6_nh);
+void fib6_nh_release_dsts(struct fib6_nh *fib6_nh);
 
 int call_fib6_entry_notifiers(struct net *net,
 			      enum fib_event_type event_type,
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 3e7d2c0e79ca1..af9e127779adf 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -47,6 +47,7 @@ struct ipv6_stub {
 			    struct fib6_config *cfg, gfp_t gfp_flags,
 			    struct netlink_ext_ack *extack);
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
+	void (*fib6_nh_release_dsts)(struct fib6_nh *fib6_nh);
 	void (*fib6_update_sernum)(struct net *net, struct fib6_info *rt);
 	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt);
 	void (*fib6_rt_update)(struct net *net, struct fib6_info *rt,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 14ac1d9112877..942da168f18fb 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -955,6 +955,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_mtu_from_fib6 = ip6_mtu_from_fib6,
 	.fib6_nh_init	   = fib6_nh_init,
 	.fib6_nh_release   = fib6_nh_release,
+	.fib6_nh_release_dsts = fib6_nh_release_dsts,
 	.fib6_update_sernum = fib6_update_sernum_stub,
 	.fib6_rt_update	   = fib6_rt_update,
 	.ip6_del_rt	   = ip6_del_rt,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index daa876c6ae8db..f36db3dd97346 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3585,6 +3585,25 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 	fib_nh_common_release(&fib6_nh->nh_common);
 }
 
+void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
+{
+	int cpu;
+
+	if (!fib6_nh->rt6i_pcpu)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct rt6_info *pcpu_rt, **ppcpu_rt;
+
+		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
+		pcpu_rt = xchg(ppcpu_rt, NULL);
+		if (pcpu_rt) {
+			dst_dev_put(&pcpu_rt->dst);
+			dst_release(&pcpu_rt->dst);
+		}
+	}
+}
+
 static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 					      gfp_t gfp_flags,
 					      struct netlink_ext_ack *extack)
-- 
2.33.0



