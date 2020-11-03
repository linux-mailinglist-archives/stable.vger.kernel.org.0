Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E132A59A6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgKCWJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:09:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729682AbgKCUj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:39:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFFD22226;
        Tue,  3 Nov 2020 20:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435996;
        bh=978wGzYzMQrjQeH16uM/corImyl56zYfIfiyGMVXZOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReZnmOGSEmbWKmNpH51nS0gbluaBn2PcuPLcNXkEHxFtH9E534ke4INqxapdpN62B
         ziXffXxjjHKOA1kjVP2F/t+cuV1rTc73VvKAf2L5MKKqtDYZcxJeH4obPZbzViL6Ei
         MJp4CgRFBgdZYDoxzHCXDiAZ6Hc9XPYLIa2DuJns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 020/391] firmware: arm_scmi: Fix duplicate workqueue name
Date:   Tue,  3 Nov 2020 21:31:11 +0100
Message-Id: <20201103203349.273384281@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b9ceca6be43233845be70792be9b5ab315d2e010 ]

When more than a single SCMI device are present in the system, the
creation of the notification workqueue with the WQ_SYSFS flag will lead
to the following sysfs duplicate node warning:

 sysfs: cannot create duplicate filename '/devices/virtual/workqueue/scmi_notify'
 CPU: 0 PID: 20 Comm: kworker/0:1 Not tainted 5.9.0-gdf4dd84a3f7d #29
 Hardware name: Broadcom STB (Flattened Device Tree)
 Workqueue: events deferred_probe_work_func
 Backtrace:
   show_stack + 0x20/0x24
   dump_stack + 0xbc/0xe0
   sysfs_warn_dup + 0x70/0x80
   sysfs_create_dir_ns + 0x15c/0x1a4
   kobject_add_internal + 0x140/0x4d0
   kobject_add + 0xc8/0x138
   device_add + 0x1dc/0xc20
   device_register + 0x24/0x28
   workqueue_sysfs_register + 0xe4/0x1f0
   alloc_workqueue + 0x448/0x6ac
   scmi_notification_init + 0x78/0x1dc
   scmi_probe + 0x268/0x4fc
   platform_drv_probe + 0x70/0xc8
   really_probe + 0x184/0x728
   driver_probe_device + 0xa4/0x278
   __device_attach_driver + 0xe8/0x148
   bus_for_each_drv + 0x108/0x158
   __device_attach + 0x190/0x234
   device_initial_probe + 0x1c/0x20
   bus_probe_device + 0xdc/0xec
   deferred_probe_work_func + 0xd4/0x11c
   process_one_work + 0x420/0x8f0
   worker_thread + 0x4fc/0x91c
   kthread + 0x21c/0x22c
   ret_from_fork + 0x14/0x20
 kobject_add_internal failed for scmi_notify with -EEXIST, don't try to
 	register things with the same name in the same directory.
 arm-scmi brcm_scmi@1: SCMI Notifications - Initialization Failed.
 arm-scmi brcm_scmi@1: SCMI Notifications NOT available.
 arm-scmi brcm_scmi@1: SCMI Protocol v1.0 'brcm-scmi:' Firmware version 0x1

Fix this by using dev_name(handle->dev) which guarantees that the name is
unique and this also helps correlate which notification workqueue corresponds
to which SCMI device instance.

Link: https://lore.kernel.org/r/20201014021737.287340-1-f.fainelli@gmail.com
Fixes: bd31b249692e ("firmware: arm_scmi: Add notification dispatch and delivery")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
[sudeep.holla: trimmed backtrace to remove all unwanted hexcodes and timestamps]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/notify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/notify.c b/drivers/firmware/arm_scmi/notify.c
index 4d9f6de3a7fae..51c5a376fb472 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1474,7 +1474,7 @@ int scmi_notification_init(struct scmi_handle *handle)
 	ni->gid = gid;
 	ni->handle = handle;
 
-	ni->notify_wq = alloc_workqueue("scmi_notify",
+	ni->notify_wq = alloc_workqueue(dev_name(handle->dev),
 					WQ_UNBOUND | WQ_FREEZABLE | WQ_SYSFS,
 					0);
 	if (!ni->notify_wq)
-- 
2.27.0



