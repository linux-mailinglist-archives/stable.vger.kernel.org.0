Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9A231E3C
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfFANfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbfFANX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 498012401C;
        Sat,  1 Jun 2019 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395406;
        bh=A4/NetqUtcNLkyBmze+0c1akfZnG/G1wfiwTCwo3EgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvYpYtIzax0c2KcoXNgho+VnCZnC+jAepe3sgiyCEcXh2saV/A+Pp/wmVSf00vUHo
         7vmTIUUaKpH/ipGUOWP42U0d7tVjybb9hfKqpr5V7+y2WmIyG4j7+uGingoX0EbX34
         RuQsvjcV4EZtU4RkiUTzQy1XW1ILgwMpKXuW7yus=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 045/141] configfs: fix possible use-after-free in configfs_register_group
Date:   Sat,  1 Jun 2019 09:20:21 -0400
Message-Id: <20190601132158.25821-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 35399f87e271f7cf3048eab00a421a6519ac8441 ]

In configfs_register_group(), if create_default_group() failed, we
forget to unlink the group. It will left a invalid item in the parent list,
which may trigger the use-after-free issue seen below:

BUG: KASAN: use-after-free in __list_add_valid+0xd4/0xe0 lib/list_debug.c:26
Read of size 8 at addr ffff8881ef61ae20 by task syz-executor.0/5996

CPU: 1 PID: 5996 Comm: syz-executor.0 Tainted: G         C        5.0.0+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xa9/0x10e lib/dump_stack.c:113
 print_address_description+0x65/0x270 mm/kasan/report.c:187
 kasan_report+0x149/0x18d mm/kasan/report.c:317
 __list_add_valid+0xd4/0xe0 lib/list_debug.c:26
 __list_add include/linux/list.h:60 [inline]
 list_add_tail include/linux/list.h:93 [inline]
 link_obj+0xb0/0x190 fs/configfs/dir.c:759
 link_group+0x1c/0x130 fs/configfs/dir.c:784
 configfs_register_group+0x56/0x1e0 fs/configfs/dir.c:1751
 configfs_register_default_group+0x72/0xc0 fs/configfs/dir.c:1834
 ? 0xffffffffc1be0000
 iio_sw_trigger_init+0x23/0x1000 [industrialio_sw_trigger]
 do_one_initcall+0xbc/0x47d init/main.c:887
 do_init_module+0x1b5/0x547 kernel/module.c:3456
 load_module+0x6405/0x8c10 kernel/module.c:3804
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
 do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x462e99
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f494ecbcc58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00007f494ecbcc70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f494ecbd6bc
R13: 00000000004bcefa R14: 00000000006f6fb0 R15: 0000000000000004

Allocated by task 5987:
 set_track mm/kasan/common.c:87 [inline]
 __kasan_kmalloc.constprop.3+0xa0/0xd0 mm/kasan/common.c:497
 kmalloc include/linux/slab.h:545 [inline]
 kzalloc include/linux/slab.h:740 [inline]
 configfs_register_default_group+0x4c/0xc0 fs/configfs/dir.c:1829
 0xffffffffc1bd0023
 do_one_initcall+0xbc/0x47d init/main.c:887
 do_init_module+0x1b5/0x547 kernel/module.c:3456
 load_module+0x6405/0x8c10 kernel/module.c:3804
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
 do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 5987:
 set_track mm/kasan/common.c:87 [inline]
 __kasan_slab_free+0x130/0x180 mm/kasan/common.c:459
 slab_free_hook mm/slub.c:1429 [inline]
 slab_free_freelist_hook mm/slub.c:1456 [inline]
 slab_free mm/slub.c:3003 [inline]
 kfree+0xe1/0x270 mm/slub.c:3955
 configfs_register_default_group+0x9a/0xc0 fs/configfs/dir.c:1836
 0xffffffffc1bd0023
 do_one_initcall+0xbc/0x47d init/main.c:887
 do_init_module+0x1b5/0x547 kernel/module.c:3456
 load_module+0x6405/0x8c10 kernel/module.c:3804
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
 do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8881ef61ae00
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 32 bytes inside of
 192-byte region [ffff8881ef61ae00, ffff8881ef61aec0)
The buggy address belongs to the page:
page:ffffea0007bd8680 count:1 mapcount:0 mapping:ffff8881f6c03000 index:0xffff8881ef61a700
flags: 0x2fffc0000000200(slab)
raw: 02fffc0000000200 ffffea0007ca4740 0000000500000005 ffff8881f6c03000
raw: ffff8881ef61a700 000000008010000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881ef61ad00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881ef61ad80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff8881ef61ae00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff8881ef61ae80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8881ef61af00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 5cf6a51e6062 ("configfs: allow dynamic group creation")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 39843fa7e11b0..920d350df37b6 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1755,12 +1755,19 @@ int configfs_register_group(struct config_group *parent_group,
 
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
 	ret = create_default_group(parent_group, group);
-	if (!ret) {
-		spin_lock(&configfs_dirent_lock);
-		configfs_dir_set_ready(group->cg_item.ci_dentry->d_fsdata);
-		spin_unlock(&configfs_dirent_lock);
-	}
+	if (ret)
+		goto err_out;
+
+	spin_lock(&configfs_dirent_lock);
+	configfs_dir_set_ready(group->cg_item.ci_dentry->d_fsdata);
+	spin_unlock(&configfs_dirent_lock);
+	inode_unlock(d_inode(parent));
+	return 0;
+err_out:
 	inode_unlock(d_inode(parent));
+	mutex_lock(&subsys->su_mutex);
+	unlink_group(group);
+	mutex_unlock(&subsys->su_mutex);
 	return ret;
 }
 EXPORT_SYMBOL(configfs_register_group);
-- 
2.20.1

