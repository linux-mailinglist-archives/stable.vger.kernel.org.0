Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E214A9648
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346314AbiBDJYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357531AbiBDJX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A52C061751;
        Fri,  4 Feb 2022 01:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 610E9B836EA;
        Fri,  4 Feb 2022 09:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66789C004E1;
        Fri,  4 Feb 2022 09:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966619;
        bh=+oZvMD9AMkNurmINvNaniI2N5vd3IeWpBeB50CWq3EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1547bn1I6R2D+PYsViTGrdb8/em5iCQSU15tF5lHEj2nKG8tGBbH37yzpiB6fuDm
         zR1WaAwUavb8BVBQYcveWZPjsKzJOSSfngPx1/GPid1Zz61LI1/bEfDrBZftRAjzBV
         L97C+E/3DSyQnw5iw810pIHIUTWTBEt+/s7ZR9Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Subject: [PATCH 5.15 02/32] selftests: mptcp: fix ipv6 routing setup
Date:   Fri,  4 Feb 2022 10:22:12 +0100
Message-Id: <20220204091915.330086969@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 9846921dba4936d92f7608315b5d1e0a8ec3a538 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -75,6 +75,7 @@ init()
 
 		# let $ns2 reach any $ns1 address from any interface
 		ip -net "$ns2" route add default via 10.0.$i.1 dev ns2eth$i metric 10$i
+		ip -net "$ns2" route add default via dead:beef:$i::1 dev ns2eth$i metric 10$i
 	done
 }
 
@@ -1383,7 +1384,7 @@ ipv6_tests()
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "single subflow IPv6" 1 1 1
 
@@ -1418,7 +1419,7 @@ ipv6_tests()
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal IPv6" 2 2 2
 	chk_add_nr 1 1


