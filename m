Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94A3CAA47
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbhGOTMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243856AbhGOTKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 570A7613E9;
        Thu, 15 Jul 2021 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376014;
        bh=fxBHdb0T7ORVgvgqL2tjLN24+oX8jHSX0AAW8RQHIsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFD97R5ddwGVPPdap4GfcFnVXTNEQMUAquGQsKPjOkNFFSQnC9rpfDGrzQ7QcD4kk
         eT3cuB8BMFrWEnBDJTmnS/ZKxRH7OfRdwSQ/IQqTvrGRgR8pl9CttPeJeaYp1manA0
         GKUHEJdSB79s12TqUX322H0qKDkZXo+xNnTFLitU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 090/266] selftests: Clean forgotten resources as part of cleanup()
Date:   Thu, 15 Jul 2021 20:37:25 +0200
Message-Id: <20210715182630.078719226@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit e67dfb8d15deb33c425d0b0ee22f2e5eef54c162 ]

Several tests do not set some ports down as part of their cleanup(),
resulting in IPv6 link-local addresses and associated routes not being
deleted.

These leaks were found using a BPF tool that monitors ASIC resources.

Solve this by setting the ports down at the end of the tests.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh       | 3 +++
 .../selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh  | 3 +++
 tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh   | 2 ++
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh        | 2 ++
 tools/testing/selftests/net/forwarding/pedit_l4port.sh         | 2 ++
 tools/testing/selftests/net/forwarding/skbedit_priority.sh     | 2 ++
 6 files changed, 14 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index 4029833f7e27..160891dcb4bc 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -109,6 +109,9 @@ router_destroy()
 	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
 
 	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
 }
 
 setup_prepare()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
index 42d44e27802c..190c1b6b5365 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
@@ -111,6 +111,9 @@ router_destroy()
 	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
 
 	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
 }
 
 setup_prepare()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
index 5cbff8038f84..28a570006d4d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
@@ -93,7 +93,9 @@ switch_destroy()
 	lldptool -T -i $swp1 -V APP -d $(dscp_map 10) >/dev/null
 	lldpad_app_wait_del
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index 55eeacf59241..64fbd211d907 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -75,7 +75,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/pedit_l4port.sh b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
index 5f20d289ee43..10e594c55117 100755
--- a/tools/testing/selftests/net/forwarding/pedit_l4port.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
@@ -71,7 +71,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/skbedit_priority.sh b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
index e3bd8a6bb8b4..bde11dc27873 100755
--- a/tools/testing/selftests/net/forwarding/skbedit_priority.sh
+++ b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
@@ -72,7 +72,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
-- 
2.30.2



