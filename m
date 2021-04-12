Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6988635C075
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhDLJNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240452AbhDLJKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EE4F61289;
        Mon, 12 Apr 2021 09:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218328;
        bh=lEtLlb9EoMAhUEVuAL2lnNl+VZqoT0wbG0UZtNm/nu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kldW4xfDpLK5LIQZv0N8wd56pCBrL0j8bDjWglx3nZYL5/mcZt4TKjEgoVEd5eFkt
         usW1EaurYUwAbs0nezN39n+x3v6jcAKhs7g7aME7FBM/MKGOFIcUDyJ6MVDKi0VxUN
         48neanB48L5tMj+xKUmwCW5l4Mfg0TxDopD1JbJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 129/210] mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
Date:   Mon, 12 Apr 2021 10:40:34 +0200
Message-Id: <20210412084020.316559621@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 66167c310deb4ac1725f81004fb4b504676ad0bf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h    | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |  7 +++----
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.c    |  7 +++----
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a6956cfc9cb1..4399c9a4999d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -21,6 +21,7 @@
 #include <net/red.h>
 #include <net/vxlan.h>
 #include <net/flow_offload.h>
+#include <net/inet_ecn.h>
 
 #include "port.h"
 #include "core.h"
@@ -346,6 +347,20 @@ struct mlxsw_sp_port_type_speed_ops {
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



