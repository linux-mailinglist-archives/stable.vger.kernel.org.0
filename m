Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7AD51A657
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354198AbiEDQzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354423AbiEDQyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976FA49262;
        Wed,  4 May 2022 09:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EC1C61720;
        Wed,  4 May 2022 16:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCE0C385AA;
        Wed,  4 May 2022 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682970;
        bh=IcffKqrIjDpWaE+eFv6pgrk0nUGEy/hPN412MBHASuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwlZ3ynF8cGULANMzvIKmOjyibEgnA+YTmwAknCpN0Nv7b85oMmKOX/JgldxRmaP9
         BQmW/mnmkIRVAlrnoCbfCKYR3NlW9WPnR/c/ghpyW3tBIQJxG3O5aIxcpI/V7bkPZw
         XVSTH+MbXGrMPzBfOVnDn6ADsSG+7ZagN1KH3DNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 84/84] mm, hugetlb: allow for "high" userspace addresses
Date:   Wed,  4 May 2022 18:45:05 +0200
Message-Id: <20220504152934.064553310@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 5f24d5a579d1eace79d505b148808a850b417d4c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c     |    9 +++++----
 include/linux/sched/mm.h |    8 ++++++++
 mm/mmap.c                |    8 --------
 3 files changed, 13 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -211,7 +211,7 @@ hugetlb_get_unmapped_area_bottomup(struc
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = arch_get_mmap_end(addr);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
@@ -227,7 +227,7 @@ hugetlb_get_unmapped_area_topdown(struct
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit = current->mm->mmap_base;
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
@@ -242,7 +242,7 @@ hugetlb_get_unmapped_area_topdown(struct
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = current->mm->mmap_base;
-		info.high_limit = TASK_SIZE;
+		info.high_limit = arch_get_mmap_end(addr);
 		addr = vm_unmapped_area(&info);
 	}
 
@@ -256,6 +256,7 @@ hugetlb_get_unmapped_area(struct file *f
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -271,7 +272,7 @@ hugetlb_get_unmapped_area(struct file *f
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (mmap_end - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -133,6 +133,14 @@ static inline void mm_update_next_owner(
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
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2077,14 +2077,6 @@ found_highest:
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


