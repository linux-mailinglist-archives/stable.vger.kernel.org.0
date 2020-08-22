Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2B24E8FF
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 19:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgHVR3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 13:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgHVR3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB392078D;
        Sat, 22 Aug 2020 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117386;
        bh=Z/SJoDT3dMF+/s6KquZ1/W4JOjHQ128HXs7K259xdZM=;
        h=Date:From:To:Subject:From;
        b=FxsX/+U/0GwewTPsqF2tepaE/INUkoCvziRqL6TIARQHbVWI4C48LQpFdMsQUjcLa
         e+9BKt1ulmQJ3QEoAM6dI6+JOGTcuCjzfpXX3jHaFQwmK5mxof2BFbyU68L2jBOImy
         eLV9QajLcJfh5plamHv5zQNfJVQzF2Lg195pxtsM=
Date:   Sat, 22 Aug 2020 10:29:46 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, edumazet@google.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        syzkaller@googlegroups.com
Subject:  [merged]
 khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch removed from -mm
 tree
Message-ID: <20200822172946.oZb62PwoZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
has been removed from the -mm tree.  Its filename was
     khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

syzbot crashes on the VM_BUG_ON_MM(khugepaged_test_exit(mm), mm) in
__khugepaged_enter(): yes, when one thread is about to dump core, has set
core_state, and is waiting for others, another might do something calling
__khugepaged_enter(), which now crashes because I lumped the core_state
test (known as "mmget_still_valid") into khugepaged_test_exit().  I still
think it's best to lump them together, so just in this exceptional case,
check mm->mm_users directly instead of khugepaged_test_exit().

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008141503370.18085@eggly.anvils
Fixes: bbe98f9cadff ("khugepaged: khugepaged_test_exit() check mmget_still_valid()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter
+++ a/mm/khugepaged.c
@@ -466,7 +466,7 @@ int __khugepaged_enter(struct mm_struct
 		return -ENOMEM;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
+	VM_BUG_ON_MM(atomic_read(&mm->mm_users) == 0, mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
_

Patches currently in -mm which might be from hughd@google.com are


