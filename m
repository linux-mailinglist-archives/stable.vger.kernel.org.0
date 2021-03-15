Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DB833B69D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhCON6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhCON5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 003FF64F29;
        Mon, 15 Mar 2021 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816662;
        bh=h3/LR2OVD5J41FJRYyqFgRY7G0sUDmvsB5kqHPgTSaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d02XI5dsgvpy3Q3XA0iVPvISlxzXP1xwzngKgvQ5YNPugfoEkFvVlK1+MMoaxeB4n
         LMz5cs1GFIs2BgfwJBkGutOMH4QimloLD5iKWsGw+tOfyeJeN+5q+5yorZ9epv9ed4
         BSz1Yzj80MW8JdBzROtrYuX8M3GdphlB8/VJjnFE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Hillf Danton <hdanton@sina.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 032/168] netdevsim: init u64 stats for 32bit hardware
Date:   Mon, 15 Mar 2021 14:54:24 +0100
Message-Id: <20210315135551.406549917@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hillf Danton <hdanton@sina.com>

commit 863a42b289c22df63db62b10fc2c2ffc237e2125 upstream.

Init the u64 stats in order to avoid the lockdep prints on the 32bit
hardware like

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 CPU: 0 PID: 4695 Comm: syz-executor.0 Not tainted 5.11.0-rc5-syzkaller #0
 Hardware name: ARM-Versatile Express
 Backtrace:
 [<826fc5b8>] (dump_backtrace) from [<826fc82c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
 [<826fc814>] (show_stack) from [<8270d1f8>] (__dump_stack lib/dump_stack.c:79 [inline])
 [<826fc814>] (show_stack) from [<8270d1f8>] (dump_stack+0xa8/0xc8 lib/dump_stack.c:120)
 [<8270d150>] (dump_stack) from [<802bf9c0>] (assign_lock_key kernel/locking/lockdep.c:935 [inline])
 [<8270d150>] (dump_stack) from [<802bf9c0>] (register_lock_class+0xabc/0xb68 kernel/locking/lockdep.c:1247)
 [<802bef04>] (register_lock_class) from [<802baa2c>] (__lock_acquire+0x84/0x32d4 kernel/locking/lockdep.c:4711)
 [<802ba9a8>] (__lock_acquire) from [<802be840>] (lock_acquire.part.0+0xf0/0x554 kernel/locking/lockdep.c:5442)
 [<802be750>] (lock_acquire.part.0) from [<802bed10>] (lock_acquire+0x6c/0x74 kernel/locking/lockdep.c:5415)
 [<802beca4>] (lock_acquire) from [<81560548>] (seqcount_lockdep_reader_access include/linux/seqlock.h:103 [inline])
 [<802beca4>] (lock_acquire) from [<81560548>] (__u64_stats_fetch_begin include/linux/u64_stats_sync.h:164 [inline])
 [<802beca4>] (lock_acquire) from [<81560548>] (u64_stats_fetch_begin include/linux/u64_stats_sync.h:175 [inline])
 [<802beca4>] (lock_acquire) from [<81560548>] (nsim_get_stats64+0xdc/0xf0 drivers/net/netdevsim/netdev.c:70)
 [<8156046c>] (nsim_get_stats64) from [<81e2efa0>] (dev_get_stats+0x44/0xd0 net/core/dev.c:10405)
 [<81e2ef5c>] (dev_get_stats) from [<81e53204>] (rtnl_fill_stats+0x38/0x120 net/core/rtnetlink.c:1211)
 [<81e531cc>] (rtnl_fill_stats) from [<81e59d58>] (rtnl_fill_ifinfo+0x6d4/0x148c net/core/rtnetlink.c:1783)
 [<81e59684>] (rtnl_fill_ifinfo) from [<81e5ceb4>] (rtmsg_ifinfo_build_skb+0x9c/0x108 net/core/rtnetlink.c:3798)
 [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3830 [inline])
 [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3821 [inline])
 [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo+0x44/0x70 net/core/rtnetlink.c:3839)
 [<81e5d068>] (rtmsg_ifinfo) from [<81e45c2c>] (register_netdevice+0x664/0x68c net/core/dev.c:10103)
 [<81e455c8>] (register_netdevice) from [<815608bc>] (nsim_create+0xf8/0x124 drivers/net/netdevsim/netdev.c:317)
 [<815607c4>] (nsim_create) from [<81561184>] (__nsim_dev_port_add+0x108/0x188 drivers/net/netdevsim/dev.c:941)
 [<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_port_add_all drivers/net/netdevsim/dev.c:990 [inline])
 [<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_probe+0x5cc/0x750 drivers/net/netdevsim/dev.c:1119)
 [<81561b0c>] (nsim_dev_probe) from [<815661dc>] (nsim_bus_probe+0x10/0x14 drivers/net/netdevsim/bus.c:287)
 [<815661cc>] (nsim_bus_probe) from [<811724c0>] (really_probe+0x100/0x50c drivers/base/dd.c:554)
 [<811723c0>] (really_probe) from [<811729c4>] (driver_probe_device+0xf8/0x1c8 drivers/base/dd.c:740)
 [<811728cc>] (driver_probe_device) from [<81172fe4>] (__device_attach_driver+0x8c/0xf0 drivers/base/dd.c:846)
 [<81172f58>] (__device_attach_driver) from [<8116fee0>] (bus_for_each_drv+0x88/0xd8 drivers/base/bus.c:431)
 [<8116fe58>] (bus_for_each_drv) from [<81172c6c>] (__device_attach+0xdc/0x1d0 drivers/base/dd.c:914)
 [<81172b90>] (__device_attach) from [<8117305c>] (device_initial_probe+0x14/0x18 drivers/base/dd.c:961)
 [<81173048>] (device_initial_probe) from [<81171358>] (bus_probe_device+0x90/0x98 drivers/base/bus.c:491)
 [<811712c8>] (bus_probe_device) from [<8116e77c>] (device_add+0x320/0x824 drivers/base/core.c:3109)
 [<8116e45c>] (device_add) from [<8116ec9c>] (device_register+0x1c/0x20 drivers/base/core.c:3182)
 [<8116ec80>] (device_register) from [<81566710>] (nsim_bus_dev_new drivers/net/netdevsim/bus.c:336 [inline])
 [<8116ec80>] (device_register) from [<81566710>] (new_device_store+0x178/0x208 drivers/net/netdevsim/bus.c:215)
 [<81566598>] (new_device_store) from [<8116fcb4>] (bus_attr_store+0x2c/0x38 drivers/base/bus.c:122)
 [<8116fc88>] (bus_attr_store) from [<805b4b8c>] (sysfs_kf_write+0x48/0x54 fs/sysfs/file.c:139)
 [<805b4b44>] (sysfs_kf_write) from [<805b3c90>] (kernfs_fop_write_iter+0x128/0x1ec fs/kernfs/file.c:296)
 [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (call_write_iter include/linux/fs.h:1901 [inline])
 [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (new_sync_write fs/read_write.c:518 [inline])
 [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (vfs_write+0x3dc/0x57c fs/read_write.c:605)
 [<804d1f20>] (vfs_write) from [<804d2604>] (ksys_write+0x68/0xec fs/read_write.c:658)
 [<804d259c>] (ksys_write) from [<804d2698>] (__do_sys_write fs/read_write.c:670 [inline])
 [<804d259c>] (ksys_write) from [<804d2698>] (sys_write+0x10/0x14 fs/read_write.c:667)
 [<804d2688>] (sys_write) from [<80200060>] (ret_fast_syscall+0x0/0x2c arch/arm/mm/proc-v7.S:64)

Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")
Reported-by: syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/netdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -292,6 +292,7 @@ nsim_create(struct nsim_dev *nsim_dev, s
 
 	ns = netdev_priv(dev);
 	ns->netdev = dev;
+	u64_stats_init(&ns->syncp);
 	ns->nsim_dev = nsim_dev;
 	ns->nsim_dev_port = nsim_dev_port;
 	ns->nsim_bus_dev = nsim_dev->nsim_bus_dev;


