Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC23566BF7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiGEMKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiGEMIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3186518377;
        Tue,  5 Jul 2022 05:08:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB2E3B817C7;
        Tue,  5 Jul 2022 12:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0EFC341C7;
        Tue,  5 Jul 2022 12:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022907;
        bh=VNyGVsrBfCuZ9WuzbLiyCfMj5dhwaihukPtxljFORqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RM9GHnbISUC8ji1PJQ0EQ6Y59TGKo1+rTBl2bD8AcpijdVWbjyj7k4kSUP8AxYB+x
         j7kIfySm+K3u9jZJPTZk4dHa34hl6CgyDomJwAhSClM0BV3HkMsyaiqrjH4f4qcBbt
         QE2kz2lMe1fBdTckVEt/7v3wCmE5bkZUKOKkQUxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/84] selftests: mptcp: add ADD_ADDR IPv6 test cases
Date:   Tue,  5 Jul 2022 13:58:16 +0200
Message-Id: <20220705115616.872399942@linuxfoundation.org>
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

[ Upstream commit 523514ed0a998fda389b9b6f00d0f2054ba30d25 ]

This patch added IPv6 support for do_transfer, and the test cases for
ADD_ADDR IPv6.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 70 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f841ed8186c1..0eae628d1ffd 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -195,6 +195,12 @@ link_failure()
 	ip -net "$ns" link set "$veth" down
 }
 
+# $1: IP address
+is_v6()
+{
+	[ -z "${1##*:*}" ]
+}
+
 do_transfer()
 {
 	listener_ns="$1"
@@ -236,7 +242,15 @@ do_transfer()
 		mptcp_connect="./mptcp_connect -r"
 	fi
 
-	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
+	local local_addr
+	if is_v6 "${connect_addr}"; then
+		local_addr="::"
+	else
+		local_addr="0.0.0.0"
+	fi
+
+	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port \
+		-s ${srv_proto} ${local_addr} < "$sin" > "$sout" &
 	spid=$!
 
 	sleep 1
@@ -649,6 +663,60 @@ chk_join_nr "remove subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
 
+# subflow IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "single subflow IPv6" 1 1 1
+
+# add_address, unused IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "unused signal address IPv6" 0 0 0
+chk_add_nr 1 1
+
+# signal address IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "single address IPv6" 1 1 1
+chk_add_nr 1 1
+
+# add_addr timeout IPv6
+reset_with_add_addr_timeout 6
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
+chk_add_nr 4 0
+
+# single address IPv6, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 dead:beef:1::1 0 1 0 slow
+chk_join_nr "remove single address IPv6" 1 1 1
+chk_add_nr 1 1
+chk_rm_nr 0 0
+
+# subflow and signal IPv6, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+run_tests $ns1 $ns2 dead:beef:1::1 0 1 1 slow
+chk_join_nr "remove subflow and signal IPv6" 2 2 2
+chk_add_nr 1 1
+chk_rm_nr 1 1
+
 # single subflow, syncookies
 reset_with_cookies
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.35.1



