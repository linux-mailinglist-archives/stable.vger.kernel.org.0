Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9375950DDB9
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbiDYKVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbiDYKVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:21:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ABB377D6
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A506B8124B
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11937C385A4;
        Mon, 25 Apr 2022 10:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650881846;
        bh=6tMSq1E1kA8qEJF8I+tHOp/Uec2FjKYT34zJZawgxAw=;
        h=Subject:To:Cc:From:Date:From;
        b=K8GbS9iz+XYD1ecb8RyfRkA3+0xFVJFIcE5WtryCDbxBDbAHlrs24zlmDZ4VgxSur
         vexncxxeyhNAZE4+17iKVLcZ4RyD0+RF1wpJc/yktXpjE5pBLCgIkD/HzxY98CSths
         uysGbr71D/uXl1yVzyVEGeKVzqmDemVTE0Jjde+A=
Subject: FAILED: patch "[PATCH] mm, hugetlb: allow for "high" userspace addresses" failed to apply to 5.4-stable tree
To:     christophe.leroy@csgroup.eu, akpm@linux-foundation.org,
        catalin.marinas@arm.com, stable@vger.kernel.org,
        steve.capper@arm.com, torvalds@linux-foundation.org,
        will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 12:17:23 +0200
Message-ID: <165088184361211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f24d5a579d1eace79d505b148808a850b417d4c Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Thu, 21 Apr 2022 16:35:46 -0700
Subject: [PATCH] mm, hugetlb: allow for "high" userspace addresses

This is a fix for commit f6795053dac8 ("mm: mmap: Allow for "high"
userspace addresses") for hugetlb.

This patch adds support for "high" userspace addresses that are
optionally supported on the system and have to be requested via a hint
mechanism ("high" addr parameter to mmap).

Architectures such as powerpc and x86 achieve this by making changes to
their architectural versions of hugetlb_get_unmapped_area() function.
However, arm64 uses the generic version of that function.

So take into account arch_get_mmap_base() and arch_get_mmap_end() in
hugetlb_get_unmapped_area().  To allow that, move those two macros out
of mm/mmap.c into include/linux/sched/mm.h

If these macros are not defined in architectural code then they default
to (TASK_SIZE) and (base) so should not introduce any behavioural
changes to architectures that do not define them.

For the time being, only ARM64 is affected by this change.

Catalin (ARM64) said
 "We should have fixed hugetlb_get_unmapped_area() as well when we added
  support for 52-bit VA. The reason for commit f6795053dac8 was to
  prevent normal mmap() from returning addresses above 48-bit by default
  as some user-space had hard assumptions about this.

  It's a slight ABI change if you do this for hugetlb_get_unmapped_area()
  but I doubt anyone would notice. It's more likely that the current
  behaviour would cause issues, so I'd rather have them consistent.

  Basically when arm64 gained support for 52-bit addresses we did not
  want user-space calling mmap() to suddenly get such high addresses,
  otherwise we could have inadvertently broken some programs (similar
  behaviour to x86 here). Hence we added commit f6795053dac8. But we
  missed hugetlbfs which could still get such high mmap() addresses. So
  in theory that's a potential regression that should have bee addressed
  at the same time as commit f6795053dac8 (and before arm64 enabled
  52-bit addresses)"

Link: https://lkml.kernel.org/r/ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu
Fixes: f6795053dac8 ("mm: mmap: Allow for "high" userspace addresses")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>	[5.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 99c7477cee5c..dd3a088db11d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -206,7 +206,7 @@ hugetlb_get_unmapped_area_bottomup(struct file *file, unsigned long addr,
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = arch_get_mmap_end(addr);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
@@ -222,7 +222,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit = current->mm->mmap_base;
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
@@ -237,7 +237,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = current->mm->mmap_base;
-		info.high_limit = TASK_SIZE;
+		info.high_limit = arch_get_mmap_end(addr);
 		addr = vm_unmapped_area(&info);
 	}
 
@@ -251,6 +251,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -266,7 +267,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (mmap_end - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index a80356e9dc69..1ad1f4bfa025 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -136,6 +136,14 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
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
diff --git a/mm/mmap.c b/mm/mmap.c
index 3aa839f81e63..313b57d55a63 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2117,14 +2117,6 @@ unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
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

