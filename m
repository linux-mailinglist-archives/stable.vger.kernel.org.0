Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAE566C86
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiGEMQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiGEMOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA601AF28;
        Tue,  5 Jul 2022 05:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B23B817D6;
        Tue,  5 Jul 2022 12:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB767C341D0;
        Tue,  5 Jul 2022 12:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023089;
        bh=DAHCEuasgYnNHkCWm8UqJFCOhvQ9ysxznv8cUKJJYP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVWzsV0m3IS+9LN3Ac8FOum6sVYx411HM7w/gVGUy4XnBbxebZhcilU33TeIrV2Ut
         qkum2iwZiGWEFKRrmQuYo8msIUqjNphsMOlc4CH1LahtMWmG/fGPGVmCXoyrx3KhgC
         iDu6f/wWBMefTvr7/VEEnnQH9+UcQg1mewwx8VqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 32/98] selftests: mptcp: more stable diag tests
Date:   Tue,  5 Jul 2022 13:57:50 +0200
Message-Id: <20220705115618.504106400@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 42fb6cddec3b306c9f6ef136b6438e0de1836431 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/diag.sh |   48 +++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 8 deletions(-)

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
@@ -109,7 +142,7 @@ ip -n $ns link set dev lo up
 echo "a" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -l -t ${timeout_poll} -w 20 \
 				0.0.0.0 >/dev/null &
 wait_local_port_listen $ns 10000
 chk_msk_nr 0 "no msk on netns creation"
@@ -117,7 +150,7 @@ chk_msk_nr 0 "no msk on netns creation"
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} -w 20 \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
@@ -129,13 +162,13 @@ flush_pids
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
@@ -146,7 +179,7 @@ for I in `seq 1 $NR_CLIENTS`; do
 	echo "a" | \
 		timeout ${timeout_test} \
 			ip netns exec $ns \
-				./mptcp_connect -p $((I+10001)) -l -w 10 \
+				./mptcp_connect -p $((I+10001)) -l -w 20 \
 					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
 wait_local_port_listen $ns $((NR_CLIENTS + 10001))
@@ -155,12 +188,11 @@ for I in `seq 1 $NR_CLIENTS`; do
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


