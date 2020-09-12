Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E69267B67
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 18:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgILQYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 12:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgILQYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E235E21D79;
        Sat, 12 Sep 2020 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927837;
        bh=VBWGgelfRygTMFumftFkX6QVY2TITjkLrq3QthVYdaY=;
        h=Date:From:To:Subject:From;
        b=lRCzmsjqWqM7RVJoYfhETVR445xONOw7ymePEzwI577IMCNaqLb4fb2A9SgbgyVad
         O4rDl+OOB3ReaoIXaYVH3XEq/a/m3965NOJrcZZGxGcJ/dqEey2pXHTJHfrRyzy6kX
         RVqwdlAKFxanQmBihBfVTl1LRWS0DKOL16qhUlbc=
Date:   Sat, 12 Sep 2020 09:23:56 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jack@suse.cz,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        stable@vger.kernel.org
Subject:  [merged] mm-madvise-fix-vma-user-after-free.patch removed
 from -mm tree
Message-ID: <20200912162356.nGzdZR4yV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: madvise: fix vma user-after-free
has been removed from the -mm tree.  Its filename was
     mm-madvise-fix-vma-user-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: madvise: fix vma user-after-free

The syzbot reported the below use-after-free:

BUG: KASAN: use-after-free in madvise_willneed mm/madvise.c:293 [inline]
BUG: KASAN: use-after-free in madvise_vma mm/madvise.c:942 [inline]
BUG: KASAN: use-after-free in do_madvise.part.0+0x1c8b/0x1cf0 mm/madvise.c:1145
Read of size 8 at addr ffff8880a6163eb0 by task syz-executor.0/9996

CPU: 0 PID: 9996 Comm: syz-executor.0 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 madvise_willneed mm/madvise.c:293 [inline]
 madvise_vma mm/madvise.c:942 [inline]
 do_madvise.part.0+0x1c8b/0x1cf0 mm/madvise.c:1145
 do_madvise mm/madvise.c:1169 [inline]
 __do_sys_madvise mm/madvise.c:1171 [inline]
 __se_sys_madvise mm/madvise.c:1169 [inline]
 __x64_sys_madvise+0xd9/0x110 mm/madvise.c:1169
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d4d9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f04f7464c78 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 0000000000020800 RCX: 000000000045d4d9
RDX: 0000000000000003 RSI: 0000000000600003 RDI: 0000000020000000
RBP: 000000000118d020 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cfec
R13: 00007ffc579cce7f R14: 00007f04f74659c0 R15: 000000000118cfec

Allocated by task 9992:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:518 [inline]
 slab_alloc mm/slab.c:3312 [inline]
 kmem_cache_alloc+0x138/0x3a0 mm/slab.c:3482
 vm_area_alloc+0x1c/0x110 kernel/fork.c:347
 mmap_region+0x8e5/0x1780 mm/mmap.c:1743
 do_mmap+0xcf9/0x11d0 mm/mmap.c:1545
 vm_mmap_pgoff+0x195/0x200 mm/util.c:506
 ksys_mmap_pgoff+0x43a/0x560 mm/mmap.c:1596
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 9992:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kmem_cache_free.part.0+0x67/0x1f0 mm/slab.c:3693
 remove_vma+0x132/0x170 mm/mmap.c:184
 remove_vma_list mm/mmap.c:2613 [inline]
 __do_munmap+0x743/0x1170 mm/mmap.c:2869
 do_munmap mm/mmap.c:2877 [inline]
 mmap_region+0x257/0x1780 mm/mmap.c:1716
 do_mmap+0xcf9/0x11d0 mm/mmap.c:1545
 vm_mmap_pgoff+0x195/0x200 mm/util.c:506
 ksys_mmap_pgoff+0x43a/0x560 mm/mmap.c:1596
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

It is because vma is accessed after releasing mmap_lock, but someone else
acquired the mmap_lock and the vma is gone.

Releasing mmap_lock after accessing vma should fix the problem.

Link: https://lkml.kernel.org/r/20200816141204.162624-1-shy828301@gmail.com
Fixes: 692fe62433d4c ("mm: Handle MADV_WILLNEED through vfs_fadvise()")
Reported-by: syzbot+b90df26038d1d5d85c97@syzkaller.appspotmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-fix-vma-user-after-free
+++ a/mm/madvise.c
@@ -289,9 +289,9 @@ static long madvise_willneed(struct vm_a
 	 */
 	*prev = NULL;	/* tell sys_madvise we drop mmap_lock */
 	get_file(file);
-	mmap_read_unlock(current->mm);
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	mmap_read_unlock(current->mm);
 	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
 	fput(file);
 	mmap_read_lock(current->mm);
_

Patches currently in -mm which might be from shy828301@gmail.com are


