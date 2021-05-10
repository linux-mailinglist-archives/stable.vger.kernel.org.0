Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3A0378907
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbhEJLZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237586AbhEJLPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:15:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0380961090;
        Mon, 10 May 2021 11:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645072;
        bh=Yx5RTY2lf33uARZzG8bGd1pDhHnoydyh7Xeta8p9pq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+COhJupQFRW1Vjpa1g+yPCN5OiHSz+W4iTgONl79Rv5adtCGWdIGlcFbf1dBEJQ+
         X43rQ7i0rIahhtYR04hJJbAR2ME1728rT0ofdEthMKLamyYAgqmIrOV2TAKflPbzPP
         /gU8D68ukYb0pYQNd8evNbUR1vfz3y9t6/0olNWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Safonov <dima@arista.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Andrei Vagin <avagin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH 5.12 305/384] powerpc/vdso: Separate vvar vma from vdso
Date:   Mon, 10 May 2021 12:21:34 +0200
Message-Id: <20210510102024.859268586@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

commit 1c4bce6753857dc409a0197342d18764e7f4b741 upstream.

Since commit 511157ab641e ("powerpc/vdso: Move vdso datapage up front")
VVAR page is in front of the VDSO area. In result it breaks CRIU
(Checkpoint Restore In Userspace) [1], where CRIU expects that "[vdso]"
from /proc/../maps points at ELF/vdso image, rather than at VVAR data page.
Laurent made a patch to keep CRIU working (by reading aux vector).
But I think it still makes sence to separate two mappings into different
VMAs. It will also make ppc64 less "special" for userspace and as
a side-bonus will make VVAR page un-writable by debugger (which previously
would COW page and can be unexpected).

I opportunistically Cc stable on it: I understand that usually such
stuff isn't a stable material, but that will allow us in CRIU have
one workaround less that is needed just for one release (v5.11) on
one platform (ppc64), which we otherwise have to maintain.
I wouldn't go as far as to say that the commit 511157ab641e is ABI
regression as no other userspace got broken, but I'd really appreciate
if it gets backported to v5.11 after v5.12 is released, so as not
to complicate already non-simple CRIU-vdso code. Thanks!

[1]: https://github.com/checkpoint-restore/criu/issues/1417

Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com> # vDSO parts.
Acked-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/f401eb1ebc0bfc4d8f0e10dc8e525fd409eb68e2.1617209142.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/mmu_context.h |    2 -
 arch/powerpc/kernel/vdso.c             |   54 +++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 16 deletions(-)

--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -263,7 +263,7 @@ extern void arch_exit_mmap(struct mm_str
 static inline void arch_unmap(struct mm_struct *mm,
 			      unsigned long start, unsigned long end)
 {
-	unsigned long vdso_base = (unsigned long)mm->context.vdso - PAGE_SIZE;
+	unsigned long vdso_base = (unsigned long)mm->context.vdso;
 
 	if (start <= vdso_base && vdso_base < end)
 		mm->context.vdso = NULL;
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -55,10 +55,10 @@ static int vdso_mremap(const struct vm_s
 {
 	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
 
-	if (new_size != text_size + PAGE_SIZE)
+	if (new_size != text_size)
 		return -EINVAL;
 
-	current->mm->context.vdso = (void __user *)new_vma->vm_start + PAGE_SIZE;
+	current->mm->context.vdso = (void __user *)new_vma->vm_start;
 
 	return 0;
 }
@@ -73,6 +73,10 @@ static int vdso64_mremap(const struct vm
 	return vdso_mremap(sm, new_vma, &vdso64_end - &vdso64_start);
 }
 
+static struct vm_special_mapping vvar_spec __ro_after_init = {
+	.name = "[vvar]",
+};
+
 static struct vm_special_mapping vdso32_spec __ro_after_init = {
 	.name = "[vdso]",
 	.mremap = vdso32_mremap,
@@ -89,11 +93,11 @@ static struct vm_special_mapping vdso64_
  */
 static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	struct mm_struct *mm = current->mm;
+	unsigned long vdso_size, vdso_base, mappings_size;
 	struct vm_special_mapping *vdso_spec;
+	unsigned long vvar_size = PAGE_SIZE;
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long vdso_size;
-	unsigned long vdso_base;
 
 	if (is_32bit_task()) {
 		vdso_spec = &vdso32_spec;
@@ -110,8 +114,8 @@ static int __arch_setup_additional_pages
 		vdso_base = 0;
 	}
 
-	/* Add a page to the vdso size for the data page */
-	vdso_size += PAGE_SIZE;
+	mappings_size = vdso_size + vvar_size;
+	mappings_size += (VDSO_ALIGNMENT - 1) & PAGE_MASK;
 
 	/*
 	 * pick a base address for the vDSO in process space. We try to put it
@@ -119,9 +123,7 @@ static int __arch_setup_additional_pages
 	 * and end up putting it elsewhere.
 	 * Add enough to the size so that the result can be aligned.
 	 */
-	vdso_base = get_unmapped_area(NULL, vdso_base,
-				      vdso_size + ((VDSO_ALIGNMENT - 1) & PAGE_MASK),
-				      0, 0);
+	vdso_base = get_unmapped_area(NULL, vdso_base, mappings_size, 0, 0);
 	if (IS_ERR_VALUE(vdso_base))
 		return vdso_base;
 
@@ -133,7 +135,13 @@ static int __arch_setup_additional_pages
 	 * install_special_mapping or the perf counter mmap tracking code
 	 * will fail to recognise it as a vDSO.
 	 */
-	mm->context.vdso = (void __user *)vdso_base + PAGE_SIZE;
+	mm->context.vdso = (void __user *)vdso_base + vvar_size;
+
+	vma = _install_special_mapping(mm, vdso_base, vvar_size,
+				       VM_READ | VM_MAYREAD | VM_IO |
+				       VM_DONTDUMP | VM_PFNMAP, &vvar_spec);
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
 
 	/*
 	 * our vma flags don't have VM_WRITE so by default, the process isn't
@@ -145,9 +153,12 @@ static int __arch_setup_additional_pages
 	 * It's fine to use that for setting breakpoints in the vDSO code
 	 * pages though.
 	 */
-	vma = _install_special_mapping(mm, vdso_base, vdso_size,
+	vma = _install_special_mapping(mm, vdso_base + vvar_size, vdso_size,
 				       VM_READ | VM_EXEC | VM_MAYREAD |
 				       VM_MAYWRITE | VM_MAYEXEC, vdso_spec);
+	if (IS_ERR(vma))
+		do_munmap(mm, vdso_base, vvar_size, NULL);
+
 	return PTR_ERR_OR_ZERO(vma);
 }
 
@@ -249,11 +260,22 @@ static struct page ** __init vdso_setup_
 	if (!pagelist)
 		panic("%s: Cannot allocate page list for VDSO", __func__);
 
-	pagelist[0] = virt_to_page(vdso_data);
-
 	for (i = 0; i < pages; i++)
-		pagelist[i + 1] = virt_to_page(start + i * PAGE_SIZE);
+		pagelist[i] = virt_to_page(start + i * PAGE_SIZE);
+
+	return pagelist;
+}
+
+static struct page ** __init vvar_setup_pages(void)
+{
+	struct page **pagelist;
 
+	/* .pages is NULL-terminated */
+	pagelist = kcalloc(2, sizeof(struct page *), GFP_KERNEL);
+	if (!pagelist)
+		panic("%s: Cannot allocate page list for VVAR", __func__);
+
+	pagelist[0] = virt_to_page(vdso_data);
 	return pagelist;
 }
 
@@ -295,6 +317,8 @@ static int __init vdso_init(void)
 	if (IS_ENABLED(CONFIG_PPC64))
 		vdso64_spec.pages = vdso_setup_pages(&vdso64_start, &vdso64_end);
 
+	vvar_spec.pages = vvar_setup_pages();
+
 	smp_wmb();
 
 	return 0;


