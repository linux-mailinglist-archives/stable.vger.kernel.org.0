Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844DD76E08
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388149AbfGZP2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388137AbfGZP2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 219F622CBF;
        Fri, 26 Jul 2019 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154922;
        bh=v7Xqxq0QTqHQrs+EEZYLm0GJ7qSjUp75lZ9u4crDjOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8ormoSBkh07mv/CLje04iVl2omwkDp1gsMTUVi3Yx8A2Z4kWynmn+FJDphBQJgdg
         pvfnLHmQ1PhwUn0h1tUfdodtkIplykTnzAswmovnKV8SAP08F5DvDGYn+Hl+tsvfYk
         prSCCsnoD85+oq+Z9xiHH5lRlBJLVREs8RmQD/mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Alex Kushnarov <alexanderk@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 46/66] mlxsw: spectrum: Do not process learned records with a dummy FID
Date:   Fri, 26 Jul 2019 17:24:45 +0200
Message-Id: <20190726152306.957806093@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 577fa14d210073ba1ce6237c659a8820312104ad ]

The switch periodically sends notifications about learned FDB entries.
Among other things, the notification includes the FID (Filtering
Identifier) and the port on which the MAC was learned.

In case the driver does not have the FID defined on the relevant port,
the following error will be periodically generated:

mlxsw_spectrum2 0000:06:00.0 swp32: Failed to find a matching {Port, VID} following FDB notification

This is not supposed to happen under normal conditions, but can happen
if an ingress tc filter with a redirect action is installed on a bridged
port. The redirect action will cause the packet's FID to be changed to
the dummy FID and a learning notification will be emitted with this FID
- which is not defined on the bridged port.

Fix this by having the driver ignore learning notifications generated
with the dummy FID and delete them from the device.

Another option is to chain an ignore action after the redirect action
which will cause the device to disable learning, but this means that we
need to consume another action whenever a redirect action is used. In
addition, the scenario described above is merely a corner case.

Fixes: cedbb8b25948 ("mlxsw: spectrum_flower: Set dummy FID before forward action")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h           |    1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c       |   10 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |    6 ++++++
 3 files changed, 17 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -805,6 +805,7 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_
 			   struct tc_prio_qopt_offload *p);
 
 /* spectrum_fid.c */
+bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
 bool mlxsw_sp_fid_lag_vid_valid(const struct mlxsw_sp_fid *fid);
 struct mlxsw_sp_fid *mlxsw_sp_fid_lookup_by_index(struct mlxsw_sp *mlxsw_sp,
 						  u16 fid_index);
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -126,6 +126,16 @@ static const int *mlxsw_sp_packet_type_s
 	[MLXSW_SP_FLOOD_TYPE_MC]	= mlxsw_sp_sfgc_mc_packet_types,
 };
 
+bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index)
+{
+	enum mlxsw_sp_fid_type fid_type = MLXSW_SP_FID_TYPE_DUMMY;
+	struct mlxsw_sp_fid_family *fid_family;
+
+	fid_family = mlxsw_sp->fid_core->fid_family_arr[fid_type];
+
+	return fid_family->start_index == fid_index;
+}
+
 bool mlxsw_sp_fid_lag_vid_valid(const struct mlxsw_sp_fid *fid)
 {
 	return fid->fid_family->lag_vid_valid;
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2468,6 +2468,9 @@ static void mlxsw_sp_fdb_notify_mac_proc
 		goto just_remove;
 	}
 
+	if (mlxsw_sp_fid_is_dummy(mlxsw_sp, fid))
+		goto just_remove;
+
 	mlxsw_sp_port_vlan = mlxsw_sp_port_vlan_find_by_fid(mlxsw_sp_port, fid);
 	if (!mlxsw_sp_port_vlan) {
 		netdev_err(mlxsw_sp_port->dev, "Failed to find a matching {Port, VID} following FDB notification\n");
@@ -2527,6 +2530,9 @@ static void mlxsw_sp_fdb_notify_mac_lag_
 		goto just_remove;
 	}
 
+	if (mlxsw_sp_fid_is_dummy(mlxsw_sp, fid))
+		goto just_remove;
+
 	mlxsw_sp_port_vlan = mlxsw_sp_port_vlan_find_by_fid(mlxsw_sp_port, fid);
 	if (!mlxsw_sp_port_vlan) {
 		netdev_err(mlxsw_sp_port->dev, "Failed to find a matching {Port, VID} following FDB notification\n");


