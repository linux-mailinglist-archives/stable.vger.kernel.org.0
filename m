Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438F82AE064
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJUCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKJUB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:01:59 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54C952067D;
        Tue, 10 Nov 2020 20:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605038517;
        bh=c+tpJtE2ie5v3DjhIRDM1dZMkyEm24Bb86WSUoz/vbo=;
        h=Date:From:To:Subject:From;
        b=VvpkWjH9qH96BdHNTiGVeAq5oBaEA2BGrslGXUEENIxoJB1sShxdZK1ImDXcHaC4B
         SYy3zFx/0MeDO+ZIULtMMsRW0CM0kL9Ee392k35I6d9xzAqDupVT+pkCbC1hgmNlwU
         NnsvjsqGOD3fpbcP/H+0GUBB7TCK8M986YtXZfVM=
Date:   Tue, 10 Nov 2020 12:01:56 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, egorenar@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-userfaultfd-do-not-access-vma-vm_mm-after-calling-handle_userfault.patch
 added to -mm tree
Message-ID: <20201110200156.uwjeKxp84%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-do-not-access-vma-vm_mm-after-calling-handle_userfault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-do-not-access-vma-vm_mm-after-calling-handle_userfault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-do-not-access-vma-vm_mm-after-calling-handle_userfault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Alexander reported a syzkaller / KASAN finding on s390, see below for
complete output.

In do_huge_pmd_anonymous_page(), the pre-allocated pagetable will be freed
in some cases.  In the case of userfaultfd_missing(), this will happen
after calling handle_userfault(), which might have released the mmap_lock.
Therefore, the following pte_free(vma->vm_mm, pgtable) will access an
unstable vma->vm_mm, which could have been freed or re-used already.

For all architectures other than s390 this will go w/o any negative
impact, because pte_free() simply frees the page and ignores the passed-in
mm.  The implementation for SPARC32 would also access mm->page_table_lock
for pte_free(), but there is no THP support in SPARC32, so the buggy code
path will not be used there.

For s390, the mm->context.pgtable_list is being used to maintain the 2K
pagetable fragments, and operating on an already freed or even re-used mm
could result in various more or less subtle bugs due to list / pagetable
corruption.

Fix this by calling pte_free() before handle_userfault(), similar to how
it is already done in __do_huge_pmd_anonymous_page() for the WRITE /
non-huge_zero_page case.

Commit 6b251fc96cf2c ("userfaultfd: call handle_userfault() for
userfaultfd_missing() faults") actually introduced both, the
do_huge_pmd_anonymous_page() and also __do_huge_pmd_anonymous_page()
changes wrt to calling handle_userfault(), but only in the latter case it
put the pte_free() before calling handle_userfault().

==================================================================
BUG: KASAN: use-after-free in do_huge_pmd_anonymous_page+0xcda/0xd90 mm/huge_memory.c:744
Read of size 8 at addr 00000000962d6988 by task syz-executor.0/9334

CPU: 1 PID: 9334 Comm: syz-executor.0 Not tainted 5.10.0-rc1-syzkaller-07083-g4c9720875573 #0
Hardware name: IBM 3906 M04 701 (KVM/Linux)
Call Trace:
 [<00000000aa0a7a1c>] unwind_start arch/s390/include/asm/unwind.h:65 [inline]
 [<00000000aa0a7a1c>] show_stack+0x174/0x220 arch/s390/kernel/dumpstack.c:135
 [<00000000aa105952>] __dump_stack lib/dump_stack.c:77 [inline]
 [<00000000aa105952>] dump_stack+0x262/0x2e8 lib/dump_stack.c:118
 [<00000000aa0b484e>] print_address_description.constprop.0+0x5e/0x218 mm/kasan/report.c:385
 [<00000000a61f13aa>] __kasan_report mm/kasan/report.c:545 [inline]
 [<00000000a61f13aa>] kasan_report+0x11a/0x168 mm/kasan/report.c:562
 [<00000000a620d782>] do_huge_pmd_anonymous_page+0xcda/0xd90 mm/huge_memory.c:744
 [<00000000a610632e>] create_huge_pmd mm/memory.c:4256 [inline]
 [<00000000a610632e>] __handle_mm_fault+0xe6e/0x1068 mm/memory.c:4480
 [<00000000a61067b0>] handle_mm_fault+0x288/0x748 mm/memory.c:4607
 [<00000000a598b55c>] do_exception+0x394/0xae0 arch/s390/mm/fault.c:479
 [<00000000a598d7c4>] do_dat_exception+0x34/0x80 arch/s390/mm/fault.c:567
 [<00000000aa124e5e>] pgm_check_handler+0x1da/0x22c arch/s390/kernel/entry.S:706
 [<00000000aa0a6902>] copy_from_user_mvcos arch/s390/lib/uaccess.c:111 [inline]
 [<00000000aa0a6902>] raw_copy_from_user+0x3a/0x88 arch/s390/lib/uaccess.c:174
 [<00000000a7c24668>] _copy_from_user+0x48/0xa8 lib/usercopy.c:16
 [<00000000a5b0b2a8>] copy_from_user include/linux/uaccess.h:192 [inline]
 [<00000000a5b0b2a8>] __do_sys_sigaltstack kernel/signal.c:4064 [inline]
 [<00000000a5b0b2a8>] __s390x_sys_sigaltstack+0xc8/0x240 kernel/signal.c:4060
 [<00000000aa124a9c>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

Allocated by task 9334:
 stack_trace_save+0xbe/0xf0 kernel/stacktrace.c:121
 kasan_save_stack+0x30/0x60 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xd0/0xe8 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:526 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 slab_alloc mm/slub.c:2899 [inline]
 kmem_cache_alloc+0x118/0x348 mm/slub.c:2904
 vm_area_dup+0x9c/0x2b8 kernel/fork.c:356
 __split_vma+0xba/0x560 mm/mmap.c:2742
 split_vma+0xca/0x108 mm/mmap.c:2800
 mlock_fixup+0x4ae/0x600 mm/mlock.c:550
 apply_vma_lock_flags+0x2c6/0x398 mm/mlock.c:619
 do_mlock+0x1aa/0x718 mm/mlock.c:711
 __do_sys_mlock2 mm/mlock.c:738 [inline]
 __s390x_sys_mlock2+0x86/0xa8 mm/mlock.c:728
 system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

Freed by task 9333:
 stack_trace_save+0xbe/0xf0 kernel/stacktrace.c:121
 kasan_save_stack+0x30/0x60 mm/kasan/common.c:48
 kasan_set_track+0x32/0x48 mm/kasan/common.c:56
 kasan_set_free_info+0x34/0x50 mm/kasan/generic.c:355
 __kasan_slab_free+0x11e/0x190 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook mm/slub.c:1577 [inline]
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x7c/0x4b8 mm/slub.c:3158
 __vma_adjust+0x7b2/0x2508 mm/mmap.c:960
 vma_merge+0x87e/0xce0 mm/mmap.c:1209
 userfaultfd_release+0x412/0x6b8 fs/userfaultfd.c:868
 __fput+0x22c/0x7a8 fs/file_table.c:281
 task_work_run+0x200/0x320 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 do_notify_resume+0x100/0x148 arch/s390/kernel/signal.c:538
 system_call+0xe6/0x28c arch/s390/kernel/entry.S:416

The buggy address belongs to the object at 00000000962d6948
 which belongs to the cache vm_area_struct of size 200
The buggy address is located 64 bytes inside of
 200-byte region [00000000962d6948, 00000000962d6a10)
The buggy address belongs to the page:
page:00000000313a09fe refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x962d6
flags: 0x3ffff00000000200(slab)
raw: 3ffff00000000200 000040000257e080 0000000c0000000c 000000008020ba00
raw: 0000000000000000 000f001e00000000 ffffffff00000001 0000000096959501
page dumped because: kasan: bad access detected
page->mem_cgroup:0000000096959501

Memory state around the buggy address:
 00000000962d6880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 00000000962d6900: 00 fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
>00000000962d6980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 00000000962d6a00: fb fb fc fc fc fc fc fc fc fc 00 00 00 00 00 00
 00000000962d6a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

Link: https://lkml.kernel.org/r/20201110190329.11920-1-gerald.schaefer@linux.ibm.com
Fixes: 6b251fc96cf2c ("userfaultfd: call handle_userfault() for userfaultfd_missing() faults")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-userfaultfd-do-not-access-vma-vm_mm-after-calling-handle_userfault
+++ a/mm/huge_memory.c
@@ -710,7 +710,6 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
 		struct page *zero_page;
-		bool set;
 		vm_fault_t ret;
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (unlikely(!pgtable))
@@ -723,25 +722,25 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		}
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
-		set = false;
 		if (pmd_none(*vmf->pmd)) {
 			ret = check_stable_address_space(vma->vm_mm);
 			if (ret) {
 				spin_unlock(vmf->ptl);
+				pte_free(vma->vm_mm, pgtable);
 			} else if (userfaultfd_missing(vma)) {
 				spin_unlock(vmf->ptl);
+				pte_free(vma->vm_mm, pgtable);
 				ret = handle_userfault(vmf, VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
 				set_huge_zero_page(pgtable, vma->vm_mm, vma,
 						   haddr, vmf->pmd, zero_page);
 				spin_unlock(vmf->ptl);
-				set = true;
 			}
-		} else
+		} else {
 			spin_unlock(vmf->ptl);
-		if (!set)
 			pte_free(vma->vm_mm, pgtable);
+		}
 		return ret;
 	}
 	gfp = alloc_hugepage_direct_gfpmask(vma);
_

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are

mm-userfaultfd-do-not-access-vma-vm_mm-after-calling-handle_userfault.patch

