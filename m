Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FA966C50A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjAPQAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjAPQAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF64234D1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4A50B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473FBC433EF;
        Mon, 16 Jan 2023 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884848;
        bh=QxfTTK4YAka9/BvrIa5Gwqrzx9bVHYkWX7/D8qvsie0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKriVWRk+KMa+adN1XcOOot6I7RDVrIhwKTbGQZQtVBPzUNSX/JV7uDrA6PgoLQ3d
         +bNf2jZHyWIBNAhOlUllNGDvnDFa0V7Jh5ypgp26xp2Qe2IXE+j4LBFhPBIkzVHZIS
         +CFfTK2EF9F3y55wWvSH4cPRlOFqKibEqSfrrN+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/183] selftests/net: l2_tos_ttl_inherit.sh: Run tests in their own netns.
Date:   Mon, 16 Jan 2023 16:51:25 +0100
Message-Id: <20230116154810.148243028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit c53cb00f7983a5474f2d36967f84908b85af9159 ]

This selftest currently runs half in the current namespace and half in
a netns of its own. Therefore, the test can fail if the current
namespace is already configured with incompatible parameters (for
example if it already has a veth0 interface).

Adapt the script to put both ends of the veth pair in their own netns.
Now veth0 is created in NS0 instead of the current namespace, while
veth1 is set up in NS1 (instead of the 'testing' netns).

The user visible netns names are randomised to minimise the risk of
conflicts with already existing namespaces. The cleanup() function
doesn't need to remove the virtual interface anymore: deleting NS0 and
NS1 automatically removes the virtual interfaces they contained.

We can remove $ns, which was only used to run ip commands in the
'testing' netns (let's use the builtin "-netns" option instead).
However, we still need a similar functionality as ping and tcpdump
now need to run in NS0. So we now have $RUN_NS0 for that.

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/l2_tos_ttl_inherit.sh       | 162 ++++++++++--------
 1 file changed, 93 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
index e2574b08eabc..cf56680d598f 100755
--- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -25,6 +25,11 @@ expected_tos="0x00"
 expected_ttl="0"
 failed=false
 
+readonly NS0=$(mktemp -u ns0-XXXXXXXX)
+readonly NS1=$(mktemp -u ns1-XXXXXXXX)
+
+RUN_NS0="ip netns exec ${NS0}"
+
 get_random_tos() {
 	# Get a random hex tos value between 0x00 and 0xfc, a multiple of 4
 	echo "0x$(tr -dc '0-9a-f' < /dev/urandom | head -c 1)\
@@ -61,7 +66,6 @@ setup() {
 	local vlan="$5"
 	local test_tos="0x00"
 	local test_ttl="0"
-	local ns="ip netns exec testing"
 
 	# We don't want a test-tos of 0x00,
 	# because this is the value that we get when no tos is set.
@@ -94,14 +98,15 @@ setup() {
 	printf "│%7s │%6s │%6s │%13s │%13s │%6s │" \
 	"$type" "$outer" "$inner" "$tos" "$ttl" "$vlan"
 
-	# Create 'testing' netns, veth pair and connect main ns with testing ns
-	ip netns add testing
-	ip link add type veth
-	ip link set veth1 netns testing
-	ip link set veth0 up
-	$ns ip link set veth1 up
-	ip addr flush dev veth0
-	$ns ip addr flush dev veth1
+	# Create netns NS0 and NS1 and connect them with a veth pair
+	ip netns add "${NS0}"
+	ip netns add "${NS1}"
+	ip link add name veth0 netns "${NS0}" type veth \
+		peer name veth1 netns "${NS1}"
+	ip -netns "${NS0}" link set dev veth0 up
+	ip -netns "${NS1}" link set dev veth1 up
+	ip -netns "${NS0}" address flush dev veth0
+	ip -netns "${NS1}" address flush dev veth1
 
 	local local_addr1=""
 	local local_addr2=""
@@ -127,51 +132,59 @@ setup() {
 		if [ "$type" = "gre" ]; then
 			type="gretap"
 		fi
-		ip addr add 198.18.0.1/24 dev veth0
-		$ns ip addr add 198.18.0.2/24 dev veth1
-		ip link add name tep0 type $type $local_addr1 remote \
-		198.18.0.2 tos $test_tos ttl $test_ttl $vxlan $geneve
-		$ns ip link add name tep1 type $type $local_addr2 remote \
-		198.18.0.1 tos $test_tos ttl $test_ttl $vxlan $geneve
+		ip -netns "${NS0}" address add 198.18.0.1/24 dev veth0
+		ip -netns "${NS1}" address add 198.18.0.2/24 dev veth1
+		ip -netns "${NS0}" link add name tep0 type $type $local_addr1 \
+			remote 198.18.0.2 tos $test_tos ttl $test_ttl         \
+			$vxlan $geneve
+		ip -netns "${NS1}" link add name tep1 type $type $local_addr2 \
+			remote 198.18.0.1 tos $test_tos ttl $test_ttl         \
+			$vxlan $geneve
 	elif [ "$outer" = "6" ]; then
 		if [ "$type" = "gre" ]; then
 			type="ip6gretap"
 		fi
-		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0 nodad
-		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1 nodad
-		ip link add name tep0 type $type $local_addr1 \
-		remote fdd1:ced0:5d88:3fce::2 tos $test_tos ttl $test_ttl \
-		$vxlan $geneve
-		$ns ip link add name tep1 type $type $local_addr2 \
-		remote fdd1:ced0:5d88:3fce::1 tos $test_tos ttl $test_ttl \
-		$vxlan $geneve
+		ip -netns "${NS0}" address add fdd1:ced0:5d88:3fce::1/64 \
+			dev veth0 nodad
+		ip -netns "${NS1}" address add fdd1:ced0:5d88:3fce::2/64 \
+			dev veth1 nodad
+		ip -netns "${NS0}" link add name tep0 type $type $local_addr1 \
+			remote fdd1:ced0:5d88:3fce::2 tos $test_tos           \
+			ttl $test_ttl $vxlan $geneve
+		ip -netns "${NS1}" link add name tep1 type $type $local_addr2 \
+			remote fdd1:ced0:5d88:3fce::1 tos $test_tos           \
+			ttl $test_ttl $vxlan $geneve
 	fi
 
 	# Bring L2-tunnel link up and create VLAN on top
-	ip link set tep0 up
-	$ns ip link set tep1 up
-	ip addr flush dev tep0
-	$ns ip addr flush dev tep1
+	ip -netns "${NS0}" link set tep0 up
+	ip -netns "${NS1}" link set tep1 up
+	ip -netns "${NS0}" address flush dev tep0
+	ip -netns "${NS1}" address flush dev tep1
 	local parent
 	if $vlan; then
 		parent="vlan99-"
-		ip link add link tep0 name ${parent}0 type vlan id 99
-		$ns ip link add link tep1 name ${parent}1 type vlan id 99
-		ip link set ${parent}0 up
-		$ns ip link set ${parent}1 up
-		ip addr flush dev ${parent}0
-		$ns ip addr flush dev ${parent}1
+		ip -netns "${NS0}" link add link tep0 name ${parent}0 \
+			type vlan id 99
+		ip -netns "${NS1}" link add link tep1 name ${parent}1 \
+			type vlan id 99
+		ip -netns "${NS0}" link set dev ${parent}0 up
+		ip -netns "${NS1}" link set dev ${parent}1 up
+		ip -netns "${NS0}" address flush dev ${parent}0
+		ip -netns "${NS1}" address flush dev ${parent}1
 	else
 		parent="tep"
 	fi
 
 	# Assign inner IPv4/IPv6 addresses
 	if [ "$inner" = "4" ] || [ "$inner" = "other" ]; then
-		ip addr add 198.19.0.1/24 brd + dev ${parent}0
-		$ns ip addr add 198.19.0.2/24 brd + dev ${parent}1
+		ip -netns "${NS0}" address add 198.19.0.1/24 brd + dev ${parent}0
+		ip -netns "${NS1}" address add 198.19.0.2/24 brd + dev ${parent}1
 	elif [ "$inner" = "6" ]; then
-		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0 nodad
-		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1 nodad
+		ip -netns "${NS0}" address add fdd4:96cf:4eae:443b::1/64 \
+			dev ${parent}0 nodad
+		ip -netns "${NS1}" address add fdd4:96cf:4eae:443b::2/64 \
+			dev ${parent}1 nodad
 	fi
 }
 
@@ -192,10 +205,10 @@ verify() {
 		ping_dst="198.19.0.3" # Generates ARPs which are not IPv4/IPv6
 	fi
 	if [ "$tos_ttl" = "inherit" ]; then
-		ping -i 0.1 $ping_dst -Q "$expected_tos" -t "$expected_ttl" \
-		2>/dev/null 1>&2 & ping_pid="$!"
+		${RUN_NS0} ping -i 0.1 $ping_dst -Q "$expected_tos"          \
+			 -t "$expected_ttl" 2>/dev/null 1>&2 & ping_pid="$!"
 	else
-		ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
+		${RUN_NS0} ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
 	fi
 	local tunnel_type_offset tunnel_type_proto req_proto_offset req_offset
 	if [ "$type" = "gre" ]; then
@@ -216,10 +229,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip[$req_proto_offset] = 0x01 and \
-			ip[$req_offset] = 0x08 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip[$req_proto_offset] = 0x01 and              \
+				ip[$req_offset] = 0x08 2>/dev/null            \
+				| head -n 1)"
 		elif [ "$inner" = "6" ]; then
 			req_proto_offset="44"
 			req_offset="78"
@@ -231,10 +246,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip[$req_proto_offset] = 0x3a and \
-			ip[$req_offset] = 0x80 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip[$req_proto_offset] = 0x3a and              \
+				ip[$req_offset] = 0x80 2>/dev/null            \
+				| head -n 1)"
 		elif [ "$inner" = "other" ]; then
 			req_proto_offset="36"
 			req_offset="45"
@@ -250,11 +267,13 @@ verify() {
 				expected_tos="0x00"
 				expected_ttl="64"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip[$req_proto_offset] = 0x08 and \
-			ip[$((req_proto_offset + 1))] = 0x06 and \
-			ip[$req_offset] = 0x01 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip[$req_proto_offset] = 0x08 and              \
+				ip[$((req_proto_offset + 1))] = 0x06 and      \
+				ip[$req_offset] = 0x01 2>/dev/null            \
+				| head -n 1)"
 		fi
 	elif [ "$outer" = "6" ]; then
 		if [ "$type" = "gre" ]; then
@@ -273,10 +292,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip6[$req_proto_offset] = 0x01 and \
-			ip6[$req_offset] = 0x08 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip6[$req_proto_offset] = 0x01 and             \
+				ip6[$req_offset] = 0x08 2>/dev/null           \
+				| head -n 1)"
 		elif [ "$inner" = "6" ]; then
 			local req_proto_offset="72"
 			local req_offset="106"
@@ -288,10 +309,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip6[$req_proto_offset] = 0x3a and \
-			ip6[$req_offset] = 0x80 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip6[$req_proto_offset] = 0x3a and             \
+				ip6[$req_offset] = 0x80 2>/dev/null           \
+				| head -n 1)"
 		elif [ "$inner" = "other" ]; then
 			local req_proto_offset="64"
 			local req_offset="73"
@@ -307,11 +330,13 @@ verify() {
 				expected_tos="0x00"
 				expected_ttl="64"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip6[$req_proto_offset] = 0x08 and \
-			ip6[$((req_proto_offset + 1))] = 0x06 and \
-			ip6[$req_offset] = 0x01 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip6[$req_proto_offset] = 0x08 and             \
+				ip6[$((req_proto_offset + 1))] = 0x06 and     \
+				ip6[$req_offset] = 0x01 2>/dev/null           \
+				| head -n 1)"
 		fi
 	fi
 	kill -9 $ping_pid
@@ -351,9 +376,8 @@ verify() {
 }
 
 cleanup() {
-	ip link del veth0 2>/dev/null
-	ip netns del testing 2>/dev/null
-	ip link del tep0 2>/dev/null
+	ip netns del "${NS0}" 2>/dev/null
+	ip netns del "${NS1}" 2>/dev/null
 }
 
 printf "┌────────┬───────┬───────┬──────────────┬"
-- 
2.35.1



