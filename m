Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF50349D7A3
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 02:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiA0By2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 20:54:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59586 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiA0By1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 20:54:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CFDC61C1A;
        Thu, 27 Jan 2022 01:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1CAC340E7;
        Thu, 27 Jan 2022 01:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643248467;
        bh=OPW8zGNwD8UsHs50Ux/JGsuNPeShoa0uo8igMI6BEoI=;
        h=Date:From:To:Subject:From;
        b=vNqs9F9LBqtVxQ1iUurBHHM2SXiwmDMkog6LA0UxbTurBtbK1oBk/s9VwIvvTrutk
         pYvPtDQ+bU8CVhfAwnAn+OhSSQRvN86lfMMq1NpzehZjoVOJVfU75EvWXhSnxbQ5wH
         CrS+ydXBACUiP/gc+JUSSr2CNu4gt1FaqPv1WvTM=
Date:   Wed, 26 Jan 2022 17:54:26 -0800
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        wmessmer@microsoft.com
Subject:  +
 coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch added
 to -mm tree
Message-ID: <20220127015426.x6Ewcg_BH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coredump: also dump first pages of non-executable ELF libraries
has been added to the -mm tree.  Its filename is
     coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: coredump: also dump first pages of non-executable ELF libraries

When I rewrote the VMA dumping logic for coredumps, I changed it to
recognize ELF library mappings based on the file being executable instead
of the mapping having an ELF header.  But turns out, distros ship many ELF
libraries as non-executable, so the heuristic goes wrong...

Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of
any offset-0 readable mapping that starts with the ELF magic.

This fix is technically layer-breaking a bit, because it checks for
something ELF-specific in fs/coredump.c; but since we probably want to
share this between standard ELF and FDPIC ELF anyway, I guess it's fine? 
And this also keeps the change small for backporting.

Link: https://lkml.kernel.org/r/20220126025739.2014888-1-jannh@google.com
Fixes: 429a22e776a2 ("coredump: rework elf/elf_fdpic vma_dump_size() into c=
ommon helper")
Signed-off-by: Jann Horn <jannh@google.com>
Reported-by: Bill Messmer <wmessmer@microsoft.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

--- a/fs/coredump.c~coredump-also-dump-first-pages-of-non-executable-elf-libraries
+++ a/fs/coredump.c
@@ -42,6 +42,7 @@
 #include <linux/path.h>
 #include <linux/timekeeping.h>
 #include <linux/sysctl.h>
+#include <linux/elf.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -980,6 +981,8 @@ static bool always_dump_vma(struct vm_ar
 	return false;
 }
 
+#define DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER 1
+
 /*
  * Decide how much of @vma's contents should be included in a core dump.
  */
@@ -1039,9 +1042,20 @@ static unsigned long vma_dump_size(struc
 	 * dump the first page to aid in determining what was mapped here.
 	 */
 	if (FILTER(ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ) &&
-	    (READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
-		return PAGE_SIZE;
+	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
+		if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
+			return PAGE_SIZE;
+
+		/*
+		 * ELF libraries aren't always executable.
+		 * We'll want to check whether the mapping starts with the ELF
+		 * magic, but not now - we're holding the mmap lock,
+		 * so copy_from_user() doesn't work here.
+		 * Use a placeholder instead, and fix it up later in
+		 * dump_vma_snapshot().
+		 */
+		return DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER;
+	}
 
 #undef	FILTER
 
@@ -1116,8 +1130,6 @@ int dump_vma_snapshot(struct coredump_pa
 		m->end = vma->vm_end;
 		m->flags = vma->vm_flags;
 		m->dump_size = vma_dump_size(vma, cprm->mm_flags);
-
-		vma_data_size += m->dump_size;
 	}
 
 	mmap_write_unlock(mm);
@@ -1127,6 +1139,23 @@ int dump_vma_snapshot(struct coredump_pa
 		return -EFAULT;
 	}
 
+	for (i = 0; i < *vma_count; i++) {
+		struct core_vma_metadata *m = (*vma_meta) + i;
+
+		if (m->dump_size == DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER) {
+			char elfmag[SELFMAG];
+
+			if (copy_from_user(elfmag, (void __user *)m->start, SELFMAG) ||
+					memcmp(elfmag, ELFMAG, SELFMAG) != 0) {
+				m->dump_size = 0;
+			} else {
+				m->dump_size = PAGE_SIZE;
+			}
+		}
+
+		vma_data_size += m->dump_size;
+	}
+
 	*vma_data_size_ptr = vma_data_size;
 	return 0;
 }
_

Patches currently in -mm which might be from jannh@google.com are

coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch

