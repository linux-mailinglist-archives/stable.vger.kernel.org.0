Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EDE2AC2E3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgKIRyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:54:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIRyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:54:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 282FC2067D;
        Mon,  9 Nov 2020 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604944458;
        bh=afkzYTJH2FFHP7OdK2XxjTbf6mK9wq4riukRrL18tjo=;
        h=Subject:To:From:Date:From;
        b=JtTvCm0Mmy0XJZV4Hx2Y9Jp0Q6G+z8FJy7U4KLvop/4T50vX/zSN5p1j9tNp10n9B
         JMP2q5YCHseAnqjanaKgQ0CsfgYILmVUyVrxelqzKB8Jw/t30crLCJHTD7/JIfNmXq
         +zCaDyNvF4L5jOKuKZuB+cOZ9chg4YI/L43gtO2U=
Subject: patch "uio: Fix use-after-free in uio_unregister_device()" added to char-misc-linus
To:     shinichiro.kawasaki@wdc.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 18:55:17 +0100
Message-ID: <1604944517209210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    uio: Fix use-after-free in uio_unregister_device()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 092561f06702dd4fdd7fb74dd3a838f1818529b7 Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Mon, 2 Nov 2020 21:28:19 +0900
Subject: uio: Fix use-after-free in uio_unregister_device()

Commit 8fd0e2a6df26 ("uio: free uio id after uio file node is freed")
triggered KASAN use-after-free failure at deletion of TCM-user
backstores [1].

In uio_unregister_device(), struct uio_device *idev is passed to
uio_free_minor() to refer idev->minor. However, before uio_free_minor()
call, idev is already freed by uio_device_release() during call to
device_unregister().

To avoid reference to idev->minor after idev free, keep idev->minor
value in a local variable. Also modify uio_free_minor() argument to
receive the value.

[1]
BUG: KASAN: use-after-free in uio_unregister_device+0x166/0x190
Read of size 4 at addr ffff888105196508 by task targetcli/49158

CPU: 3 PID: 49158 Comm: targetcli Not tainted 5.10.0-rc1 #1
Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015
Call Trace:
 dump_stack+0xae/0xe5
 ? uio_unregister_device+0x166/0x190
 print_address_description.constprop.0+0x1c/0x210
 ? uio_unregister_device+0x166/0x190
 ? uio_unregister_device+0x166/0x190
 kasan_report.cold+0x37/0x7c
 ? kobject_put+0x80/0x410
 ? uio_unregister_device+0x166/0x190
 uio_unregister_device+0x166/0x190
 tcmu_destroy_device+0x1c4/0x280 [target_core_user]
 ? tcmu_release+0x90/0x90 [target_core_user]
 ? __mutex_unlock_slowpath+0xd6/0x5d0
 target_free_device+0xf3/0x2e0 [target_core_mod]
 config_item_cleanup+0xea/0x210
 configfs_rmdir+0x651/0x860
 ? detach_groups.isra.0+0x380/0x380
 vfs_rmdir.part.0+0xec/0x3a0
 ? __lookup_hash+0x20/0x150
 do_rmdir+0x252/0x320
 ? do_file_open_root+0x420/0x420
 ? strncpy_from_user+0xbc/0x2f0
 ? getname_flags.part.0+0x8e/0x450
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f9e2bfc91fb
Code: 73 01 c3 48 8b 0d 9d ec 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 54 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6d ec 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffdd2baafe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 00007f9e2beb44a0 RCX: 00007f9e2bfc91fb
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007f9e1c20be90
RBP: 00007ffdd2bab000 R08: 0000000000000000 R09: 00007f9e2bdf2440
R10: 00007ffdd2baaf37 R11: 0000000000000246 R12: 00000000ffffff9c
R13: 000055f9abb7e390 R14: 000055f9abcf9558 R15: 00007f9e2be7a780

Allocated by task 34735:
 kasan_save_stack+0x1b/0x40
 __kasan_kmalloc.constprop.0+0xc2/0xd0
 __uio_register_device+0xeb/0xd40
 tcmu_configure_device+0x5a0/0xbc0 [target_core_user]
 target_configure_device+0x12f/0x760 [target_core_mod]
 target_dev_enable_store+0x32/0x50 [target_core_mod]
 configfs_write_file+0x2bb/0x450
 vfs_write+0x1ce/0x610
 ksys_write+0xe9/0x1b0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 49158:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x1b/0x30
 __kasan_slab_free+0x110/0x150
 slab_free_freelist_hook+0x5a/0x170
 kfree+0xc6/0x560
 device_release+0x9b/0x210
 kobject_put+0x13e/0x410
 uio_unregister_device+0xf9/0x190
 tcmu_destroy_device+0x1c4/0x280 [target_core_user]
 target_free_device+0xf3/0x2e0 [target_core_mod]
 config_item_cleanup+0xea/0x210
 configfs_rmdir+0x651/0x860
 vfs_rmdir.part.0+0xec/0x3a0
 do_rmdir+0x252/0x320
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888105196000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1288 bytes inside of
 2048-byte region [ffff888105196000, ffff888105196800)
The buggy address belongs to the page:
page:0000000098e6ca81 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x105190
head:0000000098e6ca81 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x17ffffc0010200(slab|head)
raw: 0017ffffc0010200 dead000000000100 dead000000000122 ffff888100043040
raw: 0000000000000000 0000000000080008 00000001ffffffff ffff88810eb55c01
page dumped because: kasan: bad access detected
page->mem_cgroup:ffff88810eb55c01

Memory state around the buggy address:
 ffff888105196400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888105196480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888105196500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888105196580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888105196600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 8fd0e2a6df26 ("uio: free uio id after uio file node is freed")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20201102122819.2346270-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 6dca744e39e9..be06f1a961c2 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -413,10 +413,10 @@ static int uio_get_minor(struct uio_device *idev)
 	return retval;
 }
 
-static void uio_free_minor(struct uio_device *idev)
+static void uio_free_minor(unsigned long minor)
 {
 	mutex_lock(&minor_lock);
-	idr_remove(&uio_idr, idev->minor);
+	idr_remove(&uio_idr, minor);
 	mutex_unlock(&minor_lock);
 }
 
@@ -990,7 +990,7 @@ int __uio_register_device(struct module *owner,
 err_uio_dev_add_attributes:
 	device_del(&idev->dev);
 err_device_create:
-	uio_free_minor(idev);
+	uio_free_minor(idev->minor);
 	put_device(&idev->dev);
 	return ret;
 }
@@ -1042,11 +1042,13 @@ EXPORT_SYMBOL_GPL(__devm_uio_register_device);
 void uio_unregister_device(struct uio_info *info)
 {
 	struct uio_device *idev;
+	unsigned long minor;
 
 	if (!info || !info->uio_dev)
 		return;
 
 	idev = info->uio_dev;
+	minor = idev->minor;
 
 	mutex_lock(&idev->info_lock);
 	uio_dev_del_attributes(idev);
@@ -1062,7 +1064,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	device_unregister(&idev->dev);
 
-	uio_free_minor(idev);
+	uio_free_minor(minor);
 
 	return;
 }
-- 
2.29.2


