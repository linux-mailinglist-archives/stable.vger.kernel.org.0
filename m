Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A368261BC1
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgIHTID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbgIHQG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:06:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E344E23E1B;
        Tue,  8 Sep 2020 15:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580002;
        bh=I8d/qW8Ag5Oe9JmXjC+U2NHEEjtcfNhv1BJvHpXPVEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSPeSubkUbPQ/IFPqCoPejNM7Zaign6aw2BQ6cpVvcavZXKK/m37ecFttVTcprZyO
         2zMa74wOAiZHWMAzaPD3qVn58UNWivzFAJqNsQKurwlRAqrAFydorceVnvI+B+HUFO
         MAyGQXv7DWKauMf8CKW239O0RFQaQUENhPbP3NI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b90df26038d1d5d85c97@syzkaller.appspotmail.com,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 121/129] mm: madvise: fix vma user-after-free
Date:   Tue,  8 Sep 2020 17:26:02 +0200
Message-Id: <20200908152235.894741663@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit 7867fd7cc44e63c6673cd0f8fea155456d34d0de upstream.

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

  Allocated by task 9992:
    kmem_cache_alloc+0x138/0x3a0 mm/slab.c:3482
    vm_area_alloc+0x1c/0x110 kernel/fork.c:347
    mmap_region+0x8e5/0x1780 mm/mmap.c:1743
    do_mmap+0xcf9/0x11d0 mm/mmap.c:1545
    vm_mmap_pgoff+0x195/0x200 mm/util.c:506
    ksys_mmap_pgoff+0x43a/0x560 mm/mmap.c:1596
    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

  Freed by task 9992:
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

It is because vma is accessed after releasing mmap_lock, but someone
else acquired the mmap_lock and the vma is gone.

Releasing mmap_lock after accessing vma should fix the problem.

Fixes: 692fe62433d4c ("mm: Handle MADV_WILLNEED through vfs_fadvise()")
Reported-by: syzbot+b90df26038d1d5d85c97@syzkaller.appspotmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>	[5.4+]
Link: https://lkml.kernel.org/r/20200816141204.162624-1-shy828301@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -288,9 +288,9 @@ static long madvise_willneed(struct vm_a
 	 */
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 	get_file(file);
-	up_read(&current->mm->mmap_sem);
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	up_read(&current->mm->mmap_sem);
 	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
 	fput(file);
 	down_read(&current->mm->mmap_sem);


