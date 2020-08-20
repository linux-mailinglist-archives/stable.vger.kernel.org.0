Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0264524BEC8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgHTNcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgHTJcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC02020724;
        Thu, 20 Aug 2020 09:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915936;
        bh=5bCMb58m/idID+jX1LMdnRhVIFWSKgLCIvtf2QfQDes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sfj7G3Q+4vBEEU2JTC8+2ousdYZVg5r58AFlnGb3USXHyTCATieVEJnOtadHa5r7i
         ui53HepJDtGsdgjN5ozb343Hq8OSEHtTBT9Xxpc+k4xr/qnKhqfWyoj+75mCgP/blV
         ObU5Cf0b/fMKPgUqRUUsU9BGVD60TFUBsA/dfgsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Krzysztof Sobota <krzysztof.sobota@nokia.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 185/232] watchdog: initialize device before misc_register
Date:   Thu, 20 Aug 2020 11:20:36 +0200
Message-Id: <20200820091621.761360373@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Sobota <krzysztof.sobota@nokia.com>

[ Upstream commit cb36e29bb0e4b0c33c3d5866a0a4aebace4c99b7 ]

When watchdog device is being registered, it calls misc_register that
makes watchdog available for systemd to open. This is a data race
scenario, because when device is open it may still have device struct
not initialized - this in turn causes a crash. This patch moves
device initialization before misc_register call and it solves the
problem printed below.

------------[ cut here ]------------
WARNING: CPU: 3 PID: 1 at lib/kobject.c:612 kobject_get+0x50/0x54
kobject: '(null)' ((ptrval)): is not initialized, yet kobject_get() is being called.
Modules linked in: k2_reset_status(O) davinci_wdt(+) sfn_platform_hwbcn(O) fsmddg_sfn(O) clk_misc_mmap(O) clk_sw_bcn(O) fsp_reset(O) cma_mod(O) slave_sup_notif(O) fpga_master(O) latency(O+) evnotify(O) enable_arm_pmu(O) xge(O) rio_mport_cdev br_netfilter bridge stp llc nvrd_checksum(O) ipv6
CPU: 3 PID: 1 Comm: systemd Tainted: G           O      4.19.113-g2579778-fsm4_k2 #1
Hardware name: Keystone
[<c02126c4>] (unwind_backtrace) from [<c020da94>] (show_stack+0x18/0x1c)
[<c020da94>] (show_stack) from [<c07f87d8>] (dump_stack+0xb4/0xe8)
[<c07f87d8>] (dump_stack) from [<c0221f70>] (__warn+0xfc/0x114)
[<c0221f70>] (__warn) from [<c0221fd8>] (warn_slowpath_fmt+0x50/0x74)
[<c0221fd8>] (warn_slowpath_fmt) from [<c07fd394>] (kobject_get+0x50/0x54)
[<c07fd394>] (kobject_get) from [<c0602ce8>] (get_device+0x1c/0x24)
[<c0602ce8>] (get_device) from [<c06961e0>] (watchdog_open+0x90/0xf0)
[<c06961e0>] (watchdog_open) from [<c06001dc>] (misc_open+0x130/0x17c)
[<c06001dc>] (misc_open) from [<c0388228>] (chrdev_open+0xec/0x1a8)
[<c0388228>] (chrdev_open) from [<c037fa98>] (do_dentry_open+0x204/0x3cc)
[<c037fa98>] (do_dentry_open) from [<c0391e2c>] (path_openat+0x330/0x1148)
[<c0391e2c>] (path_openat) from [<c0394518>] (do_filp_open+0x78/0xec)
[<c0394518>] (do_filp_open) from [<c0381100>] (do_sys_open+0x130/0x1f4)
[<c0381100>] (do_sys_open) from [<c0201000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xd2ceffa8 to 0xd2cefff0)
ffa0:                   b6f69968 00000000 ffffff9c b6ebd210 000a0001 00000000
ffc0: b6f69968 00000000 00000000 00000142 fffffffd ffffffff 00b65530 bed7bb78
ffe0: 00000142 bed7ba70 b6cc2503 b6cc41d6
---[ end trace 7b16eb105513974f ]---

------------[ cut here ]------------
WARNING: CPU: 3 PID: 1 at lib/refcount.c:153 kobject_get+0x24/0x54
refcount_t: increment on 0; use-after-free.
Modules linked in: k2_reset_status(O) davinci_wdt(+) sfn_platform_hwbcn(O) fsmddg_sfn(O) clk_misc_mmap(O) clk_sw_bcn(O) fsp_reset(O) cma_mod(O) slave_sup_notif(O) fpga_master(O) latency(O+) evnotify(O) enable_arm_pmu(O) xge(O) rio_mport_cdev br_netfilter bridge stp llc nvrd_checksum(O) ipv6
CPU: 3 PID: 1 Comm: systemd Tainted: G        W  O      4.19.113-g2579778-fsm4_k2 #1
Hardware name: Keystone
[<c02126c4>] (unwind_backtrace) from [<c020da94>] (show_stack+0x18/0x1c)
[<c020da94>] (show_stack) from [<c07f87d8>] (dump_stack+0xb4/0xe8)
[<c07f87d8>] (dump_stack) from [<c0221f70>] (__warn+0xfc/0x114)
[<c0221f70>] (__warn) from [<c0221fd8>] (warn_slowpath_fmt+0x50/0x74)
[<c0221fd8>] (warn_slowpath_fmt) from [<c07fd368>] (kobject_get+0x24/0x54)
[<c07fd368>] (kobject_get) from [<c0602ce8>] (get_device+0x1c/0x24)
[<c0602ce8>] (get_device) from [<c06961e0>] (watchdog_open+0x90/0xf0)
[<c06961e0>] (watchdog_open) from [<c06001dc>] (misc_open+0x130/0x17c)
[<c06001dc>] (misc_open) from [<c0388228>] (chrdev_open+0xec/0x1a8)
[<c0388228>] (chrdev_open) from [<c037fa98>] (do_dentry_open+0x204/0x3cc)
[<c037fa98>] (do_dentry_open) from [<c0391e2c>] (path_openat+0x330/0x1148)
[<c0391e2c>] (path_openat) from [<c0394518>] (do_filp_open+0x78/0xec)
[<c0394518>] (do_filp_open) from [<c0381100>] (do_sys_open+0x130/0x1f4)
[<c0381100>] (do_sys_open) from [<c0201000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xd2ceffa8 to 0xd2cefff0)
ffa0:                   b6f69968 00000000 ffffff9c b6ebd210 000a0001 00000000
ffc0: b6f69968 00000000 00000000 00000142 fffffffd ffffffff 00b65530 bed7bb78
ffe0: 00000142 bed7ba70 b6cc2503 b6cc41d6
---[ end trace 7b16eb1055139750 ]---

Fixes: 72139dfa2464 ("watchdog: Fix the race between the release of watchdog_core_data and cdev")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Krzysztof Sobota <krzysztof.sobota@nokia.com>
Link: https://lore.kernel.org/r/20200717103109.14660-1-krzysztof.sobota@nokia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 7e4cd34a8c20e..b535f5fa279b9 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -994,6 +994,15 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 	if (IS_ERR_OR_NULL(watchdog_kworker))
 		return -ENODEV;
 
+	device_initialize(&wd_data->dev);
+	wd_data->dev.devt = MKDEV(MAJOR(watchdog_devt), wdd->id);
+	wd_data->dev.class = &watchdog_class;
+	wd_data->dev.parent = wdd->parent;
+	wd_data->dev.groups = wdd->groups;
+	wd_data->dev.release = watchdog_core_data_release;
+	dev_set_drvdata(&wd_data->dev, wdd);
+	dev_set_name(&wd_data->dev, "watchdog%d", wdd->id);
+
 	kthread_init_work(&wd_data->work, watchdog_ping_work);
 	hrtimer_init(&wd_data->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
 	wd_data->timer.function = watchdog_timer_expired;
@@ -1014,15 +1023,6 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		}
 	}
 
-	device_initialize(&wd_data->dev);
-	wd_data->dev.devt = MKDEV(MAJOR(watchdog_devt), wdd->id);
-	wd_data->dev.class = &watchdog_class;
-	wd_data->dev.parent = wdd->parent;
-	wd_data->dev.groups = wdd->groups;
-	wd_data->dev.release = watchdog_core_data_release;
-	dev_set_drvdata(&wd_data->dev, wdd);
-	dev_set_name(&wd_data->dev, "watchdog%d", wdd->id);
-
 	/* Fill in the data structures */
 	cdev_init(&wd_data->cdev, &watchdog_fops);
 
-- 
2.25.1



