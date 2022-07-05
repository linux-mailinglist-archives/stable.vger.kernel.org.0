Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC3566BD8
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiGEMKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbiGEMIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CAE10AF;
        Tue,  5 Jul 2022 05:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40A01B817D2;
        Tue,  5 Jul 2022 12:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A256BC341C7;
        Tue,  5 Jul 2022 12:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022902;
        bh=BeZeInl2iFvJGNFLXV69eOTfrCOZqJMpzSiDqs4gYSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQRpNcF/6v2fEiqa6f6ZBAuYxcl5fooWXjIWzmYBXf9kNZ2K5+mzEW7O/48ySOaRc
         n9jDBsROzJfBRGZtn6a2DSDuxS9e3lBp5j+zdkSekyshDr6klp6t0ycEZm9rpHhVvZ
         wfjhhLxAvGRe8Zs756xcVPRCMrHX1dlF4J+b5gb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/84] selftests: mptcp: add ADD_ADDR timeout test case
Date:   Tue,  5 Jul 2022 13:58:14 +0200
Message-Id: <20220705115616.814163273@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit 8d014eaa9254a9b8e0841df40dd36782b451579a ]

This patch added the test case for retransmitting ADD_ADDR when timeout
occurs. It set NS1's add_addr_timeout to 1 second, and drop NS2's ADD_ADDR
echo packets.

Here we need to slow down the transfer process of all data to let the
ADD_ADDR suboptions can be retransmitted three times. So we added a new
parameter "speed" for do_transfer, it can be set with fast or slow.

We also added three new optional parameters for run_tests, and dropped
run_remove_tests function.

Since we added the netfilter rules in this test case, we need to update
the "config" file.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/config      | 10 ++
 .../testing/selftests/net/mptcp/mptcp_join.sh | 94 ++++++++++++++-----
 2 files changed, 80 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 741a1c4f4ae8..0faaccd21447 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -5,3 +5,13 @@ CONFIG_INET_DIAG=m
 CONFIG_INET_MPTCP_DIAG=m
 CONFIG_VETH=y
 CONFIG_NET_SCH_NETEM=m
+CONFIG_NETFILTER=y
+CONFIG_NETFILTER_ADVANCED=y
+CONFIG_NETFILTER_NETLINK=m
+CONFIG_NF_TABLES=m
+CONFIG_NFT_COUNTER=m
+CONFIG_NFT_COMPAT=m
+CONFIG_NETFILTER_XTABLES=m
+CONFIG_NETFILTER_XT_MATCH_BPF=m
+CONFIG_NF_TABLES_IPV4=y
+CONFIG_NF_TABLES_IPV6=y
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 08f53d86dedc..0d93b243695f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -13,6 +13,24 @@ capture=0
 
 TEST_COUNT=0
 
+# generated using "nfbpf_compile '(ip && (ip[54] & 0xf0) == 0x30) ||
+#				  (ip6 && (ip6[74] & 0xf0) == 0x30)'"
+CBPF_MPTCP_SUBOPTION_ADD_ADDR="14,
+			       48 0 0 0,
+			       84 0 0 240,
+			       21 0 3 64,
+			       48 0 0 54,
+			       84 0 0 240,
+			       21 6 7 48,
+			       48 0 0 0,
+			       84 0 0 240,
+			       21 0 4 96,
+			       48 0 0 74,
+			       84 0 0 240,
+			       21 0 1 48,
+			       6 0 0 65535,
+			       6 0 0 0"
+
 init()
 {
 	capout=$(mktemp)
@@ -82,6 +100,26 @@ reset_with_cookies()
 	done
 }
 
+reset_with_add_addr_timeout()
+{
+	local ip="${1:-4}"
+	local tables
+
+	tables="iptables"
+	if [ $ip -eq 6 ]; then
+		tables="ip6tables"
+	fi
+
+	reset
+
+	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
+	ip netns exec $ns2 $tables -A OUTPUT -p tcp \
+		-m tcp --tcp-option 30 \
+		-m bpf --bytecode \
+		"$CBPF_MPTCP_SUBOPTION_ADD_ADDR" \
+		-j DROP
+}
+
 for arg in "$@"; do
 	if [ "$arg" = "-c" ]; then
 		capture=1
@@ -94,6 +132,17 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
+iptables -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run all tests without iptables tool"
+	exit $ksft_skip
+fi
+
+ip6tables -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run all tests without ip6tables tool"
+	exit $ksft_skip
+fi
 
 check_transfer()
 {
@@ -135,6 +184,7 @@ do_transfer()
 	connect_addr="$5"
 	rm_nr_ns1="$6"
 	rm_nr_ns2="$7"
+	speed="$8"
 
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
@@ -159,7 +209,7 @@ do_transfer()
 		sleep 1
 	fi
 
-	if [[ $rm_nr_ns1 -eq 0 && $rm_nr_ns2 -eq 0 ]]; then
+	if [ $speed = "fast" ]; then
 		mptcp_connect="./mptcp_connect -j"
 	else
 		mptcp_connect="./mptcp_connect -r"
@@ -250,26 +300,13 @@ run_tests()
 	listener_ns="$1"
 	connector_ns="$2"
 	connect_addr="$3"
+	rm_nr_ns1="${4:-0}"
+	rm_nr_ns2="${5:-0}"
+	speed="${6:-fast}"
 	lret=0
 
-	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} 0 0
-	lret=$?
-	if [ $lret -ne 0 ]; then
-		ret=$lret
-		return
-	fi
-}
-
-run_remove_tests()
-{
-	listener_ns="$1"
-	connector_ns="$2"
-	connect_addr="$3"
-	rm_nr_ns1="$4"
-	rm_nr_ns2="$5"
-	lret=0
-
-	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} ${rm_nr_ns1} ${rm_nr_ns2}
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
+		${rm_nr_ns1} ${rm_nr_ns2} ${speed}
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
@@ -491,12 +528,21 @@ run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "multiple subflows and signal" 3 3 3
 chk_add_nr 1 1
 
+# add_addr timeout
+reset_with_add_addr_timeout
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+run_tests $ns1 $ns2 10.0.1.1 0 0 slow
+chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
+chk_add_nr 4 0
+
 # single subflow, remove
 reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_remove_tests $ns1 $ns2 10.0.1.1 0 1
+run_tests $ns1 $ns2 10.0.1.1 0 1 slow
 chk_join_nr "remove single subflow" 1 1 1
 chk_rm_nr 1 1
 
@@ -506,7 +552,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns2 ./pm_nl_ctl limits 0 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_remove_tests $ns1 $ns2 10.0.1.1 0 2
+run_tests $ns1 $ns2 10.0.1.1 0 2 slow
 chk_join_nr "remove multiple subflows" 2 2 2
 chk_rm_nr 2 2
 
@@ -515,7 +561,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_remove_tests $ns1 $ns2 10.0.1.1 1 0
+run_tests $ns1 $ns2 10.0.1.1 1 0 slow
 chk_join_nr "remove single address" 1 1 1
 chk_add_nr 1 1
 chk_rm_nr 0 0
@@ -526,7 +572,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_remove_tests $ns1 $ns2 10.0.1.1 1 1
+run_tests $ns1 $ns2 10.0.1.1 1 1 slow
 chk_join_nr "remove subflow and signal" 2 2 2
 chk_add_nr 1 1
 chk_rm_nr 1 1
@@ -538,7 +584,7 @@ ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 3
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_remove_tests $ns1 $ns2 10.0.1.1 1 2
+run_tests $ns1 $ns2 10.0.1.1 1 2 slow
 chk_join_nr "remove subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
-- 
2.35.1



