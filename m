Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E04518497
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 14:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbiECMvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 08:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiECMvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 08:51:10 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473337A3C;
        Tue,  3 May 2022 05:47:37 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Kt09M6wzyz9sSq;
        Tue,  3 May 2022 14:47:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ejinAxCPstkj; Tue,  3 May 2022 14:47:35 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Kt09M63lXz9sSn;
        Tue,  3 May 2022 14:47:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BCFA08B77B;
        Tue,  3 May 2022 14:47:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PPSTBfDhbT_i; Tue,  3 May 2022 14:47:35 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.20])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 71D648B763;
        Tue,  3 May 2022 14:47:35 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 243ClKsA260150
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 3 May 2022 14:47:20 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 243ClJsP260148;
        Tue, 3 May 2022 14:47:19 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] [Rebased for 5.4] mm, hugetlb: allow for "high" userspace addresses
Date:   Tue,  3 May 2022 14:47:11 +0200
Message-Id: <9367809ff3091ff451f9ab6fc029cef553c758fa.1651581958.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1651582029; l=5089; s=20211009; h=from:subject:message-id; bh=ogEzEMBMkC2QXqa8vvpCE+RIFMurxIeQopO0YRX/1m8=; b=3s8YOQ5x6Ii/KDTsS52yKt5YsqtLHjwaSOFwU0sCrRqFZ7RP75/DEfYHa1IyPTgNvLBhB4sBDHsr R340SXK9CgQGwOPujyNH3CN9eFKDrb82aC8HkibpWpBXgVKPiBES
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for linux 5.4

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
 fs/hugetlbfs/inode.c     | 5 +++--
 include/linux/sched/mm.h | 8 ++++++++
 mm/mmap.c                | 8 --------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 358398b1fe0c..ca74ae4c0ad3 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -208,6 +208,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
 	struct vm_unmapped_area_info info;
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -223,7 +224,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (mmap_end - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
@@ -231,7 +232,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = TASK_UNMAPPED_BASE;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = arch_get_mmap_end(addr);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 3a1d899019af..ab0da04ac9ee 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -133,6 +133,14 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
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
index ba78f1f1b1bd..d69a50a541f8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2077,14 +2077,6 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
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
-- 
2.35.1

