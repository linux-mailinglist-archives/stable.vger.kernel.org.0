Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29C55AB02F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiIBMu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbiIBMuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D4F5CE1;
        Fri,  2 Sep 2022 05:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9EED621C1;
        Fri,  2 Sep 2022 12:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAB2C433B5;
        Fri,  2 Sep 2022 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122072;
        bh=+wY6rbuHzDJ0l7WdqIxDX1NCcw+KRXSlQbe6Gf7RwLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2mwpFuKw8XzebCnerI64GrV71+tuuR3YelINmdo86GZbbR+wyGnlptHmPQ65TQq3
         koIsz2iRH5IkHkiERrTM0VKbbQglqMm6oHqrx+hPHhbm6tEhHbhwmbjMAkV4BlsJsw
         j/pQD5j/tDkM0ioqco27hVv/uLQRwM1cWH5DdU/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/73] testing: selftests: nft_flowtable.sh: use random netns names
Date:   Fri,  2 Sep 2022 14:19:29 +0200
Message-Id: <20220902121406.551838064@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b71b7bfeac38c7a21c423ddafb29aa6258949df8 ]

"ns1" is a too generic name, use a random suffix to avoid
errors when such a netns exists.  Also allows to run multiple
instances of the script in parallel.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/netfilter/nft_flowtable.sh      | 246 +++++++++---------
 1 file changed, 128 insertions(+), 118 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index d4ffebb989f88..c336e6c148d1f 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -14,6 +14,11 @@
 # nft_flowtable.sh -o8000 -l1500 -r2000
 #
 
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+nsr1="nsr1-$sfx"
+nsr2="nsr2-$sfx"
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -36,18 +41,17 @@ checktool (){
 checktool "nft --version" "run test without nft tool"
 checktool "ip -Version" "run test without ip tool"
 checktool "which nc" "run test without nc (netcat)"
-checktool "ip netns add nsr1" "create net namespace"
+checktool "ip netns add $nsr1" "create net namespace $nsr1"
 
-ip netns add ns1
-ip netns add ns2
-
-ip netns add nsr2
+ip netns add $ns1
+ip netns add $ns2
+ip netns add $nsr2
 
 cleanup() {
-	for i in 1 2; do
-		ip netns del ns$i
-		ip netns del nsr$i
-	done
+	ip netns del $ns1
+	ip netns del $ns2
+	ip netns del $nsr1
+	ip netns del $nsr2
 
 	rm -f "$ns1in" "$ns1out"
 	rm -f "$ns2in" "$ns2out"
@@ -59,22 +63,21 @@ trap cleanup EXIT
 
 sysctl -q net.netfilter.nf_log_all_netns=1
 
-ip link add veth0 netns nsr1 type veth peer name eth0 netns ns1
-ip link add veth1 netns nsr1 type veth peer name veth0 netns nsr2
+ip link add veth0 netns $nsr1 type veth peer name eth0 netns $ns1
+ip link add veth1 netns $nsr1 type veth peer name veth0 netns $nsr2
 
-ip link add veth1 netns nsr2 type veth peer name eth0 netns ns2
+ip link add veth1 netns $nsr2 type veth peer name eth0 netns $ns2
 
 for dev in lo veth0 veth1; do
-  for i in 1 2; do
-    ip -net nsr$i link set $dev up
-  done
+    ip -net $nsr1 link set $dev up
+    ip -net $nsr2 link set $dev up
 done
 
-ip -net nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net nsr1 addr add dead:1::1/64 dev veth0
+ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
+ip -net $nsr1 addr add dead:1::1/64 dev veth0
 
-ip -net nsr2 addr add 10.0.2.1/24 dev veth1
-ip -net nsr2 addr add dead:2::1/64 dev veth1
+ip -net $nsr2 addr add 10.0.2.1/24 dev veth1
+ip -net $nsr2 addr add dead:2::1/64 dev veth1
 
 # set different MTUs so we need to push packets coming from ns1 (large MTU)
 # to ns2 (smaller MTU) to stack either to perform fragmentation (ip_no_pmtu_disc=1),
@@ -106,49 +109,56 @@ do
 	esac
 done
 
-if ! ip -net nsr1 link set veth0 mtu $omtu; then
+if ! ip -net $nsr1 link set veth0 mtu $omtu; then
 	exit 1
 fi
 
-ip -net ns1 link set eth0 mtu $omtu
+ip -net $ns1 link set eth0 mtu $omtu
 
-if ! ip -net nsr2 link set veth1 mtu $rmtu; then
+if ! ip -net $nsr2 link set veth1 mtu $rmtu; then
 	exit 1
 fi
 
-ip -net ns2 link set eth0 mtu $rmtu
+ip -net $ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
 # these addresses are not used for connections.
-ip -net nsr1 addr add 192.168.10.1/24 dev veth1
-ip -net nsr1 addr add fee1:2::1/64 dev veth1
-
-ip -net nsr2 addr add 192.168.10.2/24 dev veth0
-ip -net nsr2 addr add fee1:2::2/64 dev veth0
-
-for i in 1 2; do
-  ip netns exec nsr$i sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
-  ip netns exec nsr$i sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
-
-  ip -net ns$i link set lo up
-  ip -net ns$i link set eth0 up
-  ip -net ns$i addr add 10.0.$i.99/24 dev eth0
-  ip -net ns$i route add default via 10.0.$i.1
-  ip -net ns$i addr add dead:$i::99/64 dev eth0
-  ip -net ns$i route add default via dead:$i::1
-  if ! ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
+ip -net $nsr1 addr add 192.168.10.1/24 dev veth1
+ip -net $nsr1 addr add fee1:2::1/64 dev veth1
+
+ip -net $nsr2 addr add 192.168.10.2/24 dev veth0
+ip -net $nsr2 addr add fee1:2::2/64 dev veth0
+
+for i in 0 1; do
+  ip netns exec $nsr1 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
+  ip netns exec $nsr2 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
+done
+
+for ns in $ns1 $ns2;do
+  ip -net $ns link set lo up
+  ip -net $ns link set eth0 up
+
+  if ! ip netns exec $ns sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
 	echo "ERROR: Check Originator/Responder values (problem during address addition)"
 	exit 1
   fi
-
   # don't set ip DF bit for first two tests
-  ip netns exec ns$i sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
+  ip netns exec $ns sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
 done
 
-ip -net nsr1 route add default via 192.168.10.2
-ip -net nsr2 route add default via 192.168.10.1
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0
+ip -net $ns2 addr add 10.0.2.99/24 dev eth0
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns2 route add default via 10.0.2.1
+ip -net $ns1 addr add dead:1::99/64 dev eth0
+ip -net $ns2 addr add dead:2::99/64 dev eth0
+ip -net $ns1 route add default via dead:1::1
+ip -net $ns2 route add default via dead:2::1
+
+ip -net $nsr1 route add default via 192.168.10.2
+ip -net $nsr2 route add default via 192.168.10.1
 
-ip netns exec nsr1 nft -f - <<EOF
+ip netns exec $nsr1 nft -f - <<EOF
 table inet filter {
   flowtable f1 {
      hook ingress priority 0
@@ -197,18 +207,18 @@ if [ $? -ne 0 ]; then
 fi
 
 # test basic connectivity
-if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
-  echo "ERROR: ns1 cannot reach ns2" 1>&2
+if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
+  echo "ERROR: $ns1 cannot reach ns2" 1>&2
   exit 1
 fi
 
-if ! ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
-  echo "ERROR: ns2 cannot reach ns1" 1>&2
+if ! ip netns exec $ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
+  echo "ERROR: $ns2 cannot reach $ns1" 1>&2
   exit 1
 fi
 
 if [ $ret -eq 0 ];then
-	echo "PASS: netns routing/connectivity: ns1 can reach ns2"
+	echo "PASS: netns routing/connectivity: $ns1 can reach $ns2"
 fi
 
 ns1in=$(mktemp)
@@ -312,24 +322,24 @@ make_file "$ns2in"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
-if test_tcp_forwarding ns1 ns2; then
+if test_tcp_forwarding $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
 	echo "FAIL: flow offload for ns1/ns2:" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
-ip -net ns2 route del default via 10.0.2.1
-ip -net ns2 route del default via dead:2::1
-ip -net ns2 route add 192.168.10.1 via 10.0.2.1
+ip -net $ns2 route del default via 10.0.2.1
+ip -net $ns2 route del default via dead:2::1
+ip -net $ns2 route add 192.168.10.1 via 10.0.2.1
 
 # Second test:
 # Same, but with NAT enabled.
-ip netns exec nsr1 nft -f - <<EOF
+ip netns exec $nsr1 nft -f - <<EOF
 table ip nat {
    chain prerouting {
       type nat hook prerouting priority 0; policy accept;
@@ -343,47 +353,47 @@ table ip nat {
 }
 EOF
 
-if test_tcp_forwarding_nat ns1 ns2; then
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # Third test:
 # Same as second test, but with PMTU discovery enabled.
-handle=$(ip netns exec nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
+handle=$(ip netns exec $nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
 
-if ! ip netns exec nsr1 nft delete rule inet filter forward $handle; then
+if ! ip netns exec $nsr1 nft delete rule inet filter forward $handle; then
 	echo "FAIL: Could not delete large-packet accept rule"
 	exit 1
 fi
 
-ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
-ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec $ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec $ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-if test_tcp_forwarding_nat ns1 ns2; then
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 fi
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT enabled.
-ip -net nsr1 link add name br0 type bridge
-ip -net nsr1 addr flush dev veth0
-ip -net nsr1 link set up dev veth0
-ip -net nsr1 link set veth0 master br0
-ip -net nsr1 addr add 10.0.1.1/24 dev br0
-ip -net nsr1 addr add dead:1::1/64 dev br0
-ip -net nsr1 link set up dev br0
+ip -net $nsr1 link add name br0 type bridge
+ip -net $nsr1 addr flush dev veth0
+ip -net $nsr1 link set up dev veth0
+ip -net $nsr1 link set veth0 master br0
+ip -net $nsr1 addr add 10.0.1.1/24 dev br0
+ip -net $nsr1 addr add dead:1::1/64 dev br0
+ip -net $nsr1 link set up dev br0
 
-ip netns exec nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
+ip netns exec $nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
 
 # br0 with NAT enabled.
-ip netns exec nsr1 nft -f - <<EOF
+ip netns exec $nsr1 nft -f - <<EOF
 flush table ip nat
 table ip nat {
    chain prerouting {
@@ -398,59 +408,59 @@ table ip nat {
 }
 EOF
 
-if test_tcp_forwarding_nat ns1 ns2; then
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT"
 else
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT and VLAN.
-ip -net nsr1 link set veth0 nomaster
-ip -net nsr1 link set down dev veth0
-ip -net nsr1 link add link veth0 name veth0.10 type vlan id 10
-ip -net nsr1 link set up dev veth0
-ip -net nsr1 link set up dev veth0.10
-ip -net nsr1 link set veth0.10 master br0
-
-ip -net ns1 addr flush dev eth0
-ip -net ns1 link add link eth0 name eth0.10 type vlan id 10
-ip -net ns1 link set eth0 up
-ip -net ns1 link set eth0.10 up
-ip -net ns1 addr add 10.0.1.99/24 dev eth0.10
-ip -net ns1 route add default via 10.0.1.1
-ip -net ns1 addr add dead:1::99/64 dev eth0.10
-
-if test_tcp_forwarding_nat ns1 ns2; then
+ip -net $nsr1 link set veth0 nomaster
+ip -net $nsr1 link set down dev veth0
+ip -net $nsr1 link add link veth0 name veth0.10 type vlan id 10
+ip -net $nsr1 link set up dev veth0
+ip -net $nsr1 link set up dev veth0.10
+ip -net $nsr1 link set veth0.10 master br0
+
+ip -net $ns1 addr flush dev eth0
+ip -net $ns1 link add link eth0 name eth0.10 type vlan id 10
+ip -net $ns1 link set eth0 up
+ip -net $ns1 link set eth0.10 up
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0.10
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns1 addr add dead:1::99/64 dev eth0.10
+
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT and VLAN"
 else
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # restore test topology (remove bridge and VLAN)
-ip -net nsr1 link set veth0 nomaster
-ip -net nsr1 link set veth0 down
-ip -net nsr1 link set veth0.10 down
-ip -net nsr1 link delete veth0.10 type vlan
-ip -net nsr1 link delete br0 type bridge
-ip -net ns1 addr flush dev eth0.10
-ip -net ns1 link set eth0.10 down
-ip -net ns1 link set eth0 down
-ip -net ns1 link delete eth0.10 type vlan
+ip -net $nsr1 link set veth0 nomaster
+ip -net $nsr1 link set veth0 down
+ip -net $nsr1 link set veth0.10 down
+ip -net $nsr1 link delete veth0.10 type vlan
+ip -net $nsr1 link delete br0 type bridge
+ip -net $ns1 addr flush dev eth0.10
+ip -net $ns1 link set eth0.10 down
+ip -net $ns1 link set eth0 down
+ip -net $ns1 link delete eth0.10 type vlan
 
 # restore address in ns1 and nsr1
-ip -net ns1 link set eth0 up
-ip -net ns1 addr add 10.0.1.99/24 dev eth0
-ip -net ns1 route add default via 10.0.1.1
-ip -net ns1 addr add dead:1::99/64 dev eth0
-ip -net ns1 route add default via dead:1::1
-ip -net nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net nsr1 addr add dead:1::1/64 dev veth0
-ip -net nsr1 link set up dev veth0
+ip -net $ns1 link set eth0 up
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns1 addr add dead:1::99/64 dev eth0
+ip -net $ns1 route add default via dead:1::1
+ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
+ip -net $nsr1 addr add dead:1::1/64 dev veth0
+ip -net $nsr1 link set up dev veth0
 
 KEY_SHA="0x"$(ps -xaf | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -xaf | md5sum | cut -d " " -f 1)
@@ -480,23 +490,23 @@ do_esp() {
 
 }
 
-do_esp nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
+do_esp $nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
 
-do_esp nsr2 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 $SPI2 $SPI1
+do_esp $nsr2 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 $SPI2 $SPI1
 
-ip netns exec nsr1 nft delete table ip nat
+ip netns exec $nsr1 nft delete table ip nat
 
 # restore default routes
-ip -net ns2 route del 192.168.10.1 via 10.0.2.1
-ip -net ns2 route add default via 10.0.2.1
-ip -net ns2 route add default via dead:2::1
+ip -net $ns2 route del 192.168.10.1 via 10.0.2.1
+ip -net $ns2 route add default via 10.0.2.1
+ip -net $ns2 route add default via dead:2::1
 
-if test_tcp_forwarding ns1 ns2; then
+if test_tcp_forwarding $ns1 $ns2; then
 	echo "PASS: ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
-	ip netns exec nsr1 nft list ruleset 1>&2
-	ip netns exec nsr1 cat /proc/net/xfrm_stat 1>&2
+	ip netns exec $nsr1 nft list ruleset 1>&2
+	ip netns exec $nsr1 cat /proc/net/xfrm_stat 1>&2
 fi
 
 exit $ret
-- 
2.35.1



