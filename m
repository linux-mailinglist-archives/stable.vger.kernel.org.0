Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5494966C46C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjAPPy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjAPPyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163DB1E5C3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6802B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2370DC433EF;
        Mon, 16 Jan 2023 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884479;
        bh=6Euv0hRlUA9F+6G0BURS03utW9dU/cYlLb1MvjMczGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yu9KUxJukE5iIkPrzf5TJ1Vk2OO1DzXc+2/z9eqZGPclrjdS+hnwmMJ4bEpPggDpO
         /Qz4L9whDK0WcmdOTwJwCuOoPKVjFOi63rLZiY7By8ZNalvdkEC+jLxgx321OWIxlZ
         qvAwj4kRls3oX5OKmClMKprIMm2qZwbwD04QkU8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Seth Jenkins <sethjenkins@google.com>,
        Will Deacon <will@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 022/183] elfcore: Add a cprm parameter to elf_core_extra_{phdrs,data_size}
Date:   Mon, 16 Jan 2023 16:49:05 +0100
Message-Id: <20230116154804.335882746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 19e183b54528f11fafeca60fc6d0821e29ff281e upstream.

A subsequent fix for arm64 will use this parameter to parse the vma
information from the snapshot created by dump_vma_snapshot() rather than
traversing the vma list without the mmap_lock.

Fixes: 6dd8b1a0b6cb ("arm64: mte: Dump the MTE tags in the core file")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Seth Jenkins <sethjenkins@google.com>
Suggested-by: Seth Jenkins <sethjenkins@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221222181251.1345752-3-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/elfcore.c |    4 ++--
 arch/ia64/kernel/elfcore.c  |    4 ++--
 arch/x86/um/elfcore.c       |    4 ++--
 fs/binfmt_elf.c             |    4 ++--
 fs/binfmt_elf_fdpic.c       |    4 ++--
 include/linux/elfcore.h     |    8 ++++----
 6 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -75,7 +75,7 @@ static int mte_dump_tag_range(struct cor
 	return ret;
 }
 
-Elf_Half elf_core_extra_phdrs(void)
+Elf_Half elf_core_extra_phdrs(struct coredump_params *cprm)
 {
 	int i;
 	struct core_vma_metadata *m;
@@ -112,7 +112,7 @@ int elf_core_write_extra_phdrs(struct co
 	return 1;
 }
 
-size_t elf_core_extra_data_size(void)
+size_t elf_core_extra_data_size(struct coredump_params *cprm)
 {
 	int i;
 	struct core_vma_metadata *m;
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -7,7 +7,7 @@
 #include <asm/elf.h>
 
 
-Elf64_Half elf_core_extra_phdrs(void)
+Elf64_Half elf_core_extra_phdrs(struct coredump_params *cprm)
 {
 	return GATE_EHDR->e_phnum;
 }
@@ -60,7 +60,7 @@ int elf_core_write_extra_data(struct cor
 	return 1;
 }
 
-size_t elf_core_extra_data_size(void)
+size_t elf_core_extra_data_size(struct coredump_params *cprm)
 {
 	const struct elf_phdr *const gate_phdrs =
 		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
--- a/arch/x86/um/elfcore.c
+++ b/arch/x86/um/elfcore.c
@@ -7,7 +7,7 @@
 #include <asm/elf.h>
 
 
-Elf32_Half elf_core_extra_phdrs(void)
+Elf32_Half elf_core_extra_phdrs(struct coredump_params *cprm)
 {
 	return vsyscall_ehdr ? (((struct elfhdr *)vsyscall_ehdr)->e_phnum) : 0;
 }
@@ -60,7 +60,7 @@ int elf_core_write_extra_data(struct cor
 	return 1;
 }
 
-size_t elf_core_extra_data_size(void)
+size_t elf_core_extra_data_size(struct coredump_params *cprm)
 {
 	if ( vsyscall_ehdr ) {
 		const struct elfhdr *const ehdrp =
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2209,7 +2209,7 @@ static int elf_core_dump(struct coredump
 	 * The number of segs are recored into ELF header as 16bit value.
 	 * Please check DEFAULT_MAX_MAP_COUNT definition when you modify here.
 	 */
-	segs = cprm->vma_count + elf_core_extra_phdrs();
+	segs = cprm->vma_count + elf_core_extra_phdrs(cprm);
 
 	/* for notes section */
 	segs++;
@@ -2249,7 +2249,7 @@ static int elf_core_dump(struct coredump
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
 	offset += cprm->vma_data_size;
-	offset += elf_core_extra_data_size();
+	offset += elf_core_extra_data_size(cprm);
 	e_shoff = offset;
 
 	if (e_phnum == PN_XNUM) {
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1509,7 +1509,7 @@ static int elf_fdpic_core_dump(struct co
 	tmp->next = thread_list;
 	thread_list = tmp;
 
-	segs = cprm->vma_count + elf_core_extra_phdrs();
+	segs = cprm->vma_count + elf_core_extra_phdrs(cprm);
 
 	/* for notes section */
 	segs++;
@@ -1555,7 +1555,7 @@ static int elf_fdpic_core_dump(struct co
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
 	offset += cprm->vma_data_size;
-	offset += elf_core_extra_data_size();
+	offset += elf_core_extra_data_size(cprm);
 	e_shoff = offset;
 
 	if (e_phnum == PN_XNUM) {
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -114,14 +114,14 @@ static inline int elf_core_copy_task_fpr
  * Dumping its extra ELF program headers includes all the other information
  * a debugger needs to easily find how the gate DSO was being used.
  */
-extern Elf_Half elf_core_extra_phdrs(void);
+extern Elf_Half elf_core_extra_phdrs(struct coredump_params *cprm);
 extern int
 elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset);
 extern int
 elf_core_write_extra_data(struct coredump_params *cprm);
-extern size_t elf_core_extra_data_size(void);
+extern size_t elf_core_extra_data_size(struct coredump_params *cprm);
 #else
-static inline Elf_Half elf_core_extra_phdrs(void)
+static inline Elf_Half elf_core_extra_phdrs(struct coredump_params *cprm)
 {
 	return 0;
 }
@@ -136,7 +136,7 @@ static inline int elf_core_write_extra_d
 	return 1;
 }
 
-static inline size_t elf_core_extra_data_size(void)
+static inline size_t elf_core_extra_data_size(struct coredump_params *cprm)
 {
 	return 0;
 }


