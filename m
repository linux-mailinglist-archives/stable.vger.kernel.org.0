Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B9A461E95
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378517AbhK2Shg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:37:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40556 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379329AbhK2Sff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:35:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A772B815C9;
        Mon, 29 Nov 2021 18:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ECAC53FC7;
        Mon, 29 Nov 2021 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210735;
        bh=c9MeRBFroZ87rEfIL2qKbxCvnRt+F2gQw6PMQ8+chg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Szi6hva57l9J3WSucZMJA66Fjz+xbdSeWpy4oc2EslL6GrgnBkJGtVaHdWp8WCLlY
         f3P05Ucf/fTbihobmu+tYX/B9HT7O1SJn94Rb7+VIt/ormDMTpg3tgLK5GxbH3Mvfs
         GermCcYV50LzLHZ84ldAd379twdtQtjDQmyzd8oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/121] net: ipv6: add fib6_nh_release_dsts stub
Date:   Mon, 29 Nov 2021 19:18:19 +0100
Message-Id: <20211129181713.926746977@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index ac5ff3c3afb14..88bc66b8d02b0 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -491,6 +491,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct fib6_config *cfg, gfp_t gfp_flags,
 		 struct netlink_ext_ack *extack);
 void fib6_nh_release(struct fib6_nh *fib6_nh);
+void fib6_nh_release_dsts(struct fib6_nh *fib6_nh);
 
 int call_fib6_entry_notifiers(struct net *net,
 			      enum fib_event_type event_type,
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 8fce558b5fea3..14a43111ffc6a 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -47,6 +47,7 @@ struct ipv6_stub {
 			    struct fib6_config *cfg, gfp_t gfp_flags,
 			    struct netlink_ext_ack *extack);
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
+	void (*fib6_nh_release_dsts)(struct fib6_nh *fib6_nh);
 	void (*fib6_update_sernum)(struct net *net, struct fib6_info *rt);
 	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt, bool skip_notify);
 	void (*fib6_rt_update)(struct net *net, struct fib6_info *rt,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb1670..090575346daf6 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1016,6 +1016,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_mtu_from_fib6 = ip6_mtu_from_fib6,
 	.fib6_nh_init	   = fib6_nh_init,
 	.fib6_nh_release   = fib6_nh_release,
+	.fib6_nh_release_dsts = fib6_nh_release_dsts,
 	.fib6_update_sernum = fib6_update_sernum_stub,
 	.fib6_rt_update	   = fib6_rt_update,
 	.ip6_del_rt	   = ip6_del_rt,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a68a7d7c07280..6fef0d7586bf6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3570,6 +3570,25 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
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



