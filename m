Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF094C617B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 03:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiB1C6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 21:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiB1C6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Feb 2022 21:58:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED462FFEB;
        Sun, 27 Feb 2022 18:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEDF460EBE;
        Mon, 28 Feb 2022 02:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33758C340EE;
        Mon, 28 Feb 2022 02:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017083;
        bh=dDs+/HnIDqvEgUDn6SE2lSIx/SIGmct2Y7WPI22tCps=;
        h=Date:To:From:Subject:From;
        b=XfcLXJSORpsgZdU+4HudnSpZULa1VEYtz6ennt+lFiRntJ5xl7uELjU1E/TQIpcw5
         ukQlgA5U8SBZMQ3v03JLOGEDPZV654T8guLQG7C9xwc1U4U6bbtOLv/fVczve/CFfu
         VaL3sdF2X+wUy2+T2PcVD107Pmhn/XCpgdDym/BA=
Date:   Sun, 27 Feb 2022 18:58:02 -0800
To:     mm-commits@vger.kernel.org, wmessmer@microsoft.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        rdunlap@infradead.org, ebiederm@xmission.com, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch removed from -mm tree
Message-Id: <20220228025803.33758C340EE@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coredump: also dump first pages of non-executable ELF libraries
has been removed from the -mm tree.  Its filename was
     coredump-also-dump-first-pages-of-non-executable-elf-libraries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Fixes: 429a22e776a2 ("coredump: rework elf/elf_fdpic vma_dump_size() into common helper")
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


