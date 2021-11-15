Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1E452393
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348107AbhKPB1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243605AbhKOTGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B61F063236;
        Mon, 15 Nov 2021 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000194;
        bh=Wqd5c32K1PC+q/kVSpCwS3AH13LwmPKy+aCGxgOQ814=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGFwKu4u9f4hAy6Kq5mg3QCvnq4zgzqSRXtRaxsj/0AvmbU9EJQf6azcYKgwp5Gs7
         OwNQm1xytTihebI4zZ+taNXaKiUa8l+RhfLNrqx9xospKPTa7qeX5hZPRWRLgENZMw
         ALbzFTTbYot3f8je2y1eInhzFXCBQ97v+KsTec20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 538/849] selftests: net: bridge: update IGMP/MLD membership interval value
Date:   Mon, 15 Nov 2021 18:00:21 +0100
Message-Id: <20211115165438.460564131@linuxfoundation.org>
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

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 34d7ecb3d4f772eb00ce1f7195ae30886ddf4d2e ]

When I fixed IGMPv3/MLDv2 to use the bridge's multicast_membership_interval
value which is chosen by user-space instead of calculating it based on
multicast_query_interval and multicast_query_response_interval I forgot
to update the selftests relying on that behaviour. Now we have to
manually set the expected GMI value to perform the tests correctly and get
proper results (similar to IGMPv2 behaviour).

Fixes: fac3cb82a54a ("net: bridge: mcast: use multicast_membership_interval for IGMPv3")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/forwarding/bridge_igmp.sh  | 12 +++++++++---
 tools/testing/selftests/net/forwarding/bridge_mld.sh | 12 +++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 675eff45b0371..1162836f8f329 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -482,10 +482,15 @@ v3exc_timeout_test()
 	local X=("192.0.2.20" "192.0.2.30")
 
 	# GMI should be 3 seconds
-	ip link set dev br0 type bridge mcast_query_interval 100 mcast_query_response_interval 100
+	ip link set dev br0 type bridge mcast_query_interval 100 \
+					mcast_query_response_interval 100 \
+					mcast_membership_interval 300
 
 	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
-	ip link set dev br0 type bridge mcast_query_interval 500 mcast_query_response_interval 500
+	ip link set dev br0 type bridge mcast_query_interval 500 \
+					mcast_query_response_interval 500 \
+					mcast_membership_interval 1500
+
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW2" -q
 	sleep 3
 	bridge -j -d -s mdb show dev br0 \
@@ -517,7 +522,8 @@ v3exc_timeout_test()
 	log_test "IGMPv3 group $TEST_GROUP exclude timeout"
 
 	ip link set dev br0 type bridge mcast_query_interval 12500 \
-					mcast_query_response_interval 1000
+					mcast_query_response_interval 1000 \
+					mcast_membership_interval 26000
 
 	v3cleanup $swp1 $TEST_GROUP
 }
diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index ffdcfa87ca2ba..e2b9ff773c6b6 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -479,10 +479,15 @@ mldv2exc_timeout_test()
 	local X=("2001:db8:1::20" "2001:db8:1::30")
 
 	# GMI should be 3 seconds
-	ip link set dev br0 type bridge mcast_query_interval 100 mcast_query_response_interval 100
+	ip link set dev br0 type bridge mcast_query_interval 100 \
+					mcast_query_response_interval 100 \
+					mcast_membership_interval 300
 
 	mldv2exclude_prepare $h1
-	ip link set dev br0 type bridge mcast_query_interval 500 mcast_query_response_interval 500
+	ip link set dev br0 type bridge mcast_query_interval 500 \
+					mcast_query_response_interval 500 \
+					mcast_membership_interval 1500
+
 	$MZ $h1 -c 1 $MZPKT_ALLOW2 -q
 	sleep 3
 	bridge -j -d -s mdb show dev br0 \
@@ -514,7 +519,8 @@ mldv2exc_timeout_test()
 	log_test "MLDv2 group $TEST_GROUP exclude timeout"
 
 	ip link set dev br0 type bridge mcast_query_interval 12500 \
-					mcast_query_response_interval 1000
+					mcast_query_response_interval 1000 \
+					mcast_membership_interval 26000
 
 	mldv2cleanup $swp1
 }
-- 
2.33.0



