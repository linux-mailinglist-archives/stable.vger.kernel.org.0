Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4A4F2C0F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347471AbiDEJ0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242522AbiDEIsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C944B1C8;
        Tue,  5 Apr 2022 01:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C506153A;
        Tue,  5 Apr 2022 08:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C99C385B3;
        Tue,  5 Apr 2022 08:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147833;
        bh=95vMahAfUKw1PtQifHx+UoIMYCOQAJPVxnMWai3wuWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KTvwdP0z76Kes71nCpB83Z+E/0IoR4FSc6aTUFYYunAaLL5TLFnYajJVR+LYUz9D
         cJ6E6NtLA2uiKCcgGtnrhSuqt9yDhq4/KHhC7Karcsfv1ToPojsxSwuP9RTFDN2uRV
         RqVj6TgL0joqgShqhlwMRCpZel7pPnfvNY3Hjuh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bill Messmer <wmessmer@microsoft.com>,
        Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.16 0138/1017] coredump: Also dump first pages of non-executable ELF libraries
Date:   Tue,  5 Apr 2022 09:17:31 +0200
Message-Id: <20220405070358.299984448@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 84158b7f6a0624b81800b4e7c90f7fb7fdecf66c upstream.

When I rewrote the VMA dumping logic for coredumps, I changed it to
recognize ELF library mappings based on the file being executable instead
of the mapping having an ELF header. But turns out, distros ship many ELF
libraries as non-executable, so the heuristic goes wrong...

Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of
any offset-0 readable mapping that starts with the ELF magic.

This fix is technically layer-breaking a bit, because it checks for
something ELF-specific in fs/coredump.c; but since we probably want to
share this between standard ELF and FDPIC ELF anyway, I guess it's fine?
And this also keeps the change small for backporting.

Cc: stable@vger.kernel.org
Fixes: 429a22e776a2 ("coredump: rework elf/elf_fdpic vma_dump_size() into common helper")
Reported-by: Bill Messmer <wmessmer@microsoft.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220126025739.2014888-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -41,6 +41,7 @@
 #include <linux/fs.h>
 #include <linux/path.h>
 #include <linux/timekeeping.h>
+#include <linux/elf.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -926,6 +927,8 @@ static bool always_dump_vma(struct vm_ar
 	return false;
 }
 
+#define DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER 1
+
 /*
  * Decide how much of @vma's contents should be included in a core dump.
  */
@@ -985,9 +988,20 @@ static unsigned long vma_dump_size(struc
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
 
@@ -1062,8 +1076,6 @@ int dump_vma_snapshot(struct coredump_pa
 		m->end = vma->vm_end;
 		m->flags = vma->vm_flags;
 		m->dump_size = vma_dump_size(vma, cprm->mm_flags);
-
-		vma_data_size += m->dump_size;
 	}
 
 	mmap_write_unlock(mm);
@@ -1073,6 +1085,23 @@ int dump_vma_snapshot(struct coredump_pa
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


