Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1B443A210
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbhJYTpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236709AbhJYTm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD707603E5;
        Mon, 25 Oct 2021 19:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190650;
        bh=LlZM4snnPVbqZG8hwToudURJAn48WSoAiOZrTRL+zxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaLx/DZMVGJLrbuitpSdiSEscoMqw5pR0dbwRnD1vCCTdipnQ70CmXP8YCVm3RNpL
         myy7bmudd8lgEApdlq1rgqJzLMZuzH8tiUQBZOpLh0QUMCCjpnd0PMV/aVg3WqzFnV
         TVmmuV5swTMZoFHYHopLt8ZOerXkY+OEgQEEJJL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 037/169] ipv6: When forwarding count rx stats on the orig netdev
Date:   Mon, 25 Oct 2021 21:13:38 +0200
Message-Id: <20211025191022.575856682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit 0857d6f8c759d95f89d0436f86cdfd189ef99f20 ]

Commit bdb7cc643fc9 ("ipv6: Count interface receive statistics on the
ingress netdev") does not work when ip6_forward() executes on the skbs
with vrf-enslaved netdev. Use IP6CB(skb)->iif to get to the right one.

Add a selftest script to verify.

Fixes: bdb7cc643fc9 ("ipv6: Count interface receive statistics on the ingress netdev")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211014130845.410602-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c                         |   3 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/forwarding.config.sample   |   2 +
 .../net/forwarding/ip6_forward_instats_vrf.sh | 172 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 5 files changed, 185 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8e6ca9ad6812..80b1a7838cff 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -488,13 +488,14 @@ static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
 
 int ip6_forward(struct sk_buff *skb)
 {
-	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
 	struct dst_entry *dst = skb_dst(skb);
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(dst->dev);
+	struct inet6_dev *idev;
 	u32 mtu;
 
+	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
 	if (net->ipv6.devconf_all->forwarding == 0)
 		goto error;
 
diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index d97bd6889446..72ee644d47bf 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -9,6 +9,7 @@ TEST_PROGS = bridge_igmp.sh \
 	gre_inner_v4_multipath.sh \
 	gre_inner_v6_multipath.sh \
 	gre_multipath.sh \
+	ip6_forward_instats_vrf.sh \
 	ip6gre_inner_v4_multipath.sh \
 	ip6gre_inner_v6_multipath.sh \
 	ipip_flat_gre_key.sh \
diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index b802c14d2950..e5e2fbeca22e 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -39,3 +39,5 @@ NETIF_CREATE=yes
 # Timeout (in seconds) before ping exits regardless of how many packets have
 # been sent or received
 PING_TIMEOUT=5
+# IPv6 traceroute utility name.
+TROUTE6=traceroute6
diff --git a/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh b/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
new file mode 100755
index 000000000000..9f5b3e2e5e95
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
@@ -0,0 +1,172 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test ipv6 stats on the incoming if when forwarding with VRF
+
+ALL_TESTS="
+	ipv6_ping
+	ipv6_in_too_big_err
+	ipv6_in_hdr_err
+	ipv6_in_addr_err
+	ipv6_in_discard
+"
+
+NUM_NETIFS=4
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 2001:1:1::2/64
+	ip -6 route add vrf v$h1 2001:1:2::/64 via 2001:1:1::1
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 2001:1:2::/64 via 2001:1:1::1
+	simple_if_fini $h1 2001:1:1::2/64
+}
+
+router_create()
+{
+	vrf_create router
+	__simple_if_init $rtr1 router 2001:1:1::1/64
+	__simple_if_init $rtr2 router 2001:1:2::1/64
+	mtu_set $rtr2 1280
+}
+
+router_destroy()
+{
+	mtu_restore $rtr2
+	__simple_if_fini $rtr2 2001:1:2::1/64
+	__simple_if_fini $rtr1 2001:1:1::1/64
+	vrf_destroy router
+}
+
+h2_create()
+{
+	simple_if_init $h2 2001:1:2::2/64
+	ip -6 route add vrf v$h2 2001:1:1::/64 via 2001:1:2::1
+	mtu_set $h2 1280
+}
+
+h2_destroy()
+{
+	mtu_restore $h2
+	ip -6 route del vrf v$h2 2001:1:1::/64 via 2001:1:2::1
+	simple_if_fini $h2 2001:1:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rtr1=${NETIFS[p2]}
+
+	rtr2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+	h1_create
+	router_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	router_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+ipv6_in_too_big_err()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InTooBigErrors)
+	local vrf_name=$(master_name_get $h1)
+
+	# Send too big packets
+	ip vrf exec $vrf_name \
+		$PING6 -s 1300 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InTooBigErrors)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InTooBigErrors"
+}
+
+ipv6_in_hdr_err()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InHdrErrors)
+	local vrf_name=$(master_name_get $h1)
+
+	# Send packets with hop limit 1, easiest with traceroute6 as some ping6
+	# doesn't allow hop limit to be specified
+	ip vrf exec $vrf_name \
+		$TROUTE6 2001:1:2::2 &> /dev/null
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InHdrErrors)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InHdrErrors"
+}
+
+ipv6_in_addr_err()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InAddrErrors)
+	local vrf_name=$(master_name_get $h1)
+
+	# Disable forwarding temporary while sending the packet
+	sysctl -qw net.ipv6.conf.all.forwarding=0
+	ip vrf exec $vrf_name \
+		$PING6 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+	sysctl -qw net.ipv6.conf.all.forwarding=1
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InAddrErrors)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InAddrErrors"
+}
+
+ipv6_in_discard()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InDiscards)
+	local vrf_name=$(master_name_get $h1)
+
+	# Add a policy to discard
+	ip xfrm policy add dst 2001:1:2::2/128 dir fwd action block
+	ip vrf exec $vrf_name \
+		$PING6 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+	ip xfrm policy del dst 2001:1:2::2/128 dir fwd
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InDiscards)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InDiscards"
+}
+ipv6_ping()
+{
+	RET=0
+
+	ping6_test $h1 2001:1:2::2
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 42e28c983d41..5140980f5475 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -748,6 +748,14 @@ qdisc_parent_stats_get()
 	    | jq '.[] | select(.parent == "'"$parent"'") | '"$selector"
 }
 
+ipv6_stats_get()
+{
+	local dev=$1; shift
+	local stat=$1; shift
+
+	cat /proc/net/dev_snmp6/$dev | grep "^$stat" | cut -f2
+}
+
 humanize()
 {
 	local speed=$1; shift
-- 
2.33.0



