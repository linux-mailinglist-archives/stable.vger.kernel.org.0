Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A46630CAAC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239065AbhBBS4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhBBOBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:01:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B4F64FFD;
        Tue,  2 Feb 2021 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273637;
        bh=4SVKmwjqH7ZGQkrtA8K5tUcZDi/m0sGJKXYr67krFc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hkgd0kDe2ctxjiCTCaBzw5+ZvXm5U1zCuXyV4JblPdUr9fzofK0ATQ+Alugw+MiCb
         k8yIkzge90LO4lUGy7rWQLalJFPj6UdWAmxo0zKGU58OaDhRQoMmfa5K8E+oLOaQtd
         zyLtgduR6wibXslQCjJr73lDoPrV2/VHxjVrkorY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Visa Hankala <visa@hankala.org>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/61] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Date:   Tue,  2 Feb 2021 14:38:14 +0100
Message-Id: <20210202132947.992415183@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Visa Hankala <visa@hankala.org>

[ Upstream commit da64ae2d35d3673233f0403b035d4c6acbf71965 ]

Use three-way comparison for address components to avoid integer
wraparound in the result of xfrm_policy_addr_delta(). This ensures
that the search trees are built and traversed correctly.

Treat IPv4 and IPv6 similarly by returning 0 when prefixlen == 0.
Prefix /0 has only one equivalence class.

Fixes: 9cf545ebd591d ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Signed-off-by: Visa Hankala <visa@hankala.org>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c                     | 26 +++++++++----
 tools/testing/selftests/net/xfrm_policy.sh | 43 ++++++++++++++++++++++
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 780e96f0708e2..32c8163427970 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -790,15 +790,22 @@ static int xfrm_policy_addr_delta(const xfrm_address_t *a,
 				  const xfrm_address_t *b,
 				  u8 prefixlen, u16 family)
 {
+	u32 ma, mb, mask;
 	unsigned int pdw, pbi;
 	int delta = 0;
 
 	switch (family) {
 	case AF_INET:
-		if (sizeof(long) == 4 && prefixlen == 0)
-			return ntohl(a->a4) - ntohl(b->a4);
-		return (ntohl(a->a4) & ((~0UL << (32 - prefixlen)))) -
-		       (ntohl(b->a4) & ((~0UL << (32 - prefixlen))));
+		if (prefixlen == 0)
+			return 0;
+		mask = ~0U << (32 - prefixlen);
+		ma = ntohl(a->a4) & mask;
+		mb = ntohl(b->a4) & mask;
+		if (ma < mb)
+			delta = -1;
+		else if (ma > mb)
+			delta = 1;
+		break;
 	case AF_INET6:
 		pdw = prefixlen >> 5;
 		pbi = prefixlen & 0x1f;
@@ -809,10 +816,13 @@ static int xfrm_policy_addr_delta(const xfrm_address_t *a,
 				return delta;
 		}
 		if (pbi) {
-			u32 mask = ~0u << (32 - pbi);
-
-			delta = (ntohl(a->a6[pdw]) & mask) -
-				(ntohl(b->a6[pdw]) & mask);
+			mask = ~0U << (32 - pbi);
+			ma = ntohl(a->a6[pdw]) & mask;
+			mb = ntohl(b->a6[pdw]) & mask;
+			if (ma < mb)
+				delta = -1;
+			else if (ma > mb)
+				delta = 1;
 		}
 		break;
 	default:
diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 5922941e70c6c..bdf450eaf60cf 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -287,6 +287,47 @@ check_hthresh_repeat()
 	return 0
 }
 
+# insert non-overlapping policies in a random order and check that
+# all of them can be fetched using the traffic selectors.
+check_random_order()
+{
+	local ns=$1
+	local log=$2
+
+	for i in $(seq 100); do
+		ip -net $ns xfrm policy flush
+		for j in $(seq 0 16 255 | sort -R); do
+			ip -net $ns xfrm policy add dst $j.0.0.0/24 dir out priority 10 action allow
+		done
+		for j in $(seq 0 16 255); do
+			if ! ip -net $ns xfrm policy get dst $j.0.0.0/24 dir out > /dev/null; then
+				echo "FAIL: $log" 1>&2
+				return 1
+			fi
+		done
+	done
+
+	for i in $(seq 100); do
+		ip -net $ns xfrm policy flush
+		for j in $(seq 0 16 255 | sort -R); do
+			local addr=$(printf "e000:0000:%02x00::/56" $j)
+			ip -net $ns xfrm policy add dst $addr dir out priority 10 action allow
+		done
+		for j in $(seq 0 16 255); do
+			local addr=$(printf "e000:0000:%02x00::/56" $j)
+			if ! ip -net $ns xfrm policy get dst $addr dir out > /dev/null; then
+				echo "FAIL: $log" 1>&2
+				return 1
+			fi
+		done
+	done
+
+	ip -net $ns xfrm policy flush
+
+	echo "PASS: $log"
+	return 0
+}
+
 #check for needed privileges
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
@@ -438,6 +479,8 @@ check_exceptions "exceptions and block policies after htresh change to normal"
 
 check_hthresh_repeat "policies with repeated htresh change"
 
+check_random_order ns3 "policies inserted in random order"
+
 for i in 1 2 3 4;do ip netns del ns$i;done
 
 exit $ret
-- 
2.27.0



