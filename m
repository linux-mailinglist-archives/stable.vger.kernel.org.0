Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79A1612179
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 10:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJ2Ijp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 04:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJ2Ijn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 04:39:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8C51F2D8;
        Sat, 29 Oct 2022 01:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB98960E08;
        Sat, 29 Oct 2022 08:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B359C433C1;
        Sat, 29 Oct 2022 08:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667032774;
        bh=pV6BKQA2rOeNxXc7Ciy0z+IYJx/zbqfl4GlGph6cobc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/jCz58YQY6efDv4LVoHi13/3kyoLFvcVO9+Fduvkgz2OAnKv/OYErcY0riwhN5Zo
         jlkk6KO0ERwd1RSHgiFP7csL2clofxvCkTMsN2+974Xy716LPzmEY0LrIVB1z59fPl
         f9krNyESr+pNxEVNcYP0oftMABsbpjVvEMkZ8ctI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.6
Date:   Sat, 29 Oct 2022 10:40:20 +0200
Message-Id: <16670328205245@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1667032820213146@kroah.com>
References: <1667032820213146@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 62a7398c8d06..e6c10009d413 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 5
+SUBLEVEL = 6
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9d3299a70242..a4dff86d39f0 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2149,7 +2149,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -2162,6 +2162,9 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 159c025ebb03..4728d3f5d5c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1961,7 +1961,6 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI
-	depends on $(cc-option,-mabi=ms) || X86_32
 	select RELOCATABLE
 	help
 	  This kernel feature allows a bzImage to be loaded directly
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 0bef44d30a27..2fd52b65deac 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -25,8 +25,10 @@ arch_rmrr_sanity_check(struct acpi_dmar_reserved_memory *rmrr)
 {
 	u64 start = rmrr->base_address;
 	u64 end = rmrr->end_address + 1;
+	int entry_type;
 
-	if (e820__mapped_all(start, end, E820_TYPE_RESERVED))
+	entry_type = e820__get_entry_type(start, end);
+	if (entry_type == E820_TYPE_RESERVED || entry_type == E820_TYPE_NVS)
 		return 0;
 
 	pr_err(FW_BUG "No firmware reserved region can cover this RMRR [%#018Lx-%#018Lx], contact BIOS vendor for fixes\n",
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 615bc6efa1dd..72869276326b 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -440,7 +440,13 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, size_t size, bool save_p
 		return ret;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev >= mc->hdr.patch_id)
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (rev > mc->hdr.patch_id)
 		return ret;
 
 	if (!__apply_microcode_amd(mc)) {
@@ -528,8 +534,12 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* Check whether we have saved a new patch already: */
-	if (*new_rev && rev < mc->hdr.patch_id) {
+	/*
+	 * Check whether a new patch has been saved already. Also, allow application of
+	 * the same revision in order to pick up SMT-thread-specific configuration even
+	 * if the sibling SMT thread already has an up-to-date revision.
+	 */
+	if (*new_rev && rev <= mc->hdr.patch_id) {
 		if (!__apply_microcode_amd(mc)) {
 			*new_rev = mc->hdr.patch_id;
 			return;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index bb1c3f5f60c8..a5c51a14fbce 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -66,9 +66,6 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.rid			= RDT_RESOURCE_L3,
 			.name			= "L3",
 			.cache_level		= 3,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L3),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -83,9 +80,6 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.rid			= RDT_RESOURCE_L2,
 			.name			= "L2",
 			.cache_level		= 2,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L2),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -877,6 +871,7 @@ static __init void rdt_init_res_defs_intel(void)
 			r->cache.arch_has_sparse_bitmaps = false;
 			r->cache.arch_has_empty_bitmaps = false;
 			r->cache.arch_has_per_cpu_cfg = false;
+			r->cache.min_cbm_bits = 1;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_THRTL_BASE;
 			hw_res->msr_update = mba_wrmsr_intel;
@@ -897,6 +892,7 @@ static __init void rdt_init_res_defs_amd(void)
 			r->cache.arch_has_sparse_bitmaps = true;
 			r->cache.arch_has_empty_bitmaps = true;
 			r->cache.arch_has_per_cpu_cfg = true;
+			r->cache.min_cbm_bits = 0;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 132a2de44d2f..5e868b62a7c4 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -96,6 +96,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	unsigned int ht_mask_width, core_plus_mask_width, die_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
 	unsigned int die_select_mask, die_level_siblings;
+	unsigned int pkg_mask_width;
 	bool die_level_present = false;
 	int leaf;
 
@@ -111,10 +112,10 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
 	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 	die_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
-	die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+	pkg_mask_width = die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 
 	sub_index = 1;
-	do {
+	while (true) {
 		cpuid_count(leaf, sub_index, &eax, &ebx, &ecx, &edx);
 
 		/*
@@ -132,10 +133,15 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 			die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 		}
 
+		if (LEAFB_SUBTYPE(ecx) != INVALID_TYPE)
+			pkg_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+		else
+			break;
+
 		sub_index++;
-	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+	}
 
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+	core_select_mask = (~(-1 << pkg_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
 				core_plus_mask_width;
 
@@ -148,7 +154,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	}
 
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid,
-				die_plus_mask_width);
+				pkg_mask_width);
 	/*
 	 * Reinit the apicid, now that we have extended initial_apicid.
 	 */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e2435090f225..86c3b29f1abc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6406,26 +6406,22 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	return 0;
 }
 
-static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
+static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
+				       struct kvm_msr_filter *filter)
 {
-	struct kvm_msr_filter __user *user_msr_filter = argp;
 	struct kvm_x86_msr_filter *new_filter, *old_filter;
-	struct kvm_msr_filter filter;
 	bool default_allow;
 	bool empty = true;
 	int r = 0;
 	u32 i;
 
-	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
-		return -EFAULT;
-
-	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+	if (filter->flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
-		empty &= !filter.ranges[i].nmsrs;
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++)
+		empty &= !filter->ranges[i].nmsrs;
 
-	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
+	default_allow = !(filter->flags & KVM_MSR_FILTER_DEFAULT_DENY);
 	if (empty && !default_allow)
 		return -EINVAL;
 
@@ -6433,8 +6429,8 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (!new_filter)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
-		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++) {
+		r = kvm_add_msr_filter(new_filter, &filter->ranges[i]);
 		if (r) {
 			kvm_free_msr_filter(new_filter);
 			return r;
@@ -6457,6 +6453,62 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_COMPAT
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range_compat {
+	__u32 flags;
+	__u32 nmsrs;
+	__u32 base;
+	__u32 bitmap;
+};
+
+struct kvm_msr_filter_compat {
+	__u32 flags;
+	struct kvm_msr_filter_range_compat ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
+
+#define KVM_X86_SET_MSR_FILTER_COMPAT _IOW(KVMIO, 0xc6, struct kvm_msr_filter_compat)
+
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kvm *kvm = filp->private_data;
+	long r = -ENOTTY;
+
+	switch (ioctl) {
+	case KVM_X86_SET_MSR_FILTER_COMPAT: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter_compat filter_compat;
+		struct kvm_msr_filter filter;
+		int i;
+
+		if (copy_from_user(&filter_compat, user_msr_filter,
+				   sizeof(filter_compat)))
+			return -EFAULT;
+
+		filter.flags = filter_compat.flags;
+		for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
+			struct kvm_msr_filter_range_compat *cr;
+
+			cr = &filter_compat.ranges[i];
+			filter.ranges[i] = (struct kvm_msr_filter_range) {
+				.flags = cr->flags,
+				.nmsrs = cr->nmsrs,
+				.base = cr->base,
+				.bitmap = (__u8 *)(ulong)cr->bitmap,
+			};
+		}
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
+		break;
+	}
+	}
+
+	return r;
+}
+#endif
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
@@ -6879,9 +6931,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
-	case KVM_X86_SET_MSR_FILTER:
-		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
+	case KVM_X86_SET_MSR_FILTER: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter filter;
+
+		if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
+			return -EFAULT;
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
 		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 887b8682eb69..fe840536e6ac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3028,8 +3028,11 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
 	struct page *page;
 	unsigned long flags;
 
-	/* There is no need to clear a driver tags own mapping */
-	if (drv_tags == tags)
+	/*
+	 * There is no need to clear mapping if driver tags is not initialized
+	 * or the mapping belongs to the driver tags.
+	 */
+	if (!drv_tags || drv_tags == tags)
 		return;
 
 	list_for_each_entry(page, &tags->page_list, lru) {
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 72f1fb77abcd..e648158368a7 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -138,8 +139,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	int	cpu = mce->extcpu;
 	struct acpi_hest_generic_status *estatus, *tmp;
 	struct acpi_hest_generic_data *gdata;
-	const guid_t *fru_id = &guid_null;
-	char *fru_text = "";
+	const guid_t *fru_id;
+	char *fru_text;
 	guid_t *sec_type;
 	static u32 err_seq;
 
@@ -160,17 +161,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	/* log event via trace */
 	err_seq++;
-	gdata = (struct acpi_hest_generic_data *)(tmp + 1);
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
-		fru_id = (guid_t *)gdata->fru_id;
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
-		fru_text = gdata->fru_text;
-	sec_type = (guid_t *)gdata->section_type;
-	if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
-		if (gdata->error_data_length >= sizeof(*mem))
-			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
-					       (u8)gdata->error_severity);
+	apei_estatus_for_each_section(tmp, gdata) {
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (guid_t *)gdata->fru_id;
+		else
+			fru_id = &guid_null;
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+		else
+			fru_text = "";
+		sec_type = (guid_t *)gdata->section_type;
+		if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
+			struct cper_sec_mem_err *mem = (void *)(gdata + 1);
+
+			if (gdata->error_data_length >= sizeof(*mem))
+				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
+						       (u8)gdata->error_severity);
+		}
 	}
 
 out:
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 5d7f38016a24..68a566f69684 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -514,6 +514,70 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
 		},
 	},
+	/*
+	 * More Tongfang devices with the same issue as the Clevo NL5xRU and
+	 * NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description above.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GKxNRxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxNGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxNGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxZGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxZGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxRGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index ad11a4c52fbe..6f3286c8506d 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -252,7 +252,7 @@ enum {
 	PCS_7				= 0x94, /* 7+ port PCS (Denverton) */
 
 	/* em constants */
-	EM_MAX_SLOTS			= 8,
+	EM_MAX_SLOTS			= SATA_PMP_MAX_PORTS,
 	EM_MAX_RETRY			= 5,
 
 	/* em_ctl bits */
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 79aa9f285312..20382f3962f5 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -1230,4 +1230,4 @@ module_platform_driver(imx_ahci_driver);
 MODULE_DESCRIPTION("Freescale i.MX AHCI SATA platform driver");
 MODULE_AUTHOR("Richard Zhu <Hong-Xing.Zhu@freescale.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ahci:imx");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 8f7f144e54f3..7f9bcc82fc9c 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -30,11 +30,6 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio
 		return NULL;
 	memset(req, 0, sizeof(*req));
 
-	req->private_bio = bio_alloc_clone(device->ldev->backing_bdev, bio_src,
-					   GFP_NOIO, &drbd_io_bio_set);
-	req->private_bio->bi_private = req;
-	req->private_bio->bi_end_io = drbd_request_endio;
-
 	req->rq_state = (bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0)
 		      | (bio_op(bio_src) == REQ_OP_WRITE_ZEROES ? RQ_ZEROES : 0)
 		      | (bio_op(bio_src) == REQ_OP_DISCARD ? RQ_UNMAP : 0);
@@ -1219,9 +1214,12 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio)
 	/* Update disk stats */
 	req->start_jif = bio_start_io_acct(req->master_bio);
 
-	if (!get_ldev(device)) {
-		bio_put(req->private_bio);
-		req->private_bio = NULL;
+	if (get_ldev(device)) {
+		req->private_bio = bio_alloc_clone(device->ldev->backing_bdev,
+						   bio, GFP_NOIO,
+						   &drbd_io_bio_set);
+		req->private_bio->bi_private = req;
+		req->private_bio->bi_end_io = drbd_request_endio;
 	}
 
 	/* process discards always from our submitter thread */
diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index 863548f59c3e..82e0339d7722 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -213,6 +213,7 @@ static int qcom_cpufreq_krait_name_version(struct device *cpu_dev,
 	int speed = 0, pvs = 0, pvs_ver = 0;
 	u8 *speedbin;
 	size_t len;
+	int ret = 0;
 
 	speedbin = nvmem_cell_read(speedbin_nvmem, &len);
 
@@ -230,7 +231,8 @@ static int qcom_cpufreq_krait_name_version(struct device *cpu_dev,
 		break;
 	default:
 		dev_err(cpu_dev, "Unable to read nvmem data. Defaulting to 0!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto len_error;
 	}
 
 	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
@@ -238,8 +240,9 @@ static int qcom_cpufreq_krait_name_version(struct device *cpu_dev,
 
 	drv->versions = (1 << speed);
 
+len_error:
 	kfree(speedbin);
-	return 0;
+	return ret;
 }
 
 static const struct qcom_cpufreq_match_data match_data_kryo = {
@@ -262,7 +265,8 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 	struct nvmem_cell *speedbin_nvmem;
 	struct device_node *np;
 	struct device *cpu_dev;
-	char *pvs_name = "speedXX-pvsXX-vXX";
+	char pvs_name_buffer[] = "speedXX-pvsXX-vXX";
+	char *pvs_name = pvs_name_buffer;
 	unsigned cpu;
 	const struct of_device_id *match;
 	int ret;
diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index 1216046cf4c2..0ea7631d9c27 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -592,6 +592,7 @@ static const struct of_device_id tegra194_cpufreq_of_match[] = {
 	{ .compatible = "nvidia,tegra234-ccplex-cluster", .data = &tegra234_cpufreq_soc },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
 
 static struct platform_driver tegra194_ccplex_driver = {
 	.driver = {
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 56424f75dd2c..65181efba50e 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1504,11 +1504,6 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 183024d7c184..e3b2b6b4f1a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1211,6 +1211,20 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
+static void soc15_sdma_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+
+	/* sdma doorbell range is programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				true, adev->doorbell_index.sdma_engine[i] << 1,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1230,6 +1244,13 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA doorbell range prior
+	 * to CP ip block init and ring test.  IH already
+	 * happens before CP.
+	 */
+	soc15_sdma_doorbell_range_init(adev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index cb81ed2fbd53..d0c6cf61c676 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -77,7 +77,7 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/dcn30_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/dcn32_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_mode_vba_32.o := $(dml_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_rq_dlg_calc_32.o := $(dml_ccflags)
-CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_mode_vba_util_32.o := $(dml_ccflags)
+CFLAGS_$(AMDDALPATH)/dc/dml/dcn32/display_mode_vba_util_32.o := $(dml_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn321/dcn321_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn31/dcn31_fpu.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn301/dcn301_fpu.o := $(dml_ccflags)
diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 6b8dfa1e7650..c186ace7f83b 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -490,6 +490,7 @@ module_init(vc4_drm_register);
 module_exit(vc4_drm_unregister);
 
 MODULE_ALIAS("platform:vc4-drm");
+MODULE_SOFTDEP("pre: snd-soc-hdmi-codec");
 MODULE_DESCRIPTION("Broadcom VC4 DRM Driver");
 MODULE_AUTHOR("Eric Anholt <eric@anholt.net>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 1e5f68704d7d..780a19a75c3f 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2871,6 +2871,15 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	u32 __maybe_unused value;
 	int ret;
 
+	/*
+	 * The HSM clock is in the HDMI power domain, so we need to set
+	 * its frequency while the power domain is active so that it
+	 * keeps its rate.
+	 */
+	ret = clk_set_min_rate(vc4_hdmi->hsm_clock, HSM_MIN_CLOCK_FREQ);
+	if (ret)
+		return ret;
+
 	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
 	if (ret)
 		return ret;
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 664a624a363d..c9c968d4b36a 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -480,7 +480,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-		break;
+		return 0;
 	default:
 		return 0;
 	}
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index ccf0af5b988a..8bf32c6c85d9 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -46,9 +46,6 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
-#define TO_CORE_ID(cpu)		(cpu_data(cpu).cpu_core_id)
-#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
-
 #ifdef CONFIG_SMP
 #define for_each_sibling(i, cpu) \
 	for_each_cpu(i, topology_sibling_cpumask(cpu))
@@ -91,6 +88,8 @@ struct temp_data {
 struct platform_data {
 	struct device		*hwmon_dev;
 	u16			pkg_id;
+	u16			cpu_map[NUM_REAL_CORES];
+	struct ida		ida;
 	struct cpumask		cpumask;
 	struct temp_data	*core_data[MAX_CORE_DATA];
 	struct device_attribute name_attr;
@@ -441,7 +440,7 @@ static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
 							MSR_IA32_THERM_STATUS;
 	tdata->is_pkg_data = pkg_flag;
 	tdata->cpu = cpu;
-	tdata->cpu_core_id = TO_CORE_ID(cpu);
+	tdata->cpu_core_id = topology_core_id(cpu);
 	tdata->attr_size = MAX_CORE_ATTRS;
 	mutex_init(&tdata->update_lock);
 	return tdata;
@@ -454,7 +453,7 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 eax, edx;
-	int err, attr_no;
+	int err, index, attr_no;
 
 	/*
 	 * Find attr number for sysfs:
@@ -462,14 +461,26 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	 * The attr number is always core id + 2
 	 * The Pkgtemp will always show up as temp1_*, if available
 	 */
-	attr_no = pkg_flag ? PKG_SYSFS_ATTR_NO : TO_ATTR_NO(cpu);
+	if (pkg_flag) {
+		attr_no = PKG_SYSFS_ATTR_NO;
+	} else {
+		index = ida_alloc(&pdata->ida, GFP_KERNEL);
+		if (index < 0)
+			return index;
+		pdata->cpu_map[index] = topology_core_id(cpu);
+		attr_no = index + BASE_SYSFS_ATTR_NO;
+	}
 
-	if (attr_no > MAX_CORE_DATA - 1)
-		return -ERANGE;
+	if (attr_no > MAX_CORE_DATA - 1) {
+		err = -ERANGE;
+		goto ida_free;
+	}
 
 	tdata = init_temp_data(cpu, pkg_flag);
-	if (!tdata)
-		return -ENOMEM;
+	if (!tdata) {
+		err = -ENOMEM;
+		goto ida_free;
+	}
 
 	/* Test if we can access the status register */
 	err = rdmsr_safe_on_cpu(cpu, tdata->status_reg, &eax, &edx);
@@ -505,6 +516,9 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 exit_free:
 	pdata->core_data[attr_no] = NULL;
 	kfree(tdata);
+ida_free:
+	if (!pkg_flag)
+		ida_free(&pdata->ida, index);
 	return err;
 }
 
@@ -524,6 +538,9 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 
 	kfree(pdata->core_data[indx]);
 	pdata->core_data[indx] = NULL;
+
+	if (indx >= BASE_SYSFS_ATTR_NO)
+		ida_free(&pdata->ida, indx - BASE_SYSFS_ATTR_NO);
 }
 
 static int coretemp_probe(struct platform_device *pdev)
@@ -537,6 +554,7 @@ static int coretemp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pdata->pkg_id = pdev->id;
+	ida_init(&pdata->ida);
 	platform_set_drvdata(pdev, pdata);
 
 	pdata->hwmon_dev = devm_hwmon_device_register_with_groups(dev, DRVNAME,
@@ -553,6 +571,7 @@ static int coretemp_remove(struct platform_device *pdev)
 		if (pdata->core_data[i])
 			coretemp_remove_core(pdata, i);
 
+	ida_destroy(&pdata->ida);
 	return 0;
 }
 
@@ -647,7 +666,7 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	struct platform_device *pdev = coretemp_get_pdev(cpu);
 	struct platform_data *pd;
 	struct temp_data *tdata;
-	int indx, target;
+	int i, indx = -1, target;
 
 	/*
 	 * Don't execute this on suspend as the device remove locks
@@ -660,12 +679,19 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	if (!pdev)
 		return 0;
 
-	/* The core id is too big, just return */
-	indx = TO_ATTR_NO(cpu);
-	if (indx > MAX_CORE_DATA - 1)
+	pd = platform_get_drvdata(pdev);
+
+	for (i = 0; i < NUM_REAL_CORES; i++) {
+		if (pd->cpu_map[i] == topology_core_id(cpu)) {
+			indx = i + BASE_SYSFS_ATTR_NO;
+			break;
+		}
+	}
+
+	/* Too many cores and this core is not populated, just return */
+	if (indx < 0)
 		return 0;
 
-	pd = platform_get_drvdata(pdev);
 	tdata = pd->core_data[indx];
 
 	cpumask_clear_cpu(cpu, &pd->cpumask);
diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index ea48e6a9cfca..1cf89f885d61 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -639,6 +639,11 @@ static int cci_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
+	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (!cci->master[i].cci)
 			continue;
@@ -650,14 +655,12 @@ static int cci_probe(struct platform_device *pdev)
 		}
 	}
 
-	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
-	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	return 0;
 
 error_i2c:
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
 	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 31bc50e538a3..ecc0b05b2796 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2400,6 +2400,7 @@ static int __init si_domain_init(int hw)
 
 	if (md_domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		domain_exit(si_domain);
+		si_domain = NULL;
 		return -EFAULT;
 	}
 
@@ -3042,6 +3043,10 @@ static int __init init_dmars(void)
 		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
 	}
+	if (si_domain) {
+		domain_exit(si_domain);
+		si_domain = NULL;
+	}
 
 	return ret;
 }
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 09c7ed2650ca..9c5ef818ca36 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -795,7 +795,8 @@ static void __make_buffer_clean(struct dm_buffer *b)
 {
 	BUG_ON(b->hold_count);
 
-	if (!b->state)	/* fast case */
+	/* smp_load_acquire() pairs with read_endio()'s smp_mb__before_atomic() */
+	if (!smp_load_acquire(&b->state))	/* fast case */
 		return;
 
 	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
@@ -816,7 +817,7 @@ static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
 		BUG_ON(test_bit(B_DIRTY, &b->state));
 
 		if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
-		    unlikely(test_bit(B_READING, &b->state)))
+		    unlikely(test_bit_acquire(B_READING, &b->state)))
 			continue;
 
 		if (!b->hold_count) {
@@ -1058,7 +1059,7 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
-	if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
+	if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state)))
 		return NULL;
 
 	b->hold_count++;
@@ -1218,7 +1219,7 @@ void dm_bufio_release(struct dm_buffer *b)
 		 * invalid buffer.
 		 */
 		if ((b->read_error || b->write_error) &&
-		    !test_bit(B_READING, &b->state) &&
+		    !test_bit_acquire(B_READING, &b->state) &&
 		    !test_bit(B_WRITING, &b->state) &&
 		    !test_bit(B_DIRTY, &b->state)) {
 			__unlink_buffer(b);
@@ -1479,7 +1480,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_release_move);
 
 static void forget_buffer_locked(struct dm_buffer *b)
 {
-	if (likely(!b->hold_count) && likely(!b->state)) {
+	if (likely(!b->hold_count) && likely(!smp_load_acquire(&b->state))) {
 		__unlink_buffer(b);
 		__free_buffer_wake(b);
 	}
@@ -1639,7 +1640,7 @@ static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
 {
 	if (!(gfp & __GFP_FS) ||
 	    (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
-		if (test_bit(B_READING, &b->state) ||
+		if (test_bit_acquire(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
 			return false;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..b4a2cb5333fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2065,7 +2065,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->minors = 1;
 	md->disk->flags |= GENHD_FL_NO_PART;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 60de4200375d..ab6a29ffc81e 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -1800,7 +1800,7 @@ bool venus_helper_check_format(struct venus_inst *inst, u32 v4l2_pixfmt)
 	struct venus_core *core = inst->core;
 	u32 fmt = to_hfi_raw_fmt(v4l2_pixfmt);
 	struct hfi_plat_caps *caps;
-	u32 buftype;
+	bool found;
 
 	if (!fmt)
 		return false;
@@ -1809,12 +1809,13 @@ bool venus_helper_check_format(struct venus_inst *inst, u32 v4l2_pixfmt)
 	if (!caps)
 		return false;
 
-	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
-		buftype = HFI_BUFFER_OUTPUT2;
-	else
-		buftype = HFI_BUFFER_OUTPUT;
+	found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT, fmt);
+	if (found)
+		goto done;
 
-	return find_fmt_from_caps(caps, buftype, fmt);
+	found = find_fmt_from_caps(caps, HFI_BUFFER_OUTPUT2, fmt);
+done:
+	return found;
 }
 EXPORT_SYMBOL_GPL(venus_helper_check_format);
 
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index ac0bb45d07f4..4ceaba37e2e5 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -183,6 +183,8 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 39d2b03e2631..c76ba24c1f55 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_dev *dev, unsigned int timeout)
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;
diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index c181346388a4..300c9345ee2b 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -137,27 +137,42 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	struct qca8k_priv *priv = ds->priv;
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u32 command;
 	u8 len, cmd;
+	int i;
 
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
 	mgmt_eth_data = &priv->mgmt_eth_data;
 
-	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
-	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
+	command = get_unaligned_le32(&mgmt_ethhdr->command);
+	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
+	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
 
 	/* Make sure the seq match the requested packet */
-	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
+	if (get_unaligned_le32(&mgmt_ethhdr->seq) == mgmt_eth_data->seq)
 		mgmt_eth_data->ack = true;
 
 	if (cmd == MDIO_READ) {
-		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
+		u32 *val = mgmt_eth_data->data;
+
+		*val = get_unaligned_le32(&mgmt_ethhdr->mdio_data);
 
 		/* Get the rest of the 12 byte of data.
 		 * The read/write function will extract the requested data.
 		 */
-		if (len > QCA_HDR_MGMT_DATA1_LEN)
-			memcpy(mgmt_eth_data->data + 1, skb->data,
-			       QCA_HDR_MGMT_DATA2_LEN);
+		if (len > QCA_HDR_MGMT_DATA1_LEN) {
+			__le32 *data2 = (__le32 *)skb->data;
+			int data_len = min_t(int, QCA_HDR_MGMT_DATA2_LEN,
+					     len - QCA_HDR_MGMT_DATA1_LEN);
+
+			val++;
+
+			for (i = sizeof(u32); i <= data_len; i += sizeof(u32)) {
+				*val = get_unaligned_le32(data2);
+				val++;
+				data2++;
+			}
+		}
 	}
 
 	complete(&mgmt_eth_data->rw_done);
@@ -169,8 +184,10 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
 	unsigned int real_len;
 	struct sk_buff *skb;
-	u32 *data2;
+	__le32 *data2;
+	u32 command;
 	u16 hdr;
+	int i;
 
 	skb = dev_alloc_skb(QCA_HDR_MGMT_PKT_LEN);
 	if (!skb)
@@ -199,20 +216,32 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
 
-	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
+	command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
+	command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
+	command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
+	command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
 					   QCA_HDR_MGMT_CHECK_CODE_VAL);
 
+	put_unaligned_le32(command, &mgmt_ethhdr->command);
+
 	if (cmd == MDIO_WRITE)
-		mgmt_ethhdr->mdio_data = *val;
+		put_unaligned_le32(*val, &mgmt_ethhdr->mdio_data);
 
 	mgmt_ethhdr->hdr = htons(hdr);
 
 	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
-	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
-		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN) {
+		int data_len = min_t(int, QCA_HDR_MGMT_DATA2_LEN,
+				     len - QCA_HDR_MGMT_DATA1_LEN);
+
+		val++;
+
+		for (i = sizeof(u32); i <= data_len; i += sizeof(u32)) {
+			put_unaligned_le32(*val, data2);
+			data2++;
+			val++;
+		}
+	}
 
 	return skb;
 }
@@ -220,9 +249,11 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
 {
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	u32 seq;
 
+	seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb->data;
-	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
+	put_unaligned_le32(seq, &mgmt_ethhdr->seq);
 }
 
 static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
@@ -1487,9 +1518,9 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	struct qca8k_priv *priv = ds->priv;
 	const struct qca8k_mib_desc *mib;
 	struct mib_ethhdr *mib_ethhdr;
-	int i, mib_len, offset = 0;
-	u64 *data;
+	__le32 *data2;
 	u8 port;
+	int i;
 
 	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
 	mib_eth_data = &priv->mib_eth_data;
@@ -1501,28 +1532,24 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	if (port != mib_eth_data->req_port)
 		goto exit;
 
-	data = mib_eth_data->data;
+	data2 = (__le32 *)skb->data;
 
 	for (i = 0; i < priv->info->mib_count; i++) {
 		mib = &ar8327_mib[i];
 
 		/* First 3 mib are present in the skb head */
 		if (i < 3) {
-			data[i] = mib_ethhdr->data[i];
+			mib_eth_data->data[i] = get_unaligned_le32(mib_ethhdr->data + i);
 			continue;
 		}
 
-		mib_len = sizeof(uint32_t);
-
 		/* Some mib are 64 bit wide */
 		if (mib->size == 2)
-			mib_len = sizeof(uint64_t);
-
-		/* Copy the mib value from packet to the */
-		memcpy(data + i, skb->data + offset, mib_len);
+			mib_eth_data->data[i] = get_unaligned_le64((__le64 *)data2);
+		else
+			mib_eth_data->data[i] = get_unaligned_le32(data2);
 
-		/* Set the offset for the next mib */
-		offset += mib_len;
+		data2 += mib->size;
 	}
 
 exit:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a36803e79e92..8a6f788f6294 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -613,6 +613,7 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
 
 static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
 {
+	bool rc = false;
 	u32 datalen;
 	u16 index;
 	u8 *buf;
@@ -632,20 +633,20 @@ static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
 
 	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
 		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd read error");
-		goto err;
+		goto done;
 	}
 
 	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
 			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
 		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd write error");
-		goto err;
+		goto done;
 	}
 
-	return true;
+	rc = true;
 
-err:
+done:
 	kfree(buf);
-	return false;
+	return rc;
 }
 
 static bool bnxt_dl_selftest_check(struct devlink *dl, unsigned int id,
diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 00fafc0f8512..430eccea8e5e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -419,8 +419,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
 	hdev->cls_dev.release = hnae_release;
 	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
 	ret = device_register(&hdev->cls_dev);
-	if (ret)
+	if (ret) {
+		put_device(&hdev->cls_dev);
 		return ret;
+	}
 
 	__module_get(THIS_MODULE);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index e9cd0fa6a0d2..af5fe84db596 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2181,9 +2181,6 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			 */
 			rx_rings[i].tail = hw->hw_addr + I40E_PRTGEN_STATUS;
 			err = i40e_setup_rx_descriptors(&rx_rings[i]);
-			if (err)
-				goto rx_unwind;
-			err = i40e_alloc_rx_bi(&rx_rings[i]);
 			if (err)
 				goto rx_unwind;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e3d9804aeb25..b3336d31f8a9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3565,12 +3565,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	if (ring->vsi->type == I40E_VSI_MAIN)
 		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
-	kfree(ring->rx_bi);
 	ring->xsk_pool = i40e_xsk_pool(ring);
 	if (ring->xsk_pool) {
-		ret = i40e_alloc_rx_bi_zc(ring);
-		if (ret)
-			return ret;
 		ring->rx_buf_len =
 		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
 		/* For AF_XDP ZC, we disallow packets to span on
@@ -3588,9 +3584,6 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 			 ring->queue_index);
 
 	} else {
-		ret = i40e_alloc_rx_bi(ring);
-		if (ret)
-			return ret;
 		ring->rx_buf_len = vsi->rx_buf_len;
 		if (ring->vsi->type == I40E_VSI_MAIN) {
 			ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -13304,6 +13297,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 		i40e_reset_and_rebuild(pf, true, true);
 	}
 
+	if (!i40e_enabled_xdp_vsi(vsi) && prog) {
+		if (i40e_realloc_rx_bi_zc(vsi, true))
+			return -ENOMEM;
+	} else if (i40e_enabled_xdp_vsi(vsi) && !prog) {
+		if (i40e_realloc_rx_bi_zc(vsi, false))
+			return -ENOMEM;
+	}
+
 	for (i = 0; i < vsi->num_queue_pairs; i++)
 		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
 
@@ -13536,6 +13537,7 @@ int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair)
 
 	i40e_queue_pair_disable_irq(vsi, queue_pair);
 	err = i40e_queue_pair_toggle_rings(vsi, queue_pair, false /* off */);
+	i40e_clean_rx_ring(vsi->rx_rings[queue_pair]);
 	i40e_queue_pair_toggle_napi(vsi, queue_pair, false /* off */);
 	i40e_queue_pair_clean_rings(vsi, queue_pair);
 	i40e_queue_pair_reset_stats(vsi, queue_pair);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 69e67eb6aea7..b97c95f89fa0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1457,14 +1457,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return -ENOMEM;
 }
 
-int i40e_alloc_rx_bi(struct i40e_ring *rx_ring)
-{
-	unsigned long sz = sizeof(*rx_ring->rx_bi) * rx_ring->count;
-
-	rx_ring->rx_bi = kzalloc(sz, GFP_KERNEL);
-	return rx_ring->rx_bi ? 0 : -ENOMEM;
-}
-
 static void i40e_clear_rx_bi(struct i40e_ring *rx_ring)
 {
 	memset(rx_ring->rx_bi, 0, sizeof(*rx_ring->rx_bi) * rx_ring->count);
@@ -1593,6 +1585,11 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 
 	rx_ring->xdp_prog = rx_ring->vsi->xdp_prog;
 
+	rx_ring->rx_bi =
+		kcalloc(rx_ring->count, sizeof(*rx_ring->rx_bi), GFP_KERNEL);
+	if (!rx_ring->rx_bi)
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 41f86e9535a0..768290dc6f48 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -469,7 +469,6 @@ int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size);
 bool __i40e_chk_linearize(struct sk_buff *skb);
 int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		  u32 flags);
-int i40e_alloc_rx_bi(struct i40e_ring *rx_ring);
 
 /**
  * i40e_get_head - Retrieve head from head writeback
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 6d4009e0cbd6..cd7b52fb6b46 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -10,14 +10,6 @@
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
-int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring)
-{
-	unsigned long sz = sizeof(*rx_ring->rx_bi_zc) * rx_ring->count;
-
-	rx_ring->rx_bi_zc = kzalloc(sz, GFP_KERNEL);
-	return rx_ring->rx_bi_zc ? 0 : -ENOMEM;
-}
-
 void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring)
 {
 	memset(rx_ring->rx_bi_zc, 0,
@@ -29,6 +21,58 @@ static struct xdp_buff **i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
 	return &rx_ring->rx_bi_zc[idx];
 }
 
+/**
+ * i40e_realloc_rx_xdp_bi - reallocate SW ring for either XSK or normal buffer
+ * @rx_ring: Current rx ring
+ * @pool_present: is pool for XSK present
+ *
+ * Try allocating memory and return ENOMEM, if failed to allocate.
+ * If allocation was successful, substitute buffer with allocated one.
+ * Returns 0 on success, negative on failure
+ */
+static int i40e_realloc_rx_xdp_bi(struct i40e_ring *rx_ring, bool pool_present)
+{
+	size_t elem_size = pool_present ? sizeof(*rx_ring->rx_bi_zc) :
+					  sizeof(*rx_ring->rx_bi);
+	void *sw_ring = kcalloc(rx_ring->count, elem_size, GFP_KERNEL);
+
+	if (!sw_ring)
+		return -ENOMEM;
+
+	if (pool_present) {
+		kfree(rx_ring->rx_bi);
+		rx_ring->rx_bi = NULL;
+		rx_ring->rx_bi_zc = sw_ring;
+	} else {
+		kfree(rx_ring->rx_bi_zc);
+		rx_ring->rx_bi_zc = NULL;
+		rx_ring->rx_bi = sw_ring;
+	}
+	return 0;
+}
+
+/**
+ * i40e_realloc_rx_bi_zc - reallocate rx SW rings
+ * @vsi: Current VSI
+ * @zc: is zero copy set
+ *
+ * Reallocate buffer for rx_rings that might be used by XSK.
+ * XDP requires more memory, than rx_buf provides.
+ * Returns 0 on success, negative on failure
+ */
+int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc)
+{
+	struct i40e_ring *rx_ring;
+	unsigned long q;
+
+	for_each_set_bit(q, vsi->af_xdp_zc_qps, vsi->alloc_queue_pairs) {
+		rx_ring = vsi->rx_rings[q];
+		if (i40e_realloc_rx_xdp_bi(rx_ring, zc))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 /**
  * i40e_xsk_pool_enable - Enable/associate an AF_XDP buffer pool to a
  * certain ring/qid
@@ -69,6 +113,10 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
 		if (err)
 			return err;
 
+		err = i40e_realloc_rx_xdp_bi(vsi->rx_rings[qid], true);
+		if (err)
+			return err;
+
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
@@ -113,6 +161,9 @@ static int i40e_xsk_pool_disable(struct i40e_vsi *vsi, u16 qid)
 	xsk_pool_dma_unmap(pool, I40E_RX_DMA_ATTR);
 
 	if (if_running) {
+		err = i40e_realloc_rx_xdp_bi(vsi->rx_rings[qid], false);
+		if (err)
+			return err;
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index bb962987f300..821df248f8be 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -32,7 +32,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
 int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
-int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring);
+int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
 void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
 
 #endif /* _I40E_XSK_H_ */
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b344632beadd..84433f3a3e22 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4028,19 +4028,23 @@ static int mtk_probe(struct platform_device *pdev)
 			eth->irq[i] = platform_get_irq(pdev, i);
 		if (eth->irq[i] < 0) {
 			dev_err(&pdev->dev, "no IRQ%d resource found\n", i);
-			return -ENXIO;
+			err = -ENXIO;
+			goto err_wed_exit;
 		}
 	}
 	for (i = 0; i < ARRAY_SIZE(eth->clks); i++) {
 		eth->clks[i] = devm_clk_get(eth->dev,
 					    mtk_clks_source_name[i]);
 		if (IS_ERR(eth->clks[i])) {
-			if (PTR_ERR(eth->clks[i]) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
+			if (PTR_ERR(eth->clks[i]) == -EPROBE_DEFER) {
+				err = -EPROBE_DEFER;
+				goto err_wed_exit;
+			}
 			if (eth->soc->required_clks & BIT(i)) {
 				dev_err(&pdev->dev, "clock %s not found\n",
 					mtk_clks_source_name[i]);
-				return -EINVAL;
+				err = -EINVAL;
+				goto err_wed_exit;
 			}
 			eth->clks[i] = NULL;
 		}
@@ -4051,7 +4055,7 @@ static int mtk_probe(struct platform_device *pdev)
 
 	err = mtk_hw_init(eth);
 	if (err)
-		return err;
+		goto err_wed_exit;
 
 	eth->hwlro = MTK_HAS_CAPS(eth->soc->caps, MTK_HWLRO);
 
@@ -4140,6 +4144,8 @@ static int mtk_probe(struct platform_device *pdev)
 	mtk_free_dev(eth);
 err_deinit_hw:
 	mtk_hw_deinit(eth);
+err_wed_exit:
+	mtk_wed_exit();
 
 	return err;
 }
@@ -4159,6 +4165,7 @@ static int mtk_remove(struct platform_device *pdev)
 		phylink_disconnect_phy(mac->phylink);
 	}
 
+	mtk_wed_exit();
 	mtk_hw_deinit(eth);
 
 	netif_napi_del(&eth->tx_napi);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 29be2fcafea3..614147ad6116 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -808,16 +808,16 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	pdev = of_find_device_by_node(np);
 	if (!pdev)
-		return;
+		goto err_of_node_put;
 
 	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return;
+		goto err_put_device;
 
 	regs = syscon_regmap_lookup_by_phandle(np, NULL);
 	if (IS_ERR(regs))
-		return;
+		goto err_put_device;
 
 	rcu_assign_pointer(mtk_soc_wed_ops, &wed_ops);
 
@@ -853,8 +853,16 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	hw_list[index] = hw;
 
+	mutex_unlock(&hw_lock);
+
+	return;
+
 unlock:
 	mutex_unlock(&hw_lock);
+err_put_device:
+	put_device(&pdev->dev);
+err_of_node_put:
+	of_node_put(np);
 }
 
 void mtk_wed_exit(void)
@@ -875,6 +883,7 @@ void mtk_wed_exit(void)
 		hw_list[i] = NULL;
 		debugfs_remove(hw->debugfs_dir);
 		put_device(hw->dev);
+		of_node_put(hw->node);
 		kfree(hw);
 	}
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0be79c516781..6ae6d79193a3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2820,11 +2820,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	 * than the full array, but leave the qcq shells in place
 	 */
 	for (i = lif->nxqs; i < lif->ionic->ntxqs_per_lif; i++) {
-		lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->txqcqs[i]);
+		if (lif->txqcqs && lif->txqcqs[i]) {
+			lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->txqcqs[i]);
+		}
 
-		lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->rxqcqs[i]);
+		if (lif->rxqcqs && lif->rxqcqs[i]) {
+			lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->rxqcqs[i]);
+		}
 	}
 
 	if (err)
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index d1e1aa19a68e..7022fb2005a2 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3277,6 +3277,30 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	bool was_enabled = efx->port_enabled;
 	int rc;
 
+#ifdef CONFIG_SFC_SRIOV
+	/* If this function is a VF and we have access to the parent PF,
+	 * then use the PF control path to attempt to change the VF MAC address.
+	 */
+	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
+		struct efx_nic *efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
+		struct efx_ef10_nic_data *nic_data = efx->nic_data;
+		u8 mac[ETH_ALEN];
+
+		/* net_dev->dev_addr can be zeroed by efx_net_stop in
+		 * efx_ef10_sriov_set_vf_mac, so pass in a copy.
+		 */
+		ether_addr_copy(mac, efx->net_dev->dev_addr);
+
+		rc = efx_ef10_sriov_set_vf_mac(efx_pf, nic_data->vf_index, mac);
+		if (!rc)
+			return 0;
+
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Updating VF mac via PF failed (%d), setting directly\n",
+			  rc);
+	}
+#endif
+
 	efx_device_detach_sync(efx);
 	efx_net_stop(efx->net_dev);
 
@@ -3297,40 +3321,6 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 		efx_net_open(efx->net_dev);
 	efx_device_attach_if_not_resetting(efx);
 
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-		struct pci_dev *pci_dev_pf = efx->pci_dev->physfn;
-
-		if (rc == -EPERM) {
-			struct efx_nic *efx_pf;
-
-			/* Switch to PF and change MAC address on vport */
-			efx_pf = pci_get_drvdata(pci_dev_pf);
-
-			rc = efx_ef10_sriov_set_vf_mac(efx_pf,
-						       nic_data->vf_index,
-						       efx->net_dev->dev_addr);
-		} else if (!rc) {
-			struct efx_nic *efx_pf = pci_get_drvdata(pci_dev_pf);
-			struct efx_ef10_nic_data *nic_data = efx_pf->nic_data;
-			unsigned int i;
-
-			/* MAC address successfully changed by VF (with MAC
-			 * spoofing) so update the parent PF if possible.
-			 */
-			for (i = 0; i < efx_pf->vf_count; ++i) {
-				struct ef10_vf *vf = nic_data->vf + i;
-
-				if (vf->efx == efx) {
-					ether_addr_copy(vf->mac,
-							efx->net_dev->dev_addr);
-					return 0;
-				}
-			}
-		}
-	} else
-#endif
 	if (rc == -EPERM) {
 		netif_err(efx, drv, efx->net_dev,
 			  "Cannot change MAC address; use sfboot to enable"
diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index 4d928839d292..f569d07ef267 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -161,9 +161,9 @@ struct efx_filter_spec {
 	u32	priority:2;
 	u32	flags:6;
 	u32	dmaq_id:12;
-	u32	vport_id;
 	u32	rss_context;
-	__be16	outer_vid __aligned(4); /* allow jhash2() of match values */
+	u32	vport_id;
+	__be16	outer_vid;
 	__be16	inner_vid;
 	u8	loc_mac[ETH_ALEN];
 	u8	rem_mac[ETH_ALEN];
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 4826e6a7e4ce..9220afeddee8 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -660,17 +660,17 @@ bool efx_filter_spec_equal(const struct efx_filter_spec *left,
 	     (EFX_FILTER_FLAG_RX | EFX_FILTER_FLAG_TX)))
 		return false;
 
-	return memcmp(&left->outer_vid, &right->outer_vid,
+	return memcmp(&left->vport_id, &right->vport_id,
 		      sizeof(struct efx_filter_spec) -
-		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
+		      offsetof(struct efx_filter_spec, vport_id)) == 0;
 }
 
 u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
 {
-	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
-	return jhash2((const u32 *)&spec->outer_vid,
+	BUILD_BUG_ON(offsetof(struct efx_filter_spec, vport_id) & 3);
+	return jhash2((const u32 *)&spec->vport_id,
 		      (sizeof(struct efx_filter_spec) -
-		       offsetof(struct efx_filter_spec, outer_vid)) / 4,
+		       offsetof(struct efx_filter_spec, vport_id)) / 4,
 		      0);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9083159b93f1..bc060ef558d3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1214,6 +1214,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (priv->plat->tx_queues_to_use > 1)
 		priv->phylink_config.mac_capabilities &=
 			~(MAC_10HD | MAC_100HD | MAC_1000HD);
+	priv->phylink_config.mac_managed_pm = true;
 
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 8549e0e356c9..b60db8b6f477 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -254,8 +254,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
 		if (!dp83822->fx_enabled)
-			misr_status |= DP83822_MDI_XOVER_INT_EN |
-				       DP83822_ANEG_ERR_INT_EN |
+			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
 		err = phy_write(phydev, MII_DP83822_MISR2, misr_status);
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..417527f8bbf5 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -853,6 +853,14 @@ static int dp83867_config_init(struct phy_device *phydev)
 		else
 			val &= ~DP83867_SGMII_TYPE;
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
+
+		/* This is a SW workaround for link instability if RX_CTRL is
+		 * not strapped to mode 3 or 4 in HW. This is required for SGMII
+		 * in addition to clearing bit 7, handled above.
+		 */
+		if (dp83867->rxctrl_strap_quirk)
+			phy_set_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
+					 BIT(8));
 	}
 
 	val = phy_read(phydev, DP83867_CFG3);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..7bbbe69a7b0a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1431,6 +1431,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
 
+	if (pl->config->mac_managed_pm)
+		phy->mac_managed_pm = true;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index e5b1f6249763..9c92f20c4aeb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -152,6 +152,7 @@ static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
 		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
 		{ 0x820cc000, 0x0e000, 0x1000 }, /* WF_UMAC_TOP (PP) */
 		{ 0x820cd000, 0x0f000, 0x1000 }, /* WF_MDP_TOP */
+		{ 0x74030000, 0x10000, 0x10000 }, /* PCIE_MAC_IREG */
 		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
 		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
 		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
index 5efda694fb9d..19facf31e4e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
@@ -59,6 +59,8 @@ int mt7921e_mcu_init(struct mt7921_dev *dev)
 	if (err)
 		return err;
 
+	mt76_rmw_field(dev, MT_PCIE_MAC_PM, MT_PCIE_MAC_PM_L0S_DIS, 1);
+
 	err = mt7921_run_firmware(dev);
 
 	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_FWDL], false);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index ea643260ceb6..c65582acfa55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -440,6 +440,8 @@
 #define MT_PCIE_MAC_BASE		0x10000
 #define MT_PCIE_MAC(ofs)		(MT_PCIE_MAC_BASE + (ofs))
 #define MT_PCIE_MAC_INT_ENABLE		MT_PCIE_MAC(0x188)
+#define MT_PCIE_MAC_PM			MT_PCIE_MAC(0x194)
+#define MT_PCIE_MAC_PM_L0S_DIS		BIT(8)
 
 #define MT_DMA_SHDL(ofs)		(0x7c026000 + (ofs))
 #define MT_DMASHDL_SW_CONTROL		MT_DMA_SHDL(0x004)
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index fad642f9ffd8..857a55b625fe 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -311,7 +311,7 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 	return ERR_PTR(err);
 
 err_free_dev:
-	kfree(dev);
+	put_device(&dev->dev);
 
 	return ERR_PTR(err);
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 59e4b188fc71..ed47c256dbd2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3256,8 +3256,12 @@ int nvme_init_ctrl_finish(struct nvme_ctrl *ctrl)
 		return ret;
 
 	if (!ctrl->identified && !nvme_discovery_ctrl(ctrl)) {
+		/*
+		 * Do not return errors unless we are in a controller reset,
+		 * the controller works perfectly fine without hwmon.
+		 */
 		ret = nvme_hwmon_init(ctrl);
-		if (ret < 0)
+		if (ret == -EINTR)
 			return ret;
 	}
 
diff --git a/drivers/nvme/host/hwmon.c b/drivers/nvme/host/hwmon.c
index 0a586d712920..9e6e56c20ec9 100644
--- a/drivers/nvme/host/hwmon.c
+++ b/drivers/nvme/host/hwmon.c
@@ -12,7 +12,7 @@
 
 struct nvme_hwmon_data {
 	struct nvme_ctrl *ctrl;
-	struct nvme_smart_log log;
+	struct nvme_smart_log *log;
 	struct mutex read_lock;
 };
 
@@ -60,14 +60,14 @@ static int nvme_set_temp_thresh(struct nvme_ctrl *ctrl, int sensor, bool under,
 static int nvme_hwmon_get_smart_log(struct nvme_hwmon_data *data)
 {
 	return nvme_get_log(data->ctrl, NVME_NSID_ALL, NVME_LOG_SMART, 0,
-			   NVME_CSI_NVM, &data->log, sizeof(data->log), 0);
+			   NVME_CSI_NVM, data->log, sizeof(*data->log), 0);
 }
 
 static int nvme_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			   u32 attr, int channel, long *val)
 {
 	struct nvme_hwmon_data *data = dev_get_drvdata(dev);
-	struct nvme_smart_log *log = &data->log;
+	struct nvme_smart_log *log = data->log;
 	int temp;
 	int err;
 
@@ -163,7 +163,7 @@ static umode_t nvme_hwmon_is_visible(const void *_data,
 	case hwmon_temp_max:
 	case hwmon_temp_min:
 		if ((!channel && data->ctrl->wctemp) ||
-		    (channel && data->log.temp_sensor[channel - 1])) {
+		    (channel && data->log->temp_sensor[channel - 1])) {
 			if (data->ctrl->quirks &
 			    NVME_QUIRK_NO_TEMP_THRESH_CHANGE)
 				return 0444;
@@ -176,7 +176,7 @@ static umode_t nvme_hwmon_is_visible(const void *_data,
 		break;
 	case hwmon_temp_input:
 	case hwmon_temp_label:
-		if (!channel || data->log.temp_sensor[channel - 1])
+		if (!channel || data->log->temp_sensor[channel - 1])
 			return 0444;
 		break;
 	default:
@@ -230,7 +230,13 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		return 0;
+		return -ENOMEM;
+
+	data->log = kzalloc(sizeof(*data->log), GFP_KERNEL);
+	if (!data->log) {
+		err = -ENOMEM;
+		goto err_free_data;
+	}
 
 	data->ctrl = ctrl;
 	mutex_init(&data->read_lock);
@@ -238,8 +244,7 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 	err = nvme_hwmon_get_smart_log(data);
 	if (err) {
 		dev_warn(dev, "Failed to read smart log (error %d)\n", err);
-		kfree(data);
-		return err;
+		goto err_free_log;
 	}
 
 	hwmon = hwmon_device_register_with_info(dev, "nvme",
@@ -247,11 +252,17 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 						NULL);
 	if (IS_ERR(hwmon)) {
 		dev_warn(dev, "Failed to instantiate hwmon device\n");
-		kfree(data);
-		return PTR_ERR(hwmon);
+		err = PTR_ERR(hwmon);
+		goto err_free_log;
 	}
 	ctrl->hwmon_device = hwmon;
 	return 0;
+
+err_free_log:
+	kfree(data->log);
+err_free_data:
+	kfree(data);
+	return err;
 }
 
 void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
@@ -262,6 +273,7 @@ void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
 
 		hwmon_device_unregister(ctrl->hwmon_device);
 		ctrl->hwmon_device = NULL;
+		kfree(data->log);
 		kfree(data);
 	}
 }
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 14677145bbba..aecb5853f8da 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1176,7 +1176,7 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
 	 * reset the keep alive timer when the controller is enabled.
 	 */
 	if (ctrl->kato)
-		mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+		mod_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 static void nvmet_clear_ctrl(struct nvmet_ctrl *ctrl)
diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 700eb19e8450..fc326fdf483f 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -635,6 +635,13 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	struct rtc_time tm;
 	int rc;
 
+	/* we haven't yet read SMU version */
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
 	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
 		return 0;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1a02134438fc..47e210095315 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4822,7 +4822,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	rc = lpfc_vmid_res_alloc(phba, vport);
 
 	if (rc)
-		goto out;
+		goto out_put_shost;
 
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
@@ -4840,16 +4840,17 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
-		goto out_put_shost;
+		goto out_free_vmid;
 
 	spin_lock_irq(&phba->port_list_lock);
 	list_add_tail(&vport->listentry, &phba->port_list);
 	spin_unlock_irq(&phba->port_list_lock);
 	return vport;
 
-out_put_shost:
+out_free_vmid:
 	kfree(vport->vmid);
 	bitmap_free(vport->vmid_priority_range);
+out_put_shost:
 	scsi_host_put(shost);
 out:
 	return NULL;
diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index d1c539cefba8..2234bb8d48b3 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -192,33 +192,30 @@ static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect *try_sel, *r;
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
 
 	if (sel->pad != IMGU_NODE_IN)
 		return -EINVAL;
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		r = &imgu_sd->rect.eff;
-		break;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
+							   sel->pad);
+		else
+			sel->r = imgu_sd->rect.eff;
+		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		r = &imgu_sd->rect.bds;
-		break;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
+							      sel->pad);
+		else
+			sel->r = imgu_sd->rect.bds;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		sel->r = *try_sel;
-	else
-		sel->r = *r;
-
-	return 0;
 }
 
 static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index 101e13c2cf41..9223d3d4089f 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -357,6 +357,17 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
 	if (ret)
 		return ret;
 
+	/*
+	 * If a driver asked to unregister a platform device registered by
+	 * sysfb, then can be assumed that this is a driver for a display
+	 * that is set up by the system firmware and has a generic driver.
+	 *
+	 * Drivers for devices that don't have a generic driver will never
+	 * ask for this, so let's assume that a real driver for the display
+	 * was already probed and prevent sysfb to register devices later.
+	 */
+	sysfb_disable();
+
 	/*
 	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
 	 * otherwise the vga fbdev driver falls over.
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index d385357e19b6..ccc818b40977 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -138,6 +138,7 @@ struct share_check {
 	u64 root_objectid;
 	u64 inum;
 	int share_count;
+	bool have_delayed_delete_refs;
 };
 
 static inline int extent_is_shared(struct share_check *sc)
@@ -820,16 +821,11 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			    struct preftrees *preftrees, struct share_check *sc)
 {
 	struct btrfs_delayed_ref_node *node;
-	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct btrfs_key key;
-	struct btrfs_key tmp_op_key;
 	struct rb_node *n;
 	int count;
 	int ret = 0;
 
-	if (extent_op && extent_op->update_key)
-		btrfs_disk_key_to_cpu(&tmp_op_key, &extent_op->key);
-
 	spin_lock(&head->lock);
 	for (n = rb_first_cached(&head->ref_tree); n; n = rb_next(n)) {
 		node = rb_entry(n, struct btrfs_delayed_ref_node,
@@ -855,10 +851,16 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 		case BTRFS_TREE_BLOCK_REF_KEY: {
 			/* NORMAL INDIRECT METADATA backref */
 			struct btrfs_delayed_tree_ref *ref;
+			struct btrfs_key *key_ptr = NULL;
+
+			if (head->extent_op && head->extent_op->update_key) {
+				btrfs_disk_key_to_cpu(&key, &head->extent_op->key);
+				key_ptr = &key;
+			}
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
-					       &tmp_op_key, ref->level + 1,
+					       key_ptr, ref->level + 1,
 					       node->bytenr, count, sc,
 					       GFP_ATOMIC);
 			break;
@@ -884,13 +886,22 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			key.offset = ref->offset;
 
 			/*
-			 * Found a inum that doesn't match our known inum, we
-			 * know it's shared.
+			 * If we have a share check context and a reference for
+			 * another inode, we can't exit immediately. This is
+			 * because even if this is a BTRFS_ADD_DELAYED_REF
+			 * reference we may find next a BTRFS_DROP_DELAYED_REF
+			 * which cancels out this ADD reference.
+			 *
+			 * If this is a DROP reference and there was no previous
+			 * ADD reference, then we need to signal that when we
+			 * process references from the extent tree (through
+			 * add_inline_refs() and add_keyed_refs()), we should
+			 * not exit early if we find a reference for another
+			 * inode, because one of the delayed DROP references
+			 * may cancel that reference in the extent tree.
 			 */
-			if (sc && sc->inum && ref->objectid != sc->inum) {
-				ret = BACKREF_FOUND_SHARED;
-				goto out;
-			}
+			if (sc && count < 0)
+				sc->have_delayed_delete_refs = true;
 
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &key, 0, node->bytenr, count, sc,
@@ -920,7 +931,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	}
 	if (!ret)
 		ret = extent_is_shared(sc);
-out:
+
 	spin_unlock(&head->lock);
 	return ret;
 }
@@ -1023,7 +1034,8 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1033,6 +1045,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			ret = add_indirect_ref(fs_info, preftrees, root,
 					       &key, 0, bytenr, count,
 					       sc, GFP_NOFS);
+
 			break;
 		}
 		default:
@@ -1122,7 +1135,8 @@ static int add_keyed_refs(struct btrfs_root *extent_root,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1544,6 +1558,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr,
 		.root_objectid = root->root_key.objectid,
 		.inum = inum,
 		.share_count = 0,
+		.have_delayed_delete_refs = false,
 	};
 
 	ulist_init(roots);
@@ -1578,6 +1593,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr,
 			break;
 		bytenr = node->val;
 		shared.share_count = 0;
+		shared.have_delayed_delete_refs = false;
 		cond_resched();
 	}
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8042d7280dec..6bc8be9ed2a5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1297,8 +1297,11 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
 	ssize_t rc;
 	struct cifsFileInfo *cfile = dst_file->private_data;
 
-	if (cfile->swapfile)
-		return -EOPNOTSUPP;
+	if (cfile->swapfile) {
+		rc = -EOPNOTSUPP;
+		free_xid(xid);
+		return rc;
+	}
 
 	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
 					len, flags);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 08f7392716e2..05c78a18ade0 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -551,8 +551,10 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
 
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
-		return -EIO;
+	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb)))) {
+		rc = -EIO;
+		goto out_free_xid;
+	}
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7d756721e1a6..5c045dd69784 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1882,11 +1882,13 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 	struct cifsFileInfo *cfile;
 	__u32 type;
 
-	rc = -EACCES;
 	xid = get_xid();
 
-	if (!(fl->fl_flags & FL_FLOCK))
-		return -ENOLCK;
+	if (!(fl->fl_flags & FL_FLOCK)) {
+		rc = -ENOLCK;
+		free_xid(xid);
+		return rc;
+	}
 
 	cfile = (struct cifsFileInfo *)file->private_data;
 	tcon = tlink_tcon(cfile->tlink);
@@ -1905,8 +1907,9 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 		 * if no lock or unlock then nothing to do since we do not
 		 * know what it is
 		 */
+		rc = -EOPNOTSUPP;
 		free_xid(xid);
-		return -EOPNOTSUPP;
+		return rc;
 	}
 
 	rc = cifs_setlk(file, fl, type, wait_flag, posix_lck, lock, unlock,
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3af3b05b6c74..11cd06aa74f0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -496,6 +496,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		cifs_put_tcp_session(chan->server, 0);
 	}
 
+	free_xid(xid);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b02552e5f3ee..14376437187a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -530,6 +530,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
+	ses->iface_count = 0;
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -650,9 +651,9 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			kref_put(&iface->refcount, release_iface);
 		} else
 			list_add_tail(&info->iface_head, &ses->iface_list);
-		spin_unlock(&ses->iface_lock);
 
 		ses->iface_count++;
+		spin_unlock(&ses->iface_lock);
 		ses->iface_last_update = jiffies;
 next_iface:
 		nb_iface++;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5016d742576d..92a1d0695ebd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1526,7 +1526,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 					  &blob_length, ses, server,
 					  sess_data->nls_cp);
 	if (rc)
-		goto out_err;
+		goto out;
 
 	if (use_spnego) {
 		/* BB eventually need to add this */
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 5792ca9e0d5e..6e663275aeb1 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -838,15 +838,13 @@ static void z_erofs_do_decompressed_bvec(struct z_erofs_decompress_backend *be,
 
 	if (!((bvec->offset + be->pcl->pageofs_out) & ~PAGE_MASK)) {
 		unsigned int pgnr;
-		struct page *oldpage;
 
 		pgnr = (bvec->offset + be->pcl->pageofs_out) >> PAGE_SHIFT;
 		DBG_BUGON(pgnr >= be->nr_pages);
-		oldpage = be->decompressed_pages[pgnr];
-		be->decompressed_pages[pgnr] = bvec->page;
-
-		if (!oldpage)
+		if (!be->decompressed_pages[pgnr]) {
+			be->decompressed_pages[pgnr] = bvec->page;
 			return;
+		}
 	}
 
 	/* (cold path) one pcluster is requested multiple times */
diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index e7f04c4fbb81..d98c95212985 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -126,10 +126,10 @@ static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
 }
 
 /*
- * bit 31: I/O error occurred on this page
- * bit 0 - 30: remaining parts to complete this page
+ * bit 30: I/O error occurred on this page
+ * bit 0 - 29: remaining parts to complete this page
  */
-#define Z_EROFS_PAGE_EIO			(1 << 31)
+#define Z_EROFS_PAGE_EIO			(1 << 30)
 
 static inline void z_erofs_onlinepage_init(struct page *page)
 {
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b26f304baa52..e5d20da58528 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -710,10 +710,10 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	 * After allocating len, we should have space at least for a 0 byte
 	 * padding.
 	 */
-	if (len + sizeof(struct ext4_fc_tl) > bsize)
+	if (len + EXT4_FC_TAG_BASE_LEN > bsize)
 		return NULL;
 
-	if (bsize - off - 1 > len + sizeof(struct ext4_fc_tl)) {
+	if (bsize - off - 1 > len + EXT4_FC_TAG_BASE_LEN) {
 		/*
 		 * Only allocate from current buffer if we have enough space for
 		 * this request AND we have space to add a zero byte padding.
@@ -730,10 +730,10 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	/* Need to add PAD tag */
 	tl = (struct ext4_fc_tl *)(sbi->s_fc_bh->b_data + off);
 	tl->fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
-	pad_len = bsize - off - 1 - sizeof(struct ext4_fc_tl);
+	pad_len = bsize - off - 1 - EXT4_FC_TAG_BASE_LEN;
 	tl->fc_len = cpu_to_le16(pad_len);
 	if (crc)
-		*crc = ext4_chksum(sbi, *crc, tl, sizeof(*tl));
+		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
 	ext4_fc_submit_bh(sb, false);
@@ -775,7 +775,7 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	 * ext4_fc_reserve_space takes care of allocating an extra block if
 	 * there's no enough space on this block for accommodating this tail.
 	 */
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(tail), &crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + sizeof(tail), &crc);
 	if (!dst)
 		return -ENOSPC;
 
@@ -785,8 +785,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	tl.fc_len = cpu_to_le16(bsize - off - 1 + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), &crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	tail.fc_tid = cpu_to_le32(sbi->s_journal->j_running_transaction->t_tid);
 	ext4_fc_memcpy(sb, dst, &tail.fc_tid, sizeof(tail.fc_tid), &crc);
 	dst += sizeof(tail.fc_tid);
@@ -808,15 +808,15 @@ static bool ext4_fc_add_tlv(struct super_block *sb, u16 tag, u16 len, u8 *val,
 	struct ext4_fc_tl tl;
 	u8 *dst;
 
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + len, crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + len, crc);
 	if (!dst)
 		return false;
 
 	tl.fc_tag = cpu_to_le16(tag);
 	tl.fc_len = cpu_to_le16(len);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), crc);
-	ext4_fc_memcpy(sb, dst + sizeof(tl), val, len, crc);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	ext4_fc_memcpy(sb, dst + EXT4_FC_TAG_BASE_LEN, val, len, crc);
 
 	return true;
 }
@@ -828,8 +828,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	struct ext4_fc_dentry_info fcd;
 	struct ext4_fc_tl tl;
 	int dlen = fc_dentry->fcd_name.len;
-	u8 *dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(fcd) + dlen,
-					crc);
+	u8 *dst = ext4_fc_reserve_space(sb,
+			EXT4_FC_TAG_BASE_LEN + sizeof(fcd) + dlen, crc);
 
 	if (!dst)
 		return false;
@@ -838,8 +838,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	fcd.fc_ino = cpu_to_le32(fc_dentry->fcd_ino);
 	tl.fc_tag = cpu_to_le16(fc_dentry->fcd_op);
 	tl.fc_len = cpu_to_le16(sizeof(fcd) + dlen);
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	ext4_fc_memcpy(sb, dst, &fcd, sizeof(fcd), crc);
 	dst += sizeof(fcd);
 	ext4_fc_memcpy(sb, dst, fc_dentry->fcd_name.name, dlen, crc);
@@ -876,13 +876,13 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 
 	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
-			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
+		EXT4_FC_TAG_BASE_LEN + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
 		goto err;
 
-	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
+	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc))
 		goto err;
-	dst += sizeof(tl);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
 		goto err;
 	dst += sizeof(fc_inode);
@@ -1346,7 +1346,7 @@ struct dentry_info_args {
 };
 
 static inline void tl_to_darg(struct dentry_info_args *darg,
-			      struct  ext4_fc_tl *tl, u8 *val)
+			      struct ext4_fc_tl *tl, u8 *val)
 {
 	struct ext4_fc_dentry_info fcd;
 
@@ -1355,8 +1355,14 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
 	darg->parent_ino = le32_to_cpu(fcd.fc_parent_ino);
 	darg->ino = le32_to_cpu(fcd.fc_ino);
 	darg->dname = val + offsetof(struct ext4_fc_dentry_info, fc_dname);
-	darg->dname_len = le16_to_cpu(tl->fc_len) -
-		sizeof(struct ext4_fc_dentry_info);
+	darg->dname_len = tl->fc_len - sizeof(struct ext4_fc_dentry_info);
+}
+
+static inline void ext4_fc_get_tl(struct ext4_fc_tl *tl, u8 *val)
+{
+	memcpy(tl, val, EXT4_FC_TAG_BASE_LEN);
+	tl->fc_len = le16_to_cpu(tl->fc_len);
+	tl->fc_tag = le16_to_cpu(tl->fc_tag);
 }
 
 /* Unlink replay function */
@@ -1521,7 +1527,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	struct ext4_inode *raw_fc_inode;
 	struct inode *inode = NULL;
 	struct ext4_iloc iloc;
-	int inode_len, ino, ret, tag = le16_to_cpu(tl->fc_tag);
+	int inode_len, ino, ret, tag = tl->fc_tag;
 	struct ext4_extent_header *eh;
 
 	memcpy(&fc_inode, val, sizeof(fc_inode));
@@ -1546,7 +1552,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	if (ret)
 		goto out;
 
-	inode_len = le16_to_cpu(tl->fc_len) - sizeof(struct ext4_fc_inode);
+	inode_len = tl->fc_len - sizeof(struct ext4_fc_inode);
 	raw_inode = ext4_raw_inode(&iloc);
 
 	memcpy(raw_inode, raw_fc_inode, offsetof(struct ext4_inode, i_block));
@@ -1980,6 +1986,34 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
 }
 
+static inline bool ext4_fc_tag_len_isvalid(struct ext4_fc_tl *tl,
+					   u8 *val, u8 *end)
+{
+	if (val + tl->fc_len > end)
+		return false;
+
+	/* Here only check ADD_RANGE/TAIL/HEAD which will read data when do
+	 * journal rescan before do CRC check. Other tags length check will
+	 * rely on CRC check.
+	 */
+	switch (tl->fc_tag) {
+	case EXT4_FC_TAG_ADD_RANGE:
+		return (sizeof(struct ext4_fc_add_range) == tl->fc_len);
+	case EXT4_FC_TAG_TAIL:
+		return (sizeof(struct ext4_fc_tail) <= tl->fc_len);
+	case EXT4_FC_TAG_HEAD:
+		return (sizeof(struct ext4_fc_head) == tl->fc_len);
+	case EXT4_FC_TAG_DEL_RANGE:
+	case EXT4_FC_TAG_LINK:
+	case EXT4_FC_TAG_UNLINK:
+	case EXT4_FC_TAG_CREAT:
+	case EXT4_FC_TAG_INODE:
+	case EXT4_FC_TAG_PAD:
+	default:
+		return true;
+	}
+}
+
 /*
  * Recovery Scan phase handler
  *
@@ -2036,12 +2070,18 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	}
 
 	state->fc_replay_expected_off++;
-	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, sizeof(tl));
-		val = cur + sizeof(tl);
+	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
+		val = cur + EXT4_FC_TAG_BASE_LEN;
+		if (!ext4_fc_tag_len_isvalid(&tl, val, end)) {
+			ret = state->fc_replay_num_tags ?
+				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			goto out_err;
+		}
 		ext4_debug("Scan phase, tag:%s, blk %lld\n",
-			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
-		switch (le16_to_cpu(tl.fc_tag)) {
+			   tag2str(tl.fc_tag), bh->b_blocknr);
+		switch (tl.fc_tag) {
 		case EXT4_FC_TAG_ADD_RANGE:
 			memcpy(&ext, val, sizeof(ext));
 			ex = (struct ext4_extent *)&ext.fc_ex;
@@ -2061,13 +2101,13 @@ static int ext4_fc_replay_scan(journal_t *journal,
 		case EXT4_FC_TAG_PAD:
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		case EXT4_FC_TAG_TAIL:
 			state->fc_cur_tag++;
 			memcpy(&tail, val, sizeof(tail));
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-						sizeof(tl) +
+						EXT4_FC_TAG_BASE_LEN +
 						offsetof(struct ext4_fc_tail,
 						fc_crc));
 			if (le32_to_cpu(tail.fc_tid) == expected_tid &&
@@ -2094,7 +2134,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 			}
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					    sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2149,19 +2189,20 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 	start = (u8 *)bh->b_data;
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
-	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, sizeof(tl));
-		val = cur + sizeof(tl);
+	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
+		val = cur + EXT4_FC_TAG_BASE_LEN;
 
 		if (state->fc_replay_num_tags == 0) {
 			ret = JBD2_FC_REPLAY_STOP;
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
-		ext4_debug("Replay phase, tag:%s\n",
-				tag2str(le16_to_cpu(tl.fc_tag)));
+
+		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
-		switch (le16_to_cpu(tl.fc_tag)) {
+		switch (tl.fc_tag) {
 		case EXT4_FC_TAG_LINK:
 			ret = ext4_fc_replay_link(sb, &tl, val);
 			break;
@@ -2182,19 +2223,18 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			break;
 		case EXT4_FC_TAG_PAD:
 			trace_ext4_fc_replay(sb, EXT4_FC_TAG_PAD, 0,
-					     le16_to_cpu(tl.fc_len), 0);
+					     tl.fc_len, 0);
 			break;
 		case EXT4_FC_TAG_TAIL:
-			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL, 0,
-					     le16_to_cpu(tl.fc_len), 0);
+			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL,
+					     0, tl.fc_len, 0);
 			memcpy(&tail, val, sizeof(tail));
 			WARN_ON(le32_to_cpu(tail.fc_tid) != expected_tid);
 			break;
 		case EXT4_FC_TAG_HEAD:
 			break;
 		default:
-			trace_ext4_fc_replay(sb, le16_to_cpu(tl.fc_tag), 0,
-					     le16_to_cpu(tl.fc_len), 0);
+			trace_ext4_fc_replay(sb, tl.fc_tag, 0, tl.fc_len, 0);
 			ret = -ECANCELED;
 			break;
 		}
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 1db12847a83b..a6154c3ed135 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -70,6 +70,9 @@ struct ext4_fc_tail {
 	__le32 fc_crc;
 };
 
+/* Tag base length */
+#define EXT4_FC_TAG_BASE_LEN (sizeof(struct ext4_fc_tl))
+
 /*
  * Fast commit status codes
  */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 961d1cf54388..05f32989bad6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -232,6 +232,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -382,6 +383,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -454,8 +456,11 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -632,18 +637,9 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct user_namespace *mnt_userns,
@@ -2028,8 +2024,11 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0023643f8b..1e7bbc0873a4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		vma = vma->vm_next;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 50be7cbd93a5..b1b5720d89a5 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -61,9 +61,9 @@ struct sk_buff;
 
 /* Special struct emulating a Ethernet header */
 struct qca_mgmt_ethhdr {
-	u32 command;		/* command bit 31:0 */
-	u32 seq;		/* seq 63:32 */
-	u32 mdio_data;		/* first 4byte mdio */
+	__le32 command;		/* command bit 31:0 */
+	__le32 seq;		/* seq 63:32 */
+	__le32 mdio_data;		/* first 4byte mdio */
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
@@ -73,7 +73,7 @@ enum mdio_cmd {
 };
 
 struct mib_ethhdr {
-	u32 data[3];		/* first 3 mib counter */
+	__le32 data[3];		/* first 3 mib counter */
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..7a40f9bdc173 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1391,6 +1391,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..a3adf7fe7eaf 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -88,6 +88,7 @@ enum phylink_op_type {
  *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
@@ -100,6 +101,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool legacy_pre_march2020;
 	bool poll_fixed_state;
+	bool mac_managed_pm;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ec693fe7c553..f2958fb5ae08 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1137,7 +1137,6 @@ static inline void __qdisc_reset_queue(struct qdisc_skb_head *qh)
 static inline void qdisc_reset_queue(struct Qdisc *sch)
 {
 	__qdisc_reset_queue(&sch->q);
-	sch->qstats.backlog = 0;
 }
 
 static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 473b0b0fa4ab..efc9085c6892 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -43,21 +43,20 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
-static inline bool reuseport_has_conns(struct sock *sk, bool set)
+static inline bool reuseport_has_conns(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
 	bool ret = false;
 
 	rcu_read_lock();
 	reuse = rcu_dereference(sk->sk_reuseport_cb);
-	if (reuse) {
-		if (set)
-			reuse->has_conns = 1;
-		ret = reuse->has_conns;
-	}
+	if (reuse && reuse->has_conns)
+		ret = true;
 	rcu_read_unlock();
 
 	return ret;
 }
 
+void reuseport_has_conns_set(struct sock *sk);
+
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 45809ae6f64e..5121b20a9193 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -229,12 +229,12 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_run_task_work(void)
 {
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
+	if (task_work_pending(current)) {
+		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
-		clear_notify_signal();
-		if (task_work_pending(current))
-			task_work_run();
-		return true;
+		task_work_run();
+		return 1;
 	}
 
 	return false;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 4a7e5d030c78..90d2fc6fd80e 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -95,6 +95,9 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
 	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
+	if (!file_ptr)
+		goto out_unlock;
+
 	src_file = (struct file *) (file_ptr & FFS_MASK);
 	get_file(src_file);
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 60c08a944e2f..93d7cb5eb9fe 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -192,8 +192,6 @@ static void io_req_io_end(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-	WARN_ON(!in_task());
-
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
 		fsnotify_modify(req->file);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 513b523ba75b..ecc197d24efb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2928,11 +2928,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock_irq(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetHPageRestoreReserve(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock_irq(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 829db9eba0cb..aaf64b953915 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -219,11 +219,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!page)
 		return -ENOMEM;
 
-	for (p = page, len = 0; len < nbytes; p++, len++) {
+	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
+		len += 1;
 		if (*p == '\0' || *p == '\n')
 			break;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index 56c8b0921c9f..2c14f48d2457 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5136,11 +5136,13 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+		*ret = NET_RX_DROP;
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
@@ -5153,8 +5155,10 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 			*another = true;
 			break;
 		}
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_CONSUMED:
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	default:
 		break;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ca70525621c7..1efdc47a999b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -500,11 +500,11 @@ bool sk_msg_is_readable(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_msg_is_readable);
 
-static struct sk_msg *alloc_sk_msg(void)
+static struct sk_msg *alloc_sk_msg(gfp_t gfp)
 {
 	struct sk_msg *msg;
 
-	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), gfp | __GFP_NOWARN);
 	if (unlikely(!msg))
 		return NULL;
 	sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
@@ -520,7 +520,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 	if (!sk_rmem_schedule(sk, skb, skb->truesize))
 		return NULL;
 
-	return alloc_sk_msg();
+	return alloc_sk_msg(GFP_KERNEL);
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
@@ -597,7 +597,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
 static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
 				     u32 off, u32 len)
 {
-	struct sk_msg *msg = alloc_sk_msg();
+	struct sk_msg *msg = alloc_sk_msg(GFP_ATOMIC);
 	struct sock *sk = psock->sk;
 	int err;
 
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 5daa1fa54249..fb90e1e00773 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -21,6 +21,22 @@ static DEFINE_IDA(reuseport_ida);
 static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
 			       struct sock_reuseport *reuse, bool bind_inany);
 
+void reuseport_has_conns_set(struct sock *sk)
+{
+	struct sock_reuseport *reuse;
+
+	if (!rcu_access_pointer(sk->sk_reuseport_cb))
+		return;
+
+	spin_lock_bh(&reuseport_lock);
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+	if (likely(reuse))
+		reuse->has_conns = 1;
+	spin_unlock_bh(&reuseport_lock);
+}
+EXPORT_SYMBOL(reuseport_has_conns_set);
+
 static int reuseport_sock_index(struct sock *sk,
 				const struct sock_reuseport *reuse,
 				bool closed)
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 5bf357734b11..a50429a62f74 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -150,15 +150,15 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port)
 {
 	if (!frame->skb_std) {
-		if (frame->skb_hsr) {
+		if (frame->skb_hsr)
 			frame->skb_std =
 				create_stripped_skb_hsr(frame->skb_hsr, frame);
-		} else {
-			/* Unexpected */
-			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",
-				  __FILE__, __LINE__, port->dev->name);
+		else
+			netdev_warn_once(port->dev,
+					 "Unexpected frame received in hsr_get_untagged_frame()\n");
+
+		if (!frame->skb_std)
 			return NULL;
-		}
 	}
 
 	return skb_clone(frame->skb_std, GFP_ATOMIC);
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 405a8c2aea64..5e66add7befa 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = prandom_u32();
diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8cd3224d913e..26b3b0e2adcd 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -78,7 +78,8 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
 	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
-	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
+	flow.flowi4_l3mdev = l3mdev_master_ifindex_rcu(xt_in(par));
+	flow.flowi4_uid = sock_net_uid(xt_net(par), NULL);
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 7ade04ff972d..fc65d69f23e1 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -65,6 +65,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi4 fl4 = {
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
+		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
@@ -84,7 +85,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		oif = NULL;
 
 	if (priv->flags & NFTA_FIB_F_IIF)
-		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+		fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(oif);
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 516b11c136da..d9099754ac69 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -448,7 +448,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 10ce86bf228e..d5967cba5b56 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7214,9 +7214,11 @@ static int __net_init addrconf_init_net(struct net *net)
 	__addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
 err_reg_all:
 	kfree(dflt);
+	net->ipv6.devconf_dflt = NULL;
 #endif
 err_alloc_dflt:
 	kfree(all);
+	net->ipv6.devconf_all = NULL;
 err_alloc_all:
 	kfree(net->ipv6.inet6_addr_lst);
 err_alloc_addr:
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index df665d4e8f0f..5ecb56522f9d 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index d800801a5dd2..a01d9b842bd0 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -37,8 +37,10 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	bool ret = false;
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
+		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev),
 		.flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,
 		.flowi6_proto = iph->nexthdr,
+		.flowi6_uid = sock_net_uid(net, NULL),
 		.daddr = iph->saddr,
 	};
 	int lookup_flags;
@@ -55,9 +57,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	if (rpfilter_addr_linklocal(&iph->saddr)) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6.flowi6_oif = dev->ifindex;
-	/* Set flowi6_oif for vrf devices to lookup route in l3mdev domain. */
-	} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
-		  (flags & XT_RPFILTER_LOOSE) == 0)
+	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
@@ -72,9 +72,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev ||
-	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
-	    (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 1d7e520d9966..36dc14b34388 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -41,9 +41,8 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
-	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
-		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
-		fl6->flowi6_oif = dev->ifindex;
+	} else if (priv->flags & NFTA_FIB_F_IIF) {
+		fl6->flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
@@ -67,6 +66,7 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
+		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	u32 ret = 0;
 
@@ -164,6 +164,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
+		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3366d6a77ff2..fb667e02e976 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -182,7 +182,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 63c70141b3e5..5897afd12466 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5865,8 +5865,9 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
 		if (flags & NFT_SET_ELEM_INTERVAL_END)
 			return false;
-		if (!nla[NFTA_SET_ELEM_KEY_END] &&
-		    !(flags & NFT_SET_ELEM_CATCHALL))
+
+		if (nla[NFTA_SET_ELEM_KEY_END] &&
+		    flags & NFT_SET_ELEM_CATCHALL)
 			return false;
 	} else {
 		if (nla[NFTA_SET_ELEM_KEY_END])
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index bf87b50837a8..67ee8ae3f310 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1081,12 +1081,13 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 skip:
 		if (!ingress) {
-			notify_and_destroy(net, skb, n, classid,
-					   rtnl_dereference(dev->qdisc), new);
+			old = rtnl_dereference(dev->qdisc);
 			if (new && !new->ops->attach)
 				qdisc_refcount_inc(new);
 			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
 
+			notify_and_destroy(net, skb, n, classid, old, new);
+
 			if (new && new->ops->attach)
 				new->ops->attach(new);
 		} else {
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 4c8e994cf0a5..816fd0d7ba38 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -577,7 +577,6 @@ static void atm_tc_reset(struct Qdisc *sch)
 	pr_debug("atm_tc_reset(sch %p,[qdisc %p])\n", sch, p);
 	list_for_each_entry(flow, &p->flows, list)
 		qdisc_reset(flow->q);
-	sch->q.qlen = 0;
 }
 
 static void atm_tc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..9530d65e6002 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2224,8 +2224,12 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 
 static void cake_reset(struct Qdisc *sch)
 {
+	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 c;
 
+	if (!q->tins)
+		return;
+
 	for (c = 0; c < CAKE_MAX_TINS; c++)
 		cake_clear_tin(sch, c);
 }
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 91a0dc463c48..ba99ce05cd52 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -975,7 +975,6 @@ cbq_reset(struct Qdisc *sch)
 			cl->cpriority = cl->priority;
 		}
 	}
-	sch->q.qlen = 0;
 }
 
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 2adbd945bf15..25d2daaa8122 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -315,8 +315,6 @@ static void choke_reset(struct Qdisc *sch)
 		rtnl_qdisc_drop(skb, sch);
 	}
 
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	if (q->tab)
 		memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
 	q->head = q->tail = 0;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 18e4f7a0b291..4e5b1cf11b85 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -441,8 +441,6 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void drr_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 4c100d105269..7da6dc38a382 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -409,8 +409,6 @@ static void dsmark_reset(struct Qdisc *sch)
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
 	if (p->q)
 		qdisc_reset(p->q);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void dsmark_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..d96103b0e2bf 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -445,9 +445,6 @@ static void etf_reset(struct Qdisc *sch)
 	timesortedlist_clear(sch);
 	__qdisc_reset_queue(&sch->q);
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	q->last = 0;
 }
 
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index d73393493553..8de4365886e8 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -727,8 +727,6 @@ static void ets_qdisc_reset(struct Qdisc *sch)
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void ets_qdisc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 839e1235db05..23a042adb74d 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -347,8 +347,6 @@ static void fq_codel_reset(struct Qdisc *sch)
 		codel_vars_init(&flow->cvars);
 	}
 	memset(q->backlogs, 0, q->flows_cnt * sizeof(u32));
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	q->memory_usage = 0;
 }
 
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d6aba6edd16e..35c35465226b 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -521,9 +521,6 @@ static void fq_pie_reset(struct Qdisc *sch)
 		INIT_LIST_HEAD(&flow->flowchain);
 		pie_vars_init(&flow->vars);
 	}
-
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 }
 
 static void fq_pie_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index d3979a6000e7..03efc40e42fc 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1484,8 +1484,6 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 	}
 	q->eligible = RB_ROOT;
 	qdisc_watchdog_cancel(&q->watchdog);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 23a9d6242429..cb5872d22ecf 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1008,8 +1008,6 @@ static void htb_reset(struct Qdisc *sch)
 	}
 	qdisc_watchdog_cancel(&q->watchdog);
 	__qdisc_reset_queue(&q->direct_queue);
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	memset(q->hlevel, 0, sizeof(q->hlevel));
 	memset(q->row_mask, 0, sizeof(q->row_mask));
 }
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index cd8ab90c4765..f28050c7f12d 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -152,7 +152,6 @@ multiq_reset(struct Qdisc *sch)
 
 	for (band = 0; band < q->bands; band++)
 		qdisc_reset(q->queues[band]);
-	sch->q.qlen = 0;
 	q->curband = 0;
 }
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 3b8d7197c06b..c03a11dd990f 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -135,8 +135,6 @@ prio_reset(struct Qdisc *sch)
 
 	for (prio = 0; prio < q->bands; prio++)
 		qdisc_reset(q->queues[prio]);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index d4ce58c90f9f..13246a9dc5c1 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1458,8 +1458,6 @@ static void qfq_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void qfq_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 40adf1f07a82..f1e013e3f04a 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -176,8 +176,6 @@ static void red_reset(struct Qdisc *sch)
 	struct red_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	red_restart(&q->vars);
 }
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 2829455211f8..0490eb5b98de 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -455,9 +455,8 @@ static void sfb_reset(struct Qdisc *sch)
 {
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
-	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
+	if (likely(q->qdisc))
+		qdisc_reset(q->qdisc);
 	q->slot = 0;
 	q->double_buffering = false;
 	sfb_zero_all_buckets(q);
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 7a5e4c454715..df72fb83d9c7 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -213,9 +213,6 @@ static void skbprio_reset(struct Qdisc *sch)
 	struct skbprio_sched_data *q = qdisc_priv(sch);
 	int prio;
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	for (prio = 0; prio < SKBPRIO_MAX_PRIORITY; prio++)
 		__skb_queue_purge(&q->qdiscs[prio]);
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 86675a79da1e..5bffc37022e0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1638,8 +1638,6 @@ static void taprio_reset(struct Qdisc *sch)
 			if (q->qdiscs[i])
 				qdisc_reset(q->qdiscs[i]);
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void taprio_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 36079fdde2cb..e031c1a41ea6 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -330,8 +330,6 @@ static void tbf_reset(struct Qdisc *sch)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	q->t_c = ktime_get_ns();
 	q->tokens = q->buffer;
 	q->ptokens = q->mtu;
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 6af6b95bdb67..79aaab51cbf5 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -124,7 +124,6 @@ teql_reset(struct Qdisc *sch)
 	struct teql_sched_data *dat = qdisc_priv(sch);
 
 	skb_queue_purge(&dat->q);
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index df89c2e08cbf..828dd3a4126a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -896,7 +896,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 		memcpy(lgr->pnet_id, ibdev->pnetid[ibport - 1],
 		       SMC_MAX_PNETID_LEN);
-		if (smc_wr_alloc_lgr_mem(lgr))
+		rc = smc_wr_alloc_lgr_mem(lgr);
+		if (rc)
 			goto free_wq;
 		smc_llc_lgr_init(lgr, smc);
 
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index da69e1abf68f..e8630707901e 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -148,8 +148,8 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 {
 	struct net *net = d->net;
 	struct tipc_net *tn = tipc_net(net);
-	bool trial = time_before(jiffies, tn->addr_trial_end);
 	u32 self = tipc_own_addr(net);
+	bool trial = time_before(jiffies, tn->addr_trial_end) && !self;
 
 	if (mtyp == DSC_TRIAL_FAIL_MSG) {
 		if (!trial)
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5522865deae9..14fd05fd6107 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -568,7 +568,7 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.seq.upper = upper;
 	sub.timeout = TIPC_WAIT_FOREVER;
 	sub.filter = filter;
-	*(u32 *)&sub.usr_handle = port;
+	*(u64 *)&sub.usr_handle = (u64)port;
 
 	con = tipc_conn_alloc(tipc_topsrv(net));
 	if (IS_ERR(con))
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 9b79e334dbd9..955ac3e0bf4d 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -273,7 +273,7 @@ static int tls_strp_read_copyin(struct tls_strparser *strp)
 	return desc.error;
 }
 
-static int tls_strp_read_short(struct tls_strparser *strp)
+static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 {
 	struct skb_shared_info *shinfo;
 	struct page *page;
@@ -283,7 +283,7 @@ static int tls_strp_read_short(struct tls_strparser *strp)
 	 * to read the data out. Otherwise the connection will stall.
 	 * Without pressure threshold of INT_MAX will never be ready.
 	 */
-	if (likely(!tcp_epollin_ready(strp->sk, INT_MAX)))
+	if (likely(qshort && !tcp_epollin_ready(strp->sk, INT_MAX)))
 		return 0;
 
 	shinfo = skb_shinfo(strp->anchor);
@@ -315,6 +315,27 @@ static int tls_strp_read_short(struct tls_strparser *strp)
 	return 0;
 }
 
+static bool tls_strp_check_no_dup(struct tls_strparser *strp)
+{
+	unsigned int len = strp->stm.offset + strp->stm.full_len;
+	struct sk_buff *skb;
+	u32 seq;
+
+	skb = skb_shinfo(strp->anchor)->frag_list;
+	seq = TCP_SKB_CB(skb)->seq;
+
+	while (skb->len < len) {
+		seq += skb->len;
+		len -= skb->len;
+		skb = skb->next;
+
+		if (TCP_SKB_CB(skb)->seq != seq)
+			return false;
+	}
+
+	return true;
+}
+
 static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
 {
 	struct tcp_sock *tp = tcp_sk(strp->sk);
@@ -373,7 +394,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 		return tls_strp_read_copyin(strp);
 
 	if (inq < strp->stm.full_len)
-		return tls_strp_read_short(strp);
+		return tls_strp_read_copy(strp, true);
 
 	if (!strp->stm.full_len) {
 		tls_strp_load_anchor_with_queue(strp, inq);
@@ -387,9 +408,12 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 		strp->stm.full_len = sz;
 
 		if (!strp->stm.full_len || inq < strp->stm.full_len)
-			return tls_strp_read_short(strp);
+			return tls_strp_read_copy(strp, true);
 	}
 
+	if (!tls_strp_check_no_dup(strp))
+		return tls_strp_read_copy(strp, false);
+
 	strp->msg_ready = 1;
 	tls_rx_msg_ready(strp);
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index fe5fcf571c56..64a6a37dc36d 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2022,7 +2022,8 @@ static inline int convert_context_handle_invalid_context(
  * in `newc'.  Verify that the context is valid
  * under the new policy.
  */
-static int convert_context(struct context *oldc, struct context *newc, void *p)
+static int convert_context(struct context *oldc, struct context *newc, void *p,
+			   gfp_t gfp_flags)
 {
 	struct convert_context_args *args;
 	struct ocontext *oc;
@@ -2036,7 +2037,7 @@ static int convert_context(struct context *oldc, struct context *newc, void *p)
 	args = p;
 
 	if (oldc->str) {
-		s = kstrdup(oldc->str, GFP_KERNEL);
+		s = kstrdup(oldc->str, gfp_flags);
 		if (!s)
 			return -ENOMEM;
 
diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index a54b8652bfb5..db5cce385bf8 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -325,7 +325,7 @@ int sidtab_context_to_sid(struct sidtab *s, struct context *context,
 		}
 
 		rc = convert->func(context, &dst_convert->context,
-				   convert->args);
+				   convert->args, GFP_ATOMIC);
 		if (rc) {
 			context_destroy(&dst->context);
 			goto out_unlock;
@@ -404,7 +404,7 @@ static int sidtab_convert_tree(union sidtab_entry_inner *edst,
 		while (i < SIDTAB_LEAF_ENTRIES && *pos < count) {
 			rc = convert->func(&esrc->ptr_leaf->entries[i].context,
 					   &edst->ptr_leaf->entries[i].context,
-					   convert->args);
+					   convert->args, GFP_KERNEL);
 			if (rc)
 				return rc;
 			(*pos)++;
diff --git a/security/selinux/ss/sidtab.h b/security/selinux/ss/sidtab.h
index 4eff0e49dcb2..9fce0d553fe2 100644
--- a/security/selinux/ss/sidtab.h
+++ b/security/selinux/ss/sidtab.h
@@ -65,7 +65,7 @@ struct sidtab_isid_entry {
 };
 
 struct sidtab_convert_params {
-	int (*func)(struct context *oldc, struct context *newc, void *args);
+	int (*func)(struct context *oldc, struct context *newc, void *args, gfp_t gfp_flags);
 	void *args;
 	struct sidtab *target;
 };
diff --git a/tools/verification/dot2/dot2c.py b/tools/verification/dot2/dot2c.py
index fa73353f7e56..be8a364a469b 100644
--- a/tools/verification/dot2/dot2c.py
+++ b/tools/verification/dot2/dot2c.py
@@ -111,7 +111,7 @@ class Dot2c(Automata):
 
     def format_aut_init_header(self):
         buff = []
-        buff.append("struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
+        buff.append("static struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
         return buff
 
     def __get_string_vector_per_line_content(self, buff):
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..4c5259828efd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4834,6 +4834,12 @@ struct compat_kvm_clear_dirty_log {
 	};
 };
 
+long __weak kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+				     unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4842,6 +4848,11 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 
 	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
+
+	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
+	if (r != -ENOTTY)
+		return r;
+
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CLEAR_DIRTY_LOG: {
