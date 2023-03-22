Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167316C5443
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjCVSzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCVSy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:54:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054EB67004;
        Wed, 22 Mar 2023 11:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24146621BE;
        Wed, 22 Mar 2023 18:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67B5C433EF;
        Wed, 22 Mar 2023 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511224;
        bh=412Z0oJwaw9L6aIcs6+Ot4gr3TyGhtDIxQmEkfn7hJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtHRJlomrUWgCzNcPYSGpO8HG41OofhTAvbPwxSmZCjSfq1DlXQyGGAPDtyAkVM8m
         vy/c+ekrOTGWMSYlhjWdmMLCU7IVRwqI8UeuC62E0rPlXyBI05Ia3bbrMzrCMJBpOg
         QJm5FqUCytP7sB228ibobYtklGjYsDeUpYFLgbmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.104
Date:   Wed, 22 Mar 2023 19:53:23 +0100
Message-Id: <16795112039194@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679511203203220@kroah.com>
References: <1679511203203220@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index a99c1c338e8f..a15527940b46 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1210,7 +1210,7 @@ defined:
 	return
 	-ECHILD and it will be called again in ref-walk mode.
 
-``_weak_revalidate``
+``d_weak_revalidate``
 	called when the VFS needs to revalidate a "jumped" dentry.  This
 	is called when a path-walk ends at dentry that was not acquired
 	by doing a lookup in the parent directory.  This includes "/",
diff --git a/Makefile b/Makefile
index 75acfd6c0cf2..d3c808f4bf6b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 103
+SUBLEVEL = 104
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
index 5ff1f19fd45c..0099dc116168 100644
--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,8 +19,6 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
-	/* A local tlb flush is needed before user execution can resume. */
-	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 907b9efd39a8..801019381dea 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,24 +22,6 @@ static inline void local_flush_tlb_page(unsigned long addr)
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
-
-static inline void local_flush_tlb_all_asid(unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma x0, %0"
-			:
-			: "r" (asid)
-			: "memory");
-}
-
-static inline void local_flush_tlb_page_asid(unsigned long addr,
-		unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma %0, %1"
-			:
-			: "r" (addr), "r" (asid)
-			: "memory");
-}
-
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index cc4a47bda82a..68d7f5f407cd 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,16 +196,6 @@ static void set_mm_asid(struct mm_struct *mm, unsigned int cpu)
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
-#ifdef CONFIG_SMP
-	else {
-		cpumask_t *mask = &mm->context.tlb_stale_mask;
-
-		if (cpumask_test_cpu(cpu, mask)) {
-			cpumask_clear_cpu(cpu, mask);
-			local_flush_tlb_all_asid(cntx & asid_mask);
-		}
-	}
-#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
@@ -215,12 +205,24 @@ static void set_mm_noasid(struct mm_struct *mm)
 	local_flush_tlb_all();
 }
 
-static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
+static inline void set_mm(struct mm_struct *prev,
+			  struct mm_struct *next, unsigned int cpu)
 {
-	if (static_branch_unlikely(&use_asid_allocator))
-		set_mm_asid(mm, cpu);
-	else
-		set_mm_noasid(mm);
+	/*
+	 * The mm_cpumask indicates which harts' TLBs contain the virtual
+	 * address mapping of the mm. Compared to noasid, using asid
+	 * can't guarantee that stale TLB entries are invalidated because
+	 * the asid mechanism wouldn't flush TLB for every switch_mm for
+	 * performance. So when using asid, keep all CPUs footmarks in
+	 * cpumask() until mm reset.
+	 */
+	cpumask_set_cpu(cpu, mm_cpumask(next));
+	if (static_branch_unlikely(&use_asid_allocator)) {
+		set_mm_asid(next, cpu);
+	} else {
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+		set_mm_noasid(next);
+	}
 }
 
 static int __init asids_init(void)
@@ -272,7 +274,8 @@ static int __init asids_init(void)
 }
 early_initcall(asids_init);
 #else
-static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
+static inline void set_mm(struct mm_struct *prev,
+			  struct mm_struct *next, unsigned int cpu)
 {
 	/* Nothing to do here when there is no MMU */
 }
@@ -325,10 +328,7 @@ void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	 */
 	cpu = smp_processor_id();
 
-	cpumask_clear_cpu(cpu, mm_cpumask(prev));
-	cpumask_set_cpu(cpu, mm_cpumask(next));
-
-	set_mm(next, cpu);
+	set_mm(prev, next, cpu);
 
 	flush_icache_deferred(next, cpu);
 }
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index efefc3986c48..64f8201237c2 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,7 +5,23 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-#include <asm/tlbflush.h>
+
+static inline void local_flush_tlb_all_asid(unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma x0, %0"
+			:
+			: "r" (asid)
+			: "memory");
+}
+
+static inline void local_flush_tlb_page_asid(unsigned long addr,
+		unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma %0, %1"
+			:
+			: "r" (addr), "r" (asid)
+			: "memory");
+}
 
 void flush_tlb_all(void)
 {
@@ -15,7 +31,6 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
-	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	struct cpumask hmask;
 	unsigned int cpuid;
@@ -30,15 +45,6 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
-		/*
-		 * TLB will be immediately flushed on harts concurrently
-		 * executing this MM context. TLB flush on other harts
-		 * is deferred until this MM context migrates there.
-		 */
-		cpumask_setall(pmask);
-		cpumask_clear_cpu(cpuid, pmask);
-		cpumask_andnot(pmask, pmask, cmask);
-
 		if (broadcast) {
 			riscv_cpuid_to_hartid_mask(cmask, &hmask);
 			sbi_remote_sfence_vma_asid(cpumask_bits(&hmask),
diff --git a/arch/s390/boot/ipl_report.c b/arch/s390/boot/ipl_report.c
index 9b14045065b6..74b5cd264862 100644
--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ static unsigned long find_bootdata_space(struct ipl_rb_components *comps,
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_data.start && initrd_data.size &&
 	    intersects(initrd_data.start, initrd_data.size, safe_addr, size))
 		safe_addr = initrd_data.start + initrd_data.size;
+	if (intersects(safe_addr, size, (unsigned long)comps, comps->len)) {
+		safe_addr = (unsigned long)comps + comps->len;
+		goto repeat;
+	}
 	for_each_rb_entry(comp, comps)
 		if (intersects(safe_addr, size, comp->addr, comp->len)) {
 			safe_addr = comp->addr + comp->len;
 			goto repeat;
 		}
+	if (intersects(safe_addr, size, (unsigned long)certs, certs->len)) {
+		safe_addr = (unsigned long)certs + certs->len;
+		goto repeat;
+	}
 	for_each_rb_entry(cert, certs)
 		if (intersects(safe_addr, size, cert->addr, cert->len)) {
 			safe_addr = cert->addr + cert->len;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 639924d98331..56c4cecdbbf9 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -503,8 +503,7 @@ static struct resource *__alloc_res(struct zpci_dev *zdev, unsigned long start,
 	return r;
 }
 
-int zpci_setup_bus_resources(struct zpci_dev *zdev,
-			     struct list_head *resources)
+int zpci_setup_bus_resources(struct zpci_dev *zdev)
 {
 	unsigned long addr, size, flags;
 	struct resource *res;
@@ -540,7 +539,6 @@ int zpci_setup_bus_resources(struct zpci_dev *zdev,
 			return -ENOMEM;
 		}
 		zdev->bars[i].res = res;
-		pci_add_resource(resources, res);
 	}
 	zdev->has_resources = 1;
 
@@ -549,17 +547,23 @@ int zpci_setup_bus_resources(struct zpci_dev *zdev,
 
 static void zpci_cleanup_bus_resources(struct zpci_dev *zdev)
 {
+	struct resource *res;
 	int i;
 
+	pci_lock_rescan_remove();
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-		if (!zdev->bars[i].size || !zdev->bars[i].res)
+		res = zdev->bars[i].res;
+		if (!res)
 			continue;
 
+		release_resource(res);
+		pci_bus_remove_resource(zdev->zbus->bus, res);
 		zpci_free_iomap(zdev, zdev->bars[i].map_idx);
-		release_resource(zdev->bars[i].res);
-		kfree(zdev->bars[i].res);
+		zdev->bars[i].res = NULL;
+		kfree(res);
 	}
 	zdev->has_resources = 0;
+	pci_unlock_rescan_remove();
 }
 
 int pcibios_add_device(struct pci_dev *pdev)
diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 5d77acbd1c87..cc7e5b22ccfb 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -41,9 +41,7 @@ static int zpci_nb_devices;
  */
 static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 {
-	struct resource_entry *window, *n;
-	struct resource *res;
-	int rc;
+	int rc, i;
 
 	if (!zdev_enabled(zdev)) {
 		rc = zpci_enable_device(zdev);
@@ -57,10 +55,10 @@ static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 	}
 
 	if (!zdev->has_resources) {
-		zpci_setup_bus_resources(zdev, &zdev->zbus->resources);
-		resource_list_for_each_entry_safe(window, n, &zdev->zbus->resources) {
-			res = window->res;
-			pci_bus_add_resource(zdev->zbus->bus, res, 0);
+		zpci_setup_bus_resources(zdev);
+		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+			if (zdev->bars[i].res)
+				pci_bus_add_resource(zdev->zbus->bus, zdev->bars[i].res, 0);
 		}
 	}
 
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index ecef3a9e16c0..c5aa9a2e5e3e 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -30,8 +30,7 @@ static inline void zpci_zdev_get(struct zpci_dev *zdev)
 
 int zpci_alloc_domain(int domain);
 void zpci_free_domain(int domain);
-int zpci_setup_bus_resources(struct zpci_dev *zdev,
-			     struct list_head *resources);
+int zpci_setup_bus_resources(struct zpci_dev *zdev);
 
 static inline struct zpci_dev *get_zdev_by_bus(struct pci_bus *bus,
 					       unsigned int devfn)
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5ee82fd386dd..a0727723676b 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2302,6 +2302,7 @@ static void mce_restart(void)
 {
 	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
+	mce_schedule_work();
 }
 
 /* Toggle features for corrected errors */
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 87666275eed9..000e1467b4cd 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -353,7 +353,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 {
 	struct resctrl_schema *s;
 	struct rdtgroup *rdtgrp;
-	struct rdt_domain *dom;
 	struct rdt_resource *r;
 	char *tok, *resname;
 	int ret = 0;
@@ -382,10 +381,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		goto out;
 	}
 
-	list_for_each_entry(s, &resctrl_schema_all, list) {
-		list_for_each_entry(dom, &s->res->domains, list)
-			memset(dom->staged_config, 0, sizeof(dom->staged_config));
-	}
+	rdt_staged_configs_clear();
 
 	while ((tok = strsep(&buf, "\n")) != NULL) {
 		resname = strim(strsep(&tok, ":"));
@@ -422,6 +418,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	}
 
 out:
+	rdt_staged_configs_clear();
 	rdtgroup_kn_unlock(of->kn);
 	cpus_read_unlock();
 	return ret ?: nbytes;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 1d647188a43b..218d88800565 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -550,5 +550,6 @@ bool has_busy_rmid(struct rdt_resource *r, struct rdt_domain *d);
 void __check_limbo(struct rdt_domain *d, bool force_free);
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void __init thread_throttle_mode_init(void);
+void rdt_staged_configs_clear(void);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 88545a1f5207..421d31718fbd 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -78,6 +78,19 @@ void rdt_last_cmd_printf(const char *fmt, ...)
 	va_end(ap);
 }
 
+void rdt_staged_configs_clear(void)
+{
+	struct rdt_resource *r;
+	struct rdt_domain *dom;
+
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	for_each_alloc_capable_rdt_resource(r) {
+		list_for_each_entry(dom, &r->domains, list)
+			memset(dom->staged_config, 0, sizeof(dom->staged_config));
+	}
+}
+
 /*
  * Trivial allocator for CLOSIDs. Since h/w only supports a small number,
  * we can keep a bitmap of free CLOSIDs in a single integer.
@@ -2813,7 +2826,9 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 {
 	struct resctrl_schema *s;
 	struct rdt_resource *r;
-	int ret;
+	int ret = 0;
+
+	rdt_staged_configs_clear();
 
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
@@ -2822,20 +2837,22 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 		} else {
 			ret = rdtgroup_init_cat(s, rdtgrp->closid);
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 
 		ret = resctrl_arch_update_domains(r, rdtgrp->closid);
 		if (ret < 0) {
 			rdt_last_cmd_puts("Failed to initialize allocations\n");
-			return ret;
+			goto out;
 		}
 
 	}
 
 	rdtgrp->mode = RDT_MODE_SHAREABLE;
 
-	return 0;
+out:
+	rdt_staged_configs_clear();
+	return ret;
 }
 
 static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f3c136548af6..e4e4c1d3aa17 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2991,7 +2991,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
 					enum vm_entry_failure_code *entry_failure_code)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
@@ -3017,6 +3017,13 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					   vmcs12->guest_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG))
+		return -EINVAL;
+
+	if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
+	    CC(ia32e && !(vmcs12->guest_cr0 & X86_CR0_PG)))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -3028,7 +3035,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 700ce8fdea87..c7e9fb1d830d 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -585,7 +585,8 @@ void __init sme_enable(struct boot_params *bp)
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer));
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
+		return;
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 58a38e61de53..07cf7a35ae50 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2188,35 +2188,44 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
 {
+	struct cgroup_subsys_state *cmd_blkcg_css = cmd->blkcg_css;
+	struct cgroup_subsys_state *cmd_memcg_css = cmd->memcg_css;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	const bool write = op_is_write(req_op(rq));
 	struct loop_device *lo = rq->q->queuedata;
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
+	const bool use_aio = cmd->use_aio;
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
 	}
 
-	if (cmd->blkcg_css)
-		kthread_associate_blkcg(cmd->blkcg_css);
-	if (cmd->memcg_css)
+	if (cmd_blkcg_css)
+		kthread_associate_blkcg(cmd_blkcg_css);
+	if (cmd_memcg_css)
 		old_memcg = set_active_memcg(
-			mem_cgroup_from_css(cmd->memcg_css));
+			mem_cgroup_from_css(cmd_memcg_css));
 
+	/*
+	 * do_req_filebacked() may call blk_mq_complete_request() synchronously
+	 * or asynchronously if using aio. Hence, do not touch 'cmd' after
+	 * do_req_filebacked() has returned unless we are sure that 'cmd' has
+	 * not yet been completed.
+	 */
 	ret = do_req_filebacked(lo, rq);
 
-	if (cmd->blkcg_css)
+	if (cmd_blkcg_css)
 		kthread_associate_blkcg(NULL);
 
-	if (cmd->memcg_css) {
+	if (cmd_memcg_css) {
 		set_active_memcg(old_memcg);
-		css_put(cmd->memcg_css);
+		css_put(cmd_memcg_css);
 	}
  failed:
 	/* complete non-aio request */
-	if (!cmd->use_aio || ret) {
+	if (!use_aio || ret) {
 		if (ret == -EOPNOTSUPP)
 			cmd->ret = ret;
 		else
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 4c8b4101516c..033b0f64f2b9 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1314,8 +1314,7 @@ static inline void nullb_complete_cmd(struct nullb_cmd *cmd)
 	case NULL_IRQ_SOFTIRQ:
 		switch (cmd->nq->dev->queue_mode) {
 		case NULL_Q_MQ:
-			if (likely(!blk_should_fake_timeout(cmd->rq->q)))
-				blk_mq_complete_request(cmd->rq);
+			blk_mq_complete_request(cmd->rq);
 			break;
 		case NULL_Q_BIO:
 			/*
@@ -1491,7 +1490,8 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	cmd->rq = bd->rq;
 	cmd->error = BLK_STS_OK;
 	cmd->nq = nq;
-	cmd->fake_timeout = should_timeout_request(bd->rq);
+	cmd->fake_timeout = should_timeout_request(bd->rq) ||
+		blk_should_fake_timeout(bd->rq->q);
 
 	blk_mq_start_request(bd->rq);
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 4d4bb810c2ae..656d99faf40a 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -964,6 +964,8 @@ static int vdc_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	print_version();
 
 	hp = mdesc_grab();
+	if (!hp)
+		return -ENODEV;
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index c5b3dc97396a..100e474ff3dc 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -83,7 +83,7 @@ config COMMON_CLK_RK808
 config COMMON_CLK_HI655X
 	tristate "Clock driver for Hi655x" if EXPERT
 	depends on (MFD_HI655X_PMIC || COMPILE_TEST)
-	depends on REGMAP
+	select REGMAP
 	default MFD_HI655X_PMIC
 	help
 	  This driver supports the hi655x PMIC clock. This
diff --git a/drivers/cpuidle/cpuidle-psci-domain.c b/drivers/cpuidle/cpuidle-psci-domain.c
index ff2c3f8e4668..ce5c415fb04d 100644
--- a/drivers/cpuidle/cpuidle-psci-domain.c
+++ b/drivers/cpuidle/cpuidle-psci-domain.c
@@ -182,7 +182,8 @@ static void psci_pd_remove(void)
 	struct psci_pd_provider *pd_provider, *it;
 	struct generic_pm_domain *genpd;
 
-	list_for_each_entry_safe(pd_provider, it, &psci_pd_providers, link) {
+	list_for_each_entry_safe_reverse(pd_provider, it,
+					 &psci_pd_providers, link) {
 		of_genpd_del_provider(pd_provider->node);
 
 		genpd = of_genpd_remove_last(pd_provider->node);
diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index a3cadbaf3cba..0dac35406a38 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -171,7 +171,7 @@ static int zynqmp_pm_feature(u32 api_id)
 	}
 
 	/* Add new entry if not present */
-	feature_data = kmalloc(sizeof(*feature_data), GFP_KERNEL);
+	feature_data = kmalloc(sizeof(*feature_data), GFP_ATOMIC);
 	if (!feature_data)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index b8bdd796cd91..8b5c82af2acd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -528,16 +528,13 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	struct kfd_event_waiter *event_waiters;
 	uint32_t i;
 
-	event_waiters = kmalloc_array(num_events,
-					sizeof(struct kfd_event_waiter),
-					GFP_KERNEL);
+	event_waiters = kcalloc(num_events, sizeof(struct kfd_event_waiter),
+				GFP_KERNEL);
 	if (!event_waiters)
 		return NULL;
 
-	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
+	for (i = 0; i < num_events; i++)
 		init_wait(&event_waiters[i].wait);
-		event_waiters[i].activated = false;
-	}
 
 	return event_waiters;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 518672a2450f..de0fa87b301a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -1868,7 +1868,10 @@ static unsigned int CalculateVMAndRowBytes(
 	}
 
 	if (SurfaceTiling == dm_sw_linear) {
-		*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
+		if (PTEBufferSizeInRequests == 0)
+			*dpte_row_height = 1;
+		else
+			*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
 		*dpte_row_width_ub = (dml_ceil(((double) SwathWidth - 1) / *PixelPTEReqWidth, 1) + 1) * *PixelPTEReqWidth;
 		*PixelPTEBytesPerRow = *dpte_row_width_ub / *PixelPTEReqWidth * *PTERequestSize;
 	} else if (ScanDirection != dm_vert) {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 82a8c184526d..dbcabaedb00d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2013,16 +2013,9 @@ static int sienna_cichlid_set_default_od_settings(struct smu_context *smu)
 		(OverDriveTable_t *)smu->smu_table.boot_overdrive_table;
 	OverDriveTable_t *user_od_table =
 		(OverDriveTable_t *)smu->smu_table.user_overdrive_table;
+	OverDriveTable_t user_od_table_bak;
 	int ret = 0;
 
-	/*
-	 * For S3/S4/Runpm resume, no need to setup those overdrive tables again as
-	 *   - either they already have the default OD settings got during cold bootup
-	 *   - or they have some user customized OD settings which cannot be overwritten
-	 */
-	if (smu->adev->in_suspend)
-		return 0;
-
 	ret = smu_cmn_update_table(smu, SMU_TABLE_OVERDRIVE,
 				   0, (void *)boot_od_table, false);
 	if (ret) {
@@ -2033,7 +2026,23 @@ static int sienna_cichlid_set_default_od_settings(struct smu_context *smu)
 	sienna_cichlid_dump_od_table(smu, boot_od_table);
 
 	memcpy(od_table, boot_od_table, sizeof(OverDriveTable_t));
-	memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+
+	/*
+	 * For S3/S4/Runpm resume, we need to setup those overdrive tables again,
+	 * but we have to preserve user defined values in "user_od_table".
+	 */
+	if (!smu->adev->in_suspend) {
+		memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+		smu->user_dpm_profile.user_od = false;
+	} else if (smu->user_dpm_profile.user_od) {
+		memcpy(&user_od_table_bak, user_od_table, sizeof(OverDriveTable_t));
+		memcpy(user_od_table, boot_od_table, sizeof(OverDriveTable_t));
+		user_od_table->GfxclkFmin = user_od_table_bak.GfxclkFmin;
+		user_od_table->GfxclkFmax = user_od_table_bak.GfxclkFmax;
+		user_od_table->UclkFmin = user_od_table_bak.UclkFmin;
+		user_od_table->UclkFmax = user_od_table_bak.UclkFmax;
+		user_od_table->VddGfxOffset = user_od_table_bak.VddGfxOffset;
+	}
 
 	return 0;
 }
@@ -2243,6 +2252,20 @@ static int sienna_cichlid_od_edit_dpm_table(struct smu_context *smu,
 	return ret;
 }
 
+static int sienna_cichlid_restore_user_od_settings(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTable_t *od_table = table_context->overdrive_table;
+	OverDriveTable_t *user_od_table = table_context->user_overdrive_table;
+	int res;
+
+	res = smu_v11_0_restore_user_od_settings(smu);
+	if (res == 0)
+		memcpy(od_table, user_od_table, sizeof(OverDriveTable_t));
+
+	return res;
+}
+
 static int sienna_cichlid_run_btc(struct smu_context *smu)
 {
 	return smu_cmn_send_smc_msg(smu, SMU_MSG_RunDcBtc, NULL);
@@ -3980,7 +4003,7 @@ static const struct pptable_funcs sienna_cichlid_ppt_funcs = {
 	.set_soft_freq_limited_range = smu_v11_0_set_soft_freq_limited_range,
 	.set_default_od_settings = sienna_cichlid_set_default_od_settings,
 	.od_edit_dpm_table = sienna_cichlid_od_edit_dpm_table,
-	.restore_user_od_settings = smu_v11_0_restore_user_od_settings,
+	.restore_user_od_settings = sienna_cichlid_restore_user_od_settings,
 	.run_btc = sienna_cichlid_run_btc,
 	.set_power_source = smu_v11_0_set_power_source,
 	.get_pp_feature_mask = smu_cmn_get_pp_feature_mask,
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index d58e8e12d3ae..0c2968052b66 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -591,11 +591,14 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	int ret;
 
 	if (obj->import_attach) {
-		/* Drop the reference drm_gem_mmap_obj() acquired.*/
-		drm_gem_object_put(obj);
 		vma->vm_private_data = NULL;
+		ret = dma_buf_mmap(obj->dma_buf, vma, 0);
+
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		if (!ret)
+			drm_gem_object_put(obj);
 
-		return dma_buf_mmap(obj->dma_buf, vma, 0);
+		return ret;
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);
diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index b56850d96491..90e055f05699 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1520,6 +1520,8 @@ struct intel_psr {
 	bool psr2_sel_fetch_enabled;
 	bool req_psr2_sdp_prior_scanline;
 	u8 sink_sync_latency;
+	u8 io_wake_lines;
+	u8 fast_wake_lines;
 	ktime_t last_entry_attempt;
 	ktime_t last_exit;
 	bool sink_not_reliable;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index a3d0c57ec0f0..cf1e92486cbc 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -22,6 +22,7 @@
  */
 
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_damage_helper.h>
 
 #include "display/intel_dp.h"
 
@@ -548,6 +549,14 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 	val |= EDP_PSR2_FRAME_BEFORE_SU(intel_dp->psr.sink_sync_latency + 1);
 	val |= intel_psr2_get_tp_time(intel_dp);
 
+	if (DISPLAY_VER(dev_priv) >= 12) {
+		if (intel_dp->psr.io_wake_lines < 9 &&
+		    intel_dp->psr.fast_wake_lines < 9)
+			val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
+		else
+			val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_3;
+	}
+
 	/* Wa_22012278275:adl-p */
 	if (IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_E0)) {
 		static const u8 map[] = {
@@ -564,31 +573,21 @@ static void hsw_activate_psr2(struct intel_dp *intel_dp)
 		 * Still using the default IO_BUFFER_WAKE and FAST_WAKE, see
 		 * comments bellow for more information
 		 */
-		u32 tmp, lines = 7;
-
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
+		u32 tmp;
 
-		tmp = map[lines - TGL_EDP_PSR2_IO_BUFFER_WAKE_MIN_LINES];
+		tmp = map[intel_dp->psr.io_wake_lines - TGL_EDP_PSR2_IO_BUFFER_WAKE_MIN_LINES];
 		tmp = tmp << TGL_EDP_PSR2_IO_BUFFER_WAKE_SHIFT;
 		val |= tmp;
 
-		tmp = map[lines - TGL_EDP_PSR2_FAST_WAKE_MIN_LINES];
+		tmp = map[intel_dp->psr.fast_wake_lines - TGL_EDP_PSR2_FAST_WAKE_MIN_LINES];
 		tmp = tmp << TGL_EDP_PSR2_FAST_WAKE_MIN_SHIFT;
 		val |= tmp;
 	} else if (DISPLAY_VER(dev_priv) >= 12) {
-		/*
-		 * TODO: 7 lines of IO_BUFFER_WAKE and FAST_WAKE are default
-		 * values from BSpec. In order to setting an optimal power
-		 * consumption, lower than 4k resoluition mode needs to decrese
-		 * IO_BUFFER_WAKE and FAST_WAKE. And higher than 4K resolution
-		 * mode needs to increase IO_BUFFER_WAKE and FAST_WAKE.
-		 */
-		val |= TGL_EDP_PSR2_BLOCK_COUNT_NUM_2;
-		val |= TGL_EDP_PSR2_IO_BUFFER_WAKE(7);
-		val |= TGL_EDP_PSR2_FAST_WAKE(7);
+		val |= TGL_EDP_PSR2_IO_BUFFER_WAKE(intel_dp->psr.io_wake_lines);
+		val |= TGL_EDP_PSR2_FAST_WAKE(intel_dp->psr.fast_wake_lines);
 	} else if (DISPLAY_VER(dev_priv) >= 9) {
-		val |= EDP_PSR2_IO_BUFFER_WAKE(7);
-		val |= EDP_PSR2_FAST_WAKE(7);
+		val |= EDP_PSR2_IO_BUFFER_WAKE(intel_dp->psr.io_wake_lines);
+		val |= EDP_PSR2_FAST_WAKE(intel_dp->psr.fast_wake_lines);
 	}
 
 	if (intel_dp->psr.req_psr2_sdp_prior_scanline)
@@ -755,11 +754,7 @@ tgl_dc3co_exitline_compute_config(struct intel_dp *intel_dp,
 static bool intel_psr2_sel_fetch_config_valid(struct intel_dp *intel_dp,
 					      struct intel_crtc_state *crtc_state)
 {
-	struct intel_atomic_state *state = to_intel_atomic_state(crtc_state->uapi.state);
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
-	struct intel_plane_state *plane_state;
-	struct intel_plane *plane;
-	int i;
 
 	if (!dev_priv->params.enable_psr2_sel_fetch &&
 	    intel_dp->psr.debug != I915_PSR_DEBUG_ENABLE_SEL_FETCH) {
@@ -774,14 +769,6 @@ static bool intel_psr2_sel_fetch_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
-	for_each_new_intel_plane_in_state(state, plane, plane_state, i) {
-		if (plane_state->uapi.rotation != DRM_MODE_ROTATE_0) {
-			drm_dbg_kms(&dev_priv->drm,
-				    "PSR2 sel fetch not enabled, plane rotated\n");
-			return false;
-		}
-	}
-
 	/* Wa_14010254185 Wa_14010103792 */
 	if (IS_TGL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_C0)) {
 		drm_dbg_kms(&dev_priv->drm,
@@ -853,6 +840,46 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
 	return true;
 }
 
+static bool _compute_psr2_wake_times(struct intel_dp *intel_dp,
+				     struct intel_crtc_state *crtc_state)
+{
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+	int io_wake_lines, io_wake_time, fast_wake_lines, fast_wake_time;
+	u8 max_wake_lines;
+
+	if (DISPLAY_VER(i915) >= 12) {
+		io_wake_time = 42;
+		/*
+		 * According to Bspec it's 42us, but based on testing
+		 * it is not enough -> use 45 us.
+		 */
+		fast_wake_time = 45;
+		max_wake_lines = 12;
+	} else {
+		io_wake_time = 50;
+		fast_wake_time = 32;
+		max_wake_lines = 8;
+	}
+
+	io_wake_lines = intel_usecs_to_scanlines(
+		&crtc_state->uapi.adjusted_mode, io_wake_time);
+	fast_wake_lines = intel_usecs_to_scanlines(
+		&crtc_state->uapi.adjusted_mode, fast_wake_time);
+
+	if (io_wake_lines > max_wake_lines ||
+	    fast_wake_lines > max_wake_lines)
+		return false;
+
+	if (i915->params.psr_safest_params)
+		io_wake_lines = fast_wake_lines = max_wake_lines;
+
+	/* According to Bspec lower limit should be set as 7 lines. */
+	intel_dp->psr.io_wake_lines = max(io_wake_lines, 7);
+	intel_dp->psr.fast_wake_lines = max(fast_wake_lines, 7);
+
+	return true;
+}
+
 static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 				    struct intel_crtc_state *crtc_state)
 {
@@ -950,6 +977,12 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	if (!_compute_psr2_wake_times(intel_dp, crtc_state)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, Unable to use long enough wake times\n");
+		return false;
+	}
+
 	if (HAS_PSR2_SEL_FETCH(dev_priv)) {
 		if (!intel_psr2_sel_fetch_config_valid(intel_dp, crtc_state) &&
 		    !HAS_PSR_HW_TRACKING(dev_priv)) {
@@ -997,7 +1030,7 @@ void intel_psr_compute_config(struct intel_dp *intel_dp,
 	int psr_setup_time;
 
 	/*
-	 * Current PSR panels dont work reliably with VRR enabled
+	 * Current PSR panels don't work reliably with VRR enabled
 	 * So if VRR is enabled, do not enable PSR.
 	 */
 	if (crtc_state->vrr.enable)
@@ -1601,6 +1634,63 @@ static void intel_psr2_sel_fetch_pipe_alignment(const struct intel_crtc_state *c
 		drm_warn(&dev_priv->drm, "Missing PSR2 sel fetch alignment with DSC\n");
 }
 
+/*
+ * FIXME: Not sure why but when moving the cursor fast it causes some artifacts
+ * of the cursor to be left in the cursor path, adding some pixels above the
+ * cursor to the damaged area fixes the issue.
+ */
+static void cursor_area_workaround(const struct intel_plane_state *new_plane_state,
+				   struct drm_rect *damaged_area,
+				   struct drm_rect *pipe_clip)
+{
+	const struct intel_plane *plane = to_intel_plane(new_plane_state->uapi.plane);
+	int height;
+
+	if (plane->id != PLANE_CURSOR)
+		return;
+
+	height = drm_rect_height(&new_plane_state->uapi.dst) / 2;
+	damaged_area->y1 -=  height;
+	damaged_area->y1 = max(damaged_area->y1, 0);
+
+	clip_area_update(pipe_clip, damaged_area);
+}
+
+/*
+ * TODO: Not clear how to handle planes with negative position,
+ * also planes are not updated if they have a negative X
+ * position so for now doing a full update in this cases
+ *
+ * Plane scaling and rotation is not supported by selective fetch and both
+ * properties can change without a modeset, so need to be check at every
+ * atomic commit.
+ */
+static bool psr2_sel_fetch_plane_state_supported(const struct intel_plane_state *plane_state)
+{
+	if (plane_state->uapi.dst.y1 < 0 ||
+	    plane_state->uapi.dst.x1 < 0 ||
+	    plane_state->scaler_id >= 0 ||
+	    plane_state->uapi.rotation != DRM_MODE_ROTATE_0)
+		return false;
+
+	return true;
+}
+
+/*
+ * Check for pipe properties that is not supported by selective fetch.
+ *
+ * TODO: pipe scaling causes a modeset but skl_update_scaler_crtc() is executed
+ * after intel_psr_compute_config(), so for now keeping PSR2 selective fetch
+ * enabled and going to the full update path.
+ */
+static bool psr2_sel_fetch_pipe_state_supported(const struct intel_crtc_state *crtc_state)
+{
+	if (crtc_state->scaler_state.scaler_id >= 0)
+		return false;
+
+	return true;
+}
+
 int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
@@ -1614,9 +1704,10 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (!crtc_state->enable_psr2_sel_fetch)
 		return 0;
 
-	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
-	if (ret)
-		return ret;
+	if (!psr2_sel_fetch_pipe_state_supported(crtc_state)) {
+		full_update = true;
+		goto skip_sel_fetch_set_loop;
+	}
 
 	/*
 	 * Calculate minimal selective fetch area of each plane and calculate
@@ -1627,8 +1718,8 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	for_each_oldnew_intel_plane_in_state(state, plane, old_plane_state,
 					     new_plane_state, i) {
 		struct drm_rect src, damaged_area = { .y1 = -1 };
-		struct drm_mode_rect *damaged_clips;
-		u32 num_clips, j;
+		struct drm_atomic_helper_damage_iter iter;
+		struct drm_rect clip;
 
 		if (new_plane_state->uapi.crtc != crtc_state->uapi.crtc)
 			continue;
@@ -1637,19 +1728,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		    !old_plane_state->uapi.visible)
 			continue;
 
-		/*
-		 * TODO: Not clear how to handle planes with negative position,
-		 * also planes are not updated if they have a negative X
-		 * position so for now doing a full update in this cases
-		 */
-		if (new_plane_state->uapi.dst.y1 < 0 ||
-		    new_plane_state->uapi.dst.x1 < 0) {
+		if (!psr2_sel_fetch_plane_state_supported(new_plane_state)) {
 			full_update = true;
 			break;
 		}
 
-		num_clips = drm_plane_get_damage_clips_count(&new_plane_state->uapi);
-
 		/*
 		 * If visibility or plane moved, mark the whole plane area as
 		 * damaged as it needs to be complete redraw in the new and old
@@ -1669,15 +1752,12 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				damaged_area.y2 = new_plane_state->uapi.dst.y2;
 				clip_area_update(&pipe_clip, &damaged_area);
 			}
+
+			cursor_area_workaround(new_plane_state, &damaged_area,
+					       &pipe_clip);
 			continue;
-		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha ||
-			   (!num_clips &&
-			    new_plane_state->uapi.fb != old_plane_state->uapi.fb)) {
-			/*
-			 * If the plane don't have damaged areas but the
-			 * framebuffer changed or alpha changed, mark the whole
-			 * plane area as damaged.
-			 */
+		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha) {
+			/* If alpha changed mark the whole plane area as damaged */
 			damaged_area.y1 = new_plane_state->uapi.dst.y1;
 			damaged_area.y2 = new_plane_state->uapi.dst.y2;
 			clip_area_update(&pipe_clip, &damaged_area);
@@ -1685,15 +1765,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		}
 
 		drm_rect_fp_to_int(&src, &new_plane_state->uapi.src);
-		damaged_clips = drm_plane_get_damage_clips(&new_plane_state->uapi);
-
-		for (j = 0; j < num_clips; j++) {
-			struct drm_rect clip;
 
-			clip.x1 = damaged_clips[j].x1;
-			clip.y1 = damaged_clips[j].y1;
-			clip.x2 = damaged_clips[j].x2;
-			clip.y2 = damaged_clips[j].y2;
+		drm_atomic_helper_damage_iter_init(&iter,
+						   &old_plane_state->uapi,
+						   &new_plane_state->uapi);
+		drm_atomic_for_each_plane_damage(&iter, &clip) {
 			if (drm_rect_intersect(&clip, &src))
 				clip_area_update(&damaged_area, &clip);
 		}
@@ -1709,6 +1785,10 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (full_update)
 		goto skip_sel_fetch_set_loop;
 
+	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
+	if (ret)
+		return ret;
+
 	intel_psr2_sel_fetch_pipe_alignment(crtc_state, &pipe_clip);
 
 	/*
@@ -1727,6 +1807,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		if (!drm_rect_intersect(&inter, &new_plane_state->uapi.dst))
 			continue;
 
+		if (!psr2_sel_fetch_plane_state_supported(new_plane_state)) {
+			full_update = true;
+			break;
+		}
+
 		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
 		sel_fetch_area->y1 = inter.y1 - new_plane_state->uapi.dst.y1;
 		sel_fetch_area->y2 = inter.y2 - new_plane_state->uapi.dst.y1;
@@ -2026,7 +2111,7 @@ static void intel_psr_work(struct work_struct *work)
 }
 
 /**
- * intel_psr_invalidate - Invalidade PSR
+ * intel_psr_invalidate - Invalidate PSR
  * @dev_priv: i915 device
  * @frontbuffer_bits: frontbuffer plane tracking bits
  * @origin: which operation caused the invalidate
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 7c4d5158e03b..7d82545d15e5 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -113,7 +113,7 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
 	struct i915_vma *vma;
 
 	obj = i915_gem_object_create_lmem(i915, size, I915_BO_ALLOC_VOLATILE);
-	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt))
+	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
 		obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(obj))
 		obj = i915_gem_object_create_internal(i915, size);
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 3103c1e1fd14..283c5091005e 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -422,8 +422,7 @@ replace_barrier(struct i915_active *ref, struct i915_active_fence *active)
 	 * we can use it to substitute for the pending idle-barrer
 	 * request that we want to emit on the kernel_context.
 	 */
-	__active_del_barrier(ref, node_from_active(active));
-	return true;
+	return __active_del_barrier(ref, node_from_active(active));
 }
 
 int i915_active_ref(struct i915_active *ref, u64 idx, struct dma_fence *fence)
@@ -436,16 +435,19 @@ int i915_active_ref(struct i915_active *ref, u64 idx, struct dma_fence *fence)
 	if (err)
 		return err;
 
-	active = active_instance(ref, idx);
-	if (!active) {
-		err = -ENOMEM;
-		goto out;
-	}
+	do {
+		active = active_instance(ref, idx);
+		if (!active) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		if (replace_barrier(ref, active)) {
+			RCU_INIT_POINTER(active->fence, NULL);
+			atomic_dec(&ref->count);
+		}
+	} while (unlikely(is_barrier(active)));
 
-	if (replace_barrier(ref, active)) {
-		RCU_INIT_POINTER(active->fence, NULL);
-		atomic_dec(&ref->count);
-	}
 	if (!__i915_active_fence_set(active, fence))
 		__i915_active_acquire(ref);
 
diff --git a/drivers/gpu/drm/meson/meson_vpp.c b/drivers/gpu/drm/meson/meson_vpp.c
index 154837688ab0..5df1957c8e41 100644
--- a/drivers/gpu/drm/meson/meson_vpp.c
+++ b/drivers/gpu/drm/meson/meson_vpp.c
@@ -100,6 +100,8 @@ void meson_vpp_init(struct meson_drm *priv)
 			       priv->io_base + _REG(VPP_DOLBY_CTRL));
 		writel_relaxed(0x1020080,
 				priv->io_base + _REG(VPP_DUMMY_DATA1));
+		writel_relaxed(0x42020,
+				priv->io_base + _REG(VPP_DUMMY_DATA));
 	} else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
 		writel_relaxed(0xf, priv->io_base + _REG(DOLBY_PATH_CTRL));
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index c3292a6bd1ae..d6dda97e2591 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -253,7 +253,7 @@ static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 	if (pm_runtime_active(pfdev->dev))
 		mmu_hw_do_operation(pfdev, mmu, iova, size, AS_COMMAND_FLUSH_PT);
 
-	pm_runtime_put_sync_autosuspend(pfdev->dev);
+	pm_runtime_put_autosuspend(pfdev->dev);
 }
 
 static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 5b7061e2bca4..0cc64c97385e 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -94,12 +94,12 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	/* Remove early framebuffers (ie. simplefb) */
 	ret = drm_aperture_remove_framebuffers(false, &sun4i_drv_driver);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	sun4i_framebuffer_init(drm);
 
@@ -118,6 +118,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f1ea883db5de..d941023c5628 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -258,6 +258,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 {
 	struct hid_report *report;
 	struct hid_field *field;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int usages;
 	unsigned int offset;
 	unsigned int i;
@@ -288,8 +289,11 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	offset = report->size;
 	report->size += parser->global.report_size * parser->global.report_count;
 
+	if (parser->device->ll_driver->max_buffer_size)
+		max_buffer_size = parser->device->ll_driver->max_buffer_size;
+
 	/* Total size check: Allow for possible report index byte */
-	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
+	if (report->size > (max_buffer_size - 1) << 3) {
 		hid_err(parser->device, "report is too long\n");
 		return -1;
 	}
@@ -1752,6 +1756,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int a;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
@@ -1768,10 +1773,13 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 
 	rsize = hid_compute_report_size(report);
 
-	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE - 1;
-	else if (rsize > HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE;
+	if (hid->ll_driver->max_buffer_size)
+		max_buffer_size = hid->ll_driver->max_buffer_size;
+
+	if (report_enum->numbered && rsize >= max_buffer_size)
+		rsize = max_buffer_size - 1;
+	else if (rsize > max_buffer_size)
+		rsize = max_buffer_size;
 
 	if (csize < rsize) {
 		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index fc06d8bb42e0..ba0ca652b9da 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 9d5b019651f2..6b84822e7d93 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -486,10 +486,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
 		val = (temp - val) / 1000;
 
 		if (sattr->index != 1) {
-			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
+			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF) << 4;
 		} else {
-			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
+			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF);
 		}
 
@@ -554,11 +554,11 @@ static ssize_t temp_st_show(struct device *dev, struct device_attribute *attr,
 		val = data->enh_acoustics[0] & 0xf;
 		break;
 	case 1:
-		val = (data->enh_acoustics[1] >> 4) & 0xf;
+		val = data->enh_acoustics[1] & 0xf;
 		break;
 	case 2:
 	default:
-		val = data->enh_acoustics[1] & 0xf;
+		val = (data->enh_acoustics[1] >> 4) & 0xf;
 		break;
 	}
 
diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index 14586b2fb17d..bc90631148ea 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -772,7 +772,7 @@ static int ina3221_probe_child_from_dt(struct device *dev,
 		return ret;
 	} else if (val > INA3221_CHANNEL3) {
 		dev_err(dev, "invalid reg %d of %pOFn\n", val, child);
-		return ret;
+		return -EINVAL;
 	}
 
 	input = &ina->inputs[val];
diff --git a/drivers/hwmon/ltc2992.c b/drivers/hwmon/ltc2992.c
index 2a4bed0ab226..009a0a5af923 100644
--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -324,6 +324,7 @@ static int ltc2992_config_gpio(struct ltc2992_state *st)
 	st->gc.label = name;
 	st->gc.parent = &st->client->dev;
 	st->gc.owner = THIS_MODULE;
+	st->gc.can_sleep = true;
 	st->gc.base = -1;
 	st->gc.names = st->gpio_names;
 	st->gc.ngpio = ARRAY_SIZE(st->gpio_names);
diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index ec5f932fc6f0..1ac2b2f4c570 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -301,6 +301,7 @@ static int adm1266_config_gpio(struct adm1266_data *data)
 	data->gc.label = name;
 	data->gc.parent = &data->client->dev;
 	data->gc.owner = THIS_MODULE;
+	data->gc.can_sleep = true;
 	data->gc.base = -1;
 	data->gc.names = data->gpio_names;
 	data->gc.ngpio = ARRAY_SIZE(data->gpio_names);
diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index 75fc770c9e40..3daaf2237832 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -16,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/pmbus.h>
 #include <linux/gpio/driver.h>
+#include <linux/timekeeping.h>
 #include "pmbus.h"
 
 enum chips { ucd9000, ucd90120, ucd90124, ucd90160, ucd90320, ucd9090,
@@ -65,6 +67,7 @@ struct ucd9000_data {
 	struct gpio_chip gpio;
 #endif
 	struct dentry *debugfs;
+	ktime_t write_time;
 };
 #define to_ucd9000_data(_info) container_of(_info, struct ucd9000_data, info)
 
@@ -73,6 +76,73 @@ struct ucd9000_debugfs_entry {
 	u8 index;
 };
 
+/*
+ * It has been observed that the UCD90320 randomly fails register access when
+ * doing another access right on the back of a register write. To mitigate this
+ * make sure that there is a minimum delay between a write access and the
+ * following access. The 250us is based on experimental data. At a delay of
+ * 200us the issue seems to go away. Add a bit of extra margin to allow for
+ * system to system differences.
+ */
+#define UCD90320_WAIT_DELAY_US 250
+
+static inline void ucd90320_wait(const struct ucd9000_data *data)
+{
+	s64 delta = ktime_us_delta(ktime_get(), data->write_time);
+
+	if (delta < UCD90320_WAIT_DELAY_US)
+		udelay(UCD90320_WAIT_DELAY_US - delta);
+}
+
+static int ucd90320_read_word_data(struct i2c_client *client, int page,
+				   int phase, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	if (reg >= PMBUS_VIRT_BASE)
+		return -ENXIO;
+
+	ucd90320_wait(data);
+	return pmbus_read_word_data(client, page, phase, reg);
+}
+
+static int ucd90320_read_byte_data(struct i2c_client *client, int page, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	ucd90320_wait(data);
+	return pmbus_read_byte_data(client, page, reg);
+}
+
+static int ucd90320_write_word_data(struct i2c_client *client, int page,
+				    int reg, u16 word)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_word_data(client, page, reg, word);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
+static int ucd90320_write_byte(struct i2c_client *client, int page, u8 value)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_byte(client, page, value);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
 static int ucd9000_get_fan_config(struct i2c_client *client, int fan)
 {
 	int fan_config = 0;
@@ -598,6 +668,11 @@ static int ucd9000_probe(struct i2c_client *client)
 		info->read_byte_data = ucd9000_read_byte_data;
 		info->func[0] |= PMBUS_HAVE_FAN12 | PMBUS_HAVE_STATUS_FAN12
 		  | PMBUS_HAVE_FAN34 | PMBUS_HAVE_STATUS_FAN34;
+	} else if (mid->driver_data == ucd90320) {
+		info->read_byte_data = ucd90320_read_byte_data;
+		info->read_word_data = ucd90320_read_word_data;
+		info->write_byte = ucd90320_write_byte;
+		info->write_word_data = ucd90320_write_word_data;
 	}
 
 	ucd9000_probe_gpio(client, mid, data);
diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 47bbe47e062f..7d5f7441aceb 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -758,7 +758,7 @@ static int tmp51x_probe(struct i2c_client *client)
 static struct i2c_driver tmp51x_driver = {
 	.driver = {
 		.name	= "tmp51x",
-		.of_match_table = of_match_ptr(tmp51x_of_match),
+		.of_match_table = tmp51x_of_match,
 	},
 	.probe_new	= tmp51x_probe,
 	.id_table	= tmp51x_id,
diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index 382ef0395d8e..a64f768bf181 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -768,6 +768,7 @@ static int xgene_hwmon_remove(struct platform_device *pdev)
 {
 	struct xgene_hwmon_dev *ctx = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&ctx->workq);
 	hwmon_device_unregister(ctx->hwmon_dev);
 	kfifo_free(&ctx->async_msg_fifo);
 	if (acpi_disabled)
diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 808f6e7a8048..14d785e5629e 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -850,6 +850,10 @@ void icc_node_destroy(int id)
 
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return;
+
+	kfree(node->links);
 	kfree(node);
 }
 EXPORT_SYMBOL_GPL(icc_node_destroy);
diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index 6559d8cf8068..e70665899482 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -149,6 +149,9 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 				 &priv->bus_clk_ratio))
 		priv->bus_clk_ratio = EXYNOS_ICC_DEFAULT_BUS_CLK_RATIO;
 
+	icc_node->data = priv;
+	icc_node_add(icc_node, provider);
+
 	/*
 	 * Register a PM QoS request for the parent (devfreq) device.
 	 */
@@ -157,9 +160,6 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_node_del;
 
-	icc_node->data = priv;
-	icc_node_add(icc_node, provider);
-
 	icc_parent_node = exynos_icc_get_parent(bus_dev->of_node);
 	if (IS_ERR(icc_parent_node)) {
 		ret = PTR_ERR(icc_parent_node);
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index e29be0242f07..f4233feb2627 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -488,7 +488,7 @@ static enum m5mols_restype __find_restype(u32 code)
 	do {
 		if (code == m5mols_default_ffmt[type].code)
 			return type;
-	} while (type++ != SIZE_DEFAULT_FFMT);
+	} while (++type != SIZE_DEFAULT_FFMT);
 
 	return 0;
 }
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 6f971a3e7e49..493ed8c82419 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1818,7 +1818,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1851,8 +1850,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				 * command to send.
 				 */
 				if (host->mrq->stop) {
-					atmci_writel(host, ATMCI_IER,
-					             ATMCI_CMDRDY);
 					atmci_send_stop_cmd(host, data);
 					state = STATE_SENDING_STOP;
 				} else {
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 9661e010df89..b3d3cb6ac656 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -369,7 +369,7 @@ static void sdhci_am654_write_b(struct sdhci_host *host, u8 val, int reg)
 					MAX_POWER_ON_TIMEOUT, false, host, val,
 					reg);
 		if (ret)
-			dev_warn(mmc_dev(host->mmc), "Power on failed\n");
+			dev_info(mmc_dev(host->mmc), "Power on failed\n");
 	}
 }
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 456298919d54..e1dc94f01cb5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1744,6 +1744,19 @@ void bond_lower_state_changed(struct slave *slave)
 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
 } while (0)
 
+/* The bonding driver uses ether_setup() to convert a master bond device
+ * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ */
+static void bond_ether_setup(struct net_device *bond_dev)
+{
+	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+
+	ether_setup(bond_dev);
+	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+}
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack)
@@ -1835,10 +1848,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 			if (slave_dev->type != ARPHRD_ETHER)
 				bond_setup_by_slave(bond_dev, slave_dev);
-			else {
-				ether_setup(bond_dev);
-				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-			}
+			else
+				bond_ether_setup(bond_dev);
 
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
 						 bond_dev);
@@ -2256,9 +2267,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			eth_hw_addr_random(bond_dev);
 		if (bond_dev->type != ARPHRD_ETHER) {
 			dev_close(bond_dev);
-			ether_setup(bond_dev);
-			bond_dev->flags |= IFF_MASTER;
-			bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+			bond_ether_setup(bond_dev);
 		}
 	}
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 7bcfa3be95e2..793992c37855 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -425,8 +425,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	switch (interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		trgint = 0;
-		/* PLL frequency: 125MHz */
-		ncpo1 = 0x0c80;
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
@@ -457,38 +455,40 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
-	/* Lower Tx Driving for TRGMII path */
-	for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
-	/* Disable MT7530 core and TRGMII Tx clocks */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
-		   REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	/* Setup the MT7530 TRGMII Tx Clock */
-	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
-	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
-	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
-	core_write(priv, CORE_PLL_GROUP4,
-		   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
-		   RG_SYSPLL_BIAS_LPF_EN);
-	core_write(priv, CORE_PLL_GROUP2,
-		   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
-		   RG_SYSPLL_POSDIV(1));
-	core_write(priv, CORE_PLL_GROUP7,
-		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
-		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
-
-	/* Enable MT7530 core and TRGMII Tx clocks */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
-		 REG_GSWCK_EN | REG_TRGMIICK_EN);
-
-	if (!trgint)
+	if (trgint) {
+		/* Lower Tx Driving for TRGMII path */
+		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
+			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+		/* Disable MT7530 core and TRGMII Tx clocks */
+		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+			   REG_GSWCK_EN | REG_TRGMIICK_EN);
+
+		/* Setup the MT7530 TRGMII Tx Clock */
+		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
+		core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
+		core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
+		core_write(priv, CORE_PLL_GROUP4,
+			   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
+			   RG_SYSPLL_BIAS_LPF_EN);
+		core_write(priv, CORE_PLL_GROUP2,
+			   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
+			   RG_SYSPLL_POSDIV(1));
+		core_write(priv, CORE_PLL_GROUP7,
+			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
+			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+		/* Enable MT7530 core and TRGMII Tx clocks */
+		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
+			 REG_GSWCK_EN | REG_TRGMIICK_EN);
+	} else {
 		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 				   RD_TAP_MASK, RD_TAP(16));
+	}
+
 	return 0;
 }
 
@@ -2168,7 +2168,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
-	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
+	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f9efd0c8bab8..99c4e45c62e3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3054,7 +3054,7 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return ETH_DATA_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -3062,6 +3062,17 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	/* For families where we don't know how to alter the MTU,
+	 * just accept any value up to ETH_DATA_LEN
+	 */
+	if (!chip->info->ops->port_set_jumbo_size &&
+	    !chip->info->ops->set_max_frame_size) {
+		if (new_mtu > ETH_DATA_LEN)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		new_mtu += EDSA_HLEN;
 
@@ -3070,9 +3081,6 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
 	else if (chip->info->ops->set_max_frame_size)
 		ret = chip->info->ops->set_max_frame_size(chip, new_mtu);
-	else
-		if (new_mtu > 1522)
-			ret = -EINVAL;
 	mv88e6xxx_reg_unlock(chip);
 
 	return ret;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5ffcd3cc989f..85d48efce1d0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15338,6 +15338,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 	int err;
 	int v_idx;
 
+	pci_set_drvdata(pf->pdev, pf);
 	pci_save_state(pf->pdev);
 
 	/* set up periodic task facility */
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a5bc804dc67a..43fe91213aa5 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -399,6 +399,7 @@ enum ice_pf_flags {
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_UNPLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
@@ -706,16 +707,11 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
-	/* We can directly unplug aux device here only if the flag bit
-	 * ICE_FLAG_PLUG_AUX_DEV is not set because ice_unplug_aux_dev()
-	 * could race with ice_plug_aux_dev() called from
-	 * ice_service_task(). In this case we only clear that bit now and
-	 * aux device will be unplugged later once ice_plug_aux_device()
-	 * called from ice_service_task() finishes (see ice_service_task()).
+	/* defer unplug to service task to avoid RTNL lock and
+	 * clear PLUG bit so that pending plugs don't interfere
 	 */
-	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-		ice_unplug_aux_dev(pf);
-
+	clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 13afbffc4758..bf9fe385274e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2156,18 +2156,15 @@ static void ice_service_task(struct work_struct *work)
 		}
 	}
 
-	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
-		/* Plug aux device per request */
-		ice_plug_aux_dev(pf);
+	/* unplug aux dev per request, if an unplug request came in
+	 * while processing a plug request, this will handle it
+	 */
+	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
 
-		/* Mark plugging as done but check whether unplug was
-		 * requested during ice_plug_aux_dev() call
-		 * (e.g. from ice_clear_rdma_cap()) and if so then
-		 * plug aux device.
-		 */
-		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-			ice_unplug_aux_dev(pf);
-	}
+	/* Plug aux device per request */
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_plug_aux_dev(pf);
 
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 60d8ef0c8859..070be30cbaa9 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -166,8 +166,6 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	}
 	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
 
-	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
-
 	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
 	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
 	if (err)
@@ -182,6 +180,8 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			return err;
 	}
+	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
+
 	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 0410c3604abd..ba445724ee65 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5022,6 +5022,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	num_vports = p_hwfn->qm_info.num_vports;
 
+	if (num_vports < 2) {
+		DP_NOTICE(p_hwfn, "Unexpected num_vports: %d\n", num_vports);
+		return -EINVAL;
+	}
+
 	/* Accounting for the vports which are configured for WFQ explicitly */
 	for (i = 0; i < num_vports; i++) {
 		u32 tmp_speed;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 6190adf965bc..f55eed092f25 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -422,7 +422,7 @@ qed_mfw_get_tlv_time_value(struct qed_mfw_tlv_time *p_time,
 	if (p_time->hour > 23)
 		p_time->hour = 0;
 	if (p_time->min > 59)
-		p_time->hour = 0;
+		p_time->min = 0;
 	if (p_time->msec > 999)
 		p_time->msec = 0;
 	if (p_time->usec > 999)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c6fe1cda7b88..12548eeef4f8 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1115,8 +1115,6 @@ static int ravb_phy_init(struct net_device *ndev)
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -1961,6 +1959,8 @@ static int ravb_mdio_init(struct ravb_private *priv)
 {
 	struct platform_device *pdev = priv->pdev;
 	struct device *dev = &pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 	int error;
 
 	/* Bitbang init */
@@ -1982,6 +1982,14 @@ static int ravb_mdio_init(struct ravb_private *priv)
 	if (error)
 		goto out_free_bus;
 
+	pn = of_parse_phandle(dev->of_node, "phy-handle", 0);
+	phydev = of_phy_find_device(pn);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+	of_node_put(pn);
+
 	return 0;
 
 out_free_bus:
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 4e190f5e32c3..b6e426d8014d 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2033,8 +2033,6 @@ static int sh_eth_phy_init(struct net_device *ndev)
 		}
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -3074,6 +3072,8 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	struct bb_info *bitbang;
 	struct platform_device *pdev = mdp->pdev;
 	struct device *dev = &mdp->pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 
 	/* create bit control struct for PHY */
 	bitbang = devm_kzalloc(dev, sizeof(struct bb_info), GFP_KERNEL);
@@ -3108,6 +3108,14 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	if (ret)
 		goto out_free_bus;
 
+	pn = of_parse_phandle(dev->of_node, "phy-handle", 0);
+	phydev = of_phy_find_device(pn);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+	of_node_put(pn);
+
 	return 0;
 
 out_free_bus:
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 50bd4e3b0af9..cde65f76e5ce 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -290,6 +290,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
 	err = -ENODEV;
 	if (!rmac) {
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 58ee89223951..dcdfc1fd3d2c 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -431,6 +431,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	vp = vnet_find_parent(hp, vdev->mp, vdev);
 	if (IS_ERR(vp)) {
 		pr_err("Cannot find port parent vnet\n");
diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f..71712ea25403 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 		goto out;
 
 	skb->dev = addr->master->dev;
+	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 91a327f67a42..fbb64aa32404 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -79,7 +79,7 @@
 #define SGMII_ABILITY			BIT(0)
 
 #define VEND1_MII_BASIC_CONFIG		0xAFC6
-#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_REV		BIT(4)
 #define MII_BASIC_CONFIG_SGMII		0x9
 #define MII_BASIC_CONFIG_RGMII		0x7
 #define MII_BASIC_CONFIG_RMII		0x5
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 04e628788f1b..36dcf6c7f445 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -206,8 +206,11 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int err;
 
-	int err = genphy_read_status(phydev);
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
 
 	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 76f7af161313..7c3e86651419 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2199,6 +2199,13 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (rx_cmd_a & RX_CMD_A_LEN) - RXW_PADDING;
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x\n", rx_cmd_a);
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 62ad26e4299d..47d423cc2608 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -175,6 +175,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	arg.phy = phy;
 	init_completion(&arg.done);
 	cntx = phy->out_urb->context;
 	phy->out_urb->context = &arg;
diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index e9dc313b333e..3564e3335a98 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -286,13 +286,15 @@ EXPORT_SYMBOL(ndlc_probe);
 
 void ndlc_remove(struct llt_ndlc *ndlc)
 {
-	st_nci_remove(ndlc->ndev);
-
 	/* cancel timers */
 	del_timer_sync(&ndlc->t1_timer);
 	del_timer_sync(&ndlc->t2_timer);
 	ndlc->t2_active = false;
 	ndlc->t1_active = false;
+	/* cancel work */
+	cancel_work_sync(&ndlc->sm_work);
+
+	st_nci_remove(ndlc->ndev);
 
 	skb_queue_purge(&ndlc->rcv_q);
 	skb_queue_purge(&ndlc->send_q);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 06750f3d5274..ef9d7a795b00 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -853,16 +853,26 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		range = page_address(ns->ctrl->discard_page);
 	}
 
-	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
-		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
-
-		if (n < segments) {
-			range[n].cattr = cpu_to_le32(0);
-			range[n].nlb = cpu_to_le32(nlb);
-			range[n].slba = cpu_to_le64(slba);
+	if (queue_max_discard_segments(req->q) == 1) {
+		u64 slba = nvme_sect_to_lba(ns, blk_rq_pos(req));
+		u32 nlb = blk_rq_sectors(req) >> (ns->lba_shift - 9);
+
+		range[0].cattr = cpu_to_le32(0);
+		range[0].nlb = cpu_to_le32(nlb);
+		range[0].slba = cpu_to_le64(slba);
+		n = 1;
+	} else {
+		__rq_for_each_bio(bio, req) {
+			u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
+			u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
+
+			if (n < segments) {
+				range[n].cattr = cpu_to_le32(0);
+				range[n].nlb = cpu_to_le32(nlb);
+				range[n].slba = cpu_to_le64(slba);
+			}
+			n++;
 		}
-		n++;
 	}
 
 	if (WARN_ON_ONCE(n != segments)) {
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 00552cd02d73..6539332b42b3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3378,6 +3378,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x1202),   /* Netac Technologies Co. NV3000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index cfd038551156..4c6d56dd29ad 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -756,8 +756,10 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_sq *sq = req->sq;
+
 	__nvmet_req_complete(req, status);
-	percpu_ref_put(&req->sq->ref);
+	percpu_ref_put(&sq->ref);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_complete);
 
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 3cef835b375f..feafa378bf8e 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -76,6 +76,27 @@ struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n)
 }
 EXPORT_SYMBOL_GPL(pci_bus_resource_n);
 
+void pci_bus_remove_resource(struct pci_bus *bus, struct resource *res)
+{
+	struct pci_bus_resource *bus_res, *tmp;
+	int i;
+
+	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++) {
+		if (bus->resource[i] == res) {
+			bus->resource[i] = NULL;
+			return;
+		}
+	}
+
+	list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
+		if (bus_res->res == res) {
+			list_del(&bus_res->list);
+			kfree(bus_res);
+			return;
+		}
+	}
+}
+
 void pci_bus_remove_resources(struct pci_bus *bus)
 {
 	int i;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 2761ab86490d..f44c0667a83c 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -925,7 +925,7 @@ static int pci_pm_resume_noirq(struct device *dev)
 	pcie_pme_root_status_cleanup(pci_dev);
 
 	if (!skip_bus_pm && prev_state == PCI_D3cold)
-		pci_bridge_wait_for_secondary_bus(pci_dev);
+		pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return 0;
@@ -1312,7 +1312,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 	pci_pm_default_resume(pci_dev);
 
 	if (prev_state == PCI_D3cold)
-		pci_bridge_wait_for_secondary_bus(pci_dev);
+		pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 
 	if (pm && pm->runtime_resume)
 		error = pm->runtime_resume(dev);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ce0988513fda..649df298869c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -163,9 +163,6 @@ static int __init pcie_port_pm_setup(char *str)
 }
 __setup("pcie_port_pm=", pcie_port_pm_setup);
 
-/* Time to wait after a reset for device to become responsive */
-#define PCIE_RESET_READY_POLL_MS 60000
-
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
@@ -1255,7 +1252,7 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 			return -ENOTTY;
 		}
 
-		if (delay > 1000)
+		if (delay > PCI_RESET_WAIT)
 			pci_info(dev, "not ready %dms after %s; waiting\n",
 				 delay - 1, reset_type);
 
@@ -1264,7 +1261,7 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 		pci_read_config_dword(dev, PCI_COMMAND, &id);
 	}
 
-	if (delay > 1000)
+	if (delay > PCI_RESET_WAIT)
 		pci_info(dev, "ready %dms after %s\n", delay - 1,
 			 reset_type);
 
@@ -4886,24 +4883,31 @@ static int pci_bus_max_d3cold_delay(const struct pci_bus *bus)
 /**
  * pci_bridge_wait_for_secondary_bus - Wait for secondary bus to be accessible
  * @dev: PCI bridge
+ * @reset_type: reset type in human-readable form
+ * @timeout: maximum time to wait for devices on secondary bus (milliseconds)
  *
  * Handle necessary delays before access to the devices on the secondary
- * side of the bridge are permitted after D3cold to D0 transition.
+ * side of the bridge are permitted after D3cold to D0 transition
+ * or Conventional Reset.
  *
  * For PCIe this means the delays in PCIe 5.0 section 6.6.1. For
  * conventional PCI it means Tpvrh + Trhfa specified in PCI 3.0 section
  * 4.3.2.
+ *
+ * Return 0 on success or -ENOTTY if the first device on the secondary bus
+ * failed to become accessible.
  */
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout)
 {
 	struct pci_dev *child;
 	int delay;
 
 	if (pci_dev_is_disconnected(dev))
-		return;
+		return 0;
 
 	if (!pci_is_bridge(dev))
-		return;
+		return 0;
 
 	down_read(&pci_bus_sem);
 
@@ -4915,14 +4919,14 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	 */
 	if (!dev->subordinate || list_empty(&dev->subordinate->devices)) {
 		up_read(&pci_bus_sem);
-		return;
+		return 0;
 	}
 
 	/* Take d3cold_delay requirements into account */
 	delay = pci_bus_max_d3cold_delay(dev->subordinate);
 	if (!delay) {
 		up_read(&pci_bus_sem);
-		return;
+		return 0;
 	}
 
 	child = list_first_entry(&dev->subordinate->devices, struct pci_dev,
@@ -4931,14 +4935,12 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 
 	/*
 	 * Conventional PCI and PCI-X we need to wait Tpvrh + Trhfa before
-	 * accessing the device after reset (that is 1000 ms + 100 ms). In
-	 * practice this should not be needed because we don't do power
-	 * management for them (see pci_bridge_d3_possible()).
+	 * accessing the device after reset (that is 1000 ms + 100 ms).
 	 */
 	if (!pci_is_pcie(dev)) {
 		pci_dbg(dev, "waiting %d ms for secondary bus\n", 1000 + delay);
 		msleep(1000 + delay);
-		return;
+		return 0;
 	}
 
 	/*
@@ -4955,11 +4957,11 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	 * configuration requests if we only wait for 100 ms (see
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=203885).
 	 *
-	 * Therefore we wait for 100 ms and check for the device presence.
-	 * If it is still not present give it an additional 100 ms.
+	 * Therefore we wait for 100 ms and check for the device presence
+	 * until the timeout expires.
 	 */
 	if (!pcie_downstream_port(dev))
-		return;
+		return 0;
 
 	if (pcie_get_speed_cap(dev) <= PCIE_SPEED_5_0GT) {
 		pci_dbg(dev, "waiting %d ms for downstream link\n", delay);
@@ -4970,14 +4972,11 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 		if (!pcie_wait_for_link_delay(dev, true, delay)) {
 			/* Did not train, no need to wait any further */
 			pci_info(dev, "Data Link Layer Link Active not set in 1000 msec\n");
-			return;
+			return -ENOTTY;
 		}
 	}
 
-	if (!pci_device_is_present(child)) {
-		pci_dbg(child, "waiting additional %d ms to become accessible\n", delay);
-		msleep(delay);
-	}
+	return pci_dev_wait(child, reset_type, timeout - delay);
 }
 
 void pci_reset_secondary_bus(struct pci_dev *dev)
@@ -4996,15 +4995,6 @@ void pci_reset_secondary_bus(struct pci_dev *dev)
 
 	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
-
-	/*
-	 * Trhfa for conventional PCI is 2^25 clock cycles.
-	 * Assuming a minimum 33MHz clock this results in a 1s
-	 * delay before we can consider subordinate devices to
-	 * be re-initialized.  PCIe has some ways to shorten this,
-	 * but we don't make use of them yet.
-	 */
-	ssleep(1);
 }
 
 void __weak pcibios_reset_secondary_bus(struct pci_dev *dev)
@@ -5023,7 +5013,8 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 {
 	pcibios_reset_secondary_bus(dev);
 
-	return pci_dev_wait(dev, "bus reset", PCIE_RESET_READY_POLL_MS);
+	return pci_bridge_wait_for_secondary_bus(dev, "bus reset",
+						 PCIE_RESET_READY_POLL_MS);
 }
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 739e416b0db2..72280e9b23b2 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -63,6 +63,19 @@ struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
 #define PCI_PM_D3HOT_WAIT       10	/* msec */
 #define PCI_PM_D3COLD_WAIT      100	/* msec */
 
+/*
+ * Following exit from Conventional Reset, devices must be ready within 1 sec
+ * (PCIe r6.0 sec 6.6.1).  A D3cold to D0 transition implies a Conventional
+ * Reset (PCIe r6.0 sec 5.8).
+ */
+#define PCI_RESET_WAIT		1000	/* msec */
+/*
+ * Devices may extend the 1 sec period through Request Retry Status completions
+ * (PCIe r6.0 sec 2.3.1).  The spec does not provide an upper limit, but 60 sec
+ * ought to be enough for any device to become responsive.
+ */
+#define PCIE_RESET_READY_POLL_MS 60000	/* msec */
+
 /**
  * struct pci_platform_pm_ops - Firmware PM callbacks
  *
@@ -124,7 +137,8 @@ void pci_msi_init(struct pci_dev *dev);
 void pci_msix_init(struct pci_dev *dev);
 bool pci_bridge_d3_possible(struct pci_dev *dev);
 void pci_bridge_d3_update(struct pci_dev *dev);
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev);
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index c556e7beafe3..f21d64ae4ffc 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -170,8 +170,8 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
-	if (!pcie_wait_for_link(pdev, true)) {
-		pci_info(pdev, "Data Link Layer Link Active not set in 1000 msec\n");
+	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC",
+					      PCIE_RESET_READY_POLL_MS)) {
 		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
 		ret = PCI_ERS_RESULT_DISCONNECT;
 	} else {
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 28b201c44326..7dc42d0e2a0d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -322,9 +322,6 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	/* In case scsi_remove_host() has not been called. */
-	scsi_proc_hostdir_rm(shost->hostt);
-
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e5ecd6ada6cd..e8a4750f6ec4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -785,7 +785,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
-	if ((sas_port_add(port))) {
+	if (!port || (sas_port_add(port))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
 		goto out_fail;
@@ -824,6 +824,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			    mpt3sas_port->remote_identify.sas_address;
 	}
 
+	if (!rphy) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		goto out_delete_port;
+	}
+
 	rphy->identify = mpt3sas_port->remote_identify;
 
 	if ((sas_rphy_add(rphy))) {
@@ -831,6 +837,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			__FILE__, __LINE__, __func__);
 		sas_rphy_free(rphy);
 		rphy = NULL;
+		goto out_delete_port;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -857,7 +864,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    rphy_to_expander_device(rphy), hba_port->port_id);
 	return mpt3sas_port;
 
- out_fail:
+out_delete_port:
+	sas_port_delete(port);
+
+out_fail:
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index f8e99995eee9..d94c3811a8f7 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -106,8 +106,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 
diff --git a/drivers/tty/serial/8250/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
index af74f82ad782..6a22f3a970f3 100644
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -38,7 +38,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 
 	iir = port->serial_in(port, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 0;
 	}
 
@@ -46,7 +46,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 	if (unlikely(up->lsr_saved_flags & UART_LSR_BI)) {
 		up->lsr_saved_flags &= ~UART_LSR_BI;
 		port->serial_in(port, UART_RX);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 1;
 	}
 
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 8a1d5c5d4c09..e1ff109d7a14 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2201,9 +2201,15 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* wait transmit engin complete */
-	lpuart32_write(&sport->port, 0, UARTMODIR);
-	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so skip waiting for transmission complete when UARTCTRL_SBK is
+	 * asserted.
+	 */
+	if (!(old_ctrl & UARTCTRL_SBK)) {
+		lpuart32_write(&sport->port, 0, UARTMODIR);
+		lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	}
 
 	/* disable transmit and receive */
 	lpuart32_write(&sport->port, old_ctrl & ~(UARTCTRL_TE | UARTCTRL_RE),
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 4d9e3fdae5f6..3ccefa58e405 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -65,6 +65,7 @@ static void vdpasim_vq_notify(struct vringh *vring)
 static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	uint16_t last_avail_idx = vq->vring.last_avail_idx;
 
 	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
@@ -73,6 +74,18 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (struct vring_used *)
 			  (uintptr_t)vq->device_addr);
 
+	vq->vring.last_avail_idx = last_avail_idx;
+
+	/*
+	 * Since vdpa_sim does not support receive inflight descriptors as a
+	 * destination of a migration, let's set both avail_idx and used_idx
+	 * the same at vq start.  This is how vhost-user works in a
+	 * VHOST_SET_VRING_BASE call.
+	 *
+	 * Although the simple fix is to set last_used_idx at
+	 * vdpasim_set_vq_state, it would be reset at vdpasim_queue_ready.
+	 */
+	vq->vring.last_used_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 3feb6e40d56d..ef8a4c5fc687 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -921,6 +921,28 @@ SETUP_HCRX(struct stifb_info *fb)
 
 /* ------------------- driver specific functions --------------------------- */
 
+static int
+stifb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (var->xres != fb->info.var.xres ||
+	    var->yres != fb->info.var.yres ||
+	    var->bits_per_pixel != fb->info.var.bits_per_pixel)
+		return -EINVAL;
+
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+	var->xoffset = 0;
+	var->yoffset = 0;
+	var->grayscale = fb->info.var.grayscale;
+	var->red.length = fb->info.var.red.length;
+	var->green.length = fb->info.var.green.length;
+	var->blue.length = fb->info.var.blue.length;
+
+	return 0;
+}
+
 static int
 stifb_setcolreg(u_int regno, u_int red, u_int green,
 	      u_int blue, u_int transp, struct fb_info *info)
@@ -1145,6 +1167,7 @@ stifb_init_display(struct stifb_info *fb)
 
 static const struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_check_var	= stifb_check_var,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
 	.fb_fillrect	= stifb_fillrect,
@@ -1164,6 +1187,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	struct stifb_info *fb;
 	struct fb_info *info;
 	unsigned long sti_rom_address;
+	char modestr[32];
 	char *dev_name;
 	int bpp, xres, yres;
 
@@ -1342,6 +1366,9 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	info->flags = FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
+	scnprintf(modestr, sizeof(modestr), "%dx%d-%d", xres, yres, bpp);
+	fb_find_mode(&info->var, info, modestr, NULL, 0, NULL, bpp);
+
 	/* This has to be done !!! */
 	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
 		goto out_err1;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index f3e49ef457db..20e9d1bcd96b 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -223,15 +223,32 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[0] = 8; /* sizeof __le64 */
 		data[0] = ptr;
 
-		rc = SMB2_set_info_init(tcon, server,
-					&rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_END_OF_FILE_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
+		if (cfile) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						cfile->fid.persistent_fid,
+						cfile->fid.volatile_fid,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+		} else {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMPOUND_FID,
+						COMPOUND_FID,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 514056605fa7..49b7edbe3497 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -299,7 +299,7 @@ static int
 __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		struct smb_rqst *rqst)
 {
-	int rc = 0;
+	int rc;
 	struct kvec *iov;
 	int n_vec;
 	unsigned int send_length = 0;
@@ -310,6 +310,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
+	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
 		rc = -EAGAIN;
@@ -318,14 +319,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		goto smbd_done;
 	}
 
+	rc = -EAGAIN;
 	if (ssocket == NULL)
-		return -EAGAIN;
+		goto out;
 
+	rc = -ERESTARTSYS;
 	if (fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
-		return -ERESTARTSYS;
+		goto out;
 	}
 
+	rc = 0;
 	/* cork the socket */
 	tcp_sock_set_cork(ssocket->sk, true);
 
@@ -438,7 +442,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			 rc);
 	else if (rc > 0)
 		rc = 0;
-
+out:
+	cifs_in_send_dec(server);
 	return rc;
 }
 
@@ -855,9 +860,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(mid);
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, 1, rqst, flags);
-	cifs_in_send_dec(server);
 
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
@@ -1149,9 +1152,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			midQ[i]->callback = cifs_compound_last_callback;
 	}
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
-	cifs_in_send_dec(server);
 
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
@@ -1388,9 +1389,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -1527,9 +1526,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b2600e8021b1..a39d5cca4121 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4636,13 +4636,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
 
-	if ((ino == EXT4_ROOT_INO) && (raw_inode->i_links_count == 0)) {
-		ext4_error_inode(inode, function, line, 0,
-				 "iget: root inode unallocated");
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
-	}
-
 	if ((flags & EXT4_IGET_HANDLE) &&
 	    (raw_inode->i_links_count == 0) && (raw_inode->i_mode == 0)) {
 		ret = -ESTALE;
@@ -4715,11 +4708,16 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	 * NeilBrown 1999oct15
 	 */
 	if (inode->i_nlink == 0) {
-		if ((inode->i_mode == 0 ||
+		if ((inode->i_mode == 0 || flags & EXT4_IGET_SPECIAL ||
 		     !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
 		    ino != EXT4_BOOT_LOADER_INO) {
-			/* this inode is deleted */
-			ret = -ESTALE;
+			/* this inode is deleted or unallocated */
+			if (flags & EXT4_IGET_SPECIAL) {
+				ext4_error_inode(inode, function, line, 0,
+						 "iget: special inode unallocated");
+				ret = -EFSCORRUPTED;
+			} else
+				ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c79c61002a62..0c47e1e3cba4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3898,10 +3898,8 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 				goto end_rename;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval) {
-			inode_unlock(old.inode);
+		if (retval)
 			goto end_rename;
-		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 802ca160d31e..6df4da084190 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5385,8 +5385,11 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!really_read_only && journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		es->s_journal_dev = cpu_to_le32(journal_devnum);
-
-		/* Make sure we flush the recovery flag to disk. */
+		ext4_commit_super(sb);
+	}
+	if (!really_read_only && journal_inum &&
+	    journal_inum != le32_to_cpu(es->s_journal_inum)) {
+		es->s_journal_inum = cpu_to_le32(journal_inum);
 		ext4_commit_super(sb);
 	}
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index bfcbfe2788bd..7ef49e4b1c17 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -386,6 +386,17 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	struct inode *inode;
 	int err;
 
+	/*
+	 * We have to check for this corruption early as otherwise
+	 * iget_locked() could wait indefinitely for the state of our
+	 * parent inode.
+	 */
+	if (parent->i_ino == ea_ino) {
+		ext4_error(parent->i_sb,
+			   "Parent and EA inode have the same ino %lu", ea_ino);
+		return -EFSCORRUPTED;
+	}
+
 	inode = ext4_iget(parent->i_sb, ea_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index bd7d58d27bfc..97a3c09fd96b 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -138,19 +138,18 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	pgoff_t index = pos >> PAGE_SHIFT;
-	uint32_t pageofs = index << PAGE_SHIFT;
 	int ret = 0;
 
 	jffs2_dbg(1, "%s()\n", __func__);
 
-	if (pageofs > inode->i_size) {
-		/* Make new hole frag from old EOF to new page */
+	if (pos > inode->i_size) {
+		/* Make new hole frag from old EOF to new position */
 		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
 
-		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
-			  (unsigned int)inode->i_size, pageofs);
+		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new position\n",
+			  (unsigned int)inode->i_size, (uint32_t)pos);
 
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
@@ -170,10 +169,10 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ri.mode = cpu_to_jemode(inode->i_mode);
 		ri.uid = cpu_to_je16(i_uid_read(inode));
 		ri.gid = cpu_to_je16(i_gid_read(inode));
-		ri.isize = cpu_to_je32(max((uint32_t)inode->i_size, pageofs));
+		ri.isize = cpu_to_je32((uint32_t)pos);
 		ri.atime = ri.ctime = ri.mtime = cpu_to_je32(JFFS2_NOW());
 		ri.offset = cpu_to_je32(inode->i_size);
-		ri.dsize = cpu_to_je32(pageofs - inode->i_size);
+		ri.dsize = cpu_to_je32((uint32_t)pos - inode->i_size);
 		ri.csize = cpu_to_je32(0);
 		ri.compr = JFFS2_COMPR_ZERO;
 		ri.node_crc = cpu_to_je32(crc32(0, &ri, sizeof(ri)-8));
@@ -203,7 +202,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			goto out_err;
 		}
 		jffs2_complete_reservation(c);
-		inode->i_size = pageofs;
+		inode->i_size = pos;
 		mutex_unlock(&f->sem);
 	}
 
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 1648ce265cba..c84783cd5abd 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -447,11 +447,11 @@ struct drm_bridge_funcs {
 	 *
 	 * The returned array must be allocated with kmalloc() and will be
 	 * freed by the caller. If the allocation fails, NULL should be
-	 * returned. num_output_fmts must be set to the returned array size.
+	 * returned. num_input_fmts must be set to the returned array size.
 	 * Formats listed in the returned array should be listed in decreasing
 	 * preference order (the core will try all formats until it finds one
 	 * that works). When the format is not supported NULL should be
-	 * returned and num_output_fmts should be set to 0.
+	 * returned and num_input_fmts should be set to 0.
 	 *
 	 * This method is called on all elements of the bridge chain as part of
 	 * the bus format negotiation process that happens in
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3cfbffd94a05..c3478e396829 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -805,6 +805,7 @@ struct hid_driver {
  * @output_report: send output report to device
  * @idle: send idle request to device
  * @may_wakeup: return if device may act as a wakeup source during system-suspend
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -830,6 +831,8 @@ struct hid_ll_driver {
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 	bool (*may_wakeup)(struct hid_device *hdev);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3a75d644a120..5b6c38f74807 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -275,9 +275,11 @@ struct hh_cache {
  * relationship HH alignment <= LL alignment.
  */
 #define LL_RESERVED_SPACE(dev) \
-	((((dev)->hard_header_len+(dev)->needed_headroom)&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 #define LL_RESERVED_SPACE_EXTRA(dev,extra) \
-	((((dev)->hard_header_len+(dev)->needed_headroom+(extra))&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom) + (extra)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 
 struct header_ops {
 	int	(*create) (struct sk_buff *skb, struct net_device *dev,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 34dd24c99180..7e471432a998 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1390,6 +1390,7 @@ void pci_bus_add_resource(struct pci_bus *bus, struct resource *res,
 			  unsigned int flags);
 struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n);
 void pci_bus_remove_resources(struct pci_bus *bus);
+void pci_bus_remove_resource(struct pci_bus *bus, struct resource *res);
 int devm_request_pci_bus_resources(struct device *dev,
 				   struct list_head *resources);
 
diff --git a/include/linux/sh_intc.h b/include/linux/sh_intc.h
index c255273b0281..37ad81058d6a 100644
--- a/include/linux/sh_intc.h
+++ b/include/linux/sh_intc.h
@@ -97,7 +97,10 @@ struct intc_hw_desc {
 	unsigned int nr_subgroups;
 };
 
-#define _INTC_ARRAY(a) a, __same_type(a, NULL) ? 0 : sizeof(a)/sizeof(*a)
+#define _INTC_SIZEOF_OR_ZERO(a) (_Generic(a,                 \
+                                 typeof(NULL):  0,           \
+                                 default:       sizeof(a)))
+#define _INTC_ARRAY(a) a, _INTC_SIZEOF_OR_ZERO(a)/sizeof(*a)
 
 #define INTC_HW_DESC(vectors, groups, mask_regs,	\
 		     prio_regs,	sense_regs, ack_regs)	\
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 28031b15f878..cd01da18e405 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -231,12 +231,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  *
- * When lockdep is enabled, we make sure to always do the RCU portions of
- * the tracepoint code, regardless of whether tracing is on. However,
- * don't check if the condition is false, due to interaction with idle
- * instrumentation. This lets us find RCU issues triggered with tracepoints
- * even when this tracepoint is off. This code has no purpose other than
- * poking RCU a bit.
+ * When lockdep is enabled, we make sure to always test if RCU is
+ * "watching" regardless if the tracepoint is enabled or not. Tracepoints
+ * require RCU to be active, and it should always warn at the tracepoint
+ * site if it is not watching, as it will need to be active when the
+ * tracepoint is enabled.
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto)		\
 	extern int __traceiter_##name(data_proto);			\
@@ -249,9 +248,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 				TP_ARGS(args),				\
 				TP_CONDITION(cond), 0);			\
 		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
-			rcu_read_lock_sched_notrace();			\
-			rcu_dereference_sched(__tracepoint_##name.funcs);\
-			rcu_read_unlock_sched_notrace();		\
+			WARN_ON_ONCE(!rcu_is_watching());		\
 		}							\
 	}								\
 	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ed17850b3c51..2d6f275d180e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5937,10 +5937,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return IO_APOLL_ABORTED;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8795036202a..d2b415820183 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2252,7 +2252,7 @@ static void perf_group_detach(struct perf_event *event)
 		/* Inherit group flags from the previous leader */
 		sibling->group_caps = event->group_caps;
 
-		if (!RB_EMPTY_NODE(&event->group_node)) {
+		if (sibling->attach_state & PERF_ATTACH_CONTEXT) {
 			add_event_to_groups(sibling, event->ctx);
 
 			if (sibling->state == PERF_EVENT_STATE_ACTIVE)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 731f25a40968..a3a15fe90e0a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1538,7 +1538,8 @@ static struct dyn_ftrace *lookup_rec(unsigned long start, unsigned long end)
 	key.flags = end;	/* overload flags, as it is unsigned long */
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		if (end < pg->records[0].ip ||
+		if (pg->index == 0 ||
+		    end < pg->records[0].ip ||
 		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
 			continue;
 		rec = bsearch(&key, pg->records, pg->index,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 161ffc56afa3..83e2d1195fa4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5093,6 +5093,8 @@ loff_t tracing_lseek(struct file *file, loff_t offset, int whence)
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.write		= tracing_write_stub,
 	.llseek		= tracing_lseek,
 	.release	= tracing_release,
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index aaf779ee68a6..80e65287294c 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1127,6 +1127,9 @@ static const char *hist_field_name(struct hist_field *field,
 {
 	const char *field_name = "";
 
+	if (WARN_ON_ONCE(!field))
+		return field_name;
+
 	if (level > 1)
 		return field_name;
 
diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index d0a730d99a33..11f32e947c45 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -588,9 +588,6 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 	 */
 	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 
-	for_each_online_cpu(cpu)
-		per_cpu(hwlat_per_cpu_data, cpu).kthread = NULL;
-
 	for_each_cpu(cpu, current_mask) {
 		retval = start_cpu_kthread(cpu);
 		if (retval)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 100f46dd79bf..98ff57c8eda6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1926,7 +1926,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
-	pmd_t _pmd;
+	pmd_t _pmd, old_pmd;
 	int i;
 
 	/*
@@ -1937,7 +1937,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	 *
 	 * See Documentation/vm/mmu_notifier.rst
 	 */
-	pmdp_huge_clear_flush(vma, haddr, pmd);
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -1946,6 +1946,8 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		pte_t *pte, entry;
 		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
+		if (pmd_uffd_wp(old_pmd))
+			entry = pte_mkuffd_wp(entry);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
diff --git a/net/9p/client.c b/net/9p/client.c
index 08e0c9990af0..c4c1e44cd7ca 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1315,7 +1315,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
-	ofid->mode = mode;
+	ofid->mode = flags;
 	ofid->iounit = iounit;
 
 free_and_error:
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 75c88d486327..c21d57f02c65 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -573,6 +573,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index fe9101d3d69e..426dc910aaf8 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -613,10 +613,10 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
-	if (headroom > dev->needed_headroom)
-		dev->needed_headroom = headroom;
+	if (headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		goto tx_dropped;
 	}
@@ -797,10 +797,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 33ba1268a111..1f39b56bbab3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3610,7 +3610,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write((__be32 *)(th + 1), NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
-	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Okay, we have all we need - do the md5 hash if needed */
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index ea5077942871..bc5d3188454d 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1237,8 +1237,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	 */
 	max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
 			+ dst->header_len + t->hlen;
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index f3343a8541a5..8efc369934fc 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -83,7 +83,7 @@ struct iucv_irq_data {
 	u16 ippathid;
 	u8  ipflags1;
 	u8  iptype;
-	u32 res2[8];
+	u32 res2[9];
 };
 
 struct iucv_irq_list {
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 3a1e8f238866..935f35175174 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -886,9 +886,13 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	return ret;
 }
 
+static struct lock_class_key mptcp_slock_keys[2];
+static struct lock_class_key mptcp_keys[2];
+
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	bool is_ipv6 = sk->sk_family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct socket *ssock;
@@ -907,6 +911,18 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 		goto out;
 	}
 
+	/* The subflow socket lock is acquired in a nested to the msk one
+	 * in several places, even by the TCP stack, and this msk is a kernel
+	 * socket: lockdep complains. Instead of propagating the _nested
+	 * modifiers in several places, re-init the lock class for the msk
+	 * socket to an mptcp specific one.
+	 */
+	sock_lock_init_class_and_name(newsk,
+				      is_ipv6 ? "mlock-AF_INET6" : "mlock-AF_INET",
+				      &mptcp_slock_keys[is_ipv6],
+				      is_ipv6 ? "msk_lock-AF_INET6" : "msk_lock-AF_INET",
+				      &mptcp_keys[is_ipv6]);
+
 	lock_sock(newsk);
 	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
 	release_sock(newsk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b0e9548f00bf..232f437770a6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -358,7 +358,6 @@ void mptcp_subflow_reset(struct sock *ssk)
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
-	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
@@ -514,7 +513,7 @@ static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
-static struct proto tcpv6_prot_override;
+static struct proto tcpv6_prot_override __ro_after_init;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -817,7 +816,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 }
 
 static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
-static struct proto tcp_prot_override;
+static struct proto tcp_prot_override __ro_after_init;
 
 enum mapping_status {
 	MAPPING_OK,
@@ -1316,6 +1315,13 @@ static void subflow_error_report(struct sock *ssk)
 {
 	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
 
+	/* bail early if this is a no-op, so that we avoid introducing a
+	 * problematic lockdep dependency between TCP accept queue lock
+	 * and msk socket spinlock
+	 */
+	if (!sk->sk_socket)
+		return;
+
 	mptcp_data_lock(sk);
 	if (!sock_owned_by_user(sk))
 		__mptcp_error_report(sk);
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9953e8053753..1818dbf089ca 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -43,7 +43,7 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 			 const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
-	u32 plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	u32 plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index db8f9116eeb4..cd4eb4996aff 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -226,7 +226,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index ba09890dddb5..e64f531d66cf 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -48,7 +48,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
@@ -232,7 +232,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 5d180d24cbf1..41b23f71c29a 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -104,6 +104,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	union smc_host_cursor cfed;
 	int rc;
 
+	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
+		return -ENOBUFS;
+
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2eafefa15a1a..f08fcc50fad3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1297,7 +1297,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
 	/* cancel free_work sync, will terminate when lgr->freeing is set */
-	cancel_delayed_work_sync(&lgr->free_work);
+	cancel_delayed_work(&lgr->free_work);
 	lgr->terminating = 1;
 
 	/* kill remaining link group connections */
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 15132b080614..60f3ea5561dd 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2643,9 +2643,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		if (inner_mode == NULL)
 			goto error;
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
-			goto error;
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 4a828bca071e..797c8bad3837 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1124,10 +1124,12 @@ static void (*conf_changed_callback)(void);
 
 void conf_set_changed(bool val)
 {
-	if (conf_changed_callback && conf_changed != val)
-		conf_changed_callback();
+	bool changed = conf_changed != val;
 
 	conf_changed = val;
+
+	if (conf_changed_callback && changed)
+		conf_changed_callback();
 }
 
 bool conf_get_changed(void)
diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 4208fa8a4db5..513eadcc38d9 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -376,6 +376,15 @@ static const struct config_entry config_table[] = {
 	},
 #endif
 
+/* Meteor Lake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_METEORLAKE)
+	/* Meteorlake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x7e28,
+	},
+#endif
+
 };
 
 static const struct config_entry *snd_intel_dsp_find_config
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c8042eb703c3..5fce1ca8a393 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -331,14 +331,15 @@ enum {
 #define needs_eld_notify_link(chip)	false
 #endif
 
-#define CONTROLLER_IN_GPU(pci) (((pci)->device == 0x0a0c) || \
+#define CONTROLLER_IN_GPU(pci) (((pci)->vendor == 0x8086) &&         \
+				       (((pci)->device == 0x0a0c) || \
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
 					((pci)->device == 0x490d) || \
 					((pci)->device == 0x4f90) || \
 					((pci)->device == 0x4f91) || \
-					((pci)->device == 0x4f92))
+					((pci)->device == 0x4f92)))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0f7dbfe547f9..21ad6f9e59b0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9166,6 +9166,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 2b5d6ff87373..2d84c7a0be6b 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -59,6 +59,8 @@ class devlink_ports(object):
         assert stderr == ""
         ports = json.loads(stdout)['port']
 
+        validate_devlink_output(ports, 'flavour')
+
         for port in ports:
             if dev in port:
                 if ports[port]['flavour'] == 'physical':
@@ -220,6 +222,27 @@ def split_splittable_port(port, k, lanes, dev):
     unsplit(port.bus_info)
 
 
+def validate_devlink_output(devlink_data, target_property=None):
+    """
+    Determine if test should be skipped by checking:
+      1. devlink_data contains values
+      2. The target_property exist in devlink_data
+    """
+    skip_reason = None
+    if any(devlink_data.values()):
+        if target_property:
+            skip_reason = "{} not found in devlink output, test skipped".format(target_property)
+            for key in devlink_data:
+                if target_property in devlink_data[key]:
+                    skip_reason = None
+    else:
+        skip_reason = 'devlink output is empty, test skipped'
+
+    if skip_reason:
+        print(skip_reason)
+        sys.exit(KSFT_SKIP)
+
+
 def make_parser():
     parser = argparse.ArgumentParser(description='A test for port splitting.')
     parser.add_argument('--dev',
@@ -240,12 +263,9 @@ def main(cmdline=None):
         stdout, stderr = run_command(cmd)
         assert stderr == ""
 
+        validate_devlink_output(json.loads(stdout))
         devs = json.loads(stdout)['dev']
-        if devs:
-            dev = list(devs.keys())[0]
-        else:
-            print("no devlink device was found, test skipped")
-            sys.exit(KSFT_SKIP)
+        dev = list(devs.keys())[0]
 
     cmd = "devlink dev show %s" % dev
     stdout, stderr = run_command(cmd)
@@ -255,6 +275,7 @@ def main(cmdline=None):
 
     ports = devlink_ports(dev)
 
+    found_max_lanes = False
     for port in ports.if_names:
         max_lanes = get_max_lanes(port.name)
 
@@ -277,6 +298,11 @@ def main(cmdline=None):
                 split_splittable_port(port, lane, max_lanes, dev)
 
                 lane //= 2
+        found_max_lanes = True
+
+    if not found_max_lanes:
+        print(f"Test not started, no port of device {dev} reports max_lanes")
+        sys.exit(KSFT_SKIP)
 
 
 if __name__ == "__main__":
