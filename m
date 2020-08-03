Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F723A498
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgHCM2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728813AbgHCM2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADCE7204EC;
        Mon,  3 Aug 2020 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457725;
        bh=0b1m8mb7itROJ1ZHdgaojuDN/beK+yioDRLDQoJtnio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+AlVrpIxwaN82YVqYilw2g5btq3lxPQznBIoG1Tf5+axbQpLr00OuxBJPoU9e0oI
         RCKNTqcPlTR15Ft7BrW9taDYgrNCTAT4glrHk3psgH0BZiapI+Xt5jws4b1XB9vNNd
         sypZ1zQ/9VRmWrQVrGeuLzsGlUDLDerlMsHK7n5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/90] net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev
Date:   Mon,  3 Aug 2020 14:19:13 +0200
Message-Id: <20200803121900.093304188@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit 350a63249d270b1f5bd05c7e2a24cd8de0f9db20 ]

After the cited commit, function 'mlx5_eswitch_set_vport_vlan' started
to acquire esw->state_lock.
However, esw is not defined for VF devices, hence attempting to set vf
VLANID on a VF dev will cause a kernel panic.

Fix it by moving up the (redundant) esw validation from function
'__mlx5_eswitch_set_vport_vlan' since the rest of the callers now have
and use a valid esw.

For example with vf device eth4:
 # ip link set dev eth4 vf 0 vlan 0

Trace of the panic:
 [  411.409842] BUG: unable to handle page fault for address: 00000000000011b8
 [  411.449745] #PF: supervisor read access in kernel mode
 [  411.452348] #PF: error_code(0x0000) - not-present page
 [  411.454938] PGD 80000004189c9067 P4D 80000004189c9067 PUD 41899a067 PMD 0
 [  411.458382] Oops: 0000 [#1] SMP PTI
 [  411.460268] CPU: 4 PID: 5711 Comm: ip Not tainted 5.8.0-rc4_for_upstream_min_debug_2020_07_08_22_04 #1
 [  411.462447] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 [  411.464158] RIP: 0010:__mutex_lock+0x4e/0x940
 [  411.464928] Code: fd 41 54 49 89 f4 41 52 53 89 d3 48 83 ec 70 44 8b 1d ee 03 b0 01 65 48 8b 04 25 28 00 00 00 48 89 45 c8 31 c0 45 85 db 75 0a <48> 3b 7f 60 0f 85 7e 05 00 00 49 8d 45 68 41 56 41 b8 01 00 00 00
 [  411.467678] RSP: 0018:ffff88841fcd74b0 EFLAGS: 00010246
 [  411.468562] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 [  411.469715] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000001158
 [  411.470812] RBP: ffff88841fcd7550 R08: ffffffffa00fa1ce R09: 0000000000000000
 [  411.471835] R10: ffff88841fcd7570 R11: 0000000000000000 R12: 0000000000000002
 [  411.472862] R13: 0000000000001158 R14: ffffffffa00fa1ce R15: 0000000000000000
 [  411.474004] FS:  00007faee7ca6b80(0000) GS:ffff88846fc00000(0000) knlGS:0000000000000000
 [  411.475237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  411.476129] CR2: 00000000000011b8 CR3: 000000041909c006 CR4: 0000000000360ea0
 [  411.477260] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [  411.478340] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [  411.479332] Call Trace:
 [  411.479760]  ? __nla_validate_parse.part.6+0x57/0x8f0
 [  411.482825]  ? mlx5_eswitch_set_vport_vlan+0x3e/0xa0 [mlx5_core]
 [  411.483804]  mlx5_eswitch_set_vport_vlan+0x3e/0xa0 [mlx5_core]
 [  411.484733]  mlx5e_set_vf_vlan+0x41/0x50 [mlx5_core]
 [  411.485545]  do_setlink+0x613/0x1000
 [  411.486165]  __rtnl_newlink+0x53d/0x8c0
 [  411.486791]  ? mark_held_locks+0x49/0x70
 [  411.487429]  ? __lock_acquire+0x8fe/0x1eb0
 [  411.488085]  ? rcu_read_lock_sched_held+0x52/0x60
 [  411.488998]  ? kmem_cache_alloc_trace+0x16d/0x2d0
 [  411.489759]  rtnl_newlink+0x47/0x70
 [  411.490357]  rtnetlink_rcv_msg+0x24e/0x450
 [  411.490978]  ? netlink_deliver_tap+0x92/0x3d0
 [  411.491631]  ? validate_linkmsg+0x330/0x330
 [  411.492262]  netlink_rcv_skb+0x47/0x110
 [  411.492852]  netlink_unicast+0x1ac/0x270
 [  411.493551]  netlink_sendmsg+0x336/0x450
 [  411.494209]  sock_sendmsg+0x30/0x40
 [  411.494779]  ____sys_sendmsg+0x1dd/0x1f0
 [  411.495378]  ? copy_msghdr_from_user+0x5c/0x90
 [  411.496082]  ___sys_sendmsg+0x87/0xd0
 [  411.496683]  ? lock_acquire+0xb9/0x3a0
 [  411.497322]  ? lru_cache_add+0x5/0x170
 [  411.497944]  ? find_held_lock+0x2d/0x90
 [  411.498568]  ? handle_mm_fault+0xe46/0x18c0
 [  411.499205]  ? __sys_sendmsg+0x51/0x90
 [  411.499784]  __sys_sendmsg+0x51/0x90
 [  411.500341]  do_syscall_64+0x59/0x2e0
 [  411.500938]  ? asm_exc_page_fault+0x8/0x30
 [  411.501609]  ? rcu_read_lock_sched_held+0x52/0x60
 [  411.502350]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [  411.503093] RIP: 0033:0x7faee73b85a7
 [  411.503654] Code: Bad RIP value.

Fixes: 0e18134f4f9f ("net/mlx5e: Eswitch, use state_lock to synchronize vlan change")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6b711affb7da4..8e6ab82019398 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2155,8 +2155,6 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
-		return -EPERM;
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
 	if (vlan > 4095 || qos > 7)
@@ -2184,6 +2182,9 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	u8 set_flags = 0;
 	int err;
 
+	if (!ESW_ALLOWED(esw))
+		return -EPERM;
+
 	if (vlan || qos)
 		set_flags = SET_VLAN_STRIP | SET_VLAN_INSERT;
 
-- 
2.25.1



