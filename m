Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF68BE5304
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbfJYSGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46832 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731465AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OM-NA; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001iM-6A; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Wang Hai" <wanghai26@huawei.com>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Hulk Robot" <hulkci@huawei.com>
Date:   Fri, 25 Oct 2019 19:03:12 +0100
Message-ID: <lsq.1572026582.775974354@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 11/47] memstick: Fix error cleanup path of memstick_init
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai26@huawei.com>

commit 65f1a0d39c289bb6fc85635528cd36c4b07f560e upstream.

If bus_register fails. On its error handling path, it has cleaned up
what it has done. There is no need to call bus_unregister again.
Otherwise, if bus_unregister is called, issues such as null-ptr-deref
will arise.

Syzkaller report this:

kobject_add_internal failed for memstick (error: -12 parent: bus)
BUG: KASAN: null-ptr-deref in sysfs_remove_file_ns+0x1b/0x40 fs/sysfs/file.c:467
Read of size 8 at addr 0000000000000078 by task syz-executor.0/4460

Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xa9/0x10e lib/dump_stack.c:113
 __kasan_report+0x171/0x18d mm/kasan/report.c:321
 kasan_report+0xe/0x20 mm/kasan/common.c:614
 sysfs_remove_file_ns+0x1b/0x40 fs/sysfs/file.c:467
 sysfs_remove_file include/linux/sysfs.h:519 [inline]
 bus_remove_file+0x6c/0x90 drivers/base/bus.c:145
 remove_probe_files drivers/base/bus.c:599 [inline]
 bus_unregister+0x6e/0x100 drivers/base/bus.c:916 ? 0xffffffffc1590000
 memstick_init+0x7a/0x1000 [memstick]
 do_one_initcall+0xb9/0x3b5 init/main.c:914
 do_init_module+0xe0/0x330 kernel/module.c:3468
 load_module+0x38eb/0x4270 kernel/module.c:3819
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3909
 do_syscall_64+0x72/0x2a0 arch/x86/entry/common.c:298
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: baf8532a147d ("memstick: initial commit for Sony MemoryStick support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai26@huawei.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/memstick/core/memstick.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -626,13 +626,18 @@ static int __init memstick_init(void)
 		return -ENOMEM;
 
 	rc = bus_register(&memstick_bus_type);
-	if (!rc)
-		rc = class_register(&memstick_host_class);
+	if (rc)
+		goto error_destroy_workqueue;
 
-	if (!rc)
-		return 0;
+	rc = class_register(&memstick_host_class);
+	if (rc)
+		goto error_bus_unregister;
 
+	return 0;
+
+error_bus_unregister:
 	bus_unregister(&memstick_bus_type);
+error_destroy_workqueue:
 	destroy_workqueue(workqueue);
 
 	return rc;

