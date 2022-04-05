Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28FB4F3DE2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383449AbiDEMZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiDEKwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D30CA88AB;
        Tue,  5 Apr 2022 03:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92BB617FE;
        Tue,  5 Apr 2022 10:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD25C385A1;
        Tue,  5 Apr 2022 10:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154485;
        bh=WU6lrd9MKsyR+b9ykgp2uA6C41Lat3B8bYl3Xq142RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2aNQhAr1sLe2g4ma7PnYlRcUWIr3H9Bg+ga7Wt9Y/QqYHxlFGd+8ybnET5+jF5dJ
         lY588fXV+LXW8XvqeoRpumX0sRkiZ6yo9U7g4juwj+uCk/AxlC4VqX4afg67mIQA2I
         8SCIyQCvnskYA9it6fGIN+DpB8pbbTeDmFQQYgME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 595/599] coredump: Snapshot the vmas in do_coredump
Date:   Tue,  5 Apr 2022 09:34:49 +0200
Message-Id: <20220405070316.546715227@linuxfoundation.org>
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

commit 95c5436a4883841588dae86fb0b9325f47ba5ad3 upstream.

Move the call of dump_vma_snapshot and kvfree(vma_meta) out of the
individual coredump routines into do_coredump itself.  This makes
the code less error prone and easier to maintain.

Make the vma snapshot available to the coredump routines
in struct coredump_params.  This makes it easier to
change and update what is captures in the vma snapshot
and will be needed for fixing fill_file_notes.

Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c          |   20 +++++++-------------
 fs/binfmt_elf_fdpic.c    |   18 ++++++------------
 fs/coredump.c            |   41 +++++++++++++++++++++++------------------
 include/linux/binfmts.h  |    3 +++
 include/linux/coredump.h |    3 ---
 5 files changed, 39 insertions(+), 46 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2166,8 +2166,7 @@ static void fill_extnum_info(struct elfh
 static int elf_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
-	int vma_count, segs, i;
-	size_t vma_data_size;
+	int segs, i;
 	struct elfhdr elf;
 	loff_t offset = 0, dataoff;
 	struct elf_note_info info = { };
@@ -2175,16 +2174,12 @@ static int elf_core_dump(struct coredump
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
 	elf_addr_t e_shoff;
-	struct core_vma_metadata *vma_meta;
-
-	if (dump_vma_snapshot(cprm, &vma_count, &vma_meta, &vma_data_size))
-		return 0;
 
 	/*
 	 * The number of segs are recored into ELF header as 16bit value.
 	 * Please check DEFAULT_MAX_MAP_COUNT definition when you modify here.
 	 */
-	segs = vma_count + elf_core_extra_phdrs();
+	segs = cprm->vma_count + elf_core_extra_phdrs();
 
 	/* for notes section */
 	segs++;
@@ -2222,7 +2217,7 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += vma_data_size;
+	offset += cprm->vma_data_size;
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
@@ -2242,8 +2237,8 @@ static int elf_core_dump(struct coredump
 		goto end_coredump;
 
 	/* Write program headers for segments dump */
-	for (i = 0; i < vma_count; i++) {
-		struct core_vma_metadata *meta = vma_meta + i;
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *meta = cprm->vma_meta + i;
 		struct elf_phdr phdr;
 
 		phdr.p_type = PT_LOAD;
@@ -2280,8 +2275,8 @@ static int elf_core_dump(struct coredump
 	if (!dump_skip(cprm, dataoff - cprm->pos))
 		goto end_coredump;
 
-	for (i = 0; i < vma_count; i++) {
-		struct core_vma_metadata *meta = vma_meta + i;
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *meta = cprm->vma_meta + i;
 
 		if (!dump_user_range(cprm, meta->start, meta->dump_size))
 			goto end_coredump;
@@ -2299,7 +2294,6 @@ static int elf_core_dump(struct coredump
 end_coredump:
 	free_note_info(&info);
 	kfree(shdr4extnum);
-	kvfree(vma_meta);
 	kfree(phdr4note);
 	return has_dumped;
 }
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1479,7 +1479,7 @@ static bool elf_fdpic_dump_segments(stru
 static int elf_fdpic_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
-	int vma_count, segs;
+	int segs;
 	int i;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
@@ -1494,8 +1494,6 @@ static int elf_fdpic_core_dump(struct co
 	elf_addr_t e_shoff;
 	struct core_thread *ct;
 	struct elf_thread_status *tmp;
-	struct core_vma_metadata *vma_meta = NULL;
-	size_t vma_data_size;
 
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
@@ -1505,9 +1503,6 @@ static int elf_fdpic_core_dump(struct co
 	if (!psinfo)
 		goto end_coredump;
 
-	if (dump_vma_snapshot(cprm, &vma_count, &vma_meta, &vma_data_size))
-		goto end_coredump;
-
 	for (ct = current->mm->core_state->dumper.next;
 					ct; ct = ct->next) {
 		tmp = elf_dump_thread_status(cprm->siginfo->si_signo,
@@ -1527,7 +1522,7 @@ static int elf_fdpic_core_dump(struct co
 	tmp->next = thread_list;
 	thread_list = tmp;
 
-	segs = vma_count + elf_core_extra_phdrs();
+	segs = cprm->vma_count + elf_core_extra_phdrs();
 
 	/* for notes section */
 	segs++;
@@ -1572,7 +1567,7 @@ static int elf_fdpic_core_dump(struct co
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += vma_data_size;
+	offset += cprm->vma_data_size;
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
@@ -1592,8 +1587,8 @@ static int elf_fdpic_core_dump(struct co
 		goto end_coredump;
 
 	/* write program headers for segments dump */
-	for (i = 0; i < vma_count; i++) {
-		struct core_vma_metadata *meta = vma_meta + i;
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *meta = cprm->vma_meta + i;
 		struct elf_phdr phdr;
 		size_t sz;
 
@@ -1643,7 +1638,7 @@ static int elf_fdpic_core_dump(struct co
 	if (!dump_skip(cprm, dataoff - cprm->pos))
 		goto end_coredump;
 
-	if (!elf_fdpic_dump_segments(cprm, vma_meta, vma_count))
+	if (!elf_fdpic_dump_segments(cprm, cprm->vma_meta, cprm->vma_count))
 		goto end_coredump;
 
 	if (!elf_core_write_extra_data(cprm))
@@ -1667,7 +1662,6 @@ end_coredump:
 		thread_list = thread_list->next;
 		kfree(tmp);
 	}
-	kvfree(vma_meta);
 	kfree(phdr4note);
 	kfree(elf);
 	kfree(psinfo);
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -53,6 +53,8 @@
 
 #include <trace/events/sched.h>
 
+static bool dump_vma_snapshot(struct coredump_params *cprm);
+
 int core_uses_pid;
 unsigned int core_pipe_limit;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
@@ -602,6 +604,7 @@ void do_coredump(const kernel_siginfo_t
 		 * by any locks.
 		 */
 		.mm_flags = mm->flags,
+		.vma_meta = NULL,
 	};
 
 	audit_core_dumps(siginfo->si_signo);
@@ -807,9 +810,13 @@ void do_coredump(const kernel_siginfo_t
 			pr_info("Core dump to |%s disabled\n", cn.corename);
 			goto close_fail;
 		}
+		if (!dump_vma_snapshot(&cprm))
+			goto close_fail;
+
 		file_start_write(cprm.file);
 		core_dumped = binfmt->core_dump(&cprm);
 		file_end_write(cprm.file);
+		kvfree(cprm.vma_meta);
 	}
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -1085,14 +1092,11 @@ static struct vm_area_struct *next_vma(s
  * Under the mmap_lock, take a snapshot of relevant information about the task's
  * VMAs.
  */
-int dump_vma_snapshot(struct coredump_params *cprm, int *vma_count,
-		      struct core_vma_metadata **vma_meta,
-		      size_t *vma_data_size_ptr)
+static bool dump_vma_snapshot(struct coredump_params *cprm)
 {
 	struct vm_area_struct *vma, *gate_vma;
 	struct mm_struct *mm = current->mm;
 	int i;
-	size_t vma_data_size = 0;
 
 	/*
 	 * Once the stack expansion code is fixed to not change VMA bounds
@@ -1100,20 +1104,21 @@ int dump_vma_snapshot(struct coredump_pa
 	 * mmap_lock in read mode.
 	 */
 	if (mmap_write_lock_killable(mm))
-		return -EINTR;
+		return false;
 
+	cprm->vma_data_size = 0;
 	gate_vma = get_gate_vma(mm);
-	*vma_count = mm->map_count + (gate_vma ? 1 : 0);
+	cprm->vma_count = mm->map_count + (gate_vma ? 1 : 0);
 
-	*vma_meta = kvmalloc_array(*vma_count, sizeof(**vma_meta), GFP_KERNEL);
-	if (!*vma_meta) {
+	cprm->vma_meta = kvmalloc_array(cprm->vma_count, sizeof(*cprm->vma_meta), GFP_KERNEL);
+	if (!cprm->vma_meta) {
 		mmap_write_unlock(mm);
-		return -ENOMEM;
+		return false;
 	}
 
 	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma), i++) {
-		struct core_vma_metadata *m = (*vma_meta) + i;
+		struct core_vma_metadata *m = cprm->vma_meta + i;
 
 		m->start = vma->vm_start;
 		m->end = vma->vm_end;
@@ -1123,13 +1128,14 @@ int dump_vma_snapshot(struct coredump_pa
 
 	mmap_write_unlock(mm);
 
-	if (WARN_ON(i != *vma_count)) {
-		kvfree(*vma_meta);
-		return -EFAULT;
+	if (WARN_ON(i != cprm->vma_count)) {
+		kvfree(cprm->vma_meta);
+		return false;
 	}
 
-	for (i = 0; i < *vma_count; i++) {
-		struct core_vma_metadata *m = (*vma_meta) + i;
+
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *m = cprm->vma_meta + i;
 
 		if (m->dump_size == DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER) {
 			char elfmag[SELFMAG];
@@ -1142,9 +1148,8 @@ int dump_vma_snapshot(struct coredump_pa
 			}
 		}
 
-		vma_data_size += m->dump_size;
+		cprm->vma_data_size += m->dump_size;
 	}
 
-	*vma_data_size_ptr = vma_data_size;
-	return 0;
+	return true;
 }
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -82,6 +82,9 @@ struct coredump_params {
 	unsigned long mm_flags;
 	loff_t written;
 	loff_t pos;
+	int vma_count;
+	size_t vma_data_size;
+	struct core_vma_metadata *vma_meta;
 };
 
 /*
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -24,9 +24,6 @@ extern int dump_align(struct coredump_pa
 extern void dump_truncate(struct coredump_params *cprm);
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len);
-int dump_vma_snapshot(struct coredump_params *cprm, int *vma_count,
-		      struct core_vma_metadata **vma_meta,
-		      size_t *vma_data_size_ptr);
 #ifdef CONFIG_COREDUMP
 extern void do_coredump(const kernel_siginfo_t *siginfo);
 #else


