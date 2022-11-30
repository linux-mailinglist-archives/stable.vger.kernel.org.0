Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C558763DF54
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiK3SqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiK3Spz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8099537E4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 607ACCE1ADB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390F5C433D6;
        Wed, 30 Nov 2022 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833946;
        bh=0K3AIHkB8kD0VAftsr2Eqscp76tLjsXPVX16DhrCo6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lz7s0cJddeTyDjJlbQW15TqUXQFJoC0NU3z42SEv2irscGPg72yl/uM1AMXWoZTId
         O6DinZiDAfzrA3o5BQ6G+XbXYrxjCS9CYI/MWp3LCnTFpajWumqtP0lshF5oIm+EhO
         AWEQ1UxAcsnfw9vixppK3ClXvLN3i+m9H/7N/bwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 072/289] selftests: mptcp: run mptcp_sockopt from a new netns
Date:   Wed, 30 Nov 2022 19:20:57 +0100
Message-Id: <20221130180545.773342978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 7e68d31020f18f8d695d5f143fc16cdaa96166cb ]

Not running it from a new netns causes issues if some MPTCP settings are
modified, e.g. if MPTCP is disabled from the sysctl knob, if multiple
addresses are available and added to the MPTCP path-manager, etc.

In these cases, the created connection will not behave as expected, e.g.
unable to create an MPTCP socket, more than one subflow is seen, etc.

A new "sandbox" net namespace is now created and used to run
mptcp_sockopt from this controlled environment.

Fixes: ce9979129a0b ("selftests: mptcp: add mptcp getsockopt test cases")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 0879da915014..80d36f7cfee8 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -35,8 +35,9 @@ init()
 
 	ns1="ns1-$rndh"
 	ns2="ns2-$rndh"
+	ns_sbox="ns_sbox-$rndh"
 
-	for netns in "$ns1" "$ns2";do
+	for netns in "$ns1" "$ns2" "$ns_sbox";do
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
 		ip netns exec $netns sysctl -q net.mptcp.enabled=1
@@ -73,7 +74,7 @@ init()
 
 cleanup()
 {
-	for netns in "$ns1" "$ns2"; do
+	for netns in "$ns1" "$ns2" "$ns_sbox"; do
 		ip netns del $netns
 	done
 	rm -f "$cin" "$cout"
@@ -243,7 +244,7 @@ do_mptcp_sockopt_tests()
 {
 	local lret=0
 
-	./mptcp_sockopt
+	ip netns exec "$ns_sbox" ./mptcp_sockopt
 	lret=$?
 
 	if [ $lret -ne 0 ]; then
@@ -252,7 +253,7 @@ do_mptcp_sockopt_tests()
 		return
 	fi
 
-	./mptcp_sockopt -6
+	ip netns exec "$ns_sbox" ./mptcp_sockopt -6
 	lret=$?
 
 	if [ $lret -ne 0 ]; then
-- 
2.35.1



