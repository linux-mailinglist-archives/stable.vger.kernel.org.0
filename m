Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220BE454C7E
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbhKQRxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239659AbhKQRxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 12:53:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAD2161929;
        Wed, 17 Nov 2021 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637171453;
        bh=WSAixO4jwnVJ0MrgbOTgS59o9Ax/Fdjm0r0qoIMbyco=;
        h=Subject:To:Cc:From:Date:From;
        b=hf3P/7bs8uWX77+Y74kURwU3qqUIA0E0t2LPQr/22swEkbrZwg8DNu6uh2WUOPEVQ
         ESVfGTPaq7pcJj5PEgJegLZpLTdGuseLql1OwhLAhfzpjRQuziuFctUL52tbpwe+H9
         jk4vhLAJPiEv24Jy0a+TOExUqaPJvOFuwjzuRuIk=
Subject: FAILED: patch "[PATCH] s390/kvm: support collaborative memory management" failed to apply to 4.9-stable tree
To:     konstantin.weitz@gmail.com, schwidefsky@de.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 18:50:50 +0100
Message-ID: <1637171450215128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b31288fa83b2bcc8834e1e208e9526b8bd5ce361 Mon Sep 17 00:00:00 2001
From: Konstantin Weitz <konstantin.weitz@gmail.com>
Date: Wed, 17 Apr 2013 17:36:29 +0200
Subject: [PATCH] s390/kvm: support collaborative memory management

This patch enables Collaborative Memory Management (CMM) for kvm
on s390. CMM allows the guest to inform the host about page usage
(see arch/s390/mm/cmm.c). The host uses this information to avoid
swapping in unused pages in the page fault handler. Further, a CPU
provided list of unused invalid pages is processed to reclaim swap
space of not yet accessed unused pages.

[ Martin Schwidefsky: patch reordering and cleanup ]

Signed-off-by: Konstantin Weitz <konstantin.weitz@gmail.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index eef3dd3fd9a9..9bf95bb30f1a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -106,7 +106,9 @@ struct kvm_s390_sie_block {
 	__u64	gbea;			/* 0x0180 */
 	__u8	reserved188[24];	/* 0x0188 */
 	__u32	fac;			/* 0x01a0 */
-	__u8	reserved1a4[68];	/* 0x01a4 */
+	__u8	reserved1a4[20];	/* 0x01a4 */
+	__u64	cbrlo;			/* 0x01b8 */
+	__u8	reserved1c0[40];	/* 0x01c0 */
 	__u64	itdba;			/* 0x01e8 */
 	__u8	reserved1f0[16];	/* 0x01f0 */
 } __attribute__((packed));
@@ -155,6 +157,7 @@ struct kvm_vcpu_stat {
 	u32 instruction_stsi;
 	u32 instruction_stfl;
 	u32 instruction_tprot;
+	u32 instruction_essa;
 	u32 instruction_sigp_sense;
 	u32 instruction_sigp_sense_running;
 	u32 instruction_sigp_external_call;
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index fc4bb82a0739..a7dd672c97f8 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -229,6 +229,7 @@ extern unsigned long MODULES_END;
 #define _PAGE_READ	0x010		/* SW pte read bit */
 #define _PAGE_WRITE	0x020		/* SW pte write bit */
 #define _PAGE_SPECIAL	0x040		/* SW associated with special page */
+#define _PAGE_UNUSED	0x080		/* SW bit for pgste usage state */
 #define __HAVE_ARCH_PTE_SPECIAL
 
 /* Set of bits not changed in pte_modify */
@@ -394,6 +395,12 @@ extern unsigned long MODULES_END;
 
 #endif /* CONFIG_64BIT */
 
+/* Guest Page State used for virtualization */
+#define _PGSTE_GPS_ZERO		0x0000000080000000UL
+#define _PGSTE_GPS_USAGE_MASK	0x0000000003000000UL
+#define _PGSTE_GPS_USAGE_STABLE 0x0000000000000000UL
+#define _PGSTE_GPS_USAGE_UNUSED 0x0000000001000000UL
+
 /*
  * A user page table pointer has the space-switch-event bit, the
  * private-space-control bit and the storage-alteration-event-control
@@ -617,6 +624,14 @@ static inline int pte_none(pte_t pte)
 	return pte_val(pte) == _PAGE_INVALID;
 }
 
+static inline int pte_swap(pte_t pte)
+{
+	/* Bit pattern: (pte & 0x603) == 0x402 */
+	return (pte_val(pte) & (_PAGE_INVALID | _PAGE_PROTECT |
+				_PAGE_TYPE | _PAGE_PRESENT))
+		== (_PAGE_INVALID | _PAGE_TYPE);
+}
+
 static inline int pte_file(pte_t pte)
 {
 	/* Bit pattern: (pte & 0x601) == 0x600 */
@@ -821,6 +836,7 @@ unsigned long gmap_translate(unsigned long address, struct gmap *);
 unsigned long __gmap_fault(unsigned long address, struct gmap *);
 unsigned long gmap_fault(unsigned long address, struct gmap *);
 void gmap_discard(unsigned long from, unsigned long to, struct gmap *);
+void __gmap_zap(unsigned long address, struct gmap *);
 
 void gmap_register_ipte_notifier(struct gmap_notifier *);
 void gmap_unregister_ipte_notifier(struct gmap_notifier *);
@@ -852,6 +868,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 
 	if (mm_has_pgste(mm)) {
 		pgste = pgste_get_lock(ptep);
+		pgste_val(pgste) &= ~_PGSTE_GPS_ZERO;
 		pgste_set_key(ptep, pgste, entry);
 		pgste_set_pte(ptep, entry);
 		pgste_set_unlock(ptep, pgste);
@@ -881,6 +898,12 @@ static inline int pte_young(pte_t pte)
 	return (pte_val(pte) & _PAGE_YOUNG) != 0;
 }
 
+#define __HAVE_ARCH_PTE_UNUSED
+static inline int pte_unused(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_UNUSED;
+}
+
 /*
  * pgd/pmd/pte modification functions
  */
@@ -1196,6 +1219,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	pte_val(*ptep) = _PAGE_INVALID;
 
 	if (mm_has_pgste(vma->vm_mm)) {
+		if ((pgste_val(pgste) & _PGSTE_GPS_USAGE_MASK) ==
+		    _PGSTE_GPS_USAGE_UNUSED)
+			pte_val(pte) |= _PAGE_UNUSED;
 		pgste = pgste_update_all(&pte, pgste);
 		pgste_set_unlock(ptep, pgste);
 	}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e0676f390d57..10b5db3c9bc4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -68,6 +68,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "instruction_storage_key", VCPU_STAT(instruction_storage_key) },
 	{ "instruction_stsch", VCPU_STAT(instruction_stsch) },
 	{ "instruction_chsc", VCPU_STAT(instruction_chsc) },
+	{ "instruction_essa", VCPU_STAT(instruction_essa) },
 	{ "instruction_stsi", VCPU_STAT(instruction_stsi) },
 	{ "instruction_stfl", VCPU_STAT(instruction_stfl) },
 	{ "instruction_tprot", VCPU_STAT(instruction_tprot) },
@@ -283,7 +284,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (kvm_is_ucontrol(vcpu->kvm))
 		gmap_free(vcpu->arch.gmap);
 
+	if (vcpu->arch.sie_block->cbrlo)
+		__free_page(__pfn_to_page(
+				vcpu->arch.sie_block->cbrlo >> PAGE_SHIFT));
 	free_page((unsigned long)(vcpu->arch.sie_block));
+
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
@@ -390,6 +395,8 @@ int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
+	struct page *cbrl;
+
 	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH |
 						    CPUSTAT_SM |
 						    CPUSTAT_STOPPED |
@@ -401,6 +408,14 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->ecb2  = 8;
 	vcpu->arch.sie_block->eca   = 0xC1002001U;
 	vcpu->arch.sie_block->fac   = (int) (long) vfacilities;
+	if (kvm_enabled_cmma()) {
+		cbrl = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (cbrl) {
+			vcpu->arch.sie_block->ecb2 |= 0x80;
+			vcpu->arch.sie_block->ecb2 &= ~0x08;
+			vcpu->arch.sie_block->cbrlo = page_to_phys(cbrl);
+		}
+	}
 	hrtimer_init(&vcpu->arch.ckc_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 	tasklet_init(&vcpu->arch.tasklet, kvm_s390_tasklet,
 		     (unsigned long) vcpu);
@@ -761,6 +776,16 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 	return rc;
 }
 
+bool kvm_enabled_cmma(void)
+{
+	if (!MACHINE_IS_LPAR)
+		return false;
+	/* only enable for z10 and later */
+	if (!MACHINE_HAS_EDAT1)
+		return false;
+	return true;
+}
+
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int rc, exit_reason;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f9559b0bd620..564514f410f4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -156,6 +156,8 @@ void s390_vcpu_block(struct kvm_vcpu *vcpu);
 void s390_vcpu_unblock(struct kvm_vcpu *vcpu);
 void exit_sie(struct kvm_vcpu *vcpu);
 void exit_sie_sync(struct kvm_vcpu *vcpu);
+/* are we going to support cmma? */
+bool kvm_enabled_cmma(void);
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
 
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 75beea632a10..aacb6b129914 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -636,8 +636,49 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_essa(struct kvm_vcpu *vcpu)
+{
+	/* entries expected to be 1FF */
+	int entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
+	unsigned long *cbrlo, cbrle;
+	struct gmap *gmap;
+	int i;
+
+	VCPU_EVENT(vcpu, 5, "cmma release %d pages", entries);
+	gmap = vcpu->arch.gmap;
+	vcpu->stat.instruction_essa++;
+	if (!kvm_enabled_cmma() || !vcpu->arch.sie_block->cbrlo)
+		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	if (((vcpu->arch.sie_block->ipb & 0xf0000000) >> 28) > 6)
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	/* Rewind PSW to repeat the ESSA instruction */
+	vcpu->arch.sie_block->gpsw.addr =
+		__rewind_psw(vcpu->arch.sie_block->gpsw, 4);
+	vcpu->arch.sie_block->cbrlo &= PAGE_MASK;	/* reset nceo */
+	cbrlo = phys_to_virt(vcpu->arch.sie_block->cbrlo);
+	down_read(&gmap->mm->mmap_sem);
+	for (i = 0; i < entries; ++i) {
+		cbrle = cbrlo[i];
+		if (unlikely(cbrle & ~PAGE_MASK || cbrle < 2 * PAGE_SIZE))
+			/* invalid entry */
+			break;
+		/* try to free backing */
+		__gmap_zap(cbrle, gmap);
+	}
+	up_read(&gmap->mm->mmap_sem);
+	if (i < entries)
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	return 0;
+}
+
 static const intercept_handler_t b9_handlers[256] = {
 	[0x8d] = handle_epsw,
+	[0xab] = handle_essa,
 	[0xaf] = handle_pfmf,
 };
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 3584ed9b20a1..9e2b4705dea2 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -17,6 +17,7 @@
 #include <linux/quicklist.h>
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
+#include <linux/swapops.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -594,6 +595,82 @@ unsigned long gmap_fault(unsigned long address, struct gmap *gmap)
 }
 EXPORT_SYMBOL_GPL(gmap_fault);
 
+static void gmap_zap_swap_entry(swp_entry_t entry, struct mm_struct *mm)
+{
+	if (!non_swap_entry(entry))
+		dec_mm_counter(mm, MM_SWAPENTS);
+	else if (is_migration_entry(entry)) {
+		struct page *page = migration_entry_to_page(entry);
+
+		if (PageAnon(page))
+			dec_mm_counter(mm, MM_ANONPAGES);
+		else
+			dec_mm_counter(mm, MM_FILEPAGES);
+	}
+	free_swap_and_cache(entry);
+}
+
+/**
+ * The mm->mmap_sem lock must be held
+ */
+static void gmap_zap_unused(struct mm_struct *mm, unsigned long address)
+{
+	unsigned long ptev, pgstev;
+	spinlock_t *ptl;
+	pgste_t pgste;
+	pte_t *ptep, pte;
+
+	ptep = get_locked_pte(mm, address, &ptl);
+	if (unlikely(!ptep))
+		return;
+	pte = *ptep;
+	if (!pte_swap(pte))
+		goto out_pte;
+	/* Zap unused and logically-zero pages */
+	pgste = pgste_get_lock(ptep);
+	pgstev = pgste_val(pgste);
+	ptev = pte_val(pte);
+	if (((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED) ||
+	    ((pgstev & _PGSTE_GPS_ZERO) && (ptev & _PAGE_INVALID))) {
+		gmap_zap_swap_entry(pte_to_swp_entry(pte), mm);
+		pte_clear(mm, address, ptep);
+	}
+	pgste_set_unlock(ptep, pgste);
+out_pte:
+	pte_unmap_unlock(*ptep, ptl);
+}
+
+/*
+ * this function is assumed to be called with mmap_sem held
+ */
+void __gmap_zap(unsigned long address, struct gmap *gmap)
+{
+	unsigned long *table, *segment_ptr;
+	unsigned long segment, pgstev, ptev;
+	struct gmap_pgtable *mp;
+	struct page *page;
+
+	segment_ptr = gmap_table_walk(address, gmap);
+	if (IS_ERR(segment_ptr))
+		return;
+	segment = *segment_ptr;
+	if (segment & _SEGMENT_ENTRY_INVALID)
+		return;
+	page = pfn_to_page(segment >> PAGE_SHIFT);
+	mp = (struct gmap_pgtable *) page->index;
+	address = mp->vmaddr | (address & ~PMD_MASK);
+	/* Page table is present */
+	table = (unsigned long *)(segment & _SEGMENT_ENTRY_ORIGIN);
+	table = table + ((address >> 12) & 0xff);
+	pgstev = table[PTRS_PER_PTE];
+	ptev = table[0];
+	/* quick check, checked again with locks held */
+	if (((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED) ||
+	    ((pgstev & _PGSTE_GPS_ZERO) && (ptev & _PAGE_INVALID)))
+		gmap_zap_unused(gmap->mm, address);
+}
+EXPORT_SYMBOL_GPL(__gmap_zap);
+
 void gmap_discard(unsigned long from, unsigned long to, struct gmap *gmap)
 {
 

