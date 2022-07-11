Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF0956FE23
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbiGKKEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiGKKDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B650748EB7;
        Mon, 11 Jul 2022 02:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5355F6141D;
        Mon, 11 Jul 2022 09:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C607C34115;
        Mon, 11 Jul 2022 09:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531781;
        bh=RfUoO/kK49NxXAgZqG2VhQS9b0PB98R1OjGwGJyKmy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Du0LzbZ4k/N5rbFGyLMfgQgDiubnTOBYh450011xeUtAHvrUHzGrt51VUOiGtgmq
         U5h+2tObRQ8/H9RFvFD+zVWxjeWFV5cX0dDg3XEicrRi8U3DMLKsAek3MsFgl2ZbuB
         xYySAoJ2YSLEeK1Sm3e9w8SI975JZL7TK5HUjZHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 230/230] selftests/net: fix section name when using xdp_dummy.o
Date:   Mon, 11 Jul 2022 11:08:06 +0200
Message-Id: <20220711090610.625380037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit d28b25a62a47a8c8aa19bd543863aab6717e68c9 upstream.

Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
selftests") the xdp_dummy.o's section name has changed to xdp. But some
tests are still using "section xdp_dummy", which make the tests failed.
Fix them by updating to the new section name.

Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20220630062228.3453016-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/udpgro.sh       |    2 +-
 tools/testing/selftests/net/udpgro_bench.sh |    2 +-
 tools/testing/selftests/net/udpgro_fwd.sh   |    2 +-
 tools/testing/selftests/net/veth.sh         |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

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
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -34,7 +34,7 @@ run_one() {
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
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


