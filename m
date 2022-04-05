Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1896C4F3A3A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379407AbiDELku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354478AbiDEKOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ED86A439;
        Tue,  5 Apr 2022 03:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC582B81C86;
        Tue,  5 Apr 2022 10:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F073FC385A2;
        Tue,  5 Apr 2022 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152836;
        bh=imzF3l1uWE55VHXm0LB90ZNN4J2QB1yPOrTckybsetI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cz89ix0NACP0LVLBjU+cfu/YN4WqLpDpKnshuIkSGcE+1RH+TE4g+5hyGy/fR7T6w
         1MZRbqvwIngq1fYhop1Ebh2BIk8UU7o4lm1e0UmkKMXFap5BdlUR1Ye3s3HgY8JVlw
         1kQUJKnHamDkDow/hgQKT1EUCOQ+8y1i6x5Hglk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 913/913] coredump: Use the vma snapshot in fill_files_note
Date:   Tue,  5 Apr 2022 09:32:55 +0200
Message-Id: <20220405070407.186440187@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -1618,17 +1618,16 @@ static void fill_siginfo_note(struct mem
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
@@ -1650,11 +1649,12 @@ static int fill_files_note(struct memelf
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
@@ -1674,9 +1674,9 @@ static int fill_files_note(struct memelf
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
 
@@ -1687,7 +1687,7 @@ static int fill_files_note(struct memelf
 	 * Count usually is less than mm->map_count,
 	 * we need to move filenames down.
 	 */
-	n = mm->map_count - count;
+	n = cprm->vma_count - count;
 	if (n != 0) {
 		unsigned shift_bytes = n * 3 * sizeof(data[0]);
 		memmove(name_base - shift_bytes, name_base,
@@ -1886,7 +1886,7 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	if (fill_files_note(&info->files) == 0)
+	if (fill_files_note(&info->files, cprm) == 0)
 		info->size += notesize(&info->files);
 
 	return 1;
@@ -2075,7 +2075,7 @@ static int fill_note_info(struct elfhdr
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
@@ -834,7 +835,7 @@ void do_coredump(const kernel_siginfo_t
 			dump_emit(&cprm, "", 1);
 		}
 		file_end_write(cprm.file);
-		kvfree(cprm.vma_meta);
+		free_vma_snapshot(&cprm);
 	}
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -1111,6 +1112,20 @@ static struct vm_area_struct *next_vma(s
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
@@ -1147,6 +1162,11 @@ static bool dump_vma_snapshot(struct cor
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
@@ -12,6 +12,8 @@ struct core_vma_metadata {
 	unsigned long start, end;
 	unsigned long flags;
 	unsigned long dump_size;
+	unsigned long pgoff;
+	struct file   *file;
 };
 
 extern int core_uses_pid;


