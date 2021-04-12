Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7149F35B886
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbhDLCXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235857AbhDLCXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0454F61208;
        Mon, 12 Apr 2021 02:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194175;
        bh=s+Kdbp7Q035U4fGFj0LwJ0VXsS3OH88tx5a+XNSUZU8=;
        h=From:To:Cc:Subject:Date:From;
        b=RTPWVHnftQcqQtfvXOVOJP7YXrySTltPflmsjeSFjDcG8pGYNS7ld/b+dLht8rhjr
         R351W8NY+CqRLXmpoFQi7d30Uy+/onQX1wbr2MzRPN9NQW90XO9DJGCi4pmZ0MiHic
         ZXbUB5GGPaO3kdsLHsb3ZXvNLCRmEk8d6P7hhCZ3DDyFM/FPPU0gJLXlbyDpBTHhGf
         s9O86ErRshqiLSkDuFzunOqt1a54es4rOyJEXOc4WOTNqd3UxH1BvP/eUl1Cm2auFF
         hVSDh7B6vYK6rCWwfeiIHVHpXJX1SroCmacbGa5lq7f+Gkb7tLEAHs/NgTBECk7e4Q
         cE2Jy1yl7EtVg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, idosch@nvidia.com
Cc:     Petr Machata <petrm@nvidia.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "mlxsw: spectrum: Fix ECN marking in tunnel decapsulation" failed to apply to 5.4-stable tree
Date:   Sun, 11 Apr 2021 22:22:53 -0400
Message-Id: <20210412022253.283411-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 66167c310deb4ac1725f81004fb4b504676ad0bf Mon Sep 17 00:00:00 2001
From: Ido Schimmel <idosch@nvidia.com>
Date: Mon, 29 Mar 2021 11:29:23 +0300
Subject: [PATCH] mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Cited commit changed the behavior of the software data path with regards
to the ECN marking of decapsulated packets. However, the commit did not
change other callers of __INET_ECN_decapsulate(), namely mlxsw. The
driver is using the function in order to ensure that the hardware and
software data paths act the same with regards to the ECN marking of
decapsulated packets.

The discrepancy was uncovered by commit 5aa3c334a449 ("selftests:
forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value") that
aligned the selftest to the new behavior. Without this patch the
selftest passes when used with veth pairs, but fails when used with
mlxsw netdevs.

Fix this by instructing the device to propagate the ECT(1) mark from the
outer header to the inner header when the inner header is ECT(0), for
both NVE and IP-in-IP tunnels.

A helper is added in order not to duplicate the code between both tunnel
types.

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h    | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |  7 +++----
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.c    |  7 +++----
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index d9d9e1f488f9..ba28ac7e79bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -21,6 +21,7 @@
 #include <net/red.h>
 #include <net/vxlan.h>
 #include <net/flow_offload.h>
+#include <net/inet_ecn.h>
 
 #include "port.h"
 #include "core.h"
@@ -347,6 +348,20 @@ struct mlxsw_sp_port_type_speed_ops {
 	u32 (*ptys_proto_cap_masked_get)(u32 eth_proto_cap);
 };
 
+static inline u8 mlxsw_sp_tunnel_ecn_decap(u8 outer_ecn, u8 inner_ecn,
+					   bool *trap_en)
+{
+	bool set_ce = false;
+
+	*trap_en = !!__INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
+	if (set_ce)
+		return INET_ECN_CE;
+	else if (outer_ecn == INET_ECN_ECT_1 && inner_ecn == INET_ECN_ECT_0)
+		return INET_ECN_ECT_1;
+	else
+		return inner_ecn;
+}
+
 static inline struct net_device *
 mlxsw_sp_bridge_vxlan_dev_find(struct net_device *br_dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 6ccca39bae84..64a8f838eb53 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -335,12 +335,11 @@ static int mlxsw_sp_ipip_ecn_decap_init_one(struct mlxsw_sp *mlxsw_sp,
 					    u8 inner_ecn, u8 outer_ecn)
 {
 	char tidem_pl[MLXSW_REG_TIDEM_LEN];
-	bool trap_en, set_ce = false;
 	u8 new_inner_ecn;
+	bool trap_en;
 
-	trap_en = __INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
-	new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
-
+	new_inner_ecn = mlxsw_sp_tunnel_ecn_decap(outer_ecn, inner_ecn,
+						  &trap_en);
 	mlxsw_reg_tidem_pack(tidem_pl, outer_ecn, inner_ecn, new_inner_ecn,
 			     trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tidem), tidem_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index e5ec595593f4..9eba8fa684ae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -909,12 +909,11 @@ static int __mlxsw_sp_nve_ecn_decap_init(struct mlxsw_sp *mlxsw_sp,
 					 u8 inner_ecn, u8 outer_ecn)
 {
 	char tndem_pl[MLXSW_REG_TNDEM_LEN];
-	bool trap_en, set_ce = false;
 	u8 new_inner_ecn;
+	bool trap_en;
 
-	trap_en = !!__INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
-	new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
-
+	new_inner_ecn = mlxsw_sp_tunnel_ecn_decap(outer_ecn, inner_ecn,
+						  &trap_en);
 	mlxsw_reg_tndem_pack(tndem_pl, outer_ecn, inner_ecn, new_inner_ecn,
 			     trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tndem), tndem_pl);
-- 
2.30.2




