Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723561D0EFF
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733001AbgEMJsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732994AbgEMJsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFDB820740;
        Wed, 13 May 2020 09:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363286;
        bh=fpRgZrHwhdR7cxhBmK4qzwEzPTjHE0NoVCfgcTVfCC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMBGOthjyI33qXODT/sN6r42CA879J84RUmabZnpKE2dlVzCxdmPBqNsMk/HgcGxD
         W2jVwxPuqE95q+78Oyl2VT1xHW6wdyKdgm3QMGG3c8kOJg13EENEWo+RkxtgUDP5pR
         VIWOWcIQAv/jN6qTmyIw5ZJXoLRXwmbjCdbdlA4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 13/90] ipv6: Use global sernum for dst validation with nexthop objects
Date:   Wed, 13 May 2020 11:44:09 +0200
Message-Id: <20200513094410.412050680@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 8f34e53b60b337e559f1ea19e2780ff95ab2fa65 ]

Nik reported a bug with pcpu dst cache when nexthop objects are
used illustrated by the following:
    $ ip netns add foo
    $ ip -netns foo li set lo up
    $ ip -netns foo addr add 2001:db8:11::1/128 dev lo
    $ ip netns exec foo sysctl net.ipv6.conf.all.forwarding=1
    $ ip li add veth1 type veth peer name veth2
    $ ip li set veth1 up
    $ ip addr add 2001:db8:10::1/64 dev veth1
    $ ip li set dev veth2 netns foo
    $ ip -netns foo li set veth2 up
    $ ip -netns foo addr add 2001:db8:10::2/64 dev veth2
    $ ip -6 nexthop add id 100 via 2001:db8:10::2 dev veth1
    $ ip -6 route add 2001:db8:11::1/128 nhid 100

    Create a pcpu entry on cpu 0:
    $ taskset -a -c 0 ip -6 route get 2001:db8:11::1

    Re-add the route entry:
    $ ip -6 ro del 2001:db8:11::1
    $ ip -6 route add 2001:db8:11::1/128 nhid 100

    Route get on cpu 0 returns the stale pcpu:
    $ taskset -a -c 0 ip -6 route get 2001:db8:11::1
    RTNETLINK answers: Network is unreachable

    While cpu 1 works:
    $ taskset -a -c 1 ip -6 route get 2001:db8:11::1
    2001:db8:11::1 from :: via 2001:db8:10::2 dev veth1 src 2001:db8:10::1 metric 1024 pref medium

Conversion of FIB entries to work with external nexthop objects
missed an important difference between IPv4 and IPv6 - how dst
entries are invalidated when the FIB changes. IPv4 has a per-network
namespace generation id (rt_genid) that is bumped on changes to the FIB.
Checking if a dst_entry is still valid means comparing rt_genid in the
rtable to the current value of rt_genid for the namespace.

IPv6 also has a per network namespace counter, fib6_sernum, but the
count is saved per fib6_node. With the per-node counter only dst_entries
based on fib entries under the node are invalidated when changes are
made to the routes - limiting the scope of invalidations. IPv6 uses a
reference in the rt6_info, 'from', to track the corresponding fib entry
used to create the dst_entry. When validating a dst_entry, the 'from'
is used to backtrack to the fib6_node and check the sernum of it to the
cookie passed to the dst_check operation.

With the inline format (nexthop definition inline with the fib6_info),
dst_entries cached in the fib6_nh have a 1:1 correlation between fib
entries, nexthop data and dst_entries. With external nexthops, IPv6
looks more like IPv4 which means multiple fib entries across disparate
fib6_nodes can all reference the same fib6_nh. That means validation
of dst_entries based on external nexthops needs to use the IPv4 format
- the per-network namespace counter.

Add sernum to rt6_info and set it when creating a pcpu dst entry. Update
rt6_get_cookie to return sernum if it is set and update dst_check for
IPv6 to look for sernum set and based the check on it if so. Finally,
rt6_get_pcpu_route needs to validate the cached entry before returning
a pcpu entry (similar to the rt_cache_valid calls in __mkroute_input and
__mkroute_output for IPv4).

This problem only affects routes using the new, external nexthops.

Thanks to the kbuild test robot for catching the IS_ENABLED needed
around rt_genid_ipv6 before I sent this out.

Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Tested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_fib.h       |    4 ++++
 include/net/net_namespace.h |    7 +++++++
 net/ipv6/route.c            |   25 +++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -177,6 +177,7 @@ struct fib6_info {
 struct rt6_info {
 	struct dst_entry		dst;
 	struct fib6_info __rcu		*from;
+	int				sernum;
 
 	struct rt6key			rt6i_dst;
 	struct rt6key			rt6i_src;
@@ -260,6 +261,9 @@ static inline u32 rt6_get_cookie(const s
 	struct fib6_info *from;
 	u32 cookie = 0;
 
+	if (rt->sernum)
+		return rt->sernum;
+
 	rcu_read_lock();
 
 	from = rcu_dereference(rt->from);
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -428,6 +428,13 @@ static inline int rt_genid_ipv4(struct n
 	return atomic_read(&net->ipv4.rt_genid);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static inline int rt_genid_ipv6(const struct net *net)
+{
+	return atomic_read(&net->ipv6.fib6_sernum);
+}
+#endif
+
 static inline void rt_genid_bump_ipv4(struct net *net)
 {
 	atomic_inc(&net->ipv4.rt_genid);
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1388,9 +1388,18 @@ static struct rt6_info *ip6_rt_pcpu_allo
 	}
 	ip6_rt_copy_init(pcpu_rt, res);
 	pcpu_rt->rt6i_flags |= RTF_PCPU;
+
+	if (f6i->nh)
+		pcpu_rt->sernum = rt_genid_ipv6(dev_net(dev));
+
 	return pcpu_rt;
 }
 
+static bool rt6_is_valid(const struct rt6_info *rt6)
+{
+	return rt6->sernum == rt_genid_ipv6(dev_net(rt6->dst.dev));
+}
+
 /* It should be called with rcu_read_lock() acquired */
 static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 {
@@ -1398,6 +1407,19 @@ static struct rt6_info *rt6_get_pcpu_rou
 
 	pcpu_rt = this_cpu_read(*res->nh->rt6i_pcpu);
 
+	if (pcpu_rt && pcpu_rt->sernum && !rt6_is_valid(pcpu_rt)) {
+		struct rt6_info *prev, **p;
+
+		p = this_cpu_ptr(res->nh->rt6i_pcpu);
+		prev = xchg(p, NULL);
+		if (prev) {
+			dst_dev_put(&prev->dst);
+			dst_release(&prev->dst);
+		}
+
+		pcpu_rt = NULL;
+	}
+
 	return pcpu_rt;
 }
 
@@ -2599,6 +2621,9 @@ static struct dst_entry *ip6_dst_check(s
 
 	rt = container_of(dst, struct rt6_info, dst);
 
+	if (rt->sernum)
+		return rt6_is_valid(rt) ? dst : NULL;
+
 	rcu_read_lock();
 
 	/* All IPV6 dsts are created with ->obsolete set to the value


