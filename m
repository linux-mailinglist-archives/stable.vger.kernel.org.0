Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772E9116201
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLHN44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60250 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbfLHNyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0007fH-Qa; Sun, 08 Dec 2019 13:54:39 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0002Ns-G2; Sun, 08 Dec 2019 13:54:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Pirko" <jiri@mellanox.com>,
        "Zhang Rui" <rui.zhang@intel.com>,
        "Ido Schimmel" <idosch@mellanox.com>
Date:   Sun, 08 Dec 2019 13:53:27 +0000
Message-ID: <lsq.1575813165.267246545@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 43/72] thermal: Fix use-after-free when unregistering
 thermal zone device
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@mellanox.com>

commit 1851799e1d2978f68eea5d9dff322e121dcf59c1 upstream.

thermal_zone_device_unregister() cancels the delayed work that polls the
thermal zone, but it does not wait for it to finish. This is racy with
respect to the freeing of the thermal zone device, which can result in a
use-after-free [1].

Fix this by waiting for the delayed work to finish before freeing the
thermal zone device. Note that thermal_zone_device_set_polling() is
never invoked from an atomic context, so it is safe to call
cancel_delayed_work_sync() that can block.

[1]
[  +0.002221] ==================================================================
[  +0.000064] BUG: KASAN: use-after-free in __mutex_lock+0x1076/0x11c0
[  +0.000016] Read of size 8 at addr ffff8881e48e0450 by task kworker/1:0/17

[  +0.000023] CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.2.0-rc6-custom-02495-g8e73ca3be4af #1701
[  +0.000010] Hardware name: Mellanox Technologies Ltd. MSN2100-CB2FO/SA001017, BIOS 5.6.5 06/07/2016
[  +0.000016] Workqueue: events_freezable_power_ thermal_zone_device_check
[  +0.000012] Call Trace:
[  +0.000021]  dump_stack+0xa9/0x10e
[  +0.000020]  print_address_description.cold.2+0x9/0x25e
[  +0.000018]  __kasan_report.cold.3+0x78/0x9d
[  +0.000016]  kasan_report+0xe/0x20
[  +0.000016]  __mutex_lock+0x1076/0x11c0
[  +0.000014]  step_wise_throttle+0x72/0x150
[  +0.000018]  handle_thermal_trip+0x167/0x760
[  +0.000019]  thermal_zone_device_update+0x19e/0x5f0
[  +0.000019]  process_one_work+0x969/0x16f0
[  +0.000017]  worker_thread+0x91/0xc40
[  +0.000014]  kthread+0x33d/0x400
[  +0.000015]  ret_from_fork+0x3a/0x50

[  +0.000020] Allocated by task 1:
[  +0.000015]  save_stack+0x19/0x80
[  +0.000015]  __kasan_kmalloc.constprop.4+0xc1/0xd0
[  +0.000014]  kmem_cache_alloc_trace+0x152/0x320
[  +0.000015]  thermal_zone_device_register+0x1b4/0x13a0
[  +0.000015]  mlxsw_thermal_init+0xc92/0x23d0
[  +0.000014]  __mlxsw_core_bus_device_register+0x659/0x11b0
[  +0.000013]  mlxsw_core_bus_device_register+0x3d/0x90
[  +0.000013]  mlxsw_pci_probe+0x355/0x4b0
[  +0.000014]  local_pci_probe+0xc3/0x150
[  +0.000013]  pci_device_probe+0x280/0x410
[  +0.000013]  really_probe+0x26a/0xbb0
[  +0.000013]  driver_probe_device+0x208/0x2e0
[  +0.000013]  device_driver_attach+0xfe/0x140
[  +0.000013]  __driver_attach+0x110/0x310
[  +0.000013]  bus_for_each_dev+0x14b/0x1d0
[  +0.000013]  driver_register+0x1c0/0x400
[  +0.000015]  mlxsw_sp_module_init+0x5d/0xd3
[  +0.000014]  do_one_initcall+0x239/0x4dd
[  +0.000013]  kernel_init_freeable+0x42b/0x4e8
[  +0.000012]  kernel_init+0x11/0x18b
[  +0.000013]  ret_from_fork+0x3a/0x50

[  +0.000015] Freed by task 581:
[  +0.000013]  save_stack+0x19/0x80
[  +0.000014]  __kasan_slab_free+0x125/0x170
[  +0.000013]  kfree+0xf3/0x310
[  +0.000013]  thermal_release+0xc7/0xf0
[  +0.000014]  device_release+0x77/0x200
[  +0.000014]  kobject_put+0x1a8/0x4c0
[  +0.000014]  device_unregister+0x38/0xc0
[  +0.000014]  thermal_zone_device_unregister+0x54e/0x6a0
[  +0.000014]  mlxsw_thermal_fini+0x184/0x35a
[  +0.000014]  mlxsw_core_bus_device_unregister+0x10a/0x640
[  +0.000013]  mlxsw_devlink_core_bus_device_reload+0x92/0x210
[  +0.000015]  devlink_nl_cmd_reload+0x113/0x1f0
[  +0.000014]  genl_family_rcv_msg+0x700/0xee0
[  +0.000013]  genl_rcv_msg+0xca/0x170
[  +0.000013]  netlink_rcv_skb+0x137/0x3a0
[  +0.000012]  genl_rcv+0x29/0x40
[  +0.000013]  netlink_unicast+0x49b/0x660
[  +0.000013]  netlink_sendmsg+0x755/0xc90
[  +0.000013]  __sys_sendto+0x3de/0x430
[  +0.000013]  __x64_sys_sendto+0xe2/0x1b0
[  +0.000013]  do_syscall_64+0xa4/0x4d0
[  +0.000013]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[  +0.000017] The buggy address belongs to the object at ffff8881e48e0008
               which belongs to the cache kmalloc-2k of size 2048
[  +0.000012] The buggy address is located 1096 bytes inside of
               2048-byte region [ffff8881e48e0008, ffff8881e48e0808)
[  +0.000007] The buggy address belongs to the page:
[  +0.000012] page:ffffea0007923800 refcount:1 mapcount:0 mapping:ffff88823680d0c0 index:0x0 compound_mapcount: 0
[  +0.000020] flags: 0x200000000010200(slab|head)
[  +0.000019] raw: 0200000000010200 ffffea0007682008 ffffea00076ab808 ffff88823680d0c0
[  +0.000016] raw: 0000000000000000 00000000000d000d 00000001ffffffff 0000000000000000
[  +0.000007] page dumped because: kasan: bad access detected

[  +0.000012] Memory state around the buggy address:
[  +0.000012]  ffff8881e48e0300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000012]  ffff8881e48e0380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000012] >ffff8881e48e0400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000008]                                                  ^
[  +0.000012]  ffff8881e48e0480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000012]  ffff8881e48e0500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007] ==================================================================

Fixes: b1569e99c795 ("ACPI: move thermal trip handling to generic thermal layer")
Reported-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -333,7 +333,7 @@ static void thermal_zone_device_set_poll
 		mod_delayed_work(system_freezable_wq, &tz->poll_queue,
 				 msecs_to_jiffies(delay));
 	else
-		cancel_delayed_work(&tz->poll_queue);
+		cancel_delayed_work_sync(&tz->poll_queue);
 }
 
 static void monitor_thermal_zone(struct thermal_zone_device *tz)

