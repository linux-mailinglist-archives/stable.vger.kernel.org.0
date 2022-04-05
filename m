Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988754F31B4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiDEJes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245712AbiDEI4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E8A1A3A6;
        Tue,  5 Apr 2022 01:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B31AB81B92;
        Tue,  5 Apr 2022 08:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D30FC385A1;
        Tue,  5 Apr 2022 08:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148757;
        bh=zm6JjuvnyZuylzaFd5qdpfTbBniT0d81g3XjdXWjT/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFdivL3KqFWaCMN0+RTO+Pu65/Xrbr85V580wR1HXFG4eJOAB/kxfrDE/AVkUnVp2
         zxSOsNROQK/93vOjG1Asa1nYBSQ9cnlJYN2ZPH+lw3FrFFB6FXN2XZbP/fDmD5c+qf
         erpOQrksN4ddRcMjmFRWxZp97sYth3uNIP9Yujn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0432/1017] selftests/bpf/test_xdp_redirect_multi: use temp netns for testing
Date:   Tue,  5 Apr 2022 09:22:25 +0200
Message-Id: <20220405070407.118131248@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit cec74489a8dee93053340ec88ea938ff4008c3c0 ]

Use temp netns instead of hard code name for testing in case the netns
already exists.

Remove the hard code interface index when creating the veth interfaces.
Because when the system loads some virtual interface modules, e.g. tunnels.
the ifindex of 2 will be used and the cmd will fail.

As the netns has not created if checking environment failed. Trap the
clean up function after checking env.

Fixes: 8955c1a32987 ("selftests/bpf/xdp_redirect_multi: Limit the tests in netns")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
Link: https://lore.kernel.org/r/20220125081717.1260849-2-liuhangbin@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 60 ++++++++++---------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index 05f872740999..cc57cb87e65f 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -32,6 +32,11 @@ DRV_MODE="xdpgeneric xdpdrv xdpegress"
 PASS=0
 FAIL=0
 LOG_DIR=$(mktemp -d)
+declare -a NS
+NS[0]="ns0-$(mktemp -u XXXXXX)"
+NS[1]="ns1-$(mktemp -u XXXXXX)"
+NS[2]="ns2-$(mktemp -u XXXXXX)"
+NS[3]="ns3-$(mktemp -u XXXXXX)"
 
 test_pass()
 {
@@ -47,11 +52,9 @@ test_fail()
 
 clean_up()
 {
-	for i in $(seq $NUM); do
-		ip link del veth$i 2> /dev/null
-		ip netns del ns$i 2> /dev/null
+	for i in $(seq 0 $NUM); do
+		ip netns del ${NS[$i]} 2> /dev/null
 	done
-	ip netns del ns0 2> /dev/null
 }
 
 # Kselftest framework requirement - SKIP code is 4.
@@ -79,23 +82,22 @@ setup_ns()
 		mode="xdpdrv"
 	fi
 
-	ip netns add ns0
+	ip netns add ${NS[0]}
 	for i in $(seq $NUM); do
-	        ip netns add ns$i
-		ip -n ns$i link add veth0 index 2 type veth \
-			peer name veth$i netns ns0 index $((1 + $i))
-		ip -n ns0 link set veth$i up
-		ip -n ns$i link set veth0 up
-
-		ip -n ns$i addr add 192.0.2.$i/24 dev veth0
-		ip -n ns$i addr add 2001:db8::$i/64 dev veth0
+	        ip netns add ${NS[$i]}
+		ip -n ${NS[$i]} link add veth0 type veth peer name veth$i netns ${NS[0]}
+		ip -n ${NS[$i]} link set veth0 up
+		ip -n ${NS[0]} link set veth$i up
+
+		ip -n ${NS[$i]} addr add 192.0.2.$i/24 dev veth0
+		ip -n ${NS[$i]} addr add 2001:db8::$i/64 dev veth0
 		# Add a neigh entry for IPv4 ping test
-		ip -n ns$i neigh add 192.0.2.253 lladdr 00:00:00:00:00:01 dev veth0
-		ip -n ns$i link set veth0 $mode obj \
+		ip -n ${NS[$i]} neigh add 192.0.2.253 lladdr 00:00:00:00:00:01 dev veth0
+		ip -n ${NS[$i]} link set veth0 $mode obj \
 			xdp_dummy.o sec xdp &> /dev/null || \
 			{ test_fail "Unable to load dummy xdp" && exit 1; }
 		IFACES="$IFACES veth$i"
-		veth_mac[$i]=$(ip -n ns0 link show veth$i | awk '/link\/ether/ {print $2}')
+		veth_mac[$i]=$(ip -n ${NS[0]} link show veth$i | awk '/link\/ether/ {print $2}')
 	done
 }
 
@@ -104,10 +106,10 @@ do_egress_tests()
 	local mode=$1
 
 	# mac test
-	ip netns exec ns2 tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-2_${mode}.log &
-	ip netns exec ns3 tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-3_${mode}.log &
+	ip netns exec ${NS[2]} tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-2_${mode}.log &
+	ip netns exec ${NS[3]} tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-3_${mode}.log &
 	sleep 0.5
-	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
+	ip netns exec ${NS[1]} ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
 	sleep 0.5
 	pkill tcpdump
 
@@ -123,18 +125,18 @@ do_ping_tests()
 	local mode=$1
 
 	# ping6 test: echo request should be redirect back to itself, not others
-	ip netns exec ns1 ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
+	ip netns exec ${NS[1]} ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
 
-	ip netns exec ns1 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-1_${mode}.log &
-	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-2_${mode}.log &
-	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
+	ip netns exec ${NS[1]} tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-1_${mode}.log &
+	ip netns exec ${NS[2]} tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-2_${mode}.log &
+	ip netns exec ${NS[3]} tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
 	sleep 0.5
 	# ARP test
-	ip netns exec ns1 arping -q -c 2 -I veth0 192.0.2.254
+	ip netns exec ${NS[1]} arping -q -c 2 -I veth0 192.0.2.254
 	# IPv4 test
-	ip netns exec ns1 ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
+	ip netns exec ${NS[1]} ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
 	# IPv6 test
-	ip netns exec ns1 ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
+	ip netns exec ${NS[1]} ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
 	sleep 0.5
 	pkill tcpdump
 
@@ -180,7 +182,7 @@ do_tests()
 		xdpgeneric) drv_p="-S";;
 	esac
 
-	ip netns exec ns0 ./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
+	ip netns exec ${NS[0]} ./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
 	xdp_pid=$!
 	sleep 1
 	if ! ps -p $xdp_pid > /dev/null; then
@@ -197,10 +199,10 @@ do_tests()
 	kill $xdp_pid
 }
 
-trap clean_up EXIT
-
 check_env
 
+trap clean_up EXIT
+
 for mode in ${DRV_MODE}; do
 	setup_ns $mode
 	do_tests $mode
-- 
2.34.1



