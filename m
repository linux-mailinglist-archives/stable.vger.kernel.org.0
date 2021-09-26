Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110444188B6
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhIZMuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:50:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4E160F93;
        Sun, 26 Sep 2021 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660509;
        bh=NIpztGt19NCrQUXnHLyPlhhyVDxpIxXeE136Y+JWR7Q=;
        h=Subject:To:Cc:From:Date:From;
        b=dkDlacgqtbvjEPOEMKSOGyO7vfvLpatSJkUPv/g9FCShcP1Tp/Xi9TH6iFQ5DANqw
         9BmJrdolo/lvxC3v8iq6seJtYwqtOZHAVLn0VcjEu2yOAsZvopbM5Mgnhmfu2NPbP3
         jUhTVXIekVjzzY8EhtQV1ttHBo6x2zTP5FO25yTE=
Subject: FAILED: patch "[PATCH] software node: balance refcount for managed software nodes" failed to apply to 5.14-stable tree
To:     laurentiu.tudor@nxp.com, heikki.krogerus@linux.intel.com,
        jon@solid-run.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:48:26 +0200
Message-ID: <1632660506144131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5aeb05b27f81269a2bf2e15eab9fc0f9a400d3a8 Mon Sep 17 00:00:00 2001
From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Date: Wed, 15 Sep 2021 11:09:39 +0300
Subject: [PATCH] software node: balance refcount for managed software nodes

software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
software nodes, thus leading to underflow errors. Balance the refcount by
bumping it in the device_create_managed_software_node() function.

The error [1] was encountered after adding a .shutdown() op to our
fsl-mc-bus driver.

[1]
pc : refcount_warn_saturate+0xf8/0x150
lr : refcount_warn_saturate+0xf8/0x150
sp : ffff80001009b920
x29: ffff80001009b920 x28: ffff1a2420318000 x27: 0000000000000000
x26: ffffccac15e7a038 x25: 0000000000000008 x24: ffffccac168e0030
x23: ffff1a2428a82000 x22: 0000000000080000 x21: ffff1a24287b5000
x20: 0000000000000001 x19: ffff1a24261f4400 x18: ffffffffffffffff
x17: 6f72645f726f7272 x16: 0000000000000000 x15: ffff80009009b607
x14: 0000000000000000 x13: ffffccac16602670 x12: 0000000000000a17
x11: 000000000000035d x10: ffffccac16602670 x9 : ffffccac16602670
x8 : 00000000ffffefff x7 : ffffccac1665a670 x6 : ffffccac1665a670
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff1a2420318000
Call trace:
 refcount_warn_saturate+0xf8/0x150
 kobject_put+0x10c/0x120
 software_node_notify+0xd8/0x140
 device_platform_notify+0x4c/0xb4
 device_del+0x188/0x424
 fsl_mc_device_remove+0x2c/0x4c
 rebofind sp.c__fsl_mc_device_remove+0x14/0x2c
 device_for_each_child+0x5c/0xac
 dprc_remove+0x9c/0xc0
 fsl_mc_driver_remove+0x28/0x64
 __device_release_driver+0x188/0x22c
 device_release_driver+0x30/0x50
 bus_remove_device+0x128/0x134
 device_del+0x16c/0x424
 fsl_mc_bus_remove+0x8c/0x114
 fsl_mc_bus_shutdown+0x14/0x20
 platform_shutdown+0x28/0x40
 device_shutdown+0x15c/0x330
 __do_sys_reboot+0x218/0x2a0
 __arm64_sys_reboot+0x28/0x34
 invoke_syscall+0x48/0x114
 el0_svc_common+0x40/0xdc
 do_el0_svc+0x2c/0x94
 el0_svc+0x2c/0x54
 el0t_64_sync_handler+0xa8/0x12c
 el0t_64_sync+0x198/0x19c
---[ end trace 32eb1c71c7d86821 ]---

Fixes: 151f6ff78cdf ("software node: Provide replacement for device_add_properties()")
Reported-by: Jon Nettleton <jon@solid-run.com>
Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc: 5.12+ <stable@vger.kernel.org> # 5.12+
[ rjw: Fix up the software_node_notify() invocation ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 7bd0f3cfb7eb..c46f6a8e14d2 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -1116,6 +1116,9 @@ int device_create_managed_software_node(struct device *dev,
 	to_swnode(fwnode)->managed = true;
 	set_secondary_fwnode(dev, fwnode);
 
+	if (device_is_registered(dev))
+		software_node_notify(dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(device_create_managed_software_node);

