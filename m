Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A12A4F1639
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 15:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356207AbiDDNns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 09:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356701AbiDDNnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 09:43:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3EB624F1C
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 06:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649079709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+NmYruGxKKIG/ZFA9VyQu62MgzXU5kZch5innJDCA/E=;
        b=g9QVuX/xod1zak2/trc9NyyAenyLGhIFB9edwr9/VteBDD1CiZaee0MXYehBvqG840f2Y1
        KkMR3xgQZNB6DNa7U5wGA6j1dfYnOGSK6lx9KW5wIWU5RnbER9HkJLjl7TJhHr8W5I1hEz
        DNblFs8aQMSQvE1YhvKJtj9MzvewZCQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-92RzUQCAPkWQvsVGkPza1w-1; Mon, 04 Apr 2022 09:41:43 -0400
X-MC-Unique: 92RzUQCAPkWQvsVGkPza1w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B060811E78;
        Mon,  4 Apr 2022 13:41:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 202A2468A4B;
        Mon,  4 Apr 2022 13:41:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5.15] KVM: x86/mmu: do compare-and-exchange of gPTE via the user address
Date:   Mon,  4 Apr 2022 09:41:39 -0400
Message-Id: <20220404134141.427397-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
to handle any exception correctly.  Worse, the guest PTE can be 8-byte
even on i686 so there is the extra complication of using cmpxchg8b to
account for.  But at least it is an efficient mess.

Reported-by: Qiuhao Li <qiuhao@sysec.org>
Reported-by: Gaoning Pan <pgn@zju.edu.cn>
Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Debugged-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 77 ++++++++++++++++------------------
 1 file changed, 37 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 913d52a7923e..a1811f51eda9 100644
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
@@ -147,43 +148,39 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
-- 
2.31.1

