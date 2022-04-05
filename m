Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9C4F4140
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383369AbiDEMZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiDEKx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EAFAA024;
        Tue,  5 Apr 2022 03:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BCE617F2;
        Tue,  5 Apr 2022 10:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17765C385A0;
        Tue,  5 Apr 2022 10:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154496;
        bh=TsfQp/7X+3iKvuFdGqSGi4rv7cpIaKJQNzVQuYkNsGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVRxeOKW/ElHWrvgTELJ2eIlaNzB/vqfL5/Ftn/TXD/9udhf+byNtZrNTGAVX52vU
         M+JtXDNhoHb3D84vTdBtX5ANrI5II683UTqeUTshpvsAQGLXkddRCyimJKQdlxakld
         fR1jCP1LA9lRiuTnOWtMR9kAmIugCN4DxyfTR9qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 598/599] coredump: Use the vma snapshot in fill_files_note
Date:   Tue,  5 Apr 2022 09:34:52 +0200
Message-Id: <20220405070316.634888893@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Eric W. Biederman <ebiederm@xmission.com>

commit 390031c942116d4733310f0684beb8db19885fe6 upstream.

Matthew Wilcox reported that there is a missing mmap_lock in
file_files_note that could possibly lead to a user after free.

Solve this by using the existing vma snapshot for consistency
and to avoid the need to take the mmap_lock anywhere in the
coredump code except for dump_vma_snapshot.

Update the dump_vma_snapshot to capture vm_pgoff and vm_file
that are neeeded by fill_files_note.

Add free_vma_snapshot to free the captured values of vm_file.

Reported-by: Matthew Wilcox <willy@infradead.org>
Link: https://lkml.kernel.org/r/20220131153740.2396974-1-willy@infradead.org
Cc: stable@vger.kernel.org
Fixes: a07279c9a8cd ("binfmt_elf, binfmt_elf_fdpic: use a VMA list snapshot")
Fixes: 2aa362c49c31 ("coredump: extend core dump note section to contain file names of mapped files")
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c          |   24 ++++++++++++------------
 fs/coredump.c            |   22 +++++++++++++++++++++-
 include/linux/coredump.h |    2 ++
 3 files changed, 35 insertions(+), 13 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1613,17 +1613,16 @@ static void fill_siginfo_note(struct mem
  *   long file_ofs
  * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
  */
-static int fill_files_note(struct memelfnote *note)
+static int fill_files_note(struct memelfnote *note, struct coredump_params *cprm)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	unsigned count, size, names_ofs, remaining, n;
 	user_long_t *data;
 	user_long_t *start_end_ofs;
 	char *name_base, *name_curpos;
+	int i;
 
 	/* *Estimated* file count and total data size needed */
-	count = mm->map_count;
+	count = cprm->vma_count;
 	if (count > UINT_MAX / 64)
 		return -EINVAL;
 	size = count * 64;
@@ -1645,11 +1644,12 @@ static int fill_files_note(struct memelf
 	name_base = name_curpos = ((char *)data) + names_ofs;
 	remaining = size - names_ofs;
 	count = 0;
-	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *m = &cprm->vma_meta[i];
 		struct file *file;
 		const char *filename;
 
-		file = vma->vm_file;
+		file = m->file;
 		if (!file)
 			continue;
 		filename = file_path(file, name_curpos, remaining);
@@ -1669,9 +1669,9 @@ static int fill_files_note(struct memelf
 		memmove(name_curpos, filename, n);
 		name_curpos += n;
 
-		*start_end_ofs++ = vma->vm_start;
-		*start_end_ofs++ = vma->vm_end;
-		*start_end_ofs++ = vma->vm_pgoff;
+		*start_end_ofs++ = m->start;
+		*start_end_ofs++ = m->end;
+		*start_end_ofs++ = m->pgoff;
 		count++;
 	}
 
@@ -1682,7 +1682,7 @@ static int fill_files_note(struct memelf
 	 * Count usually is less than mm->map_count,
 	 * we need to move filenames down.
 	 */
-	n = mm->map_count - count;
+	n = cprm->vma_count - count;
 	if (n != 0) {
 		unsigned shift_bytes = n * 3 * sizeof(data[0]);
 		memmove(name_base - shift_bytes, name_base,
@@ -1884,7 +1884,7 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	if (fill_files_note(&info->files) == 0)
+	if (fill_files_note(&info->files, cprm) == 0)
 		info->size += notesize(&info->files);
 
 	return 1;
@@ -2073,7 +2073,7 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(info->notes + 3, current->mm);
 	info->numnote = 4;
 
-	if (fill_files_note(info->notes + info->numnote) == 0) {
+	if (fill_files_note(info->notes + info->numnote, cprm) == 0) {
 		info->notes_files = info->notes + info->numnote;
 		info->numnote++;
 	}
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -54,6 +54,7 @@
 #include <trace/events/sched.h>
 
 static bool dump_vma_snapshot(struct coredump_params *cprm);
+static void free_vma_snapshot(struct coredump_params *cprm);
 
 int core_uses_pid;
 unsigned int core_pipe_limit;
@@ -816,7 +817,7 @@ void do_coredump(const kernel_siginfo_t
 		file_start_write(cprm.file);
 		core_dumped = binfmt->core_dump(&cprm);
 		file_end_write(cprm.file);
-		kvfree(cprm.vma_meta);
+		free_vma_snapshot(&cprm);
 	}
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -1088,6 +1089,20 @@ static struct vm_area_struct *next_vma(s
 	return gate_vma;
 }
 
+static void free_vma_snapshot(struct coredump_params *cprm)
+{
+	if (cprm->vma_meta) {
+		int i;
+		for (i = 0; i < cprm->vma_count; i++) {
+			struct file *file = cprm->vma_meta[i].file;
+			if (file)
+				fput(file);
+		}
+		kvfree(cprm->vma_meta);
+		cprm->vma_meta = NULL;
+	}
+}
+
 /*
  * Under the mmap_lock, take a snapshot of relevant information about the task's
  * VMAs.
@@ -1124,6 +1139,11 @@ static bool dump_vma_snapshot(struct cor
 		m->end = vma->vm_end;
 		m->flags = vma->vm_flags;
 		m->dump_size = vma_dump_size(vma, cprm->mm_flags);
+		m->pgoff = vma->vm_pgoff;
+
+		m->file = vma->vm_file;
+		if (m->file)
+			get_file(m->file);
 	}
 
 	mmap_write_unlock(mm);
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -11,6 +11,8 @@ struct core_vma_metadata {
 	unsigned long start, end;
 	unsigned long flags;
 	unsigned long dump_size;
+	unsigned long pgoff;
+	struct file   *file;
 };
 
 /*


