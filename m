Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DDA4F3A2D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379254AbiDELki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354470AbiDEKOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8CA49695;
        Tue,  5 Apr 2022 03:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A8F9B81B96;
        Tue,  5 Apr 2022 10:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B1FC385A1;
        Tue,  5 Apr 2022 10:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152828;
        bh=nKyec0Bo6fuA2Joftn7Yg/E82UU+uBrw/p5mBrUXe0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPm0LGK/KXyiEVEI5ZAqe5zblFQS+KGKVXHb5xFVBaPdvE/0ECq9yYqO3vsJ58OIF
         /XWEZ2Oa6Gmn9DK+p02LkjNhV/agkdLjdbuV21me0/JlGzdUGRB7p6VhAkOevZWpZ5
         kKMg9I0dbX5Y8hVsYTHRqwHcDdfq/RTRrr2Oe+Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 910/913] coredump: Snapshot the vmas in do_coredump
Date:   Tue,  5 Apr 2022 09:32:52 +0200
Message-Id: <20220405070407.097150382@linuxfoundation.org>
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
@@ -2168,8 +2168,7 @@ static void fill_extnum_info(struct elfh
 static int elf_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
-	int vma_count, segs, i;
-	size_t vma_data_size;
+	int segs, i;
 	struct elfhdr elf;
 	loff_t offset = 0, dataoff;
 	struct elf_note_info info = { };
@@ -2177,16 +2176,12 @@ static int elf_core_dump(struct coredump
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
@@ -2225,7 +2220,7 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += vma_data_size;
+	offset += cprm->vma_data_size;
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
@@ -2245,8 +2240,8 @@ static int elf_core_dump(struct coredump
 		goto end_coredump;
 
 	/* Write program headers for segments dump */
-	for (i = 0; i < vma_count; i++) {
-		struct core_vma_metadata *meta = vma_meta + i;
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *meta = cprm->vma_meta + i;
 		struct elf_phdr phdr;
 
 		phdr.p_type = PT_LOAD;
@@ -2283,8 +2278,8 @@ static int elf_core_dump(struct coredump
 	/* Align to page */
 	dump_skip_to(cprm, dataoff);
 
-	for (i = 0; i < vma_count; i++) {
-		struct core_vma_metadata *meta = vma_meta + i;
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *meta = cprm->vma_meta + i;
 
 		if (!dump_user_range(cprm, meta->start, meta->dump_size))
 			goto end_coredump;
@@ -2301,7 +2296,6 @@ static int elf_core_dump(struct coredump
 end_coredump:
 	free_note_info(&info);
 	kfree(shdr4extnum);
-	kvfree(vma_meta);
 	kfree(phdr4note);
 	return has_dumped;
 }
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1465,7 +1465,7 @@ static bool elf_fdpic_dump_segments(stru
 static int elf_fdpic_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
-	int vma_count, segs;
+	int segs;
 	int i;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
@@ -1480,8 +1480,6 @@ static int elf_fdpic_core_dump(struct co
 	elf_addr_t e_shoff;
 	struct core_thread *ct;
 	struct elf_thread_status *tmp;
-	struct core_vma_metadata *vma_meta = NULL;
-	size_t vma_data_size;
 
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
@@ -1491,9 +1489,6 @@ static int elf_fdpic_core_dump(struct co
 	if (!psinfo)
 		goto end_coredump;
 
-	if (dump_vma_snapshot(cprm, &vma_count, &vma_meta, &vma_data_size))
-		goto end_coredump;
-
 	for (ct = current->mm->core_state->dumper.next;
 					ct; ct = ct->next) {
 		tmp = elf_dump_thread_status(cprm->siginfo->si_signo,
@@ -1513,7 +1508,7 @@ static int elf_fdpic_core_dump(struct co
 	tmp->next = thread_list;
 	thread_list = tmp;
 
-	segs = vma_count + elf_core_extra_phdrs();
+	segs = cprm->vma_count + elf_core_extra_phdrs();
 
 	/* for notes section */
 	segs++;
@@ -1558,7 +1553,7 @@ static int elf_fdpic_core_dump(struct co
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	offset += vma_data_size;
+	offset += cprm->vma_data_size;
 	offset += elf_core_extra_data_size();
 	e_shoff = offset;
 
@@ -1578,8 +1573,8 @@ static int elf_fdpic_core_dump(struct co
 		goto end_coredump;
 
 	/* write program headers for segments dump */
-	for (i = 0; i < vma_count; i++) {
-		struct core_vma_metadata *meta = vma_meta + i;
+	for (i = 0; i < cprm->vma_count; i++) {
+		struct core_vma_metadata *meta = cprm->vma_meta + i;
 		struct elf_phdr phdr;
 		size_t sz;
 
@@ -1628,7 +1623,7 @@ static int elf_fdpic_core_dump(struct co
 
 	dump_skip_to(cprm, dataoff);
 
-	if (!elf_fdpic_dump_segments(cprm, vma_meta, vma_count))
+	if (!elf_fdpic_dump_segments(cprm, cprm->vma_meta, cprm->vma_count))
 		goto end_coredump;
 
 	if (!elf_core_write_extra_data(cprm))
@@ -1652,7 +1647,6 @@ end_coredump:
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
@@ -601,6 +603,7 @@ void do_coredump(const kernel_siginfo_t
 		 * by any locks.
 		 */
 		.mm_flags = mm->flags,
+		.vma_meta = NULL,
 	};
 
 	audit_core_dumps(siginfo->si_signo);
@@ -815,6 +818,9 @@ void do_coredump(const kernel_siginfo_t
 			pr_info("Core dump to |%s disabled\n", cn.corename);
 			goto close_fail;
 		}
+		if (!dump_vma_snapshot(&cprm))
+			goto close_fail;
+
 		file_start_write(cprm.file);
 		core_dumped = binfmt->core_dump(&cprm);
 		/*
@@ -828,6 +834,7 @@ void do_coredump(const kernel_siginfo_t
 			dump_emit(&cprm, "", 1);
 		}
 		file_end_write(cprm.file);
+		kvfree(cprm.vma_meta);
 	}
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -1108,14 +1115,11 @@ static struct vm_area_struct *next_vma(s
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
@@ -1123,20 +1127,21 @@ int dump_vma_snapshot(struct coredump_pa
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
@@ -1146,13 +1151,14 @@ int dump_vma_snapshot(struct coredump_pa
 
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
@@ -1165,9 +1171,8 @@ int dump_vma_snapshot(struct coredump_pa
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
@@ -87,6 +87,9 @@ struct coredump_params {
 	loff_t written;
 	loff_t pos;
 	loff_t to_skip;
+	int vma_count;
+	size_t vma_data_size;
+	struct core_vma_metadata *vma_meta;
 };
 
 /*
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -29,9 +29,6 @@ extern int dump_emit(struct coredump_par
 extern int dump_align(struct coredump_params *cprm, int align);
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len);
-int dump_vma_snapshot(struct coredump_params *cprm, int *vma_count,
-		      struct core_vma_metadata **vma_meta,
-		      size_t *vma_data_size_ptr);
 extern void do_coredump(const kernel_siginfo_t *siginfo);
 #else
 static inline void do_coredump(const kernel_siginfo_t *siginfo) {}


