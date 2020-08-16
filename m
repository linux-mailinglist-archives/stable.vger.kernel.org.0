Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB3724E23A
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 22:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgHUUqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 16:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUUqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 16:46:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48209C061573;
        Fri, 21 Aug 2020 13:46:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t11so1411058plr.5;
        Fri, 21 Aug 2020 13:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DE5SPmJa0Jtc878oOnDyAAxuHxQ/uszHB5NDDF1X0Zw=;
        b=s9rfFkng/tXyb5bH4GYYZOvYrX1sZCUN2+X6sQu91WRnAJ1IUNVt6vg9A/amvnv069
         /UDPE8sB15nJ3Xt+SG1CIhTbW6DTphdJbnIfBbrcqGN2sw35dvWGRGfW7bglE2htcnzC
         8lrHKsu2rrIEVHv/XwqJjPZU0Wev8hCT0rGT3zL2T0pufmtuHnGa/8eSpkQVI+3YRT7x
         dDbpIzV3pVR4RJ9ZCzW0IE92NRfVdU4hphXbv8dxhiCCjUcqNAaxTEzkdVaX8ClqVQjH
         wfELQBxz6bd1FkZLrK68Au1qReXrT4y/fujpIhXfz44sMslex67Ia4JwqMUy2aChObst
         sUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DE5SPmJa0Jtc878oOnDyAAxuHxQ/uszHB5NDDF1X0Zw=;
        b=h0wIyr6SXK1/KX2dGGHykjvowHYORgqAB1ae4zJwJ6sf4zVStUD55Kt5Py6hoaGEaI
         RB3TPGTDg4WHJfHWzpM5+m2bN2yA5GpFZ3MrbSKqQmCsxMqIbiHQXpWASuj8yV5Sc+NO
         v0x2Fh2DK6RVgdDoj9l/pExapE9q+3LoAJEmE2sSDQN8m4ow3SjSyD7j7/8KqJumuK+3
         anscuyr0Uatuopv/5IIn1Q5dBJahZTcNEeoBkBlWLauVuBf3Fwz5z+ujP9TWpcZlgMrq
         TFFMntTaR+lJoGgk6/rcgYQM+Jp+/ck8f873CEWM8qPYzE/K4BMm7CE0FWyuAn4Od9v9
         Hsog==
X-Gm-Message-State: AOAM533tM4YKfV+8/ONbUM+5RV9sHHwHaLWOnYvR7URpaOODq/XO+cff
        r5/ybTa6+gJfzQoDQ1jWMuU=
X-Google-Smtp-Source: ABdhPJxRYstwLNpWOZ5J3DjR1qCaSj/+573CyfsBmhuLjw9gbA8bjW7jyR5d7x1cxoscjEjYLSC4Sg==
X-Received: by 2002:a17:902:ff0c:: with SMTP id f12mr3793627plj.326.1598042809822;
        Fri, 21 Aug 2020 13:46:49 -0700 (PDT)
Received: from localhost.localdomain (c-107-3-138-210.hsd1.ca.comcast.net. [107.3.138.210])
        by smtp.gmail.com with ESMTPSA id g4sm2795816pjh.32.2020.08.21.13.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:46:48 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     jack@suse.cz, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: madvise: fix vma user-after-free
Date:   Sun, 16 Aug 2020 07:12:04 -0700
Message-Id: <20200816141204.162624-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

It is because vma is accessed after releasing mmap_sem, but someone else
acquired the mmap_sem and the vma is gone.

Releasing mmap_sem after accessing vma should fix the problem.

Fixes: 692fe62433d4c ("mm: Handle MADV_WILLNEED through vfs_fadvise()")
Reported-by: syzbot+b90df26038d1d5d85c97@syzkaller.appspotmail.com
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org> v5.4+
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index dd1d43cf026d..d4aa5f776543 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -289,9 +289,9 @@ static long madvise_willneed(struct vm_area_struct *vma,
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
-- 
2.26.2

