Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5595453E3B9
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiFFHFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiFFHFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:05:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D7F2EA0F;
        Mon,  6 Jun 2022 00:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82C436113B;
        Mon,  6 Jun 2022 07:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C79C385A9;
        Mon,  6 Jun 2022 07:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499100;
        bh=Eu9FR5zQjipq/dx0Nm5lYPKviZqZZDV8P1dbznL67+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHbut5yl2XiDm+OlaCiHNbvszGcwlmIlouv9Dk1OpiaY2Zj1+it1YGzcUm6eo7oTb
         FEiDTdkYvhazdIe983JSbBCJNYLuXPRF0Ok8aCXe7QEEo7mtpfqETYy04otxPtLEJG
         JLs6A+qwTRf9uuvnsfz58p4tAqhVZ95gbXoqkDnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.45
Date:   Mon,  6 Jun 2022 09:04:50 +0200
Message-Id: <165449908911438@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16544990891688@kroah.com>
References: <16544990891688@kroah.com>
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
index 8ad6b93f91e6..025272139539 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -72,7 +72,7 @@ as you intend it to.
 
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
-system, ``git``, as a "commit log".  See :ref:`explicit_in_reply_to`.
+system, ``git``, as a "commit log".  See :ref:`the_canonical_patch_format`.
 
 Solve only one problem per patch.  If your description starts to get
 long, that's a sign that you probably need to split up your patch.
diff --git a/Makefile b/Makefile
index b8ce2ba17486..e58d682071a8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 44
+SUBLEVEL = 45
 EXTRAVERSION =
 NAME = Trick or Treat
 
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
index 0b2f684cd8ca..a30c036577a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1458,7 +1458,8 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (kvm_system_needs_idmapped_vectors() && !has_vhe()) {
+	if (kvm_system_needs_idmapped_vectors() &&
+	    !is_protected_kvm_enabled()) {
 		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
 					       __BP_HARDEN_HYP_VECS_SZ, &base);
 		if (err)
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index a7061ee3b157..3fbe710ff839 100644
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
index 8471a8b9b48e..00e09a2b933a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -170,6 +170,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
 			  backing->pcmd_offset;
 
 	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
+	set_page_dirty(backing->pcmd);
+	set_page_dirty(backing->contents);
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
 					      backing->pcmd_offset));
@@ -287,6 +289,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
+	sgx_encl_put_backing(backing);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
 		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -299,7 +302,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
-		sgx_encl_put_backing(&secs_backing, true);
+		sgx_encl_put_backing(&secs_backing);
 	}
 
 out:
@@ -360,11 +363,14 @@ static void sgx_reclaim_pages(void)
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
@@ -392,7 +398,6 @@ static void sgx_reclaim_pages(void)
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i], true);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d36b58e705b6..9e3af56747e8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -188,7 +188,7 @@ void kvm_async_pf_task_wake(u32 token)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node *n;
+	struct kvm_task_sleep_node *n, *dummy = NULL;
 
 	if (token == ~0) {
 		apf_task_wake_all();
@@ -200,28 +200,41 @@ void kvm_async_pf_task_wake(u32 token)
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
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 556e7a3f3562..993daa6fb128 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -750,9 +750,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct kvm_host_map map;
 	int rc;
 
-	/* Triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8c321225061..4a4dc105552e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -676,7 +676,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -796,7 +796,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
@@ -1082,7 +1082,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -1164,7 +1164,7 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	/* allocate the memory to hold the session data blob */
-	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
+	session_data = kzalloc(params.session_len, GFP_KERNEL_ACCOUNT);
 	if (!session_data)
 		return -ENOMEM;
 
@@ -1288,11 +1288,11 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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
index 1546a10ecb56..5eae69c8123b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4501,9 +4501,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-	/* Similarly, triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75da9c0d5ae3..23905ba3058a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7846,7 +7846,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
-static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
+static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu, int *r)
 {
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
@@ -7915,25 +7915,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
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
@@ -7966,6 +7964,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 55718de56137..a346b6f74bb3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1924,5 +1924,3 @@ source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
 
 endif	# if CRYPTO
-
-source "lib/crypto/Kconfig"
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 03c9ef768c22..761104e93d44 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1036,17 +1036,38 @@ static const struct drbg_state_ops drbg_hash_ops = {
  ******************************************************************/
 
 static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
-			      int reseed)
+			      int reseed, enum drbg_seed_state new_seed_state)
 {
 	int ret = drbg->d_ops->update(drbg, seed, reseed);
 
 	if (ret)
 		return ret;
 
-	drbg->seeded = true;
+	drbg->seeded = new_seed_state;
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
+	switch (drbg->seeded) {
+	case DRBG_SEED_STATE_UNSEEDED:
+		/* Impossible, but handle it to silence compiler warnings. */
+		fallthrough;
+	case DRBG_SEED_STATE_PARTIAL:
+		/*
+		 * Require frequent reseeds until the seed source is
+		 * fully initialized.
+		 */
+		drbg->reseed_threshold = 50;
+		break;
+
+	case DRBG_SEED_STATE_FULL:
+		/*
+		 * Seed source has become fully initialized, frequent
+		 * reseeds no longer required.
+		 */
+		drbg->reseed_threshold = drbg_max_requests(drbg);
+		break;
+	}
+
 	return ret;
 }
 
@@ -1066,12 +1087,10 @@ static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 	return 0;
 }
 
-static void drbg_async_seed(struct work_struct *work)
+static int drbg_seed_from_random(struct drbg_state *drbg)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
-	struct drbg_state *drbg = container_of(work, struct drbg_state,
-					       seed_work);
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	unsigned char entropy[32];
 	int ret;
@@ -1082,26 +1101,15 @@ static void drbg_async_seed(struct work_struct *work)
 	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
 
-	mutex_lock(&drbg->drbg_mutex);
-
 	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
 	if (ret)
-		goto unlock;
-
-	/* Set seeded to false so that if __drbg_seed fails the
-	 * next generate call will trigger a reseed.
-	 */
-	drbg->seeded = false;
-
-	__drbg_seed(drbg, &seedlist, true);
-
-	if (drbg->seeded)
-		drbg->reseed_threshold = drbg_max_requests(drbg);
+		goto out;
 
-unlock:
-	mutex_unlock(&drbg->drbg_mutex);
+	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
+out:
 	memzero_explicit(entropy, entropylen);
+	return ret;
 }
 
 /*
@@ -1123,6 +1131,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	struct drbg_string data1;
 	LIST_HEAD(seedlist);
+	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
@@ -1150,6 +1159,9 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
+		if (!rng_is_initialized())
+			new_seed_state = DRBG_SEED_STATE_PARTIAL;
+
 		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
 		if (ret)
 			goto out;
@@ -1206,7 +1218,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		memset(drbg->C, 0, drbg_statelen(drbg));
 	}
 
-	ret = __drbg_seed(drbg, &seedlist, reseed);
+	ret = __drbg_seed(drbg, &seedlist, reseed, new_seed_state);
 
 out:
 	memzero_explicit(entropy, entropylen * 2);
@@ -1386,19 +1398,25 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * here. The spec is a bit convoluted here, we make it simpler.
 	 */
 	if (drbg->reseed_threshold < drbg->reseed_ctr)
-		drbg->seeded = false;
+		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 
-	if (drbg->pr || !drbg->seeded) {
+	if (drbg->pr || drbg->seeded == DRBG_SEED_STATE_UNSEEDED) {
 		pr_devel("DRBG: reseeding before generation (prediction "
 			 "resistance: %s, state %s)\n",
 			 drbg->pr ? "true" : "false",
-			 drbg->seeded ? "seeded" : "unseeded");
+			 (drbg->seeded ==  DRBG_SEED_STATE_FULL ?
+			  "seeded" : "unseeded"));
 		/* 9.3.1 steps 7.1 through 7.3 */
 		len = drbg_seed(drbg, addtl, true);
 		if (len)
 			goto err;
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
+	} else if (rng_is_initialized() &&
+		   drbg->seeded == DRBG_SEED_STATE_PARTIAL) {
+		len = drbg_seed_from_random(drbg);
+		if (len)
+			goto err;
 	}
 
 	if (addtl && 0 < addtl->len)
@@ -1491,50 +1509,15 @@ static int drbg_generate_long(struct drbg_state *drbg,
 	return 0;
 }
 
-static int drbg_schedule_async_seed(struct notifier_block *nb, unsigned long action, void *data)
-{
-	struct drbg_state *drbg = container_of(nb, struct drbg_state,
-					       random_ready);
-
-	schedule_work(&drbg->seed_work);
-	return 0;
-}
-
 static int drbg_prepare_hrng(struct drbg_state *drbg)
 {
-	int err;
-
 	/* We do not need an HRNG in test mode. */
 	if (list_empty(&drbg->test_data.list))
 		return 0;
 
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 
-	INIT_WORK(&drbg->seed_work, drbg_async_seed);
-
-	drbg->random_ready.notifier_call = drbg_schedule_async_seed;
-	err = register_random_ready_notifier(&drbg->random_ready);
-
-	switch (err) {
-	case 0:
-		break;
-
-	case -EALREADY:
-		err = 0;
-		fallthrough;
-
-	default:
-		drbg->random_ready.notifier_call = NULL;
-		return err;
-	}
-
-	/*
-	 * Require frequent reseeds until the seed source is fully
-	 * initialized.
-	 */
-	drbg->reseed_threshold = 50;
-
-	return err;
+	return 0;
 }
 
 /*
@@ -1577,7 +1560,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	if (!drbg->core) {
 		drbg->core = &drbg_cores[coreref];
 		drbg->pr = pr;
-		drbg->seeded = false;
+		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
 		ret = drbg_alloc_state(drbg);
@@ -1628,11 +1611,6 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	if (drbg->random_ready.notifier_call) {
-		unregister_random_ready_notifier(&drbg->random_ready);
-		cancel_work_sync(&drbg->seed_work);
-	}
-
 	if (!IS_ERR_OR_NULL(drbg->jent))
 		crypto_free_rng(drbg->jent);
 	drbg->jent = NULL;
diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index 6a3fd09057d0..f7ed43020672 100644
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
index 8eb7fddfb930..ed91af4319b5 100644
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
diff --git a/drivers/char/random.c b/drivers/char/random.c
index ca17a658c214..e2f1fce8dc97 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -163,7 +163,6 @@ int __cold register_random_ready_notifier(struct notifier_block *nb)
 	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(register_random_ready_notifier);
 
 /*
  * Delete a previously registered readiness callback function.
@@ -178,7 +177,6 @@ int __cold unregister_random_ready_notifier(struct notifier_block *nb)
 	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(unregister_random_ready_notifier);
 
 static void __cold process_random_ready_list(void)
 {
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index a25815a6f625..de92065394be 100644
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
index 57c1dda76b94..1a27e4833adf 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2863,7 +2863,7 @@ static void ilk_compute_wm_level(const struct drm_i915_private *dev_priv,
 }
 
 static void intel_read_wm_latency(struct drm_i915_private *dev_priv,
-				  u16 wm[8])
+				  u16 wm[])
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 645a5f566d23..42b5b050b72d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -753,6 +753,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
+#define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e1afddb7b33d..f382444dc2db 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2032,6 +2032,12 @@ static const struct hid_device_id mt_devices[] = {
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
@@ -2176,6 +2182,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_GOOGLE,
 		HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY, USB_VENDOR_ID_GOOGLE,
 			USB_DEVICE_ID_GOOGLE_TOUCH_ROSE) },
+	{ .driver_data = MT_CLS_GOOGLE,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8, USB_VENDOR_ID_GOOGLE,
+			USB_DEVICE_ID_GOOGLE_WHISKERS) },
 
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index a6187cbec2c9..483428c5e30b 100644
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
index 154139bf7d22..f30fd38c3773 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3435,6 +3435,11 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
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
@@ -3453,9 +3458,12 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
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
index e2a51c184a25..d5b827086962 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4478,8 +4478,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
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
index 88288c8d6bc8..426299ceb33d 100644
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
index b9d062f0a02b..e54d802ee0bb 100644
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
index e1df2dc810a2..0b833572205f 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1910,6 +1910,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
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
index 87e42db1b61e..477eb4051bed 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -722,13 +722,15 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
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
index d32aec0c334f..6dc0af63440f 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2789,13 +2789,14 @@ void pn53x_common_clean(struct pn533 *priv)
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
index cc5cffc4a769..e2113e0a848c 100644
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
index 1d6da61157c9..9f82a8a835ee 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -381,6 +381,14 @@ static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		EXFAT_RESERVED_CLUSTERS;
 }
 
+static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
+		unsigned int clus)
+{
+	if (clus < EXFAT_FIRST_CLUSTER || sbi->num_clusters <= clus)
+		return false;
+	return true;
+}
+
 /* super.c */
 int exfat_set_volume_dirty(struct super_block *sb);
 int exfat_clear_volume_dirty(struct super_block *sb);
diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index e949e563443c..421c27353104 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -81,14 +81,6 @@ int exfat_ent_set(struct super_block *sb, unsigned int loc,
 	return 0;
 }
 
-static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
-		unsigned int clus)
-{
-	if (clus < EXFAT_FIRST_CLUSTER || sbi->num_clusters <= clus)
-		return false;
-	return true;
-}
-
 int exfat_ent_get(struct super_block *sb, unsigned int loc,
 		unsigned int *content)
 {
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index c8845242d422..fbfe293af72c 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -834,6 +834,7 @@ static inline bool nfs_error_is_fatal_on_server(int err)
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
+	case -ENOMEM:
 		return false;
 	}
 	return nfs_error_is_fatal(err);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 181bc3d9f566..f9e2fa9cfbec 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7299,16 +7299,12 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
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
index d41d76979e12..7f85ec83e196 100644
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
index 751d5b36c84b..e08f0fe55584 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -652,7 +652,7 @@ pipe_poll(struct file *filp, poll_table *wait)
 	unsigned int head, tail;
 
 	/* Epoll has some historical nasty semantics, this enables them */
-	pipe->poll_usage = 1;
+	WRITE_ONCE(pipe->poll_usage, true);
 
 	/*
 	 * Reading pipe state only -- no need for acquiring the semaphore.
@@ -1244,30 +1244,33 @@ unsigned int round_pipe_size(unsigned long size)
 
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
@@ -1299,6 +1302,8 @@ int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 	pipe->tail = tail;
 	pipe->head = head;
 
+	spin_unlock_irq(&pipe->rd_wait.lock);
+
 	/* This might have made more room for writers */
 	wake_up_interruptible(&pipe->wr_wait);
 	return 0;
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 88e4d145f7cd..a6c3b8e7deb6 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -105,6 +105,12 @@ struct drbg_test_data {
 	struct drbg_string *testentropy; /* TEST PARAMETER: test entropy */
 };
 
+enum drbg_seed_state {
+	DRBG_SEED_STATE_UNSEEDED,
+	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
+	DRBG_SEED_STATE_FULL,
+};
+
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	unsigned char *V;	/* internal state 10.1.1.1 1a) */
@@ -127,16 +133,14 @@ struct drbg_state {
 	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
 	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
 
-	bool seeded;		/* DRBG fully seeded? */
+	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
-	struct work_struct seed_work;	/* asynchronous seeding support */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
-	struct notifier_block random_ready;
 };
 
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index fc5642431b92..c0b6ec6bf65b 100644
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
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index fc0f77f91224..7efae3af6201 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -119,7 +119,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
 	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 2660fbced9ad..4fa75791b45e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -414,7 +414,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
-	int cnt;
+	int cnt = 0, i;
 
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
@@ -425,7 +425,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
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
@@ -503,16 +506,19 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
 
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
index d2b119b4fbe7..25ee8d9572c6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4587,6 +4587,11 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
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
@@ -4597,13 +4602,23 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
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
diff --git a/lib/Kconfig b/lib/Kconfig
index fa4b10322efc..e052f843afed 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -121,6 +121,8 @@ config INDIRECT_IOMEM_FALLBACK
 	  mmio accesses when the IO memory address is not a registered
 	  emulated region.
 
+source "lib/crypto/Kconfig"
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 04c98799c3ba..70304b8f15ac 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1462,6 +1462,7 @@ int assoc_array_gc(struct assoc_array *array,
 	struct assoc_array_ptr *cursor, *ptr;
 	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
 	unsigned long nr_leaves_on_tree;
+	bool retained;
 	int keylen, slot, nr_free, next_slot, i;
 
 	pr_devel("-->%s()\n", __func__);
@@ -1538,6 +1539,7 @@ int assoc_array_gc(struct assoc_array *array,
 		goto descend;
 	}
 
+retry_compress:
 	pr_devel("-- compress node %p --\n", new_n);
 
 	/* Count up the number of empty slots in this node and work out the
@@ -1555,6 +1557,7 @@ int assoc_array_gc(struct assoc_array *array,
 	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
 
 	/* See what we can fold in */
+	retained = false;
 	next_slot = 0;
 	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		struct assoc_array_shortcut *s;
@@ -1604,9 +1607,14 @@ int assoc_array_gc(struct assoc_array *array,
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
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 8620f38e117c..e8e525650cf2 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+menu "Crypto library routines"
+
 config CRYPTO_LIB_AES
 	tristate
 
@@ -31,7 +33,7 @@ config CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
-	select CRYPTO_ALGAPI
+	select XOR_BLOCKS
 	help
 	  This symbol can be depended upon by arch implementations of the
 	  ChaCha library interface that require the generic code as a
@@ -40,7 +42,8 @@ config CRYPTO_LIB_CHACHA_GENERIC
 	  of CRYPTO_LIB_CHACHA.
 
 config CRYPTO_LIB_CHACHA
-	tristate
+	tristate "ChaCha library interface"
+	depends on CRYPTO
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
@@ -65,7 +68,7 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 	  of CRYPTO_LIB_CURVE25519.
 
 config CRYPTO_LIB_CURVE25519
-	tristate
+	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	help
@@ -100,7 +103,7 @@ config CRYPTO_LIB_POLY1305_GENERIC
 	  of CRYPTO_LIB_POLY1305.
 
 config CRYPTO_LIB_POLY1305
-	tristate
+	tristate "Poly1305 library interface"
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
@@ -109,14 +112,18 @@ config CRYPTO_LIB_POLY1305
 	  is available and enabled.
 
 config CRYPTO_LIB_CHACHA20POLY1305
-	tristate
+	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
+	depends on CRYPTO
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
+	select CRYPTO_ALGAPI
 
 config CRYPTO_LIB_SHA256
 	tristate
 
 config CRYPTO_LIB_SM4
 	tristate
+
+endmenu
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
index b897ce3b399a..439deb8decbc 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1743,11 +1743,40 @@ static enum fullness_group putback_zspage(struct size_class *class,
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 821278b906b7..707e2e48d769 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1688,7 +1688,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 
 	if (unlikely(flags & ~(BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH)))
 		return -EINVAL;
-	if (unlikely(offset > 0xffff))
+	if (unlikely(offset > INT_MAX))
 		return -EFAULT;
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
@@ -1723,7 +1723,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
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
index 2feb88ffcd81..79e8fc687fdd 100644
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
@@ -2778,27 +2793,31 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
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
 
@@ -4147,6 +4166,9 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 	u32 len;
 	int err;
 
+	if (desc->field_count >= ARRAY_SIZE(desc->field_len))
+		return -E2BIG;
+
 	err = nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
 					  nft_concat_policy, NULL);
 	if (err < 0)
@@ -4156,9 +4178,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 		return -EINVAL;
 
 	len = ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
-
-	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
-		return -E2BIG;
+	if (!len || len > U8_MAX)
+		return -EINVAL;
 
 	desc->field_len[desc->field_count++] = len;
 
@@ -4169,7 +4190,8 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
 	struct nlattr *attr;
-	int rem, err;
+	u32 num_regs = 0;
+	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
 		if (nla_type(attr) != NFTA_LIST_ELEM)
@@ -4180,6 +4202,12 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
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
 
@@ -5318,9 +5346,6 @@ struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
 		return expr;
 
 	err = -EOPNOTSUPP;
-	if (!(expr->ops->type->flags & NFT_EXPR_STATEFUL))
-		goto err_set_elem_expr;
-
 	if (expr->ops->type->flags & NFT_EXPR_GC) {
 		if (set->flags & NFT_SET_TIMEOUT)
 			goto err_set_elem_expr;
@@ -7196,13 +7221,25 @@ static void nft_unregister_flowtable_hook(struct net *net,
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
@@ -9595,9 +9632,10 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
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
@@ -9736,7 +9774,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
 {
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	mutex_lock(&nft_net->commit_mutex);
 	__nft_release_hooks(net);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static void __net_exit nf_tables_exit_net(struct net *net)
diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 98345a695dcc..ccca9efa7d33 100644
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
index 729e26f5ac4c..9e65a42cc9b7 100644
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
