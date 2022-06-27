Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8EC55CF2D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbiF0Ls7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbiF0LsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB125C19;
        Mon, 27 Jun 2022 04:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EE2CB81134;
        Mon, 27 Jun 2022 11:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E437AC341C7;
        Mon, 27 Jun 2022 11:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330069;
        bh=FrKv/fYisOYImlCmHvguXRljYQWRRY7Ecyt+PcKsa6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y69VIK3g/2ygs0nuEPJgX5bo/Cbjnd01E8d9C8sRAt0lkgOlMjg5+56l5X4QTA0Ph
         TTyTkW+epdCswgIZaNNFP7FjbGHzmz0JJRkInPgqzR3ZG9/PajxPHoAnazQmR7p41w
         MaDzr55rzNDHlLA6DoaJBohM3RpJXzVNR0wGVEog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Paolo Bestetti <pbl@bestov.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 073/181] ipv4: fix bind address validity regression tests
Date:   Mon, 27 Jun 2022 13:20:46 +0200
Message-Id: <20220627111946.681083536@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Paolo Bestetti <pbl@bestov.io>

[ Upstream commit 313c502fa3b3494159cb8f18d4a6444d06c5c9a5 ]

Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
introduces support for binding to nonlocal addresses, as well as some
basic test coverage for some of the related cases.

Commit b4a028c4d031 ("ipv4: ping: fix bind address validity check")
fixes a regression which incorrectly removed some checks for bind
address validation. In addition, it introduces regression tests for
those specific checks. However, those regression tests are defective, in
that they perform the tests using an incorrect combination of bind
flags. As a result, those tests fail when they should succeed.

This commit introduces additional regression tests for nonlocal binding
and fixes the defective regression tests. It also introduces new
set_sysctl calls for the ipv4_bind test group, as to perform the ICMP
binding tests it is necessary to allow ICMP socket creation by setting
the net.ipv4.ping_group_range knob.

Fixes: b4a028c4d031 ("ipv4: ping: fix bind address validity check")
Reported-by: Riccardo Paolo Bestetti <pbl@bestov.io>
Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 36 +++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 75223b63e3c8..03b586760164 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1800,24 +1800,32 @@ ipv4_addr_bind_novrf()
 	done
 
 	#
-	# raw socket with nonlocal bind
+	# tests for nonlocal bind
 	#
 	a=${NL_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${NSA_DEV} -b
-	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after device bind"
+	run_cmd nettest -s -R -f -l ${a} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address"
+
+	log_start
+	run_cmd nettest -s -f -l ${a} -b
+	log_test_addr ${a} $? 0 "TCP socket bind to nonlocal address"
+
+	log_start
+	run_cmd nettest -s -D -P icmp -f -l ${a} -b
+	log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address"
 
 	#
 	# check that ICMP sockets cannot bind to broadcast and multicast addresses
 	#
 	a=${BCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -l ${a} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address"
 
 	a=${MCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address"
 
 	#
@@ -1870,24 +1878,32 @@ ipv4_addr_bind_vrf()
 	log_test_addr ${a} $? 1 "Raw socket bind to out of scope address after VRF bind"
 
 	#
-	# raw socket with nonlocal bind
+	# tests for nonlocal bind
 	#
 	a=${NL_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -R -f -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
 
+	log_start
+	run_cmd nettest -s -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "TCP socket bind to nonlocal address after VRF bind"
+
+	log_start
+	run_cmd nettest -s -D -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "ICMP socket bind to nonlocal address after VRF bind"
+
 	#
 	# check that ICMP sockets cannot bind to broadcast and multicast addresses
 	#
 	a=${BCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address after VRF bind"
 
 	a=${MCAST_IP}
 	log_start
-	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	run_cmd nettest -s -D -P icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address after VRF bind"
 
 	#
@@ -1922,10 +1938,12 @@ ipv4_addr_bind()
 
 	log_subsection "No VRF"
 	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
 	ipv4_addr_bind_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
 	ipv4_addr_bind_vrf
 }
 
-- 
2.35.1



