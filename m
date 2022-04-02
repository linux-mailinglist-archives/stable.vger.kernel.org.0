Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CFA4F012B
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbiDBLjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241002AbiDBLin (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 07:38:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF10C5520D
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 04:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CF0A60BA1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 11:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9487BC340EC;
        Sat,  2 Apr 2022 11:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648899410;
        bh=zQkzA+O09FOCNlkoswfFGZb5KYMg/gbKqE/EyRAJZLY=;
        h=Subject:To:Cc:From:Date:From;
        b=y+Jb6vcEKEmSzG9OoYyRd6eyzvyFRceuXP0gieRIA/uZenkgX4f8FLFbWF6G9QV0S
         aatTO+VhJ/wNiAjLv16p9wWpMBB4GWr8PprqwOXMCognKOx+b9Oy+EKzxDDBzyTaAn
         UxNdqqzidK1pFLny8UCb5mAEeGEercNwAtbK4Iug=
Subject: FAILED: patch "[PATCH] coredump: Use the vma snapshot in fill_files_note" failed to apply to 5.10-stable tree
To:     ebiederm@xmission.com, keescook@chromium.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 13:36:40 +0200
Message-ID: <1648899400225147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 390031c942116d4733310f0684beb8db19885fe6 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 8 Mar 2022 13:04:19 -0600
Subject: [PATCH] coredump: Use the vma snapshot in fill_files_note

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

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 7f0c391832cf..ca5296cae979 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1641,17 +1641,16 @@ static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
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
@@ -1673,11 +1672,12 @@ static int fill_files_note(struct memelfnote *note)
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
@@ -1697,9 +1697,9 @@ static int fill_files_note(struct memelfnote *note)
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
 
@@ -1710,7 +1710,7 @@ static int fill_files_note(struct memelfnote *note)
 	 * Count usually is less than mm->map_count,
 	 * we need to move filenames down.
 	 */
-	n = mm->map_count - count;
+	n = cprm->vma_count - count;
 	if (n != 0) {
 		unsigned shift_bytes = n * 3 * sizeof(data[0]);
 		memmove(name_base - shift_bytes, name_base,
@@ -1909,7 +1909,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	if (fill_files_note(&info->files) == 0)
+	if (fill_files_note(&info->files, cprm) == 0)
 		info->size += notesize(&info->files);
 
 	return 1;
@@ -2098,7 +2098,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(info->notes + 3, current->mm);
 	info->numnote = 4;
 
-	if (fill_files_note(info->notes + info->numnote) == 0) {
+	if (fill_files_note(info->notes + info->numnote, cprm) == 0) {
 		info->notes_files = info->notes + info->numnote;
 		info->numnote++;
 	}
diff --git a/fs/coredump.c b/fs/coredump.c
index 7f100a637264..7ed7d601e5e0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -55,6 +55,7 @@
 #include <trace/events/sched.h>
 
 static bool dump_vma_snapshot(struct coredump_params *cprm);
+static void free_vma_snapshot(struct coredump_params *cprm);
 
 static int core_uses_pid;
 static unsigned int core_pipe_limit;
@@ -765,7 +766,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 			dump_emit(&cprm, "", 1);
 		}
 		file_end_write(cprm.file);
-		kvfree(cprm.vma_meta);
+		free_vma_snapshot(&cprm);
 	}
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -1099,6 +1100,20 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
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
@@ -1135,6 +1150,11 @@ static bool dump_vma_snapshot(struct coredump_params *cprm)
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
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 7d05370e555e..08a1d3e7e46d 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -12,6 +12,8 @@ struct core_vma_metadata {
 	unsigned long start, end;
 	unsigned long flags;
 	unsigned long dump_size;
+	unsigned long pgoff;
+	struct file   *file;
 };
 
 struct coredump_params {

