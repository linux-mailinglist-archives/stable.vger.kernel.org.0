Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCCE17FDD0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgCJMuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgCJMuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1BF20674;
        Tue, 10 Mar 2020 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844650;
        bh=3VYHnFW9xuaaqOe/hIphKKB4MipCxChBwxd5IRK5Rbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoWAmsknIGq4TZyPajh4VfXlsD69a0L0zSPTIW5IGb+GmQe9mY02EQNq8Emjxq9Kg
         1TW3IOodR4o9fnJCdNOfHy7QFjZrmuGpqEWUvs3ab3svl/stxR/nPW3JrmtGX/yO4M
         ZfhQXLdg5w3yCSYkXy2HmHh0HjOw4ajiF4DtQhZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/168] selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac testing
Date:   Tue, 10 Mar 2020 13:37:55 +0100
Message-Id: <20200310123638.543414246@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e8023b030ce1748930e2dc76353a262fe47d4745 ]

For tc ip_proto filter, when we extract the flow via __skb_flow_dissect()
without flag FLOW_DISSECTOR_F_STOP_AT_ENCAP, we will continue extract to
the inner proto.

So for GRE + ICMP messages, we should not track GRE proto, but inner ICMP
proto.

For test mirror_gre.sh, it may make user confused if we capture ICMP
message on $h3(since the flow is GRE message). So I move the capture
dev to h3-gt{4,6}, and only capture ICMP message.

Before the fix:
]# ./mirror_gre.sh
TEST: ingress mirror to gretap (skip_hw)                            [ OK ]
TEST: egress mirror to gretap (skip_hw)                             [ OK ]
TEST: ingress mirror to ip6gretap (skip_hw)                         [ OK ]
TEST: egress mirror to ip6gretap (skip_hw)                          [ OK ]
TEST: ingress mirror to gretap: envelope MAC (skip_hw)              [FAIL]
 Expected to capture 10 packets, got 0.
TEST: egress mirror to gretap: envelope MAC (skip_hw)               [FAIL]
 Expected to capture 10 packets, got 0.
TEST: ingress mirror to ip6gretap: envelope MAC (skip_hw)           [FAIL]
 Expected to capture 10 packets, got 0.
TEST: egress mirror to ip6gretap: envelope MAC (skip_hw)            [FAIL]
 Expected to capture 10 packets, got 0.
TEST: two simultaneously configured mirrors (skip_hw)               [ OK ]
WARN: Could not test offloaded functionality

After fix:
]# ./mirror_gre.sh
TEST: ingress mirror to gretap (skip_hw)                            [ OK ]
TEST: egress mirror to gretap (skip_hw)                             [ OK ]
TEST: ingress mirror to ip6gretap (skip_hw)                         [ OK ]
TEST: egress mirror to ip6gretap (skip_hw)                          [ OK ]
TEST: ingress mirror to gretap: envelope MAC (skip_hw)              [ OK ]
TEST: egress mirror to gretap: envelope MAC (skip_hw)               [ OK ]
TEST: ingress mirror to ip6gretap: envelope MAC (skip_hw)           [ OK ]
TEST: egress mirror to ip6gretap: envelope MAC (skip_hw)            [ OK ]
TEST: two simultaneously configured mirrors (skip_hw)               [ OK ]
WARN: Could not test offloaded functionality

Fixes: ba8d39871a10 ("selftests: forwarding: Add test for mirror to gretap")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Petr Machata <pmachata@gmail.com>
Tested-by: Petr Machata <pmachata@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/mirror_gre.sh    | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre.sh b/tools/testing/selftests/net/forwarding/mirror_gre.sh
index e6fd7a18c655f..0266443601bc0 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre.sh
@@ -63,22 +63,23 @@ test_span_gre_mac()
 {
 	local tundev=$1; shift
 	local direction=$1; shift
-	local prot=$1; shift
 	local what=$1; shift
 
-	local swp3mac=$(mac_get $swp3)
-	local h3mac=$(mac_get $h3)
+	case "$direction" in
+	ingress) local src_mac=$(mac_get $h1); local dst_mac=$(mac_get $h2)
+		;;
+	egress) local src_mac=$(mac_get $h2); local dst_mac=$(mac_get $h1)
+		;;
+	esac
 
 	RET=0
 
 	mirror_install $swp1 $direction $tundev "matchall $tcflags"
-	tc filter add dev $h3 ingress pref 77 prot $prot \
-		flower ip_proto 0x2f src_mac $swp3mac dst_mac $h3mac \
-		action pass
+	icmp_capture_install h3-${tundev} "src_mac $src_mac dst_mac $dst_mac"
 
-	mirror_test v$h1 192.0.2.1 192.0.2.2 $h3 77 10
+	mirror_test v$h1 192.0.2.1 192.0.2.2 h3-${tundev} 100 10
 
-	tc filter del dev $h3 ingress pref 77
+	icmp_capture_uninstall h3-${tundev}
 	mirror_uninstall $swp1 $direction
 
 	log_test "$direction $what: envelope MAC ($tcflags)"
@@ -120,14 +121,14 @@ test_ip6gretap()
 
 test_gretap_mac()
 {
-	test_span_gre_mac gt4 ingress ip "mirror to gretap"
-	test_span_gre_mac gt4 egress ip "mirror to gretap"
+	test_span_gre_mac gt4 ingress "mirror to gretap"
+	test_span_gre_mac gt4 egress "mirror to gretap"
 }
 
 test_ip6gretap_mac()
 {
-	test_span_gre_mac gt6 ingress ipv6 "mirror to ip6gretap"
-	test_span_gre_mac gt6 egress ipv6 "mirror to ip6gretap"
+	test_span_gre_mac gt6 ingress "mirror to ip6gretap"
+	test_span_gre_mac gt6 egress "mirror to ip6gretap"
 }
 
 test_all()
-- 
2.20.1



