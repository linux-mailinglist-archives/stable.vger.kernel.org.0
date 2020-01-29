Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6458414C407
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 01:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgA2A3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 19:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbgA2A3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 19:29:39 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B153224687;
        Wed, 29 Jan 2020 00:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580257778;
        bh=rTuhp1yW6IfOoiOolt/SA3kPwEWcPXDXeIdasyCqMds=;
        h=Date:From:To:Subject:From;
        b=ZVOhostK1P551REf31on3ska/t21xP5NTbryGe3Rb9qoosucoYuFoD4dI0J5tWn9k
         ViU1LJ61sgGhRArCp5LP79mez8ry0LwMNi2OH1aLF6LZrROw25eBwFGkS0+9vgK2Ym
         ptAgUL4EXCMwlowcZ7ybjL8NTHvt75tok/YUpJsw=
Date:   Tue, 28 Jan 2020 16:29:37 -0800
From:   akpm@linux-foundation.org
To:     andrew.smirnov@gmail.com, andy.shevchenko@gmail.com,
        cphealy@gmail.com, linux@roeck-us.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vdronov@redhat.com, wim@linux-watchdog.org
Subject:  [merged]
 watchdog-fix-uaf-in-reboot-notifier-handling-in-watchdog-core-code.patch
 removed from -mm tree
Message-ID: <20200129002937.-Dh-zT_py%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: drivers/watchdog/: fix oops in reboot notifier handling in watchdog core code
has been removed from the -mm tree.  Its filename was
     watchdog-fix-uaf-in-reboot-notifier-handling-in-watchdog-core-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladis Dronov <vdronov@redhat.com>
Subject: drivers/watchdog/: fix oops in reboot notifier handling in watchdog core code

After commit 44ea39420fc9 ("drivers/watchdog: make use of
devm_register_reboot_notifier()") the struct notifier_block reboot_nb in
the struct watchdog_device is removed from the reboot notifiers chain at
the time watchdog's chardev is closed.  But at least in i6300esb.c case
reboot_nb is embedded in the struct esb_dev which can be freed on its
device removal and before the chardev is closed, thus an oops at reboot:

[    7.728581] esb_probe: esb_dev.watchdog_device ffff91316f91ab28
ts# uname -r                            note the address ^^^
5.5.0-rc5-ae6088-wdog
ts# ./openwdog0 &
[1] 696
ts# opened /dev/watchdog0, sleeping 10s...
ts# echo 1 > /sys/devices/pci0000\:00/0000\:00\:09.0/remove
[  178.086079] devres:rel_nodes: dev ffff91317668a0b0 data ffff91316f91ab=
28
           esb_dev.watchdog_device.reboot_nb memory is freed here ^^^
ts# ...woken up
[  181.459010] devres:rel_nodes: dev ffff913171781000 data ffff913174a1da=
e8
[  181.460195] devm_unreg_reboot_notifier: res ffff913174a1dae8 nb ffff91=
316f91ab78
                                     attempt to use memory already freed =
^^^
[  181.461063] devm_unreg_reboot_notifier: nb->call 6b6b6b6b6b6b6b6b
[  181.461243] devm_unreg_reboot_notifier: nb->next 6b6b6b6b6b6b6b6b
                freed memory is filled with a slub poison ^^^
[1]+  Done                    ./openwdog0
ts# reboot
[  229.921862] systemd-shutdown[1]: Rebooting.
[  229.939265] notifier_call_chain: nb ffffffff9c6c2f20 nb->next ffffffff=
9c6d50c0
[  229.943080] notifier_call_chain: nb ffffffff9c6d50c0 nb->next 6b6b6b6b=
6b6b6b6b
[  229.946054] notifier_call_chain: nb 6b6b6b6b6b6b6b6b INVAL
[  229.957584] general protection fault: 0000 [#1] SMP
[  229.958770] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 5.5.0-rc5-=
ae6088-wdog
[  229.960224] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
[  229.963288] RIP: 0010:notifier_call_chain+0x66/0xd0
[  229.969082] RSP: 0018:ffffb20dc0013d88 EFLAGS: 00010246
[  229.970812] RAX: 000000000000002e RBX: 6b6b6b6b6b6b6b6b RCX: 000000000=
00008b3
[  229.972929] RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff9=
ccc46ac
[  229.975028] RBP: 0000000000000001 R08: 0000000000000000 R09: 000000000=
00008b3
[  229.977039] R10: 0000000000000001 R11: ffffffff9c26c740 R12: 000000000=
0000000
[  229.979155] R13: 6b6b6b6b6b6b6b6b R14: 0000000000000000 R15: 00000000f=
ffffffa
...   slub_debug=3DFZP poison ^^^
[  229.989089] Call Trace:
[  229.990157]  blocking_notifier_call_chain+0x43/0x59
[  229.991401]  kernel_restart_prepare+0x14/0x30
[  229.992607]  kernel_restart+0x9/0x30
[  229.993800]  __do_sys_reboot+0x1d2/0x210
[  230.000149]  do_syscall_64+0x3d/0x130
[  230.001277]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  230.002639] RIP: 0033:0x7f5461bdd177
[  230.016402] Modules linked in: i6300esb
[  230.050261] Kernel panic - not syncing: Attempted to kill init! exitco=
de=3D0x0000000b

Fix the crash by reverting 44ea39420fc9 so unregister_reboot_notifier() is
called when watchdog device is removed.  This also makes handling of the
reboot notifier unified with the handling of the restart handler, which is
freed with unregister_restart_handler() in the same place.

Link: http://lkml.kernel.org/r/20200108125347.6067-1-vdronov@redhat.com
Fixes: 44ea39420fc9 ("drivers/watchdog: make use of devm_register_reboot_=
notifier()")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <stable@vger.kernel.org>	[4.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/watchdog_core.c |   35 ++++++++++++++++++++++++++++
 drivers/watchdog/watchdog_dev.c  |   36 -----------------------------
 2 files changed, 36 insertions(+), 35 deletions(-)

--- a/drivers/watchdog/watchdog_core.c~watchdog-fix-uaf-in-reboot-notifier-handling-in-watchdog-core-code
+++ a/drivers/watchdog/watchdog_core.c
@@ -147,6 +147,25 @@ int watchdog_init_timeout(struct watchdo
 }
 EXPORT_SYMBOL_GPL(watchdog_init_timeout);
 
+static int watchdog_reboot_notifier(struct notifier_block *nb,
+				    unsigned long code, void *data)
+{
+	struct watchdog_device *wdd;
+
+	wdd = container_of(nb, struct watchdog_device, reboot_nb);
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		if (watchdog_active(wdd)) {
+			int ret;
+
+			ret = wdd->ops->stop(wdd);
+			if (ret)
+				return NOTIFY_BAD;
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int watchdog_restart_notifier(struct notifier_block *nb,
 				     unsigned long action, void *data)
 {
@@ -235,6 +254,19 @@ static int __watchdog_register_device(st
 		}
 	}
 
+	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status)) {
+		wdd->reboot_nb.notifier_call = watchdog_reboot_notifier;
+
+		ret = register_reboot_notifier(&wdd->reboot_nb);
+		if (ret) {
+			pr_err("watchdog%d: Cannot register reboot notifier (%d)\n",
+			       wdd->id, ret);
+			watchdog_dev_unregister(wdd);
+			ida_simple_remove(&watchdog_ida, id);
+			return ret;
+		}
+	}
+
 	if (wdd->ops->restart) {
 		wdd->restart_nb.notifier_call = watchdog_restart_notifier;
 
@@ -289,6 +321,9 @@ static void __watchdog_unregister_device
 	if (wdd->ops->restart)
 		unregister_restart_handler(&wdd->restart_nb);
 
+	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status))
+		unregister_reboot_notifier(&wdd->reboot_nb);
+
 	watchdog_dev_unregister(wdd);
 	ida_simple_remove(&watchdog_ida, wdd->id);
 }
--- a/drivers/watchdog/watchdog_dev.c~watchdog-fix-uaf-in-reboot-notifier-handling-in-watchdog-core-code
+++ a/drivers/watchdog/watchdog_dev.c
@@ -38,7 +38,6 @@
 #include <linux/miscdevice.h>	/* For handling misc devices */
 #include <linux/module.h>	/* For module stuff/... */
 #include <linux/mutex.h>	/* For mutexes */
-#include <linux/reboot.h>	/* For reboot notifier */
 #include <linux/slab.h>		/* For memory functions */
 #include <linux/types.h>	/* For standard types (like size_t) */
 #include <linux/watchdog.h>	/* For watchdog specific items */
@@ -1097,25 +1096,6 @@ static void watchdog_cdev_unregister(str
 	put_device(&wd_data->dev);
 }
 
-static int watchdog_reboot_notifier(struct notifier_block *nb,
-				    unsigned long code, void *data)
-{
-	struct watchdog_device *wdd;
-
-	wdd = container_of(nb, struct watchdog_device, reboot_nb);
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		if (watchdog_active(wdd)) {
-			int ret;
-
-			ret = wdd->ops->stop(wdd);
-			if (ret)
-				return NOTIFY_BAD;
-		}
-	}
-
-	return NOTIFY_DONE;
-}
-
 /*
  *	watchdog_dev_register: register a watchdog device
  *	@wdd: watchdog device
@@ -1134,22 +1114,8 @@ int watchdog_dev_register(struct watchdo
 		return ret;
 
 	ret = watchdog_register_pretimeout(wdd);
-	if (ret) {
+	if (ret)
 		watchdog_cdev_unregister(wdd);
-		return ret;
-	}
-
-	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status)) {
-		wdd->reboot_nb.notifier_call = watchdog_reboot_notifier;
-
-		ret = devm_register_reboot_notifier(&wdd->wd_data->dev,
-						    &wdd->reboot_nb);
-		if (ret) {
-			pr_err("watchdog%d: Cannot register reboot notifier (%d)\n",
-			       wdd->id, ret);
-			watchdog_dev_unregister(wdd);
-		}
-	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from vdronov@redhat.com are


