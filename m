Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B71F511A3A
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiD0NPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 09:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiD0NPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 09:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12203DC59E;
        Wed, 27 Apr 2022 06:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB5961BC4;
        Wed, 27 Apr 2022 13:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CEFC385A9;
        Wed, 27 Apr 2022 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651065109;
        bh=WH3onmj8lATrQFh3z5JXvEURCwS0qOR+mIQBt14VQzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyjLfD2tlO8cbsB2Ch8HXUIegvu9yrCMi2EWFqz4UelBntSiABWZx2+hbm3ndOzcE
         BT3MshhFVULkga6be/VeV9hqWAyLFq92K7Fv8KUEhLK1Fj+naoo1SRM1UT/WZlsdAw
         9VEzaTesjGRrYWRGVJy968QYYOFsh5wKHGXZxSkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.36
Date:   Wed, 27 Apr 2022 15:11:36 +0200
Message-Id: <165106509613948@kroah.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <165106509613250@kroah.com>
References: <165106509613250@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/filesystems/ext4/attributes.rst b/Documentation/filesystems/ext4/attributes.rst
index 54386a010a8d..871d2da7a0a9 100644
--- a/Documentation/filesystems/ext4/attributes.rst
+++ b/Documentation/filesystems/ext4/attributes.rst
@@ -76,7 +76,7 @@ The beginning of an extended attribute block is in
      - Checksum of the extended attribute block.
    * - 0x14
      - \_\_u32
-     - h\_reserved[2]
+     - h\_reserved[3]
      - Zero.
 
 The checksum is calculated against the FS UUID, the 64-bit block number
diff --git a/Makefile b/Makefile
index e5440c513f5a..e0710f983784 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 35
+SUBLEVEL = 36
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index dd77a0c8f740..66ba549b520f 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -196,6 +196,7 @@ tracesys_exit:
 	st  r0, [sp, PT_r0]     ; sys call return value in pt_regs
 
 	;POST Sys Call Ptrace Hook
+	mov r0, sp		; pt_regs needed
 	bl  @syscall_trace_exit
 	b   ret_from_exception ; NOT ret_from_system_call at is saves r0 which
 	; we'd done before calling post hook above
diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 1da11bdb1dfb..1c6500c4e6a1 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -580,7 +580,7 @@ static int __init ve_spc_clk_init(void)
 		}
 
 		cluster = topology_physical_package_id(cpu_dev->id);
-		if (init_opp_table[cluster])
+		if (cluster < 0 || init_opp_table[cluster])
 			continue;
 
 		if (ve_init_opp_table(cpu_dev))
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1a18c9045773..8b6f090e0364 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -154,7 +154,6 @@ config ARM64
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
-	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_PREL32_RELOCATIONS
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
index 1dc9d187601c..a0bd540f27d3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
@@ -89,12 +89,12 @@ touchscreen@0 {
 		pendown-gpio = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
 		ti,x-min = /bits/ 16 <125>;
-		touchscreen-size-x = /bits/ 16 <4008>;
+		touchscreen-size-x = <4008>;
 		ti,y-min = /bits/ 16 <282>;
-		touchscreen-size-y = /bits/ 16 <3864>;
+		touchscreen-size-y = <3864>;
 		ti,x-plate-ohms = /bits/ 16 <180>;
-		touchscreen-max-pressure = /bits/ 16 <255>;
-		touchscreen-average-samples = /bits/ 16 <10>;
+		touchscreen-max-pressure = <255>;
+		touchscreen-average-samples = <10>;
 		ti,debounce-tol = /bits/ 16 <3>;
 		ti,debounce-rep = /bits/ 16 <1>;
 		ti,settle-delay-usec = /bits/ 16 <150>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
index b16c7caf34c1..87b5e23c766f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
@@ -70,12 +70,12 @@ touchscreen@0 {
 		pendown-gpio = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
 		ti,x-min = /bits/ 16 <125>;
-		touchscreen-size-x = /bits/ 16 <4008>;
+		touchscreen-size-x = <4008>;
 		ti,y-min = /bits/ 16 <282>;
-		touchscreen-size-y = /bits/ 16 <3864>;
+		touchscreen-size-y = <3864>;
 		ti,x-plate-ohms = /bits/ 16 <180>;
-		touchscreen-max-pressure = /bits/ 16 <255>;
-		touchscreen-average-samples = /bits/ 16 <10>;
+		touchscreen-max-pressure = <255>;
+		touchscreen-average-samples = <10>;
 		ti,debounce-tol = /bits/ 16 <3>;
 		ti,debounce-rep = /bits/ 16 <1>;
 		ti,settle-delay-usec = /bits/ 16 <150>;
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 495c15deacb7..de86ae3a7fd2 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1460,6 +1460,8 @@ ipa: ipa@1e40000 {
 					     "imem",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 692973c4f434..b795a9993cc1 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -615,6 +615,8 @@ ipa: ipa@1e40000 {
 			interconnect-names = "memory",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 3d32d5581816..9ffb7355850c 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -736,6 +736,8 @@ ipa: ipa@1e40000 {
 			interconnect-names = "memory",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index f98c91bbd7c1..993a27ea6f54 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -41,7 +41,6 @@ void tag_clear_highpage(struct page *to);
 
 typedef struct page *pgtable_t;
 
-int pfn_valid(unsigned long pfn);
 int pfn_is_map_memory(unsigned long pfn);
 
 #include <asm/memory.h>
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 08363d3cc1da..ed57717cd004 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -535,7 +535,7 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				 PMD_TYPE_TABLE)
 #define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 				 PMD_TYPE_SECT)
-#define pmd_leaf(pmd)		pmd_sect(pmd)
+#define pmd_leaf(pmd)		(pmd_present(pmd) && !pmd_table(pmd))
 #define pmd_bad(pmd)		(!pmd_table(pmd))
 
 #define pmd_leaf_size(pmd)	(pmd_cont(pmd) ? CONT_PMD_SIZE : PMD_SIZE)
@@ -625,7 +625,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		(!pud_table(pud))
 #define pud_present(pud)	pte_present(pud_pte(pud))
-#define pud_leaf(pud)		pud_sect(pud)
+#define pud_leaf(pud)		(pud_present(pud) && !pud_table(pud))
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index c59cb2efd554..3b269c756798 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -184,43 +184,6 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 	free_area_init(max_zone_pfns);
 }
 
-int pfn_valid(unsigned long pfn)
-{
-	phys_addr_t addr = PFN_PHYS(pfn);
-	struct mem_section *ms;
-
-	/*
-	 * Ensure the upper PAGE_SHIFT bits are clear in the
-	 * pfn. Else it might lead to false positives when
-	 * some of the upper bits are set, but the lower bits
-	 * match a valid pfn.
-	 */
-	if (PHYS_PFN(addr) != pfn)
-		return 0;
-
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-
-	ms = __pfn_to_section(pfn);
-	if (!valid_section(ms))
-		return 0;
-
-	/*
-	 * ZONE_DEVICE memory does not have the memblock entries.
-	 * memblock_is_map_memory() check for ZONE_DEVICE based
-	 * addresses will always fail. Even the normal hotplugged
-	 * memory will never have MEMBLOCK_NOMAP flag set in their
-	 * memblock entries. Skip memblock search for all non early
-	 * memory sections covering all of hotplug memory including
-	 * both normal and ZONE_DEVICE based.
-	 */
-	if (!early_section(ms))
-		return pfn_section_valid(ms, pfn);
-
-	return memblock_is_memory(addr);
-}
-EXPORT_SYMBOL(pfn_valid);
-
 int pfn_is_map_memory(unsigned long pfn)
 {
 	phys_addr_t addr = PFN_PHYS(pfn);
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 6365087f3160..3cb2e05a7ee8 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -421,13 +421,19 @@ static void kvmppc_tce_put(struct kvmppc_spapr_tce_table *stt,
 	tbl[idx % TCES_PER_PAGE] = tce;
 }
 
-static void kvmppc_clear_tce(struct mm_struct *mm, struct iommu_table *tbl,
-		unsigned long entry)
+static void kvmppc_clear_tce(struct mm_struct *mm, struct kvmppc_spapr_tce_table *stt,
+		struct iommu_table *tbl, unsigned long entry)
 {
-	unsigned long hpa = 0;
-	enum dma_data_direction dir = DMA_NONE;
+	unsigned long i;
+	unsigned long subpages = 1ULL << (stt->page_shift - tbl->it_page_shift);
+	unsigned long io_entry = entry << (stt->page_shift - tbl->it_page_shift);
+
+	for (i = 0; i < subpages; ++i) {
+		unsigned long hpa = 0;
+		enum dma_data_direction dir = DMA_NONE;
 
-	iommu_tce_xchg_no_kill(mm, tbl, entry, &hpa, &dir);
+		iommu_tce_xchg_no_kill(mm, tbl, io_entry + i, &hpa, &dir);
+	}
 }
 
 static long kvmppc_tce_iommu_mapped_dec(struct kvm *kvm,
@@ -486,6 +492,8 @@ static long kvmppc_tce_iommu_unmap(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -545,6 +553,8 @@ static long kvmppc_tce_iommu_map(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -591,10 +601,9 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_tce_iommu_map(vcpu->kvm, stt, stit->tbl,
 					entry, ua, dir);
 
-		iommu_tce_kill(stit->tbl, entry, 1);
 
 		if (ret != H_SUCCESS) {
-			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
+			kvmppc_clear_tce(vcpu->kvm->mm, stt, stit->tbl, entry);
 			goto unlock_exit;
 		}
 	}
@@ -670,13 +679,13 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		 */
 		if (get_user(tce, tces + i)) {
 			ret = H_TOO_HARD;
-			goto invalidate_exit;
+			goto unlock_exit;
 		}
 		tce = be64_to_cpu(tce);
 
 		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua)) {
 			ret = H_PARAMETER;
-			goto invalidate_exit;
+			goto unlock_exit;
 		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
@@ -685,19 +694,15 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 					iommu_tce_direction(tce));
 
 			if (ret != H_SUCCESS) {
-				kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl,
-						entry);
-				goto invalidate_exit;
+				kvmppc_clear_tce(vcpu->kvm->mm, stt, stit->tbl,
+						 entry + i);
+				goto unlock_exit;
 			}
 		}
 
 		kvmppc_tce_put(stt, entry + i, tce);
 	}
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill(stit->tbl, entry, npages);
-
 unlock_exit:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
@@ -736,20 +741,16 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				goto invalidate_exit;
+				return ret;
 
 			WARN_ON_ONCE(1);
-			kvmppc_clear_tce(vcpu->kvm->mm, stit->tbl, entry);
+			kvmppc_clear_tce(vcpu->kvm->mm, stt, stit->tbl, entry + i);
 		}
 	}
 
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill(stit->tbl, ioba >> stt->page_shift, npages);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_stuff_tce);
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 870b7f0c7ea5..fdeda6a9cff4 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -247,13 +247,19 @@ static void iommu_tce_kill_rm(struct iommu_table *tbl,
 		tbl->it_ops->tce_kill(tbl, entry, pages, true);
 }
 
-static void kvmppc_rm_clear_tce(struct kvm *kvm, struct iommu_table *tbl,
-		unsigned long entry)
+static void kvmppc_rm_clear_tce(struct kvm *kvm, struct kvmppc_spapr_tce_table *stt,
+		struct iommu_table *tbl, unsigned long entry)
 {
-	unsigned long hpa = 0;
-	enum dma_data_direction dir = DMA_NONE;
+	unsigned long i;
+	unsigned long subpages = 1ULL << (stt->page_shift - tbl->it_page_shift);
+	unsigned long io_entry = entry << (stt->page_shift - tbl->it_page_shift);
+
+	for (i = 0; i < subpages; ++i) {
+		unsigned long hpa = 0;
+		enum dma_data_direction dir = DMA_NONE;
 
-	iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, entry, &hpa, &dir);
+		iommu_tce_xchg_no_kill_rm(kvm->mm, tbl, io_entry + i, &hpa, &dir);
+	}
 }
 
 static long kvmppc_rm_tce_iommu_mapped_dec(struct kvm *kvm,
@@ -316,6 +322,8 @@ static long kvmppc_rm_tce_iommu_unmap(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill_rm(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -379,6 +387,8 @@ static long kvmppc_rm_tce_iommu_map(struct kvm *kvm,
 			break;
 	}
 
+	iommu_tce_kill_rm(tbl, io_entry, subpages);
+
 	return ret;
 }
 
@@ -420,10 +430,8 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm, stt,
 					stit->tbl, entry, ua, dir);
 
-		iommu_tce_kill_rm(stit->tbl, entry, 1);
-
 		if (ret != H_SUCCESS) {
-			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
+			kvmppc_rm_clear_tce(vcpu->kvm, stt, stit->tbl, entry);
 			return ret;
 		}
 	}
@@ -561,7 +569,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		ua = 0;
 		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua)) {
 			ret = H_PARAMETER;
-			goto invalidate_exit;
+			goto unlock_exit;
 		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
@@ -570,19 +578,15 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 					iommu_tce_direction(tce));
 
 			if (ret != H_SUCCESS) {
-				kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl,
-						entry);
-				goto invalidate_exit;
+				kvmppc_rm_clear_tce(vcpu->kvm, stt, stit->tbl,
+						entry + i);
+				goto unlock_exit;
 			}
 		}
 
 		kvmppc_rm_tce_put(stt, entry + i, tce);
 	}
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill_rm(stit->tbl, entry, npages);
-
 unlock_exit:
 	if (!prereg)
 		arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
@@ -620,20 +624,16 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 				continue;
 
 			if (ret == H_TOO_HARD)
-				goto invalidate_exit;
+				return ret;
 
 			WARN_ON_ONCE_RM(1);
-			kvmppc_rm_clear_tce(vcpu->kvm, stit->tbl, entry);
+			kvmppc_rm_clear_tce(vcpu->kvm, stt, stit->tbl, entry + i);
 		}
 	}
 
 	for (i = 0; i < npages; ++i, ioba += (1ULL << stt->page_shift))
 		kvmppc_rm_tce_put(stt, ioba >> stt->page_shift, tce_value);
 
-invalidate_exit:
-	list_for_each_entry_lockless(stit, &stt->iommu_tables, next)
-		iommu_tce_kill_rm(stit->tbl, ioba >> stt->page_shift, npages);
-
 	return ret;
 }
 
diff --git a/arch/powerpc/perf/power10-pmu.c b/arch/powerpc/perf/power10-pmu.c
index 9dd75f385837..07ca62d084d9 100644
--- a/arch/powerpc/perf/power10-pmu.c
+++ b/arch/powerpc/perf/power10-pmu.c
@@ -91,8 +91,8 @@ extern u64 PERF_REG_EXTENDED_MASK;
 
 /* Table of alternatives, sorted by column 0 */
 static const unsigned int power10_event_alternatives[][MAX_ALT] = {
-	{ PM_CYC_ALT,			PM_CYC },
 	{ PM_INST_CMPL_ALT,		PM_INST_CMPL },
+	{ PM_CYC_ALT,			PM_CYC },
 };
 
 static int power10_get_alternatives(u64 event, unsigned int flags, u64 alt[])
diff --git a/arch/powerpc/perf/power9-pmu.c b/arch/powerpc/perf/power9-pmu.c
index ff3382140d7e..cbdd074ee2a7 100644
--- a/arch/powerpc/perf/power9-pmu.c
+++ b/arch/powerpc/perf/power9-pmu.c
@@ -133,11 +133,11 @@ int p9_dd22_bl_ev[] = {
 
 /* Table of alternatives, sorted by column 0 */
 static const unsigned int power9_event_alternatives[][MAX_ALT] = {
-	{ PM_INST_DISP,			PM_INST_DISP_ALT },
-	{ PM_RUN_CYC_ALT,		PM_RUN_CYC },
-	{ PM_RUN_INST_CMPL_ALT,		PM_RUN_INST_CMPL },
-	{ PM_LD_MISS_L1,		PM_LD_MISS_L1_ALT },
 	{ PM_BR_2PATH,			PM_BR_2PATH_ALT },
+	{ PM_INST_DISP,			PM_INST_DISP_ALT },
+	{ PM_RUN_CYC_ALT,               PM_RUN_CYC },
+	{ PM_LD_MISS_L1,                PM_LD_MISS_L1_ALT },
+	{ PM_RUN_INST_CMPL_ALT,         PM_RUN_INST_CMPL },
 };
 
 static int power9_get_alternatives(u64 event, unsigned int flags, u64 alt[])
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 7516e4199b3c..20fd0acd7d80 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -28,15 +28,13 @@ typedef u16		compat_ipc_pid_t;
 typedef __kernel_fsid_t	compat_fsid_t;
 
 struct compat_stat {
-	compat_dev_t	st_dev;
-	u16		__pad1;
+	u32		st_dev;
 	compat_ino_t	st_ino;
 	compat_mode_t	st_mode;
 	compat_nlink_t	st_nlink;
 	__compat_uid_t	st_uid;
 	__compat_gid_t	st_gid;
-	compat_dev_t	st_rdev;
-	u16		__pad2;
+	u32		st_rdev;
 	u32		st_size;
 	u32		st_blksize;
 	u32		st_blocks;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a06d95165ac7..c206decb39fa 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -141,6 +141,15 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event || pmc->is_paused)
+		return;
+
+	perf_event_period(pmc->perf_event,
+			  get_sample_period(pmc, pmc->counter));
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 3faf1d9c6c91..f337ce7e898e 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -256,6 +256,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_update_sample_period(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 134c4ea5e6ad..c8c321225061 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1990,11 +1990,14 @@ static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
 				   unsigned long len)
 {
 	/*
-	 * If hardware enforced cache coherency for encrypted mappings of the
-	 * same physical page is supported, nothing to do.
+	 * If CPU enforced cache coherency for encrypted mappings of the
+	 * same physical page is supported, use CLFLUSHOPT instead. NOTE: cache
+	 * flush is still needed in order to work properly with DMA devices.
 	 */
-	if (boot_cpu_has(X86_FEATURE_SME_COHERENT))
+	if (boot_cpu_has(X86_FEATURE_SME_COHERENT)) {
+		clflush_cache_range(va, PAGE_SIZE);
 		return;
+	}
 
 	/*
 	 * If the VM Page Flush MSR is supported, use it to flush the page
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a0193b11c381..1546a10ecb56 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4601,6 +4601,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 	}
 
+	if (vmx->nested.update_vmcs01_apicv_status) {
+		vmx->nested.update_vmcs01_apicv_status = false;
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+	}
+
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7abe77c8b5d0..e7275ce15a8b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -439,15 +439,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 322485ab9271..16a660a0ed5f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4098,6 +4098,11 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (is_guest_mode(vcpu)) {
+		vmx->nested.update_vmcs01_apicv_status = true;
+		return;
+	}
+
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3f9c8548625d..460c7bd8158c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -164,6 +164,7 @@ struct nested_vmx {
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
+	bool update_vmcs01_apicv_status;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b1d2f656b45..75da9c0d5ae3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10813,8 +10813,21 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
-		if (kvm_apicv_activated(vcpu->kvm))
+
+		/*
+		 * Defer evaluating inhibits until the vCPU is first run, as
+		 * this vCPU will not get notified of any changes until this
+		 * vCPU is visible to other vCPUs (marked online and added to
+		 * the set of vCPUs).  Opportunistically mark APICv active as
+		 * VMX in particularly is highly unlikely to have inhibits.
+		 * Ignore the current per-VM APICv state so that vCPU creation
+		 * is guaranteed to run with a deterministic value, the request
+		 * will ensure the vCPU gets the correct state before VM-Entry.
+		 */
+		if (enable_apicv) {
 			vcpu->arch.apicv_active = true;
+			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+		}
 	} else
 		static_branch_inc(&kvm_has_noapic_vcpu);
 
diff --git a/arch/xtensa/kernel/coprocessor.S b/arch/xtensa/kernel/coprocessor.S
index 45cc0ae0af6f..c7b9f12896f2 100644
--- a/arch/xtensa/kernel/coprocessor.S
+++ b/arch/xtensa/kernel/coprocessor.S
@@ -29,7 +29,7 @@
 	.if XTENSA_HAVE_COPROCESSOR(x);					\
 		.align 4;						\
 	.Lsave_cp_regs_cp##x:						\
-		xchal_cp##x##_store a2 a4 a5 a6 a7;			\
+		xchal_cp##x##_store a2 a3 a4 a5 a6;			\
 		jx	a0;						\
 	.endif
 
@@ -46,7 +46,7 @@
 	.if XTENSA_HAVE_COPROCESSOR(x);					\
 		.align 4;						\
 	.Lload_cp_regs_cp##x:						\
-		xchal_cp##x##_load a2 a4 a5 a6 a7;			\
+		xchal_cp##x##_load a2 a3 a4 a5 a6;			\
 		jx	a0;						\
 	.endif
 
diff --git a/arch/xtensa/kernel/jump_label.c b/arch/xtensa/kernel/jump_label.c
index 0dde21e0d3de..ad1841cecdfb 100644
--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -40,7 +40,7 @@ static int patch_text_stop_machine(void *data)
 {
 	struct patch *patch = data;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		local_patch_text(patch->addr, patch->data, patch->sz);
 		atomic_inc(&patch->cpu_count);
 	} else {
diff --git a/block/bdev.c b/block/bdev.c
index 485a258b0ab3..18abafb135e0 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -184,14 +184,13 @@ int sb_min_blocksize(struct super_block *sb, int size)
 
 EXPORT_SYMBOL(sb_min_blocksize);
 
-int __sync_blockdev(struct block_device *bdev, int wait)
+int sync_blockdev_nowait(struct block_device *bdev)
 {
 	if (!bdev)
 		return 0;
-	if (!wait)
-		return filemap_flush(bdev->bd_inode->i_mapping);
-	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
+	return filemap_flush(bdev->bd_inode->i_mapping);
 }
+EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
 
 /*
  * Write out and wait upon all the dirty data associated with a block
@@ -199,7 +198,9 @@ int __sync_blockdev(struct block_device *bdev, int wait)
  */
 int sync_blockdev(struct block_device *bdev)
 {
-	return __sync_blockdev(bdev, 1);
+	if (!bdev)
+		return 0;
+	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
 }
 EXPORT_SYMBOL(sync_blockdev);
 
@@ -1016,7 +1017,7 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 }
 EXPORT_SYMBOL(__invalidate_device);
 
-void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
+void sync_bdevs(bool wait)
 {
 	struct inode *inode, *old_inode = NULL;
 
@@ -1047,8 +1048,19 @@ void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 		bdev = I_BDEV(inode);
 
 		mutex_lock(&bdev->bd_disk->open_mutex);
-		if (bdev->bd_openers)
-			func(bdev, arg);
+		if (!bdev->bd_openers) {
+			; /* skip */
+		} else if (wait) {
+			/*
+			 * We keep the error status of individual mapping so
+			 * that applications can catch the writeback error using
+			 * fsync(2). See filemap_fdatawait_keep_errors() for
+			 * details.
+			 */
+			filemap_fdatawait_keep_errors(inode->i_mapping);
+		} else {
+			filemap_fdatawrite(inode->i_mapping);
+		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
diff --git a/block/ioctl.c b/block/ioctl.c
index a31be7fa31a5..cd506a902963 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -645,7 +645,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			(bdev->bd_disk->bdi->ra_pages * PAGE_SIZE) / 512);
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
-		if ((size >> 9) > ~0UL)
+		if ((size >> 9) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(argp, size >> 9);
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 361597d14c56..d45a75bfc016 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -83,6 +83,8 @@ static int marvell_cable_detect(struct ata_port *ap)
 	switch(ap->port_no)
 	{
 	case 0:
+		if (!ap->ioaddr.bmdma_addr)
+			return ATA_CBL_PATA_UNK;
 		if (ioread8(ap->ioaddr.bmdma_addr + 1) & 1)
 			return ATA_CBL_PATA40;
 		return ATA_CBL_PATA80;
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 8177aed16006..177a537971a1 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1450,7 +1450,7 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 {
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
 	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
-	struct at_xdmac_desc	*desc, *_desc;
+	struct at_xdmac_desc	*desc, *_desc, *iter;
 	struct list_head	*descs_list;
 	enum dma_status		ret;
 	int			residue, retry;
@@ -1565,11 +1565,13 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	 * microblock.
 	 */
 	descs_list = &desc->descs_list;
-	list_for_each_entry_safe(desc, _desc, descs_list, desc_node) {
-		dwidth = at_xdmac_get_dwidth(desc->lld.mbr_cfg);
-		residue -= (desc->lld.mbr_ubc & 0xffffff) << dwidth;
-		if ((desc->lld.mbr_nda & 0xfffffffc) == cur_nda)
+	list_for_each_entry_safe(iter, _desc, descs_list, desc_node) {
+		dwidth = at_xdmac_get_dwidth(iter->lld.mbr_cfg);
+		residue -= (iter->lld.mbr_ubc & 0xffffff) << dwidth;
+		if ((iter->lld.mbr_nda & 0xfffffffc) == cur_nda) {
+			desc = iter;
 			break;
+		}
 	}
 	residue += cur_ubc << dwidth;
 
diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index 329fc2e57b70..b5b8f8181e77 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -415,8 +415,11 @@ void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 			  (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));
 		/* Linked list */
 		#ifdef CONFIG_64BIT
-			SET_CH_64(dw, chan->dir, chan->id, llp.reg,
-				  chunk->ll_region.paddr);
+			/* llp is not aligned on 64bit -> keep 32bit accesses */
+			SET_CH_32(dw, chan->dir, chan->id, llp.lsb,
+				  lower_32_bits(chunk->ll_region.paddr));
+			SET_CH_32(dw, chan->dir, chan->id, llp.msb,
+				  upper_32_bits(chunk->ll_region.paddr));
 		#else /* CONFIG_64BIT */
 			SET_CH_32(dw, chan->dir, chan->id, llp.lsb,
 				  lower_32_bits(chunk->ll_region.paddr));
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 7bd9ac1e93b2..e622245c9380 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -406,7 +406,6 @@ static void idxd_wq_device_reset_cleanup(struct idxd_wq *wq)
 {
 	lockdep_assert_held(&wq->wq_lock);
 
-	idxd_wq_disable_cleanup(wq);
 	wq->size = 0;
 	wq->group = NULL;
 }
@@ -723,14 +722,17 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 
 		if (wq->state == IDXD_WQ_ENABLED) {
 			idxd_wq_disable_cleanup(wq);
-			idxd_wq_device_reset_cleanup(wq);
 			wq->state = IDXD_WQ_DISABLED;
 		}
+		idxd_wq_device_reset_cleanup(wq);
 	}
 }
 
 void idxd_device_clear_state(struct idxd_device *idxd)
 {
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return;
+
 	idxd_groups_clear_state(idxd);
 	idxd_engines_clear_state(idxd);
 	idxd_device_wqs_clear_state(idxd);
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 999ce13a93ad..33d94c67fedb 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -842,6 +842,9 @@ static ssize_t wq_max_transfer_size_store(struct device *dev, struct device_attr
 	u64 xfer_size;
 	int rc;
 
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return -EPERM;
+
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
@@ -876,6 +879,9 @@ static ssize_t wq_max_batch_size_store(struct device *dev, struct device_attribu
 	u64 batch_size;
 	int rc;
 
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return -EPERM;
+
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index cacc725ca545..2300d965a3f4 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -198,12 +198,12 @@ struct sdma_script_start_addrs {
 	s32 per_2_firi_addr;
 	s32 mcu_2_firi_addr;
 	s32 uart_2_per_addr;
-	s32 uart_2_mcu_ram_addr;
+	s32 uart_2_mcu_addr;
 	s32 per_2_app_addr;
 	s32 mcu_2_app_addr;
 	s32 per_2_per_addr;
 	s32 uartsh_2_per_addr;
-	s32 uartsh_2_mcu_ram_addr;
+	s32 uartsh_2_mcu_addr;
 	s32 per_2_shp_addr;
 	s32 mcu_2_shp_addr;
 	s32 ata_2_mcu_addr;
@@ -232,8 +232,8 @@ struct sdma_script_start_addrs {
 	s32 mcu_2_ecspi_addr;
 	s32 mcu_2_sai_addr;
 	s32 sai_2_mcu_addr;
-	s32 uart_2_mcu_addr;
-	s32 uartsh_2_mcu_addr;
+	s32 uart_2_mcu_rom_addr;
+	s32 uartsh_2_mcu_rom_addr;
 	/* End of v3 array */
 	s32 mcu_2_zqspi_addr;
 	/* End of v4 array */
@@ -1780,17 +1780,17 @@ static void sdma_add_scripts(struct sdma_engine *sdma,
 			saddr_arr[i] = addr_arr[i];
 
 	/*
-	 * get uart_2_mcu_addr/uartsh_2_mcu_addr rom script specially because
-	 * they are now replaced by uart_2_mcu_ram_addr/uartsh_2_mcu_ram_addr
-	 * to be compatible with legacy freescale/nxp sdma firmware, and they
-	 * are located in the bottom part of sdma_script_start_addrs which are
-	 * beyond the SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1.
+	 * For compatibility with NXP internal legacy kernel before 4.19 which
+	 * is based on uart ram script and mainline kernel based on uart rom
+	 * script, both uart ram/rom scripts are present in newer sdma
+	 * firmware. Use the rom versions if they are present (V3 or newer).
 	 */
-	if (addr->uart_2_mcu_addr)
-		sdma->script_addrs->uart_2_mcu_addr = addr->uart_2_mcu_addr;
-	if (addr->uartsh_2_mcu_addr)
-		sdma->script_addrs->uartsh_2_mcu_addr = addr->uartsh_2_mcu_addr;
-
+	if (sdma->script_number >= SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V3) {
+		if (addr->uart_2_mcu_rom_addr)
+			sdma->script_addrs->uart_2_mcu_addr = addr->uart_2_mcu_rom_addr;
+		if (addr->uartsh_2_mcu_rom_addr)
+			sdma->script_addrs->uartsh_2_mcu_addr = addr->uartsh_2_mcu_rom_addr;
+	}
 }
 
 static void sdma_load_firmware(const struct firmware *fw, void *context)
@@ -1869,7 +1869,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	u32 reg, val, shift, num_map, i;
 	int ret = 0;
 
-	if (IS_ERR(np) || IS_ERR(gpr_np))
+	if (IS_ERR(np) || !gpr_np)
 		goto out;
 
 	event_remap = of_find_property(np, propname, NULL);
@@ -1917,7 +1917,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	}
 
 out:
-	if (!IS_ERR(gpr_np))
+	if (gpr_np)
 		of_node_put(gpr_np);
 
 	return ret;
diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index 375e7e647df6..a1517ef1f4a0 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -274,7 +274,7 @@ static int mtk_uart_apdma_alloc_chan_resources(struct dma_chan *chan)
 	unsigned int status;
 	int ret;
 
-	ret = pm_runtime_get_sync(mtkd->ddev.dev);
+	ret = pm_runtime_resume_and_get(mtkd->ddev.dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(chan->device->dev);
 		return ret;
@@ -288,18 +288,21 @@ static int mtk_uart_apdma_alloc_chan_resources(struct dma_chan *chan)
 	ret = readx_poll_timeout(readl, c->base + VFF_EN,
 			  status, !status, 10, 100);
 	if (ret)
-		return ret;
+		goto err_pm;
 
 	ret = request_irq(c->irq, mtk_uart_apdma_irq_handler,
 			  IRQF_TRIGGER_NONE, KBUILD_MODNAME, chan);
 	if (ret < 0) {
 		dev_err(chan->device->dev, "Can't request dma IRQ\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm;
 	}
 
 	if (mtkd->support_33bits)
 		mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_SUPPORT_CLR_B);
 
+err_pm:
+	pm_runtime_put_noidle(mtkd->ddev.dev);
 	return ret;
 }
 
diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index a5486d86fdd2..8557781bb8dc 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -163,6 +163,11 @@
 #define ECC_STAT_CECNT_SHIFT		8
 #define ECC_STAT_BITNUM_MASK		0x7F
 
+/* ECC error count register definitions */
+#define ECC_ERRCNT_UECNT_MASK		0xFFFF0000
+#define ECC_ERRCNT_UECNT_SHIFT		16
+#define ECC_ERRCNT_CECNT_MASK		0xFFFF
+
 /* DDR QOS Interrupt register definitions */
 #define DDR_QOS_IRQ_STAT_OFST		0x20200
 #define DDR_QOSUE_MASK			0x4
@@ -418,15 +423,16 @@ static int zynqmp_get_error_info(struct synps_edac_priv *priv)
 	base = priv->baseaddr;
 	p = &priv->stat;
 
+	regval = readl(base + ECC_ERRCNT_OFST);
+	p->ce_cnt = regval & ECC_ERRCNT_CECNT_MASK;
+	p->ue_cnt = (regval & ECC_ERRCNT_UECNT_MASK) >> ECC_ERRCNT_UECNT_SHIFT;
+	if (!p->ce_cnt)
+		goto ue_err;
+
 	regval = readl(base + ECC_STAT_OFST);
 	if (!regval)
 		return 1;
 
-	p->ce_cnt = (regval & ECC_STAT_CECNT_MASK) >> ECC_STAT_CECNT_SHIFT;
-	p->ue_cnt = (regval & ECC_STAT_UECNT_MASK) >> ECC_STAT_UECNT_SHIFT;
-	if (!p->ce_cnt)
-		goto ue_err;
-
 	p->ceinfo.bitpos = (regval & ECC_STAT_BITNUM_MASK);
 
 	regval = readl(base + ECC_CEADDR0_OFST);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 91628edad2c6..320baed949ee 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1560,8 +1560,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	gpiochip_set_irq_hooks(gc);
 
-	acpi_gpiochip_request_interrupts(gc);
-
 	/*
 	 * Using barrier() here to prevent compiler from reordering
 	 * gc->irq.initialized before initialization of above
@@ -1571,6 +1569,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	gc->irq.initialized = true;
 
+	acpi_gpiochip_request_interrupts(gc);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 1b0daf649e82..a3d0c57ec0f0 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -936,6 +936,20 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
+	/* Wa_16011303918:adl-p */
+	if (crtc_state->vrr.enable &&
+	    IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_B0)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, not compatible with HW stepping + VRR\n");
+		return false;
+	}
+
+	if (!_compute_psr2_sdp_prior_scanline_indication(intel_dp, crtc_state)) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR2 not enabled, PSR2 SDP indication do not fit in hblank\n");
+		return false;
+	}
+
 	if (HAS_PSR2_SEL_FETCH(dev_priv)) {
 		if (!intel_psr2_sel_fetch_config_valid(intel_dp, crtc_state) &&
 		    !HAS_PSR_HW_TRACKING(dev_priv)) {
@@ -949,12 +963,12 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 	if (!crtc_state->enable_psr2_sel_fetch &&
 	    IS_TGL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_C0)) {
 		drm_dbg_kms(&dev_priv->drm, "PSR2 HW tracking is not supported this Display stepping\n");
-		return false;
+		goto unsupported;
 	}
 
 	if (!psr2_granularity_check(intel_dp, crtc_state)) {
 		drm_dbg_kms(&dev_priv->drm, "PSR2 not enabled, SU granularity not compatible\n");
-		return false;
+		goto unsupported;
 	}
 
 	if (!crtc_state->enable_psr2_sel_fetch &&
@@ -963,25 +977,15 @@ static bool intel_psr2_config_valid(struct intel_dp *intel_dp,
 			    "PSR2 not enabled, resolution %dx%d > max supported %dx%d\n",
 			    crtc_hdisplay, crtc_vdisplay,
 			    psr_max_h, psr_max_v);
-		return false;
-	}
-
-	if (!_compute_psr2_sdp_prior_scanline_indication(intel_dp, crtc_state)) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "PSR2 not enabled, PSR2 SDP indication do not fit in hblank\n");
-		return false;
-	}
-
-	/* Wa_16011303918:adl-p */
-	if (crtc_state->vrr.enable &&
-	    IS_ADLP_DISPLAY_STEP(dev_priv, STEP_A0, STEP_B0)) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "PSR2 not enabled, not compatible with HW stepping + VRR\n");
-		return false;
+		goto unsupported;
 	}
 
 	tgl_dc3co_exitline_compute_config(intel_dp, crtc_state);
 	return true;
+
+unsupported:
+	crtc_state->enable_psr2_sel_fetch = false;
+	return false;
 }
 
 void intel_psr_compute_config(struct intel_dp *intel_dp,
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
index c6b69afcbac8..50e854207c70 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -90,7 +90,10 @@ static void mdp5_plane_reset(struct drm_plane *plane)
 		__drm_atomic_helper_plane_destroy_state(plane->state);
 
 	kfree(to_mdp5_plane_state(plane->state));
+	plane->state = NULL;
 	mdp5_state = kzalloc(sizeof(*mdp5_state), GFP_KERNEL);
+	if (!mdp5_state)
+		return;
 
 	if (plane->type == DRM_PLANE_TYPE_PRIMARY)
 		mdp5_state->base.zpos = STAGE_BASE;
diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
index cabe15190ec1..369e57f73a47 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -169,6 +169,8 @@ void msm_disp_snapshot_add_block(struct msm_disp_state *disp_state, u32 len,
 	va_list va;
 
 	new_blk = kzalloc(sizeof(struct msm_disp_state_block), GFP_KERNEL);
+	if (!new_blk)
+		return;
 
 	va_start(va, fmt);
 
diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index 46029c5610c8..145047e19394 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -229,7 +229,7 @@ static void rpi_touchscreen_i2c_write(struct rpi_touchscreen *ts,
 
 	ret = i2c_smbus_write_byte_data(ts->i2c, reg, val);
 	if (ret)
-		dev_err(&ts->dsi->dev, "I2C write failed: %d\n", ret);
+		dev_err(&ts->i2c->dev, "I2C write failed: %d\n", ret);
 }
 
 static int rpi_touchscreen_write(struct rpi_touchscreen *ts, u16 reg, u32 val)
@@ -265,7 +265,7 @@ static int rpi_touchscreen_noop(struct drm_panel *panel)
 	return 0;
 }
 
-static int rpi_touchscreen_enable(struct drm_panel *panel)
+static int rpi_touchscreen_prepare(struct drm_panel *panel)
 {
 	struct rpi_touchscreen *ts = panel_to_ts(panel);
 	int i;
@@ -295,6 +295,13 @@ static int rpi_touchscreen_enable(struct drm_panel *panel)
 	rpi_touchscreen_write(ts, DSI_STARTDSI, 0x01);
 	msleep(100);
 
+	return 0;
+}
+
+static int rpi_touchscreen_enable(struct drm_panel *panel)
+{
+	struct rpi_touchscreen *ts = panel_to_ts(panel);
+
 	/* Turn on the backlight. */
 	rpi_touchscreen_i2c_write(ts, REG_PWM, 255);
 
@@ -349,7 +356,7 @@ static int rpi_touchscreen_get_modes(struct drm_panel *panel,
 static const struct drm_panel_funcs rpi_touchscreen_funcs = {
 	.disable = rpi_touchscreen_disable,
 	.unprepare = rpi_touchscreen_noop,
-	.prepare = rpi_touchscreen_noop,
+	.prepare = rpi_touchscreen_prepare,
 	.enable = rpi_touchscreen_enable,
 	.get_modes = rpi_touchscreen_get_modes,
 };
diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index d09c1ea60c04..ca8506316660 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -846,7 +846,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 	unsigned long phy_clock;
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
 		DRM_ERROR("Failed to runtime PM enable on DSI%d\n", dsi->variant->port);
 		return;
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index 43375b38ee59..8a7ce41b8c56 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -393,7 +393,7 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 	 * revision register.
 	 */
 	error = pm_runtime_get_sync(dev);
-	if (error) {
+	if (error < 0) {
 		dev_err(dev, "pm_runtime_get_sync() failed\n");
 		pm_runtime_put_noidle(dev);
 		return error;
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 412ae3e43ffb..35ac6fe7529c 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -34,15 +34,6 @@ source "drivers/net/ethernet/apple/Kconfig"
 source "drivers/net/ethernet/aquantia/Kconfig"
 source "drivers/net/ethernet/arc/Kconfig"
 source "drivers/net/ethernet/atheros/Kconfig"
-source "drivers/net/ethernet/broadcom/Kconfig"
-source "drivers/net/ethernet/brocade/Kconfig"
-source "drivers/net/ethernet/cadence/Kconfig"
-source "drivers/net/ethernet/calxeda/Kconfig"
-source "drivers/net/ethernet/cavium/Kconfig"
-source "drivers/net/ethernet/chelsio/Kconfig"
-source "drivers/net/ethernet/cirrus/Kconfig"
-source "drivers/net/ethernet/cisco/Kconfig"
-source "drivers/net/ethernet/cortina/Kconfig"
 
 config CX_ECAT
 	tristate "Beckhoff CX5020 EtherCAT master support"
@@ -56,6 +47,14 @@ config CX_ECAT
 	  To compile this driver as a module, choose M here. The module
 	  will be called ec_bhf.
 
+source "drivers/net/ethernet/broadcom/Kconfig"
+source "drivers/net/ethernet/cadence/Kconfig"
+source "drivers/net/ethernet/calxeda/Kconfig"
+source "drivers/net/ethernet/cavium/Kconfig"
+source "drivers/net/ethernet/chelsio/Kconfig"
+source "drivers/net/ethernet/cirrus/Kconfig"
+source "drivers/net/ethernet/cisco/Kconfig"
+source "drivers/net/ethernet/cortina/Kconfig"
 source "drivers/net/ethernet/davicom/Kconfig"
 
 config DNET
@@ -82,7 +81,6 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
-source "drivers/net/ethernet/microsoft/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
@@ -125,8 +123,9 @@ source "drivers/net/ethernet/mediatek/Kconfig"
 source "drivers/net/ethernet/mellanox/Kconfig"
 source "drivers/net/ethernet/micrel/Kconfig"
 source "drivers/net/ethernet/microchip/Kconfig"
-source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/mscc/Kconfig"
+source "drivers/net/ethernet/microsoft/Kconfig"
+source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/myricom/Kconfig"
 
 config FEALNX
@@ -138,10 +137,10 @@ config FEALNX
 	  Say Y here to support the Myson MTD-800 family of PCI-based Ethernet
 	  cards. <http://www.myson.com.tw/>
 
+source "drivers/net/ethernet/ni/Kconfig"
 source "drivers/net/ethernet/natsemi/Kconfig"
 source "drivers/net/ethernet/neterion/Kconfig"
 source "drivers/net/ethernet/netronome/Kconfig"
-source "drivers/net/ethernet/ni/Kconfig"
 source "drivers/net/ethernet/8390/Kconfig"
 source "drivers/net/ethernet/nvidia/Kconfig"
 source "drivers/net/ethernet/nxp/Kconfig"
@@ -161,6 +160,7 @@ source "drivers/net/ethernet/packetengines/Kconfig"
 source "drivers/net/ethernet/pasemi/Kconfig"
 source "drivers/net/ethernet/pensando/Kconfig"
 source "drivers/net/ethernet/qlogic/Kconfig"
+source "drivers/net/ethernet/brocade/Kconfig"
 source "drivers/net/ethernet/qualcomm/Kconfig"
 source "drivers/net/ethernet/rdc/Kconfig"
 source "drivers/net/ethernet/realtek/Kconfig"
@@ -168,10 +168,10 @@ source "drivers/net/ethernet/renesas/Kconfig"
 source "drivers/net/ethernet/rocker/Kconfig"
 source "drivers/net/ethernet/samsung/Kconfig"
 source "drivers/net/ethernet/seeq/Kconfig"
-source "drivers/net/ethernet/sfc/Kconfig"
 source "drivers/net/ethernet/sgi/Kconfig"
 source "drivers/net/ethernet/silan/Kconfig"
 source "drivers/net/ethernet/sis/Kconfig"
+source "drivers/net/ethernet/sfc/Kconfig"
 source "drivers/net/ethernet/smsc/Kconfig"
 source "drivers/net/ethernet/socionext/Kconfig"
 source "drivers/net/ethernet/stmicro/Kconfig"
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 9de0065f89b9..fbb1e05d5878 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -480,8 +480,8 @@ int aq_nic_start(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
+	for (i = 0U; self->aq_vecs > i; ++i) {
+		aq_vec = self->aq_vec[i];
 		err = aq_vec_start(aq_vec);
 		if (err < 0)
 			goto err_exit;
@@ -511,8 +511,8 @@ int aq_nic_start(struct aq_nic_s *self)
 		mod_timer(&self->polling_timer, jiffies +
 			  AQ_CFG_POLLING_TIMER_INTERVAL);
 	} else {
-		for (i = 0U, aq_vec = self->aq_vec[0];
-			self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i]) {
+		for (i = 0U; self->aq_vecs > i; ++i) {
+			aq_vec = self->aq_vec[i];
 			err = aq_pci_func_alloc_irq(self, i, self->ndev->name,
 						    aq_vec_isr, aq_vec,
 						    aq_vec_get_affinity_mask(aq_vec));
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 797a95142d1f..3a529ee8c834 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -444,22 +444,22 @@ static int atl_resume_common(struct device *dev, bool deep)
 
 static int aq_pm_freeze(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev, false);
 }
 
 static int aq_pm_thaw(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev, false);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f4774cf051c9..6ab1f3212d24 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -43,8 +43,8 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 	if (!self) {
 		err = -EINVAL;
 	} else {
-		for (i = 0U, ring = self->ring[0];
-			self->tx_rings > i; ++i, ring = self->ring[i]) {
+		for (i = 0U; self->tx_rings > i; ++i) {
+			ring = self->ring[i];
 			u64_stats_update_begin(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
 			ring[AQ_VEC_RX_ID].stats.rx.polls++;
 			u64_stats_update_end(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
@@ -182,8 +182,8 @@ int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
 	self->aq_hw_ops = aq_hw_ops;
 	self->aq_hw = aq_hw;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		err = aq_ring_init(&ring[AQ_VEC_TX_ID], ATL_RING_TX);
 		if (err < 0)
 			goto err_exit;
@@ -224,8 +224,8 @@ int aq_vec_start(struct aq_vec_s *self)
 	unsigned int i = 0U;
 	int err = 0;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		err = self->aq_hw_ops->hw_ring_tx_start(self->aq_hw,
 							&ring[AQ_VEC_TX_ID]);
 		if (err < 0)
@@ -248,8 +248,8 @@ void aq_vec_stop(struct aq_vec_s *self)
 	struct aq_ring_s *ring = NULL;
 	unsigned int i = 0U;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		self->aq_hw_ops->hw_ring_tx_stop(self->aq_hw,
 						 &ring[AQ_VEC_TX_ID]);
 
@@ -268,8 +268,8 @@ void aq_vec_deinit(struct aq_vec_s *self)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		aq_ring_tx_clean(&ring[AQ_VEC_TX_ID]);
 		aq_ring_rx_deinit(&ring[AQ_VEC_RX_ID]);
 	}
@@ -297,8 +297,8 @@ void aq_vec_ring_free(struct aq_vec_s *self)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, ring = self->ring[0];
-		self->tx_rings > i; ++i, ring = self->ring[i]) {
+	for (i = 0U; self->tx_rings > i; ++i) {
+		ring = self->ring[i];
 		aq_ring_free(&ring[AQ_VEC_TX_ID]);
 		if (i < self->rx_rings)
 			aq_ring_free(&ring[AQ_VEC_RX_ID]);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9705c49655ad..217c1a0f8940 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1689,6 +1689,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1696,6 +1697,13 @@ static void macb_tx_restart(struct macb_queue *queue)
 	if (head == tail)
 		return;
 
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
+
+	if (tbqp == head_idx)
+		return;
+
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 763d2c7b5fb1..5750f9a56393 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -489,11 +489,15 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
 	info->phc_index = -1;
 
 	fman_node = of_get_parent(mac_node);
-	if (fman_node)
+	if (fman_node) {
 		ptp_node = of_parse_phandle(fman_node, "ptimer-handle", 0);
+		of_node_put(fman_node);
+	}
 
-	if (ptp_node)
+	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
+	}
 
 	if (ptp_dev)
 		ptp = platform_get_drvdata(ptp_dev);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index d60e2016d03c..e6c8e6d5234f 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1009,8 +1009,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
-	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
-	u16 lat_enc_d = 0;	/* latency decoded */
+	u32 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u32 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index b6807e16eea9..a0e2a404d535 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -156,8 +156,15 @@ void igc_release_swfw_sync_i225(struct igc_hw *hw, u16 mask)
 {
 	u32 swfw_sync;
 
-	while (igc_get_hw_semaphore_i225(hw))
-		; /* Empty */
+	/* Releasing the resource requires first getting the HW semaphore.
+	 * If we fail to get the semaphore, there is nothing we can do,
+	 * except log an error and quit. We are not allowed to hang here
+	 * indefinitely, as it may cause denial of service or system crash.
+	 */
+	if (igc_get_hw_semaphore_i225(hw)) {
+		hw_dbg("Failed to release SW_FW_SYNC.\n");
+		return;
+	}
 
 	swfw_sync = rd32(IGC_SW_FW_SYNC);
 	swfw_sync &= ~mask;
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 40dbf4b43234..6961f65d36b9 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -581,7 +581,7 @@ static s32 igc_read_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 *data)
 	 * the lower time out
 	 */
 	for (i = 0; i < IGC_GEN_POLL_TIMEOUT; i++) {
-		usleep_range(500, 1000);
+		udelay(50);
 		mdic = rd32(IGC_MDIC);
 		if (mdic & IGC_MDIC_READY)
 			break;
@@ -638,7 +638,7 @@ static s32 igc_write_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 data)
 	 * the lower time out
 	 */
 	for (i = 0; i < IGC_GEN_POLL_TIMEOUT; i++) {
-		usleep_range(500, 1000);
+		udelay(50);
 		mdic = rd32(IGC_MDIC);
 		if (mdic & IGC_MDIC_READY)
 			break;
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 4f9245aa79a1..8e521f99b80a 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -996,6 +996,17 @@ static void igc_ptp_time_restore(struct igc_adapter *adapter)
 	igc_ptp_write_i225(adapter, &ts);
 }
 
+static void igc_ptm_stop(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 ctrl;
+
+	ctrl = rd32(IGC_PTM_CTRL);
+	ctrl &= ~IGC_PTM_CTRL_EN;
+
+	wr32(IGC_PTM_CTRL, ctrl);
+}
+
 /**
  * igc_ptp_suspend - Disable PTP work items and prepare for suspend
  * @adapter: Board private structure
@@ -1013,8 +1024,10 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 
-	if (pci_device_is_present(adapter->pdev))
+	if (pci_device_is_present(adapter->pdev)) {
 		igc_ptp_time_save(adapter);
+		igc_ptm_stop(adapter);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6aad0953e8fe..a59300d9e000 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1932,6 +1932,8 @@ static void ocelot_port_set_mcast_flood(struct ocelot *ocelot, int port,
 		val = BIT(port);
 
 	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV6);
 }
 
 static void ocelot_port_set_bcast_flood(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index a7ec9f4d46ce..d68ef72dcdde 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -71,9 +71,9 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 	writel(value, ioaddr + PTP_TCR);
 
 	/* wait for present system time initialize to complete */
-	return readl_poll_timeout(ioaddr + PTP_TCR, value,
+	return readl_poll_timeout_atomic(ioaddr + PTP_TCR, value,
 				 !(value & PTP_TCR_TSINIT),
-				 10000, 100000);
+				 10, 100000);
 }
 
 static int config_addend(void __iomem *ioaddr, u32 addend)
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 141635a35c28..129e270e9a7c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -711,11 +711,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
 	rd = kmalloc(sizeof(*rd), GFP_ATOMIC);
 	if (rd == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
 		kfree(rd);
-		return -ENOBUFS;
+		return -ENOMEM;
 	}
 
 	rd->remote_ip = *ip;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5d156e591b35..f7961b22e051 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -557,7 +557,7 @@ enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_SUB,
 };
 
-#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((unsigned int)(chip) << 16) | (pmu))
 
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index adf288e50e21..5cd0379d86de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -80,7 +80,7 @@ mt76x2e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mt76_rmw_field(dev, 0x15a10, 0x1f << 16, 0x9);
 
 	/* RG_SSUSB_G1_CDR_BIC_LTR = 0xf */
-	mt76_rmw_field(dev, 0x15a0c, 0xf << 28, 0xf);
+	mt76_rmw_field(dev, 0x15a0c, 0xfU << 28, 0xf);
 
 	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
 	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4c35e9acf8ee..f2bb57615762 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1354,6 +1354,8 @@ static int nvme_process_ns_desc(struct nvme_ctrl *ctrl, struct nvme_ns_ids *ids,
 				 warn_str, cur->nidl);
 			return -1;
 		}
+		if (ctrl->quirks & NVME_QUIRK_BOGUS_NID)
+			return NVME_NIDT_EUI64_LEN;
 		memcpy(ids->eui64, data + sizeof(*cur), NVME_NIDT_EUI64_LEN);
 		return NVME_NIDT_EUI64_LEN;
 	case NVME_NIDT_NGUID:
@@ -1362,6 +1364,8 @@ static int nvme_process_ns_desc(struct nvme_ctrl *ctrl, struct nvme_ns_ids *ids,
 				 warn_str, cur->nidl);
 			return -1;
 		}
+		if (ctrl->quirks & NVME_QUIRK_BOGUS_NID)
+			return NVME_NIDT_NGUID_LEN;
 		memcpy(ids->nguid, data + sizeof(*cur), NVME_NIDT_NGUID_LEN);
 		return NVME_NIDT_NGUID_LEN;
 	case NVME_NIDT_UUID:
@@ -1370,6 +1374,8 @@ static int nvme_process_ns_desc(struct nvme_ctrl *ctrl, struct nvme_ns_ids *ids,
 				 warn_str, cur->nidl);
 			return -1;
 		}
+		if (ctrl->quirks & NVME_QUIRK_BOGUS_NID)
+			return NVME_NIDT_UUID_LEN;
 		uuid_copy(&ids->uuid, data + sizeof(*cur));
 		return NVME_NIDT_UUID_LEN;
 	case NVME_NIDT_CSI:
@@ -1466,12 +1472,18 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if ((*id)->ncap == 0) /* namespace not allocated or attached */
 		goto out_free_id;
 
-	if (ctrl->vs >= NVME_VS(1, 1, 0) &&
-	    !memchr_inv(ids->eui64, 0, sizeof(ids->eui64)))
-		memcpy(ids->eui64, (*id)->eui64, sizeof(ids->eui64));
-	if (ctrl->vs >= NVME_VS(1, 2, 0) &&
-	    !memchr_inv(ids->nguid, 0, sizeof(ids->nguid)))
-		memcpy(ids->nguid, (*id)->nguid, sizeof(ids->nguid));
+
+	if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
+		dev_info(ctrl->device,
+			 "Ignoring bogus Namespace Identifiers\n");
+	} else {
+		if (ctrl->vs >= NVME_VS(1, 1, 0) &&
+		    !memchr_inv(ids->eui64, 0, sizeof(ids->eui64)))
+			memcpy(ids->eui64, (*id)->eui64, sizeof(ids->eui64));
+		if (ctrl->vs >= NVME_VS(1, 2, 0) &&
+		    !memchr_inv(ids->nguid, 0, sizeof(ids->nguid)))
+			memcpy(ids->nguid, (*id)->nguid, sizeof(ids->nguid));
+	}
 
 	return 0;
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 0628e2d802e7..f1e5c7564cae 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -144,6 +144,11 @@ enum nvme_quirks {
 	 * encoding the generation sequence number.
 	 */
 	NVME_QUIRK_SKIP_CID_GEN			= (1 << 17),
+
+	/*
+	 * Reports garbage in the namespace identifiers (eui64, nguid, uuid).
+	 */
+	NVME_QUIRK_BOGUS_NID			= (1 << 18),
 };
 
 /*
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b925a5f4afc3..d7695bdbde8d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3314,7 +3314,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_IDENTIFY_CNS |
-				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+				NVME_QUIRK_DISABLE_WRITE_ZEROES |
+				NVME_QUIRK_BOGUS_NID, },
+	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
@@ -3352,6 +3355,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 295cc7952d0e..57d20cf3da7a 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -398,6 +398,9 @@ validate_group(struct perf_event *event)
 	if (!validate_event(event->pmu, &fake_pmu, leader))
 		return -EINVAL;
 
+	if (event == leader)
+		return 0;
+
 	for_each_sibling_event(sibling, leader) {
 		if (!validate_event(event->pmu, &fake_pmu, sibling))
 			return -EINVAL;
@@ -487,12 +490,7 @@ __hw_perf_event_init(struct perf_event *event)
 		local64_set(&hwc->period_left, hwc->sample_period);
 	}
 
-	if (event->group_leader != event) {
-		if (validate_group(event) != 0)
-			return -EINVAL;
-	}
-
-	return 0;
+	return validate_group(event);
 }
 
 static int armpmu_event_init(struct perf_event *event)
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 7ee010aa740a..404bdb4cbfae 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1121,8 +1121,6 @@ static void kbd_led_set(struct led_classdev *led_cdev,
 
 	if (value > samsung->kbd_led.max_brightness)
 		value = samsung->kbd_led.max_brightness;
-	else if (value < 0)
-		value = 0;
 
 	samsung->kbd_led_wk = value;
 	queue_work(samsung->led_workqueue, &samsung->kbd_led_work);
diff --git a/drivers/reset/reset-rzg2l-usbphy-ctrl.c b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
index 1e8315038850..a8dde4606360 100644
--- a/drivers/reset/reset-rzg2l-usbphy-ctrl.c
+++ b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
@@ -121,7 +121,9 @@ static int rzg2l_usbphy_ctrl_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(priv->rstc),
 				     "failed to get reset\n");
 
-	reset_control_deassert(priv->rstc);
+	error = reset_control_deassert(priv->rstc);
+	if (error)
+		return error;
 
 	priv->rcdev.ops = &rzg2l_usbphy_ctrl_reset_ops;
 	priv->rcdev.of_reset_n_cells = 1;
diff --git a/drivers/reset/tegra/reset-bpmp.c b/drivers/reset/tegra/reset-bpmp.c
index 24d3395964cc..4c5bba52b105 100644
--- a/drivers/reset/tegra/reset-bpmp.c
+++ b/drivers/reset/tegra/reset-bpmp.c
@@ -20,6 +20,7 @@ static int tegra_bpmp_reset_common(struct reset_controller_dev *rstc,
 	struct tegra_bpmp *bpmp = to_tegra_bpmp(rstc);
 	struct mrq_reset_request request;
 	struct tegra_bpmp_message msg;
+	int err;
 
 	memset(&request, 0, sizeof(request));
 	request.cmd = command;
@@ -30,7 +31,13 @@ static int tegra_bpmp_reset_common(struct reset_controller_dev *rstc,
 	msg.tx.data = &request;
 	msg.tx.size = sizeof(request);
 
-	return tegra_bpmp_transfer(bpmp, &msg);
+	err = tegra_bpmp_transfer(bpmp, &msg);
+	if (err)
+		return err;
+	if (msg.rx.ret)
+		return -EINVAL;
+
+	return 0;
 }
 
 static int tegra_bpmp_reset_module(struct reset_controller_dev *rstc,
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5521469ce678..e16327a4b4c9 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
 			break;
 
-		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
+		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
 			    nopin->itt == (u16) RESERVED_ITT) {
 				printk(KERN_ALERT "bnx2i: Unsolicited "
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1b5f3e143f07..2e5241d12dc3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
 
 			/* Must suspend all rx queue activity for this ep */
-			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 		}
 		/* CONN_DISCONNECT timeout may or may not be an issue depending
 		 * on what transcribed in TCP layer, different targets behave
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 8c7d4dda4cf2..4365d52c6430 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"csk 0x%p, conn 0x%p.\n", csk, conn);
 
-	if (unlikely(!conn || conn->suspend_rx)) {
+	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
+			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
 			csk, conn, conn ? conn->id : 0xFF,
-			conn ? conn->suspend_rx : 0xFF);
+			conn ? conn->flags : 0xFF);
 		return;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index cbc263ec9d66..0f2c7098f9d6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -678,7 +678,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_task *task;
 	itt_t itt;
 
-	if (session->state == ISCSI_STATE_TERMINATE)
+	if (session->state == ISCSI_STATE_TERMINATE ||
+	    !test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags))
 		return NULL;
 
 	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
@@ -1392,8 +1393,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 	return true;
 }
 
@@ -1454,7 +1455,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * Do this after dropping the extra ref because if this was a requeue
 	 * it's removed from that list and cleanup_queued_task would miss it.
 	 */
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		/*
 		 * Save the task and ref in case we weren't cleaning up this
 		 * task and get woken up again.
@@ -1532,7 +1533,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	spin_lock_bh(&conn->session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->frwd_lock);
 		return -ENODATA;
@@ -1746,7 +1747,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1935,7 +1936,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
 	spin_lock_bh(&conn->session->frwd_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
@@ -1953,7 +1954,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
 		flush_workqueue(ihost->workq);
 }
@@ -1961,7 +1962,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	iscsi_conn_queue_work(conn);
 }
 
@@ -2214,6 +2215,8 @@ void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->frwd_lock);
+	clear_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
+
 	if (!is_active) {
 		/*
 		 * if logout timed out before userspace could even send a PDU
@@ -3312,6 +3315,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	spin_lock_bh(&session->frwd_lock);
 	if (is_leading)
 		session->leadconn = conn;
+
+	set_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
 	spin_unlock_bh(&session->frwd_lock);
 
 	/*
@@ -3324,8 +3329,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e9ffe3d1a55..883005757ddb 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	 */
 	conn->last_recv = jiffies;
 
-	if (unlikely(conn->suspend_rx)) {
+	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
 		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index c5260429c637..04b40a6c1aff 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -859,6 +859,37 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	return qedi_iscsi_send_ioreq(task);
 }
 
+static void qedi_offload_work(struct work_struct *work)
+{
+	struct qedi_endpoint *qedi_ep =
+		container_of(work, struct qedi_endpoint, offload_work);
+	struct qedi_ctx *qedi;
+	int wait_delay = 5 * HZ;
+	int ret;
+
+	qedi = qedi_ep->qedi;
+
+	ret = qedi_iscsi_offload_conn(qedi_ep);
+	if (ret) {
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
+			 qedi_ep->iscsi_cid, qedi_ep, ret);
+		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
+		return;
+	}
+
+	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
+					       (qedi_ep->state ==
+					       EP_STATE_OFLDCONN_COMPL),
+					       wait_delay);
+	if (ret <= 0 || qedi_ep->state != EP_STATE_OFLDCONN_COMPL) {
+		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
+			 qedi_ep->iscsi_cid, qedi_ep);
+	}
+}
+
 static struct iscsi_endpoint *
 qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		int non_blocking)
@@ -907,6 +938,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 	qedi_ep = ep->dd_data;
 	memset(qedi_ep, 0, sizeof(struct qedi_endpoint));
+	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
 	qedi_ep->state = EP_STATE_IDLE;
 	qedi_ep->iscsi_cid = (u32)-1;
 	qedi_ep->qedi = qedi;
@@ -1055,12 +1087,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	qedi_ep = ep->dd_data;
 	qedi = qedi_ep->qedi;
 
+	flush_work(&qedi_ep->offload_work);
+
 	if (qedi_ep->state == EP_STATE_OFLDCONN_START)
 		goto ep_exit_recover;
 
-	if (qedi_ep->state != EP_STATE_OFLDCONN_NONE)
-		flush_work(&qedi_ep->offload_work);
-
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
 		abrt_conn = qedi_conn->abrt_conn;
@@ -1234,37 +1265,6 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
 	return rc;
 }
 
-static void qedi_offload_work(struct work_struct *work)
-{
-	struct qedi_endpoint *qedi_ep =
-		container_of(work, struct qedi_endpoint, offload_work);
-	struct qedi_ctx *qedi;
-	int wait_delay = 5 * HZ;
-	int ret;
-
-	qedi = qedi_ep->qedi;
-
-	ret = qedi_iscsi_offload_conn(qedi_ep);
-	if (ret) {
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
-			 qedi_ep->iscsi_cid, qedi_ep, ret);
-		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
-		return;
-	}
-
-	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
-					       (qedi_ep->state ==
-					       EP_STATE_OFLDCONN_COMPL),
-					       wait_delay);
-	if ((ret <= 0) || (qedi_ep->state != EP_STATE_OFLDCONN_COMPL)) {
-		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
-			 qedi_ep->iscsi_cid, qedi_ep);
-	}
-}
-
 static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 {
 	struct qedi_ctx *qedi;
@@ -1380,7 +1380,6 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 			  qedi_ep->dst_addr, qedi_ep->dst_port);
 	}
 
-	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
 	queue_work(qedi->offload_thread, &qedi_ep->offload_work);
 
 	ret = 0;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c7b1b2e8bb02..bcdfcb25349a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,6 +86,9 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
+static DEFINE_IDR(iscsi_ep_idr);
+static DEFINE_MUTEX(iscsi_ep_idr_mutex);
+
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
@@ -169,6 +172,11 @@ struct device_attribute dev_attr_##_prefix##_##_name =	\
 static void iscsi_endpoint_release(struct device *dev)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+
+	mutex_lock(&iscsi_ep_idr_mutex);
+	idr_remove(&iscsi_ep_idr, ep->id);
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
 	kfree(ep);
 }
 
@@ -181,7 +189,7 @@ static ssize_t
 show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	return sysfs_emit(buf, "%llu\n", (unsigned long long) ep->id);
+	return sysfs_emit(buf, "%d\n", ep->id);
 }
 static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
 
@@ -194,48 +202,32 @@ static struct attribute_group iscsi_endpoint_group = {
 	.attrs = iscsi_endpoint_attrs,
 };
 
-#define ISCSI_MAX_EPID -1
-
-static int iscsi_match_epid(struct device *dev, const void *data)
-{
-	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	const uint64_t *epid = data;
-
-	return *epid == ep->id;
-}
-
 struct iscsi_endpoint *
 iscsi_create_endpoint(int dd_size)
 {
-	struct device *dev;
 	struct iscsi_endpoint *ep;
-	uint64_t id;
-	int err;
-
-	for (id = 1; id < ISCSI_MAX_EPID; id++) {
-		dev = class_find_device(&iscsi_endpoint_class, NULL, &id,
-					iscsi_match_epid);
-		if (!dev)
-			break;
-		else
-			put_device(dev);
-	}
-	if (id == ISCSI_MAX_EPID) {
-		printk(KERN_ERR "Too many connections. Max supported %u\n",
-		       ISCSI_MAX_EPID - 1);
-		return NULL;
-	}
+	int err, id;
 
 	ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
 	if (!ep)
 		return NULL;
 
+	mutex_lock(&iscsi_ep_idr_mutex);
+	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+	if (id < 0) {
+		mutex_unlock(&iscsi_ep_idr_mutex);
+		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
+		       id);
+		goto free_ep;
+	}
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
 	ep->id = id;
 	ep->dev.class = &iscsi_endpoint_class;
-	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
+	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
-                goto free_ep;
+		goto free_id;
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -249,6 +241,10 @@ iscsi_create_endpoint(int dd_size)
 	device_unregister(&ep->dev);
 	return NULL;
 
+free_id:
+	mutex_lock(&iscsi_ep_idr_mutex);
+	idr_remove(&iscsi_ep_idr, id);
+	mutex_unlock(&iscsi_ep_idr_mutex);
 free_ep:
 	kfree(ep);
 	return NULL;
@@ -276,14 +272,17 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
  */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct device *dev;
+	struct iscsi_endpoint *ep;
 
-	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
-				iscsi_match_epid);
-	if (!dev)
-		return NULL;
+	mutex_lock(&iscsi_ep_idr_mutex);
+	ep = idr_find(&iscsi_ep_idr, handle);
+	if (!ep)
+		goto unlock;
 
-	return iscsi_dev_to_endpoint(dev);
+	get_device(&ep->dev);
+unlock:
+	mutex_unlock(&iscsi_ep_idr_mutex);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ddd00efc4882..fbdb5124d7f7 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -41,7 +41,7 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL);
+	buffer = kzalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -55,10 +55,13 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	cgc.data_direction = DMA_FROM_DEVICE;
 
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	tochdr->cdth_trk0 = buffer[2];
 	tochdr->cdth_trk1 = buffer[3];
 
+err:
 	kfree(buffer);
 	return result;
 }
@@ -71,7 +74,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL);
+	buffer = kzalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -86,6 +89,8 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	cgc.data_direction = DMA_FROM_DEVICE;
 
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	tocentry->cdte_ctrl = buffer[5] & 0xf;
 	tocentry->cdte_adr = buffer[5] >> 4;
@@ -98,6 +103,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 		tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
 			+ buffer[10]) << 8) + buffer[11];
 
+err:
 	kfree(buffer);
 	return result;
 }
@@ -384,7 +390,7 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL);
+	char *buffer = kzalloc(32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -400,10 +406,13 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 	cgc.data_direction = DMA_FROM_DEVICE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	memcpy(mcn->medium_catalog_number, buffer + 9, 13);
 	mcn->medium_catalog_number[13] = 0;
 
+err:
 	kfree(buffer);
 	return result;
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0e4c04d3b023..b55e0a07363f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -358,7 +358,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
 static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	u64 lba;
+	u64 lba = 0;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
@@ -375,7 +375,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		return;
 
 	opcode = cmd->cmnd[0];
-	lba = scsi_get_lba(cmd);
 
 	if (opcode == READ_10 || opcode == WRITE_10) {
 		/*
@@ -383,6 +382,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		 */
 		transfer_len =
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+		lba = scsi_get_lba(cmd);
 		if (opcode == WRITE_10)
 			group_id = lrbp->cmd->cmnd[6];
 	} else if (opcode == UNMAP) {
@@ -390,6 +390,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		 * The number of Bytes to be unmapped beginning with the lba.
 		 */
 		transfer_len = blk_rq_bytes(rq);
+		lba = scsi_get_lba(cmd);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 92d9610df1fd..938017a60c8e 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -277,6 +277,9 @@ static int atmel_qspi_find_mode(const struct spi_mem_op *op)
 static bool atmel_qspi_supports_op(struct spi_mem *mem,
 				   const struct spi_mem_op *op)
 {
+	if (!spi_mem_default_supports_op(mem, op))
+		return false;
+
 	if (atmel_qspi_find_mode(op) < 0)
 		return false;
 
diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 1a6294a06e72..75680eecd2f7 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1226,9 +1226,24 @@ static bool cqspi_supports_mem_op(struct spi_mem *mem,
 	all_false = !op->cmd.dtr && !op->addr.dtr && !op->dummy.dtr &&
 		    !op->data.dtr;
 
-	/* Mixed DTR modes not supported. */
-	if (!(all_true || all_false))
+	if (all_true) {
+		/* Right now we only support 8-8-8 DTR mode. */
+		if (op->cmd.nbytes && op->cmd.buswidth != 8)
+			return false;
+		if (op->addr.nbytes && op->addr.buswidth != 8)
+			return false;
+		if (op->data.nbytes && op->data.buswidth != 8)
+			return false;
+	} else if (all_false) {
+		/* Only 1-1-X ops are supported without DTR */
+		if (op->cmd.nbytes && op->cmd.buswidth > 1)
+			return false;
+		if (op->addr.nbytes && op->addr.buswidth > 1)
+			return false;
+	} else {
+		/* Mixed DTR modes are not supported. */
 		return false;
+	}
 
 	if (all_true)
 		return spi_mem_dtr_supports_op(mem, op);
diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 5c93730615f8..6d203477c04b 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -909,7 +909,17 @@ static int __maybe_unused mtk_nor_suspend(struct device *dev)
 
 static int __maybe_unused mtk_nor_resume(struct device *dev)
 {
-	return pm_runtime_force_resume(dev);
+	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret)
+		return ret;
+
+	mtk_nor_init(sp);
+
+	return 0;
 }
 
 static const struct dev_pm_ops mtk_nor_pm_ops = {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 29a019cf1d5f..8f8d281e3151 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -936,7 +936,7 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_flags & IOCB_DIRECT)
 		return cifs_user_readv(iocb, iter);
 
 	rc = cifs_revalidate_mapping(inode);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index db981619f6c8..a0a987857894 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2267,6 +2267,10 @@ static inline int ext4_forced_shutdown(struct ext4_sb_info *sbi)
  * Structure of a directory entry
  */
 #define EXT4_NAME_LEN 255
+/*
+ * Base length of the ext4 directory entry excluding the name length
+ */
+#define EXT4_BASE_DIR_LEN (sizeof(struct ext4_dir_entry_2) - EXT4_NAME_LEN)
 
 struct ext4_dir_entry {
 	__le32	inode;			/* Inode number */
@@ -3027,7 +3031,7 @@ extern int ext4_inode_attach_jinode(struct inode *inode);
 extern int ext4_can_truncate(struct inode *inode);
 extern int ext4_truncate(struct inode *);
 extern int ext4_break_layouts(struct inode *);
-extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
+extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
 extern void ext4_set_inode_flags(struct inode *, bool init);
 extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b81c008e6675..44d00951e609 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4504,9 +4504,9 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	return ret > 0 ? ret2 : ret;
 }
 
-static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
+static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
 
-static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len);
+static int ext4_insert_range(struct file *file, loff_t offset, loff_t len);
 
 static long ext4_zero_range(struct file *file, loff_t offset,
 			    loff_t len, int mode)
@@ -4578,6 +4578,10 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/* Preallocate the range including the unaligned edges */
 	if (partial_begin || partial_end) {
 		ret = ext4_alloc_file_blocks(file,
@@ -4696,7 +4700,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	ext4_fc_start_update(inode);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
-		ret = ext4_punch_hole(inode, offset, len);
+		ret = ext4_punch_hole(file, offset, len);
 		goto exit;
 	}
 
@@ -4705,12 +4709,12 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		goto exit;
 
 	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
-		ret = ext4_collapse_range(inode, offset, len);
+		ret = ext4_collapse_range(file, offset, len);
 		goto exit;
 	}
 
 	if (mode & FALLOC_FL_INSERT_RANGE) {
-		ret = ext4_insert_range(inode, offset, len);
+		ret = ext4_insert_range(file, offset, len);
 		goto exit;
 	}
 
@@ -4746,6 +4750,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
 	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size, flags);
 	if (ret)
 		goto out;
@@ -5248,8 +5256,9 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
  * This implements the fallocate's collapse range functionality for ext4
  * Returns: 0 and non-zero on error.
  */
-static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
+static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	ext4_lblk_t punch_start, punch_stop;
@@ -5301,6 +5310,10 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.
@@ -5394,8 +5407,9 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
  * by len bytes.
  * Returns 0 on success, error otherwise.
  */
-static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
+static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	handle_t *handle;
@@ -5452,6 +5466,10 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fff52292c01e..db73b49bd979 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3939,12 +3939,14 @@ int ext4_break_layouts(struct inode *inode)
  * Returns: 0 on success or negative on failure
  */
 
-int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
+int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t first_block_offset, last_block_offset;
+	loff_t first_block_offset, last_block_offset, max_length;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	unsigned int credits;
 	int ret = 0, ret2 = 0;
@@ -3987,6 +3989,14 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		   offset;
 	}
 
+	/*
+	 * For punch hole the length + offset needs to be within one block
+	 * before last range. Adjust the length if it goes beyond that limit.
+	 */
+	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
+	if (offset + length > max_length)
+		length = max_length - offset;
+
 	if (offset & (sb->s_blocksize - 1) ||
 	    (offset + length) & (sb->s_blocksize - 1)) {
 		/*
@@ -4002,6 +4012,10 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8cb5ea7ee506..19c620118e62 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1466,10 +1466,10 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 
 	de = (struct ext4_dir_entry_2 *)search_buf;
 	dlimit = search_buf + buf_size;
-	while ((char *) de < dlimit) {
+	while ((char *) de < dlimit - EXT4_BASE_DIR_LEN) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
-		if ((char *) de + de->name_len <= dlimit &&
+		if (de->name + de->name_len <= dlimit &&
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index f038d578d8d8..18977ff8e493 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -134,8 +134,10 @@ static void ext4_finish_bio(struct bio *bio)
 				continue;
 			}
 			clear_buffer_async_write(bh);
-			if (bio->bi_status)
+			if (bio->bi_status) {
+				set_buffer_write_io_error(bh);
 				buffer_io_error(bh);
+			}
 		} while ((bh = bh->b_this_page) != head);
 		spin_unlock_irqrestore(&head->b_uptodate_lock, flags);
 		if (!under_io) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fd4d34deb9fc..fa21d8180319 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3697,9 +3697,11 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
 	ext4_fsblk_t		first_block, last_block, b;
 	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
 	int			s, j, count = 0;
+	int			has_super = ext4_bg_has_super(sb, grp);
 
 	if (!ext4_has_feature_bigalloc(sb))
-		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, grp) +
+		return (has_super + ext4_bg_num_gdb(sb, grp) +
+			(has_super ? le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) : 0) +
 			sbi->s_itb_per_group + 2);
 
 	first_block = le32_to_cpu(sbi->s_es->s_first_data_block) +
@@ -4786,9 +4788,18 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.
 	 */
-	if (es->s_overhead_clusters)
-		sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
-	else {
+	sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
+	/* ignore the precalculated value if it is ridiculous */
+	if (sbi->s_overhead > ext4_blocks_count(es))
+		sbi->s_overhead = 0;
+	/*
+	 * If the bigalloc feature is not enabled recalculating the
+	 * overhead doesn't take long, so we might as well just redo
+	 * it to make sure we are using the correct value.
+	 */
+	if (!ext4_has_feature_bigalloc(sb))
+		sbi->s_overhead = 0;
+	if (sbi->s_overhead == 0) {
 		err = ext4_calculate_overhead(sb);
 		if (err)
 			goto failed_mount_wq;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 403cf6f1eb8c..6901cd85f1df 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -923,15 +923,15 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	spin_lock_init(&rgd->rd_rsspin);
 	mutex_init(&rgd->rd_mutex);
 
-	error = compute_bitstructs(rgd);
-	if (error)
-		goto fail;
-
 	error = gfs2_glock_get(sdp, rgd->rd_addr,
 			       &gfs2_rgrp_glops, CREATE, &rgd->rd_gl);
 	if (error)
 		goto fail;
 
+	error = compute_bitstructs(rgd);
+	if (error)
+		goto fail_glock;
+
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~(GFS2_RDF_UPTODATE | GFS2_RDF_PREFERRED);
 	if (rgd->rd_data > sdp->sd_max_rg_data)
@@ -945,6 +945,7 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	}
 
 	error = 0; /* someone else read in the rgrp; free it and ignore it */
+fail_glock:
 	gfs2_glock_put(rgd->rd_gl);
 
 fail:
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 54c4e0b0dda4..bb0651a4a128 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -206,7 +206,7 @@ hugetlb_get_unmapped_area_bottomup(struct file *file, unsigned long addr,
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = arch_get_mmap_end(addr);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
@@ -222,7 +222,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit = current->mm->mmap_base;
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
@@ -237,7 +237,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = current->mm->mmap_base;
-		info.high_limit = TASK_SIZE;
+		info.high_limit = arch_get_mmap_end(addr);
 		addr = vm_unmapped_area(&info);
 	}
 
@@ -251,6 +251,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct hstate *h = hstate_file(file);
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -266,7 +267,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (mmap_end - len >= addr &&
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
diff --git a/fs/internal.h b/fs/internal.h
index 3cd065c8a66b..cdd83d4899bb 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -23,22 +23,11 @@ struct pipe_inode_info;
 #ifdef CONFIG_BLOCK
 extern void __init bdev_cache_init(void);
 
-extern int __sync_blockdev(struct block_device *bdev, int wait);
-void iterate_bdevs(void (*)(struct block_device *, void *), void *);
 void emergency_thaw_bdev(struct super_block *sb);
 #else
 static inline void bdev_cache_init(void)
 {
 }
-
-static inline int __sync_blockdev(struct block_device *bdev, int wait)
-{
-	return 0;
-}
-static inline void iterate_bdevs(void (*f)(struct block_device *, void *),
-		void *arg)
-{
-}
 static inline int emergency_thaw_bdev(struct super_block *sb)
 {
 	return 0;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d188fa913a07..34b1406c06fd 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -501,7 +501,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	}
 	spin_unlock(&commit_transaction->t_handle_lock);
 	commit_transaction->t_state = T_SWITCH;
-	write_unlock(&journal->j_state_lock);
 
 	J_ASSERT (atomic_read(&commit_transaction->t_outstanding_credits) <=
 			journal->j_max_transaction_buffers);
@@ -521,6 +520,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * has reserved.  This is consistent with the existing behaviour
 	 * that multiple jbd2_journal_get_write_access() calls to the same
 	 * buffer are perfectly permissible.
+	 * We use journal->j_state_lock here to serialize processing of
+	 * t_reserved_list with eviction of buffers from journal_unmap_buffer().
 	 */
 	while (commit_transaction->t_reserved_list) {
 		jh = commit_transaction->t_reserved_list;
@@ -540,6 +541,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		jbd2_journal_refile_buffer(journal, jh);
 	}
 
+	write_unlock(&journal->j_state_lock);
 	/*
 	 * Now try to drop any written-back buffers from the journal's
 	 * checkpoint lists.  We do this *before* commit because it potentially
diff --git a/fs/namei.c b/fs/namei.c
index 3bb65f48fe1d..8882a70dc119 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3625,18 +3625,14 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct qstr last;
+	bool want_dir = lookup_flags & LOOKUP_DIRECTORY;
+	unsigned int reval_flag = lookup_flags & LOOKUP_REVAL;
+	unsigned int create_flags = LOOKUP_CREATE | LOOKUP_EXCL;
 	int type;
 	int err2;
 	int error;
-	bool is_dir = (lookup_flags & LOOKUP_DIRECTORY);
 
-	/*
-	 * Note that only LOOKUP_REVAL and LOOKUP_DIRECTORY matter here. Any
-	 * other flags passed in are ignored!
-	 */
-	lookup_flags &= LOOKUP_REVAL;
-
-	error = filename_parentat(dfd, name, lookup_flags, path, &last, &type);
+	error = filename_parentat(dfd, name, reval_flag, path, &last, &type);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3650,11 +3646,13 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	/* don't fail immediately if it's r/o, at least try to report other errors */
 	err2 = mnt_want_write(path->mnt);
 	/*
-	 * Do the final lookup.
+	 * Do the final lookup.  Suppress 'create' if there is a trailing
+	 * '/', and a directory wasn't requested.
 	 */
-	lookup_flags |= LOOKUP_CREATE | LOOKUP_EXCL;
+	if (last.name[last.len] && !want_dir)
+		create_flags = 0;
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
-	dentry = __lookup_hash(&last, path->dentry, lookup_flags);
+	dentry = __lookup_hash(&last, path->dentry, reval_flag | create_flags);
 	if (IS_ERR(dentry))
 		goto unlock;
 
@@ -3668,7 +3666,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	 * all is fine. Let's be bastards - you had / on the end, you've
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
-	if (unlikely(!is_dir && last.name[last.len])) {
+	if (unlikely(!create_flags)) {
 		error = -ENOENT;
 		goto fail;
 	}
diff --git a/fs/stat.c b/fs/stat.c
index 28d2020ba1f4..246d138ec066 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -334,9 +334,6 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, stat
 #  define choose_32_64(a,b) b
 #endif
 
-#define valid_dev(x)  choose_32_64(old_valid_dev(x),true)
-#define encode_dev(x) choose_32_64(old_encode_dev,new_encode_dev)(x)
-
 #ifndef INIT_STRUCT_STAT_PADDING
 #  define INIT_STRUCT_STAT_PADDING(st) memset(&st, 0, sizeof(st))
 #endif
@@ -345,7 +342,9 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 {
 	struct stat tmp;
 
-	if (!valid_dev(stat->dev) || !valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
@@ -353,7 +352,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #endif
 
 	INIT_STRUCT_STAT_PADDING(tmp);
-	tmp.st_dev = encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -363,7 +362,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -644,11 +643,13 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 {
 	struct compat_stat tmp;
 
-	if (!old_valid_dev(stat->dev) || !old_valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 
 	memset(&tmp, 0, sizeof(tmp));
-	tmp.st_dev = old_encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -658,7 +659,7 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = old_encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	if ((u64) stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
 	tmp.st_size = stat->size;
diff --git a/fs/sync.c b/fs/sync.c
index 1373a610dc78..c7690016453e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -3,6 +3,7 @@
  * High-level sync()-related operations
  */
 
+#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/file.h>
 #include <linux/fs.h>
@@ -21,25 +22,6 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
-/*
- * Do the filesystem syncing work. For simple filesystems
- * writeback_inodes_sb(sb) just dirties buffers with inodes so we have to
- * submit IO for these buffers via __sync_blockdev(). This also speeds up the
- * wait == 1 case since in that case write_inode() functions do
- * sync_dirty_buffer() and thus effectively write one block at a time.
- */
-static int __sync_filesystem(struct super_block *sb, int wait)
-{
-	if (wait)
-		sync_inodes_sb(sb);
-	else
-		writeback_inodes_sb(sb, WB_REASON_SYNC);
-
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, wait);
-	return __sync_blockdev(sb->s_bdev, wait);
-}
-
 /*
  * Write out and wait upon all dirty data associated with this
  * superblock.  Filesystem data as well as the underlying block
@@ -47,7 +29,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -61,10 +43,31 @@ int sync_filesystem(struct super_block *sb)
 	if (sb_rdonly(sb))
 		return 0;
 
-	ret = __sync_filesystem(sb, 0);
-	if (ret < 0)
+	/*
+	 * Do the filesystem syncing work.  For simple filesystems
+	 * writeback_inodes_sb(sb) just dirties buffers with inodes so we have
+	 * to submit I/O for these buffers via sync_blockdev().  This also
+	 * speeds up the wait == 1 case since in that case write_inode()
+	 * methods call sync_dirty_buffer() and thus effectively write one block
+	 * at a time.
+	 */
+	writeback_inodes_sb(sb, WB_REASON_SYNC);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
+	ret = sync_blockdev_nowait(sb->s_bdev);
+	if (ret)
 		return ret;
-	return __sync_filesystem(sb, 1);
+
+	sync_inodes_sb(sb);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
+	return sync_blockdev(sb->s_bdev);
 }
 EXPORT_SYMBOL(sync_filesystem);
 
@@ -81,21 +84,6 @@ static void sync_fs_one_sb(struct super_block *sb, void *arg)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
 
-static void fdatawrite_one_bdev(struct block_device *bdev, void *arg)
-{
-	filemap_fdatawrite(bdev->bd_inode->i_mapping);
-}
-
-static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
-{
-	/*
-	 * We keep the error status of individual mapping so that
-	 * applications can catch the writeback error using fsync(2).
-	 * See filemap_fdatawait_keep_errors() for details.
-	 */
-	filemap_fdatawait_keep_errors(bdev->bd_inode->i_mapping);
-}
-
 /*
  * Sync everything. We start by waking flusher threads so that most of
  * writeback runs on all devices in parallel. Then we sync all inodes reliably
@@ -114,8 +102,8 @@ void ksys_sync(void)
 	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &wait);
-	iterate_bdevs(fdatawrite_one_bdev, NULL);
-	iterate_bdevs(fdatawait_one_bdev, NULL);
+	sync_bdevs(false);
+	sync_bdevs(true);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
 }
@@ -136,10 +124,10 @@ static void do_sync_work(struct work_struct *work)
 	 */
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(fdatawrite_one_bdev, NULL);
+	sync_bdevs(false);
 	iterate_supers(sync_inodes_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &nowait);
-	iterate_bdevs(fdatawrite_one_bdev, NULL);
+	sync_bdevs(false);
 	printk("Emergency Sync complete\n");
 	kfree(work);
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c4e0cd1c1c8c..170fee98c45c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -729,6 +729,7 @@ xfs_fs_sync_fs(
 	int			wait)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
 
 	trace_xfs_fs_sync_fs(mp, __return_address);
 
@@ -738,7 +739,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
-	xfs_log_force(mp, XFS_LOG_SYNC);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 413c0148c0ce..aebe67ed7a73 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1999,6 +1999,8 @@ int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
 #ifdef CONFIG_BLOCK
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
+int sync_blockdev_nowait(struct block_device *bdev);
+void sync_bdevs(bool wait);
 #else
 static inline void invalidate_bdev(struct block_device *bdev)
 {
@@ -2007,6 +2009,13 @@ static inline int sync_blockdev(struct block_device *bdev)
 {
 	return 0;
 }
+static inline int sync_blockdev_nowait(struct block_device *bdev)
+{
+	return 0;
+}
+static inline void sync_bdevs(bool wait)
+{
+}
 #endif
 int fsync_bdev(struct block_device *bdev);
 
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index c58d50451485..7f28fa702bb7 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -127,7 +127,7 @@ static inline bool is_multicast_ether_addr(const u8 *addr)
 #endif
 }
 
-static inline bool is_multicast_ether_addr_64bits(const u8 addr[6+2])
+static inline bool is_multicast_ether_addr_64bits(const u8 *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 #ifdef __BIG_ENDIAN
@@ -364,8 +364,7 @@ static inline bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
  * Please note that alignment of addr1 & addr2 are only guaranteed to be 16 bits.
  */
 
-static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
-					   const u8 addr2[6+2])
+static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *addr2)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 fold = (*(const u64 *)addr1) ^ (*(const u64 *)addr2);
diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 4b5e3679a72c..3c75209a545e 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -202,6 +202,22 @@ static __always_inline __must_check bool kfence_free(void *addr)
  */
 bool __must_check kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs *regs);
 
+#ifdef CONFIG_PRINTK
+struct kmem_obj_info;
+/**
+ * __kfence_obj_info() - fill kmem_obj_info struct
+ * @kpp: kmem_obj_info to be filled
+ * @object: the object
+ *
+ * Return:
+ * * false - not a KFENCE object
+ * * true - a KFENCE object, filled @kpp
+ *
+ * Copies information to @kpp for KFENCE objects.
+ */
+bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
+#endif
+
 #else /* CONFIG_KFENCE */
 
 static inline bool is_kfence_address(const void *addr) { return false; }
@@ -219,6 +235,14 @@ static inline bool __must_check kfence_handle_page_fault(unsigned long addr, boo
 	return false;
 }
 
+#ifdef CONFIG_PRINTK
+struct kmem_obj_info;
+static inline bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+{
+	return false;
+}
+#endif
+
 #endif
 
 #endif /* _LINUX_KFENCE_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d9b8df5ef212..d35439db047c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1002,6 +1002,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 }
 
 void mem_cgroup_flush_stats(void);
+void mem_cgroup_flush_stats_delayed(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1422,6 +1423,10 @@ static inline void mem_cgroup_flush_stats(void)
 {
 }
 
+static inline void mem_cgroup_flush_stats_delayed(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 700ea077ce2d..2770db2fa080 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -2,7 +2,7 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
 struct ip_conntrack_stat {
@@ -25,19 +25,21 @@ struct ip_conntrack_stat {
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
 struct nf_conntrack {
-	atomic_t use;
+	refcount_t use;
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
+
+/* like nf_ct_put, but without module dependency on nf_conntrack */
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
+	if (nfct && refcount_dec_and_test(&nfct->use))
 		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		atomic_inc(&nfct->use);
+		refcount_inc(&nfct->use);
 }
 
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9016bbacedf3..ad7ff332a0ac 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1436,6 +1436,7 @@ struct task_struct {
 	int				pagefault_disabled;
 #ifdef CONFIG_MMU
 	struct task_struct		*oom_reaper_list;
+	struct timer_list		oom_reaper_timer;
 #endif
 #ifdef CONFIG_VMAP_STACK
 	struct vm_struct		*stack_vm_area;
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 5561486fddef..95fb7aaaec8d 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -106,6 +106,14 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_MMU
+#ifndef arch_get_mmap_end
+#define arch_get_mmap_end(addr)	(TASK_SIZE)
+#endif
+
+#ifndef arch_get_mmap_base
+#define arch_get_mmap_base(addr, base) (base)
+#endif
+
 extern void arch_pick_mmap_layout(struct mm_struct *mm,
 				  struct rlimit *rlim_stack);
 extern unsigned long
diff --git a/include/net/esp.h b/include/net/esp.h
index 90cd02ff77ef..9c5637d41d95 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,8 +4,6 @@
 
 #include <linux/skbuff.h>
 
-#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
-
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d24b0a34c8f0..34c266502a50 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -76,6 +76,8 @@ struct nf_conn {
 	 * Hint, SKB address this struct and refcnt via skb->_nfct and
 	 * helpers nf_conntrack_get() and nf_conntrack_put().
 	 * Helper nf_ct_put() equals nf_conntrack_put() by dec refcnt,
+	 * except that the latter uses internal indirection and does not
+	 * result in a conntrack module dependency.
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
@@ -169,11 +171,13 @@ nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 	return (struct nf_conn *)(nfct & NFCT_PTRMASK);
 }
 
+void nf_ct_destroy(struct nf_conntrack *nfct);
+
 /* decrement reference count on a conntrack */
 static inline void nf_ct_put(struct nf_conn *ct)
 {
-	WARN_ON(!ct);
-	nf_conntrack_put(&ct->ct_general);
+	if (ct && refcount_dec_and_test(&ct->ct_general.use))
+		nf_ct_destroy(&ct->ct_general);
 }
 
 /* Protocol module loading */
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 6bd7e5a85ce7..ff82983b7ab4 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -75,8 +75,8 @@ struct netns_ipv6 {
 	struct list_head	fib6_walkers;
 	rwlock_t		fib6_walker_lock;
 	spinlock_t		fib6_gc_lock;
-	unsigned int		 ip6_rt_gc_expire;
-	unsigned long		 ip6_rt_last_gc;
+	atomic_t		ip6_rt_gc_expire;
+	unsigned long		ip6_rt_last_gc;
 	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	bool			fib6_has_custom_rules;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4ee233e5a6ff..d1e282f0d6f1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -52,8 +52,10 @@ enum {
 
 #define ISID_SIZE			6
 
-/* Connection suspend "bit" */
-#define ISCSI_SUSPEND_BIT		1
+/* Connection flags */
+#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
+#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
+#define ISCSI_CONN_FLAG_BOUND		BIT(2)
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
@@ -199,8 +201,7 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	unsigned long		suspend_tx;	/* suspend Tx */
-	unsigned long		suspend_rx;	/* suspend Rx */
+	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 037c77fb5dc5..3ecf9702287b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -296,7 +296,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
 struct iscsi_endpoint {
 	void *dd_data;			/* LLD private data */
 	struct device dev;
-	uint64_t id;
+	int id;
 	struct iscsi_cls_conn *conn;
 };
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 8349a9f2c345..9478eccd1c8e 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -296,10 +296,6 @@ dma_addr_t dma_map_resource(struct device *dev, phys_addr_t phys_addr,
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return DMA_MAPPING_ERROR;
 
-	/* Don't allow RAM to be mapped */
-	if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
-		return DMA_MAPPING_ERROR;
-
 	if (dma_map_direct(dev, ops))
 		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
 	else if (ops->map_resource)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 699446d60b6b..7c891a8eb323 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6348,7 +6348,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 again:
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages != nr_pages) {
+		if (data_page_nr(event->rb) != nr_pages) {
 			ret = -EINVAL;
 			goto unlock;
 		}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 228801e20788..aa23ffdaf819 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -116,6 +116,11 @@ static inline int page_order(struct perf_buffer *rb)
 }
 #endif
 
+static inline int data_page_nr(struct perf_buffer *rb)
+{
+	return rb->nr_pages << page_order(rb);
+}
+
 static inline unsigned long perf_data_size(struct perf_buffer *rb)
 {
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 52868716ec35..fb35b926024c 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -859,11 +859,6 @@ void rb_free(struct perf_buffer *rb)
 }
 
 #else
-static int data_page_nr(struct perf_buffer *rb)
-{
-	return rb->nr_pages << page_order(rb);
-}
-
 static struct page *
 __perf_mmap_to_page(struct perf_buffer *rb, unsigned long pgoff)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 02766f3fe206..9a4fa22a69ed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3794,11 +3794,11 @@ static void attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
 
 	se->avg.runnable_sum = se->avg.runnable_avg * divider;
 
-	se->avg.load_sum = divider;
-	if (se_weight(se)) {
-		se->avg.load_sum =
-			div_u64(se->avg.load_avg * se->avg.load_sum, se_weight(se));
-	}
+	se->avg.load_sum = se->avg.load_avg * divider;
+	if (se_weight(se) < se->avg.load_sum)
+		se->avg.load_sum = div_u64(se->avg.load_sum, se_weight(se));
+	else
+		se->avg.load_sum = 1;
 
 	enqueue_load_avg(cfs_rq, se);
 	cfs_rq->avg.util_avg += se->avg.util_avg;
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 51ea9193cecb..86260e8f2830 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -221,27 +221,6 @@ static bool kfence_unprotect(unsigned long addr)
 	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), false));
 }
 
-static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
-{
-	long index;
-
-	/* The checks do not affect performance; only called from slow-paths. */
-
-	if (!is_kfence_address((void *)addr))
-		return NULL;
-
-	/*
-	 * May be an invalid index if called with an address at the edge of
-	 * __kfence_pool, in which case we would report an "invalid access"
-	 * error.
-	 */
-	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
-	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
-		return NULL;
-
-	return &kfence_metadata[index];
-}
-
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index 2a2d5de9d379..92bf6eff6060 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -93,6 +93,27 @@ struct kfence_metadata {
 
 extern struct kfence_metadata kfence_metadata[CONFIG_KFENCE_NUM_OBJECTS];
 
+static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
+{
+	long index;
+
+	/* The checks do not affect performance; only called from slow-paths. */
+
+	if (!is_kfence_address((void *)addr))
+		return NULL;
+
+	/*
+	 * May be an invalid index if called with an address at the edge of
+	 * __kfence_pool, in which case we would report an "invalid access"
+	 * error.
+	 */
+	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
+	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
+		return NULL;
+
+	return &kfence_metadata[index];
+}
+
 /* KFENCE error types for report generation. */
 enum kfence_error_type {
 	KFENCE_ERROR_OOB,		/* Detected a out-of-bounds access. */
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index f93a7b2a338b..37e140e7f201 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -273,3 +273,50 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
 }
+
+#ifdef CONFIG_PRINTK
+static void kfence_to_kp_stack(const struct kfence_track *track, void **kp_stack)
+{
+	int i, j;
+
+	i = get_stack_skipnr(track->stack_entries, track->num_stack_entries, NULL);
+	for (j = 0; i < track->num_stack_entries && j < KS_ADDRS_COUNT; ++i, ++j)
+		kp_stack[j] = (void *)track->stack_entries[i];
+	if (j < KS_ADDRS_COUNT)
+		kp_stack[j] = NULL;
+}
+
+bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+{
+	struct kfence_metadata *meta = addr_to_metadata((unsigned long)object);
+	unsigned long flags;
+
+	if (!meta)
+		return false;
+
+	/*
+	 * If state is UNUSED at least show the pointer requested; the rest
+	 * would be garbage data.
+	 */
+	kpp->kp_ptr = object;
+
+	/* Requesting info an a never-used object is almost certainly a bug. */
+	if (WARN_ON(meta->state == KFENCE_OBJECT_UNUSED))
+		return true;
+
+	raw_spin_lock_irqsave(&meta->lock, flags);
+
+	kpp->kp_page = page;
+	kpp->kp_slab_cache = meta->cache;
+	kpp->kp_objp = (void *)meta->addr;
+	kfence_to_kp_stack(&meta->alloc_track, kpp->kp_stack);
+	if (meta->state == KFENCE_OBJECT_FREED)
+		kfence_to_kp_stack(&meta->free_track, kpp->kp_free_stack);
+	/* get_stack_skipnr() ensures the first entry is outside allocator. */
+	kpp->kp_ret = kpp->kp_stack[0];
+
+	raw_spin_unlock_irqrestore(&meta->lock, flags);
+
+	return true;
+}
+#endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8cdeb33d2cf9..971546bb99e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -650,6 +650,9 @@ static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_SPINLOCK(stats_flush_lock);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+static u64 flush_next_time;
+
+#define FLUSH_TIME (2UL*HZ)
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
@@ -671,6 +674,7 @@ static void __mem_cgroup_flush_stats(void)
 	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
+	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock_irqrestore(&stats_flush_lock, flag);
@@ -682,10 +686,16 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
+void mem_cgroup_flush_stats_delayed(void)
+{
+	if (time_after64(jiffies_64, flush_next_time))
+		mem_cgroup_flush_stats();
+}
+
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	__mem_cgroup_flush_stats();
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
 /**
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f66977a17196..e659a7ef5acf 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1689,6 +1689,19 @@ int memory_failure(unsigned long pfn, int flags)
 	}
 
 	if (PageTransHuge(hpage)) {
+		/*
+		 * Bail out before SetPageHasHWPoisoned() if hpage is
+		 * huge_zero_page, although PG_has_hwpoisoned is not
+		 * checked in set_huge_zero_page().
+		 *
+		 * TODO: Handle memory failure of huge_zero_page thoroughly.
+		 */
+		if (is_huge_zero_page(hpage)) {
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
+			res = -EBUSY;
+			goto unlock_mutex;
+		}
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
diff --git a/mm/mmap.c b/mm/mmap.c
index 049b8e5c18f0..6bb553ed5c55 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2113,14 +2113,6 @@ unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
 	return addr;
 }
 
-#ifndef arch_get_mmap_end
-#define arch_get_mmap_end(addr)	(TASK_SIZE)
-#endif
-
-#ifndef arch_get_mmap_base
-#define arch_get_mmap_base(addr, base) (base)
-#endif
-
 /* Get an address range which is currently unmapped.
  * For shmat() with addr=0.
  *
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 459d195d2ff6..f45ff1b7626a 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -1036,6 +1036,18 @@ int mmu_interval_notifier_insert_locked(
 }
 EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert_locked);
 
+static bool
+mmu_interval_seq_released(struct mmu_notifier_subscriptions *subscriptions,
+			  unsigned long seq)
+{
+	bool ret;
+
+	spin_lock(&subscriptions->lock);
+	ret = subscriptions->invalidate_seq != seq;
+	spin_unlock(&subscriptions->lock);
+	return ret;
+}
+
 /**
  * mmu_interval_notifier_remove - Remove a interval notifier
  * @interval_sub: Interval subscription to unregister
@@ -1083,7 +1095,7 @@ void mmu_interval_notifier_remove(struct mmu_interval_notifier *interval_sub)
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 	if (seq)
 		wait_event(subscriptions->wq,
-			   READ_ONCE(subscriptions->invalidate_seq) != seq);
+			   mmu_interval_seq_released(subscriptions, seq));
 
 	/* pairs with mmgrab in mmu_interval_notifier_insert() */
 	mmdrop(mm);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index bfa9e348c3a3..262f752d3d51 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -635,7 +635,7 @@ static void oom_reap_task(struct task_struct *tsk)
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 
-	/* Drop a reference taken by wake_oom_reaper */
+	/* Drop a reference taken by queue_oom_reaper */
 	put_task_struct(tsk);
 }
 
@@ -645,12 +645,12 @@ static int oom_reaper(void *unused)
 		struct task_struct *tsk = NULL;
 
 		wait_event_freezable(oom_reaper_wait, oom_reaper_list != NULL);
-		spin_lock(&oom_reaper_lock);
+		spin_lock_irq(&oom_reaper_lock);
 		if (oom_reaper_list != NULL) {
 			tsk = oom_reaper_list;
 			oom_reaper_list = tsk->oom_reaper_list;
 		}
-		spin_unlock(&oom_reaper_lock);
+		spin_unlock_irq(&oom_reaper_lock);
 
 		if (tsk)
 			oom_reap_task(tsk);
@@ -659,22 +659,48 @@ static int oom_reaper(void *unused)
 	return 0;
 }
 
-static void wake_oom_reaper(struct task_struct *tsk)
+static void wake_oom_reaper(struct timer_list *timer)
 {
-	/* mm is already queued? */
-	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
-		return;
+	struct task_struct *tsk = container_of(timer, struct task_struct,
+			oom_reaper_timer);
+	struct mm_struct *mm = tsk->signal->oom_mm;
+	unsigned long flags;
 
-	get_task_struct(tsk);
+	/* The victim managed to terminate on its own - see exit_mmap */
+	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
+		put_task_struct(tsk);
+		return;
+	}
 
-	spin_lock(&oom_reaper_lock);
+	spin_lock_irqsave(&oom_reaper_lock, flags);
 	tsk->oom_reaper_list = oom_reaper_list;
 	oom_reaper_list = tsk;
-	spin_unlock(&oom_reaper_lock);
+	spin_unlock_irqrestore(&oom_reaper_lock, flags);
 	trace_wake_reaper(tsk->pid);
 	wake_up(&oom_reaper_wait);
 }
 
+/*
+ * Give the OOM victim time to exit naturally before invoking the oom_reaping.
+ * The timers timeout is arbitrary... the longer it is, the longer the worst
+ * case scenario for the OOM can take. If it is too small, the oom_reaper can
+ * get in the way and release resources needed by the process exit path.
+ * e.g. The futex robust list can sit in Anon|Private memory that gets reaped
+ * before the exit path is able to wake the futex waiters.
+ */
+#define OOM_REAPER_DELAY (2*HZ)
+static void queue_oom_reaper(struct task_struct *tsk)
+{
+	/* mm is already queued? */
+	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
+		return;
+
+	get_task_struct(tsk);
+	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
+	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
+	add_timer(&tsk->oom_reaper_timer);
+}
+
 static int __init oom_init(void)
 {
 	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
@@ -682,7 +708,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static inline void wake_oom_reaper(struct task_struct *tsk)
+static inline void queue_oom_reaper(struct task_struct *tsk)
 {
 }
 #endif /* CONFIG_MMU */
@@ -933,7 +959,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	rcu_read_unlock();
 
 	if (can_oom_reap)
-		wake_oom_reaper(victim);
+		queue_oom_reaper(victim);
 
 	mmdrop(mm);
 	put_task_struct(victim);
@@ -969,7 +995,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	task_lock(victim);
 	if (task_will_free_mem(victim)) {
 		mark_oom_victim(victim);
-		wake_oom_reaper(victim);
+		queue_oom_reaper(victim);
 		task_unlock(victim);
 		put_task_struct(victim);
 		return;
@@ -1067,7 +1093,7 @@ bool out_of_memory(struct oom_control *oc)
 	 */
 	if (task_will_free_mem(current)) {
 		mark_oom_victim(current);
-		wake_oom_reaper(current);
+		queue_oom_reaper(current);
 		return true;
 	}
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a373cd6326b0..47c22810c3c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8169,7 +8169,7 @@ void __init mem_init_print_info(void)
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
 	do { \
-		if (start <= pos && pos < end && size > adj) \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
 			size -= adj; \
 	} while (0)
 
diff --git a/mm/slab.c b/mm/slab.c
index 03d3074d0bb0..1bd283e98c58 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3658,7 +3658,7 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	struct kmem_cache *cachep;
 	unsigned int objnr;
diff --git a/mm/slab.h b/mm/slab.h
index 56ad7eea3ddf..1ae1bdd485c1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -643,7 +643,7 @@ struct kmem_obj_info {
 	void *kp_stack[KS_ADDRS_COUNT];
 	void *kp_free_stack[KS_ADDRS_COUNT];
 };
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
 #endif
 
 #endif /* MM_SLAB_H */
diff --git a/mm/slab_common.c b/mm/slab_common.c
index ec2bb0beed75..022319e7deaf 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -568,6 +568,13 @@ bool kmem_valid_obj(void *object)
 }
 EXPORT_SYMBOL_GPL(kmem_valid_obj);
 
+static void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+{
+	if (__kfence_obj_info(kpp, object, page))
+		return;
+	__kmem_obj_info(kpp, object, page);
+}
+
 /**
  * kmem_dump_obj - Print available slab provenance information
  * @object: slab object for which to find provenance information.
@@ -603,6 +610,8 @@ void kmem_dump_obj(void *object)
 		pr_cont(" slab%s %s", cp, kp.kp_slab_cache->name);
 	else
 		pr_cont(" slab%s", cp);
+	if (is_kfence_address(object))
+		pr_cont(" (kfence)");
 	if (kp.kp_objp)
 		pr_cont(" start %px", kp.kp_objp);
 	if (kp.kp_data_offset)
diff --git a/mm/slob.c b/mm/slob.c
index 74d3f6e60666..f3fc15df971a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -462,7 +462,7 @@ static void slob_free(void *block, int size)
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	kpp->kp_ptr = object;
 	kpp->kp_page = page;
diff --git a/mm/slub.c b/mm/slub.c
index ca6ba6bdf27b..b75eebc0350e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4299,7 +4299,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	void *base;
 	int __maybe_unused i;
diff --git a/mm/workingset.c b/mm/workingset.c
index d5b81e4f4cbe..880d882f3325 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -352,7 +352,7 @@ void workingset_refault(struct page *page, void *shadow)
 
 	inc_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_delayed();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 5bce7c66c121..8c753dcefe7f 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -866,6 +866,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct canfd_frame *cf;
 	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
 	int wait_tx_done = (so->opt.flags & CAN_ISOTP_WAIT_TX_DONE) ? 1 : 0;
+	s64 hrtimer_sec = 0;
 	int off;
 	int err;
 
@@ -964,7 +965,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		isotp_create_fframe(cf, so, ae);
 
 		/* start timeout for FC */
-		hrtimer_start(&so->txtimer, ktime_set(1, 0), HRTIMER_MODE_REL_SOFT);
+		hrtimer_sec = 1;
+		hrtimer_start(&so->txtimer, ktime_set(hrtimer_sec, 0),
+			      HRTIMER_MODE_REL_SOFT);
 	}
 
 	/* send the first or only CAN frame */
@@ -977,6 +980,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
+
+		/* no transmission -> no timeout monitoring */
+		if (hrtimer_sec)
+			hrtimer_cancel(&so->txtimer);
+
 		goto err_out_drop;
 	}
 
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index f64b805303cd..eb204ad36eee 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -21,6 +21,14 @@ static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *tag;
 
+	/* Calculate checksums (if required) before adding the trailer tag to
+	 * avoid including it in calculations. That would lead to wrong
+	 * checksums after the switch strips the tag.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_checksum_help(skb))
+		return NULL;
+
 	/* Tag encoding */
 	tag  = skb_put(skb, HELLCREEK_TAG_LEN);
 	*tag = BIT(dp->index);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 70e6c87fbe3d..d747166bb291 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -446,7 +446,6 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
@@ -456,8 +455,8 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 5023f59a5b96..6219d97cac7a 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -483,7 +483,6 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	if (x->encap) {
 		int err = esp6_output_encap(x, skb, esp);
@@ -492,8 +491,8 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 466a5610e3ca..869c3337e319 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -733,9 +733,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	else
 		fl6->daddr = tunnel->parms.raddr;
 
-	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
-		return -ENOMEM;
-
 	/* Push GRE header. */
 	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
 
@@ -743,6 +740,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
 		__be16 flags;
+		int tun_hlen;
 
 		tun_info = skb_tunnel_info_txcheck(skb);
 		if (IS_ERR(tun_info) ||
@@ -760,9 +758,12 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		dsfield = key->tos;
 		flags = key->tun_flags &
 			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
-		tunnel->tun_hlen = gre_calc_hlen(flags);
+		tun_hlen = gre_calc_hlen(flags);
 
-		gre_build_header(skb, tunnel->tun_hlen,
+		if (skb_cow_head(skb, dev->needed_headroom ?: tun_hlen + tunnel->encap_hlen))
+			return -ENOMEM;
+
+		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
 				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
@@ -772,6 +773,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		if (tunnel->parms.o_flags & TUNNEL_SEQ)
 			tunnel->o_seqno++;
 
+		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
+			return -ENOMEM;
+
 		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
 				 protocol, tunnel->parms.o_key,
 				 htonl(tunnel->o_seqno));
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6b269595efaa..0ca7c780d97a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3303,6 +3303,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
 	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
 	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
+	unsigned int val;
 	int entries;
 
 	entries = dst_entries_get_fast(ops);
@@ -3313,13 +3314,13 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	    entries <= rt_max_size)
 		goto out;
 
-	net->ipv6.ip6_rt_gc_expire++;
-	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
+	fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
 	entries = dst_entries_get_slow(ops);
 	if (entries < ops->gc_thresh)
-		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
+		atomic_set(&net->ipv6.ip6_rt_gc_expire, rt_gc_timeout >> 1);
 out:
-	net->ipv6.ip6_rt_gc_expire -= net->ipv6.ip6_rt_gc_expire>>rt_elasticity;
+	val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
+	atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
 	return entries > rt_max_size;
 }
 
@@ -6528,7 +6529,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.skip_notify_on_dev_down = 0;
 
-	net->ipv6.ip6_rt_gc_expire = 30*HZ;
+	atomic_set(&net->ipv6.ip6_rt_gc_expire, 30*HZ);
 
 	ret = 0;
 out:
diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index 17927966abb3..8b14a24f1040 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -147,7 +147,7 @@ int l3mdev_master_upper_ifindex_by_index_rcu(struct net *net, int ifindex)
 
 	dev = dev_get_by_index_rcu(net, ifindex);
 	while (dev && !netif_is_l3_master(dev))
-		dev = netdev_master_upper_dev_get(dev);
+		dev = netdev_master_upper_dev_get_rcu(dev);
 
 	return dev ? dev->ifindex : 0;
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3a98a1316307..31399c53dfb1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -571,7 +571,7 @@ static void nf_ct_del_from_dying_or_unconfirmed_list(struct nf_conn *ct)
 
 #define NFCT_ALIGN(len)	(((len) + NFCT_INFOMASK) & ~NFCT_INFOMASK)
 
-/* Released via destroy_conntrack() */
+/* Released via nf_ct_destroy() */
 struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 				 const struct nf_conntrack_zone *zone,
 				 gfp_t flags)
@@ -598,7 +598,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 	nf_ct_zone_add(tmpl, zone);
-	atomic_set(&tmpl->ct_general.use, 0);
+	refcount_set(&tmpl->ct_general.use, 1);
 
 	return tmpl;
 }
@@ -625,13 +625,12 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
 #endif
 }
 
-static void
-destroy_conntrack(struct nf_conntrack *nfct)
+void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
-	pr_debug("destroy_conntrack(%p)\n", ct);
-	WARN_ON(atomic_read(&nfct->use) != 0);
+	pr_debug("%s(%p)\n", __func__, ct);
+	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -656,9 +655,10 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (ct->master)
 		nf_ct_put(ct->master);
 
-	pr_debug("destroy_conntrack: returning ct=%p to slab\n", ct);
+	pr_debug("%s: returning ct=%p to slab\n", __func__, ct);
 	nf_conntrack_free(ct);
 }
+EXPORT_SYMBOL(nf_ct_destroy);
 
 static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
@@ -755,7 +755,7 @@ nf_ct_match(const struct nf_conn *ct1, const struct nf_conn *ct2)
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
 	if (nf_ct_should_gc(ct))
@@ -823,7 +823,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		 * in, try to obtain a reference and re-check tuple
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
+		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -920,7 +920,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
-	atomic_set(&ct->ct_general.use, 2);
+	refcount_set(&ct->ct_general.use, 2);
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
@@ -971,7 +971,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 {
 	struct nf_conn_tstamp *tstamp;
 
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	ct->status |= IPS_CONFIRMED;
 
 	/* set conntrack timestamp, if enabled. */
@@ -1364,7 +1364,7 @@ static unsigned int early_drop_list(struct net *net,
 		    nf_ct_is_dying(tmp))
 			continue;
 
-		if (!atomic_inc_not_zero(&tmp->ct_general.use))
+		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
 		/* kill only if still in same netns -- might have moved due to
@@ -1513,7 +1513,7 @@ static void gc_worker(struct work_struct *work)
 				continue;
 
 			/* need to take reference to avoid possible races */
-			if (!atomic_inc_not_zero(&tmp->ct_general.use))
+			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
 			if (gc_worker_skip_ct(tmp)) {
@@ -1622,7 +1622,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
-	atomic_set(&ct->ct_general.use, 0);
+	refcount_set(&ct->ct_general.use, 0);
 	return ct;
 out:
 	atomic_dec(&cnet->count);
@@ -1647,7 +1647,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
 	 */
-	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
+	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
@@ -1739,8 +1739,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
-	/* Now it is inserted into the unconfirmed list, bump refcount */
-	nf_conntrack_get(&ct->ct_general);
+	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
+	refcount_set(&ct->ct_general.use, 1);
 	nf_ct_add_to_unconfirmed_list(ct);
 
 	local_bh_enable();
@@ -2352,7 +2352,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 
 	return NULL;
 found:
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	spin_unlock(lockp);
 	local_bh_enable();
 	return ct;
@@ -2825,7 +2825,7 @@ int nf_conntrack_init_start(void)
 
 static struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
-	.destroy	= destroy_conntrack,
+	.destroy	= nf_ct_destroy,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
 };
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f562eeef4234..6d056ebba57c 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -203,12 +203,12 @@ nf_ct_find_expectation(struct net *net,
 	 * about to invoke ->destroy(), or nf_ct_delete() via timeout
 	 * or early_drop().
 	 *
-	 * The atomic_inc_not_zero() check tells:  If that fails, we
+	 * The refcount_inc_not_zero() check tells:  If that fails, we
 	 * know that the ct is being destroyed.  If it succeeds, we
 	 * can be sure the ct cannot disappear underneath.
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
-		     !atomic_inc_not_zero(&exp->master->ct_general.use)))
+		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1c02be04aaf5..ef0a78aa9ba9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -508,7 +508,7 @@ static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 
 static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
+	if (nla_put_be32(skb, CTA_USE, htonl(refcount_read(&ct->ct_general.use))))
 		goto nla_put_failure;
 	return 0;
 
@@ -1200,7 +1200,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
-				    atomic_inc_not_zero(&ct->ct_general.use))
+				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
 				continue;
 			}
@@ -1748,7 +1748,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 						  ct, dying ? true : false, 0);
 			if (res < 0) {
-				if (!atomic_inc_not_zero(&ct->ct_general.use))
+				if (!refcount_inc_not_zero(&ct->ct_general.use))
 					continue;
 				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 80f675d884b2..3e1afd10a9b6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -303,7 +303,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	int ret = 0;
 
 	WARN_ON(!ct);
-	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
 	if (nf_ct_should_gc(ct)) {
@@ -370,7 +370,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	ct_show_zone(s, ct, NF_CT_DEFAULT_ZONE_DIR);
 	ct_show_delta_time(s, ct);
 
-	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	seq_printf(s, "use=%u\n", refcount_read(&ct->ct_general.use));
 
 	if (seq_has_overflowed(s))
 		goto release;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index ed37bb9b4e58..b90eca7a2f22 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -48,7 +48,7 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 	struct flow_offload *flow;
 
 	if (unlikely(nf_ct_is_dying(ct) ||
-	    !atomic_inc_not_zero(&ct->ct_general.use)))
+	    !refcount_inc_not_zero(&ct->ct_general.use)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 3d6d49420db8..2dfc5dae0656 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -349,7 +349,6 @@ static int __net_init synproxy_net_init(struct net *net)
 		goto err2;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 	snet->tmpl = ct;
 
 	snet->stats = alloc_percpu(struct synproxy_stats);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 54ecb9fbf2de..9c7472af9e4a 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -259,10 +259,13 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(atomic_read(&ct->ct_general.use) == 1)) {
+	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_zone_add(ct, &zone);
 	} else {
-		/* previous skb got queued to userspace */
+		/* previous skb got queued to userspace, allocate temporary
+		 * one until percpu template can be reused.
+		 */
 		ct = nf_ct_tmpl_alloc(nft_net(pkt), &zone, GFP_ATOMIC);
 		if (!ct) {
 			regs->verdict.code = NF_DROP;
@@ -270,7 +273,6 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 		}
 	}
 
-	atomic_inc(&ct->ct_general.use);
 	nf_ct_set(skb, ct, IP_CT_NEW);
 }
 #endif
@@ -375,7 +377,6 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 			return false;
 		}
 
-		atomic_set(&tmp->ct_general.use, 1);
 		per_cpu(nft_ct_pcpu_template, cpu) = tmp;
 	}
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 0a913ce07425..267757b0392a 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -24,7 +24,7 @@ static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 		return XT_CONTINUE;
 
 	if (ct) {
-		atomic_inc(&ct->ct_general.use);
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_set(skb, ct, IP_CT_NEW);
 	} else {
 		nf_ct_set(skb, ct, IP_CT_UNTRACKED);
@@ -201,7 +201,6 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			goto err4;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 out:
 	info->ct = ct;
 	return 0;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 83ca93b32f5f..fb7f7b17c78c 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2284,6 +2284,13 @@ static int netlink_dump(struct sock *sk)
 	 * single netdev. The outcome is MSG_TRUNC error.
 	 */
 	skb_reserve(skb, skb_tailroom(skb) - alloc_size);
+
+	/* Make sure malicious BPF programs can not read unitialized memory
+	 * from skb->head -> skb->data
+	 */
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
 	netlink_skb_set_owner_r(skb, sk);
 
 	if (nlk->dump_done_errno > 0) {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index f2b64cab9af7..815916056e0d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1722,7 +1722,6 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 		goto err_free_ct;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct_info.ct->status);
-	nf_conntrack_get(&ct_info.ct->ct_general);
 	return 0;
 err_free_ct:
 	__ovs_ct_free_action(&ct_info);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index c591b923016a..d77c21ff066c 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2436,7 +2436,7 @@ static struct nlattr *reserve_sfa_size(struct sw_flow_actions **sfa,
 	new_acts_size = max(next_offset + req_size, ksize(*sfa) * 2);
 
 	if (new_acts_size > MAX_ACTIONS_BUFSIZE) {
-		if ((MAX_ACTIONS_BUFSIZE - next_offset) < req_size) {
+		if ((next_offset + req_size) > MAX_ACTIONS_BUFSIZE) {
 			OVS_NLERR(log, "Flow action size exceeds max %u",
 				  MAX_ACTIONS_BUFSIZE);
 			return ERR_PTR(-EMSGSIZE);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c0d4a65931de..88c3b5cf8d94 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2820,8 +2820,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = po->xmit(skb);
-		if (unlikely(err > 0)) {
-			err = net_xmit_errno(err);
+		if (unlikely(err != 0)) {
+			if (err > 0)
+				err = net_xmit_errno(err);
 			if (err && __packet_get_status(po, ph) ==
 				   TP_STATUS_AVAILABLE) {
 				/* skb was destructed already */
@@ -3022,8 +3023,12 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		skb->no_fcs = 1;
 
 	err = po->xmit(skb);
-	if (err > 0 && (err = net_xmit_errno(err)) != 0)
-		goto out_unlock;
+	if (unlikely(err != 0)) {
+		if (err > 0)
+			err = net_xmit_errno(err);
+		if (err)
+			goto out_unlock;
+	}
 
 	dev_put(dev);
 
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index f15d6942da45..cc7e30733feb 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -113,7 +113,9 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 
 	rxnet->live = false;
+	del_timer_sync(&rxnet->peer_keepalive_timer);
 	cancel_work_sync(&rxnet->peer_keepalive_work);
+	/* Remove the timer again as the worker may have restarted it. */
 	del_timer_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 553bf41671a6..f4fd584fba08 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1232,7 +1232,6 @@ static int tcf_ct_fill_params(struct net *net,
 		return -ENOMEM;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
-	nf_conntrack_get(&tmpl->ct_general);
 	p->tmpl = tmpl;
 
 	return 0;
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4272814487f0..5d30db0d7157 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -386,14 +386,19 @@ static int u32_init(struct tcf_proto *tp)
 	return 0;
 }
 
-static int u32_destroy_key(struct tc_u_knode *n, bool free_pf)
+static void __u32_destroy_key(struct tc_u_knode *n)
 {
 	struct tc_u_hnode *ht = rtnl_dereference(n->ht_down);
 
 	tcf_exts_destroy(&n->exts);
-	tcf_exts_put_net(&n->exts);
 	if (ht && --ht->refcnt == 0)
 		kfree(ht);
+	kfree(n);
+}
+
+static void u32_destroy_key(struct tc_u_knode *n, bool free_pf)
+{
+	tcf_exts_put_net(&n->exts);
 #ifdef CONFIG_CLS_U32_PERF
 	if (free_pf)
 		free_percpu(n->pf);
@@ -402,8 +407,7 @@ static int u32_destroy_key(struct tc_u_knode *n, bool free_pf)
 	if (free_pf)
 		free_percpu(n->pcpu_success);
 #endif
-	kfree(n);
-	return 0;
+	__u32_destroy_key(n);
 }
 
 /* u32_delete_key_rcu should be called when free'ing a copied
@@ -810,10 +814,6 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	new->flags = n->flags;
 	RCU_INIT_POINTER(new->ht_down, ht);
 
-	/* bump reference count as long as we hold pointer to structure */
-	if (ht)
-		ht->refcnt++;
-
 #ifdef CONFIG_CLS_U32_PERF
 	/* Statistics may be incremented by readers during update
 	 * so we must keep them in tact. When the node is later destroyed
@@ -835,6 +835,10 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 		return NULL;
 	}
 
+	/* bump reference count as long as we hold pointer to structure */
+	if (ht)
+		ht->refcnt++;
+
 	return new;
 }
 
@@ -898,13 +902,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 				    tca[TCA_RATE], flags, extack);
 
 		if (err) {
-			u32_destroy_key(new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
 		err = u32_replace_hw_knode(tp, new, flags, extack);
 		if (err) {
-			u32_destroy_key(new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fa8897497dcc..499058248bdb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2332,8 +2332,10 @@ static int smc_shutdown(struct socket *sock, int how)
 	if (smc->use_fallback) {
 		rc = kernel_sock_shutdown(smc->clcsock, how);
 		sk->sk_shutdown = smc->clcsock->sk->sk_shutdown;
-		if (sk->sk_shutdown == SHUTDOWN_MASK)
+		if (sk->sk_shutdown == SHUTDOWN_MASK) {
 			sk->sk_state = SMC_CLOSED;
+			sock_put(sk);
+		}
 		goto out;
 	}
 	switch (how) {
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 472d81679a27..24da843f39a1 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1387,7 +1387,7 @@ static int hdmi_find_pcm_slot(struct hdmi_spec *spec,
 
  last_try:
 	/* the last try; check the empty slots in pins */
-	for (i = 0; i < spec->num_nids; i++) {
+	for (i = 0; i < spec->pcm_used; i++) {
 		if (!test_bit(i, &spec->pcm_bitmap))
 			return i;
 	}
@@ -2263,7 +2263,9 @@ static int generic_hdmi_build_pcms(struct hda_codec *codec)
 	 * dev_num is the device entry number in a pin
 	 */
 
-	if (codec->mst_no_extra_pcms)
+	if (spec->dyn_pcm_no_legacy && codec->mst_no_extra_pcms)
+		pcm_num = spec->num_cvts;
+	else if (codec->mst_no_extra_pcms)
 		pcm_num = spec->num_nids;
 	else
 		pcm_num = spec->num_nids + spec->dev_num - 1;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5ae20cbbd5c0..9771300683c4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8962,6 +8962,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x8562, "Clevo NH[57][0-9]RZ[Q]", ALC269_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1558, 0x8668, "Clevo NP50B[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x866d, "Clevo NP5[05]PN[HJK]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x867c, "Clevo NP7[01]PNP", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x867d, "Clevo NP7[01]PN[HJK]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8680, "Clevo NJ50LU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME),
diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 8a55d59a6c2a..d243de5f23dc 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -46,35 +46,6 @@
  */
 #undef ENABLE_MIC_INPUT
 
-static struct clk *mclk;
-
-static int at91sam9g20ek_set_bias_level(struct snd_soc_card *card,
-					struct snd_soc_dapm_context *dapm,
-					enum snd_soc_bias_level level)
-{
-	static int mclk_on;
-	int ret = 0;
-
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-	case SND_SOC_BIAS_PREPARE:
-		if (!mclk_on)
-			ret = clk_enable(mclk);
-		if (ret == 0)
-			mclk_on = 1;
-		break;
-
-	case SND_SOC_BIAS_OFF:
-	case SND_SOC_BIAS_STANDBY:
-		if (mclk_on)
-			clk_disable(mclk);
-		mclk_on = 0;
-		break;
-	}
-
-	return ret;
-}
-
 static const struct snd_soc_dapm_widget at91sam9g20ek_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("Int Mic", NULL),
 	SND_SOC_DAPM_SPK("Ext Spk", NULL),
@@ -135,7 +106,6 @@ static struct snd_soc_card snd_soc_at91sam9g20ek = {
 	.owner = THIS_MODULE,
 	.dai_link = &at91sam9g20ek_dai,
 	.num_links = 1,
-	.set_bias_level = at91sam9g20ek_set_bias_level,
 
 	.dapm_widgets = at91sam9g20ek_dapm_widgets,
 	.num_dapm_widgets = ARRAY_SIZE(at91sam9g20ek_dapm_widgets),
@@ -148,7 +118,6 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *codec_np, *cpu_np;
-	struct clk *pllb;
 	struct snd_soc_card *card = &snd_soc_at91sam9g20ek;
 	int ret;
 
@@ -162,31 +131,6 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/*
-	 * Codec MCLK is supplied by PCK0 - set it up.
-	 */
-	mclk = clk_get(NULL, "pck0");
-	if (IS_ERR(mclk)) {
-		dev_err(&pdev->dev, "Failed to get MCLK\n");
-		ret = PTR_ERR(mclk);
-		goto err;
-	}
-
-	pllb = clk_get(NULL, "pllb");
-	if (IS_ERR(pllb)) {
-		dev_err(&pdev->dev, "Failed to get PLLB\n");
-		ret = PTR_ERR(pllb);
-		goto err_mclk;
-	}
-	ret = clk_set_parent(mclk, pllb);
-	clk_put(pllb);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "Failed to set MCLK parent\n");
-		goto err_mclk;
-	}
-
-	clk_set_rate(mclk, MCLK_RATE);
-
 	card->dev = &pdev->dev;
 
 	/* Parse device node info */
@@ -230,9 +174,6 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 
 	return ret;
 
-err_mclk:
-	clk_put(mclk);
-	mclk = NULL;
 err:
 	atmel_ssc_put_audio(0);
 	return ret;
@@ -242,8 +183,6 @@ static int at91sam9g20ek_audio_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	clk_disable(mclk);
-	mclk = NULL;
 	snd_soc_unregister_card(card);
 	atmel_ssc_put_audio(0);
 
diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index 9ad7fc0baf07..20a07c92b2fc 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -1206,9 +1206,16 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, priv);
 
-	return devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
+	ret = devm_snd_soc_register_component(dev, &msm8916_wcd_digital,
 				      msm8916_wcd_digital_dai,
 				      ARRAY_SIZE(msm8916_wcd_digital_dai));
+	if (ret)
+		goto err_mclk;
+
+	return 0;
+
+err_mclk:
+	clk_disable_unprepare(priv->mclk);
 err_clk:
 	clk_disable_unprepare(priv->ahbclk);
 	return ret;
diff --git a/sound/soc/codecs/rk817_codec.c b/sound/soc/codecs/rk817_codec.c
index 8fffe378618d..cce6f4e7992f 100644
--- a/sound/soc/codecs/rk817_codec.c
+++ b/sound/soc/codecs/rk817_codec.c
@@ -489,7 +489,7 @@ static int rk817_platform_probe(struct platform_device *pdev)
 
 	rk817_codec_parse_dt_property(&pdev->dev, rk817_codec_data);
 
-	rk817_codec_data->mclk = clk_get(pdev->dev.parent, "mclk");
+	rk817_codec_data->mclk = devm_clk_get(pdev->dev.parent, "mclk");
 	if (IS_ERR(rk817_codec_data->mclk)) {
 		dev_dbg(&pdev->dev, "Unable to get mclk\n");
 		ret = -ENXIO;
diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index 7b99318070cf..144046864d15 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1274,29 +1274,7 @@ static int wcd934x_set_sido_input_src(struct wcd934x_codec *wcd, int sido_src)
 	if (sido_src == wcd->sido_input_src)
 		return 0;
 
-	if (sido_src == SIDO_SOURCE_INTERNAL) {
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_HI_ACCU_EN_MASK, 0);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_HI_ACCU_PRE_ENX_MASK, 0x0);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_RCO,
-				   WCD934X_ANA_RCO_BG_EN_MASK, 0);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_PRE_EN1_MASK,
-				   WCD934X_ANA_BUCK_PRE_EN1_ENABLE);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_PRE_EN2_MASK,
-				   WCD934X_ANA_BUCK_PRE_EN2_ENABLE);
-		usleep_range(100, 110);
-		regmap_update_bits(wcd->regmap, WCD934X_ANA_BUCK_CTL,
-				   WCD934X_ANA_BUCK_HI_ACCU_EN_MASK,
-				   WCD934X_ANA_BUCK_HI_ACCU_ENABLE);
-		usleep_range(100, 110);
-	} else if (sido_src == SIDO_SOURCE_RCO_BG) {
+	if (sido_src == SIDO_SOURCE_RCO_BG) {
 		regmap_update_bits(wcd->regmap, WCD934X_ANA_RCO,
 				   WCD934X_ANA_RCO_BG_EN_MASK,
 				   WCD934X_ANA_RCO_BG_ENABLE);
@@ -1382,8 +1360,6 @@ static int wcd934x_disable_ana_bias_and_syclk(struct wcd934x_codec *wcd)
 	regmap_update_bits(wcd->regmap, WCD934X_CLK_SYS_MCLK_PRG,
 			   WCD934X_EXT_CLK_BUF_EN_MASK |
 			   WCD934X_MCLK_EN_MASK, 0x0);
-	wcd934x_set_sido_input_src(wcd, SIDO_SOURCE_INTERNAL);
-
 	regmap_update_bits(wcd->regmap, WCD934X_ANA_BIAS,
 			   WCD934X_ANA_BIAS_EN_MASK, 0);
 	regmap_update_bits(wcd->regmap, WCD934X_ANA_BIAS,
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 0479bb0005ab..0b166e074457 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1685,8 +1685,7 @@ static void dapm_seq_run(struct snd_soc_card *card,
 		switch (w->id) {
 		case snd_soc_dapm_pre:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
@@ -1698,8 +1697,7 @@ static void dapm_seq_run(struct snd_soc_card *card,
 
 		case snd_soc_dapm_post:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 561eddfc8c22..eff8d4f71561 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1481,12 +1481,12 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 	template.num_kcontrols = le32_to_cpu(w->num_kcontrols);
 	kc = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(*kc), GFP_KERNEL);
 	if (!kc)
-		goto err;
+		goto hdr_err;
 
 	kcontrol_type = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(unsigned int),
 				     GFP_KERNEL);
 	if (!kcontrol_type)
-		goto err;
+		goto hdr_err;
 
 	for (i = 0; i < w->num_kcontrols; i++) {
 		control_hdr = (struct snd_soc_tplg_ctl_hdr *)tplg->pos;
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 2c01649c70f6..7c6ca2b433a5 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1194,6 +1194,7 @@ static void snd_usbmidi_output_drain(struct snd_rawmidi_substream *substream)
 		} while (drain_urbs && timeout);
 		finish_wait(&ep->drain_wait, &wait);
 	}
+	port->active = 0;
 	spin_unlock_irq(&ep->buffer_lock);
 }
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 167834133b9b..b8359a0aa008 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -8,7 +8,7 @@
  */
 
 /* handling of USB vendor/product ID pairs as 32-bit numbers */
-#define USB_ID(vendor, product) (((vendor) << 16) | (product))
+#define USB_ID(vendor, product) (((unsigned int)(vendor) << 16) | (product))
 #define USB_ID_VENDOR(id) ((id) >> 16)
 #define USB_ID_PRODUCT(id) ((u16)(id))
 
diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index e37dfad31383..5146ff0fa078 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -577,7 +577,6 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 {
 	struct perf_evsel *evsel;
 	const struct perf_cpu_map *cpus = evlist->cpus;
-	const struct perf_thread_map *threads = evlist->threads;
 
 	if (!ops || !ops->get || !ops->mmap)
 		return -EINVAL;
@@ -589,7 +588,7 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 	perf_evlist__for_each_entry(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, perf_cpu_map__nr(cpus), threads->nr) < 0)
+		    perf_evsel__alloc_id(evsel, evsel->fd->max_x, evsel->fd->max_y) < 0)
 			return -ENOMEM;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 997e0a4b0902..6583ad9cc7de 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -349,6 +349,7 @@ static int report__setup_sample_type(struct report *rep)
 	struct perf_session *session = rep->session;
 	u64 sample_type = evlist__combined_sample_type(session->evlist);
 	bool is_pipe = perf_data__is_pipe(session->data);
+	struct evsel *evsel;
 
 	if (session->itrace_synth_opts->callchain ||
 	    session->itrace_synth_opts->add_callchain ||
@@ -403,6 +404,19 @@ static int report__setup_sample_type(struct report *rep)
 	}
 
 	if (sort__mode == SORT_MODE__MEMORY) {
+		/*
+		 * FIXUP: prior to kernel 5.18, Arm SPE missed to set
+		 * PERF_SAMPLE_DATA_SRC bit in sample type.  For backward
+		 * compatibility, set the bit if it's an old perf data file.
+		 */
+		evlist__for_each_entry(session->evlist, evsel) {
+			if (strstr(evsel->name, "arm_spe") &&
+				!(sample_type & PERF_SAMPLE_DATA_SRC)) {
+				evsel->core.attr.sample_type |= PERF_SAMPLE_DATA_SRC;
+				sample_type |= PERF_SAMPLE_DATA_SRC;
+			}
+		}
+
 		if (!is_pipe && !(sample_type & PERF_SAMPLE_DATA_SRC)) {
 			ui__error("Selected --mem-mode but no mem data. "
 				  "Did you call perf record without -d?\n");
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 18b56256bb6f..cb3d81adf5ca 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -455,7 +455,7 @@ static int evsel__check_attr(struct evsel *evsel, struct perf_session *session)
 		return -EINVAL;
 
 	if (PRINT_FIELD(DATA_SRC) &&
-	    evsel__check_stype(evsel, PERF_SAMPLE_DATA_SRC, "DATA_SRC", PERF_OUTPUT_DATA_SRC))
+	    evsel__do_check_stype(evsel, PERF_SAMPLE_DATA_SRC, "DATA_SRC", PERF_OUTPUT_DATA_SRC, allow_user_set))
 		return -EINVAL;
 
 	if (PRINT_FIELD(WEIGHT) &&
diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh
index fedcb7b35af9..af5ea50ed5c0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh
@@ -172,6 +172,17 @@ flooding_filters_add()
 	local lsb
 	local i
 
+	# Prevent unwanted packets from entering the bridge and interfering
+	# with the test.
+	tc qdisc add dev br0 clsact
+	tc filter add dev br0 egress protocol all pref 1 handle 1 \
+		matchall skip_hw action drop
+	tc qdisc add dev $h1 clsact
+	tc filter add dev $h1 egress protocol all pref 1 handle 1 \
+		flower skip_hw dst_mac de:ad:be:ef:13:37 action pass
+	tc filter add dev $h1 egress protocol all pref 2 handle 2 \
+		matchall skip_hw action drop
+
 	tc qdisc add dev $rp2 clsact
 
 	for i in $(eval echo {1..$num_remotes}); do
@@ -194,6 +205,12 @@ flooding_filters_del()
 	done
 
 	tc qdisc del dev $rp2 clsact
+
+	tc filter del dev $h1 egress protocol all pref 2 handle 2 matchall
+	tc filter del dev $h1 egress protocol all pref 1 handle 1 flower
+	tc qdisc del dev $h1 clsact
+	tc filter del dev br0 egress protocol all pref 1 handle 1 matchall
+	tc qdisc del dev br0 clsact
 }
 
 flooding_check_packets()
