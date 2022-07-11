Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87989566BF6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiGEMKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiGEMIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A48419017;
        Tue,  5 Jul 2022 05:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11C4A6185C;
        Tue,  5 Jul 2022 12:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13653C341C7;
        Tue,  5 Jul 2022 12:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022910;
        bh=WJ97NuEKUSfk3P4idjQ/uIkIU6er6VMKWyWewT9PDo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cocUtVdqRi46U2uqI/Cf+AcYlwgt6tvP4X4m18F1ZijhJNeZmfsUMn8np9nI+FO+X
         nshoPDw0QcKL74KpJEIVq1n0MGWh+6qgRHUUbuGVonDd8oVHf3jIvduruZ8rJWJ+lU
         Rh7H/rw0uKkDfe+u8FCWw88FhMogfm7c0a1TnwZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/84] selftests: mptcp: launch mptcp_connect with timeout
Date:   Tue,  5 Jul 2022 13:58:17 +0200
Message-Id: <20220705115616.901174488@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 5888a61cb4e00695075bbacfd86f3fa73af00413 ]

'mptcp_connect' already has a timeout for poll() but in some cases, it
is not enough.

With "timeout" tool, we will force the command to fail if it doesn't
finish on time. Thanks to that, the script will continue and display
details about the current state before marking the test as failed.
Displaying this state is very important to be able to understand the
issue. Best to have our CI reporting the issue than just "the test
hanged".

Note that in mptcp_connect.sh, we were using a long timeout to validate
the fact we cannot create a socket if a sysctl is set. We don't need
this timeout.

In diag.sh, we want to send signals to mptcp_connect instances that have
been started in the netns. But we cannot send this signal to 'timeout'
otherwise that will stop the timeout and messages telling us SIGUSR1 has
been received will be printed. Instead of trying to find the right PID
and storing them in an array, we can simply use the output of
'ip netns pids' which is all the PIDs we want to send signal to.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/160
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/diag.sh     | 55 ++++++++++++-------
 .../selftests/net/mptcp/mptcp_connect.sh      | 15 +++--
 .../testing/selftests/net/mptcp/mptcp_join.sh | 22 ++++++--
 .../selftests/net/mptcp/simult_flows.sh       | 13 ++++-
 4 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index 39edce4f541c..2674ba20d524 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -5,8 +5,9 @@ rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
 ns="ns1-$rndh"
 ksft_skip=4
 test_cnt=1
+timeout_poll=100
+timeout_test=$((timeout_poll * 2 + 1))
 ret=0
-pids=()
 
 flush_pids()
 {
@@ -14,18 +15,14 @@ flush_pids()
 	# give it some time
 	sleep 1.1
 
-	for pid in ${pids[@]}; do
-		[ -d /proc/$pid ] && kill -SIGUSR1 $pid >/dev/null 2>&1
-	done
-	pids=()
+	ip netns pids "${ns}" | xargs --no-run-if-empty kill -SIGUSR1 &>/dev/null
 }
 
 cleanup()
 {
+	ip netns pids "${ns}" | xargs --no-run-if-empty kill -SIGKILL &>/dev/null
+
 	ip netns del $ns
-	for pid in ${pids[@]}; do
-		[ -d /proc/$pid ] && kill -9 $pid >/dev/null 2>&1
-	done
 }
 
 ip -Version > /dev/null 2>&1
@@ -79,39 +76,57 @@ trap cleanup EXIT
 ip netns add $ns
 ip -n $ns link set dev lo up
 
-echo "a" | ip netns exec $ns ./mptcp_connect -p 10000 -l 0.0.0.0 -t 100 >/dev/null &
+echo "a" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
+				0.0.0.0 >/dev/null &
 sleep 0.1
-pids[0]=$!
 chk_msk_nr 0 "no msk on netns creation"
 
-echo "b" | ip netns exec $ns ./mptcp_connect -p 10000 127.0.0.1 -j -t 100 >/dev/null &
+echo "b" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10000 -j -t ${timeout_poll} \
+				127.0.0.1 >/dev/null &
 sleep 0.1
-pids[1]=$!
 chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
 flush_pids
 
 
-echo "a" | ip netns exec $ns ./mptcp_connect -p 10001 -s TCP -l 0.0.0.0 -t 100 >/dev/null &
-pids[0]=$!
+echo "a" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} \
+				0.0.0.0 >/dev/null &
 sleep 0.1
-echo "b" | ip netns exec $ns ./mptcp_connect -p 10001 127.0.0.1 -j -t 100 >/dev/null &
-pids[1]=$!
+echo "b" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10001 -j -t ${timeout_poll} \
+				127.0.0.1 >/dev/null &
 sleep 0.1
 chk_msk_fallback_nr 1 "check fallback"
 flush_pids
 
 NR_CLIENTS=100
 for I in `seq 1 $NR_CLIENTS`; do
-	echo "a" | ip netns exec $ns ./mptcp_connect -p $((I+10001)) -l 0.0.0.0 -t 100 -w 10 >/dev/null  &
-	pids[$((I*2))]=$!
+	echo "a" | \
+		timeout ${timeout_test} \
+			ip netns exec $ns \
+				./mptcp_connect -p $((I+10001)) -l -w 10 \
+					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
 sleep 0.1
 
 for I in `seq 1 $NR_CLIENTS`; do
-	echo "b" | ip netns exec $ns ./mptcp_connect -p $((I+10001)) 127.0.0.1 -t 100 -w 10 >/dev/null &
-	pids[$((I*2 + 1))]=$!
+	echo "b" | \
+		timeout ${timeout_test} \
+			ip netns exec $ns \
+				./mptcp_connect -p $((I+10001)) -w 10 \
+					-t ${timeout_poll} 127.0.0.1 >/dev/null &
 done
 sleep 1.5
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 987a914ee0df..4d94c4e81d49 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -11,7 +11,8 @@ cin=""
 cout=""
 ksft_skip=4
 capture=false
-timeout=30
+timeout_poll=30
+timeout_test=$((timeout_poll * 2 + 1))
 ipv6=true
 ethtool_random_on=true
 tc_delay="$((RANDOM%50))"
@@ -269,7 +270,7 @@ check_mptcp_disabled()
 	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
 
 	local err=0
-	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
+	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
 		grep -q "^socket: Protocol not available$" && err=1
 	ip netns delete ${disabled_ns}
 
@@ -411,14 +412,20 @@ do_transfer()
 	local stat_cookietx_last=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesSent | while read a count c rest ;do  echo $count;done)
 	local stat_cookierx_last=$(ip netns exec ${listener_ns} nstat -z -a TcpExtSyncookiesRecv | while read a count c rest ;do  echo $count;done)
 
-	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} $extra_args $local_addr < "$sin" > "$sout" &
+	timeout ${timeout_test} \
+		ip netns exec ${listener_ns} \
+			./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+				$extra_args $local_addr < "$sin" > "$sout" &
 	local spid=$!
 
 	wait_local_port_listen "${listener_ns}" "${port}"
 
 	local start
 	start=$(date +%s%3N)
-	ip netns exec ${connector_ns} ./mptcp_connect -t $timeout -p $port -s ${cl_proto} $extra_args $connect_addr < "$cin" > "$cout" &
+	timeout ${timeout_test} \
+		ip netns exec ${connector_ns} \
+			./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+				$extra_args $connect_addr < "$cin" > "$cout" &
 	local cpid=$!
 
 	wait $cpid
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0eae628d1ffd..1a9c1c0a5692 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -8,7 +8,8 @@ cin=""
 cinsent=""
 cout=""
 ksft_skip=4
-timeout=30
+timeout_poll=30
+timeout_test=$((timeout_poll * 2 + 1))
 mptcp_connect=""
 capture=0
 
@@ -249,17 +250,26 @@ do_transfer()
 		local_addr="0.0.0.0"
 	fi
 
-	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port \
-		-s ${srv_proto} ${local_addr} < "$sin" > "$sout" &
+	timeout ${timeout_test} \
+		ip netns exec ${listener_ns} \
+			$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+				${local_addr} < "$sin" > "$sout" &
 	spid=$!
 
 	sleep 1
 
 	if [ "$test_link_fail" -eq 0 ];then
-		ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
+		timeout ${timeout_test} \
+			ip netns exec ${connector_ns} \
+				$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+					$connect_addr < "$cin" > "$cout" &
 	else
-		( cat "$cin" ; sleep 2; link_failure $listener_ns ; cat "$cin" ) | tee "$cinsent" | \
-		ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr > "$cout" &
+		( cat "$cin" ; sleep 2; link_failure $listener_ns ; cat "$cin" ) | \
+			tee "$cinsent" | \
+			timeout ${timeout_test} \
+				ip netns exec ${connector_ns} \
+					$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+						$connect_addr > "$cout" &
 	fi
 	cpid=$!
 
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 8fcb28927818..ce832b443475 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -7,7 +7,8 @@ ns2="ns2-$rndh"
 ns3="ns3-$rndh"
 capture=false
 ksft_skip=4
-timeout=30
+timeout_poll=30
+timeout_test=$((timeout_poll * 2 + 1))
 test_cnt=1
 ret=0
 bail=0
@@ -157,14 +158,20 @@ do_transfer()
 		sleep 1
 	fi
 
-	ip netns exec ${ns3} ./mptcp_connect -jt $timeout -l -p $port 0.0.0.0 < "$sin" > "$sout" &
+	timeout ${timeout_test} \
+		ip netns exec ${ns3} \
+			./mptcp_connect -jt ${timeout_poll} -l -p $port \
+				0.0.0.0 < "$sin" > "$sout" &
 	local spid=$!
 
 	wait_local_port_listen "${ns3}" "${port}"
 
 	local start
 	start=$(date +%s%3N)
-	ip netns exec ${ns1} ./mptcp_connect -jt $timeout -p $port 10.0.3.3 < "$cin" > "$cout" &
+	timeout ${timeout_test} \
+		ip netns exec ${ns1} \
+			./mptcp_connect -jt ${timeout_poll} -p $port \
+				10.0.3.3 < "$cin" > "$cout" &
 	local cpid=$!
 
 	wait $cpid
-- 
2.35.1



