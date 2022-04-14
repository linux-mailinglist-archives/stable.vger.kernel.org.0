Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5172050144D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242975AbiDNOO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346568AbiDNN5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3894D81673;
        Thu, 14 Apr 2022 06:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB14BB828E6;
        Thu, 14 Apr 2022 13:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BA0C385A1;
        Thu, 14 Apr 2022 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944020;
        bh=JkVcvjkDM8C5oXeCLrcW2btgV7jD1g2hmZnsjqyKkKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0pmdyoeZ3tD5k3mrvbs82/XdLQ+Sf6nz7KmVc2XnaIeFW/JHtfIHiuVKBXzfUVqJ
         RRw9FSPwZU9Q1s3YOOFV33DDPu6D+iO2fmWXsW9qehFTtCZhSFm15+zKwvtq8AcyZG
         KFf+HvUUX6I5NAS8PzsTUC72ffQrcXWG66EfVaiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.4 366/475] KVM: x86/mmu: do compare-and-exchange of gPTE via the user address
Date:   Thu, 14 Apr 2022 15:12:31 +0200
Message-Id: <20220414110905.321317582@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 2a8859f373b0a86f0ece8ec8312607eacf12485d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/paging_tmpl.h |   77 +++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 40 deletions(-)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
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
@@ -65,8 +64,10 @@
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
-	#define CMPXCHG cmpxchg64
 	#define PT_MAX_FULL_LEVELS 4
+	#ifdef CONFIG_X86_64
+	#define CMPXCHG "cmpxchgq"
+	#endif
 #else
 	#error Invalid PTTYPE value
 #endif
@@ -132,43 +133,39 @@ static int FNAME(cmpxchg_gpte)(struct kv
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
-		down_read(&current->mm->mmap_sem);
-		vma = find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
-		if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
-			up_read(&current->mm->mmap_sem);
-			return -EFAULT;
-		}
-		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		paddr = pfn << PAGE_SHIFT;
-		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
-		if (!table) {
-			up_read(&current->mm->mmap_sem);
-			return -EFAULT;
-		}
-		ret = CMPXCHG(&table[index], orig_pte, new_pte);
-		memunmap(table);
-		up_read(&current->mm->mmap_sem);
-	}
+	int r = -EFAULT;
+
+	if (!user_access_begin(ptep_user, sizeof(pt_element_t)))
+		return -EFAULT;
+
+#ifdef CMPXCHG
+	asm volatile("1:" LOCK_PREFIX CMPXCHG " %[new], %[ptr]\n"
+		     "mov $0, %[r]\n"
+		     "setnz %b[r]\n"
+		     "2:"
+		     _ASM_EXTABLE_UA(1b, 2b)
+		     : [ptr] "+m" (*ptep_user),
+		       [old] "+a" (orig_pte),
+		       [r] "+q" (r)
+		     : [new] "r" (new_pte)
+		     : "memory");
+#else
+	asm volatile("1:" LOCK_PREFIX "cmpxchg8b %[ptr]\n"
+		     "movl $0, %[r]\n"
+		     "jz 2f\n"
+		     "incl %[r]\n"
+		     "2:"
+		     _ASM_EXTABLE_UA(1b, 2b)
+		     : [ptr] "+m" (*ptep_user),
+		       [old] "+A" (orig_pte),
+		       [r] "+rm" (r)
+		     : [new_lo] "b" ((u32)new_pte),
+		       [new_hi] "c" ((u32)(new_pte >> 32))
+		     : "memory");
+#endif
 
-	return (ret != orig_pte);
+	user_access_end();
+	return r;
 }
 
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,


