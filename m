Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5339C353F11
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhDEJKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238859AbhDEJJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 724B361398;
        Mon,  5 Apr 2021 09:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613741;
        bh=QyMaZfyU8O69zl4rPPwQEByU5rJpN4LDUIujc/NtQgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bhnozsevx3/7VeIpgYHaLKgJFsuJlIZfYvu8HL94jKGogOmG1h3ynpxqgThwtrvMB
         s3Jr5YywcIIN2eDT6bTA4jeaxorvRk5rMGxEjSRKxVNmen8ommqS+lRbnYlFdx5EWb
         XLXzTVzK4beU9tJgWqqXsK8sJOLFojvlkyMlL+44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/126] flow_dissector: fix TTL and TOS dissection on IPv4 fragments
Date:   Mon,  5 Apr 2021 10:53:20 +0200
Message-Id: <20210405085032.307878394@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit d2126838050ccd1dadf310ffb78b2204f3b032b9 ]

the following command:

 # tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
   $tcflags dst_ip 192.0.2.2 ip_ttl 63 action drop

doesn't drop all IPv4 packets that match the configured TTL / destination
address. In particular, if "fragment offset" or "more fragments" have non
zero value in the IPv4 header, setting of FLOW_DISSECTOR_KEY_IP is simply
ignored. Fix this dissecting IPv4 TTL and TOS before fragment info; while
at it, add a selftest for tc flower's match on 'ip_ttl' that verifies the
correct behavior.

Fixes: 518d8a2e9bad ("net/flow_dissector: add support for dissection of misc ip header fields")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c                     |  6 +--
 .../selftests/net/forwarding/tc_flower.sh     | 38 ++++++++++++++++++-
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index c79be25b2e0c..d48b37b15b27 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1050,6 +1050,9 @@ proto_again:
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
+		__skb_flow_dissect_ipv4(skb, flow_dissector,
+					target_container, data, iph);
+
 		if (ip_is_fragment(iph)) {
 			key_control->flags |= FLOW_DIS_IS_FRAGMENT;
 
@@ -1066,9 +1069,6 @@ proto_again:
 			}
 		}
 
-		__skb_flow_dissect_ipv4(skb, flow_dissector,
-					target_container, data, iph);
-
 		break;
 	}
 	case htons(ETH_P_IPV6): {
diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 058c746ee300..b11d8e6b5bc1 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
-	match_ip_tos_test match_indev_test"
+	match_ip_tos_test match_indev_test match_ip_ttl_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -310,6 +310,42 @@ match_ip_tos_test()
 	log_test "ip_tos match ($tcflags)"
 }
 
+match_ip_ttl_test()
+{
+	RET=0
+
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		$tcflags dst_ip 192.0.2.2 ip_ttl 63 action drop
+	tc filter add dev $h2 ingress protocol ip pref 2 handle 102 flower \
+		$tcflags dst_ip 192.0.2.2 action drop
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip "ttl=63" -q
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip "ttl=63,mf,frag=256" -q
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_fail $? "Matched on the wrong filter (no check on ttl)"
+
+	tc_check_packets "dev $h2 ingress" 101 2
+	check_err $? "Did not match on correct filter (ttl=63)"
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip "ttl=255" -q
+
+	tc_check_packets "dev $h2 ingress" 101 3
+	check_fail $? "Matched on a wrong filter (ttl=63)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (no check on ttl)"
+
+	tc filter del dev $h2 ingress protocol ip pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+
+	log_test "ip_ttl match ($tcflags)"
+}
+
 match_indev_test()
 {
 	RET=0
-- 
2.30.1



