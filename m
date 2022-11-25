Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46027638E7E
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 17:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiKYQrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 11:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiKYQrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 11:47:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5DA50D58;
        Fri, 25 Nov 2022 08:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3E462535;
        Fri, 25 Nov 2022 16:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A00C433D6;
        Fri, 25 Nov 2022 16:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669394804;
        bh=Zzew0a0vUwqB2yEbbrTOzoVqJopW0AuilHp5g5B/OtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3V1lmvP8ineFNjuq5VrI+Aut7gy1LGFi24dYvnJ2GmNJbt6pn3s1Wk8CQ5OWIVWm
         QquxaFdh7EHloiICUc+mwLSi9y/QhJ3JeOV+RNuRnYBvJi7N1a8osUz44bmqD8I231
         /o6sO7LaijFMF/r17/HGoiw7u8+vyeidEpM+56LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.267
Date:   Fri, 25 Nov 2022 17:46:33 +0100
Message-Id: <1669394793115129@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1669394793178241@kroah.com>
References: <1669394793178241@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/process/code-of-conduct-interpretation.rst b/Documentation/process/code-of-conduct-interpretation.rst
index 4f8a06b00f60..43da2cc2e3b9 100644
--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or other maintainers if you're
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
+reach out to our conflict mediator, Joanna Lee <jlee@linuxfoundation.org>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the
diff --git a/Makefile b/Makefile
index a0cfded5d0cc..c5a4fbb0444b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 266
+SUBLEVEL = 267
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 4f9acb5fbe97..5b425ed9cd82 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -16,6 +16,14 @@
 
 #include <asm/efi.h>
 
+static bool region_is_misaligned(const efi_memory_desc_t *md)
+{
+	if (PAGE_SIZE == EFI_PAGE_SIZE)
+		return false;
+	return !PAGE_ALIGNED(md->phys_addr) ||
+	       !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT);
+}
+
 /*
  * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
  * executable, everything else can be mapped with the XN bits
@@ -29,14 +37,22 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	if (type == EFI_MEMORY_MAPPED_IO)
 		return PROT_DEVICE_nGnRE;
 
-	if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
-		      "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
+	if (region_is_misaligned(md)) {
+		static bool __initdata code_is_misaligned;
+
 		/*
-		 * If the region is not aligned to the page size of the OS, we
-		 * can not use strict permissions, since that would also affect
-		 * the mapping attributes of the adjacent regions.
+		 * Regions that are not aligned to the OS page size cannot be
+		 * mapped with strict permissions, as those might interfere
+		 * with the permissions that are needed by the adjacent
+		 * region's mapping. However, if we haven't encountered any
+		 * misaligned runtime code regions so far, we can safely use
+		 * non-executable permissions for non-code regions.
 		 */
-		return pgprot_val(PAGE_KERNEL_EXEC);
+		code_is_misaligned |= (type == EFI_RUNTIME_SERVICES_CODE);
+
+		return code_is_misaligned ? pgprot_val(PAGE_KERNEL_EXEC)
+					  : pgprot_val(PAGE_KERNEL);
+	}
 
 	/* R-- */
 	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
@@ -66,19 +82,16 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 	bool page_mappings_only = (md->type == EFI_RUNTIME_SERVICES_CODE ||
 				   md->type == EFI_RUNTIME_SERVICES_DATA);
 
-	if (!PAGE_ALIGNED(md->phys_addr) ||
-	    !PAGE_ALIGNED(md->num_pages << EFI_PAGE_SHIFT)) {
-		/*
-		 * If the end address of this region is not aligned to page
-		 * size, the mapping is rounded up, and may end up sharing a
-		 * page frame with the next UEFI memory region. If we create
-		 * a block entry now, we may need to split it again when mapping
-		 * the next region, and support for that is going to be removed
-		 * from the MMU routines. So avoid block mappings altogether in
-		 * that case.
-		 */
+	/*
+	 * If this region is not aligned to the page size used by the OS, the
+	 * mapping will be rounded outwards, and may end up sharing a page
+	 * frame with an adjacent runtime memory region. Given that the page
+	 * table descriptor covering the shared page will be rewritten when the
+	 * adjacent region gets mapped, we must avoid block mappings here so we
+	 * don't have to worry about splitting them when that happens.
+	 */
+	if (region_is_misaligned(md))
 		page_mappings_only = true;
-	}
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
@@ -106,6 +119,9 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
 	BUG_ON(md->type != EFI_RUNTIME_SERVICES_CODE &&
 	       md->type != EFI_RUNTIME_SERVICES_DATA);
 
+	if (region_is_misaligned(md))
+		return 0;
+
 	/*
 	 * Calling apply_to_page_range() is only safe on regions that are
 	 * guaranteed to be mapped down to pages. Since we are only called
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index d7c6ca7c95ae..64180108072c 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -104,6 +104,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
+	memset(&p->thread.s, 0, sizeof(p->thread.s));
+
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* Kernel thread */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index dbe98e8ed164..0bd07699dba3 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -399,6 +399,11 @@
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+
+#define MSR_AMD64_DE_CFG		0xc0011029
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	 1
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE	BIT_ULL(MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)
+
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
@@ -467,9 +472,6 @@
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f1f41c96d319..e017f64e09d6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -789,8 +789,6 @@ static void init_amd_gh(struct cpuinfo_x86 *c)
 		set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 }
 
-#define MSR_AMD64_DE_CFG	0xC0011029
-
 static void init_amd_ln(struct cpuinfo_x86 *c)
 {
 	/*
@@ -960,16 +958,16 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * msr_set_bit() uses the safe accessors, too, even if the MSR
 		 * is not present.
 		 */
-		msr_set_bit(MSR_F10H_DECFG,
-			    MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT);
+		msr_set_bit(MSR_AMD64_DE_CFG,
+			    MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT);
 
 		/*
 		 * Verify that the MSR write was successful (could be running
 		 * under a hypervisor) and only then assume that LFENCE is
 		 * serializing.
 		 */
-		ret = rdmsrl_safe(MSR_F10H_DECFG, &val);
-		if (!ret && (val & MSR_F10H_DECFG_LFENCE_SERIALIZE)) {
+		ret = rdmsrl_safe(MSR_AMD64_DE_CFG, &val);
+		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)) {
 			/* A serializing LFENCE stops RDTSC speculation */
 			set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 		} else {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5b68ec68fc13..cd3432df0d24 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4155,9 +4155,9 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 	msr->data = 0;
 
 	switch (msr->index) {
-	case MSR_F10H_DECFG:
-		if (boot_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
+	case MSR_AMD64_DE_CFG:
+		if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	default:
 		return 1;
@@ -4259,7 +4259,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = 0x1E;
 		}
 		break;
-	case MSR_F10H_DECFG:
+	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
 	default:
@@ -4446,7 +4446,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_VM_IGNNE:
 		vcpu_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
-	case MSR_F10H_DECFG: {
+	case MSR_AMD64_DE_CFG: {
 		struct kvm_msr_entry msr_entry;
 
 		msr_entry.index = msr->index;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c6c2253c2fb..8fe615df8e5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1156,7 +1156,7 @@ static u32 msr_based_features[] = {
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
 
-	MSR_F10H_DECFG,
+	MSR_AMD64_DE_CFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 };
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 794824948263..dea9d6246e00 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -533,6 +533,7 @@ static void pm_save_spec_msr(void)
 		MSR_TSX_FORCE_ABORT,
 		MSR_IA32_MCU_OPT_CTRL,
 		MSR_AMD64_LS_CFG,
+		MSR_AMD64_DE_CFG,
 	};
 
 	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
diff --git a/block/sed-opal.c b/block/sed-opal.c
index 119640897293..9651c40e093a 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -94,8 +94,8 @@ struct opal_dev {
 	u64 lowest_lba;
 
 	size_t pos;
-	u8 cmd[IO_BUFFER_LENGTH];
-	u8 resp[IO_BUFFER_LENGTH];
+	u8 *cmd;
+	u8 *resp;
 
 	struct parsed_resp parsed;
 	size_t prev_d_len;
@@ -2028,6 +2028,8 @@ void free_opal_dev(struct opal_dev *dev)
 	if (!dev)
 		return;
 	clean_opal_dev(dev);
+	kfree(dev->resp);
+	kfree(dev->cmd);
 	kfree(dev);
 }
 EXPORT_SYMBOL(free_opal_dev);
@@ -2040,16 +2042,38 @@ struct opal_dev *init_opal_dev(void *data, sec_send_recv *send_recv)
 	if (!dev)
 		return NULL;
 
+	/*
+	 * Presumably DMA-able buffers must be cache-aligned. Kmalloc makes
+	 * sure the allocated buffer is DMA-safe in that regard.
+	 */
+	dev->cmd = kmalloc(IO_BUFFER_LENGTH, GFP_KERNEL);
+	if (!dev->cmd)
+		goto err_free_dev;
+
+	dev->resp = kmalloc(IO_BUFFER_LENGTH, GFP_KERNEL);
+	if (!dev->resp)
+		goto err_free_cmd;
+
 	INIT_LIST_HEAD(&dev->unlk_lst);
 	mutex_init(&dev->dev_lock);
 	dev->data = data;
 	dev->send_recv = send_recv;
 	if (check_opal_support(dev) != 0) {
 		pr_debug("Opal is not supported on this device\n");
-		kfree(dev);
-		return NULL;
+		goto err_free_resp;
 	}
 	return dev;
+
+err_free_resp:
+	kfree(dev->resp);
+
+err_free_cmd:
+	kfree(dev->cmd);
+
+err_free_dev:
+	kfree(dev);
+
+	return NULL;
 }
 EXPORT_SYMBOL(init_opal_dev);
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 43a91495ee67..f04f4f977400 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -317,7 +317,6 @@ int ata_tport_add(struct device *parent,
  tport_err:
 	transport_destroy_device(dev);
 	put_device(dev);
-	ata_host_put(ap->host);
 	return error;
 }
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c3e4f9d83b29..3ae718aa6b39 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2770,7 +2770,7 @@ static int init_submitter(struct drbd_device *device)
 enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsigned int minor)
 {
 	struct drbd_resource *resource = adm_ctx->resource;
-	struct drbd_connection *connection;
+	struct drbd_connection *connection, *n;
 	struct drbd_device *device;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 	struct gendisk *disk;
@@ -2898,7 +2898,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 out_idr_remove_vol:
 	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
-	for_each_connection(connection, resource) {
+	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
 		if (peer_device)
 			kref_put(&connection->kref, drbd_destroy_connection);
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index c52718b37f8f..adcae1077fd3 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -252,6 +252,8 @@ static void atc_dostart(struct at_dma_chan *atchan, struct at_desc *first)
 		       ATC_SPIP_BOUNDARY(first->boundary));
 	channel_writel(atchan, DPIP, ATC_DPIP_HOLE(first->dst_hole) |
 		       ATC_DPIP_BOUNDARY(first->boundary));
+	/* Don't allow CPU to reorder channel enable. */
+	wmb();
 	dma_writel(atdma, CHER, atchan->mask);
 
 	vdbg_dump_regs(atchan);
@@ -312,7 +314,8 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 	struct at_desc *desc_first = atc_first_active(atchan);
 	struct at_desc *desc;
 	int ret;
-	u32 ctrla, dscr, trials;
+	u32 ctrla, dscr;
+	unsigned int i;
 
 	/*
 	 * If the cookie doesn't match to the currently running transfer then
@@ -382,7 +385,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 		dscr = channel_readl(atchan, DSCR);
 		rmb(); /* ensure DSCR is read before CTRLA */
 		ctrla = channel_readl(atchan, CTRLA);
-		for (trials = 0; trials < ATC_MAX_DSCR_TRIALS; ++trials) {
+		for (i = 0; i < ATC_MAX_DSCR_TRIALS; ++i) {
 			u32 new_dscr;
 
 			rmb(); /* ensure DSCR is read after CTRLA */
@@ -408,7 +411,7 @@ static int atc_get_bytes_left(struct dma_chan *chan, dma_cookie_t cookie)
 			rmb(); /* ensure DSCR is read before CTRLA */
 			ctrla = channel_readl(atchan, CTRLA);
 		}
-		if (unlikely(trials >= ATC_MAX_DSCR_TRIALS))
+		if (unlikely(i == ATC_MAX_DSCR_TRIALS))
 			return -ETIMEDOUT;
 
 		/* for the first descriptor we can be more accurate */
@@ -556,10 +559,6 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 	bad_desc = atc_first_active(atchan);
 	list_del_init(&bad_desc->desc_node);
 
-	/* As we are stopped, take advantage to push queued descriptors
-	 * in active_list */
-	list_splice_init(&atchan->queue, atchan->active_list.prev);
-
 	/* Try to restart the controller */
 	if (!list_empty(&atchan->active_list))
 		atc_dostart(atchan, atc_first_active(atchan));
@@ -680,19 +679,11 @@ static dma_cookie_t atc_tx_submit(struct dma_async_tx_descriptor *tx)
 	spin_lock_irqsave(&atchan->lock, flags);
 	cookie = dma_cookie_assign(tx);
 
-	if (list_empty(&atchan->active_list)) {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: started %u\n",
-				desc->txd.cookie);
-		atc_dostart(atchan, desc);
-		list_add_tail(&desc->desc_node, &atchan->active_list);
-	} else {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
-				desc->txd.cookie);
-		list_add_tail(&desc->desc_node, &atchan->queue);
-	}
-
+	list_add_tail(&desc->desc_node, &atchan->queue);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
+	dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
+		 desc->txd.cookie);
 	return cookie;
 }
 
@@ -1967,7 +1958,11 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
 	  plat_dat->nr_channels);
 
-	dma_async_device_register(&atdma->dma_common);
+	err = dma_async_device_register(&atdma->dma_common);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to register: %d.\n", err);
+		goto err_dma_async_device_register;
+	}
 
 	/*
 	 * Do not return an error if the dmac node is not present in order to
@@ -1987,6 +1982,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_common);
+err_dma_async_device_register:
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->dma_desc_pool);
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index ef3f227ce3e6..00517cbd3a31 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -168,13 +168,13 @@
 /* LLI == Linked List Item; aka DMA buffer descriptor */
 struct at_lli {
 	/* values that are not changed by hardware */
-	dma_addr_t	saddr;
-	dma_addr_t	daddr;
+	u32 saddr;
+	u32 daddr;
 	/* value that may get written back: */
-	u32		ctrla;
+	u32 ctrla;
 	/* more values that are not changed by hardware */
-	u32		ctrlb;
-	dma_addr_t	dscr;	/* chain to next lli */
+	u32 ctrlb;
+	u32 dscr;	/* chain to next lli */
 };
 
 /**
diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index 462adf7e4e95..62864b3e120f 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -906,6 +906,7 @@ static int mv_xor_v2_remove(struct platform_device *pdev)
 	tasklet_kill(&xor_dev->irq_tasklet);
 
 	clk_disable_unprepare(xor_dev->clk);
+	clk_disable_unprepare(xor_dev->reg_clk);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 82e2ca17a441..15f21f60fc8a 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -55,13 +55,13 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attachme
 		goto err_unpin_pages;
 	}
 
-	ret = sg_alloc_table(st, obj->mm.pages->nents, GFP_KERNEL);
+	ret = sg_alloc_table(st, obj->mm.pages->orig_nents, GFP_KERNEL);
 	if (ret)
 		goto err_free;
 
 	src = obj->mm.pages->sgl;
 	dst = st->sgl;
-	for (i = 0; i < obj->mm.pages->nents; i++) {
+	for (i = 0; i < obj->mm.pages->orig_nents; i++) {
 		sg_set_page(dst, sg_page(src), src->length, 0);
 		dst = sg_next(dst);
 		src = sg_next(src);
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index c19c1dfbfcdc..de3996fe90be 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -243,8 +243,9 @@ static int imx_tve_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int imx_tve_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+imx_tve_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	struct imx_tve *tve = con_to_tve(connector);
 	unsigned long rate;
diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 868dd1ef3b69..f210560a4831 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -394,7 +394,12 @@ static int __init vc4_drm_register(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&vc4_platform_driver);
+	ret = platform_driver_register(&vc4_platform_driver);
+	if (ret)
+		platform_unregister_drivers(component_drivers,
+					    ARRAY_SIZE(component_drivers));
+
+	return ret;
 }
 
 static void __exit vc4_drm_unregister(void)
diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 4d1496f60071..8f2bf70218bf 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -500,7 +500,7 @@ static int mousevsc_probe(struct hv_device *device,
 
 	ret = hid_add_device(hid_dev);
 	if (ret)
-		goto probe_err1;
+		goto probe_err2;
 
 
 	ret = hid_parse(hid_dev);
diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 596841a3c4db..93f4bb7ace34 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -617,8 +617,10 @@ static struct iio_trigger *at91_adc_allocate_trigger(struct iio_dev *idev,
 	trig->ops = &at91_adc_trigger_ops;
 
 	ret = iio_trigger_register(trig);
-	if (ret)
+	if (ret) {
+		iio_trigger_free(trig);
 		return NULL;
+	}
 
 	return trig;
 }
diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
index 932e05001e1a..a582515ae2e6 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -95,7 +95,7 @@ static int ms5611_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index cccc07e637a4..9daba4b16a58 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -211,9 +211,13 @@ static int iio_sysfs_trigger_remove(int id)
 
 static int __init iio_sysfs_trig_init(void)
 {
+	int ret;
 	device_initialize(&iio_sysfs_trig_dev);
 	dev_set_name(&iio_sysfs_trig_dev, "iio_sysfs_trigger");
-	return device_add(&iio_sysfs_trig_dev);
+	ret = device_add(&iio_sysfs_trig_dev);
+	if (ret)
+		put_device(&iio_sysfs_trig_dev);
+	return ret;
 }
 module_init(iio_sysfs_trig_init);
 
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 082afbf088d6..c9b51511b33d 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1544,8 +1544,6 @@ static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
-	i8042_platform_device = dev;
-
 	if (i8042_reset == I8042_RESET_ALWAYS) {
 		error = i8042_controller_selftest();
 		if (error)
@@ -1583,7 +1581,6 @@ static int i8042_probe(struct platform_device *dev)
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return error;
 }
@@ -1593,7 +1590,6 @@ static int i8042_remove(struct platform_device *dev)
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return 0;
 }
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 5cd53b2c47c7..e542439f4950 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -231,7 +231,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 	err = get_free_devid();
 	if (err < 0)
-		goto error1;
+		return err;
 	dev->id = err;
 
 	device_initialize(&dev->dev);
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index e72b4e73cd61..796cae691560 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -97,6 +97,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	if (!entry)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&entry->list);
 	entry->elem = elem;
 
 	entry->dev.class = elements_class;
@@ -131,7 +132,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	device_unregister(&entry->dev);
 	return ret;
 err1:
-	kfree(entry);
+	put_device(&entry->dev);
 	return ret;
 }
 EXPORT_SYMBOL(mISDN_dsp_element_register);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 0aae4a46db66..0c8ddf37ef39 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -573,7 +573,7 @@ static void list_version_get_needed(struct target_type *tt, void *needed_param)
     size_t *needed = needed_param;
 
     *needed += sizeof(struct dm_target_versions);
-    *needed += strlen(tt->name);
+    *needed += strlen(tt->name) + 1;
     *needed += ALIGN_MASK;
 }
 
@@ -628,7 +628,7 @@ static int list_versions(struct file *filp, struct dm_ioctl *param, size_t param
 	iter_info.old_vers = NULL;
 	iter_info.vers = vers;
 	iter_info.flags = 0;
-	iter_info.end = (char *)vers+len;
+	iter_info.end = (char *)vers + needed;
 
 	/*
 	 * Now loop through filling out the names & versions.
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index db433d285eff..e353ad27ad30 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -865,6 +865,7 @@ static int qp_notify_peer_local(bool attach, struct vmci_handle handle)
 	u32 context_id = vmci_get_context_id();
 	struct vmci_event_qp ev;
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(context_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
@@ -1476,6 +1477,7 @@ static int qp_notify_peer(bool attach,
 	 * kernel.
 	 */
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(peer_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index e340791a8eab..6937f39fe657 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1461,7 +1461,13 @@ u32 mmc_select_voltage(struct mmc_host *host, u32 ocr)
 		mmc_power_cycle(host, ocr);
 	} else {
 		bit = fls(ocr) - 1;
-		ocr &= 3 << bit;
+		/*
+		 * The bit variable represents the highest voltage bit set in
+		 * the OCR register.
+		 * To keep a range of 2 values (e.g. 3.2V/3.3V and 3.3V/3.4V),
+		 * we must shift the mask '3' with (bit - 1).
+		 */
+		ocr &= 3 << (bit - 1);
 		if (bit != host->ios.vdd)
 			dev_warn(mmc_dev(host), "exceeding card's volts\n");
 	}
diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index cb4a0458f098..fecab3633a13 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1532,6 +1532,8 @@ static int amd_probe(struct sdhci_pci_chip *chip)
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 
diff --git a/drivers/mtd/spi-nor/intel-spi.c b/drivers/mtd/spi-nor/intel-spi.c
index d60cbf23d9aa..642a6f9071f2 100644
--- a/drivers/mtd/spi-nor/intel-spi.c
+++ b/drivers/mtd/spi-nor/intel-spi.c
@@ -116,7 +116,7 @@
 #define ERASE_OPCODE_SHIFT		8
 #define ERASE_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
 #define ERASE_64K_OPCODE_SHIFT		16
-#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
+#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_64K_OPCODE_SHIFT)
 
 #define INTEL_SPI_TIMEOUT		5000 /* ms */
 #define INTEL_SPI_FIFO_SZ		64
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 86811de191ed..f27391abd7da 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1015,8 +1015,10 @@ static int xgene_enet_open(struct net_device *ndev)
 
 	xgene_enet_napi_enable(pdata);
 	ret = xgene_enet_register_irq(ndev);
-	if (ret)
+	if (ret) {
+		xgene_enet_napi_disable(pdata);
 		return ret;
+	}
 
 	if (ndev->phydev) {
 		phy_start(ndev->phydev);
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 4c94d9218bba..50c5afc46eb0 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1566,7 +1566,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5e30299bcf64..dc106212259a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8327,8 +8327,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(fltr, head, hash) {
 		if (bnxt_fltr_match(fltr, new_fltr)) {
+			rc = fltr->sw_id;
 			rcu_read_unlock();
-			rc = 0;
 			goto err_free;
 		}
 	}
@@ -9383,8 +9383,16 @@ static struct pci_driver bnxt_pci_driver = {
 
 static int __init bnxt_init(void)
 {
+	int err;
+
 	bnxt_debug_init();
-	return pci_register_driver(&bnxt_pci_driver);
+	err = pci_register_driver(&bnxt_pci_driver);
+	if (err) {
+		bnxt_debug_exit();
+		return err;
+	}
+
+	return 0;
 }
 
 static void __exit bnxt_exit(void)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index c82469ab7aba..2c72e716b973 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1304,6 +1304,7 @@ static int cxgb_up(struct adapter *adap)
 		if (ret < 0) {
 			CH_ERR(adap, "failed to bind qsets, err %d\n", ret);
 			t3_intr_disable(adap);
+			quiesce_rx(adap);
 			free_irq_resources(adap);
 			err = ret;
 			goto out;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 713abcd9371f..390849faf4cd 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -891,12 +891,21 @@ static int mac_probe(struct platform_device *_of_dev)
 	return err;
 }
 
+static int mac_remove(struct platform_device *pdev)
+{
+	struct mac_device *mac_dev = platform_get_drvdata(pdev);
+
+	platform_device_unregister(mac_dev->priv->eth_dev);
+	return 0;
+}
+
 static struct platform_driver mac_driver = {
 	.driver = {
 		.name		= KBUILD_MODNAME,
 		.of_match_table	= mac_match,
 	},
 	.probe		= mac_probe,
+	.remove		= mac_remove,
 };
 
 builtin_platform_driver(mac_driver);
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 59007d6cd36d..2bfad889fdec 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2495,6 +2495,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 	for (i = 0; i < mp->rxq_count; i++)
 		rxq_deinit(mp->rxq + i);
 out:
+	napi_disable(&mp->napi);
 	free_irq(dev->irq, dev);
 
 	return err;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 85a54215616c..0a8483c615d4 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7126,9 +7126,8 @@ static int s2io_card_up(struct s2io_nic *sp)
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
-			s2io_reset(sp);
-			free_rx_buffers(sp);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_fill_buff;
 		}
 		DBG_PRINT(INFO_DBG, "Buf in ring:%d is %d:\n", i,
 			  ring->rx_bufs_left);
@@ -7166,18 +7165,16 @@ static int s2io_card_up(struct s2io_nic *sp)
 	/* Enable Rx Traffic and interrupts on the NIC */
 	if (start_nic(sp)) {
 		DBG_PRINT(ERR_DBG, "%s: Starting NIC failed\n", dev->name);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	/* Add interrupt service routine */
 	if (s2io_add_isr(sp) != 0) {
 		if (sp->config.intr_type == MSI_X)
 			s2io_rem_isr(sp);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	timer_setup(&sp->alarm_timer, s2io_alarm_handle, 0);
@@ -7197,6 +7194,20 @@ static int s2io_card_up(struct s2io_nic *sp)
 	}
 
 	return 0;
+
+err_out:
+	if (config->napi) {
+		if (config->intr_type == MSI_X) {
+			for (i = 0; i < sp->config.rx_ring_num; i++)
+				napi_disable(&sp->mac_control.rings[i].napi);
+		} else {
+			napi_disable(&sp->napi);
+		}
+	}
+err_fill_buff:
+	s2io_reset(sp);
+	free_rx_buffers(sp);
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a791d7932b0e..abbb25f1384c 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -833,6 +833,7 @@ static int nixge_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(priv->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&priv->napi);
 	phy_stop(phy);
 	phy_disconnect(phy);
 	tasklet_kill(&priv->dma_err_tasklet);
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 777fa59f5e0c..1eeddfea389c 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -537,7 +537,7 @@ static int bpq_device_event(struct notifier_block *this,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !bpq_get_ax25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e226a96da3a3..e1f95fd08d72 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1137,7 +1137,7 @@ void macvlan_common_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);
@@ -1471,8 +1471,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	/* the macvlan port may be freed by macvlan_uninit when fail to register.
 	 * so we destroy the macvlan port only when it's valid.
 	 */
-	if (create && macvlan_port_get_rtnl(lowerdev))
+	if (create && macvlan_port_get_rtnl(lowerdev)) {
+		macvlan_flush_sources(port, vlan);
 		macvlan_port_destroy(port->dev);
+	}
 	return err;
 }
 EXPORT_SYMBOL_GPL(macvlan_common_newlink);
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 4b5af2413970..51b5442fbc66 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1342,12 +1342,21 @@ static int __init tbnet_init(void)
 				  TBNET_MATCH_FRAGS_ID);
 
 	ret = tb_register_property_dir("network", tbnet_dir);
-	if (ret) {
-		tb_property_free_dir(tbnet_dir);
-		return ret;
-	}
+	if (ret)
+		goto err_free_dir;
+
+	ret = tb_register_service_driver(&tbnet_driver);
+	if (ret)
+		goto err_unregister;
 
-	return tb_register_service_driver(&tbnet_driver);
+	return 0;
+
+err_unregister:
+	tb_unregister_property_dir("network", tbnet_dir);
+err_free_dir:
+	tb_property_free_dir(tbnet_dir);
+
+	return ret;
 }
 module_init(tbnet_init);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8d1b34640f79..8df651999b2b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1962,17 +1962,25 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		headlen = eth_get_headlen(skb->data, skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
+			WARN_ON_ONCE(1);
+			err = -ENOMEM;
 			this_cpu_inc(tun->pcpu_stats->rx_dropped);
+napi_busy:
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
-			WARN_ON(1);
-			return -ENOMEM;
+			return err;
 		}
 
-		local_bh_disable();
-		napi_gro_frags(&tfile->napi);
-		local_bh_enable();
+		if (likely(napi_schedule_prep(&tfile->napi))) {
+			local_bh_disable();
+			napi_gro_frags(&tfile->napi);
+			napi_complete(&tfile->napi);
+			local_bh_enable();
+		} else {
+			err = -EBUSY;
+			goto napi_busy;
+		}
 		mutex_unlock(&tfile->napi_mutex);
 	} else if (tfile->napi_enabled) {
 		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 3ec922bed2d8..6233805fc032 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -406,7 +406,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	if (dev_net(dev) != &init_net)
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !lapbeth_get_x25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index dee5b9e35ffd..d99ac73a1d89 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -474,7 +474,7 @@ static size_t parport_pc_fifo_write_block_pio(struct parport *port,
 	const unsigned char *bufp = buf;
 	size_t left = length;
 	unsigned long expire = jiffies + port->physport->cad->timeout;
-	const int fifo = FIFO(port);
+	const unsigned long fifo = FIFO(port);
 	int poll_for = 8; /* 80 usecs */
 	const struct parport_pc_private *priv = port->physport->private_data;
 	const int fifo_depth = priv->fifo_depth;
diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 1255cd1d9a60..5056662d2927 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -393,6 +393,8 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(child, "reg", &index);
 		if (ret || index > usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
+			if (!ret)
+				ret = -EINVAL;
 			goto put_child;
 		}
 
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 177ee1136e34..6f5acfcba57c 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -235,6 +235,8 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
 		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
+		if (!propname)
+			return -ENOMEM;
 		prop = of_find_property(np, propname, &size);
 		kfree(propname);
 		if (!prop) {
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index f911410bb4c7..ba1a3e2fcebe 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -894,8 +894,16 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 	wwan_rfkill = NULL;
 	rfkill2_count = 0;
 
-	if (hp_wmi_rfkill_setup(device))
-		hp_wmi_rfkill2_setup(device);
+	/*
+	 * In pre-2009 BIOS, command 1Bh return 0x4 to indicate that
+	 * BIOS no longer controls the power for the wireless
+	 * devices. All features supported by this command will no
+	 * longer be supported.
+	 */
+	if (!hp_wmi_bios_2009_later()) {
+		if (hp_wmi_rfkill_setup(device))
+			hp_wmi_rfkill2_setup(device);
+	}
 
 	err = device_create_file(&device->dev, &dev_attr_display);
 	if (err)
diff --git a/drivers/siox/siox-core.c b/drivers/siox/siox-core.c
index f8c08fb9891d..e0ffef6e9386 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -835,6 +835,8 @@ static struct siox_device *siox_device_add(struct siox_master *smaster,
 
 err_device_register:
 	/* don't care to make the buffer smaller again */
+	put_device(&sdevice->dev);
+	sdevice = NULL;
 
 err_buf_alloc:
 	siox_master_unlock(smaster);
diff --git a/drivers/slimbus/stream.c b/drivers/slimbus/stream.c
index 2fa05324ed07..2a376afed35c 100644
--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_table[] = {
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,
diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index d4a74f7ddf6b..5e4e2f423e42 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -1778,7 +1778,7 @@ static void speakup_con_update(struct vc_data *vc)
 {
 	unsigned long flags;
 
-	if (!speakup_console[vc->vc_num] || spk_parked)
+	if (!speakup_console[vc->vc_num] || spk_parked || !synth)
 		return;
 	if (!spin_trylock_irqsave(&speakup_info.spinlock, flags))
 		/* Speakup output, discard */
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index bc8918f382e4..80b74db4048b 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -409,6 +409,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
 		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
+		put_device(&tl_hba->dev);
 		return -ENODEV;
 	}
 
@@ -1103,7 +1104,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	 */
 	ret = tcm_loop_setup_hba_bus(tl_hba, tcm_loop_hba_no_cnt);
 	if (ret)
-		goto out;
+		return ERR_PTR(ret);
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f6d2be13b32e..4a890011eba3 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1413,7 +1413,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 		unsigned int command, u8 *data, int clen)
 {
 	struct gsm_control *ctrl = kzalloc(sizeof(struct gsm_control),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 	unsigned long flags;
 	if (ctrl == NULL)
 		return NULL;
diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 98dbc796353f..448388ec03e2 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -246,8 +246,13 @@ static int lpss8250_dma_setup(struct lpss8250 *lpss, struct uart_8250_port *port
 	struct dw_dma_slave *rx_param, *tx_param;
 	struct device *dev = port->port.dev;
 
-	if (!lpss->dma_param.dma_dev)
+	if (!lpss->dma_param.dma_dev) {
+		dma = port->dma;
+		if (dma)
+			goto out_configuration_only;
+
 		return 0;
+	}
 
 	rx_param = devm_kzalloc(dev, sizeof(*rx_param), GFP_KERNEL);
 	if (!rx_param)
@@ -258,16 +263,18 @@ static int lpss8250_dma_setup(struct lpss8250 *lpss, struct uart_8250_port *port
 		return -ENOMEM;
 
 	*rx_param = lpss->dma_param;
-	dma->rxconf.src_maxburst = lpss->dma_maxburst;
-
 	*tx_param = lpss->dma_param;
-	dma->txconf.dst_maxburst = lpss->dma_maxburst;
 
 	dma->fn = lpss8250_dma_filter;
 	dma->rx_param = rx_param;
 	dma->tx_param = tx_param;
 
 	port->dma = dma;
+
+out_configuration_only:
+	dma->rxconf.src_maxburst = lpss->dma_maxburst;
+	dma->txconf.dst_maxburst = lpss->dma_maxburst;
+
 	return 0;
 }
 
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index c1166b45c288..8cf4819312f5 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -162,27 +162,10 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static void omap_8250_mdr1_errataset(struct uart_8250_port *up,
 				     struct omap8250_priv *priv)
 {
-	u8 timeout = 255;
-
 	serial_out(up, UART_OMAP_MDR1, priv->mdr1);
 	udelay(2);
 	serial_out(up, UART_FCR, up->fcr | UART_FCR_CLEAR_XMIT |
 			UART_FCR_CLEAR_RCVR);
-	/*
-	 * Wait for FIFO to empty: when empty, RX_FIFO_E bit is 0 and
-	 * TX_FIFO_E bit is 1.
-	 */
-	while (UART_LSR_THRE != (serial_in(up, UART_LSR) &
-				(UART_LSR_THRE | UART_LSR_DR))) {
-		timeout--;
-		if (!timeout) {
-			/* Should *never* happen. we warn and carry on */
-			dev_crit(up->port.dev, "Errata i202: timedout %x\n",
-				 serial_in(up, UART_LSR));
-			break;
-		}
-		udelay(1);
-	}
 }
 
 static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
@@ -1279,6 +1262,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
 	serial8250_unregister_port(priv->line);
 	pm_qos_remove_request(&priv->pm_qos_request);
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 6fc89888a52e..ce266e10a21e 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1865,10 +1865,13 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
-	case UART_IIR_RX_TIMEOUT:
-		serial8250_rx_dma_flush(up);
+	case UART_IIR_RDI:
+		if (!up->dma->rx_running)
+			break;
 		/* fall-through */
 	case UART_IIR_RLSI:
+	case UART_IIR_RX_TIMEOUT:
+		serial8250_rx_dma_flush(up);
 		return true;
 	}
 	return up->dma->rx_dma(up);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index aeda1fe71eeb..819f340a8a7a 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2510,6 +2510,7 @@ static const struct dev_pm_ops imx_uart_pm_ops = {
 	.suspend_noirq = imx_uart_suspend_noirq,
 	.resume_noirq = imx_uart_resume_noirq,
 	.freeze_noirq = imx_uart_suspend_noirq,
+	.thaw_noirq = imx_uart_resume_noirq,
 	.restore_noirq = imx_uart_resume_noirq,
 	.suspend = imx_uart_suspend,
 	.resume = imx_uart_resume,
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 6ed4b00dba96..7a2a9559693f 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -256,8 +256,10 @@ static void ci_otg_del_timer(struct ci_hdrc *ci, enum otg_fsm_timer t)
 	ci->enabled_otg_timer_bits &= ~(1 << t);
 	if (ci->next_otg_timer == t) {
 		if (ci->enabled_otg_timer_bits == 0) {
+			spin_unlock_irqrestore(&ci->lock, flags);
 			/* No enabled timers after delete it */
 			hrtimer_cancel(&ci->otg_fsm_hrtimer);
+			spin_lock_irqsave(&ci->lock, flags);
 			ci->next_otg_timer = NUM_OTG_FSM_TIMERS;
 		} else {
 			/* Find the next timer */
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 62a063ed8220..35a11f7bcb65 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -362,6 +362,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Realforce 87U Keyboard */
+	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 560e628912e5..ebb293627129 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -162,6 +162,8 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
+#define UBLOX_VENDOR_ID				0x1546
+
 /* AMOI PRODUCTS */
 #define AMOI_VENDOR_ID				0x1614
 #define AMOI_PRODUCT_H01			0x0800
@@ -240,7 +242,6 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
-#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -581,6 +582,9 @@ static void option_instat_callback(struct urb *urb);
 #define OPPO_VENDOR_ID				0x22d9
 #define OPPO_PRODUCT_R11			0x276c
 
+/* Sierra Wireless products */
+#define SIERRA_VENDOR_ID			0x1199
+#define SIERRA_PRODUCT_EM9191			0x90d3
 
 /* Device flags */
 
@@ -1124,8 +1128,16 @@ static const struct usb_device_id option_ids[] = {
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
-	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x908b),	/* u-blox LARA-R6 00B */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
+	/* u-blox products */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1341) },	/* u-blox LARA-L6 */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1342),		/* u-blox LARA-L6 (RMNET) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1343),		/* u-blox LARA-L6 (ECM) */
+	  .driver_info = RSVD(4) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
@@ -2167,6 +2179,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x010a, 0xff) },			/* Fibocom MA510 (ECM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0111, 0xff) },			/* Fibocom FM160 (MBIM mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a2, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a4, 0xff),			/* Fibocom FM101-GL (laptop MBIM) */
@@ -2176,6 +2189,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
 	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index cdc6daa7a9f6..9cf7085a260b 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -228,7 +228,7 @@ static int register_pcpu(struct pcpu *pcpu)
 
 	err = device_register(dev);
 	if (err) {
-		pcpu_release(dev);
+		put_device(dev);
 		return err;
 	}
 
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 82d874b10438..86c6ff2cc689 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -174,7 +174,7 @@ void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info)
 
 void btrfs_free_dummy_root(struct btrfs_root *root)
 {
-	if (!root)
+	if (IS_ERR_OR_NULL(root))
 		return;
 	/* Will be freed by btrfs_free_fs_roots */
 	if (WARN_ON(test_bit(BTRFS_ROOT_IN_RADIX, &root->state)))
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 24a61e524861..9b43907324a3 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -230,7 +230,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -246,7 +245,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -258,18 +256,19 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
+	/* btrfs_qgroup_account_extent() always frees the ulists passed to it. */
+	old_roots = NULL;
+	new_roots = NULL;
+
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				nodesize, nodesize)) {
 		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
-	old_roots = NULL;
-	new_roots = NULL;
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -284,7 +283,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -335,7 +333,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -351,7 +348,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -372,7 +368,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -388,7 +383,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -415,7 +409,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -431,7 +424,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
diff --git a/fs/buffer.c b/fs/buffer.c
index 356e289d19f2..5bc0877f223f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2321,7 +2321,7 @@ int generic_cont_expand_simple(struct inode *inode, loff_t size)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 
 	err = inode_newsize_ok(inode, size);
@@ -2347,7 +2347,7 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	unsigned int blocksize = i_blocksize(inode);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	pgoff_t index, curidx;
 	loff_t curpos;
 	unsigned zerofrom, offset, len;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 54f32f9143a9..5a7020e767e4 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -149,7 +149,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
 						(int __user *)arg);
-				if (rc != EOPNOTSUPP)
+				if (rc != -EOPNOTSUPP)
 					break;
 			}
 #endif /* CONFIG_CIFS_POSIX */
@@ -178,7 +178,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *		       pSMBFile->fid.netfid,
 			 *		       extAttrBits,
 			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
+			 * if (rc != -EOPNOTSUPP)
 			 *	break;
 			 */
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 17001f4e9f84..e5e7a8101aa6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -172,7 +172,10 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 		pr_warn("Invalid superblock size\n");
 		return -EINVAL;
 	}
-
+	if (sb->sb_bsize_shift != ffs(sb->sb_bsize) - 1) {
+		pr_warn("Invalid block size shift\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -369,8 +372,10 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	BUILD_BUG_ON(GFS2_LOCKNAME_LEN > GFS2_FSNAME_LEN);
+
+	strscpy(sdp->sd_proto_name, proto, GFS2_LOCKNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_LOCKNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
diff --git a/fs/namei.c b/fs/namei.c
index c34ee9653559..9e8fca598acc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4826,7 +4826,7 @@ int __page_symlink(struct inode *inode, const char *symname, int len, int nofs)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 	unsigned int flags = 0;
 	if (nofs)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f9f76594b866..9a0f48f7f2b8 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6613,6 +6613,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 	struct nfs4_lock_state *lsp = data->lsp;
+	struct nfs_server *server = NFS_SERVER(d_inode(data->ctx->dentry));
 
 	dprintk("%s: begin!\n", __func__);
 
@@ -6622,8 +6623,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	data->rpc_status = task->tk_status;
 	switch (task->tk_status) {
 	case 0:
-		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
-				data->timestamp);
+		renew_lease(server, data->timestamp);
 		if (data->arg.new_lock && !data->cancelled) {
 			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
 			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
@@ -6644,6 +6644,8 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 			if (!nfs4_stateid_match(&data->arg.open_stateid,
 						&lsp->ls_state->open_stateid))
 				goto out_restart;
+			else if (nfs4_async_handle_error(task, server, lsp->ls_state, NULL) == -EAGAIN)
+				goto out_restart;
 		} else if (!nfs4_stateid_match(&data->arg.lock_stateid,
 						&lsp->ls_stateid))
 				goto out_restart;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 535543ab4e26..11914b3585b3 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -322,7 +322,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2243,7 +2243,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_transaction_info *ti;
 	int err;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2282,7 +2282,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2778,11 +2778,12 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem was remounted
-		 * read/write after nilfs_error degenerated it into a
-		 * read-only mount.
+		 * This happens if the filesystem is made read-only by
+		 * __nilfs_error or nilfs_remount and then remounted
+		 * read/write.  In these cases, reuse the existing
+		 * writer.
 		 */
-		nilfs_detach_log_writer(sb);
+		return 0;
 	}
 
 	nilfs->ns_writer = nilfs_segctor_new(sb, root);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2a3ad1270133..5e4d7d19102c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1138,8 +1138,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out;
 	if (*flags & SB_RDONLY) {
-		/* Shutting down log writer */
-		nilfs_detach_log_writer(sb);
 		sb->s_flags |= SB_RDONLY;
 
 		/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 931870768556..fb61c33c6004 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -695,9 +695,7 @@ int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 {
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 62b49197e5f6..0a7efbe2adb3 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -608,17 +608,37 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
-		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-			       a->name_length * sizeof(ntfschar);
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
-		    name_end > mrec_end)
+		u8 *name_end;
+
+		/* check whether ATTR_RECORD wrap */
+		if ((u8 *)a < (u8 *)ctx->mrec)
+			break;
+
+		/* check whether Attribute Record Header is within bounds */
+		if ((u8 *)a > mrec_end ||
+		    (u8 *)a + sizeof(ATTR_RECORD) > mrec_end)
+			break;
+
+		/* check whether ATTR_RECORD's name is within bounds */
+		name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			   a->name_length * sizeof(ntfschar);
+		if (name_end > mrec_end)
 			break;
+
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
 				a->type == AT_END))
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 0acd1f02b146..97d34de2a8f3 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1854,6 +1854,13 @@ int ntfs_read_inode_mount(struct inode *vi)
 		goto err_out;
 	}
 
+	/* Sanity check offset to the first attribute */
+	if (le16_to_cpu(m->attrs_offset) >= le32_to_cpu(m->bytes_allocated)) {
+		ntfs_error(sb, "Incorrect mft offset to the first attribute %u in superblock.",
+			       le16_to_cpu(m->attrs_offset));
+		goto err_out;
+	}
+
 	/* Need this to sanity check attribute list references to $MFT. */
 	vi->i_generation = ni->seq_no = le16_to_cpu(m->sequence_number);
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 1dfb9c36e6da..d13ded8e2c30 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -241,7 +241,7 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 						      poffset - lfi);
 			else {
 				if (!copy_name) {
-					copy_name = kmalloc(UDF_NAME_LEN,
+					copy_name = kmalloc(UDF_NAME_LEN_CS0,
 							    GFP_NOFS);
 					if (!copy_name) {
 						fi = ERR_PTR(-ENOMEM);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a26e6f5034a6..d56faf894492 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -242,6 +242,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -843,7 +844,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 240fdb9a60f6..6e0d68e841cd 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -376,7 +376,7 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
-#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+#define CAP_TO_MASK(x)      (1U << ((x) & 31)) /* mask for indexed __u32 */
 
 
 #endif /* _UAPI_LINUX_CAPABILITY_H */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ba7d361878aa..9c7795566436 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1331,6 +1331,7 @@ static int ftrace_add_mod(struct trace_array *tr,
 	if (!ftrace_mod)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ftrace_mod->list);
 	ftrace_mod->func = kstrdup(func, GFP_KERNEL);
 	ftrace_mod->module = kstrdup(module, GFP_KERNEL);
 	ftrace_mod->enable = enable;
@@ -3033,7 +3034,7 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 		/* if we can't allocate this size, try something smaller */
 		if (!order)
 			return -ENOMEM;
-		order >>= 1;
+		order--;
 		goto again;
 	}
 
@@ -6229,7 +6230,7 @@ void __init ftrace_init(void)
 	}
 
 	pr_info("ftrace: allocating %ld entries in %ld pages\n",
-		count, count / ENTRIES_PER_PAGE + 1);
+		count, DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a0353c8f0891..5e5b0c067f61 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1328,9 +1328,9 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	free_buffer_page(cpu_buffer->reader_page);
 
-	rb_head_page_deactivate(cpu_buffer);
-
 	if (head) {
+		rb_head_page_deactivate(cpu_buffer);
+
 		list_for_each_entry_safe(bpage, tmp, head, list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
diff --git a/mm/filemap.c b/mm/filemap.c
index f2e777003b90..e61ec2c88bd0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3140,7 +3140,7 @@ ssize_t generic_perform_write(struct file *file,
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
-		void *fsdata;
+		void *fsdata = NULL;
 
 		offset = (pos & (PAGE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_SIZE - offset,
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 9268f808afc0..7194ffa58d3e 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -220,6 +220,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -227,7 +229,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t
@@ -835,11 +836,14 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 		goto out_free_ts;
 	if (!(ts->rd->f_mode & FMODE_READ))
 		goto out_put_rd;
+	/* prevent workers from hanging on IO when fd is a pipe */
+	ts->rd->f_flags |= O_NONBLOCK;
 	ts->wr = fget(wfd);
 	if (!ts->wr)
 		goto out_put_rd;
 	if (!(ts->wr->f_mode & FMODE_WRITE))
 		goto out_put_wr;
+	ts->wr->f_flags |= O_NONBLOCK;
 
 	client->trans = ts;
 	client->status = Connected;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 251da90642cd..82e3629617c8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1824,7 +1824,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f4078830ea50..e0c6dfae42d8 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -87,6 +87,7 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
 		return ERR_PTR(-EINVAL);
 
+	size = SKB_DATA_ALIGN(size);
 	data = kzalloc(size + headroom + tailroom, GFP_USER);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 8aeece7aa9e9..ece140ad0ac1 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -314,9 +314,6 @@ static int chnl_net_open(struct net_device *dev)
 
 	if (result == 0) {
 		pr_debug("connect timeout\n");
-		caif_disconnect_client(dev_net(dev), &priv->chnl);
-		priv->state = CAIF_DISCONNECTED;
-		pr_debug("state disconnected\n");
 		result = -ETIMEDOUT;
 		goto error;
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e0be1f8651bb..4178fc28c277 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3560,23 +3560,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	int pos;
 	int dummy;
 
-	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
-	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
-		/* gso_size is untrusted, and we have a frag_list with a linear
-		 * non head_frag head.
-		 *
-		 * (we assume checking the first list_skb member suffices;
-		 * i.e if either of the list_skb members have non head_frag
-		 * head, then the first one has too).
-		 *
-		 * If head_skb's headlen does not fit requested gso_size, it
-		 * means that the frag_list members do NOT terminate on exact
-		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
-		 * sharing. Therefore we must fallback to copying the frag_list
-		 * skbs; we do so by disabling SG.
-		 */
-		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			features &= ~NETIF_F_SG;
+	if ((skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY) &&
+	    mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb)) {
+		struct sk_buff *check_skb;
+
+		for (check_skb = list_skb; check_skb; check_skb = check_skb->next) {
+			if (skb_headlen(check_skb) && !check_skb->head_frag) {
+				/* gso_size is untrusted, and we have a frag_list with
+				 * a linear non head_frag item.
+				 *
+				 * If head_skb's headlen does not fit requested gso_size,
+				 * it means that the frag_list members do NOT terminate
+				 * on exact gso_size boundaries. Hence we cannot perform
+				 * skb_frag_t page sharing. Therefore we must fallback to
+				 * copying the frag_list skbs; we do so by disabling SG.
+				 */
+				features &= ~NETIF_F_SG;
+				break;
+			}
+		}
 	}
 
 	__skb_push(head_skb, doffset);
diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
index 06fbe102a425..10daea1fcefc 100644
--- a/net/ipv4/tcp_cdg.c
+++ b/net/ipv4/tcp_cdg.c
@@ -374,6 +374,7 @@ static void tcp_cdg_init(struct sock *sk)
 	struct cdg *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
+	ca->gradients = NULL;
 	/* We silently fall back to window = 1 if allocation fails. */
 	if (window > 1)
 		ca->gradients = kcalloc(window, sizeof(ca->gradients[0]),
@@ -387,6 +388,7 @@ static void tcp_cdg_release(struct sock *sk)
 	struct cdg *ca = inet_csk_ca(sk);
 
 	kfree(ca->gradients);
+	ca->gradients = NULL;
 }
 
 static struct tcp_congestion_ops tcp_cdg __read_mostly = {
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index c7dc8b2de6c2..7fdd433b968e 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -437,6 +437,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
 {
 	struct ifaddrlblmsg *ifal = nlmsg_data(nlh);
 	ifal->ifal_family = AF_INET6;
+	ifal->__ifal_reserved = 0;
 	ifal->ifal_prefixlen = prefixlen;
 	ifal->ifal_flags = 0;
 	ifal->ifal_index = ifindex;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index f2fbccd3fcf4..c0034546a9ed 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -224,7 +224,7 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 	struct sk_buff *skb;
 	struct kcm_sock *kcm;
 
-	while ((skb = __skb_dequeue(head))) {
+	while ((skb = skb_dequeue(head))) {
 		/* Reset destructor to avoid calling kcm_rcv_ready */
 		skb->destructor = sock_rfree;
 		skb_orphan(skb);
@@ -1085,53 +1085,18 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
-				     long timeo, int *err)
-{
-	struct sk_buff *skb;
-
-	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
-
-		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
-
-		if ((flags & MSG_DONTWAIT) || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
-
-		sk_wait_data(sk, &timeo, NULL);
-
-		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
-	}
-
-	return skb;
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
+	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
 	int err = 0;
-	long timeo;
 	struct strp_msg *stm;
 	int copied = 0;
 	struct sk_buff *skb;
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
 
@@ -1162,14 +1127,11 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
-			skb_unlink(skb, &sk->sk_receive_queue);
-			kfree_skb(skb);
 		}
 	}
 
 out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied ? : err;
 }
 
@@ -1177,9 +1139,9 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 			       struct pipe_inode_info *pipe, size_t len,
 			       unsigned int flags)
 {
+	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	long timeo;
 	struct strp_msg *stm;
 	int err = 0;
 	ssize_t copied;
@@ -1187,11 +1149,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 
 	/* Only support splice for SOCKSEQPACKET */
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto err_out;
 
@@ -1219,13 +1177,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	 * finish reading the message.
 	 */
 
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied;
 
 err_out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return err;
 }
 
@@ -1845,10 +1801,10 @@ static int kcm_release(struct socket *sock)
 	kcm = kcm_sk(sk);
 	mux = kcm->mux;
 
+	lock_sock(sk);
 	sock_orphan(sk);
 	kfree_skb(kcm->seq_skb);
 
-	lock_sock(sk);
 	/* Purge queue under lock to avoid race condition with tx_work trying
 	 * to act when queue is nonempty. If tx_work runs after this point
 	 * it will just return.
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 5086e27d3011..59e8e17d8da9 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -865,7 +865,7 @@ static int tipc_nl_compat_name_table_dump_header(struct tipc_nl_compat_msg *msg)
 	};
 
 	ntq = (struct tipc_name_table_query *)TLV_DATA(msg->req);
-	if (TLV_GET_DATA_LEN(msg->req) < sizeof(struct tipc_name_table_query))
+	if (TLV_GET_DATA_LEN(msg->req) < (int)sizeof(struct tipc_name_table_query))
 		return -EINVAL;
 
 	depth = ntohl(ntq->depth);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dd8503a3ef1e..07d053603e3a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1050,6 +1050,8 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 
 static int query_regdb_file(const char *alpha2)
 {
+	int err;
+
 	ASSERT_RTNL();
 
 	if (regdb)
@@ -1059,9 +1061,13 @@ static int query_regdb_file(const char *alpha2)
 	if (!alpha2)
 		return -ENOMEM;
 
-	return request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
-				       &reg_pdev->dev, GFP_KERNEL,
-				       (void *)alpha2, regdb_fw_cb);
+	err = request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
+				      &reg_pdev->dev, GFP_KERNEL,
+				      (void *)alpha2, regdb_fw_cb);
+	if (err)
+		kfree(alpha2);
+
+	return err;
 }
 
 int reg_reload_regdb(void)
diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 30f71620d4e3..24f2676e3b66 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -122,7 +122,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 
 	if (!pskb_may_pull(skb, 1)) {
 		x25_neigh_put(nb);
-		return 0;
+		goto drop;
 	}
 
 	switch (skb->data[0]) {
diff --git a/scripts/extract-cert.c b/scripts/extract-cert.c
index b071bf476fea..dd1a4bd706a2 100644
--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -23,6 +23,13 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+/*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 #define PKEY_ID_PKCS7 2
 
 static __attribute__((noreturn))
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index fbd34b8e8f57..7434e9ea926e 100644
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -29,6 +29,13 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+/*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 /*
  * Use CMS if we have openssl-1.0.0 or newer available - otherwise we have to
  * assume that it's not available and its header file is missing and that we
diff --git a/sound/hda/hdac_sysfs.c b/sound/hda/hdac_sysfs.c
index fb2aa344981e..ce2af695a19a 100644
--- a/sound/hda/hdac_sysfs.c
+++ b/sound/hda/hdac_sysfs.c
@@ -346,8 +346,10 @@ static int add_widget_node(struct kobject *parent, hda_nid_t nid,
 		return -ENOMEM;
 	kobject_init(kobj, &widget_ktype);
 	err = kobject_add(kobj, parent, "%02x", nid);
-	if (err < 0)
+	if (err < 0) {
+		kobject_put(kobj);
 		return err;
+	}
 	err = sysfs_create_group(kobj, group);
 	if (err < 0) {
 		kobject_put(kobj);
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 004a7772bb5d..23f00ba993cb 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1070,6 +1070,7 @@ static const struct snd_pci_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	{}
 };
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 9b33c87c2fe4..7e817e1877c2 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2085,6 +2085,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2117,9 +2120,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 43a47312d71b..e510aca55163 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2453,6 +2453,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2485,9 +2488,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 9f819113af1e..bb6a95be8726 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1159,6 +1159,9 @@ static int wm8997_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm8997_digital_vu[i],
 				   WM8997_DIG_VU, WM8997_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	arizona_init_common(arizona);
 
 	ret = arizona_init_vol_limit(arizona);
@@ -1177,9 +1180,6 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9ca7dff5593d..07875867f5c2 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3863,10 +3863,23 @@ EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_link_codecs);
 
 static int __init snd_soc_init(void)
 {
+	int ret;
+
 	snd_soc_debugfs_init();
-	snd_soc_util_init();
+	ret = snd_soc_util_init();
+	if (ret)
+		goto err_util_init;
 
-	return platform_driver_register(&soc_driver);
+	ret = platform_driver_register(&soc_driver);
+	if (ret)
+		goto err_register;
+	return 0;
+
+err_register:
+	snd_soc_util_exit();
+err_util_init:
+	snd_soc_debugfs_exit();
+	return ret;
 }
 module_init(snd_soc_init);
 
diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index e0c93496c0cd..ba7e5ee30f66 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -373,7 +373,7 @@ int __init snd_soc_util_init(void)
 	return ret;
 }
 
-void __exit snd_soc_util_exit(void)
+void snd_soc_util_exit(void)
 {
 	platform_driver_unregister(&soc_dummy_driver);
 	platform_device_unregister(soc_dummy_dev);
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index c9c604f0e1ff..78637bfafd09 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1149,10 +1149,8 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 					port = &umidi->endpoints[i].out->ports[j];
 					break;
 				}
-	if (!port) {
-		snd_BUG();
+	if (!port)
 		return -ENXIO;
-	}
 
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 3f353e051a1d..e72f744bc305 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2109,6 +2109,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/* M-Audio Micro */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x201a),
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2030),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 512e052e59f7..43cbaaff163f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1410,6 +1410,7 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
+	case USB_ID(0x21ed, 0xd75a): /* Accuphase DAC-60 option card */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 30996306cabc..479531f5865d 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,11 +3,11 @@ INCLUDES := -I../include -I../../
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
 LDFLAGS := $(LDFLAGS) -pthread -lrt
 
-HEADERS := \
+LOCAL_HDRS := \
 	../include/futextest.h \
 	../include/atomic.h \
 	../include/logging.h
-TEST_GEN_FILES := \
+TEST_GEN_PROGS := \
 	futex_wait_timeout \
 	futex_wait_wouldblock \
 	futex_requeue_pi \
@@ -21,5 +21,3 @@ TEST_PROGS := run.sh
 top_srcdir = ../../../../..
 KSFT_KHDR_INSTALL := 1
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testing/selftests/intel_pstate/Makefile
index 7340fd6a9a9f..9fc1a40b0127 100644
--- a/tools/testing/selftests/intel_pstate/Makefile
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -2,10 +2,10 @@
 CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
 LDLIBS := $(LDLIBS) -lm
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq (x86,$(ARCH))
+ifeq (x86,$(ARCH_PROCESSED))
 TEST_GEN_FILES := msr aperf
 endif
 
diff --git a/tools/testing/selftests/kvm/include/x86.h b/tools/testing/selftests/kvm/include/x86.h
index a7667a613bbc..68b69f13a50d 100644
--- a/tools/testing/selftests/kvm/include/x86.h
+++ b/tools/testing/selftests/kvm/include/x86.h
@@ -614,6 +614,11 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+
+#define MSR_AMD64_DE_CFG		0xc0011029
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	1
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE	BIT_ULL(MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)
+
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
@@ -664,9 +669,6 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
