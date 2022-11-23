Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54738635857
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiKWJz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbiKWJyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:54:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C882F5BD58
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80655B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34E1C433D6;
        Wed, 23 Nov 2022 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197023;
        bh=Htk4lFxlXUqXg8iR+lbYeuN9dR1Zr7JJCzLfbNd3l7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb8Jni1fBLSIWgRw1ULgpU2hVaq8Pp9/d7aizk/OrdFnQO8hOd6sbkyc25WHJXstb
         jxLbzOBKWpv4QccxkFBVTOvLsYogGmG3L6CZsjLjpzxEHOyNDiu5lWVdPdw9+ZXdXt
         AM6KOzwytBqgaRFaB42OH2cxYLcoUybN2JJ+sWJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 169/314] mlxsw: Avoid warnings when not offloaded FDB entry with IPv6 is removed
Date:   Wed, 23 Nov 2022 09:50:14 +0100
Message-Id: <20221123084633.227775978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 30f5312d2c722107364f266cfa98ef4f0857c1fb ]

FDB entries that perform VXLAN encapsulation with an IPv6 underlay hold
a reference on a resource - the KVDL entry where the IPv6 underlay
destination IP is stored. For that, the driver maintains two hash tables:
1. Maps IPv6 to KVDL index
2. Maps {MAC, FID index} to IPv6 address

When a FDB entry is removed, the second table is used to find the relevant
IPv6 address and the first table is used to remove the reference count and
free the index if is not used anymore.

In order for a packet to be forwarded to a single remote VTEP, FDB
entries need to be configured at both the bridge and VXLAN devices' FDB
tables. Both entries are squashed into one {MAC, VLAN/VNI} -> IP entry
in the hardware. Therefore, in case one entry is removed, the entry will
be removed from the hardware and the remaining entry will be unmarked
with 'offload' flag since it is not offloaded anymore.

For example, the two FDB entries should be added to allow packets to be
forwarded via vx10:
$ bridge fdb add dev vx10 aa:bb:cc:dd:ee:ff self static dst 2001:db8:5::1
$ bridge fdb add dev vx10 aa:bb:cc:dd:ee:ff master static vlan 10

When one entry will be removed, the second one will not be offloaded
anymore. When the first entry (in VXLAN FDB) will be removed / will not be
offloaded anymore, the two mappings in IPv6 hash tables will be removed.

In case that the second entry is removed before the first one, unexpected
warnings[1][2] will be shown in user space as a result of removing the
first entry. The issue is that not offloaded entry is removed, the driver
tries to search the relevant entries in the hash tables, does not find them
and therefore warns.

Do not handle removing of not offloaded VXLAN FDB entries, as they were
already removed when the offload flag was removed.

[1]:
WARNING: CPU: 1 PID: 239 at drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c:914 mlxsw_sp_nve_ipv6_addr_map_del+0x6b/0x80 [mlxsw_spectrum]
...
Hardware name: Mellanox Technologies Ltd. Mellanox switch/Mellanox switch, BIOS 4.6.5 05/21/2015
Workqueue: mlxsw_core_ordered mlxsw_sp_switchdev_vxlan_fdb_event_work [mlxsw_spectrum]
RIP: 0010:mlxsw_sp_nve_ipv6_addr_map_del+0x6b/0x80 [mlxsw_spectrum]
...
Call Trace:
  <TASK>
  mlxsw_sp_port_fdb_tunnel_uc_op+0x6cf/0x7b0 [mlxsw_spectrum]
  mlxsw_sp_switchdev_vxlan_fdb_event_work+0x17c/0x420 [mlxsw_spectrum]
  ? finish_task_switch.isra.0+0x8c/0x290
  process_one_work+0x1cd/0x390
  worker_thread+0x48/0x3c0
  ? process_one_work+0x390/0x390
  kthread+0xe0/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

[2]:
WARNING: CPU: 0 PID: 239 at drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3035 mlxsw_sp_ipv6_addr_put+0x142/0x220 [mlxsw_spectrum]
...
Hardware name: Mellanox Technologies Ltd. Mellanox switch/Mellanox switch, BIOS 4.6.5 05/21/2015
Workqueue: mlxsw_core_ordered mlxsw_sp_switchdev_vxlan_fdb_event_work [mlxsw_spectrum]
RIP: 0010:mlxsw_sp_ipv6_addr_put+0x142/0x220 [mlxsw_spectrum]
...
Call Trace:
  <TASK>
  ? mlxsw_sp_port_fdb_tun_uc_op6_sfd_write+0x5c1/0x610 [mlxsw_spectrum]
  mlxsw_sp_port_fdb_tunnel_uc_op+0x6ec/0x7b0 [mlxsw_spectrum]
  mlxsw_sp_switchdev_vxlan_fdb_event_work+0x17c/0x420 [mlxsw_spectrum]
  ? finish_task_switch.isra.0+0x8c/0x290
  process_one_work+0x1cd/0x390
  worker_thread+0x48/0x3c0
  ? process_one_work+0x390/0x390
  kthread+0xe0/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

Fixes: 0860c7641634 ("mlxsw: spectrum_nve: Keep track of IPv6 addresses used by FDB entries")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/c186de8cbd28e3eb661e06f31f7f2f2dff30020f.1668184350.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 4efccd942fb8..1290b2d3eae6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3470,6 +3470,8 @@ mlxsw_sp_switchdev_vxlan_fdb_del(struct mlxsw_sp *mlxsw_sp,
 	u16 vid;
 
 	vxlan_fdb_info = &switchdev_work->vxlan_fdb_info;
+	if (!vxlan_fdb_info->offloaded)
+		return;
 
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)
-- 
2.35.1



