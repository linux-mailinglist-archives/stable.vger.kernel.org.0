Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B04B2E3AE6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404343AbgL1Nm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403957AbgL1Nm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84584206ED;
        Mon, 28 Dec 2020 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162960;
        bh=ta8s5tOQLMgtm31ieLcgJoulBygNHScWPlis8790aj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdJOXUc/YlWKJRHrfZtiXaoxKic+E3JM826IPFLDDcS73RD+hnH61LnjJnBCv3C0g
         pN2Frp1tWN7hnf6aZgfZ6qBvPe0SSdv6kgmAgIzeTYE8sVEbHq+gO5cKe6bxb9aMft
         spA69/lisp/uc4xbGEhJapEwCGKJvuuy7MR8GqrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/453] selftest/bpf: Add missed ip6ip6 test back
Date:   Mon, 28 Dec 2020 13:45:57 +0100
Message-Id: <20201228124943.038865086@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 58cfa49c2ba7f815adccc27a775e7cf8a8f7f539 ]

In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
ip6ip6 test") we added ip6ip6 test for bpf tunnel testing. But in commit
933a741e3b82 ("selftests/bpf: bpf tunnel test.") when we moved it to
the current folder, we didn't add it.

This patch add the ip6ip6 test back to bpf tunnel test. Update the ipip6's
topology for both IPv4 and IPv6 testing. Since iperf test is removed as
currect framework simplified it in purpose, I also removed unused tcp
checkings in test_tunnel_kern.c.

Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20201110015013.1570716-2-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/test_tunnel_kern.c    | 42 +++---------------
 tools/testing/selftests/bpf/test_tunnel.sh    | 43 +++++++++++++++++--
 2 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index 504df69c83df4..0f98724120deb 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -15,7 +15,6 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/types.h>
-#include <linux/tcp.h>
 #include <linux/socket.h>
 #include <linux/pkt_cls.h>
 #include <linux/erspan.h>
@@ -528,12 +527,11 @@ int _ipip_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct iphdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
@@ -541,16 +539,6 @@ int _ipip_set_tunnel(struct __sk_buff *skb)
 	key.tunnel_ttl = 64;
 	if (iph->protocol == IPPROTO_ICMP) {
 		key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
-	} else {
-		if (iph->protocol != IPPROTO_TCP || iph->ihl != 5)
-			return TC_ACT_SHOT;
-
-		if (tcp->dest == bpf_htons(5200))
-			key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
-		else if (tcp->dest == bpf_htons(5201))
-			key.remote_ipv4 = 0xac100165; /* 172.16.1.101 */
-		else
-			return TC_ACT_SHOT;
 	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key), 0);
@@ -585,19 +573,20 @@ int _ipip6_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct iphdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
 
 	__builtin_memset(&key, 0x0, sizeof(key));
-	key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
 	key.tunnel_ttl = 64;
+	if (iph->protocol == IPPROTO_ICMP) {
+		key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
+	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
 				     BPF_F_TUNINFO_IPV6);
@@ -634,35 +623,18 @@ int _ip6ip6_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct ipv6hdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
 
-	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
 	key.tunnel_ttl = 64;
-
 	if (iph->nexthdr == 58 /* NEXTHDR_ICMP */) {
-		key.remote_ipv6[3] = bpf_htonl(1);
-	} else {
-		if (iph->nexthdr != 6 /* NEXTHDR_TCP */) {
-			ERROR(iph->nexthdr);
-			return TC_ACT_SHOT;
-		}
-
-		if (tcp->dest == bpf_htons(5200)) {
-			key.remote_ipv6[3] = bpf_htonl(1);
-		} else if (tcp->dest == bpf_htons(5201)) {
-			key.remote_ipv6[3] = bpf_htonl(2);
-		} else {
-			ERROR(tcp->dest);
-			return TC_ACT_SHOT;
-		}
+		key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
 	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
index bd12ec97a44df..1ccbe804e8e1c 100755
--- a/tools/testing/selftests/bpf/test_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tunnel.sh
@@ -24,12 +24,12 @@
 # Root namespace with metadata-mode tunnel + BPF
 # Device names and addresses:
 # 	veth1 IP: 172.16.1.200, IPv6: 00::22 (underlay)
-# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200 (overlay)
+# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200, IPv6: 1::22 (overlay)
 #
 # Namespace at_ns0 with native tunnel
 # Device names and addresses:
 # 	veth0 IPv4: 172.16.1.100, IPv6: 00::11 (underlay)
-# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100 (overlay)
+# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100, IPv6: 1::11 (overlay)
 #
 #
 # End-to-end ping packet flow
@@ -250,7 +250,7 @@ add_ipip_tunnel()
 	ip addr add dev $DEV 10.1.1.200/24
 }
 
-add_ipip6tnl_tunnel()
+add_ip6tnl_tunnel()
 {
 	ip netns exec at_ns0 ip addr add ::11/96 dev veth0
 	ip netns exec at_ns0 ip link set dev veth0 up
@@ -262,11 +262,13 @@ add_ipip6tnl_tunnel()
 		ip link add dev $DEV_NS type $TYPE \
 		local ::11 remote ::22
 	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
+	ip netns exec at_ns0 ip addr add dev $DEV_NS 1::11/96
 	ip netns exec at_ns0 ip link set dev $DEV_NS up
 
 	# root namespace
 	ip link add dev $DEV type $TYPE external
 	ip addr add dev $DEV 10.1.1.200/24
+	ip addr add dev $DEV 1::22/96
 	ip link set dev $DEV up
 }
 
@@ -534,7 +536,7 @@ test_ipip6()
 
 	check $TYPE
 	config_device
-	add_ipip6tnl_tunnel
+	add_ip6tnl_tunnel
 	ip link set dev veth1 mtu 1500
 	attach_bpf $DEV ipip6_set_tunnel ipip6_get_tunnel
 	# underlay
@@ -553,6 +555,34 @@ test_ipip6()
         echo -e ${GREEN}"PASS: $TYPE"${NC}
 }
 
+test_ip6ip6()
+{
+	TYPE=ip6tnl
+	DEV_NS=ip6ip6tnl00
+	DEV=ip6ip6tnl11
+	ret=0
+
+	check $TYPE
+	config_device
+	add_ip6tnl_tunnel
+	ip link set dev veth1 mtu 1500
+	attach_bpf $DEV ip6ip6_set_tunnel ip6ip6_get_tunnel
+	# underlay
+	ping6 $PING_ARG ::11
+	# ip6 over ip6
+	ping6 $PING_ARG 1::11
+	check_err $?
+	ip netns exec at_ns0 ping6 $PING_ARG 1::22
+	check_err $?
+	cleanup
+
+	if [ $ret -ne 0 ]; then
+                echo -e ${RED}"FAIL: ip6$TYPE"${NC}
+                return 1
+        fi
+        echo -e ${GREEN}"PASS: ip6$TYPE"${NC}
+}
+
 setup_xfrm_tunnel()
 {
 	auth=0x$(printf '1%.0s' {1..40})
@@ -646,6 +676,7 @@ cleanup()
 	ip link del veth1 2> /dev/null
 	ip link del ipip11 2> /dev/null
 	ip link del ipip6tnl11 2> /dev/null
+	ip link del ip6ip6tnl11 2> /dev/null
 	ip link del gretap11 2> /dev/null
 	ip link del ip6gre11 2> /dev/null
 	ip link del ip6gretap11 2> /dev/null
@@ -742,6 +773,10 @@ bpf_tunnel_test()
 	test_ipip6
 	errors=$(( $errors + $? ))
 
+	echo "Testing IP6IP6 tunnel..."
+	test_ip6ip6
+	errors=$(( $errors + $? ))
+
 	echo "Testing IPSec tunnel..."
 	test_xfrm_tunnel
 	errors=$(( $errors + $? ))
-- 
2.27.0



