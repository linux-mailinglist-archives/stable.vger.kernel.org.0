Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807F43832AC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhEQOub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241911AbhEQOs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:48:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA24E61975;
        Mon, 17 May 2021 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261347;
        bh=sZURDu140O4z/6zp/lezuwLrla+Z+0BMu7Yr4aR4Sfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qniMn57QyqF2de0NhNJGyYfjuIyem0HysBRRXwho/G99wOmE65SLIIgHS07TmE5Y0
         jq+U8kafANmKM/lrnVEDrMrQ0GokPDIa3Hg4EG0NbtKG5/ozNJ5C2eWCBYZPBt02zx
         AqTm4eGmz8Camglo3WG9qdjDQ1eeQEtB8bNygeIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 104/329] selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test
Date:   Mon, 17 May 2021 16:00:15 +0200
Message-Id: <20210517140305.643322166@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 1233898ab758cbcf5f6fea10b8dd16a0b2c24fab ]

The mirror_gre_scale test creates as many ERSPAN sessions as the underlying
chip supports, and tests that they all work. In order to determine that it
issues a stream of ICMP packets and checks if they are mirrored as
expected.

However, the mausezahn invocation missed the -6 flag to identify the use of
IPv6 protocol, and was sending ICMP messages over IPv6, as opposed to
ICMP6. It also didn't pass an explicit source IP address, which apparently
worked at some point in the past, but does not anymore.

To fix these issues, extend the function mirror_test() in mirror_lib by
detecting the IPv6 protocol addresses, and using a different ICMP scheme.
Fix __mirror_gre_test() in the selftest itself to pass a source IP address.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drivers/net/mlxsw/mirror_gre_scale.sh     |  3 ++-
 .../selftests/net/forwarding/mirror_lib.sh    | 19 +++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
index 6f3a70df63bc..e00435753008 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
@@ -120,12 +120,13 @@ __mirror_gre_test()
 	sleep 5
 
 	for ((i = 0; i < count; ++i)); do
+		local sip=$(mirror_gre_ipv6_addr 1 $i)::1
 		local dip=$(mirror_gre_ipv6_addr 1 $i)::2
 		local htun=h3-gt6-$i
 		local message
 
 		icmp6_capture_install $htun
-		mirror_test v$h1 "" $dip $htun 100 10
+		mirror_test v$h1 $sip $dip $htun 100 10
 		icmp6_capture_uninstall $htun
 	done
 }
diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
index 13db1cb50e57..6406cd76a19d 100644
--- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
@@ -20,6 +20,13 @@ mirror_uninstall()
 	tc filter del dev $swp1 $direction pref 1000
 }
 
+is_ipv6()
+{
+	local addr=$1; shift
+
+	[[ -z ${addr//[0-9a-fA-F:]/} ]]
+}
+
 mirror_test()
 {
 	local vrf_name=$1; shift
@@ -29,9 +36,17 @@ mirror_test()
 	local pref=$1; shift
 	local expect=$1; shift
 
+	if is_ipv6 $dip; then
+		local proto=-6
+		local type="icmp6 type=128" # Echo request.
+	else
+		local proto=
+		local type="icmp echoreq"
+	fi
+
 	local t0=$(tc_rule_stats_get $dev $pref)
-	$MZ $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
-	    -c 10 -d 100msec -t icmp type=8
+	$MZ $proto $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
+	    -c 10 -d 100msec -t $type
 	sleep 0.5
 	local t1=$(tc_rule_stats_get $dev $pref)
 	local delta=$((t1 - t0))
-- 
2.30.2



