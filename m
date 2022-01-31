Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074614A438F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376718AbiAaLV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378402AbiAaLUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4F0C061BB9;
        Mon, 31 Jan 2022 03:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BE160ED0;
        Mon, 31 Jan 2022 11:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA3AC340F1;
        Mon, 31 Jan 2022 11:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627546;
        bh=ZDIQl4UCiIE4FH1PPvz0fsGh3ZhHXhlaAKmajb3b1d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIhIxOZS1eRq6EbSgPlVhD0gu1jfWVhcB3xHsHdTsxBzmPwM5bJosD65ADQdfAtOt
         fTugPnx5WbWhikN6vzPns1tKPZ6OEGQRtbRFfeXLqoCWI0dOFjcISWFCQIXgQWiirX
         VF1sqR5MKcCeWKlLtRl976hNrSqoVJyzqal2TJ/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Subject: [PATCH 5.15 119/171] selftests: mptcp: fix ipv6 routing setup
Date:   Mon, 31 Jan 2022 11:56:24 +0100
Message-Id: <20220131105234.068692157@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9846921dba4936d92f7608315b5d1e0a8ec3a538 ]

MPJ ipv6 selftests currently lack per link route to the server
net. Additionally, ipv6 subflows endpoints are created without any
interface specified. The end-result is that in ipv6 self-tests
subflows are created all on the same link, leading to expected delays
and sporadic self-tests failures.

Fix the issue by adding the missing setup bits.

Fixes: 523514ed0a99 ("selftests: mptcp: add ADD_ADDR IPv6 test cases")
Reported-and-tested-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0c12602fa22e8..38777d1ef766f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -75,6 +75,7 @@ init()
 
 		# let $ns2 reach any $ns1 address from any interface
 		ip -net "$ns2" route add default via 10.0.$i.1 dev ns2eth$i metric 10$i
+		ip -net "$ns2" route add default via dead:beef:$i::1 dev ns2eth$i metric 10$i
 	done
 }
 
@@ -1386,7 +1387,7 @@ ipv6_tests()
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "single subflow IPv6" 1 1 1
 
@@ -1421,7 +1422,7 @@ ipv6_tests()
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal IPv6" 2 2 2
 	chk_add_nr 1 1
-- 
2.34.1



