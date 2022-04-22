Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85E50BFB5
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 20:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiDVS2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 14:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiDVS2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 14:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ABC10522B;
        Fri, 22 Apr 2022 11:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA39B8321C;
        Fri, 22 Apr 2022 18:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76169C385A0;
        Fri, 22 Apr 2022 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651889;
        bh=i/TnTWKxOevTcmXSTuReN3T7aL9zVXl2rqXLarmgjl8=;
        h=Date:To:From:Subject:From;
        b=jQk0NT0TGSnIg3ZEqARVmn+0yiX84rmTVyoJL5zUMw8JzWZ1WVghGEvA2Eqq5fgL/
         kAmW8NJPxfgnyLUUqZdp+V8V25n6uvGHy500eAXvzqjFL7WAsAKVlNvZHudbnIjbY6
         NuE139W9e1VR2yITrHsX8eerss2tAiwPBI0zy1oI=
Date:   Fri, 22 Apr 2022 11:24:48 -0700
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        steve.capper@arm.com, stable@vger.kernel.org,
        catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hugetlbfs-allow-for-high-userspace-addresses.patch removed from -mm tree
Message-Id: <20220422182449.76169C385A0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: allow for "high" userspace addresses
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-allow-for-high-userspace-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm, hugetlb: allow for "high" userspace addresses

This is a fix for commit f6795053dac8 ("mm: mmap: Allow for "high"
userspace addresses") for hugetlb.

This patch adds support for "high" userspace addresses that are optionally
supported on the system and have to be requested via a hint mechanism
("high" addr parameter to mmap).

Architectures such as powerpc and x86 achieve this by making changes to
their architectural versions of hugetlb_get_unmapped_area() function. 
However, arm64 uses the generic version of that function.

So take into account arch_get_mmap_base() and arch_get_mmap_end() in
hugetlb_get_unmapped_area().  To allow that, move those two macros out of
mm/mmap.c into include/linux/sched/mm.h

If these macros are not defined in architectural code then they default to
(TASK_SIZE) and (base) so should not introduce any behavioural changes to
architectures that do not define them.

For the time being, only ARM64 is affected by this change.

Catalin (ARM64) said

: We should have fixed hugetlb_get_unmapped_area() as well when we added
: support for 52-bit VA.  The reason for commit f6795053dac8 was to prevent
: normal mmap() from returning addresses above 48-bit by default as some
: user-space had hard assumptions about this.
: 
: It's a slight ABI change if you do this for hugetlb_get_unmapped_area()
: but I doubt anyone would notice.  It's more likely that the current
: behaviour would cause issues, so I'd rather have them consistent.
:
: Basically when arm64 gained support for 52-bit addresses we did not
: want user-space calling mmap() to suddenly get such high addresses,
: otherwise we could have inadvertently broken some programs (similar
: behaviour to x86 here).  Hence we added commit f6795053dac8.  But we
: missed hugetlbfs which could still get such high mmap() addresses.  So
: in theory that's a potential regression that should have bee addressed
: at the same time as commit f6795053dac8 (and before arm64 enabled
: 52-bit addresses).

Link: https://lkml.kernel.org/r/ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu
Fixes: f6795053dac8 ("mm: mmap: Allow for "high" userspace addresses")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>	[5.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c     |    9 +++++----
 include/linux/sched/mm.h |    8 ++++++++
 mm/mmap.c                |    8 --------
 3 files changed, 13 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-allow-for-high-userspace-addresses
+++ a/fs/hugetlbfs/inode.c
@@ -206,7 +206,7 @@ hugetlb_get_unmapped_area_bottomup(struc
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = arch_get_mmap_end(addr);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
@@ -222,7 +222,7 @@ hugetlb_get_unmapped_area_topdown(struct
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit = current->mm->mmap_base;
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
@@ -237,7 +237,7 @@ hugetlb_get_unmapped_area_topdown(struct
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = current->mm->mmap_base;
-		info.high_limit = TASK_SIZE;
+		info.high_limit = arch_get_mmap_end(addr);
 		addr = vm_unmapped_area(&info);
 	}
 
@@ -251,6 +251,7 @@ hugetlb_get_unmapped_area(struct file *f
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -266,7 +267,7 @@ hugetlb_get_unmapped_area(struct file *f
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (mmap_end - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
--- a/include/linux/sched/mm.h~mm-hugetlbfs-allow-for-high-userspace-addresses
+++ a/include/linux/sched/mm.h
@@ -136,6 +136,14 @@ static inline void mm_update_next_owner(
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_MMU
+#ifndef arch_get_mmap_end
+#define arch_get_mmap_end(addr)	(TASK_SIZE)
+#endif
+
+#ifndef arch_get_mmap_base
+#define arch_get_mmap_base(addr, base) (base)
+#endif
+
 extern void arch_pick_mmap_layout(struct mm_struct *mm,
 				  struct rlimit *rlim_stack);
 extern unsigned long
--- a/mm/mmap.c~mm-hugetlbfs-allow-for-high-userspace-addresses
+++ a/mm/mmap.c
@@ -2117,14 +2117,6 @@ unsigned long vm_unmapped_area(struct vm
 	return addr;
 }
 
-#ifndef arch_get_mmap_end
-#define arch_get_mmap_end(addr)	(TASK_SIZE)
-#endif
-
-#ifndef arch_get_mmap_base
-#define arch_get_mmap_base(addr, base) (base)
-#endif
-
 /* Get an address range which is currently unmapped.
  * For shmat() with addr=0.
  *
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


