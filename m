Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D4A56543F
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiGDMBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiGDMBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BE011824
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A29FAB80EEA
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0963DC3411E;
        Mon,  4 Jul 2022 12:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656936110;
        bh=42dJhRh2PhRr6vT+Jje2uO/co7LB6MGy3drR6xj1xGk=;
        h=Subject:To:Cc:From:Date:From;
        b=ZnpxTCcffVk5hU1vGUy5Fy8RmDo9Px6CTrRrEy4SLyHlQdYQRC2FbQI1PeXKrj3Dh
         vXEpqhy3Bdy8vnThIy8GtVVpw5c/wawJJTu3213thuLPs0EyQohz04pgZoTcbz8bx6
         OEkPVZ5RCWFGpyvTXXsQQuKeGK3hRdlWNrRL80vA=
Subject: FAILED: patch "[PATCH] selftests: mptcp: more stable diag tests" failed to apply to 5.10-stable tree
To:     pabeni@redhat.com, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 14:01:47 +0200
Message-ID: <165693610748224@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42fb6cddec3b306c9f6ef136b6438e0de1836431 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 27 Jun 2022 18:02:41 -0700
Subject: [PATCH] selftests: mptcp: more stable diag tests

The mentioned test-case still use an hard-coded-len sleep to
wait for a relative large number of connection to be established.

On very slow VM and with debug build such timeout could be exceeded,
causing failures in our CI.

Address the issue polling for the expected condition several times,
up to an unreasonable high amount of time. On reasonably fast system
the self-tests will be faster then before, on very slow one we will
still catch the correct condition.

Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index 9dd43d7d957b..515859a5168b 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -61,6 +61,39 @@ chk_msk_nr()
 	__chk_nr "grep -c token:" $*
 }
 
+wait_msk_nr()
+{
+	local condition="grep -c token:"
+	local expected=$1
+	local timeout=20
+	local msg nr
+	local max=0
+	local i=0
+
+	shift 1
+	msg=$*
+
+	while [ $i -lt $timeout ]; do
+		nr=$(ss -inmHMN $ns | $condition)
+		[ $nr == $expected ] && break;
+		[ $nr -gt $max ] && max=$nr
+		i=$((i + 1))
+		sleep 1
+	done
+
+	printf "%-50s" "$msg"
+	if [ $i -ge $timeout ]; then
+		echo "[ fail ] timeout while expecting $expected max $max last $nr"
+		ret=$test_cnt
+	elif [ $nr != $expected ]; then
+		echo "[ fail ] expected $expected found $nr"
+		ret=$test_cnt
+	else
+		echo "[  ok  ]"
+	fi
+	test_cnt=$((test_cnt+1))
+}
+
 chk_msk_fallback_nr()
 {
 		__chk_nr "grep -c fallback" $*
@@ -146,7 +179,7 @@ ip -n $ns link set dev lo up
 echo "a" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -l -t ${timeout_poll} -w 20 \
 				0.0.0.0 >/dev/null &
 wait_local_port_listen $ns 10000
 chk_msk_nr 0 "no msk on netns creation"
@@ -155,7 +188,7 @@ chk_msk_listen 10000
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} -w 20 \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
@@ -167,13 +200,13 @@ flush_pids
 echo "a" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} \
+			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} -w 20 \
 				0.0.0.0 >/dev/null &
 wait_local_port_listen $ns 10001
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10001 -r 0 -t ${timeout_poll} \
+			./mptcp_connect -p 10001 -r 0 -t ${timeout_poll} -w 20 \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
@@ -184,7 +217,7 @@ for I in `seq 1 $NR_CLIENTS`; do
 	echo "a" | \
 		timeout ${timeout_test} \
 			ip netns exec $ns \
-				./mptcp_connect -p $((I+10001)) -l -w 10 \
+				./mptcp_connect -p $((I+10001)) -l -w 20 \
 					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
 wait_local_port_listen $ns $((NR_CLIENTS + 10001))
@@ -193,12 +226,11 @@ for I in `seq 1 $NR_CLIENTS`; do
 	echo "b" | \
 		timeout ${timeout_test} \
 			ip netns exec $ns \
-				./mptcp_connect -p $((I+10001)) -w 10 \
+				./mptcp_connect -p $((I+10001)) -w 20 \
 					-t ${timeout_poll} 127.0.0.1 >/dev/null &
 done
-sleep 1.5
 
-chk_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
+wait_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
 flush_pids
 
 exit $ret

