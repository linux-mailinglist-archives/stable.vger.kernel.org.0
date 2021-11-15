Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7F451EC5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352573AbhKPAh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344823AbhKOTZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 636AD633E1;
        Mon, 15 Nov 2021 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003089;
        bh=L0PMa3Q3yB6dKOng0a2/intWD71kVEdEsAS32z0lpLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHXSTR+qW4rB0e66KDsTqPEeiuL48mwX4VPhnLeTvyfKFYVv8aeptc2AsZOj5CTyy
         bwria0aqSxXAAGgADsWn/QIrVVvMObVcu6AeYYin3Ym1E5Hp8FJUG2d15ffQpIrBB5
         qvonNcBSlZA6hFP/nbd8XnHODLTAAHZZ91y6pL6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 805/917] selftests/bpf/xdp_redirect_multi: Use arping to accurate the arp number
Date:   Mon, 15 Nov 2021 18:05:00 +0100
Message-Id: <20211115165456.283561667@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit f53ea9dbf78d42a10e2392b5c59362ccc224fd1d ]

The arp request number triggered by ping none exist address is not accurate,
which may lead the test false negative/positive. Change to use arping to
accurate the arp number. Also do not use grep pattern match for dot.

Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Suggested-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211027033553.962413-3-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index b20b96ba72ef0..c2a933caa32d4 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -127,7 +127,7 @@ do_ping_tests()
 	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
 	sleep 0.5
 	# ARP test
-	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
+	ip netns exec ns1 arping -q -c 2 -I veth0 192.0.2.254
 	# IPv4 test
 	ip netns exec ns1 ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
 	# IPv6 test
@@ -136,13 +136,13 @@ do_ping_tests()
 	pkill -9 tcpdump
 
 	# All netns should receive the redirect arp requests
-	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -gt 4 ] && \
+	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -eq 4 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-1" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-1"
-	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-2_${mode}.log) -le 4 ] && \
+	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-2_${mode}.log) -eq 2 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-2" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-2"
-	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-3_${mode}.log) -le 4 ] && \
+	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-3_${mode}.log) -eq 2 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-3" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-3"
 
-- 
2.33.0



