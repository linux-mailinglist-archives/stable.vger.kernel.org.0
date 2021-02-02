Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1784530CBD1
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhBBTgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:36:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhBBN4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B8BC64F68;
        Tue,  2 Feb 2021 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273504;
        bh=ixivgIlh1IPA3J4TEhtPXAxoNvXYrtmJTO/IyMq+rPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSvXa5k+Mct99xa7v10WGBKmlOJF0i12oCIIhyGE3BFNV8iw0Oz/X7lTFACwrGFd7
         HBaeV0EaRqlZosUS6r4PO78/aCBn/EfIxzkH9z2wgsts2qERtFyGXb5xfYMY1hljl1
         cIKb+QmlyHZAYrnMm8Hm4X2YgO34vaUMaq4weyc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/142] selftests: forwarding: Specify interface when invoking mausezahn
Date:   Tue,  2 Feb 2021 14:38:14 +0100
Message-Id: <20210202133003.098725784@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 11df27f7fdf02cc2bb354358ad482e1fdd690589 ]

Specify the interface through which packets should be transmitted so
that the test will pass regardless of the libnet version against which
mausezahn is linked.

Fixes: cab14d1087d9 ("selftests: Add version of router_multipath.sh using nexthop objects")
Fixes: 3d578d879517 ("selftests: forwarding: Test IPv4 weighted nexthops")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh  | 2 +-
 tools/testing/selftests/net/forwarding/router_multipath.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
index cf3d26c233e8e..7fcc42bc076fa 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -197,7 +197,7 @@ multipath4_test()
 	t0_rp12=$(link_stats_tx_packets_get $rp12)
 	t0_rp13=$(link_stats_tx_packets_get $rp13)
 
-	ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+	ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
 		-d 1msec -t udp "sp=1024,dp=0-32768"
 
 	t1_rp12=$(link_stats_tx_packets_get $rp12)
diff --git a/tools/testing/selftests/net/forwarding/router_multipath.sh b/tools/testing/selftests/net/forwarding/router_multipath.sh
index 79a2099279621..464821c587a5e 100755
--- a/tools/testing/selftests/net/forwarding/router_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/router_multipath.sh
@@ -178,7 +178,7 @@ multipath4_test()
        t0_rp12=$(link_stats_tx_packets_get $rp12)
        t0_rp13=$(link_stats_tx_packets_get $rp13)
 
-       ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+       ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
 	       -d 1msec -t udp "sp=1024,dp=0-32768"
 
        t1_rp12=$(link_stats_tx_packets_get $rp12)
-- 
2.27.0



