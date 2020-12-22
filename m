Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D61C2DEFA7
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgLSM6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgLSM6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:43 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 07/49] vrf: packets with lladdr src needs dst at input with orig_iif when needs strict
Date:   Sat, 19 Dec 2020 13:58:11 +0100
Message-Id: <20201219125345.035145505@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit 205704c618af0ab2366015d2281a3b0814d918a0 ]

Depending on the order of the routes to fe80::/64 are installed on the
VRF table, the NS for the source link-local address of the originator
might be sent to the wrong interface.

This patch ensures that packets with link-local addr source is doing a
lookup with the orig_iif when the destination addr indicates that it
is strict.

Add the reproducer as a use case in self test script fcnal-test.sh.

Fixes: b4869aa2f881 ("net: vrf: ipv6 support for local traffic to local addresses")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20201204030604.18828-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c                         |   10 ++-
 tools/testing/selftests/net/fcnal-test.sh |   95 ++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 2 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1315,11 +1315,17 @@ static struct sk_buff *vrf_ip6_rcv(struc
 	int orig_iif = skb->skb_iif;
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
+	bool is_ll_src;
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
-	 * packet taps again. Reset pkt_type for upper layers to process skb
+	 * packet taps again. Reset pkt_type for upper layers to process skb.
+	 * for packets with lladdr src, however, skip so that the dst can be
+	 * determine at input using original ifindex in the case that daddr
+	 * needs strict
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
+	is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
+	if (skb->pkt_type == PACKET_LOOPBACK ||
+	    (need_strict && !is_ndisc && !is_ll_src)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -256,6 +256,28 @@ setup_cmd_nsb()
 	fi
 }
 
+setup_cmd_nsc()
+{
+	local cmd="$*"
+	local rc
+
+	run_cmd_nsc ${cmd}
+	rc=$?
+	if [ $rc -ne 0 ]; then
+		# show user the command if not done so already
+		if [ "$VERBOSE" = "0" ]; then
+			echo "setup command: $cmd"
+		fi
+		echo "failed. stopping tests"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue"
+			read a
+		fi
+		exit $rc
+	fi
+}
+
 # set sysctl values in NS-A
 set_sysctl()
 {
@@ -471,6 +493,36 @@ setup()
 	sleep 1
 }
 
+setup_lla_only()
+{
+	# make sure we are starting with a clean slate
+	kill_procs
+	cleanup 2>/dev/null
+
+	log_debug "Configuring network namespaces"
+	set -e
+
+	create_ns ${NSA} "-" "-"
+	create_ns ${NSB} "-" "-"
+	create_ns ${NSC} "-" "-"
+	connect_ns ${NSA} ${NSA_DEV} "-" "-" \
+		   ${NSB} ${NSB_DEV} "-" "-"
+	connect_ns ${NSA} ${NSA_DEV2} "-" "-" \
+		   ${NSC} ${NSC_DEV}  "-" "-"
+
+	NSA_LINKIP6=$(get_linklocal ${NSA} ${NSA_DEV})
+	NSB_LINKIP6=$(get_linklocal ${NSB} ${NSB_DEV})
+	NSC_LINKIP6=$(get_linklocal ${NSC} ${NSC_DEV})
+
+	create_vrf ${NSA} ${VRF} ${VRF_TABLE} "-" "-"
+	ip -netns ${NSA} link set dev ${NSA_DEV} vrf ${VRF}
+	ip -netns ${NSA} link set dev ${NSA_DEV2} vrf ${VRF}
+
+	set +e
+
+	sleep 1
+}
+
 ################################################################################
 # IPv4
 
@@ -3787,10 +3839,53 @@ use_case_br()
 	setup_cmd_nsb ip li del vlan100 2>/dev/null
 }
 
+# VRF only.
+# ns-A device is connected to both ns-B and ns-C on a single VRF but only has
+# LLA on the interfaces
+use_case_ping_lla_multi()
+{
+	setup_lla_only
+	# only want reply from ns-A
+	setup_cmd_nsb sysctl -qw net.ipv6.icmp.echo_ignore_multicast=1
+	setup_cmd_nsc sysctl -qw net.ipv6.icmp.echo_ignore_multicast=1
+
+	log_start
+	run_cmd_nsb ping -c1 -w1 ${MCAST}%${NSB_DEV}
+	log_test_addr ${MCAST}%${NSB_DEV} $? 0 "Pre cycle, ping out ns-B"
+
+	run_cmd_nsc ping -c1 -w1 ${MCAST}%${NSC_DEV}
+	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Pre cycle, ping out ns-C"
+
+	# cycle/flap the first ns-A interface
+	setup_cmd ip link set ${NSA_DEV} down
+	setup_cmd ip link set ${NSA_DEV} up
+	sleep 1
+
+	log_start
+	run_cmd_nsb ping -c1 -w1 ${MCAST}%${NSB_DEV}
+	log_test_addr ${MCAST}%${NSB_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV}, ping out ns-B"
+	run_cmd_nsc ping -c1 -w1 ${MCAST}%${NSC_DEV}
+	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV}, ping out ns-C"
+
+	# cycle/flap the second ns-A interface
+	setup_cmd ip link set ${NSA_DEV2} down
+	setup_cmd ip link set ${NSA_DEV2} up
+	sleep 1
+
+	log_start
+	run_cmd_nsb ping -c1 -w1 ${MCAST}%${NSB_DEV}
+	log_test_addr ${MCAST}%${NSB_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV2}, ping out ns-B"
+	run_cmd_nsc ping -c1 -w1 ${MCAST}%${NSC_DEV}
+	log_test_addr ${MCAST}%${NSC_DEV} $? 0 "Post cycle ${NSA} ${NSA_DEV2}, ping out ns-C"
+}
+
 use_cases()
 {
 	log_section "Use cases"
+	log_subsection "Device enslaved to bridge"
 	use_case_br
+	log_subsection "Ping LLA with multiple interfaces"
+	use_case_ping_lla_multi
 }
 
 ################################################################################


