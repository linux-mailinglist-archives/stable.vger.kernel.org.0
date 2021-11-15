Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2437452225
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351449AbhKPBKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244943AbhKOTSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95ABC634E1;
        Mon, 15 Nov 2021 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000760;
        bh=L0PMa3Q3yB6dKOng0a2/intWD71kVEdEsAS32z0lpLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uS5Hbwj5+K0jcmrGbyYRtCX+mIibGxltchIaxYjDAyMB31O7dcKhuowq1pp2aVGE6
         1mWxov4MTIr9u8ktZSF/op+/QVfIMpJkcnuZb16HhV9ROnqDxg1QnSi76wO7HhVQKD
         ZcWH5bPqFcU4CQVK2n2pgcmkZNa/7Y9JdTqrbmA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 749/849] selftests/bpf/xdp_redirect_multi: Use arping to accurate the arp number
Date:   Mon, 15 Nov 2021 18:03:52 +0100
Message-Id: <20211115165445.589787009@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



