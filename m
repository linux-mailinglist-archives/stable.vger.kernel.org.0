Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5D74727D1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbhLMKFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49688 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238940AbhLMKBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:01:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8FC25CE0F8F;
        Mon, 13 Dec 2021 10:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FC4C34604;
        Mon, 13 Dec 2021 10:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389701;
        bh=TzRbTAmIN2O4nc2nTlH7ECyI3bJrKjXsUDTA/pyPUrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUkMh8HWvPrE4oKPoHcvku+V8BhwMr0jx+K1NfRh/8YThJW8evJEqYKYWjiaGaV2i
         /gyJEMKWR3Io1HNiAipQZqxXBBfmfBurfgOwBS+fZfx1do2awPYWfZZyIot/w4jmF7
         UgNjTNv3x5JIDHBVvMCUBuwW3IDN7O2fsyriDelQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 135/171] selftests/fib_tests: Rework fib_rp_filter_test()
Date:   Mon, 13 Dec 2021 10:30:50 +0100
Message-Id: <20211213092949.588555944@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

commit f6071e5e3961eeb5300bd0901c9e128598730ae3 upstream.

Currently rp_filter tests in fib_tests.sh:fib_rp_filter_test() are
failing.  ping sockets are bound to dummy1 using the "-I" option
(SO_BINDTODEVICE), but socket lookup is failing when receiving ping
replies, since the routing table thinks they belong to dummy0.

For example, suppose ping is using a SOCK_RAW socket for ICMP messages.
When receiving ping replies, in __raw_v4_lookup(), sk->sk_bound_dev_if
is 3 (dummy1), but dif (skb_rtable(skb)->rt_iif) says 2 (dummy0), so the
raw_sk_bound_dev_eq() check fails.  Similar things happen in
ping_lookup() for SOCK_DGRAM sockets.

These tests used to pass due to a bug [1] in iputils, where "ping -I"
actually did not bind ICMP message sockets to device.  The bug has been
fixed by iputils commit f455fee41c07 ("ping: also bind the ICMP socket
to the specific device") in 2016, which is why our rp_filter tests
started to fail.  See [2] .

Fixing the tests while keeping everything in one netns turns out to be
nontrivial.  Rework the tests and build the following topology:

 ┌─────────────────────────────┐    ┌─────────────────────────────┐
 │  network namespace 1 (ns1)  │    │  network namespace 2 (ns2)  │
 │                             │    │                             │
 │  ┌────┐     ┌─────┐         │    │  ┌─────┐            ┌────┐  │
 │  │ lo │<───>│veth1│<────────┼────┼─>│veth2│<──────────>│ lo │  │
 │  └────┘     ├─────┴──────┐  │    │  ├─────┴──────┐     └────┘  │
 │             │192.0.2.1/24│  │    │  │192.0.2.1/24│             │
 │             └────────────┘  │    │  └────────────┘             │
 └─────────────────────────────┘    └─────────────────────────────┘

Consider sending an ICMP_ECHO packet A in ns2.  Both source and
destination IP addresses are 192.0.2.1, and we use strict mode rp_filter
in both ns1 and ns2:

  1. A is routed to lo since its destination IP address is one of ns2's
     local addresses (veth2);
  2. A is redirected from lo's egress to veth2's egress using mirred;
  3. A arrives at veth1's ingress in ns1;
  4. A is redirected from veth1's ingress to lo's ingress, again, using
     mirred;
  5. In __fib_validate_source(), fib_info_nh_uses_dev() returns false,
     since A was received on lo, but reverse path lookup says veth1;
  6. However A is not dropped since we have relaxed this check for lo in
     commit 66f8209547cc ("fib: relax source validation check for loopback
     packets");

Making sure A is not dropped here in this corner case is the whole point
of having this test.

  7. As A reaches the ICMP layer, an ICMP_ECHOREPLY packet, B, is
     generated;
  8. Similarly, B is redirected from lo's egress to veth1's egress (in
     ns1), then redirected once again from veth2's ingress to lo's
     ingress (in ns2), using mirred.

Also test "ping 127.0.0.1" from ns2.  It does not trigger the relaxed
check in __fib_validate_source(), but just to make sure the topology
works with loopback addresses.

Tested with ping from iputils 20210722-41-gf9fb573:

$ ./fib_tests.sh -t rp_filter

IPv4 rp_filter tests
    TEST: rp_filter passes local packets		[ OK ]
    TEST: rp_filter passes loopback packets		[ OK ]

[1] https://github.com/iputils/iputils/issues/55
[2] https://github.com/iputils/iputils/commit/f455fee41c077d4b700a473b2f5b3487b8febc1d

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: adb701d6cfa4 ("selftests: add a test case for rp_filter")
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211201004720.6357-1-yepeilin.cs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_tests.sh |   59 +++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -444,24 +444,63 @@ fib_rp_filter_test()
 	setup
 
 	set -e
+	ip netns add ns2
+	ip netns set ns2 auto
+
+	ip -netns ns2 link set dev lo up
+
+	$IP link add name veth1 type veth peer name veth2
+	$IP link set dev veth2 netns ns2
+	$IP address add 192.0.2.1/24 dev veth1
+	ip -netns ns2 address add 192.0.2.1/24 dev veth2
+	$IP link set dev veth1 up
+	ip -netns ns2 link set dev veth2 up
+
 	$IP link set dev lo address 52:54:00:6a:c7:5e
-	$IP link set dummy0 address 52:54:00:6a:c7:5e
-	$IP link add dummy1 type dummy
-	$IP link set dummy1 address 52:54:00:6a:c7:5e
-	$IP link set dev dummy1 up
+	$IP link set dev veth1 address 52:54:00:6a:c7:5e
+	ip -netns ns2 link set dev lo address 52:54:00:6a:c7:5e
+	ip -netns ns2 link set dev veth2 address 52:54:00:6a:c7:5e
+
+	# 1. (ns2) redirect lo's egress to veth2's egress
+	ip netns exec ns2 tc qdisc add dev lo parent root handle 1: fq_codel
+	ip netns exec ns2 tc filter add dev lo parent 1: protocol arp basic \
+		action mirred egress redirect dev veth2
+	ip netns exec ns2 tc filter add dev lo parent 1: protocol ip basic \
+		action mirred egress redirect dev veth2
+
+	# 2. (ns1) redirect veth1's ingress to lo's ingress
+	$NS_EXEC tc qdisc add dev veth1 ingress
+	$NS_EXEC tc filter add dev veth1 ingress protocol arp basic \
+		action mirred ingress redirect dev lo
+	$NS_EXEC tc filter add dev veth1 ingress protocol ip basic \
+		action mirred ingress redirect dev lo
+
+	# 3. (ns1) redirect lo's egress to veth1's egress
+	$NS_EXEC tc qdisc add dev lo parent root handle 1: fq_codel
+	$NS_EXEC tc filter add dev lo parent 1: protocol arp basic \
+		action mirred egress redirect dev veth1
+	$NS_EXEC tc filter add dev lo parent 1: protocol ip basic \
+		action mirred egress redirect dev veth1
+
+	# 4. (ns2) redirect veth2's ingress to lo's ingress
+	ip netns exec ns2 tc qdisc add dev veth2 ingress
+	ip netns exec ns2 tc filter add dev veth2 ingress protocol arp basic \
+		action mirred ingress redirect dev lo
+	ip netns exec ns2 tc filter add dev veth2 ingress protocol ip basic \
+		action mirred ingress redirect dev lo
+
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.rp_filter=1
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.accept_local=1
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.route_localnet=1
-
-	$NS_EXEC tc qd add dev dummy1 parent root handle 1: fq_codel
-	$NS_EXEC tc filter add dev dummy1 parent 1: protocol arp basic action mirred egress redirect dev lo
-	$NS_EXEC tc filter add dev dummy1 parent 1: protocol ip basic action mirred egress redirect dev lo
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.rp_filter=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.accept_local=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.route_localnet=1
 	set +e
 
-	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 198.51.100.1"
+	run_cmd "ip netns exec ns2 ping -w1 -c1 192.0.2.1"
 	log_test $? 0 "rp_filter passes local packets"
 
-	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 127.0.0.1"
+	run_cmd "ip netns exec ns2 ping -w1 -c1 127.0.0.1"
 	log_test $? 0 "rp_filter passes loopback packets"
 
 	cleanup


