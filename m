Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63A49DFA4
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbfH0H4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbfH0H4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C54F1206BA;
        Tue, 27 Aug 2019 07:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892567;
        bh=MUIcTWJ/nQc3kOxlYLVxWaob9x9FWvs1EU/9x9YOFck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSg5O4OWYADa0XYAArc25CaEorRJu7No8gda8y3w3aS3zb/qj8Pg22T7Q1pOeSTt8
         lHJOpJGA1q9YWzQSmOPacEPI/s0PFzPMpwO5p228MBZ6K6Q2x3RCwz9fLFRrjDQJZP
         eAKncRqaUSNcJFdSFjGb59+m2UrUnaywgGKdce3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/98] selftests: forwarding: gre_multipath: Fix flower filters
Date:   Tue, 27 Aug 2019 09:49:49 +0200
Message-Id: <20190827072718.711893415@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1be79d89b7ae96e004911bd228ce8c2b5cc6415f ]

The TC filters used in the test do not work with veth devices because the
outer Ethertype is 802.1Q and not IPv4. The test passes with mlxsw
netdevs since the hardware always looks at "The first Ethertype that
does not point to either: VLAN, CNTAG or configurable Ethertype".

Fix this by matching on the VLAN ID instead, but on the ingress side.
The reason why this is not performed at egress is explained in the
commit cited below.

Fixes: 541ad323db3a ("selftests: forwarding: gre_multipath: Update next-hop statistics match criteria")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Tested-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/gre_multipath.sh | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath.sh b/tools/testing/selftests/net/forwarding/gre_multipath.sh
index 37d7297e1cf8a..a8d8e8b3dc819 100755
--- a/tools/testing/selftests/net/forwarding/gre_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/gre_multipath.sh
@@ -93,18 +93,10 @@ sw1_create()
 	ip route add vrf v$ol1 192.0.2.16/28 \
 	   nexthop dev g1a \
 	   nexthop dev g1b
-
-	tc qdisc add dev $ul1 clsact
-	tc filter add dev $ul1 egress pref 111 prot ipv4 \
-	   flower dst_ip 192.0.2.66 action pass
-	tc filter add dev $ul1 egress pref 222 prot ipv4 \
-	   flower dst_ip 192.0.2.82 action pass
 }
 
 sw1_destroy()
 {
-	tc qdisc del dev $ul1 clsact
-
 	ip route del vrf v$ol1 192.0.2.16/28
 
 	ip route del vrf v$ol1 192.0.2.82/32 via 192.0.2.146
@@ -139,10 +131,18 @@ sw2_create()
 	ip route add vrf v$ol2 192.0.2.0/28 \
 	   nexthop dev g2a \
 	   nexthop dev g2b
+
+	tc qdisc add dev $ul2 clsact
+	tc filter add dev $ul2 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul2 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
 }
 
 sw2_destroy()
 {
+	tc qdisc del dev $ul2 clsact
+
 	ip route del vrf v$ol2 192.0.2.0/28
 
 	ip route del vrf v$ol2 192.0.2.81/32 via 192.0.2.145
@@ -215,15 +215,15 @@ multipath4_test()
 	   nexthop dev g1a weight $weight1 \
 	   nexthop dev g1b weight $weight2
 
-	local t0_111=$(tc_rule_stats_get $ul1 111 egress)
-	local t0_222=$(tc_rule_stats_get $ul1 222 egress)
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
 
 	ip vrf exec v$h1 \
 	   $MZ $h1 -q -p 64 -A 192.0.2.1 -B 192.0.2.18 \
 	       -d 1msec -t udp "sp=1024,dp=0-32768"
 
-	local t1_111=$(tc_rule_stats_get $ul1 111 egress)
-	local t1_222=$(tc_rule_stats_get $ul1 222 egress)
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
 
 	local d111=$((t1_111 - t0_111))
 	local d222=$((t1_222 - t0_222))
-- 
2.20.1



