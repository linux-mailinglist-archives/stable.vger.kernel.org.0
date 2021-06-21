Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4373AEEB3
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhFUQbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232493AbhFUQ3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C716100A;
        Mon, 21 Jun 2021 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292666;
        bh=cKhUS4vqPpygwwYSWuhU83L2eD0RwH9mjU07q3AEHhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJCvRJoKPP5wyjq4mFGDYzP0Xn3L3YN5mvQFxd5I7BA7RY7zfvAqhRAuiPdtPIRo8
         NsZ8uQHqsz9QEc0Odabhg1q6BmQLsOi8lQgllCaX+ltL4Ynymofz/3psZfNRZoLxpf
         M7g3wjN2ikrRgzb9GxeH8iLGdl3m1EEzB73lpPco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Herms <oliver.peter.herms@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/146] ipv4: Fix device used for dst_alloc with local routes
Date:   Mon, 21 Jun 2021 18:14:42 +0200
Message-Id: <20210621154913.645584801@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit b87b04f5019e821c8c6c7761f258402e43500a1f ]

Oliver reported a use case where deleting a VRF device can hang
waiting for the refcnt to drop to 0. The root cause is that the dst
is allocated against the VRF device but cached on the loopback
device.

The use case (added to the selftests) has an implicit VRF crossing
due to the ordering of the FIB rules (lookup local is before the
l3mdev rule, but the problem occurs even if the FIB rules are
re-ordered with local after l3mdev because the VRF table does not
have a default route to terminate the lookup). The end result is
is that the FIB lookup returns the loopback device as the nexthop,
but the ingress device is in a VRF. The mismatch causes the dst
alloc against the VRF device but then cached on the loopback.

The fix is to bring the trick used for IPv6 (see ip6_rt_get_dev_rcu):
pick the dst alloc device based the fib lookup result but with checks
that the result has a nexthop device (e.g., not an unreachable or
prohibit entry).

Fixes: f5a0aab84b74 ("net: ipv4: dst for local input routes should use l3mdev if relevant")
Reported-by: Oliver Herms <oliver.peter.herms@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c                         | 15 +++++++++++++-
 tools/testing/selftests/net/fib_tests.sh | 25 ++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 798dc85bde5b..e968bb47d5bd 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2076,6 +2076,19 @@ martian_source:
 	return err;
 }
 
+/* get device for dst_alloc with local routes */
+static struct net_device *ip_rt_get_dev(struct net *net,
+					const struct fib_result *res)
+{
+	struct fib_nh_common *nhc = res->fi ? res->nhc : NULL;
+	struct net_device *dev = NULL;
+
+	if (nhc)
+		dev = l3mdev_master_dev_rcu(nhc->nhc_dev);
+
+	return dev ? : net->loopback_dev;
+}
+
 /*
  *	NOTE. We drop all the packets that has local source
  *	addresses, because every properly looped back packet
@@ -2232,7 +2245,7 @@ local_input:
 		}
 	}
 
-	rth = rt_dst_alloc(l3mdev_master_dev_rcu(dev) ? : net->loopback_dev,
+	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
 			   flags | RTCF_LOCAL, res->type,
 			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
 	if (!rth)
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 2b5707738609..6fad54c7ecb4 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1384,12 +1384,37 @@ ipv4_rt_replace()
 	ipv4_rt_replace_mpath
 }
 
+# checks that cached input route on VRF port is deleted
+# when VRF is deleted
+ipv4_local_rt_cache()
+{
+	run_cmd "ip addr add 10.0.0.1/32 dev lo"
+	run_cmd "ip netns add test-ns"
+	run_cmd "ip link add veth-outside type veth peer name veth-inside"
+	run_cmd "ip link add vrf-100 type vrf table 1100"
+	run_cmd "ip link set veth-outside master vrf-100"
+	run_cmd "ip link set veth-inside netns test-ns"
+	run_cmd "ip link set veth-outside up"
+	run_cmd "ip link set vrf-100 up"
+	run_cmd "ip route add 10.1.1.1/32 dev veth-outside table 1100"
+	run_cmd "ip netns exec test-ns ip link set veth-inside up"
+	run_cmd "ip netns exec test-ns ip addr add 10.1.1.1/32 dev veth-inside"
+	run_cmd "ip netns exec test-ns ip route add 10.0.0.1/32 dev veth-inside"
+	run_cmd "ip netns exec test-ns ip route add default via 10.0.0.1"
+	run_cmd "ip netns exec test-ns ping 10.0.0.1 -c 1 -i 1"
+	run_cmd "ip link delete vrf-100"
+
+	# if we do not hang test is a success
+	log_test $? 0 "Cached route removed from VRF port device"
+}
+
 ipv4_route_test()
 {
 	route_setup
 
 	ipv4_rt_add
 	ipv4_rt_replace
+	ipv4_local_rt_cache
 
 	route_cleanup
 }
-- 
2.30.2



