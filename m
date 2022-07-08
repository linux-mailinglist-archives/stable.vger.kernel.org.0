Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00C56B869
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiGHLZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbiGHLZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:25:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F88737B
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1D6624BF
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F985C341C0;
        Fri,  8 Jul 2022 11:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657279519;
        bh=ucT1MsZpdKPbY/MVHrQtMAY0KCjDN9TLQWuI5DVuUsc=;
        h=Subject:To:Cc:From:Date:From;
        b=RqI0gEtMJ303viOj6WvUglANzfsmYp801fZbrU6nNCPtEZOghk7OIvPHO+oweTUcS
         buel+5fi0qlBkg+ufZS0pdfitScsV2D+bbTI/qOeBYMs7QvxO/rESOYzkkrRibd1An
         YcIjhoORAkXlcqDbD8khNl2NdGN/jbpi8fOcUUFM=
Subject: FAILED: patch "[PATCH] selftests/net: fix section name when using xdp_dummy.o" failed to apply to 5.15-stable tree
To:     liuhangbin@gmail.com, andrii@kernel.org, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:25:16 +0200
Message-ID: <165727951618112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d28b25a62a47a8c8aa19bd543863aab6717e68c9 Mon Sep 17 00:00:00 2001
From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu, 30 Jun 2022 14:22:28 +0800
Subject: [PATCH] selftests/net: fix section name when using xdp_dummy.o

Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
selftests") the xdp_dummy.o's section name has changed to xdp. But some
tests are still using "section xdp_dummy", which make the tests failed.
Fix them by updating to the new section name.

Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20220630062228.3453016-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index f8a19f548ae9..ebbd0b282432 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -34,7 +34,7 @@ cfg_veth() {
 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 }
 
 run_one() {
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index 820bc50f6b68..fad2d1a71cac 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -34,7 +34,7 @@ run_one() {
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 807b74c8fd80..832c738cc3c2 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -36,7 +36,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
 
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
 	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
 	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6f05e06f6761..1bcd82e1f662 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -46,7 +46,7 @@ create_ns() {
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
 	done
-	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 }
 
 create_vxlan_endpoint() {
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 19eac3e44c06..430895d1a2b6 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -289,14 +289,14 @@ if [ $CPUS -gt 1 ]; then
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
 	printf "%-60s" "bad setting: XDP with RX nr less than TX"
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null &&\
+		section xdp 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
 
 	# the following tests will run with multiple channels active
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
 	ip netns exec $NS_DST ethtool -L veth$DST rx 2
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null
+		section xdp 2>/dev/null
 	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
 	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
@@ -311,7 +311,7 @@ if [ $CPUS -gt 2 ]; then
 	chk_channels "setting invalid channels nr" $DST 2 2
 fi
 
-ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC off

