Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C436F244FDA
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 00:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgHNWb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 18:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgHNWbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Aug 2020 18:31:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97F2A20716;
        Fri, 14 Aug 2020 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597444315;
        bh=XP66Pq+Ux3vvBHhb4rwTJW8fprvue7ksOhrK7VZMBFc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dmHcqfEYyoFIrSaK2Ns6iANFO73RlrHwTq/xLKig7QsH2jELwRtbu0O4DF42uYRaq
         LgG4DAKWfek47+gc40zjvsBm5bqCny+OYWlGZMiCTcx4faux2IUx9L3FQknY5T1ZRK
         mNHm6ggN5smXgPhlmMbgKCoeR5LFEmokP1RAOVec=
Date:   Fri, 14 Aug 2020 15:31:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, edumazet@google.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org, syzkaller@googlegroups.com
Subject:  +
 khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch added to -mm
 tree
Message-ID: <20200814223154.GPMju05_c%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
has been added to the -mm tree.  Its filename is
     khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-debug-fix-debug_dma_assert_idle-use-rcu_read_lock.patch
khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch

