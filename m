Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D647419CD2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhI0Rca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238122AbhI0RaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDDF361262;
        Mon, 27 Sep 2021 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763076;
        bh=jpfmtd47R/F4mGS9s52CrzGTZMmtH1/bvQccjaXRH70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lr/UQw1vM4Kqajk15eslgpw7upGevFLRoWCooFGyvSVA1xAB6C6yEKiwJoyqu0XD1
         QGvst1s6/QiwR5tqRr11/4Nueme4X/jT3l6J+0DqarWy16voQYIM0wr7OSuzyXvE6/
         OClrZ8tDaP7cvN3Wigj5Fc0YkMoC+gZT0l1mXHv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Nettleton <jon@solid-run.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.14 157/162] software node: balance refcount for managed software nodes
Date:   Mon, 27 Sep 2021 19:03:23 +0200
Message-Id: <20210927170238.858470287@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

commit 5aeb05b27f81269a2bf2e15eab9fc0f9a400d3a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/swnode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -1113,6 +1113,9 @@ int device_create_managed_software_node(
 	to_swnode(fwnode)->managed = true;
 	set_secondary_fwnode(dev, fwnode);
 
+	if (device_is_registered(dev))
+		software_node_notify(dev, KOBJ_ADD);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(device_create_managed_software_node);


