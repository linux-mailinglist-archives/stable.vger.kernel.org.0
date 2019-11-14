Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5E2FC97E
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 16:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNPFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 10:05:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:24781 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfKNPFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 10:05:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 07:05:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="379599049"
Received: from longcui-mobl.ccr.corp.intel.com ([10.255.29.57])
  by orsmga005.jf.intel.com with ESMTP; 14 Nov 2019 07:05:04 -0800
Message-ID: <05e926734126474216885a243cb94887b3a1ddc6.camel@intel.com>
Subject: Re: [PATCH 5.3 113/148] thermal: Fix use-after-free when
 unregistering thermal zone device
From:   Zhang Rui <rui.zhang@intel.com>
To:     Lukasz Luba <lukasz.luba@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, wvw@google.com
Date:   Thu, 14 Nov 2019 23:05:03 +0800
In-Reply-To: <905e26d4-76c7-555f-3b33-51fa3cf7a470@arm.com>
References: <20191010083609.660878383@linuxfoundation.org>
         <20191010083617.967244655@linuxfoundation.org>
         <905e26d4-76c7-555f-3b33-51fa3cf7a470@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-11-14 at 13:17 +0000, Lukasz Luba wrote:
> Hi Greg,
> 
> This patch causes a deadlock, the thermal framework stops. Please
> check
> this fix (I found it before posting exactly the same solution):
> https://lkml.org/lkml/2019/11/12/1075
> 
> I have verified it on OdroidXU4 and it works. It needs some cleaning
> in
> the commit message, though.
> I have added to CC the author: Wei Wang
> 
> I don't know in how many stable trees it was applied, but should be
> fix
> there also.
> 
Right.
I've just applied this in thermal tree, will check if it can get 5.4 or
not later.

thanks,
rui

> Regards,
> Lukasz Luba
> 
> On 10/10/19 9:36 AM, Greg Kroah-Hartman wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > [ Upstream commit 1851799e1d2978f68eea5d9dff322e121dcf59c1 ]
> > 
> > thermal_zone_device_unregister() cancels the delayed work that
> > polls the
> > thermal zone, but it does not wait for it to finish. This is racy
> > with
> > respect to the freeing of the thermal zone device, which can result
> > in a
> > use-after-free [1].
> > 
> > Fix this by waiting for the delayed work to finish before freeing
> > the
> > thermal zone device. Note that thermal_zone_device_set_polling() is
> > never invoked from an atomic context, so it is safe to call
> > cancel_delayed_work_sync() that can block.
> > 
> > [1]
> > [  +0.002221]
> > ==================================================================
> > [  +0.000064] BUG: KASAN: use-after-free in
> > __mutex_lock+0x1076/0x11c0
> > [  +0.000016] Read of size 8 at addr ffff8881e48e0450 by task
> > kworker/1:0/17
> > 
> > [  +0.000023] CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.2.0-
> > rc6-custom-02495-g8e73ca3be4af #1701
> > [  +0.000010] Hardware name: Mellanox Technologies Ltd. MSN2100-
> > CB2FO/SA001017, BIOS 5.6.5 06/07/2016
> > [  +0.000016] Workqueue: events_freezable_power_
> > thermal_zone_device_check
> > [  +0.000012] Call Trace:
> > [  +0.000021]  dump_stack+0xa9/0x10e
> > [  +0.000020]  print_address_description.cold.2+0x9/0x25e
> > [  +0.000018]  __kasan_report.cold.3+0x78/0x9d
> > [  +0.000016]  kasan_report+0xe/0x20
> > [  +0.000016]  __mutex_lock+0x1076/0x11c0
> > [  +0.000014]  step_wise_throttle+0x72/0x150
> > [  +0.000018]  handle_thermal_trip+0x167/0x760
> > [  +0.000019]  thermal_zone_device_update+0x19e/0x5f0
> > [  +0.000019]  process_one_work+0x969/0x16f0
> > [  +0.000017]  worker_thread+0x91/0xc40
> > [  +0.000014]  kthread+0x33d/0x400
> > [  +0.000015]  ret_from_fork+0x3a/0x50
> > 
> > [  +0.000020] Allocated by task 1:
> > [  +0.000015]  save_stack+0x19/0x80
> > [  +0.000015]  __kasan_kmalloc.constprop.4+0xc1/0xd0
> > [  +0.000014]  kmem_cache_alloc_trace+0x152/0x320
> > [  +0.000015]  thermal_zone_device_register+0x1b4/0x13a0
> > [  +0.000015]  mlxsw_thermal_init+0xc92/0x23d0
> > [  +0.000014]  __mlxsw_core_bus_device_register+0x659/0x11b0
> > [  +0.000013]  mlxsw_core_bus_device_register+0x3d/0x90
> > [  +0.000013]  mlxsw_pci_probe+0x355/0x4b0
> > [  +0.000014]  local_pci_probe+0xc3/0x150
> > [  +0.000013]  pci_device_probe+0x280/0x410
> > [  +0.000013]  really_probe+0x26a/0xbb0
> > [  +0.000013]  driver_probe_device+0x208/0x2e0
> > [  +0.000013]  device_driver_attach+0xfe/0x140
> > [  +0.000013]  __driver_attach+0x110/0x310
> > [  +0.000013]  bus_for_each_dev+0x14b/0x1d0
> > [  +0.000013]  driver_register+0x1c0/0x400
> > [  +0.000015]  mlxsw_sp_module_init+0x5d/0xd3
> > [  +0.000014]  do_one_initcall+0x239/0x4dd
> > [  +0.000013]  kernel_init_freeable+0x42b/0x4e8
> > [  +0.000012]  kernel_init+0x11/0x18b
> > [  +0.000013]  ret_from_fork+0x3a/0x50
> > 
> > [  +0.000015] Freed by task 581:
> > [  +0.000013]  save_stack+0x19/0x80
> > [  +0.000014]  __kasan_slab_free+0x125/0x170
> > [  +0.000013]  kfree+0xf3/0x310
> > [  +0.000013]  thermal_release+0xc7/0xf0
> > [  +0.000014]  device_release+0x77/0x200
> > [  +0.000014]  kobject_put+0x1a8/0x4c0
> > [  +0.000014]  device_unregister+0x38/0xc0
> > [  +0.000014]  thermal_zone_device_unregister+0x54e/0x6a0
> > [  +0.000014]  mlxsw_thermal_fini+0x184/0x35a
> > [  +0.000014]  mlxsw_core_bus_device_unregister+0x10a/0x640
> > [  +0.000013]  mlxsw_devlink_core_bus_device_reload+0x92/0x210
> > [  +0.000015]  devlink_nl_cmd_reload+0x113/0x1f0
> > [  +0.000014]  genl_family_rcv_msg+0x700/0xee0
> > [  +0.000013]  genl_rcv_msg+0xca/0x170
> > [  +0.000013]  netlink_rcv_skb+0x137/0x3a0
> > [  +0.000012]  genl_rcv+0x29/0x40
> > [  +0.000013]  netlink_unicast+0x49b/0x660
> > [  +0.000013]  netlink_sendmsg+0x755/0xc90
> > [  +0.000013]  __sys_sendto+0x3de/0x430
> > [  +0.000013]  __x64_sys_sendto+0xe2/0x1b0
> > [  +0.000013]  do_syscall_64+0xa4/0x4d0
> > [  +0.000013]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > [  +0.000017] The buggy address belongs to the object at
> > ffff8881e48e0008
> >                 which belongs to the cache kmalloc-2k of size 2048
> > [  +0.000012] The buggy address is located 1096 bytes inside of
> >                 2048-byte region [ffff8881e48e0008,
> > ffff8881e48e0808)
> > [  +0.000007] The buggy address belongs to the page:
> > [  +0.000012] page:ffffea0007923800 refcount:1 mapcount:0
> > mapping:ffff88823680d0c0 index:0x0 compound_mapcount: 0
> > [  +0.000020] flags: 0x200000000010200(slab|head)
> > [  +0.000019] raw: 0200000000010200 ffffea0007682008
> > ffffea00076ab808 ffff88823680d0c0
> > [  +0.000016] raw: 0000000000000000 00000000000d000d
> > 00000001ffffffff 0000000000000000
> > [  +0.000007] page dumped because: kasan: bad access detected
> > 
> > [  +0.000012] Memory state around the buggy address:
> > [  +0.000012]  ffff8881e48e0300: fb fb fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb
> > [  +0.000012]  ffff8881e48e0380: fb fb fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb
> > [  +0.000012] >ffff8881e48e0400: fb fb fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb
> > [  +0.000008]                                                  ^
> > [  +0.000012]  ffff8881e48e0480: fb fb fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb
> > [  +0.000012]  ffff8881e48e0500: fb fb fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb
> > [  +0.000007]
> > ==================================================================
> > 
> > Fixes: b1569e99c795 ("ACPI: move thermal trip handling to generic
> > thermal layer")
> > Reported-by: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/thermal/thermal_core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/thermal_core.c
> > b/drivers/thermal/thermal_core.c
> > index 6bab66e84eb58..ebe15f2cf7fc3 100644
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -304,7 +304,7 @@ static void
> > thermal_zone_device_set_polling(struct thermal_zone_device *tz,
> >   				 &tz->poll_queue,
> >   				 msecs_to_jiffies(delay));
> >   	else
> > -		cancel_delayed_work(&tz->poll_queue);
> > +		cancel_delayed_work_sync(&tz->poll_queue);
> >   }
> >   
> >   static void monitor_thermal_zone(struct thermal_zone_device *tz)
> > 

