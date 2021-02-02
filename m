Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7A30CA24
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbhBBSjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhBBOEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:04:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A4664F05;
        Tue,  2 Feb 2021 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273711;
        bh=QpPd2qsHv/OkvsF+JfonwJ9VGA9EyEEFRiKSNRinuEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Edml52JL8OVZl32BE0gDS3x7NcqWrDDy5NT4QfvyiLebGvLhYFHcu6TAu1cxn7qss
         cijEV7pjYC4OmXvOnISNMekdcBig9K8cerZpL6R3WmzDRXfy3i1dU92q6klo8Hj6qv
         nePSMYx0Z/oWFgapIPLR8Q+1JbOOOtqYaVf2zwy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/61] selftests: forwarding: Specify interface when invoking mausezahn
Date:   Tue,  2 Feb 2021 14:38:31 +0100
Message-Id: <20210202132948.725459248@linuxfoundation.org>
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
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh  |    2 +-
 tools/testing/selftests/net/forwarding/router_multipath.sh |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -197,7 +197,7 @@ multipath4_test()
 	t0_rp12=$(link_stats_tx_packets_get $rp12)
 	t0_rp13=$(link_stats_tx_packets_get $rp13)
 
-	ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+	ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
 		-d 1msec -t udp "sp=1024,dp=0-32768"
 
 	t1_rp12=$(link_stats_tx_packets_get $rp12)
--- a/tools/testing/selftests/net/forwarding/router_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/router_multipath.sh
@@ -178,7 +178,7 @@ multipath4_test()
        t0_rp12=$(link_stats_tx_packets_get $rp12)
        t0_rp13=$(link_stats_tx_packets_get $rp13)
 
-       ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+       ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
 	       -d 1msec -t udp "sp=1024,dp=0-32768"
 
        t1_rp12=$(link_stats_tx_packets_get $rp12)


