Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0886E6A294B
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 12:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBYLKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 06:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBYLKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 06:10:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC49C1968A;
        Sat, 25 Feb 2023 03:09:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0182260AFC;
        Sat, 25 Feb 2023 11:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B275FC433D2;
        Sat, 25 Feb 2023 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677323346;
        bh=jgd5EvbIVuEXVM000xL86NH0r5tvghprJxmwWOi5iAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+8UnTuOf+7DAQ2uUCkz9uECmEJAH18ue+txBhAQzPbhp6h6+xTP5/9vHW0QIZC+1
         VytbfA1fM07obSAuBR+rDdJWT+9hLyadUzj1Xw2tWuAGmLfxDeFOMIUSs7nHLxL0ga
         j4NFNpMMr7y32jPQ2QveEw76CJ37z2Abu5QCsz6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.96
Date:   Sat, 25 Feb 2023 12:08:55 +0100
Message-Id: <1677323335200250@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167732333583191@kroah.com>
References: <167732333583191@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 4f50a453e18a..d0884a5d49b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3114,7 +3114,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git
@@ -3407,6 +3407,7 @@ F:	net/sched/act_bpf.c
 F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
+F:	scripts/pahole-version.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
diff --git a/Makefile b/Makefile
index e367784df9ba..ca432d4fdc7a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 95
+SUBLEVEL = 96
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 000000000000..437dab3fc017
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 000000000000..ad116b17850a
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc..27714dc2f04a 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@ usb1: usb@211000 {
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
@@ -659,3 +659,19 @@ L2_1: l2-cache-controller@c20000 {
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
index 6e4af4492a14..e92d39c0cd1d 100644
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -6,22 +6,10 @@
 #include <linux/elf.h>
 #include <linux/uaccess.h>
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 
-extern bool init_mem_is_free;
-
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (!init_mem_is_free)
-		return 0;
-
-	return addr >= (unsigned long)__init_begin &&
-		addr < (unsigned long)__init_end;
-}
-
 extern char __head_end[];
+extern char __srwx_boundary[];
 
 #ifdef __powerpc64__
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 1a63e37f336a..a664d0c4344a 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -32,6 +32,10 @@
 
 #define STRICT_ALIGN_SIZE	(1 << CONFIG_DATA_SHIFT)
 
+#if STRICT_ALIGN_SIZE < PAGE_SIZE
+#error "CONFIG_DATA_SHIFT must be >= PAGE_SHIFT"
+#endif
+
 ENTRY(_stext)
 
 PHDRS {
@@ -204,12 +208,16 @@ SECTIONS
 	}
 #endif
 
+	/*
+	 * Various code relies on __init_begin being at the strict RWX boundary.
+	 */
+	. = ALIGN(STRICT_ALIGN_SIZE);
+	__srwx_boundary = .;
+	__init_begin = .;
+
 /*
  * Init sections discarded at runtime
  */
-	. = ALIGN(STRICT_ALIGN_SIZE);
-	__init_begin = .;
-	. = ALIGN(PAGE_SIZE);
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
 		INIT_TEXT
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index bfca0afe9112..692c336e4f55 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -159,7 +159,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 {
 	unsigned long done;
-	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
+	unsigned long border = (unsigned long)__srwx_boundary - PAGE_OFFSET;
 	unsigned long size;
 
 	size = roundup_pow_of_two((unsigned long)_einittext - PAGE_OFFSET);
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index a339cb5de5dd..feb24313e2e3 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -232,6 +232,14 @@ void radix__mark_rodata_ro(void)
 	end = (unsigned long)__init_begin;
 
 	radix__change_memory_range(start, end, _PAGE_WRITE);
+
+	for (start = PAGE_OFFSET; start < (unsigned long)_stext; start += PAGE_SIZE) {
+		end = start + PAGE_SIZE;
+		if (overlaps_interrupt_vector_text(start, end))
+			radix__change_memory_range(start, end, _PAGE_WRITE);
+		else
+			break;
+	}
 }
 
 void radix__mark_initmem_nx(void)
@@ -260,8 +268,24 @@ print_mapping(unsigned long start, unsigned long end, unsigned long size, bool e
 static unsigned long next_boundary(unsigned long addr, unsigned long end)
 {
 #ifdef CONFIG_STRICT_KERNEL_RWX
-	if (addr < __pa_symbol(__init_begin))
-		return __pa_symbol(__init_begin);
+	unsigned long stext_phys;
+
+	stext_phys = __pa_symbol(_stext);
+
+	// Relocatable kernel running at non-zero real address
+	if (stext_phys != 0) {
+		// The end of interrupts code at zero is a rodata boundary
+		unsigned long end_intr = __pa_symbol(__end_interrupts) - stext_phys;
+		if (addr < end_intr)
+			return end_intr;
+
+		// Start of relocated kernel text is a rodata boundary
+		if (addr < stext_phys)
+			return stext_phys;
+	}
+
+	if (addr < __pa_symbol(__srwx_boundary))
+		return __pa_symbol(__srwx_boundary);
 #endif
 	return end;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c1a758038892..0611dac70c25 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3740,8 +3740,14 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+
+	/*
+	 * Note, the next RIP must be provided as SRCU isn't held, i.e. KVM
+	 * can't read guest memory (dereference memslots) to decode the WRMSR.
+	 */
+	if (control->exit_code == SVM_EXIT_MSR && control->exit_info_1 &&
+	    nrips && control->next_rip)
 		return handle_fastpath_set_msr_irqoff(vcpu);
 
 	return EXIT_FASTPATH_NONE;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cdebeceedbd0..f3c136548af6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4617,6 +4617,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
+	 * branch predictors when transitioning from L2 to L1, as L1 expects
+	 * hardware (KVM in this case) to provide separate predictor modes.
+	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
+	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
+	 * separate modes for L2 vs L1.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0718658268fe..c849173b60c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1332,8 +1332,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		/*
 		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * the active VMCS within a vCPU, unless IBRS is advertised to
+		 * the vCPU.  To minimize the number of IBPBs executed, KVM
+		 * performs IBPB on nested VM-Exit (a single nested transition
+		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75c8f66cce4f..0622256cd768 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8116,7 +8116,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 						  write_fault_to_spt,
 						  emulation_type))
 				return 1;
-			if (ctxt->have_exception) {
+
+			if (ctxt->have_exception &&
+			    !(emulation_type & EMULTYPE_SKIP)) {
 				/*
 				 * #UD should result in just EMULATION_FAILED, and trap-like
 				 * exception should not be encountered during decode.
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 00c6c03ff822..c8d33c5dbe29 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2269,16 +2269,266 @@ static int binder_translate_fd(u32 fd, binder_size_t fd_offset,
 	return ret;
 }
 
-static int binder_translate_fd_array(struct binder_fd_array_object *fda,
+/**
+ * struct binder_ptr_fixup - data to be fixed-up in target buffer
+ * @offset	offset in target buffer to fixup
+ * @skip_size	bytes to skip in copy (fixup will be written later)
+ * @fixup_data	data to write at fixup offset
+ * @node	list node
+ *
+ * This is used for the pointer fixup list (pf) which is created and consumed
+ * during binder_transaction() and is only accessed locally. No
+ * locking is necessary.
+ *
+ * The list is ordered by @offset.
+ */
+struct binder_ptr_fixup {
+	binder_size_t offset;
+	size_t skip_size;
+	binder_uintptr_t fixup_data;
+	struct list_head node;
+};
+
+/**
+ * struct binder_sg_copy - scatter-gather data to be copied
+ * @offset		offset in target buffer
+ * @sender_uaddr	user address in source buffer
+ * @length		bytes to copy
+ * @node		list node
+ *
+ * This is used for the sg copy list (sgc) which is created and consumed
+ * during binder_transaction() and is only accessed locally. No
+ * locking is necessary.
+ *
+ * The list is ordered by @offset.
+ */
+struct binder_sg_copy {
+	binder_size_t offset;
+	const void __user *sender_uaddr;
+	size_t length;
+	struct list_head node;
+};
+
+/**
+ * binder_do_deferred_txn_copies() - copy and fixup scatter-gather data
+ * @alloc:	binder_alloc associated with @buffer
+ * @buffer:	binder buffer in target process
+ * @sgc_head:	list_head of scatter-gather copy list
+ * @pf_head:	list_head of pointer fixup list
+ *
+ * Processes all elements of @sgc_head, applying fixups from @pf_head
+ * and copying the scatter-gather data from the source process' user
+ * buffer to the target's buffer. It is expected that the list creation
+ * and processing all occurs during binder_transaction() so these lists
+ * are only accessed in local context.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_do_deferred_txn_copies(struct binder_alloc *alloc,
+					 struct binder_buffer *buffer,
+					 struct list_head *sgc_head,
+					 struct list_head *pf_head)
+{
+	int ret = 0;
+	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *tmppf;
+	struct binder_ptr_fixup *pf =
+		list_first_entry_or_null(pf_head, struct binder_ptr_fixup,
+					 node);
+
+	list_for_each_entry_safe(sgc, tmpsgc, sgc_head, node) {
+		size_t bytes_copied = 0;
+
+		while (bytes_copied < sgc->length) {
+			size_t copy_size;
+			size_t bytes_left = sgc->length - bytes_copied;
+			size_t offset = sgc->offset + bytes_copied;
+
+			/*
+			 * We copy up to the fixup (pointed to by pf)
+			 */
+			copy_size = pf ? min(bytes_left, (size_t)pf->offset - offset)
+				       : bytes_left;
+			if (!ret && copy_size)
+				ret = binder_alloc_copy_user_to_buffer(
+						alloc, buffer,
+						offset,
+						sgc->sender_uaddr + bytes_copied,
+						copy_size);
+			bytes_copied += copy_size;
+			if (copy_size != bytes_left) {
+				BUG_ON(!pf);
+				/* we stopped at a fixup offset */
+				if (pf->skip_size) {
+					/*
+					 * we are just skipping. This is for
+					 * BINDER_TYPE_FDA where the translated
+					 * fds will be fixed up when we get
+					 * to target context.
+					 */
+					bytes_copied += pf->skip_size;
+				} else {
+					/* apply the fixup indicated by pf */
+					if (!ret)
+						ret = binder_alloc_copy_to_buffer(
+							alloc, buffer,
+							pf->offset,
+							&pf->fixup_data,
+							sizeof(pf->fixup_data));
+					bytes_copied += sizeof(pf->fixup_data);
+				}
+				list_del(&pf->node);
+				kfree(pf);
+				pf = list_first_entry_or_null(pf_head,
+						struct binder_ptr_fixup, node);
+			}
+		}
+		list_del(&sgc->node);
+		kfree(sgc);
+	}
+	list_for_each_entry_safe(pf, tmppf, pf_head, node) {
+		BUG_ON(pf->skip_size == 0);
+		list_del(&pf->node);
+		kfree(pf);
+	}
+	BUG_ON(!list_empty(sgc_head));
+
+	return ret > 0 ? -EINVAL : ret;
+}
+
+/**
+ * binder_cleanup_deferred_txn_lists() - free specified lists
+ * @sgc_head:	list_head of scatter-gather copy list
+ * @pf_head:	list_head of pointer fixup list
+ *
+ * Called to clean up @sgc_head and @pf_head if there is an
+ * error.
+ */
+static void binder_cleanup_deferred_txn_lists(struct list_head *sgc_head,
+					      struct list_head *pf_head)
+{
+	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *pf, *tmppf;
+
+	list_for_each_entry_safe(sgc, tmpsgc, sgc_head, node) {
+		list_del(&sgc->node);
+		kfree(sgc);
+	}
+	list_for_each_entry_safe(pf, tmppf, pf_head, node) {
+		list_del(&pf->node);
+		kfree(pf);
+	}
+}
+
+/**
+ * binder_defer_copy() - queue a scatter-gather buffer for copy
+ * @sgc_head:		list_head of scatter-gather copy list
+ * @offset:		binder buffer offset in target process
+ * @sender_uaddr:	user address in source process
+ * @length:		bytes to copy
+ *
+ * Specify a scatter-gather block to be copied. The actual copy must
+ * be deferred until all the needed fixups are identified and queued.
+ * Then the copy and fixups are done together so un-translated values
+ * from the source are never visible in the target buffer.
+ *
+ * We are guaranteed that repeated calls to this function will have
+ * monotonically increasing @offset values so the list will naturally
+ * be ordered.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_defer_copy(struct list_head *sgc_head, binder_size_t offset,
+			     const void __user *sender_uaddr, size_t length)
+{
+	struct binder_sg_copy *bc = kzalloc(sizeof(*bc), GFP_KERNEL);
+
+	if (!bc)
+		return -ENOMEM;
+
+	bc->offset = offset;
+	bc->sender_uaddr = sender_uaddr;
+	bc->length = length;
+	INIT_LIST_HEAD(&bc->node);
+
+	/*
+	 * We are guaranteed that the deferred copies are in-order
+	 * so just add to the tail.
+	 */
+	list_add_tail(&bc->node, sgc_head);
+
+	return 0;
+}
+
+/**
+ * binder_add_fixup() - queue a fixup to be applied to sg copy
+ * @pf_head:	list_head of binder ptr fixup list
+ * @offset:	binder buffer offset in target process
+ * @fixup:	bytes to be copied for fixup
+ * @skip_size:	bytes to skip when copying (fixup will be applied later)
+ *
+ * Add the specified fixup to a list ordered by @offset. When copying
+ * the scatter-gather buffers, the fixup will be copied instead of
+ * data from the source buffer. For BINDER_TYPE_FDA fixups, the fixup
+ * will be applied later (in target process context), so we just skip
+ * the bytes specified by @skip_size. If @skip_size is 0, we copy the
+ * value in @fixup.
+ *
+ * This function is called *mostly* in @offset order, but there are
+ * exceptions. Since out-of-order inserts are relatively uncommon,
+ * we insert the new element by searching backward from the tail of
+ * the list.
+ *
+ * Return: 0=success, else -errno
+ */
+static int binder_add_fixup(struct list_head *pf_head, binder_size_t offset,
+			    binder_uintptr_t fixup, size_t skip_size)
+{
+	struct binder_ptr_fixup *pf = kzalloc(sizeof(*pf), GFP_KERNEL);
+	struct binder_ptr_fixup *tmppf;
+
+	if (!pf)
+		return -ENOMEM;
+
+	pf->offset = offset;
+	pf->fixup_data = fixup;
+	pf->skip_size = skip_size;
+	INIT_LIST_HEAD(&pf->node);
+
+	/* Fixups are *mostly* added in-order, but there are some
+	 * exceptions. Look backwards through list for insertion point.
+	 */
+	list_for_each_entry_reverse(tmppf, pf_head, node) {
+		if (tmppf->offset < pf->offset) {
+			list_add(&pf->node, &tmppf->node);
+			return 0;
+		}
+	}
+	/*
+	 * if we get here, then the new offset is the lowest so
+	 * insert at the head
+	 */
+	list_add(&pf->node, pf_head);
+	return 0;
+}
+
+static int binder_translate_fd_array(struct list_head *pf_head,
+				     struct binder_fd_array_object *fda,
+				     const void __user *sender_ubuffer,
 				     struct binder_buffer_object *parent,
+				     struct binder_buffer_object *sender_uparent,
 				     struct binder_transaction *t,
 				     struct binder_thread *thread,
 				     struct binder_transaction *in_reply_to)
 {
 	binder_size_t fdi, fd_buf_size;
 	binder_size_t fda_offset;
+	const void __user *sender_ufda_base;
 	struct binder_proc *proc = thread->proc;
-	struct binder_proc *target_proc = t->to_proc;
+	int ret;
+
+	if (fda->num_fds == 0)
+		return 0;
 
 	fd_buf_size = sizeof(u32) * fda->num_fds;
 	if (fda->num_fds >= SIZE_MAX / sizeof(u32)) {
@@ -2302,19 +2552,25 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32))) {
+	sender_ufda_base = (void __user *)(uintptr_t)sender_uparent->buffer +
+				fda->parent_offset;
+
+	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
+	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {
 		binder_user_error("%d:%d parent offset not aligned correctly.\n",
 				  proc->pid, thread->pid);
 		return -EINVAL;
 	}
+	ret = binder_add_fixup(pf_head, fda_offset, 0, fda->num_fds * sizeof(u32));
+	if (ret)
+		return ret;
+
 	for (fdi = 0; fdi < fda->num_fds; fdi++) {
 		u32 fd;
-		int ret;
 		binder_size_t offset = fda_offset + fdi * sizeof(fd);
+		binder_size_t sender_uoffset = fdi * sizeof(fd);
 
-		ret = binder_alloc_copy_from_buffer(&target_proc->alloc,
-						    &fd, t->buffer,
-						    offset, sizeof(fd));
+		ret = copy_from_user(&fd, sender_ufda_base + sender_uoffset, sizeof(fd));
 		if (!ret)
 			ret = binder_translate_fd(fd, offset, t, thread,
 						  in_reply_to);
@@ -2324,7 +2580,8 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 	return 0;
 }
 
-static int binder_fixup_parent(struct binder_transaction *t,
+static int binder_fixup_parent(struct list_head *pf_head,
+			       struct binder_transaction *t,
 			       struct binder_thread *thread,
 			       struct binder_buffer_object *bp,
 			       binder_size_t off_start_offset,
@@ -2370,14 +2627,7 @@ static int binder_fixup_parent(struct binder_transaction *t,
 	}
 	buffer_offset = bp->parent_offset +
 			(uintptr_t)parent->buffer - (uintptr_t)b->user_data;
-	if (binder_alloc_copy_to_buffer(&target_proc->alloc, b, buffer_offset,
-					&bp->buffer, sizeof(bp->buffer))) {
-		binder_user_error("%d:%d got transaction with invalid parent offset\n",
-				  proc->pid, thread->pid);
-		return -EINVAL;
-	}
-
-	return 0;
+	return binder_add_fixup(pf_head, buffer_offset, bp->buffer, 0);
 }
 
 /**
@@ -2519,8 +2769,12 @@ static void binder_transaction(struct binder_proc *proc,
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	char *secctx = NULL;
 	u32 secctx_sz = 0;
+	struct list_head sgc_head;
+	struct list_head pf_head;
 	const void __user *user_buffer = (const void __user *)
 				(uintptr_t)tr->data.ptr.buffer;
+	INIT_LIST_HEAD(&sgc_head);
+	INIT_LIST_HEAD(&pf_head);
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;
@@ -2987,6 +3241,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_FDA: {
 			struct binder_object ptr_object;
 			binder_size_t parent_offset;
+			struct binder_object user_object;
+			size_t user_parent_size;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
 			size_t num_valid = (buffer_offset - off_start_offset) /
@@ -3018,8 +3274,27 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error_line = __LINE__;
 				goto err_bad_parent;
 			}
-			ret = binder_translate_fd_array(fda, parent, t, thread,
-							in_reply_to);
+			/*
+			 * We need to read the user version of the parent
+			 * object to get the original user offset
+			 */
+			user_parent_size =
+				binder_get_object(proc, user_buffer, t->buffer,
+						  parent_offset, &user_object);
+			if (user_parent_size != sizeof(user_object.bbo)) {
+				binder_user_error("%d:%d invalid ptr object size: %zd vs %zd\n",
+						  proc->pid, thread->pid,
+						  user_parent_size,
+						  sizeof(user_object.bbo));
+				return_error = BR_FAILED_REPLY;
+				return_error_param = -EINVAL;
+				return_error_line = __LINE__;
+				goto err_bad_parent;
+			}
+			ret = binder_translate_fd_array(&pf_head, fda,
+							user_buffer, parent,
+							&user_object.bbo, t,
+							thread, in_reply_to);
 			if (!ret)
 				ret = binder_alloc_copy_to_buffer(&target_proc->alloc,
 								  t->buffer,
@@ -3049,19 +3324,14 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error_line = __LINE__;
 				goto err_bad_offset;
 			}
-			if (binder_alloc_copy_user_to_buffer(
-						&target_proc->alloc,
-						t->buffer,
-						sg_buf_offset,
-						(const void __user *)
-							(uintptr_t)bp->buffer,
-						bp->length)) {
-				binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
-						  proc->pid, thread->pid);
-				return_error_param = -EFAULT;
+			ret = binder_defer_copy(&sgc_head, sg_buf_offset,
+				(const void __user *)(uintptr_t)bp->buffer,
+				bp->length);
+			if (ret) {
 				return_error = BR_FAILED_REPLY;
+				return_error_param = ret;
 				return_error_line = __LINE__;
-				goto err_copy_data_failed;
+				goto err_translate_failed;
 			}
 			/* Fixup buffer pointer to target proc address space */
 			bp->buffer = (uintptr_t)
@@ -3070,7 +3340,8 @@ static void binder_transaction(struct binder_proc *proc,
 
 			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
-			ret = binder_fixup_parent(t, thread, bp,
+			ret = binder_fixup_parent(&pf_head, t,
+						  thread, bp,
 						  off_start_offset,
 						  num_valid,
 						  last_fixup_obj_off,
@@ -3110,6 +3381,17 @@ static void binder_transaction(struct binder_proc *proc,
 		return_error_line = __LINE__;
 		goto err_copy_data_failed;
 	}
+
+	ret = binder_do_deferred_txn_copies(&target_proc->alloc, t->buffer,
+					    &sgc_head, &pf_head);
+	if (ret) {
+		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
+				  proc->pid, thread->pid);
+		return_error = BR_FAILED_REPLY;
+		return_error_param = ret;
+		return_error_line = __LINE__;
+		goto err_copy_data_failed;
+	}
 	if (t->buffer->oneway_spam_suspect)
 		tcomplete->type = BINDER_WORK_TRANSACTION_ONEWAY_SPAM_SUSPECT;
 	else
@@ -3183,6 +3465,7 @@ static void binder_transaction(struct binder_proc *proc,
 err_bad_offset:
 err_bad_parent:
 err_copy_data_failed:
+	binder_cleanup_deferred_txn_lists(&sgc_head, &pf_head);
 	binder_free_txn_fixups(t);
 	trace_binder_transaction_failed_buffer_release(t->buffer);
 	binder_transaction_buffer_release(target_proc, NULL, t->buffer,
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index ec2b5dd2ce4a..c1ef1df42eb6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1756,17 +1756,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	refcount_set(&nbd->refs, 0);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
-
-	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since index << part_shift might overflow, or
-	 * MKDEV() expect that the max bits of first_minor is 20.
-	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
-		err = -EINVAL;
-		goto out_free_work;
-	}
-
 	disk->minors = 1 << part_shift;
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
@@ -1871,8 +1861,19 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (info->attrs[NBD_ATTR_INDEX])
+	if (info->attrs[NBD_ATTR_INDEX]) {
 		index = nla_get_u32(info->attrs[NBD_ATTR_INDEX]);
+
+		/*
+		 * Too big first_minor can cause duplicate creation of
+		 * sysfs files/links, since index << part_shift might overflow, or
+		 * MKDEV() expect that the max bits of first_minor is 20.
+		 */
+		if (index < 0 || index > MINORMASK >> part_shift) {
+			printk(KERN_ERR "nbd: illegal input index %d\n", index);
+			return -EINVAL;
+		}
+	}
 	if (!info->attrs[NBD_ATTR_SOCKETS]) {
 		printk(KERN_ERR "nbd: must specify at least one socket\n");
 		return -EINVAL;
diff --git a/drivers/clk/x86/Kconfig b/drivers/clk/x86/Kconfig
index 69642e15fcc1..ced99e082e3d 100644
--- a/drivers/clk/x86/Kconfig
+++ b/drivers/clk/x86/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CLK_LGM_CGU
 	depends on OF && HAS_IOMEM && (X86 || COMPILE_TEST)
+	select MFD_SYSCON
 	select OF_EARLY_FLATTREE
 	bool "Clock driver for Lightning Mountain(LGM) platform"
 	help
-	  Clock Generation Unit(CGU) driver for Intel Lightning Mountain(LGM)
-	  network processor SoC.
+	  Clock Generation Unit(CGU) driver for MaxLinear's x86 based
+	  Lightning Mountain(LGM) network processor SoC.
diff --git a/drivers/clk/x86/clk-cgu-pll.c b/drivers/clk/x86/clk-cgu-pll.c
index 3179557b5f78..409dbf55f4ca 100644
--- a/drivers/clk/x86/clk-cgu-pll.c
+++ b/drivers/clk/x86/clk-cgu-pll.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #include <linux/clk-provider.h>
@@ -40,13 +41,10 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
 	unsigned int div, mult, frac;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	mult = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 0, 12);
 	div = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 18, 6);
 	frac = lgm_get_clk_val(pll->membase, pll->reg, 2, 24);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	if (pll->type == TYPE_LJPLL)
 		div *= 4;
@@ -57,12 +55,9 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 static int lgm_pll_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	ret = lgm_get_clk_val(pll->membase, pll->reg, 0, 1);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	return ret;
 }
@@ -70,15 +65,13 @@ static int lgm_pll_is_enabled(struct clk_hw *hw)
 static int lgm_pll_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	u32 val;
 	int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 1);
-	ret = readl_poll_timeout_atomic(pll->membase + pll->reg,
-					val, (val & 0x1), 1, 100);
-	spin_unlock_irqrestore(&pll->lock, flags);
+	ret = regmap_read_poll_timeout_atomic(pll->membase, pll->reg,
+					      val, (val & 0x1), 1, 100);
+
 
 	return ret;
 }
@@ -86,11 +79,8 @@ static int lgm_pll_enable(struct clk_hw *hw)
 static void lgm_pll_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 0);
-	spin_unlock_irqrestore(&pll->lock, flags);
 }
 
 static const struct clk_ops lgm_pll_ops = {
@@ -121,7 +111,6 @@ lgm_clk_register_pll(struct lgm_clk_provider *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	pll->membase = ctx->membase;
-	pll->lock = ctx->lock;
 	pll->reg = list->reg;
 	pll->flags = list->flags;
 	pll->type = list->type;
diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 33de600e0c38..89b53f280aee 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -24,14 +25,10 @@
 static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 					     const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return clk_hw_register_fixed_rate(NULL, list->name,
 					  list->parent_data[0].name,
@@ -41,33 +38,27 @@ static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 static u8 lgm_clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		val = mux->reg;
 	else
 		val = lgm_get_clk_val(mux->membase, mux->reg, mux->shift,
 				      mux->width);
-	spin_unlock_irqrestore(&mux->lock, flags);
 	return clk_mux_val_to_index(hw, NULL, mux->flags, val);
 }
 
 static int lgm_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
 	val = clk_mux_index_to_val(NULL, mux->flags, index);
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		mux->reg = val;
 	else
 		lgm_set_clk_val(mux->membase, mux->reg, mux->shift,
 				mux->width, val);
-	spin_unlock_irqrestore(&mux->lock, flags);
 
 	return 0;
 }
@@ -90,7 +81,7 @@ static struct clk_hw *
 lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 		     const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->mux_flags;
+	unsigned long cflags = list->mux_flags;
 	struct device *dev = ctx->dev;
 	u8 shift = list->mux_shift;
 	u8 width = list->mux_width;
@@ -111,7 +102,6 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	init.num_parents = list->num_parents;
 
 	mux->membase = ctx->membase;
-	mux->lock = ctx->lock;
 	mux->reg = reg;
 	mux->shift = shift;
 	mux->width = width;
@@ -123,11 +113,8 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&mux->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(mux->membase, reg, shift, width, list->mux_val);
-		spin_unlock_irqrestore(&mux->lock, flags);
-	}
 
 	return hw;
 }
@@ -136,13 +123,10 @@ static unsigned long
 lgm_clk_divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	unsigned int val;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	val = lgm_get_clk_val(divider->membase, divider->reg,
 			      divider->shift, divider->width);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return divider_recalc_rate(hw, parent_rate, val, divider->table,
 				   divider->flags, divider->width);
@@ -163,7 +147,6 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 			 unsigned long prate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	int value;
 
 	value = divider_get_val(rate, prate, divider->table,
@@ -171,10 +154,8 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (value < 0)
 		return value;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	lgm_set_clk_val(divider->membase, divider->reg,
 			divider->shift, divider->width, value);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return 0;
 }
@@ -182,12 +163,10 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 static int lgm_clk_divider_enable_disable(struct clk_hw *hw, int enable)
 {
 	struct lgm_clk_divider *div = to_lgm_clk_divider(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&div->lock, flags);
-	lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
-			div->width_gate, enable);
-	spin_unlock_irqrestore(&div->lock, flags);
+	if (div->flags != DIV_CLK_NO_MASK)
+		lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
+				div->width_gate, enable);
 	return 0;
 }
 
@@ -213,7 +192,7 @@ static struct clk_hw *
 lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 			 const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->div_flags;
+	unsigned long cflags = list->div_flags;
 	struct device *dev = ctx->dev;
 	struct lgm_clk_divider *div;
 	struct clk_init_data init = {};
@@ -236,7 +215,6 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	init.num_parents = 1;
 
 	div->membase = ctx->membase;
-	div->lock = ctx->lock;
 	div->reg = reg;
 	div->shift = shift;
 	div->width = width;
@@ -251,11 +229,8 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&div->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(div->membase, reg, shift, width, list->div_val);
-		spin_unlock_irqrestore(&div->lock, flags);
-	}
 
 	return hw;
 }
@@ -264,7 +239,6 @@ static struct clk_hw *
 lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 	struct clk_hw *hw;
 
 	hw = clk_hw_register_fixed_factor(ctx->dev, list->name,
@@ -273,12 +247,9 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 	if (IS_ERR(hw))
 		return ERR_CAST(hw);
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return hw;
 }
@@ -286,13 +257,10 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 static int lgm_clk_gate_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_EN(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return 0;
 }
@@ -300,25 +268,19 @@ static int lgm_clk_gate_enable(struct clk_hw *hw)
 static void lgm_clk_gate_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_DIS(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 }
 
 static int lgm_clk_gate_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
 	unsigned int reg, ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_STAT(gate->reg);
 	ret = lgm_get_clk_val(gate->membase, reg, gate->shift, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return ret;
 }
@@ -333,7 +295,7 @@ static struct clk_hw *
 lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		      const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->gate_flags;
+	unsigned long cflags = list->gate_flags;
 	const char *pname = list->parent_data[0].name;
 	struct device *dev = ctx->dev;
 	u8 shift = list->gate_shift;
@@ -354,7 +316,6 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 	init.num_parents = pname ? 1 : 0;
 
 	gate->membase = ctx->membase;
-	gate->lock = ctx->lock;
 	gate->reg = reg;
 	gate->shift = shift;
 	gate->flags = cflags;
@@ -366,9 +327,7 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		return ERR_PTR(ret);
 
 	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&gate->lock, flags);
 		lgm_set_clk_val(gate->membase, reg, shift, 1, list->gate_val);
-		spin_unlock_irqrestore(&gate->lock, flags);
 	}
 
 	return hw;
@@ -396,8 +355,22 @@ int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			hw = lgm_clk_register_fixed_factor(ctx, list);
 			break;
 		case CLK_TYPE_GATE:
-			hw = lgm_clk_register_gate(ctx, list);
+			if (list->gate_flags & GATE_CLK_HW) {
+				hw = lgm_clk_register_gate(ctx, list);
+			} else {
+				/*
+				 * GATE_CLKs can be controlled either from
+				 * CGU clk driver i.e. this driver or directly
+				 * from power management driver/daemon. It is
+				 * dependent on the power policy/profile requirements
+				 * of the end product. To override control of gate
+				 * clks from this driver, provide NULL for this index
+				 * of gate clk provider.
+				 */
+				hw = NULL;
+			}
 			break;
+
 		default:
 			dev_err(ctx->dev, "invalid clk type\n");
 			return -EINVAL;
@@ -443,24 +416,18 @@ lgm_clk_ddiv_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 static int lgm_clk_ddiv_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 	return 0;
 }
 
 static void lgm_clk_ddiv_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 0);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 }
 
 static int
@@ -497,32 +464,25 @@ lgm_clk_ddiv_set_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)prate, rate);
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 		div = div * 2;
 	}
 
-	if (div <= 0) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (div <= 0)
 		return -EINVAL;
-	}
 
-	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2)) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2))
 		return -EINVAL;
-	}
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift0, ddiv->width0,
 			ddiv1 - 1);
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg,  ddiv->shift1, ddiv->width1,
 			ddiv2 - 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return 0;
 }
@@ -533,18 +493,15 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 	u64 rate64;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)*prate, rate);
 
 	/* if predivide bit is enabled, modify div by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = div * 2;
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	if (div <= 0)
 		return *prate;
@@ -558,12 +515,10 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 	do_div(rate64, ddiv2);
 
 	/* if predivide bit is enabled, modify rounded rate by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		rate64 = rate64 * 2;
 		rate64 = DIV_ROUND_CLOSEST_ULL(rate64, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return rate64;
 }
@@ -600,7 +555,6 @@ int lgm_clk_register_ddiv(struct lgm_clk_provider *ctx,
 		init.num_parents = 1;
 
 		ddiv->membase = ctx->membase;
-		ddiv->lock = ctx->lock;
 		ddiv->reg = list->reg;
 		ddiv->shift0 = list->shift0;
 		ddiv->width0 = list->width0;
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 4e22bfb22312..bcaf8aec94e5 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -1,28 +1,28 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright(c) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
+ * Copyright (C) 2020 Intel Corporation.
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #ifndef __CLK_CGU_H
 #define __CLK_CGU_H
 
-#include <linux/io.h>
+#include <linux/regmap.h>
 
 struct lgm_clk_mux {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_divider {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
@@ -30,12 +30,11 @@ struct lgm_clk_divider {
 	u8 width_gate;
 	unsigned long flags;
 	const struct clk_div_table *table;
-	spinlock_t lock;
 };
 
 struct lgm_clk_ddiv {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift0;
 	u8 width0;
@@ -48,16 +47,14 @@ struct lgm_clk_ddiv {
 	unsigned int mult;
 	unsigned int div;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_gate {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 enum lgm_clk_type {
@@ -77,11 +74,10 @@ enum lgm_clk_type {
  * @clk_data: array of hw clocks and clk number.
  */
 struct lgm_clk_provider {
-	void __iomem *membase;
+	struct regmap *membase;
 	struct device_node *np;
 	struct device *dev;
 	struct clk_hw_onecell_data clk_data;
-	spinlock_t lock;
 };
 
 enum pll_type {
@@ -92,11 +88,10 @@ enum pll_type {
 
 struct lgm_clk_pll {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	unsigned long flags;
 	enum pll_type type;
-	spinlock_t lock;
 };
 
 /**
@@ -202,6 +197,8 @@ struct lgm_clk_branch {
 /* clock flags definition */
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
+#define GATE_CLK_HW		BIT(18)
+#define DIV_CLK_NO_MASK		BIT(19)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
@@ -300,29 +297,32 @@ struct lgm_clk_branch {
 		.div = _d,					\
 	}
 
-static inline void lgm_set_clk_val(void __iomem *membase, u32 reg,
+static inline void lgm_set_clk_val(struct regmap *membase, u32 reg,
 				   u8 shift, u8 width, u32 set_val)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
-	u32 regval;
 
-	regval = readl(membase + reg);
-	regval = (regval & ~mask) | ((set_val << shift) & mask);
-	writel(regval, membase + reg);
+	regmap_update_bits(membase, reg, mask, set_val << shift);
 }
 
-static inline u32 lgm_get_clk_val(void __iomem *membase, u32 reg,
+static inline u32 lgm_get_clk_val(struct regmap *membase, u32 reg,
 				  u8 shift, u8 width)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
 	u32 val;
 
-	val = readl(membase + reg);
+	if (regmap_read(membase, reg, &val)) {
+		WARN_ONCE(1, "Failed to read clk reg: 0x%x\n", reg);
+		return 0;
+	}
+
 	val = (val & mask) >> shift;
 
 	return val;
 }
 
+
+
 int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list,
 			      unsigned int nr_clk);
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 020f4e83a5cc..f69455dd1c98 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -1,10 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
+#include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <dt-bindings/clock/intel,lgm-clk.h>
@@ -253,8 +255,8 @@ static const struct lgm_clk_branch lgm_branch_clks[] = {
 	LGM_FIXED(LGM_CLK_SLIC, "slic", NULL, 0, CGU_IF_CLK1,
 		  8, 2, CLOCK_FLAG_VAL_INIT, 8192000, 2),
 	LGM_FIXED(LGM_CLK_DOCSIS, "v_docsis", NULL, 0, 0, 0, 0, 0, 16000000, 0),
-	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", 0, CGU_PCMCR,
-		25, 3, 0, 0, 0, 0, dcl_div),
+	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", CLK_SET_RATE_PARENT, CGU_PCMCR,
+		25, 3, 0, 0, DIV_CLK_NO_MASK, 0, dcl_div),
 	LGM_MUX(LGM_CLK_PCM, "pcm", pcm_p, 0, CGU_C55_PCMCR,
 		0, 1, CLK_MUX_ROUND_CLOSEST, 0),
 	LGM_FIXED_FACTOR(LGM_CLK_DDR_PHY, "ddr_phy", "ddr",
@@ -433,13 +435,15 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 
 	ctx->clk_data.num = CLK_NR_CLKS;
 
-	ctx->membase = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ctx->membase))
+	ctx->membase = syscon_node_to_regmap(np);
+	if (IS_ERR(ctx->membase)) {
+		dev_err(dev, "Failed to get clk CGU iomem\n");
 		return PTR_ERR(ctx->membase);
+	}
+
 
 	ctx->np = np;
 	ctx->dev = dev;
-	spin_lock_init(&ctx->lock);
 
 	ret = lgm_clk_register_plls(ctx, lgm_pll_clks,
 				    ARRAY_SIZE(lgm_pll_clks));
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 6ab048ba8021..d940c76419c5 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4942,7 +4942,8 @@ static void drm_parse_hdmi_forum_vsdb(struct drm_connector *connector,
 			else if (hf_vsdb[11] & DRM_EDID_DSC_10BPC)
 				hdmi_dsc->bpc_supported = 10;
 			else
-				hdmi_dsc->bpc_supported = 0;
+				/* Supports min 8 BPC if DSC 1.2 is supported*/
+				hdmi_dsc->bpc_supported = 8;
 
 			dsc_max_frl_rate = (hf_vsdb[12] & DRM_EDID_DSC_MAX_FRL_RATE_MASK) >> 4;
 			drm_get_max_frl_rate(dsc_max_frl_rate, &hdmi_dsc->max_lanes,
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index aabb997a74eb..2de806173b3a 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -80,10 +80,10 @@ static int etnaviv_iommu_map(struct etnaviv_iommu_context *context, u32 iova,
 		return -EINVAL;
 
 	for_each_sgtable_dma_sg(sgt, sg, i) {
-		u32 pa = sg_dma_address(sg) - sg->offset;
+		phys_addr_t pa = sg_dma_address(sg) - sg->offset;
 		size_t bytes = sg_dma_len(sg) + sg->offset;
 
-		VERB("map[%d]: %08x %08x(%zx)", i, iova, pa, bytes);
+		VERB("map[%d]: %08x %pap(%zx)", i, iova, &pa, bytes);
 
 		ret = etnaviv_context_map(context, da, pa, bytes, prot);
 		if (ret)
diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index e5c2fdfc20e3..7ea7abef6143 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1195,10 +1195,8 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_hypervisor_dma_map_guest_page(vgpu,
 				start_gfn + sub_index, PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1217,6 +1215,17 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 6cc65bf28d03..562105b8a632 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -545,6 +545,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 					    u8 cmd_no, int channel)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -552,6 +553,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	if (channel < 0) {
 		kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -568,7 +570,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -584,6 +586,7 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 {
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
@@ -591,14 +594,14 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd_async(priv, cmd,
-					kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd_async(priv, cmd, cmd_len);
 	if (err)
 		kfree(cmd);
 
@@ -742,6 +745,7 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	u32 value = 0;
 	u32 mask = 0;
 	u16 cap_cmd_res;
@@ -753,13 +757,14 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_CAPABILITIES_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->cap_req.cap_cmd = cpu_to_le16(cap_cmd_req);
 
 	kvaser_usb_hydra_set_cmd_dest_he(cmd, card_data->hydra.sysdbg_he);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1582,6 +1587,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_usb_net_hydra_priv *hydra = priv->sub_priv;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if (!hydra)
@@ -1592,6 +1598,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1601,7 +1608,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 
 	reinit_completion(&priv->get_busparams_comp);
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		return err;
 
@@ -1628,6 +1635,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1635,6 +1643,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_nominal, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_nominal));
 
@@ -1643,7 +1652,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1656,6 +1665,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1663,6 +1673,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_data, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_data));
 
@@ -1680,7 +1691,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1808,6 +1819,7 @@ static int kvaser_usb_hydra_get_software_info(struct kvaser_usb *dev)
 static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 	u32 flags;
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
@@ -1817,6 +1829,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_SOFTWARE_DETAILS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->sw_detail_req.use_ext_cmd = 1;
 	kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -1824,7 +1837,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1942,6 +1955,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if ((priv->can.ctrlmode &
@@ -1957,6 +1971,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_DRIVERMODE_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1966,7 +1981,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	else
 		cmd->set_ctrlmode.mode = KVASER_USB_HYDRA_CTRLMODE_NORMAL;
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	kfree(cmd);
 
 	return err;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bde9e4bbfffe..7fb6eef40928 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -485,6 +485,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7370d92a3bda..3d3fa2b616a8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4369,12 +4369,9 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
-#ifdef RTL8XXXU_GEN2_REPORT_CONNECT
 	/*
-	 * Barry Day reports this causes issues with 8192eu and 8723bu
-	 * devices reconnecting. The reason for this is unclear, but
-	 * until it is better understood, leave the code in place but
-	 * disabled, so it is not lost.
+	 * The firmware turns on the rate control when it knows it's
+	 * connected to a network.
 	 */
 	struct h2c_cmd h2c;
 
@@ -4387,7 +4384,6 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 2314f7446592..aa07b78ba910 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -489,6 +489,11 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -503,7 +508,7 @@ static struct kobj_type ext4_sb_ktype = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_groups = ext4_feat_groups,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index c1e79f72cd89..9f0af4f116d9 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -11,6 +11,10 @@
 
 struct task_struct;
 
+#ifndef barrier_nospec
+# define barrier_nospec() do { } while (0)
+#endif
+
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
diff --git a/include/linux/random.h b/include/linux/random.h
index 3feafab498ad..ed75fb2b0ca9 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,14 +19,14 @@ void add_input_randomness(unsigned int type, unsigned int code,
 void add_interrupt_randomness(int irq) __latent_entropy;
 void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
-#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
+#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
-}
 #else
-static inline void add_latent_entropy(void) { }
+	add_device_randomness(NULL, 0);
 #endif
+}
 
 void get_random_bytes(void *buf, size_t len);
 size_t __must_check get_random_bytes_arch(void *buf, size_t len);
diff --git a/init/Kconfig b/init/Kconfig
index a4144393717b..dafc3ba6fa7a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -91,6 +91,10 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config PAHOLE_VERSION
+	int
+	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
+
 config CONSTRUCTORS
 	bool
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 4ce500eac2ef..cea0d1296599 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/extable.h>
 #include <linux/log2.h>
+#include <linux/nospec.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -1648,9 +1649,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		 * reuse preexisting logic from Spectre v1 mitigation that
 		 * happens to produce the required code on x86 for v4 as well.
 		 */
-#ifdef CONFIG_X86
 		barrier_nospec();
-#endif
 		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f71db0cc3bf1..dbbd243c865f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -302,7 +302,7 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
-	depends on !DEBUG_INFO_BTF
+	depends on !DEBUG_INFO_BTF || PAHOLE_VERSION >= 121
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
@@ -328,7 +328,7 @@ config DEBUG_INFO_BTF
 	  DWARF type info into equivalent deduplicated BTF type info.
 
 config PAHOLE_HAS_SPLIT_BTF
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
+	def_bool PAHOLE_VERSION >= 119
 
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 7413dd300516..7ee63df042d7 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -3,6 +3,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/instrumented.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 /* out-of-line parts */
 
@@ -12,6 +13,12 @@ unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n
 	unsigned long res = n;
 	might_fault();
 	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
 		instrument_copy_from_user(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 	}
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 135ea8b3816f..e203deacc953 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1950,14 +1950,12 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	unsigned int ntx = cl - 1;
+	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 
-	if (ntx >= dev->num_tx_queues)
+	if (!dev_queue)
 		return NULL;
 
-	return q->qdiscs[ntx];
+	return dev_queue->qdisc_sleeping;
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
index 7acee326aa6c..d38fa6d84d62 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -7,7 +7,7 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
 	exit 0
 fi
 
-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+pahole_ver=$($(dirname $0)/pahole-version.sh ${PAHOLE})
 
 if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
diff --git a/scripts/pahole-version.sh b/scripts/pahole-version.sh
new file mode 100755
index 000000000000..f8a32ab93ad1
--- /dev/null
+++ b/scripts/pahole-version.sh
@@ -0,0 +1,13 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Usage: $ ./pahole-version.sh pahole
+#
+# Prints pahole's version in a 3-digit form, such as 119 for v1.19.
+
+if [ ! -x "$(command -v "$@")" ]; then
+	echo 0
+	exit 1
+fi
+
+"$@" --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'
