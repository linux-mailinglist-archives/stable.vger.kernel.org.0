Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C070C66C463
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjAPPyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjAPPyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451CE1D908
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A146CE1275
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2381EC433EF;
        Mon, 16 Jan 2023 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884458;
        bh=rnnKq4YAi+mlzfQZ+6/xXGtXI9Fjzl/J04SuA/C34M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAFsQDDsu+ZCyobuUipAK3PcnxERhfTKoBY3Bm57nyXUrSmxGqCnEZJswCzELBMcN
         pcWyukRt3WNUdf+xTmQnQhtX5nyYzd46pCqZdH+sXO4+QAbotSN6S42KLbZzvdOYyF
         NUqzPDfsJa85np9qnpYTfNYf/rUnMVfaeMPQPYNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Seth Jenkins <sethjenkins@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 014/183] arm64: mte: Avoid the racy walk of the vma list during core dump
Date:   Mon, 16 Jan 2023 16:48:57 +0100
Message-Id: <20230116154804.009592951@linuxfoundation.org>
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

commit 4f4c549feb4ecca95ae9abb88887b941d196f83a upstream.

The MTE coredump code in arch/arm64/kernel/elfcore.c iterates over the
vma list without the mmap_lock held. This can race with another process
or userfaultfd concurrently modifying the vma list. Change the
for_each_mte_vma macro and its callers to instead use the vma snapshot
taken by dump_vma_snapshot() and stored in the cprm object.

Fixes: 6dd8b1a0b6cb ("arm64: mte: Dump the MTE tags in the core file")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Seth Jenkins <sethjenkins@google.com>
Suggested-by: Seth Jenkins <sethjenkins@google.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221222181251.1345752-4-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/elfcore.c |   56 ++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -8,28 +8,27 @@
 #include <asm/cpufeature.h>
 #include <asm/mte.h>
 
-#define for_each_mte_vma(vmi, vma)					\
+#define for_each_mte_vma(cprm, i, m)					\
 	if (system_supports_mte())					\
-		for_each_vma(vmi, vma)					\
-			if (vma->vm_flags & VM_MTE)
+		for (i = 0, m = cprm->vma_meta;				\
+		     i < cprm->vma_count;				\
+		     i++, m = cprm->vma_meta + i)			\
+			if (m->flags & VM_MTE)
 
-static unsigned long mte_vma_tag_dump_size(struct vm_area_struct *vma)
+static unsigned long mte_vma_tag_dump_size(struct core_vma_metadata *m)
 {
-	if (vma->vm_flags & VM_DONTDUMP)
-		return 0;
-
-	return vma_pages(vma) * MTE_PAGE_TAG_STORAGE;
+	return (m->dump_size >> PAGE_SHIFT) * MTE_PAGE_TAG_STORAGE;
 }
 
 /* Derived from dump_user_range(); start/end must be page-aligned */
 static int mte_dump_tag_range(struct coredump_params *cprm,
-			      unsigned long start, unsigned long end)
+			      unsigned long start, unsigned long len)
 {
 	int ret = 1;
 	unsigned long addr;
 	void *tags = NULL;
 
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
+	for (addr = start; addr < start + len; addr += PAGE_SIZE) {
 		struct page *page = get_dump_page(addr);
 
 		/*
@@ -78,11 +77,11 @@ static int mte_dump_tag_range(struct cor
 
 Elf_Half elf_core_extra_phdrs(void)
 {
-	struct vm_area_struct *vma;
+	int i;
+	struct core_vma_metadata *m;
 	int vma_count = 0;
-	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(vmi, vma)
+	for_each_mte_vma(cprm, i, m)
 		vma_count++;
 
 	return vma_count;
@@ -90,18 +89,18 @@ Elf_Half elf_core_extra_phdrs(void)
 
 int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 {
-	struct vm_area_struct *vma;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	int i;
+	struct core_vma_metadata *m;
 
-	for_each_mte_vma(vmi, vma) {
+	for_each_mte_vma(cprm, i, m) {
 		struct elf_phdr phdr;
 
 		phdr.p_type = PT_AARCH64_MEMTAG_MTE;
 		phdr.p_offset = offset;
-		phdr.p_vaddr = vma->vm_start;
+		phdr.p_vaddr = m->start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = mte_vma_tag_dump_size(vma);
-		phdr.p_memsz = vma->vm_end - vma->vm_start;
+		phdr.p_filesz = mte_vma_tag_dump_size(m);
+		phdr.p_memsz = m->end - m->start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = 0;
 		phdr.p_align = 0;
@@ -115,26 +114,23 @@ int elf_core_write_extra_phdrs(struct co
 
 size_t elf_core_extra_data_size(void)
 {
-	struct vm_area_struct *vma;
+	int i;
+	struct core_vma_metadata *m;
 	size_t data_size = 0;
-	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(vmi, vma)
-		data_size += mte_vma_tag_dump_size(vma);
+	for_each_mte_vma(cprm, i, m)
+		data_size += mte_vma_tag_dump_size(m);
 
 	return data_size;
 }
 
 int elf_core_write_extra_data(struct coredump_params *cprm)
 {
-	struct vm_area_struct *vma;
-	VMA_ITERATOR(vmi, current->mm, 0);
-
-	for_each_mte_vma(vmi, vma) {
-		if (vma->vm_flags & VM_DONTDUMP)
-			continue;
+	int i;
+	struct core_vma_metadata *m;
 
-		if (!mte_dump_tag_range(cprm, vma->vm_start, vma->vm_end))
+	for_each_mte_vma(cprm, i, m) {
+		if (!mte_dump_tag_range(cprm, m->start, m->dump_size))
 			return 0;
 	}
 


