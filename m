Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2447F943
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 23:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhLZWUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 17:20:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58374 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhLZWUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 17:20:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4195A60F17;
        Sun, 26 Dec 2021 22:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E82EC36AE9;
        Sun, 26 Dec 2021 22:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557216;
        bh=g5LqZMxyruUxGR3bfmbtmXz6SMLnDiRS+J9IkoyXB1Y=;
        h=Date:From:To:Subject:From;
        b=YrWrfaT3a6PMdfTiQYEGJk7gbPoHUxkBbgkbMC72j9cTWef7qWdPTy7Edcm5NYFEr
         nuL6NdDOnxW+RB7oluPFrQ/pNDd4QnKRBWo5XR0GhGf0hJSFvAElFvgOz7mKrXC+Us
         3y+1lXedOxcNFf1I27mKrjcjM+JNLfB3c4iEuUcY=
Date:   Sun, 26 Dec 2021 14:20:15 -0800
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, liushixin2@huawei.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org
Subject:  [merged]
 mm-hwpoison-clear-mf_count_increased-before-retrying-get_any_page.patch
 removed from -mm tree
Message-ID: <20211226222015.f6PnqN9cH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-clear-mf_count_increased-before-retrying-get_any_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()

Hulk Robot reported a panic in put_page_testzero() when testing madvise()
with MADV_SOFT_OFFLINE.  The BUG() is triggered when retrying
get_any_page().  This is because we keep MF_COUNT_INCREASED flag in second
try but the refcnt is not increased.

 page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
 ------------[ cut here ]------------
 kernel BUG at include/linux/mm.h:737!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 5 PID: 2135 Comm: sshd Tainted: G    B             5.16.0-rc6-dirty #373
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 RIP: 0010:release_pages+0x53f/0x840
 Code: 0c 01 4c 8d 60 ff e9 5b fb ff ff 48 c7 c6 d8 97 0c b3 4c 89 e7 48 83 05 0e 7b 3c 0c 01 e8 89 3d 04 00 48 83 05 11 7b 3c 0c 01 <0f> 0b 48 83 05 0f 7b 3c 0c 01 48 83 05 0f 7b 3c 0c 01 48 83 05f
 RSP: 0018:ffffc900015a7bc0 EFLAGS: 00010002
 RAX: 000000000000003e RBX: ffffffffbace04c8 RCX: 0000000000000002
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
 RBP: ffff88817b9acd50 R08: 0000000000000000 R09: c0000000ffefffff
 R10: 0000000000000001 R11: ffffc900015a79b0 R12: ffffea0005e1c900
 R13: ffffea0005e1de88 R14: 000000000000001f R15: ffff888100071000
 FS:  0000000000000000(0000) GS:ffff88842fb40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f305e8de3d4 CR3: 000000017bb6f000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  free_pages_and_swap_cache+0x64/0x80
  tlb_flush_mmu+0x6f/0x220
  unmap_page_range+0xe6c/0x12c0
  unmap_single_vma+0x90/0x170
  unmap_vmas+0xc4/0x180
  exit_mmap+0xde/0x3a0
  mmput+0xa3/0x250
  do_exit+0x564/0x1470
  do_group_exit+0x3b/0x100
  __do_sys_exit_group+0x13/0x20
  __x64_sys_exit_group+0x16/0x20
  do_syscall_64+0x34/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f30625401d9
 Code: Unable to access opcode bytes at RIP 0x7f30625401af.
 RSP: 002b:00007ffe391b0c88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
 RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f30625401d9
 RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000001
 RBP: 00007f306283d838 R08: 000000000000003c R09: 00000000000000e7
 R10: fffffffffffffe30 R11: 0000000000000246 R12: 00007f306283d838
 R13: 00007f3062842e80 R14: 0000000000000000 R15: ffffaa4fb7932430
  </TASK>
 Modules linked in:
 ---[ end trace e99579b570fe0649 ]---
 RIP: 0010:release_pages+0x53f/0x840
 Code: 0c 01 4c 8d 60 ff e9 5b fb ff ff 48 c7 c6 d8 97 0c b3 4c 89 e7 48 83 05 0e 7b 3c 0c 01 e8 89 3d 04 00 48 83 05 11 7b 3c 0c 01 <0f> 0b 48 83 05 0f 7b 3c 0c 01 48 83 05 0f 7b 3c 0c 01 48 83 05f
 RSP: 0018:ffffc900015a7bc0 EFLAGS: 00010002
 RAX: 000000000000003e RBX: ffffffffbace04c8 RCX: 0000000000000002
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
 RBP: ffff88817b9acd50 R08: 0000000000000000 R09: c0000000ffefffff
 R10: 0000000000000001 R11: ffffc900015a79b0 R12: ffffea0005e1c900
 R13: ffffea0005e1de88 R14: 000000000000001f R15: ffff888100071000
 FS:  0000000000000000(0000) GS:ffff88842fb40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f305e8de3d4 CR3: 000000017bb6f000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Link: https://lkml.kernel.org/r/20211221074908.3910286-1-liushixin2@huawei.com
Fixes: b94e02822deb ("mm,hwpoison: try to narrow window race for free pages")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-hwpoison-clear-mf_count_increased-before-retrying-get_any_page
+++ a/mm/memory-failure.c
@@ -2234,6 +2234,7 @@ retry:
 	} else if (ret == 0) {
 		if (soft_offline_free_page(page) && try_again) {
 			try_again = false;
+			flags &= ~MF_COUNT_INCREASED;
 			goto retry;
 		}
 	}
_

Patches currently in -mm which might be from liushixin2@huawei.com are


