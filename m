Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6C1EFFA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbfEOL2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732071AbfEOL2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:28:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B8820818;
        Wed, 15 May 2019 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919725;
        bh=akPbtu2m/5AOg/1NNH29ydnBj+HXAz/HUtkMhjTCuc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDvJ0KAMdT+9AryMmsgD4iuVjlskMPzWur+8r9lIfhYqZTZ6UD19wwATUc/vSsZ4r
         bvh2rHG90smR9kzUNNLpL2eMtSLHZB44CWhDh54y4PIZypLMMIPL6vnV+BOdPxBGMW
         gZ/a64W/nHDhP8JzQ3i7HLiBEAo5biaVXVRpM89c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 068/137] netfilter: nat: fix icmp id randomization
Date:   Wed, 15 May 2019 12:55:49 +0200
Message-Id: <20190515090658.388711972@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5bdac418f33f60b07a34e01e722889140ee8fac9 ]

Sven Auhagen reported that a 2nd ping request will fail if 'fully-random'
mode is used.

Reason is that if no proto information is given, min/max are both 0,
so we set the icmp id to 0 instead of chosing a random value between
0 and 65535.

Update test case as well to catch this, without fix this yields:
[..]
ERROR: cannot ping ns1 from ns2 with ip masquerade fully-random (attempt 2)
ERROR: cannot ping ns1 from ns2 with ipv6 masquerade fully-random (attempt 2)

... becaus 2nd ping clashes with existing 'id 0' icmp conntrack and gets
dropped.

Fixes: 203f2e78200c27e ("netfilter: nat: remove l4proto->unique_tuple")
Reported-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c                  | 11 ++++--
 tools/testing/selftests/netfilter/nft_nat.sh | 36 +++++++++++++++-----
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d159e9e7835b4..ade527565127b 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -358,9 +358,14 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	case IPPROTO_ICMPV6:
 		/* id is same for either direction... */
 		keyptr = &tuple->src.u.icmp.id;
-		min = range->min_proto.icmp.id;
-		range_size = ntohs(range->max_proto.icmp.id) -
-			     ntohs(range->min_proto.icmp.id) + 1;
+		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+			min = 0;
+			range_size = 65536;
+		} else {
+			min = ntohs(range->min_proto.icmp.id);
+			range_size = ntohs(range->max_proto.icmp.id) -
+				     ntohs(range->min_proto.icmp.id) + 1;
+		}
 		goto find_free_id;
 #if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
 	case IPPROTO_GRE:
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 8ec76681605cc..3194007cf8d1b 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -321,6 +321,7 @@ EOF
 
 test_masquerade6()
 {
+	local natflags=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -354,13 +355,13 @@ ip netns exec ns0 nft -f - <<EOF
 table ip6 nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
-		meta oif veth0 masquerade
+		meta oif veth0 masquerade $natflags
 	}
 }
 EOF
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags"
 		lret=1
 	fi
 
@@ -397,19 +398,26 @@ EOF
 		fi
 	done
 
+	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags (attempt 2)"
+		lret=1
+	fi
+
 	ip netns exec ns0 nft flush chain ip6 nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush ip6 nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IPv6 masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: IPv6 masquerade $natflags for ns2"
 
 	return $lret
 }
 
 test_masquerade()
 {
+	local natflags=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
@@ -417,7 +425,7 @@ test_masquerade()
 
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: canot ping ns1 from ns2"
+		echo "ERROR: cannot ping ns1 from ns2 $natflags"
 		lret=1
 	fi
 
@@ -443,13 +451,13 @@ ip netns exec ns0 nft -f - <<EOF
 table ip nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
-		meta oif veth0 masquerade
+		meta oif veth0 masquerade $natflags
 	}
 }
 EOF
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active ip masquere $natflags"
 		lret=1
 	fi
 
@@ -485,13 +493,19 @@ EOF
 		fi
 	done
 
+	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerade $natflags (attempt 2)"
+		lret=1
+	fi
+
 	ip netns exec ns0 nft flush chain ip nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IP masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: IP masquerade $natflags for ns2"
 
 	return $lret
 }
@@ -750,8 +764,12 @@ test_local_dnat
 test_local_dnat6
 
 reset_counters
-test_masquerade
-test_masquerade6
+test_masquerade ""
+test_masquerade6 ""
+
+reset_counters
+test_masquerade "fully-random"
+test_masquerade6 "fully-random"
 
 reset_counters
 test_redirect
-- 
2.20.1



