Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299CA53E2DB
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiFFHF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiFFHFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:05:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17955250B;
        Mon,  6 Jun 2022 00:05:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCC60B80DEF;
        Mon,  6 Jun 2022 07:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDF4C385A9;
        Mon,  6 Jun 2022 07:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499109;
        bh=aBKGxu6PuhOyg1wk0hYZx0KleZ/GjEKDwYVPcgjA1vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkipBkh1Iuzf39X5klUn0U7y1uV63mlwZns0C9ZOM/DhM8c4btwpOo1IoAlgBxTxF
         3UrOG/v+BDcFx9jSfS9cfQfncLrE+4d1bjNclZ9heK8bX/1TGEolGza6NVWPsfCIY/
         qM7VdFHHWuEorXE8wKeOJk9RqIJTnMFixpBQ+d4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.17.13
Date:   Mon,  6 Jun 2022 09:05:02 +0200
Message-Id: <165449910298201@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16544991022241@kroah.com>
References: <16544991022241@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
index 31ea120ce531..0c76d4ede04b 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -77,7 +77,7 @@ as you intend it to.
 
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
-system, ``git``, as a "commit log".  See :ref:`explicit_in_reply_to`.
+system, ``git``, as a "commit log".  See :ref:`the_canonical_patch_format`.
 
 Solve only one problem per patch.  If your description starts to get
 long, that's a sign that you probably need to split up your patch.
diff --git a/Makefile b/Makefile
index 25c44dda0ef3..d38228d336bf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 17
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 160f8cd9a68d..2f57100a011a 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -895,7 +895,7 @@ bluetooth {
 		device-wakeup-gpios = <&gpg3 4 GPIO_ACTIVE_HIGH>;
 		interrupt-parent = <&gph2>;
 		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "host-wake";
+		interrupt-names = "host-wakeup";
 	};
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 25d8aff273a1..4dd5f3b08aaa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1496,7 +1496,8 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (kvm_system_needs_idmapped_vectors() && !has_vhe()) {
+	if (kvm_system_needs_idmapped_vectors() &&
+	    !is_protected_kvm_enabled()) {
 		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
 					       __BP_HARDEN_HYP_VECS_SZ, &base);
 		if (err)
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e414ca44839f..0cb20ee6a632 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -360,13 +360,15 @@ static bool kvmppc_gfn_is_uvmem_pfn(unsigned long gfn, struct kvm *kvm,
 static bool kvmppc_next_nontransitioned_gfn(const struct kvm_memory_slot *memslot,
 		struct kvm *kvm, unsigned long *gfn)
 {
-	struct kvmppc_uvmem_slot *p;
+	struct kvmppc_uvmem_slot *p = NULL, *iter;
 	bool ret = false;
 	unsigned long i;
 
-	list_for_each_entry(p, &kvm->arch.uvmem_pfns, list)
-		if (*gfn >= p->base_pfn && *gfn < p->base_pfn + p->nr_pfns)
+	list_for_each_entry(iter, &kvm->arch.uvmem_pfns, list)
+		if (*gfn >= iter->base_pfn && *gfn < iter->base_pfn + iter->nr_pfns) {
+			p = iter;
 			break;
+		}
 	if (!p)
 		return ret;
 	/*
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index ac96f9b2d64b..1c14bcce88f2 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -409,6 +409,103 @@ do {									\
 
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+#ifdef CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+#endif // CONFIG_X86_32
+#else  // !CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	int __err = 0;							\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     CC_SET(z)						\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
+					   %[errout])			\
+		     : CC_OUT(z) (success),				\
+		       [errout] "+r" (__err),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory", "cc");					\
+	if (unlikely(__err))						\
+		goto label;						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+/*
+ * Unlike the normal CMPXCHG, hardcode ECX for both success/fail and error.
+ * There are only six GPRs available and four (EAX, EBX, ECX, and EDX) are
+ * hardcoded by CMPXCHG8B, leaving only ESI and EDI.  If the compiler uses
+ * both ESI and EDI for the memory operand, compilation will fail if the error
+ * is an input+output as there will be no register available for input.
+ */
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	int __result;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     "mov $0, %%ecx\n\t"				\
+		     "setz %%cl\n"					\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %%ecx) \
+		     : [result]"=c" (__result),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory", "cc");					\
+	if (unlikely(__result < 0))					\
+		goto label;						\
+	if (unlikely(!__result))					\
+		*_old = __old;						\
+	likely(__result);					})
+#endif // CONFIG_X86_32
+#endif // CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct __user *)(x))
@@ -501,6 +598,51 @@ do {										\
 } while (0)
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+extern void __try_cmpxchg_user_wrong_size(void);
+
+#ifndef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _oldp, _nval, _label)		\
+	__try_cmpxchg_user_asm("q", "r", (_ptr), (_oldp), (_nval), _label)
+#endif
+
+/*
+ * Force the pointer to u<size> to match the size expected by the asm helper.
+ * clang/LLVM compiles all cases and only discards the unused paths after
+ * processing errors, which breaks i386 if the pointer is an 8-byte value.
+ */
+#define unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label) ({			\
+	bool __ret;								\
+	__chk_user_ptr(_ptr);							\
+	switch (sizeof(*(_ptr))) {						\
+	case 1:	__ret = __try_cmpxchg_user_asm("b", "q",			\
+					       (__force u8 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 2:	__ret = __try_cmpxchg_user_asm("w", "r",			\
+					       (__force u16 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 4:	__ret = __try_cmpxchg_user_asm("l", "r",			\
+					       (__force u32 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 8:	__ret = __try_cmpxchg64_user_asm((__force u64 *)(_ptr), (_oldp),\
+						 (_nval), _label);		\
+		break;								\
+	default: __try_cmpxchg_user_wrong_size();				\
+	}									\
+	__ret;						})
+
+/* "Returns" 0 on success, 1 on failure, -EFAULT if the access faults. */
+#define __try_cmpxchg_user(_ptr, _oldp, _nval, _label)	({		\
+	int __ret = -EFAULT;						\
+	__uaccess_begin_nospec();					\
+	__ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);	\
+_label:									\
+	__uaccess_end();						\
+	__ret;								\
+							})
+
 /*
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7c63a1911fae..3c24e6124d95 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -12,6 +12,92 @@
 #include "encls.h"
 #include "sgx.h"
 
+#define PCMDS_PER_PAGE (PAGE_SIZE / sizeof(struct sgx_pcmd))
+/*
+ * 32 PCMD entries share a PCMD page. PCMD_FIRST_MASK is used to
+ * determine the page index associated with the first PCMD entry
+ * within a PCMD page.
+ */
+#define PCMD_FIRST_MASK GENMASK(4, 0)
+
+/**
+ * reclaimer_writing_to_pcmd() - Query if any enclave page associated with
+ *                               a PCMD page is in process of being reclaimed.
+ * @encl:        Enclave to which PCMD page belongs
+ * @start_addr:  Address of enclave page using first entry within the PCMD page
+ *
+ * When an enclave page is reclaimed some Paging Crypto MetaData (PCMD) is
+ * stored. The PCMD data of a reclaimed enclave page contains enough
+ * information for the processor to verify the page at the time
+ * it is loaded back into the Enclave Page Cache (EPC).
+ *
+ * The backing storage to which enclave pages are reclaimed is laid out as
+ * follows:
+ * Encrypted enclave pages:SECS page:PCMD pages
+ *
+ * Each PCMD page contains the PCMD metadata of
+ * PAGE_SIZE/sizeof(struct sgx_pcmd) enclave pages.
+ *
+ * A PCMD page can only be truncated if it is (a) empty, and (b) not in the
+ * process of getting data (and thus soon being non-empty). (b) is tested with
+ * a check if an enclave page sharing the PCMD page is in the process of being
+ * reclaimed.
+ *
+ * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
+ * intends to reclaim that enclave page - it means that the PCMD page
+ * associated with that enclave page is about to get some data and thus
+ * even if the PCMD page is empty, it should not be truncated.
+ *
+ * Context: Enclave mutex (&sgx_encl->lock) must be held.
+ * Return: 1 if the reclaimer is about to write to the PCMD page
+ *         0 if the reclaimer has no intention to write to the PCMD page
+ */
+static int reclaimer_writing_to_pcmd(struct sgx_encl *encl,
+				     unsigned long start_addr)
+{
+	int reclaimed = 0;
+	int i;
+
+	/*
+	 * PCMD_FIRST_MASK is based on number of PCMD entries within
+	 * PCMD page being 32.
+	 */
+	BUILD_BUG_ON(PCMDS_PER_PAGE != 32);
+
+	for (i = 0; i < PCMDS_PER_PAGE; i++) {
+		struct sgx_encl_page *entry;
+		unsigned long addr;
+
+		addr = start_addr + i * PAGE_SIZE;
+
+		/*
+		 * Stop when reaching the SECS page - it does not
+		 * have a page_array entry and its reclaim is
+		 * started and completed with enclave mutex held so
+		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
+		 * flag.
+		 */
+		if (addr == encl->base + encl->size)
+			break;
+
+		entry = xa_load(&encl->page_array, PFN_DOWN(addr));
+		if (!entry)
+			continue;
+
+		/*
+		 * VA page slot ID uses same bit as the flag so it is important
+		 * to ensure that the page is not already in backing store.
+		 */
+		if (entry->epc_page &&
+		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
+			reclaimed = 1;
+			break;
+		}
+	}
+
+	return reclaimed;
+}
+
 /*
  * Calculate byte offset of a PCMD struct associated with an enclave page. PCMD's
  * follow right after the EPC data in the backing storage. In addition to the
@@ -47,6 +133,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	struct sgx_encl *encl = encl_page->encl;
 	pgoff_t page_index, page_pcmd_off;
+	unsigned long pcmd_first_page;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
 	bool pcmd_page_empty;
@@ -58,6 +145,11 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	else
 		page_index = PFN_DOWN(encl->size);
 
+	/*
+	 * Address of enclave page using the first entry within the PCMD page.
+	 */
+	pcmd_first_page = PFN_PHYS(page_index & ~PCMD_FIRST_MASK) + encl->base;
+
 	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 
 	ret = sgx_encl_get_backing(encl, page_index, &b);
@@ -84,6 +176,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	}
 
 	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
+	set_page_dirty(b.pcmd);
 
 	/*
 	 * The area for the PCMD in the page was zeroed above.  Check if the
@@ -94,12 +187,20 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	sgx_encl_put_backing(&b, false);
+	get_page(b.pcmd);
+	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty)
+	if (pcmd_page_empty && !reclaimer_writing_to_pcmd(encl, pcmd_first_page)) {
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+		pcmd_page = kmap_atomic(b.pcmd);
+		if (memchr_inv(pcmd_page, 0, PAGE_SIZE))
+			pr_warn("PCMD page not empty after truncate.\n");
+		kunmap_atomic(pcmd_page);
+	}
+
+	put_page(b.pcmd);
 
 	return ret;
 }
@@ -645,15 +746,9 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 /**
  * sgx_encl_put_backing() - Unpin the backing storage
  * @backing:	data for accessing backing storage for the page
- * @do_write:	mark pages dirty
  */
-void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
+void sgx_encl_put_backing(struct sgx_backing *backing)
 {
-	if (do_write) {
-		set_page_dirty(backing->pcmd);
-		set_page_dirty(backing->contents);
-	}
-
 	put_page(backing->pcmd);
 	put_page(backing->contents);
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index fec43ca65065..d44e7372151f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -107,7 +107,7 @@ void sgx_encl_release(struct kref *ref);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing);
-void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
+void sgx_encl_put_backing(struct sgx_backing *backing);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8e4bc6453d26..ab4ec54bbdd9 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -191,6 +191,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
 			  backing->pcmd_offset;
 
 	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
+	set_page_dirty(backing->pcmd);
+	set_page_dirty(backing->contents);
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
 					      backing->pcmd_offset));
@@ -308,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
+	sgx_encl_put_backing(backing);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
 		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -320,7 +323,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
-		sgx_encl_put_backing(&secs_backing, true);
+		sgx_encl_put_backing(&secs_backing);
 	}
 
 out:
@@ -379,11 +382,14 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
+
+		mutex_lock(&encl_page->encl->lock);
 		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
+		}
 
-		mutex_lock(&encl_page->encl->lock);
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -411,7 +417,6 @@ static void sgx_reclaim_pages(void)
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i], true);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 5290d6472308..98e6c29e17a4 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -14,6 +14,8 @@
 #include <asm/traps.h>
 #include <asm/irq_regs.h>
 
+#include <uapi/asm/kvm.h>
+
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 #include <linux/vmalloc.h>
@@ -232,7 +234,20 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
 	gfpu->perm		= fpu_user_cfg.default_features;
-	gfpu->uabi_size		= fpu_user_cfg.default_size;
+
+	/*
+	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
+	 * to userspace, even when XSAVE is unsupported, so that restoring FPU
+	 * state on a different CPU that does support XSAVE can cleanly load
+	 * the incoming state using its natural XSAVE.  In other words, KVM's
+	 * uABI size may be larger than this host's default size.  Conversely,
+	 * the default size should never be larger than KVM's base uABI size;
+	 * all features that can expand the uABI size must be opt-in.
+	 */
+	gfpu->uabi_size		= sizeof(struct kvm_xsave);
+	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
+		gfpu->uabi_size = fpu_user_cfg.default_size;
+
 	fpu_init_guest_permissions(gfpu);
 
 	return true;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4c2a158bb6c4..015df76bc914 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -191,7 +191,7 @@ void kvm_async_pf_task_wake(u32 token)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node *n;
+	struct kvm_task_sleep_node *n, *dummy = NULL;
 
 	if (token == ~0) {
 		apf_task_wake_all();
@@ -203,28 +203,41 @@ void kvm_async_pf_task_wake(u32 token)
 	n = _find_apf_task(b, token);
 	if (!n) {
 		/*
-		 * async PF was not yet handled.
-		 * Add dummy entry for the token.
+		 * Async #PF not yet handled, add a dummy entry for the token.
+		 * Allocating the token must be down outside of the raw lock
+		 * as the allocator is preemptible on PREEMPT_RT kernels.
 		 */
-		n = kzalloc(sizeof(*n), GFP_ATOMIC);
-		if (!n) {
+		if (!dummy) {
+			raw_spin_unlock(&b->lock);
+			dummy = kzalloc(sizeof(*dummy), GFP_ATOMIC);
+
 			/*
-			 * Allocation failed! Busy wait while other cpu
-			 * handles async PF.
+			 * Continue looping on allocation failure, eventually
+			 * the async #PF will be handled and allocating a new
+			 * node will be unnecessary.
+			 */
+			if (!dummy)
+				cpu_relax();
+
+			/*
+			 * Recheck for async #PF completion before enqueueing
+			 * the dummy token to avoid duplicate list entries.
 			 */
-			raw_spin_unlock(&b->lock);
-			cpu_relax();
 			goto again;
 		}
-		n->token = token;
-		n->cpu = smp_processor_id();
-		init_swait_queue_head(&n->wq);
-		hlist_add_head(&n->link, &b->list);
+		dummy->token = token;
+		dummy->cpu = smp_processor_id();
+		init_swait_queue_head(&dummy->wq);
+		hlist_add_head(&dummy->link, &b->list);
+		dummy = NULL;
 	} else {
 		apf_task_wake_one(n);
 	}
 	raw_spin_unlock(&b->lock);
-	return;
+
+	/* A dummy token might be allocated and ultimately not used.  */
+	if (dummy)
+		kfree(dummy);
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 495329ae6b1b..f03fa385b2e2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1894,17 +1894,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
 	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
 
-	if (ret < 0) {
+	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
-		return false;
-	}
-
-	return !!ret;
+	return ret;
 }
 
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
@@ -2033,7 +2030,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 
 		for_each_sp(pages, sp, parents, i) {
 			kvm_unlink_unsync_page(vcpu->kvm, sp);
-			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
+			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
 			mmu_pages_clear_parents(&parents);
 		}
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
@@ -2074,6 +2071,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	struct hlist_head *sp_list;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
+	int ret;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
@@ -2126,11 +2124,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			 * If the sync fails, the page is zapped.  If so, break
 			 * in order to rebuild it.
 			 */
-			if (!kvm_sync_page(vcpu, sp, &invalid_list))
+			ret = kvm_sync_page(vcpu, sp, &invalid_list);
+			if (ret < 0)
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			if (ret > 0)
+				kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
 		__clear_sp_write_flooding_count(sp);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3821d5140ea3..8aba3c5be462 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -144,42 +144,6 @@ static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
 	       FNAME(is_bad_mt_xwr)(&mmu->guest_rsvd_check, gpte);
 }
 
-static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			       pt_element_t __user *ptep_user, unsigned index,
-			       pt_element_t orig_pte, pt_element_t new_pte)
-{
-	signed char r;
-
-	if (!user_access_begin(ptep_user, sizeof(pt_element_t)))
-		return -EFAULT;
-
-#ifdef CMPXCHG
-	asm volatile("1:" LOCK_PREFIX CMPXCHG " %[new], %[ptr]\n"
-		     "setnz %b[r]\n"
-		     "2:"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %k[r])
-		     : [ptr] "+m" (*ptep_user),
-		       [old] "+a" (orig_pte),
-		       [r] "=q" (r)
-		     : [new] "r" (new_pte)
-		     : "memory");
-#else
-	asm volatile("1:" LOCK_PREFIX "cmpxchg8b %[ptr]\n"
-		     "setnz %b[r]\n"
-		     "2:"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %k[r])
-		     : [ptr] "+m" (*ptep_user),
-		       [old] "+A" (orig_pte),
-		       [r] "=q" (r)
-		     : [new_lo] "b" ((u32)new_pte),
-		       [new_hi] "c" ((u32)(new_pte >> 32))
-		     : "memory");
-#endif
-
-	user_access_end();
-	return r;
-}
-
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  u64 gpte)
@@ -278,7 +242,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 		if (unlikely(!walker->pte_writable[level - 1]))
 			continue;
 
-		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
+		ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
 		if (ret)
 			return ret;
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 39d280e7e80e..26140579456b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -790,9 +790,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct kvm_host_map map;
 	int rc;
 
-	/* Triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 76e6411d4dde..730d887f53ac 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -684,7 +684,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -804,7 +804,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
@@ -1090,7 +1090,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -1172,7 +1172,7 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	/* allocate the memory to hold the session data blob */
-	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
+	session_data = kzalloc(params.session_len, GFP_KERNEL_ACCOUNT);
 	if (!session_data)
 		return -ENOMEM;
 
@@ -1296,11 +1296,11 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* allocate memory for header and transport buffer */
 	ret = -ENOMEM;
-	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	hdr = kzalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
 	if (!hdr)
 		goto e_unpin;
 
-	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	trans_data = kzalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
 	if (!trans_data)
 		goto e_free_hdr;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 896ddf739236..3237d804564b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4518,9 +4518,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-	/* Similarly, triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 267d6dc4b818..c87be7c52cc2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7858,7 +7858,7 @@ static unsigned int vmx_handle_intel_pt_intr(void)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!kvm_arch_pmi_in_guest(vcpu))
+	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23d176cd12a4..5204283da798 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7168,15 +7168,8 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 				   exception, &write_emultor);
 }
 
-#define CMPXCHG_TYPE(t, ptr, old, new) \
-	(cmpxchg((t *)(ptr), *(t *)(old), *(t *)(new)) == *(t *)(old))
-
-#ifdef CONFIG_X86_64
-#  define CMPXCHG64(ptr, old, new) CMPXCHG_TYPE(u64, ptr, old, new)
-#else
-#  define CMPXCHG64(ptr, old, new) \
-	(cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new)) == *(u64 *)(old))
-#endif
+#define emulator_try_cmpxchg_user(t, ptr, old, new) \
+	(__try_cmpxchg_user((t __user *)(ptr), (t *)(old), *(t *)(new), efault ## t))
 
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
@@ -7185,12 +7178,11 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned int bytes,
 				     struct x86_exception *exception)
 {
-	struct kvm_host_map map;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u64 page_line_mask;
+	unsigned long hva;
 	gpa_t gpa;
-	char *kaddr;
-	bool exchanged;
+	int r;
 
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes > 8 || (bytes & (bytes - 1)))
@@ -7214,31 +7206,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
 		goto emul_write;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
+	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
+	if (kvm_is_error_hva(hva))
 		goto emul_write;
 
-	kaddr = map.hva + offset_in_page(gpa);
+	hva += offset_in_page(gpa);
 
 	switch (bytes) {
 	case 1:
-		exchanged = CMPXCHG_TYPE(u8, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u8, hva, old, new);
 		break;
 	case 2:
-		exchanged = CMPXCHG_TYPE(u16, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u16, hva, old, new);
 		break;
 	case 4:
-		exchanged = CMPXCHG_TYPE(u32, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u32, hva, old, new);
 		break;
 	case 8:
-		exchanged = CMPXCHG64(kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u64, hva, old, new);
 		break;
 	default:
 		BUG();
 	}
 
-	kvm_vcpu_unmap(vcpu, &map, true);
-
-	if (!exchanged)
+	if (r < 0)
+		goto emul_write;
+	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
 	kvm_page_track_write(vcpu, gpa, new, bytes);
@@ -8176,7 +8169,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
-static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
+static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu, int *r)
 {
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
@@ -8245,25 +8238,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 }
 
 /*
- * Decode to be emulated instruction. Return EMULATION_OK if success.
+ * Decode an instruction for emulation.  The caller is responsible for handling
+ * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
+ * (and wrong) when emulating on an intercepted fault-like exception[*], as
+ * code breakpoints have higher priority and thus have already been done by
+ * hardware.
+ *
+ * [*] Except #MC, which is higher priority, but KVM should never emulate in
+ *     response to a machine check.
  */
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 				    void *insn, int insn_len)
 {
-	int r = EMULATION_OK;
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	int r;
 
 	init_emulate_ctxt(vcpu);
 
-	/*
-	 * We will reenter on the same instruction since we do not set
-	 * complete_userspace_io. This does not handle watchpoints yet,
-	 * those would be handled in the emulate_ops.
-	 */
-	if (!(emulation_type & EMULTYPE_SKIP) &&
-	    kvm_vcpu_check_breakpoint(vcpu, &r))
-		return r;
-
 	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
@@ -8296,6 +8287,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);
 
+		/*
+		 * Return immediately if RIP hits a code breakpoint, such #DBs
+		 * are fault-like and are higher priority than any faults on
+		 * the code fetch itself.
+		 */
+		if (!(emulation_type & EMULTYPE_SKIP) &&
+		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+			return r;
+
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
 						    insn, insn_len);
 		if (r != EMULATION_OK)  {
@@ -11655,20 +11655,15 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
-static void kvm_free_vcpus(struct kvm *kvm)
+static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 {
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
-	/*
-	 * Unpin any mmu pages first.
-	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_unload_vcpu_mmu(vcpu);
 	}
-
-	kvm_destroy_vcpus(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -11774,11 +11769,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
+	kvm_unload_vcpu_mmus(kvm);
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
-	kvm_free_vcpus(kvm);
+	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index b32ffcaad9ad..f3c6b5e15e75 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -113,15 +113,15 @@ static int ecrdsa_verify(struct akcipher_request *req)
 
 	/* Step 1: verify that 0 < r < q, 0 < s < q */
 	if (vli_is_zero(r, ndigits) ||
-	    vli_cmp(r, ctx->curve->n, ndigits) == 1 ||
+	    vli_cmp(r, ctx->curve->n, ndigits) >= 0 ||
 	    vli_is_zero(s, ndigits) ||
-	    vli_cmp(s, ctx->curve->n, ndigits) == 1)
+	    vli_cmp(s, ctx->curve->n, ndigits) >= 0)
 		return -EKEYREJECTED;
 
 	/* Step 2: calculate hash (h) of the message (passed as input) */
 	/* Step 3: calculate e = h \mod q */
 	vli_from_le64(e, digest, ndigits);
-	if (vli_cmp(e, ctx->curve->n, ndigits) == 1)
+	if (vli_cmp(e, ctx->curve->n, ndigits) >= 0)
 		vli_sub(e, e, ctx->curve->n, ndigits);
 	if (vli_is_zero(e, ndigits))
 		e[0] = 1;
@@ -137,7 +137,7 @@ static int ecrdsa_verify(struct akcipher_request *req)
 	/* Step 6: calculate point C = z_1P + z_2Q, and R = x_c \mod q */
 	ecc_point_mult_shamir(&cc, z1, &ctx->curve->g, z2, &ctx->pub_key,
 			      ctx->curve);
-	if (vli_cmp(cc.x, ctx->curve->n, ndigits) == 1)
+	if (vli_cmp(cc.x, ctx->curve->n, ndigits) >= 0)
 		vli_sub(cc.x, cc.x, ctx->curve->n, ndigits);
 
 	/* Step 7: if R == r signature is valid */
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f6e91fb432a3..eab34e24d944 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -696,9 +696,9 @@ static int qca_close(struct hci_uart *hu)
 	skb_queue_purge(&qca->tx_wait_q);
 	skb_queue_purge(&qca->txq);
 	skb_queue_purge(&qca->rx_memdump_q);
-	del_timer(&qca->tx_idle_timer);
-	del_timer(&qca->wake_retrans_timer);
 	destroy_workqueue(qca->workqueue);
+	del_timer_sync(&qca->tx_idle_timer);
+	del_timer_sync(&qca->wake_retrans_timer);
 	qca->hu = NULL;
 
 	kfree_skb(qca->rx_skb);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 4704fa553098..04a3e23a4afc 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -400,7 +400,16 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 	if (!rc) {
 		out = (struct tpm2_get_cap_out *)
 			&buf.data[TPM_HEADER_SIZE];
-		*value = be32_to_cpu(out->value);
+		/*
+		 * To prevent failing boot up of some systems, Infineon TPM2.0
+		 * returns SUCCESS on TPM2_Startup in field upgrade mode. Also
+		 * the TPM2_Getcapability command returns a zero length list
+		 * in field upgrade mode.
+		 */
+		if (be32_to_cpu(out->property_cnt) > 0)
+			*value = be32_to_cpu(out->value);
+		else
+			rc = -ENODATA;
 	}
 	tpm_buf_destroy(&buf);
 	return rc;
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 3af4c07a9342..d3989b257f42 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -681,6 +681,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	if (!wait_event_timeout(ibmvtpm->crq_queue.wq,
 				ibmvtpm->rtce_buf != NULL,
 				HZ)) {
+		rc = -ENODEV;
 		dev_err(dev, "CRQ response timed out\n");
 		goto init_irq_cleanup;
 	}
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..f87aa2169e5f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -609,6 +609,13 @@ static bool check_version(struct fsl_mc_version *mc_version, u32 major,
 }
 #endif
 
+static bool needs_entropy_delay_adjustment(void)
+{
+	if (of_machine_is_compatible("fsl,imx6sx"))
+		return true;
+	return false;
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -855,6 +862,8 @@ static int caam_probe(struct platform_device *pdev)
 			 * Also, if a handle was instantiated, do not change
 			 * the TRNG parameters.
 			 */
+			if (needs_entropy_delay_adjustment())
+				ent_delay = 12000;
 			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
 				dev_info(dev,
 					 "Entropy delay = %u\n",
@@ -871,6 +880,15 @@ static int caam_probe(struct platform_device *pdev)
 			 */
 			ret = instantiate_rng(dev, inst_handles,
 					      gen_sk);
+			/*
+			 * Entropy delay is determined via TRNG characterization.
+			 * TRNG characterization is run across different voltages
+			 * and temperatures.
+			 * If worst case value for ent_dly is identified,
+			 * the loop can be skipped for that platform.
+			 */
+			if (needs_entropy_delay_adjustment())
+				break;
 			if (ret == -EAGAIN)
 				/*
 				 * if here, the loop will rerun,
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 12120474c80c..b97a079a56aa 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2876,7 +2876,7 @@ static void ilk_compute_wm_level(const struct drm_i915_private *dev_priv,
 }
 
 static void intel_read_wm_latency(struct drm_i915_private *dev_priv,
-				  u16 wm[8])
+				  u16 wm[])
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 78bd3ddda442..aca7909c726d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -760,6 +760,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
+#define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 99eabfb4145b..6bb3890b0f2c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2034,6 +2034,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
 
+	/* Lenovo X12 TAB Gen 1 */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X12_TAB) },
+
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
@@ -2178,6 +2184,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_GOOGLE,
 		HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY, USB_VENDOR_ID_GOOGLE,
 			USB_DEVICE_ID_GOOGLE_TOUCH_ROSE) },
+	{ .driver_data = MT_CLS_GOOGLE,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8, USB_VENDOR_ID_GOOGLE,
+			USB_DEVICE_ID_GOOGLE_WHISKERS) },
 
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index f4820fd3dc13..9c7896536021 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -82,6 +82,7 @@
 
 #define ISMT_DESC_ENTRIES	2	/* number of descriptor entries */
 #define ISMT_MAX_RETRIES	3	/* number of SMBus retries to attempt */
+#define ISMT_LOG_ENTRIES	3	/* number of interrupt cause log entries */
 
 /* Hardware Descriptor Constants - Control Field */
 #define ISMT_DESC_CWRL	0x01	/* Command/Write Length */
@@ -175,6 +176,8 @@ struct ismt_priv {
 	u8 head;				/* ring buffer head pointer */
 	struct completion cmp;			/* interrupt completion */
 	u8 buffer[I2C_SMBUS_BLOCK_MAX + 16];	/* temp R/W data buffer */
+	dma_addr_t log_dma;
+	u32 *log;
 };
 
 static const struct pci_device_id ismt_ids[] = {
@@ -411,6 +414,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 	memset(desc, 0, sizeof(struct ismt_desc));
 	desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, read_write);
 
+	/* Always clear the log entries */
+	memset(priv->log, 0, ISMT_LOG_ENTRIES * sizeof(u32));
+
 	/* Initialize common control bits */
 	if (likely(pci_dev_msi_enabled(priv->pci_dev)))
 		desc->control = ISMT_DESC_INT | ISMT_DESC_FAIR;
@@ -522,6 +528,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 
 	case I2C_SMBUS_BLOCK_PROC_CALL:
 		dev_dbg(dev, "I2C_SMBUS_BLOCK_PROC_CALL\n");
+		if (data->block[0] > I2C_SMBUS_BLOCK_MAX)
+			return -EINVAL;
+
 		dma_size = I2C_SMBUS_BLOCK_MAX;
 		desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, 1);
 		desc->wr_len_cmd = data->block[0] + 1;
@@ -708,6 +717,8 @@ static void ismt_hw_init(struct ismt_priv *priv)
 	/* initialize the Master Descriptor Base Address (MDBA) */
 	writeq(priv->io_rng_dma, priv->smba + ISMT_MSTR_MDBA);
 
+	writeq(priv->log_dma, priv->smba + ISMT_GR_SMTICL);
+
 	/* initialize the Master Control Register (MCTRL) */
 	writel(ISMT_MCTRL_MEIE, priv->smba + ISMT_MSTR_MCTRL);
 
@@ -795,6 +806,12 @@ static int ismt_dev_init(struct ismt_priv *priv)
 	priv->head = 0;
 	init_completion(&priv->cmp);
 
+	priv->log = dmam_alloc_coherent(&priv->pci_dev->dev,
+					ISMT_LOG_ENTRIES * sizeof(u32),
+					&priv->log_dma, GFP_KERNEL);
+	if (!priv->log)
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/drivers/i2c/busses/i2c-thunderx-pcidrv.c b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
index 12c90aa0900e..a77cd86fe75e 100644
--- a/drivers/i2c/busses/i2c-thunderx-pcidrv.c
+++ b/drivers/i2c/busses/i2c-thunderx-pcidrv.c
@@ -213,6 +213,7 @@ static int thunder_i2c_probe_pci(struct pci_dev *pdev,
 	i2c->adap.bus_recovery_info = &octeon_i2c_recovery_info;
 	i2c->adap.dev.parent = dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	i2c->adap.dev.fwnode = dev->fwnode;
 	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
 		 "Cavium ThunderX i2c adapter at %s", dev_name(dev));
 	i2c_set_adapdata(&i2c->adap, i2c);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f51aea71cb03..a97ac274d875 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3449,6 +3449,11 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_SUBMITTED;
 }
 
+static char hex2asc(unsigned char c)
+{
+	return c + '0' + ((unsigned)(9 - c) >> 4 & 0x27);
+}
+
 static void crypt_status(struct dm_target *ti, status_type_t type,
 			 unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -3467,9 +3472,12 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 		if (cc->key_size > 0) {
 			if (cc->key_string)
 				DMEMIT(":%u:%s", cc->key_size, cc->key_string);
-			else
-				for (i = 0; i < cc->key_size; i++)
-					DMEMIT("%02x", cc->key[i]);
+			else {
+				for (i = 0; i < cc->key_size; i++) {
+					DMEMIT("%c%c", hex2asc(cc->key[i] >> 4),
+					       hex2asc(cc->key[i] & 0xf));
+				}
+			}
 		} else
 			DMEMIT("-");
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ffe50be8b687..afd127eef0c1 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4495,8 +4495,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (should_write_sb) {
-		int r;
-
 		init_journal(ic, 0, ic->journal_sections, 0);
 		r = dm_integrity_failed(ic);
 		if (unlikely(r)) {
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 0e039a8c0bf2..a3f2050b9c9b 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -225,6 +225,7 @@ void dm_stats_cleanup(struct dm_stats *stats)
 				       atomic_read(&shared->in_flight[READ]),
 				       atomic_read(&shared->in_flight[WRITE]));
 			}
+			cond_resched();
 		}
 		dm_stat_free(&s->rcu_head);
 	}
@@ -330,6 +331,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 	for (ni = 0; ni < n_entries; ni++) {
 		atomic_set(&s->stat_shared[ni].in_flight[READ], 0);
 		atomic_set(&s->stat_shared[ni].in_flight[WRITE], 0);
+		cond_resched();
 	}
 
 	if (s->n_histogram_entries) {
@@ -342,6 +344,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 		for (ni = 0; ni < n_entries; ni++) {
 			s->stat_shared[ni].tmp.histogram = hi;
 			hi += s->n_histogram_entries + 1;
+			cond_resched();
 		}
 	}
 
@@ -362,6 +365,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 			for (ni = 0; ni < n_entries; ni++) {
 				p[ni].histogram = hi;
 				hi += s->n_histogram_entries + 1;
+				cond_resched();
 			}
 		}
 	}
@@ -497,6 +501,7 @@ static int dm_stats_list(struct dm_stats *stats, const char *program,
 			}
 			DMEMIT("\n");
 		}
+		cond_resched();
 	}
 	mutex_unlock(&stats->mutex);
 
@@ -774,6 +779,7 @@ static void __dm_stat_clear(struct dm_stat *s, size_t idx_start, size_t idx_end,
 				local_irq_enable();
 			}
 		}
+		cond_resched();
 	}
 }
 
@@ -889,6 +895,8 @@ static int dm_stats_print(struct dm_stats *stats, int id,
 
 		if (unlikely(sz + 1 >= maxlen))
 			goto buffer_overflow;
+
+		cond_resched();
 	}
 
 	if (clear)
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 80133aae0db3..d6dbd47492a8 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1312,6 +1312,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 static struct target_type verity_target = {
 	.name		= "verity",
+	.features	= DM_TARGET_IMMUTABLE,
 	.version	= {1, 8, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ffe720c73b0a..ad7a84a82938 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -686,17 +686,17 @@ int raid5_calc_degraded(struct r5conf *conf)
 	return degraded;
 }
 
-static int has_failed(struct r5conf *conf)
+static bool has_failed(struct r5conf *conf)
 {
-	int degraded;
+	int degraded = conf->mddev->degraded;
 
-	if (conf->mddev->reshape_position == MaxSector)
-		return conf->mddev->degraded > conf->max_degraded;
+	if (test_bit(MD_BROKEN, &conf->mddev->flags))
+		return true;
 
-	degraded = raid5_calc_degraded(conf);
-	if (degraded > conf->max_degraded)
-		return 1;
-	return 0;
+	if (conf->mddev->reshape_position != MaxSector)
+		degraded = raid5_calc_degraded(conf);
+
+	return degraded > conf->max_degraded;
 }
 
 struct stripe_head *
@@ -2877,34 +2877,31 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	unsigned long flags;
 	pr_debug("raid456: error called\n");
 
+	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n",
+		mdname(mddev), bdevname(rdev->bdev, b));
+
 	spin_lock_irqsave(&conf->device_lock, flags);
+	set_bit(Faulty, &rdev->flags);
+	clear_bit(In_sync, &rdev->flags);
+	mddev->degraded = raid5_calc_degraded(conf);
 
-	if (test_bit(In_sync, &rdev->flags) &&
-	    mddev->degraded == conf->max_degraded) {
-		/*
-		 * Don't allow to achieve failed state
-		 * Don't try to recover this device
-		 */
+	if (has_failed(conf)) {
+		set_bit(MD_BROKEN, &conf->mddev->flags);
 		conf->recovery_disabled = mddev->recovery_disabled;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		return;
+
+		pr_crit("md/raid:%s: Cannot continue operation (%d/%d failed).\n",
+			mdname(mddev), mddev->degraded, conf->raid_disks);
+	} else {
+		pr_crit("md/raid:%s: Operation continuing on %d devices.\n",
+			mdname(mddev), conf->raid_disks - mddev->degraded);
 	}
 
-	set_bit(Faulty, &rdev->flags);
-	clear_bit(In_sync, &rdev->flags);
-	mddev->degraded = raid5_calc_degraded(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
 	set_bit(Blocked, &rdev->flags);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n"
-		"md/raid:%s: Operation continuing on %d devices.\n",
-		mdname(mddev),
-		bdevname(rdev->bdev, b),
-		mdname(mddev),
-		conf->raid_disks - mddev->degraded);
 	r5c_update_on_rdev_error(mddev, rdev);
 }
 
diff --git a/drivers/media/i2c/imx412.c b/drivers/media/i2c/imx412.c
index be3f6ea55559..84279a680873 100644
--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -1011,7 +1011,7 @@ static int imx412_power_on(struct device *dev)
 	struct imx412 *imx412 = to_imx412(sd);
 	int ret;
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
 
 	ret = clk_prepare_enable(imx412->inclk);
 	if (ret) {
@@ -1024,7 +1024,7 @@ static int imx412_power_on(struct device *dev)
 	return 0;
 
 error_reset:
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	return ret;
 }
@@ -1040,10 +1040,10 @@ static int imx412_power_off(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx412 *imx412 = to_imx412(sd);
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
-
 	clk_disable_unprepare(imx412->inclk);
 
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index caf48023f8ea..5231818943c6 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
+	/* AST2600 tx checksum with NCSI is broken */
+	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
 	netdev->features |= netdev->hw_features;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 2ecfc17544a6..dde55ccae9d7 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -723,13 +723,15 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
+			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
+			buffer_size = IPA_RX_BUFFER_SIZE - NET_SKB_PAD;
+			limit = ipa_aggr_size_kb(buffer_size);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a491db46e3bd..d9f6367b9993 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2787,13 +2787,14 @@ void pn53x_common_clean(struct pn533 *priv)
 {
 	struct pn533_cmd *cmd, *n;
 
+	/* delete the timer before cleanup the worker */
+	del_timer_sync(&priv->listen_timer);
+
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
 
-	del_timer(&priv->listen_timer);
-
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);
 		kfree(cmd);
diff --git a/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c b/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c
index 2801ca706273..68a5b627fb9b 100644
--- a/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c
+++ b/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c
@@ -204,7 +204,7 @@ static const struct sunxi_desc_pin suniv_f1c100s_pins[] = {
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
 		  SUNXI_FUNCTION(0x2, "lcd"),		/* D20 */
-		  SUNXI_FUNCTION(0x3, "lvds1"),		/* RX */
+		  SUNXI_FUNCTION(0x3, "uart2"),		/* RX */
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 14)),
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 15),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 03f142307174..9f42f25fab92 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -148,7 +148,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
-	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return -EINVAL;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
@@ -166,7 +168,9 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct exfat_mount_options *opts = &sbi->options;
 
-	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 619e5b4bed10..0f2b1b196fa2 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -380,6 +380,12 @@ static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		EXFAT_RESERVED_CLUSTERS;
 }
 
+static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
+		unsigned int clus)
+{
+	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
+}
+
 /* super.c */
 int exfat_set_volume_dirty(struct super_block *sb);
 int exfat_clear_volume_dirty(struct super_block *sb);
diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index a3464e56a7e1..421c27353104 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -81,12 +81,6 @@ int exfat_ent_set(struct super_block *sb, unsigned int loc,
 	return 0;
 }
 
-static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
-		unsigned int clus)
-{
-	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
-}
-
 int exfat_ent_get(struct super_block *sb, unsigned int loc,
 		unsigned int *content)
 {
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 465e39ff018d..b3b8ac4a9ace 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -827,6 +827,7 @@ static inline bool nfs_error_is_fatal_on_server(int err)
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
+	case -ENOMEM:
 		return false;
 	}
 	return nfs_error_is_fatal(err);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f3b71fd1d134..8ad64b207b58 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7330,16 +7330,12 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 		if (sop->so_is_open_owner || !same_owner_str(sop, owner))
 			continue;
 
-		/* see if there are still any locks associated with it */
-		lo = lockowner(sop);
-		list_for_each_entry(stp, &sop->so_stateids, st_perstateowner) {
-			if (check_for_locks(stp->st_stid.sc_file, lo)) {
-				status = nfserr_locks_held;
-				spin_unlock(&clp->cl_lock);
-				return status;
-			}
+		if (atomic_read(&sop->so_count) != 1) {
+			spin_unlock(&clp->cl_lock);
+			return nfserr_locks_held;
 		}
 
+		lo = lockowner(sop);
 		nfs4_get_stateowner(sop);
 		break;
 	}
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 29813200c7af..e81246d9a08e 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -668,9 +668,11 @@ static u32 format_size_gb(const u64 bytes, u32 *mb)
 
 static u32 true_sectors_per_clst(const struct NTFS_BOOT *boot)
 {
-	return boot->sectors_per_clusters <= 0x80
-		       ? boot->sectors_per_clusters
-		       : (1u << (0 - boot->sectors_per_clusters));
+	if (boot->sectors_per_clusters <= 0x80)
+		return boot->sectors_per_clusters;
+	if (boot->sectors_per_clusters >= 0xf4) /* limit shift to 2MB max */
+		return 1U << (0 - boot->sectors_per_clusters);
+	return -EINVAL;
 }
 
 /*
@@ -713,6 +715,8 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 
 	/* cluster size: 512, 1K, 2K, 4K, ... 2M */
 	sct_per_clst = true_sectors_per_clst(boot);
+	if ((int)sct_per_clst < 0)
+		goto out;
 	if (!is_power_of_2(sct_per_clst))
 		goto out;
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 2667db9506e2..1025f8ad1aa5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -653,7 +653,7 @@ pipe_poll(struct file *filp, poll_table *wait)
 	unsigned int head, tail;
 
 	/* Epoll has some historical nasty semantics, this enables them */
-	pipe->poll_usage = 1;
+	WRITE_ONCE(pipe->poll_usage, true);
 
 	/*
 	 * Reading pipe state only -- no need for acquiring the semaphore.
@@ -1245,30 +1245,33 @@ unsigned int round_pipe_size(unsigned long size)
 
 /*
  * Resize the pipe ring to a number of slots.
+ *
+ * Note the pipe can be reduced in capacity, but only if the current
+ * occupancy doesn't exceed nr_slots; if it does, EBUSY will be
+ * returned instead.
  */
 int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 {
 	struct pipe_buffer *bufs;
 	unsigned int head, tail, mask, n;
 
-	/*
-	 * We can shrink the pipe, if arg is greater than the ring occupancy.
-	 * Since we don't expect a lot of shrink+grow operations, just free and
-	 * allocate again like we would do for growing.  If the pipe currently
-	 * contains more buffers than arg, then return busy.
-	 */
-	mask = pipe->ring_size - 1;
-	head = pipe->head;
-	tail = pipe->tail;
-	n = pipe_occupancy(pipe->head, pipe->tail);
-	if (nr_slots < n)
-		return -EBUSY;
-
 	bufs = kcalloc(nr_slots, sizeof(*bufs),
 		       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
+	spin_lock_irq(&pipe->rd_wait.lock);
+	mask = pipe->ring_size - 1;
+	head = pipe->head;
+	tail = pipe->tail;
+
+	n = pipe_occupancy(head, tail);
+	if (nr_slots < n) {
+		spin_unlock_irq(&pipe->rd_wait.lock);
+		kfree(bufs);
+		return -EBUSY;
+	}
+
 	/*
 	 * The pipe array wraps around, so just start the new one at zero
 	 * and adjust the indices.
@@ -1300,6 +1303,8 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 	pipe->tail = tail;
 	pipe->head = head;
 
+	spin_unlock_irq(&pipe->rd_wait.lock);
+
 	/* This might have made more room for writers */
 	wake_up_interruptible(&pipe->wr_wait);
 	return 0;
diff --git a/include/linux/bpf_local_storage.h b/include/linux/bpf_local_storage.h
index 37b3906af8b1..40b561b09e47 100644
--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -143,9 +143,9 @@ void bpf_selem_link_storage_nolock(struct bpf_local_storage *local_storage,
 
 bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 				     struct bpf_local_storage_elem *selem,
-				     bool uncharge_omem);
+				     bool uncharge_omem, bool use_trace_rcu);
 
-void bpf_selem_unlink(struct bpf_local_storage_elem *selem);
+void bpf_selem_unlink(struct bpf_local_storage_elem *selem, bool use_trace_rcu);
 
 void bpf_selem_link_map(struct bpf_local_storage_map *smap,
 			struct bpf_local_storage_elem *selem);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index c00c618ef290..cb0fd633a610 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -71,7 +71,7 @@ struct pipe_inode_info {
 	unsigned int files;
 	unsigned int r_counter;
 	unsigned int w_counter;
-	unsigned int poll_usage;
+	bool poll_usage;
 	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 13807ea94cd2..2d524782f53b 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -58,8 +58,13 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct)) {
 			ret = __nf_conntrack_confirm(skb);
+
+			if (ret == NF_ACCEPT)
+				ct = (struct nf_conn *)skb_nfct(skb);
+		}
+
 		if (likely(ret == NF_ACCEPT))
 			nf_ct_deliver_cached_events(ct);
 	}
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index e29d9e3d853e..0da52c3bcd4d 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -90,7 +90,7 @@ void bpf_inode_storage_free(struct inode *inode)
 		 */
 		bpf_selem_unlink_map(selem);
 		free_inode_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, false);
+			local_storage, selem, false, false);
 	}
 	raw_spin_unlock_bh(&local_storage->lock);
 	rcu_read_unlock();
@@ -149,7 +149,7 @@ static int inode_storage_delete(struct inode *inode, struct bpf_map *map)
 	if (!sdata)
 		return -ENOENT;
 
-	bpf_selem_unlink(SELEM(sdata));
+	bpf_selem_unlink(SELEM(sdata), true);
 
 	return 0;
 }
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 71de2a89869c..79a8edfa7a2f 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -106,7 +106,7 @@ static void bpf_selem_free_rcu(struct rcu_head *rcu)
  */
 bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 				     struct bpf_local_storage_elem *selem,
-				     bool uncharge_mem)
+				     bool uncharge_mem, bool use_trace_rcu)
 {
 	struct bpf_local_storage_map *smap;
 	bool free_local_storage;
@@ -150,11 +150,16 @@ bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 	    SDATA(selem))
 		RCU_INIT_POINTER(local_storage->cache[smap->cache_idx], NULL);
 
-	call_rcu_tasks_trace(&selem->rcu, bpf_selem_free_rcu);
+	if (use_trace_rcu)
+		call_rcu_tasks_trace(&selem->rcu, bpf_selem_free_rcu);
+	else
+		kfree_rcu(selem, rcu);
+
 	return free_local_storage;
 }
 
-static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
+static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem,
+				       bool use_trace_rcu)
 {
 	struct bpf_local_storage *local_storage;
 	bool free_local_storage = false;
@@ -169,12 +174,16 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
 	raw_spin_lock_irqsave(&local_storage->lock, flags);
 	if (likely(selem_linked_to_storage(selem)))
 		free_local_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, true);
+			local_storage, selem, true, use_trace_rcu);
 	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 
-	if (free_local_storage)
-		call_rcu_tasks_trace(&local_storage->rcu,
+	if (free_local_storage) {
+		if (use_trace_rcu)
+			call_rcu_tasks_trace(&local_storage->rcu,
 				     bpf_local_storage_free_rcu);
+		else
+			kfree_rcu(local_storage, rcu);
+	}
 }
 
 void bpf_selem_link_storage_nolock(struct bpf_local_storage *local_storage,
@@ -214,14 +223,14 @@ void bpf_selem_link_map(struct bpf_local_storage_map *smap,
 	raw_spin_unlock_irqrestore(&b->lock, flags);
 }
 
-void bpf_selem_unlink(struct bpf_local_storage_elem *selem)
+void bpf_selem_unlink(struct bpf_local_storage_elem *selem, bool use_trace_rcu)
 {
 	/* Always unlink from map before unlinking from local_storage
 	 * because selem will be freed after successfully unlinked from
 	 * the local_storage.
 	 */
 	bpf_selem_unlink_map(selem);
-	__bpf_selem_unlink_storage(selem);
+	__bpf_selem_unlink_storage(selem, use_trace_rcu);
 }
 
 struct bpf_local_storage_data *
@@ -454,7 +463,7 @@ bpf_local_storage_update(void *owner, struct bpf_local_storage_map *smap,
 	if (old_sdata) {
 		bpf_selem_unlink_map(SELEM(old_sdata));
 		bpf_selem_unlink_storage_nolock(local_storage, SELEM(old_sdata),
-						false);
+						false, true);
 	}
 
 unlock:
@@ -532,7 +541,7 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 				migrate_disable();
 				__this_cpu_inc(*busy_counter);
 			}
-			bpf_selem_unlink(selem);
+			bpf_selem_unlink(selem, false);
 			if (busy_counter) {
 				__this_cpu_dec(*busy_counter);
 				migrate_enable();
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index 5da7bed0f5f6..be6c533bb862 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -102,7 +102,7 @@ void bpf_task_storage_free(struct task_struct *task)
 		 */
 		bpf_selem_unlink_map(selem);
 		free_task_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, false);
+			local_storage, selem, false, false);
 	}
 	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 	bpf_task_storage_unlock();
@@ -191,7 +191,7 @@ static int task_storage_delete(struct task_struct *task, struct bpf_map *map)
 	if (!sdata)
 		return -ENOENT;
 
-	bpf_selem_unlink(SELEM(sdata));
+	bpf_selem_unlink(SELEM(sdata), true);
 
 	return 0;
 }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index de3e5bc6781f..64c44eed8c07 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1157,6 +1157,16 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 	insn = clone->insnsi;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
+		if (bpf_pseudo_func(insn)) {
+			/* ld_imm64 with an address of bpf subprog is not
+			 * a user controlled constant. Don't randomize it,
+			 * since it will conflict with jit_subprogs() logic.
+			 */
+			insn++;
+			i++;
+			continue;
+		}
+
 		/* We temporarily need to hold the original ld64 insn
 		 * so that we can still access the first part in the
 		 * second blinding run.
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 2823dcefae10..354d066ce695 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -100,7 +100,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
 	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5e7edf913060..e854ebd0aa65 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -423,7 +423,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
-	int cnt;
+	int cnt = 0, i;
 
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
@@ -434,7 +434,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		err = -EBUSY;
 		goto out;
 	}
-	cnt = tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT];
+
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		cnt += tr->progs_cnt[i];
+
 	if (kind == BPF_TRAMP_REPLACE) {
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt) {
@@ -512,16 +515,19 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
 
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
+	int i;
+
 	if (!tr)
 		return;
 	mutex_lock(&trampoline_mutex);
 	if (!refcount_dec_and_test(&tr->refcnt))
 		goto out;
 	WARN_ON_ONCE(mutex_is_locked(&tr->mutex));
-	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
-		goto out;
-	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
-		goto out;
+
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[i])))
+			goto out;
+
 	/* This code will be executed even when the last bpf_tramp_image
 	 * is alive. All progs are detached from the trampoline and the
 	 * trampoline image is patched with jmp into epilogue to skip
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a39eedecc93a..1d93e90b4e09 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4832,6 +4832,11 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 		return check_packet_access(env, regno, reg->off, access_size,
 					   zero_size_allowed);
 	case PTR_TO_MAP_KEY:
+		if (meta && meta->raw_mode) {
+			verbose(env, "R%d cannot write into %s\n", regno,
+				reg_type_str(env, reg->type));
+			return -EACCES;
+		}
 		return check_mem_region_access(env, regno, reg->off, access_size,
 					       reg->map_ptr->key_size, false);
 	case PTR_TO_MAP_VALUE:
@@ -4842,13 +4847,23 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 		return check_map_access(env, regno, reg->off, access_size,
 					zero_size_allowed);
 	case PTR_TO_MEM:
+		if (type_is_rdonly_mem(reg->type)) {
+			if (meta && meta->raw_mode) {
+				verbose(env, "R%d cannot write into %s\n", regno,
+					reg_type_str(env, reg->type));
+				return -EACCES;
+			}
+		}
 		return check_mem_region_access(env, regno, reg->off,
 					       access_size, reg->mem_size,
 					       zero_size_allowed);
 	case PTR_TO_BUF:
 		if (type_is_rdonly_mem(reg->type)) {
-			if (meta && meta->raw_mode)
+			if (meta && meta->raw_mode) {
+				verbose(env, "R%d cannot write into %s\n", regno,
+					reg_type_str(env, reg->type));
 				return -EACCES;
+			}
 
 			buf_info = "rdonly";
 			max_access = &env->prog->aux->max_rdonly_access;
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 079c72e26493..ca0b4f360c1a 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1461,6 +1461,7 @@ int assoc_array_gc(struct assoc_array *array,
 	struct assoc_array_ptr *cursor, *ptr;
 	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
 	unsigned long nr_leaves_on_tree;
+	bool retained;
 	int keylen, slot, nr_free, next_slot, i;
 
 	pr_devel("-->%s()\n", __func__);
@@ -1536,6 +1537,7 @@ int assoc_array_gc(struct assoc_array *array,
 		goto descend;
 	}
 
+retry_compress:
 	pr_devel("-- compress node %p --\n", new_n);
 
 	/* Count up the number of empty slots in this node and work out the
@@ -1553,6 +1555,7 @@ int assoc_array_gc(struct assoc_array *array,
 	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
 
 	/* See what we can fold in */
+	retained = false;
 	next_slot = 0;
 	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		struct assoc_array_shortcut *s;
@@ -1602,9 +1605,14 @@ int assoc_array_gc(struct assoc_array *array,
 			pr_devel("[%d] retain node %lu/%d [nx %d]\n",
 				 slot, child->nr_leaves_on_branch, nr_free + 1,
 				 next_slot);
+			retained = true;
 		}
 	}
 
+	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
+		pr_devel("internal nodes remain despite enough space, retrying\n");
+		goto retry_compress;
+	}
 	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
 
 	nr_leaves_on_tree = new_n->nr_leaves_on_branch;
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index af9302141bcf..e5c5315da274 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -76,6 +76,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 	data = kzalloc(sizeof(*ref->data), gfp);
 	if (!data) {
 		free_percpu((void __percpu *)ref->percpu_count_ptr);
+		ref->percpu_count_ptr = 0;
 		return -ENOMEM;
 	}
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 9152fbde33b5..5d5fc04385b8 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1718,11 +1718,40 @@ static enum fullness_group putback_zspage(struct size_class *class,
  */
 static void lock_zspage(struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct page *curr_page, *page;
 
-	do {
-		lock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+	/*
+	 * Pages we haven't locked yet can be migrated off the list while we're
+	 * trying to lock them, so we need to be careful and only attempt to
+	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
+	 * may no longer belong to the zspage. This means that we may wait for
+	 * the wrong page to unlock, so we must take a reference to the page
+	 * prior to waiting for it to unlock outside migrate_read_lock().
+	 */
+	while (1) {
+		migrate_read_lock(zspage);
+		page = get_first_page(zspage);
+		if (trylock_page(page))
+			break;
+		get_page(page);
+		migrate_read_unlock(zspage);
+		wait_on_page_locked(page);
+		put_page(page);
+	}
+
+	curr_page = page;
+	while ((page = get_next_page(curr_page))) {
+		if (trylock_page(page)) {
+			curr_page = page;
+		} else {
+			get_page(page);
+			migrate_read_unlock(zspage);
+			wait_on_page_locked(page);
+			put_page(page);
+			migrate_read_lock(zspage);
+		}
+	}
+	migrate_read_unlock(zspage);
 }
 
 static int zs_init_fs_context(struct fs_context *fc)
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index d9c37fd10809..4fc5bf519ba5 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -40,7 +40,7 @@ static int bpf_sk_storage_del(struct sock *sk, struct bpf_map *map)
 	if (!sdata)
 		return -ENOENT;
 
-	bpf_selem_unlink(SELEM(sdata));
+	bpf_selem_unlink(SELEM(sdata), true);
 
 	return 0;
 }
@@ -75,8 +75,8 @@ void bpf_sk_storage_free(struct sock *sk)
 		 * sk_storage.
 		 */
 		bpf_selem_unlink_map(selem);
-		free_sk_storage = bpf_selem_unlink_storage_nolock(sk_storage,
-								  selem, true);
+		free_sk_storage = bpf_selem_unlink_storage_nolock(
+			sk_storage, selem, true, false);
 	}
 	raw_spin_unlock_bh(&sk_storage->lock);
 	rcu_read_unlock();
diff --git a/net/core/filter.c b/net/core/filter.c
index af0bafe9dcce..f8fbb5fa74f3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1687,7 +1687,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 
 	if (unlikely(flags & ~(BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH)))
 		return -EINVAL;
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
@@ -1722,7 +1722,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 {
 	void *ptr;
 
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		goto err_clear;
 
 	ptr = skb_header_pointer(skb, offset, len, to);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 92e9d75dba2f..339d95df19d3 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2900,7 +2900,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2918,7 +2918,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2929,7 +2929,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 30d29d038d09..42cc703a68e5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -222,12 +222,18 @@ static int nft_netdev_register_hooks(struct net *net,
 }
 
 static void nft_netdev_unregister_hooks(struct net *net,
-					struct list_head *hook_list)
+					struct list_head *hook_list,
+					bool release_netdev)
 {
-	struct nft_hook *hook;
+	struct nft_hook *hook, *next;
 
-	list_for_each_entry(hook, hook_list, list)
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		if (release_netdev) {
+			list_del(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
+	}
 }
 
 static int nf_tables_register_hook(struct net *net,
@@ -253,9 +259,10 @@ static int nf_tables_register_hook(struct net *net,
 	return nf_register_net_hook(net, &basechain->ops);
 }
 
-static void nf_tables_unregister_hook(struct net *net,
-				      const struct nft_table *table,
-				      struct nft_chain *chain)
+static void __nf_tables_unregister_hook(struct net *net,
+					const struct nft_table *table,
+					struct nft_chain *chain,
+					bool release_netdev)
 {
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
@@ -270,11 +277,19 @@ static void nf_tables_unregister_hook(struct net *net,
 		return basechain->type->ops_unregister(net, ops);
 
 	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
-		nft_netdev_unregister_hooks(net, &basechain->hook_list);
+		nft_netdev_unregister_hooks(net, &basechain->hook_list,
+					    release_netdev);
 	else
 		nf_unregister_net_hook(net, &basechain->ops);
 }
 
+static void nf_tables_unregister_hook(struct net *net,
+				      const struct nft_table *table,
+				      struct nft_chain *chain)
+{
+	return __nf_tables_unregister_hook(net, table, chain, false);
+}
+
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -2794,27 +2809,31 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
 	err = nf_tables_expr_parse(ctx, nla, &expr_info);
 	if (err < 0)
-		goto err1;
+		goto err_expr_parse;
+
+	err = -EOPNOTSUPP;
+	if (!(expr_info.ops->type->flags & NFT_EXPR_STATEFUL))
+		goto err_expr_stateful;
 
 	err = -ENOMEM;
 	expr = kzalloc(expr_info.ops->size, GFP_KERNEL);
 	if (expr == NULL)
-		goto err2;
+		goto err_expr_stateful;
 
 	err = nf_tables_newexpr(ctx, &expr_info, expr);
 	if (err < 0)
-		goto err3;
+		goto err_expr_new;
 
 	return expr;
-err3:
+err_expr_new:
 	kfree(expr);
-err2:
+err_expr_stateful:
 	owner = expr_info.ops->type->owner;
 	if (expr_info.ops->type->release_ops)
 		expr_info.ops->type->release_ops(expr_info.ops);
 
 	module_put(owner);
-err1:
+err_expr_parse:
 	return ERR_PTR(err);
 }
 
@@ -4163,6 +4182,9 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 	u32 len;
 	int err;
 
+	if (desc->field_count >= ARRAY_SIZE(desc->field_len))
+		return -E2BIG;
+
 	err = nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
 					  nft_concat_policy, NULL);
 	if (err < 0)
@@ -4172,9 +4194,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 		return -EINVAL;
 
 	len = ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
-
-	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
-		return -E2BIG;
+	if (!len || len > U8_MAX)
+		return -EINVAL;
 
 	desc->field_len[desc->field_count++] = len;
 
@@ -4185,7 +4206,8 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
 	struct nlattr *attr;
-	int rem, err;
+	u32 num_regs = 0;
+	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
 		if (nla_type(attr) != NFTA_LIST_ELEM)
@@ -4196,6 +4218,12 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 			return err;
 	}
 
+	for (i = 0; i < desc->field_count; i++)
+		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
+
+	if (num_regs > NFT_REG32_COUNT)
+		return -E2BIG;
+
 	return 0;
 }
 
@@ -5334,9 +5362,6 @@ struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
 		return expr;
 
 	err = -EOPNOTSUPP;
-	if (!(expr->ops->type->flags & NFT_EXPR_STATEFUL))
-		goto err_set_elem_expr;
-
 	if (expr->ops->type->flags & NFT_EXPR_GC) {
 		if (set->flags & NFT_SET_TIMEOUT)
 			goto err_set_elem_expr;
@@ -7212,13 +7237,25 @@ static void nft_unregister_flowtable_hook(struct net *net,
 				    FLOW_BLOCK_UNBIND);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct list_head *hook_list)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct list_head *hook_list,
+					         bool release_netdev)
 {
-	struct nft_hook *hook;
+	struct nft_hook *hook, *next;
 
-	list_for_each_entry(hook, hook_list, list)
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		if (release_netdev) {
+			list_del(&hook->list);
+			kfree_rcu(hook);
+		}
+	}
+}
+
+static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct list_head *hook_list)
+{
+	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -9662,9 +9699,10 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
-		nf_tables_unregister_hook(net, table, chain);
+		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list);
+		__nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list,
+						     true);
 }
 
 static void __nft_release_hooks(struct net *net)
@@ -9803,7 +9841,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
 {
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	mutex_lock(&nft_net->commit_mutex);
 	__nft_release_hooks(net);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static void __net_exit nf_tables_exit_net(struct net *net)
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index a726b623963d..05a17dc1febb 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -213,6 +213,8 @@ static int nft_limit_pkts_clone(struct nft_expr *dst, const struct nft_expr *src
 	struct nft_limit_priv_pkts *priv_dst = nft_expr_priv(dst);
 	struct nft_limit_priv_pkts *priv_src = nft_expr_priv(src);
 
+	priv_dst->cost = priv_src->cost;
+
 	return nft_limit_clone(&priv_dst->limit, &priv_src->limit);
 }
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e38acdbe1a3b..53d1586b71ec 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6773,6 +6773,41 @@ static void alc256_fixup_mic_no_presence_and_resume(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_dell4_mic_no_presence_quiet(struct hda_codec *codec,
+						  const struct hda_fixup *fix,
+						  int action)
+{
+	struct alc_spec *spec = codec->spec;
+	struct hda_input_mux *imux = &spec->gen.input_mux;
+	int i;
+
+	alc269_fixup_limit_int_mic_boost(codec, fix, action);
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		/**
+		 * Set the vref of pin 0x19 (Headset Mic) and pin 0x1b (Headphone Mic)
+		 * to Hi-Z to avoid pop noises at startup and when plugging and
+		 * unplugging headphones.
+		 */
+		snd_hda_codec_set_pin_target(codec, 0x19, PIN_VREFHIZ);
+		snd_hda_codec_set_pin_target(codec, 0x1b, PIN_VREFHIZ);
+		break;
+	case HDA_FIXUP_ACT_PROBE:
+		/**
+		 * Make the internal mic (0x12) the default input source to
+		 * prevent pop noises on cold boot.
+		 */
+		for (i = 0; i < imux->num_items; i++) {
+			if (spec->gen.imux_pins[i] == 0x12) {
+				spec->gen.cur_mux[0] = i;
+				break;
+			}
+		}
+		break;
+	}
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -6814,6 +6849,7 @@ enum {
 	ALC269_FIXUP_DELL2_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL3_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET,
 	ALC269_FIXUP_HEADSET_MODE,
 	ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC,
 	ALC269_FIXUP_ASPIRE_HEADSET_MIC,
@@ -7000,6 +7036,7 @@ enum {
 	ALC287_FIXUP_LEGION_16ACHG6,
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
+	ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8770,6 +8807,21 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
 	},
+	[ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_dell4_mic_no_presence_quiet,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	},
+	[ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x02a1112c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8860,6 +8912,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a38, "Dell Latitude 7520", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET),
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a62, "Dell Precision 5560", ALC289_FIXUP_DUAL_SPK),
@@ -9249,6 +9302,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
+	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 4dfe76416794..33db334e6556 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -572,6 +572,17 @@ static int set_sample_rate_v2v3(struct snd_usb_audio *chip,
 		/* continue processing */
 	}
 
+	/* FIXME - TEAC devices require the immediate interface setup */
+	if (USB_ID_VENDOR(chip->usb_id) == 0x0644) {
+		bool cur_base_48k = (rate % 48000 == 0);
+		bool prev_base_48k = (prev_rate % 48000 == 0);
+		if (cur_base_48k != prev_base_48k) {
+			usb_set_interface(chip->dev, fmt->iface, fmt->altsetting);
+			if (chip->quirk_flags & QUIRK_FLAG_IFACE_DELAY)
+				msleep(50);
+		}
+	}
+
 validation:
 	/* validate clock after rate change */
 	if (!uac_clock_source_is_valid(chip, fmt, clock))
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 6d699065e81a..b470404a5376 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -439,16 +439,21 @@ static int configure_endpoints(struct snd_usb_audio *chip,
 		/* stop any running stream beforehand */
 		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
+		if (subs->sync_endpoint) {
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			if (err < 0)
+				return err;
+		}
 		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
 		if (err < 0)
 			return err;
 		snd_usb_set_format_quirk(subs, subs->cur_audiofmt);
-	}
-
-	if (subs->sync_endpoint) {
-		err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
-		if (err < 0)
-			return err;
+	} else {
+		if (subs->sync_endpoint) {
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			if (err < 0)
+				return err;
+		}
 	}
 
 	return 0;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 40a5e3eb4ef2..78eb41b621d6 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2672,6 +2672,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.altset_idx = 1,
 					.attributes = 0,
 					.endpoint = 0x82,
+					.ep_idx = 1,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC,
 					.datainterval = 1,
 					.maxpacksize = 0x0126,
@@ -2875,6 +2876,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.altset_idx = 1,
 					.attributes = 0x4,
 					.endpoint = 0x81,
+					.ep_idx = 1,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						USB_ENDPOINT_SYNC_ASYNC,
 					.maxpacksize = 0x130,
@@ -3391,6 +3393,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.altset_idx = 1,
 					.attributes = 0,
 					.endpoint = 0x03,
+					.ep_idx = 1,
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index ab9f3da49941..fbbe59054c3f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1822,6 +1822,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x0711, 0x5800, /* MCT Trigger 5 USB-to-HDMI */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x074d, 0x3553, /* Outlaw RR2150 (Micronas UAC3553B) */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
diff --git a/tools/memory-model/README b/tools/memory-model/README
index 9edd402704c4..dab38904206a 100644
--- a/tools/memory-model/README
+++ b/tools/memory-model/README
@@ -54,7 +54,8 @@ klitmus7 Compatibility Table
 	     -- 4.14  7.48 --
 	4.15 -- 4.19  7.49 --
 	4.20 -- 5.5   7.54 --
-	5.6  --       7.56 --
+	5.6  -- 5.16  7.56 --
+	5.17 --       7.56.1 --
 	============  ==========
 
 
