Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595C2566BDC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiGEMKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbiGEMIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCBA6431;
        Tue,  5 Jul 2022 05:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E8636195F;
        Tue,  5 Jul 2022 12:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713B1C341C7;
        Tue,  5 Jul 2022 12:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022904;
        bh=tQhRaHEIDOzQ7cCV0dKMnj9VcdSCYGIE3vFJ+h7oO9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTqfaRt2+LzmHLMcRJeqPspxoZfXIZtelebAinb+tIprn6h3iS4dXrA9UhLK7PsWr
         PeyBfb4qZOqOfSgw6TNuxXdMEbkYoQQ8+zMLXkQrZp6JHf2Hca1uRnzCLvashEgZ34
         /GR3SqAYcsEoMyGXZhA/xm+AY363Bqtyr9EMKTRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/84] selftests: mptcp: add link failure test case
Date:   Tue,  5 Jul 2022 13:58:15 +0200
Message-Id: <20220705115616.843257768@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8b819a84d4b12c4a91cc9f91ad69ca09c3e0606d ]

Add a test case where a link fails with multiple subflows.
The expectation is that MPTCP will transmit any data that
could not be delivered via the failed link on another subflow.

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 104 ++++++++++++++----
 1 file changed, 82 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0d93b243695f..f841ed8186c1 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -5,6 +5,7 @@ ret=0
 sin=""
 sout=""
 cin=""
+cinsent=""
 cout=""
 ksft_skip=4
 timeout=30
@@ -81,7 +82,7 @@ cleanup_partial()
 cleanup()
 {
 	rm -f "$cin" "$cout"
-	rm -f "$sin" "$sout"
+	rm -f "$sin" "$sout" "$cinsent"
 	cleanup_partial
 }
 
@@ -144,6 +145,13 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
+print_file_err()
+{
+	ls -l "$1" 1>&2
+	echo "Trailing bytes are: "
+	tail -c 27 "$1"
+}
+
 check_transfer()
 {
 	in=$1
@@ -155,6 +163,7 @@ check_transfer()
 		echo "[ FAIL ] $what does not match (in, out):"
 		print_file_err "$in"
 		print_file_err "$out"
+		ret=1
 
 		return 1
 	fi
@@ -175,6 +184,17 @@ do_ping()
 	fi
 }
 
+link_failure()
+{
+	ns="$1"
+
+	l=$((RANDOM%4))
+	l=$((l+1))
+
+	veth="ns1eth$l"
+	ip -net "$ns" link set "$veth" down
+}
+
 do_transfer()
 {
 	listener_ns="$1"
@@ -182,9 +202,10 @@ do_transfer()
 	cl_proto="$3"
 	srv_proto="$4"
 	connect_addr="$5"
-	rm_nr_ns1="$6"
-	rm_nr_ns2="$7"
-	speed="$8"
+	test_link_fail="$6"
+	rm_nr_ns1="$7"
+	rm_nr_ns2="$8"
+	speed="$9"
 
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
@@ -220,7 +241,12 @@ do_transfer()
 
 	sleep 1
 
-	ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
+	if [ "$test_link_fail" -eq 0 ];then
+		ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
+	else
+		( cat "$cin" ; sleep 2; link_failure $listener_ns ; cat "$cin" ) | tee "$cinsent" | \
+		ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr > "$cout" &
+	fi
 	cpid=$!
 
 	if [ $rm_nr_ns1 -gt 0 ]; then
@@ -265,12 +291,17 @@ do_transfer()
 		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
 
 		cat "$capout"
+		ret=1
 		return 1
 	fi
 
 	check_transfer $sin $cout "file received by client"
 	retc=$?
-	check_transfer $cin $sout "file received by server"
+	if [ "$test_link_fail" -eq 0 ];then
+		check_transfer $cin $sout "file received by server"
+	else
+		check_transfer $cinsent $sout "file received by server"
+	fi
 	rets=$?
 
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
@@ -286,13 +317,12 @@ make_file()
 {
 	name=$1
 	who=$2
+	size=$3
 
-	SIZE=1
-
-	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+	dd if=/dev/urandom of="$name" bs=1024 count=$size 2> /dev/null
 	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
 
-	echo "Created $name (size $SIZE KB) containing data sent by $who"
+	echo "Created $name (size $size KB) containing data sent by $who"
 }
 
 run_tests()
@@ -300,14 +330,32 @@ run_tests()
 	listener_ns="$1"
 	connector_ns="$2"
 	connect_addr="$3"
-	rm_nr_ns1="${4:-0}"
-	rm_nr_ns2="${5:-0}"
-	speed="${6:-fast}"
+	test_linkfail="${4:-0}"
+	rm_nr_ns1="${5:-0}"
+	rm_nr_ns2="${6:-0}"
+	speed="${7:-fast}"
 	lret=0
+	oldin=""
+
+	if [ "$test_linkfail" -eq 1 ];then
+		size=$((RANDOM%1024))
+		size=$((size+1))
+		size=$((size*128))
+
+		oldin=$(mktemp)
+		cp "$cin" "$oldin"
+		make_file "$cin" "client" $size
+	fi
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
-		${rm_nr_ns1} ${rm_nr_ns2} ${speed}
+		${test_linkfail} ${rm_nr_ns1} ${rm_nr_ns2} ${speed}
 	lret=$?
+
+	if [ "$test_linkfail" -eq 1 ];then
+		cp "$oldin" "$cin"
+		rm -f "$oldin"
+	fi
+
 	if [ $lret -ne 0 ]; then
 		ret=$lret
 		return
@@ -440,10 +488,11 @@ chk_rm_nr()
 sin=$(mktemp)
 sout=$(mktemp)
 cin=$(mktemp)
+cinsent=$(mktemp)
 cout=$(mktemp)
 init
-make_file "$cin" "client"
-make_file "$sin" "server"
+make_file "$cin" "client" 1
+make_file "$sin" "server" 1
 trap cleanup EXIT
 
 run_tests $ns1 $ns2 10.0.1.1
@@ -528,12 +577,23 @@ run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "multiple subflows and signal" 3 3 3
 chk_add_nr 1 1
 
+# accept and use add_addr with additional subflows and link loss
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1 1
+chk_join_nr "multiple flows, signal, link failure" 3 3 3
+chk_add_nr 1 1
+
 # add_addr timeout
 reset_with_add_addr_timeout
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl limits 1 1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-run_tests $ns1 $ns2 10.0.1.1 0 0 slow
+run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
 chk_add_nr 4 0
 
@@ -542,7 +602,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 1 slow
+run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
 chk_join_nr "remove single subflow" 1 1 1
 chk_rm_nr 1 1
 
@@ -552,7 +612,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns2 ./pm_nl_ctl limits 0 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 2 slow
+run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
 chk_join_nr "remove multiple subflows" 2 2 2
 chk_rm_nr 2 2
 
@@ -561,7 +621,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 10.0.1.1 1 0 slow
+run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
 chk_join_nr "remove single address" 1 1 1
 chk_add_nr 1 1
 chk_rm_nr 0 0
@@ -572,7 +632,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 1 1 slow
+run_tests $ns1 $ns2 10.0.1.1 0 1 1 slow
 chk_join_nr "remove subflow and signal" 2 2 2
 chk_add_nr 1 1
 chk_rm_nr 1 1
@@ -584,7 +644,7 @@ ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 3
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 1 2 slow
+run_tests $ns1 $ns2 10.0.1.1 0 1 2 slow
 chk_join_nr "remove subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
-- 
2.35.1



