Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9F4F0818
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiDCGnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiDCGnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCE736B4D
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 23:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 421C6B80C94
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9D8C340ED;
        Sun,  3 Apr 2022 06:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648968075;
        bh=fgHmMLQxHGUbPKSchE5JcQW2yAlcOTmQo6B0Q3loFsg=;
        h=Subject:To:Cc:From:Date:From;
        b=LOoM6zfJB0Nw6xjVGaGZ4MLgYM811ik1HEo7h3A7HAusvfN976a0X4E/qJGmkxIbk
         YKidcmG3EJdk8jaifK1MLPYYF7wGY6Fgty0u+H/Jmjs2jLsUCG44CC+RdN6srkVD9A
         aVQkg+7d7ar7VzxW/gzXS1kwr4gEp/SMtpgQ9oeU=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: do compare-and-exchange of gPTE via the user" failed to apply to 5.4-stable tree
To:     pbonzini@redhat.com, kangel@zju.edu.cn, mlevitsk@redhat.com,
        pgn@zju.edu.cn, qiuhao@sysec.org, tadeusz.struk@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 08:41:13 +0200
Message-ID: <1648968073137142@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2a8859f373b0a86f0ece8ec8312607eacf12485d Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 29 Mar 2022 12:56:24 -0400
Subject: [PATCH] KVM: x86/mmu: do compare-and-exchange of gPTE via the user
 address

FNAME(cmpxchg_gpte) is an inefficient mess.  It is at least decent if it
can go through get_user_pages_fast(), but if it cannot then it tries to
use memremap(); that is not just terribly slow, it is also wrong because
it assumes that the VM_PFNMAP VMA is contiguous.

The right way to do it would be to do the same thing as
hva_to_pfn_remapped() does since commit add6a0cd1c5b ("KVM: MMU: try to
fix up page faults before giving up", 2016-07-05), using follow_pte()
and fixup_user_fault() to determine the correct address to use for
memremap().  To do this, one could for example extract hva_to_pfn()
for use outside virt/kvm/kvm_main.c.  But really there is no reason to
do that either, because there is already a perfectly valid address to
do the cmpxchg() on, only it is a userspace address.  That means doing
user_access_begin()/user_access_end() and writing the code in assembly
to handle exceptions correctly.  Worse, the guest PTE can be 8-byte
even on i686 so there is the extra complication of using cmpxchg8b to
account for.  But at least it is an efficient mess.

(Thanks to Linus for suggesting improvement on the inline assembly).

Reported-by: Qiuhao Li <qiuhao@sysec.org>
Reported-by: Gaoning Pan <pgn@zju.edu.cn>
Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Debugged-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8621188b46df..01fee5f67ac3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -34,9 +34,8 @@
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
 	#ifdef CONFIG_X86_64
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
-	#define CMPXCHG cmpxchg
+	#define CMPXCHG "cmpxchgq"
 	#else
-	#define CMPXCHG cmpxchg64
 	#define PT_MAX_FULL_LEVELS 2
 	#endif
 #elif PTTYPE == 32
@@ -52,7 +51,7 @@
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
-	#define CMPXCHG cmpxchg
+	#define CMPXCHG "cmpxchgl"
 #elif PTTYPE == PTTYPE_EPT
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
@@ -65,7 +64,9 @@
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
-	#define CMPXCHG cmpxchg64
+	#ifdef CONFIG_X86_64
+	#define CMPXCHG "cmpxchgq"
+	#endif
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
 	#error Invalid PTTYPE value
@@ -147,43 +148,36 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			       pt_element_t __user *ptep_user, unsigned index,
 			       pt_element_t orig_pte, pt_element_t new_pte)
 {
-	int npages;
-	pt_element_t ret;
-	pt_element_t *table;
-	struct page *page;
-
-	npages = get_user_pages_fast((unsigned long)ptep_user, 1, FOLL_WRITE, &page);
-	if (likely(npages == 1)) {
-		table = kmap_atomic(page);
-		ret = CMPXCHG(&table[index], orig_pte, new_pte);
-		kunmap_atomic(table);
-
-		kvm_release_page_dirty(page);
-	} else {
-		struct vm_area_struct *vma;
-		unsigned long vaddr = (unsigned long)ptep_user & PAGE_MASK;
-		unsigned long pfn;
-		unsigned long paddr;
-
-		mmap_read_lock(current->mm);
-		vma = find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
-		if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
-			mmap_read_unlock(current->mm);
-			return -EFAULT;
-		}
-		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		paddr = pfn << PAGE_SHIFT;
-		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
-		if (!table) {
-			mmap_read_unlock(current->mm);
-			return -EFAULT;
-		}
-		ret = CMPXCHG(&table[index], orig_pte, new_pte);
-		memunmap(table);
-		mmap_read_unlock(current->mm);
-	}
+	signed char r;
 
-	return (ret != orig_pte);
+	if (!user_access_begin(ptep_user, sizeof(pt_element_t)))
+		return -EFAULT;
+
+#ifdef CMPXCHG
+	asm volatile("1:" LOCK_PREFIX CMPXCHG " %[new], %[ptr]\n"
+		     "setnz %b[r]\n"
+		     "2:"
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %k[r])
+		     : [ptr] "+m" (*ptep_user),
+		       [old] "+a" (orig_pte),
+		       [r] "=q" (r)
+		     : [new] "r" (new_pte)
+		     : "memory");
+#else
+	asm volatile("1:" LOCK_PREFIX "cmpxchg8b %[ptr]\n"
+		     "setnz %b[r]\n"
+		     "2:"
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %k[r])
+		     : [ptr] "+m" (*ptep_user),
+		       [old] "+A" (orig_pte),
+		       [r] "=q" (r)
+		     : [new_lo] "b" ((u32)new_pte),
+		       [new_hi] "c" ((u32)(new_pte >> 32))
+		     : "memory");
+#endif
+
+	user_access_end();
+	return r;
 }
 
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,

