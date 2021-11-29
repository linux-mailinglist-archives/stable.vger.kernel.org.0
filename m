Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4E446279C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhK2XIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbhK2XHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CEDC047CC7;
        Mon, 29 Nov 2021 10:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C3D2CE13BF;
        Mon, 29 Nov 2021 18:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C97C53FAD;
        Mon, 29 Nov 2021 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210669;
        bh=qqGrbcGVrxOtYzcrT2uofG8twxs4Hp89a+h6rBzGc1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1yoo1AHnYa1p6SzEHpSWDfeERL+V5RBS9Ya5jM4FoPUcyYWF7NLQXtPq549u8gu/
         +Sp8IJMJKQzZCS15P5yPEaPqvGz1IydwOClnEk2CA49dCnrNnYBGQ3+VufSSrVKDcI
         wxNYqI2wbKngtGpkTRwOolGDzpVeglyK2hc37LqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/121] mlxsw: Verify the accessed index doesnt exceed the array length
Date:   Mon, 29 Nov 2021 19:18:27 +0100
Message-Id: <20211129181714.208789922@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 837ec05cfea08284c575e8e834777b107da5ff9d ]

There are few cases in which an array index queried from a fw register,
is accessed without any validation that it doesn't exceed the array
length.

Add a proper length validation, so accessing memory past the end of an
array will be forbidden.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c            | 4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           | 5 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c       | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 4 ++++
 5 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index c010db2c9dba9..443dc44452ef8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -234,6 +234,7 @@ static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u8 local_port)
 static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
 				   u8 *last_module)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
 	u8 module, width;
 	int err;
 
@@ -249,6 +250,9 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
 	if (module == *last_module)
 		return 0;
 	*last_module = module;
+
+	if (WARN_ON_ONCE(module >= max_ports))
+		return -EINVAL;
 	mlxsw_m->module_to_port[module] = ++mlxsw_m->max_ports;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b08853f71b2be..1a9978f501ba9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2052,9 +2052,14 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum mlxsw_reg_pude_oper_status status;
+	unsigned int max_ports;
 	u8 local_port;
 
+	max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	local_port = mlxsw_reg_pude_local_port_get(pude_pl);
+
+	if (WARN_ON_ONCE(local_port >= max_ports))
+		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index ca8090a28dec6..50eca2daad843 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -568,10 +568,13 @@ void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
 				 u8 domain_number, u16 sequence_id,
 				 u64 timestamp)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp1_ptp_key key;
 	u8 types;
 
+	if (WARN_ON_ONCE(local_port >= max_ports))
+		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4381f8c6c3fb7..53128382fc2e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2177,6 +2177,7 @@ static void mlxsw_sp_router_neigh_ent_ipv4_process(struct mlxsw_sp *mlxsw_sp,
 						   char *rauhtd_pl,
 						   int ent_index)
 {
+	u64 max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 	struct net_device *dev;
 	struct neighbour *n;
 	__be32 dipn;
@@ -2185,6 +2186,8 @@ static void mlxsw_sp_router_neigh_ent_ipv4_process(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_reg_rauhtd_ent_ipv4_unpack(rauhtd_pl, ent_index, &rif, &dip);
 
+	if (WARN_ON_ONCE(rif >= max_rifs))
+		return;
 	if (!mlxsw_sp->router->rifs[rif]) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Incorrect RIF in neighbour entry\n");
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 6501ce94ace58..368fa0e5ad315 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2410,6 +2410,7 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 					    char *sfn_pl, int rec_index,
 					    bool adding)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
@@ -2422,6 +2423,9 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	mlxsw_reg_sfn_mac_unpack(sfn_pl, rec_index, mac, &fid, &local_port);
+
+	if (WARN_ON_ONCE(local_port >= max_ports))
+		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Incorrect local port in FDB notification\n");
-- 
2.33.0



