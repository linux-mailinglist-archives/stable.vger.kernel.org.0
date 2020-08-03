Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E33623A68F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgHCMtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgHCMYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EAF5204EC;
        Mon,  3 Aug 2020 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457452;
        bh=et039MEu/JZv75gwsVathHW/qTIeunWTRegEb9QD3qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Es9/HtwtRPz4091GarMCNhwNmO9tii5Q38c4/kEuNnSchcQ1kb/xghFTnjHYMkETc
         KS9J1dXKRvmN41HFg9pHylaGi3UQuIBmzdVB0wByDjGmTQ1uE3l5i1Gg5smovkomES
         bDLnFxXOfWWMojVWQmzDAXmp1vqKCKQHnh8N8K48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 073/120] mlxsw: spectrum_router: Fix use-after-free in router init / de-init
Date:   Mon,  3 Aug 2020 14:18:51 +0200
Message-Id: <20200803121906.355050324@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 5515c3448d55bdcb5ff8a1778aa84f34e4205596 ]

Several notifiers are registered as part of router initialization.
Since some of these notifiers are registered before the end of the
initialization, it is possible for them to access uninitialized or freed
memory when processing notifications [1].

Additionally, some of these notifiers queue work items on a workqueue.
If these work items are executed after the router was de-initialized,
they will access freed memory.

Fix both problems by moving the registration of the notifiers to the end
of the router initialization and flush the work queue after they are
unregistered.

[1]
BUG: KASAN: use-after-free in __mutex_lock_common kernel/locking/mutex.c:938 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0xeea/0x1340 kernel/locking/mutex.c:1103
Read of size 8 at addr ffff888038c3a6e0 by task kworker/u4:1/61

CPU: 1 PID: 61 Comm: kworker/u4:1 Not tainted 5.8.0-rc2+ #36
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: mlxsw_core_ordered mlxsw_sp_inet6addr_event_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __mutex_lock_common kernel/locking/mutex.c:938 [inline]
 __mutex_lock+0xeea/0x1340 kernel/locking/mutex.c:1103
 mlxsw_sp_inet6addr_event_work+0xb3/0x1b0 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:7123
 process_one_work+0xa3e/0x17a0 kernel/workqueue.c:2269
 worker_thread+0x9e/0x1050 kernel/workqueue.c:2415
 kthread+0x355/0x470 kernel/kthread.c:291
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 1298:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:467
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 mlxsw_sp_router_init+0xb2/0x1d20 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:8074
 mlxsw_sp_init+0xbd8/0x3ac0 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:2932
 __mlxsw_core_bus_device_register+0x657/0x10d0 drivers/net/ethernet/mellanox/mlxsw/core.c:1375
 mlxsw_core_bus_device_register drivers/net/ethernet/mellanox/mlxsw/core.c:1436 [inline]
 mlxsw_devlink_core_bus_device_reload_up+0xcd/0x150 drivers/net/ethernet/mellanox/mlxsw/core.c:1133
 devlink_reload net/core/devlink.c:2959 [inline]
 devlink_reload+0x281/0x3b0 net/core/devlink.c:2944
 devlink_nl_cmd_reload+0x2f1/0x7c0 net/core/devlink.c:2987
 genl_family_rcv_msg_doit net/netlink/genetlink.c:691 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:736 [inline]
 genl_rcv_msg+0x611/0x9d0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:672
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2363
 ___sys_sendmsg+0xff/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 1348:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x12c/0x170 mm/kasan/common.c:455
 slab_free_hook mm/slub.c:1474 [inline]
 slab_free_freelist_hook mm/slub.c:1507 [inline]
 slab_free mm/slub.c:3072 [inline]
 kfree+0xe6/0x320 mm/slub.c:4063
 mlxsw_sp_fini+0x340/0x4e0 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3132
 mlxsw_core_bus_device_unregister+0x16c/0x6d0 drivers/net/ethernet/mellanox/mlxsw/core.c:1474
 mlxsw_devlink_core_bus_device_reload_down+0x8e/0xc0 drivers/net/ethernet/mellanox/mlxsw/core.c:1123
 devlink_reload+0xc6/0x3b0 net/core/devlink.c:2952
 devlink_nl_cmd_reload+0x2f1/0x7c0 net/core/devlink.c:2987
 genl_family_rcv_msg_doit net/netlink/genetlink.c:691 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:736 [inline]
 genl_rcv_msg+0x611/0x9d0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:672
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2363
 ___sys_sendmsg+0xff/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888038c3a000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1760 bytes inside of
 2048-byte region [ffff888038c3a000, ffff888038c3a800)
The buggy address belongs to the page:
page:ffffea0000e30e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0000e30e00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x100000000010200(slab|head)
raw: 0100000000010200 dead000000000100 dead000000000122 ffff88806c40c000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888038c3a580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888038c3a600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888038c3a680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888038c3a700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888038c3a780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 965fa8e600d2 ("mlxsw: spectrum_router: Make RIF deletion more robust")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 50 ++++++++++---------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 84b3d78a9dd84..ac1a63fe0899c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8072,16 +8072,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp->router = router;
 	router->mlxsw_sp = mlxsw_sp;
 
-	router->inetaddr_nb.notifier_call = mlxsw_sp_inetaddr_event;
-	err = register_inetaddr_notifier(&router->inetaddr_nb);
-	if (err)
-		goto err_register_inetaddr_notifier;
-
-	router->inet6addr_nb.notifier_call = mlxsw_sp_inet6addr_event;
-	err = register_inet6addr_notifier(&router->inet6addr_nb);
-	if (err)
-		goto err_register_inet6addr_notifier;
-
 	INIT_LIST_HEAD(&mlxsw_sp->router->nexthop_neighs_list);
 	err = __mlxsw_sp_router_init(mlxsw_sp);
 	if (err)
@@ -8122,12 +8112,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_neigh_init;
 
-	mlxsw_sp->router->netevent_nb.notifier_call =
-		mlxsw_sp_router_netevent_event;
-	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
-	if (err)
-		goto err_register_netevent_notifier;
-
 	err = mlxsw_sp_mp_hash_init(mlxsw_sp);
 	if (err)
 		goto err_mp_hash_init;
@@ -8136,6 +8120,22 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_dscp_init;
 
+	router->inetaddr_nb.notifier_call = mlxsw_sp_inetaddr_event;
+	err = register_inetaddr_notifier(&router->inetaddr_nb);
+	if (err)
+		goto err_register_inetaddr_notifier;
+
+	router->inet6addr_nb.notifier_call = mlxsw_sp_inet6addr_event;
+	err = register_inet6addr_notifier(&router->inet6addr_nb);
+	if (err)
+		goto err_register_inet6addr_notifier;
+
+	mlxsw_sp->router->netevent_nb.notifier_call =
+		mlxsw_sp_router_netevent_event;
+	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
+	if (err)
+		goto err_register_netevent_notifier;
+
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
 	err = register_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &mlxsw_sp->router->fib_nb,
@@ -8146,10 +8146,15 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_register_fib_notifier:
-err_dscp_init:
-err_mp_hash_init:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
+	unregister_inet6addr_notifier(&router->inet6addr_nb);
+err_register_inet6addr_notifier:
+	unregister_inetaddr_notifier(&router->inetaddr_nb);
+err_register_inetaddr_notifier:
+	mlxsw_core_flush_owq();
+err_dscp_init:
+err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
 	mlxsw_sp_vrs_fini(mlxsw_sp);
@@ -8168,10 +8173,6 @@ err_ipips_init:
 err_rifs_init:
 	__mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
-	unregister_inet6addr_notifier(&router->inet6addr_nb);
-err_register_inet6addr_notifier:
-	unregister_inetaddr_notifier(&router->inetaddr_nb);
-err_register_inetaddr_notifier:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 	return err;
@@ -8182,6 +8183,9 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				&mlxsw_sp->router->fib_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
+	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
+	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
+	mlxsw_core_flush_owq();
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
@@ -8191,8 +8195,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_ipips_fini(mlxsw_sp);
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
-	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
-	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
-- 
2.25.1



