Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174F5424D1E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 08:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbhJGGPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 02:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240223AbhJGGPK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 02:15:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 096AC611AE;
        Thu,  7 Oct 2021 06:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633587197;
        bh=O8R5+xfUOVso1Qc7C8IvlyE29lmnA+craaeGWw0VqKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRylE7OalwNi1UXzrhvSVAo1ARUkinIM9M9LlcJ38hQjUl6vrzp6zjPZo76o0v6LK
         rVSnmASXv9xeWt6pwEp/w9AT++w9Yo+4Qp/qw+oLAlrGOeh1vzCLysu+wO7G8/aV0z
         6//XlH5T2OofVDdXlkrrkh7bUj2aBl2lE7DNcI7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.14.10
Date:   Thu,  7 Oct 2021 08:13:06 +0200
Message-Id: <1633587185198130@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163358718522341@kroah.com>
References: <163358718522341@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 50c17e63c54e..9f99a61d2589 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 14
-SUBLEVEL = 9
+SUBLEVEL = 10
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 9dd76fbb7c6b..ff9e842cec0f 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -186,6 +186,8 @@ ENTRY(ret_from_signal)
 	movel	%curptr@(TASK_STACK),%a1
 	tstb	%a1@(TINFO_FLAGS+2)
 	jge	1f
+	lea	%sp@(SWITCH_STACK_SIZE),%a1
+	movel	%a1,%curptr@(TASK_THREAD+THREAD_ESP0)
 	jbsr	syscall_trace
 1:	RESTORE_SWITCH_STACK
 	addql	#4,%sp
diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 0af88622c619..cb6d22439f71 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -662,6 +662,11 @@ static void build_epilogue(struct jit_ctx *ctx)
 	((int)K < 0 ? ((int)K >= SKF_LL_OFF ? func##_negative : func) : \
 	 func##_positive)
 
+static bool is_bad_offset(int b_off)
+{
+	return b_off > 0x1ffff || b_off < -0x20000;
+}
+
 static int build_body(struct jit_ctx *ctx)
 {
 	const struct bpf_prog *prog = ctx->skf;
@@ -728,7 +733,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* Load return register on DS for failures */
 			emit_reg_move(r_ret, r_zero, ctx);
 			/* Return with error */
-			emit_b(b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
 		case BPF_LD | BPF_W | BPF_IND:
@@ -775,8 +783,10 @@ static int build_body(struct jit_ctx *ctx)
 			emit_jalr(MIPS_R_RA, r_s0, ctx);
 			emit_reg_move(MIPS_R_A0, r_skb, ctx); /* delay slot */
 			/* Check the error value */
-			emit_bcond(MIPS_COND_NE, r_ret, 0,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_NE, r_ret, 0, b_off, ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			/* We are good */
 			/* X <- P[1:K] & 0xf */
@@ -855,8 +865,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* A /= X */
 			ctx->flags |= SEEN_X | SEEN_A;
 			/* Check if r_X is zero */
-			emit_bcond(MIPS_COND_EQ, r_X, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_X, r_zero, b_off, ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			emit_div(r_A, r_X, ctx);
 			break;
@@ -864,8 +876,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* A %= X */
 			ctx->flags |= SEEN_X | SEEN_A;
 			/* Check if r_X is zero */
-			emit_bcond(MIPS_COND_EQ, r_X, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_X, r_zero, b_off, ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			emit_mod(r_A, r_X, ctx);
 			break;
@@ -926,7 +940,10 @@ static int build_body(struct jit_ctx *ctx)
 			break;
 		case BPF_JMP | BPF_JA:
 			/* pc += K */
-			emit_b(b_imm(i + k + 1, ctx), ctx);
+			b_off = b_imm(i + k + 1, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
 		case BPF_JMP | BPF_JEQ | BPF_K:
@@ -1056,12 +1073,16 @@ static int build_body(struct jit_ctx *ctx)
 			break;
 		case BPF_RET | BPF_A:
 			ctx->flags |= SEEN_A;
-			if (i != prog->len - 1)
+			if (i != prog->len - 1) {
 				/*
 				 * If this is not the last instruction
 				 * then jump to the epilogue
 				 */
-				emit_b(b_imm(prog->len, ctx), ctx);
+				b_off = b_imm(prog->len, ctx);
+				if (is_bad_offset(b_off))
+					return -E2BIG;
+				emit_b(b_off, ctx);
+			}
 			emit_reg_move(r_ret, r_A, ctx); /* delay slot */
 			break;
 		case BPF_RET | BPF_K:
@@ -1075,7 +1096,10 @@ static int build_body(struct jit_ctx *ctx)
 				 * If this is not the last instruction
 				 * then jump to the epilogue
 				 */
-				emit_b(b_imm(prog->len, ctx), ctx);
+				b_off = b_imm(prog->len, ctx);
+				if (is_bad_offset(b_off))
+					return -E2BIG;
+				emit_b(b_off, ctx);
 				emit_nop(ctx);
 			}
 			break;
@@ -1133,8 +1157,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* Load *dev pointer */
 			emit_load_ptr(r_s0, r_skb, off, ctx);
 			/* error (0) in the delay slot */
-			emit_bcond(MIPS_COND_EQ, r_s0, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_s0, r_zero, b_off, ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			if (code == (BPF_ANC | SKF_AD_IFINDEX)) {
 				BUILD_BUG_ON(sizeof_field(struct net_device, ifindex) != 4);
@@ -1244,7 +1270,10 @@ void bpf_jit_compile(struct bpf_prog *fp)
 
 	/* Generate the actual JIT code */
 	build_prologue(&ctx);
-	build_body(&ctx);
+	if (build_body(&ctx)) {
+		module_memfree(ctx.target);
+		goto out;
+	}
 	build_epilogue(&ctx);
 
 	/* Update the icache */
diff --git a/arch/nios2/Kconfig.debug b/arch/nios2/Kconfig.debug
index a8bc06e96ef5..ca1beb87f987 100644
--- a/arch/nios2/Kconfig.debug
+++ b/arch/nios2/Kconfig.debug
@@ -3,9 +3,10 @@
 config EARLY_PRINTK
 	bool "Activate early kernel debugging"
 	default y
+	depends on TTY
 	select SERIAL_CORE_CONSOLE
 	help
-	  Enable early printk on console
+	  Enable early printk on console.
 	  This is useful for kernel debugging when your machine crashes very
 	  early before the console code is initialized.
 	  You should normally say N here, unless you want to debug such a crash.
diff --git a/arch/nios2/kernel/setup.c b/arch/nios2/kernel/setup.c
index cf8d687a2644..40bc8fb75e0b 100644
--- a/arch/nios2/kernel/setup.c
+++ b/arch/nios2/kernel/setup.c
@@ -149,8 +149,6 @@ static void __init find_limits(unsigned long *min, unsigned long *max_low,
 
 void __init setup_arch(char **cmdline_p)
 {
-	int dram_start;
-
 	console_verbose();
 
 	memory_start = memblock_start_of_DRAM();
diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index 20f169b6db4e..d97301d9d0b8 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -57,7 +57,7 @@ struct ccwgroup_device *get_ccwgroupdev_by_busid(struct ccwgroup_driver *gdrv,
 						 char *bus_id);
 
 extern int ccwgroup_set_online(struct ccwgroup_device *gdev);
-extern int ccwgroup_set_offline(struct ccwgroup_device *gdev);
+int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
 
 extern int ccwgroup_probe_ccwdev(struct ccw_device *cdev);
 extern void ccwgroup_remove_ccwdev(struct ccw_device *cdev);
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 388643ca2177..0fc961bef299 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
+	if (!walk.nbytes)
 		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ac6fd2dabf6a..482224444a1e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -263,6 +263,7 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0xa8, 0xb0, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xb7, 0xbd, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xd0, 0xe6, 0xf),
+	INTEL_EVENT_CONSTRAINT(0xef, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xf0, 0xf4, 0xf),
 	EVENT_CONSTRAINT_END
 };
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..6a5f3acf2b33 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -46,7 +46,7 @@ struct kvm_page_track_notifier_node {
 			    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_page_track_init(struct kvm *kvm);
+int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index eceea9299097..6c5765192102 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -2,6 +2,20 @@
 #ifndef _ASM_X86_KVM_CLOCK_H
 #define _ASM_X86_KVM_CLOCK_H
 
+#include <linux/percpu.h>
+
 extern struct clocksource kvm_clock;
 
+DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+
+static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
+{
+	return &this_cpu_read(hv_clock_per_cpu)->pvti;
+}
+
+static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
+{
+	return this_cpu_read(hv_clock_per_cpu);
+}
+
 #endif /* _ASM_X86_KVM_CLOCK_H */
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ad273e5861c1..73c74b961d0f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -49,18 +49,9 @@ early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
 static struct pvclock_vsyscall_time_info
 			hv_clock_boot[HVC_BOOT_ARRAY_SIZE] __bss_decrypted __aligned(PAGE_SIZE);
 static struct pvclock_wall_clock wall_clock __bss_decrypted;
-static DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 static struct pvclock_vsyscall_time_info *hvclock_mem;
-
-static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
-{
-	return &this_cpu_read(hv_clock_per_cpu)->pvti;
-}
-
-static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
-{
-	return this_cpu_read(hv_clock_per_cpu);
-}
+DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+EXPORT_PER_CPU_SYMBOL_GPL(hv_clock_per_cpu);
 
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fe03bd978761..751aa85a3001 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -65,8 +65,8 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-		if (e->function == function && (e->index == index ||
-		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+		if (e->function == function &&
+		    (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
 			return e;
 	}
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2837110e66ed..50050d06672b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -435,7 +435,6 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	__FOP_RET(#op)
 
 asm(".pushsection .fixup, \"ax\"\n"
-    ".global kvm_fastop_exception \n"
     "kvm_fastop_exception: xor %esi, %esi; ret\n"
     ".popsection");
 
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index ff005fe738a4..8c065da73f8e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -319,8 +319,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	unsigned index;
 	bool mask_before, mask_after;
 	union kvm_ioapic_redirect_entry *e;
-	unsigned long vcpu_bitmap;
 	int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -384,9 +384,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			irq.shorthand = APIC_DEST_NOSHORT;
 			irq.dest_id = e->fields.dest_id;
 			irq.msi_redir_hint = false;
-			bitmap_zero(&vcpu_bitmap, 16);
+			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
-						 &vcpu_bitmap);
+						 vcpu_bitmap);
 			if (old_dest_mode != e->fields.dest_mode ||
 			    old_dest_id != e->fields.dest_id) {
 				/*
@@ -399,10 +399,10 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 				    kvm_lapic_irq_dest_mode(
 					!!e->fields.dest_mode);
 				kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
-							 &vcpu_bitmap);
+							 vcpu_bitmap);
 			}
 			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
-							  &vcpu_bitmap);
+							  vcpu_bitmap);
 		} else {
 			kvm_make_scan_ioapic_request(ioapic->kvm);
 		}
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 91a9f7e0fd91..68e67228101d 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -163,13 +163,13 @@ void kvm_page_track_cleanup(struct kvm *kvm)
 	cleanup_srcu_struct(&head->track_srcu);
 }
 
-void kvm_page_track_init(struct kvm *kvm)
+int kvm_page_track_init(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
 
 	head = &kvm->arch.track_notifier_head;
-	init_srcu_struct(&head->track_srcu);
 	INIT_HLIST_HEAD(&head->track_notifier_list);
+	return init_srcu_struct(&head->track_srcu);
 }
 
 /*
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e5515477c30a..700bc241cee1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -545,7 +545,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
 		(svm->vmcb01.ptr->control.int_ctl & int_ctl_vmcb01_bits);
 
-	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
 	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
 	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7fbce342eec4..cb166bde449b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -596,43 +596,50 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	return 0;
 }
 
-static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				    int *error)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa vmsa;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	/* Perform some pre-encryption checks against the VMSA */
+	ret = sev_es_sync_vmsa(svm);
+	if (ret)
+		return ret;
+
+	/*
+	 * The LAUNCH_UPDATE_VMSA command will perform in-place encryption of
+	 * the VMSA memory content (i.e it will write the same memory region
+	 * with the guest's key), so invalidate it first.
+	 */
+	clflush_cache_range(svm->vmsa, PAGE_SIZE);
+
+	vmsa.reserved = 0;
+	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
+	vmsa.address = __sme_pa(svm->vmsa);
+	vmsa.len = PAGE_SIZE;
+	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+}
+
+static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
 	struct kvm_vcpu *vcpu;
 	int i, ret;
 
 	if (!sev_es_guest(kvm))
 		return -ENOTTY;
 
-	vmsa.reserved = 0;
-
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct vcpu_svm *svm = to_svm(vcpu);
-
-		/* Perform some pre-encryption checks against the VMSA */
-		ret = sev_es_sync_vmsa(svm);
+		ret = mutex_lock_killable(&vcpu->mutex);
 		if (ret)
 			return ret;
 
-		/*
-		 * The LAUNCH_UPDATE_VMSA command will perform in-place
-		 * encryption of the VMSA memory content (i.e it will write
-		 * the same memory region with the guest's key), so invalidate
-		 * it first.
-		 */
-		clflush_cache_range(svm->vmsa, PAGE_SIZE);
+		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
 
-		vmsa.handle = sev->handle;
-		vmsa.address = __sme_pa(svm->vmsa);
-		vmsa.len = PAGE_SIZE;
-		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
-				    &argp->error);
+		mutex_unlock(&vcpu->mutex);
 		if (ret)
 			return ret;
-
-		svm->vcpu.arch.guest_state_protected = true;
 	}
 
 	return 0;
@@ -1398,8 +1405,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
@@ -1465,7 +1474,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 0);
+				    PAGE_SIZE, &n, 1);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -1502,6 +1511,20 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
+static bool cmd_allowed_from_miror(u32 cmd_id)
+{
+	/*
+	 * Allow mirrors VM to call KVM_SEV_LAUNCH_UPDATE_VMSA to enable SEV-ES
+	 * active mirror VMs. Also allow the debugging and status commands.
+	 */
+	if (cmd_id == KVM_SEV_LAUNCH_UPDATE_VMSA ||
+	    cmd_id == KVM_SEV_GUEST_STATUS || cmd_id == KVM_SEV_DBG_DECRYPT ||
+	    cmd_id == KVM_SEV_DBG_ENCRYPT)
+		return true;
+
+	return false;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1518,8 +1541,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 
 	mutex_lock(&kvm->lock);
 
-	/* enc_context_owner handles all memory enc operations */
-	if (is_mirroring_enc_context(kvm)) {
+	/* Only the enc_context_owner handles some memory enc operations. */
+	if (is_mirroring_enc_context(kvm) &&
+	    !cmd_allowed_from_miror(sev_cmd.id)) {
 		r = -EINVAL;
 		goto out;
 	}
@@ -1716,8 +1740,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct file *source_kvm_file;
 	struct kvm *source_kvm;
-	struct kvm_sev_info *mirror_sev;
-	unsigned int asid;
+	struct kvm_sev_info source_sev, *mirror_sev;
 	int ret;
 
 	source_kvm_file = fget(source_fd);
@@ -1740,7 +1763,8 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 		goto e_source_unlock;
 	}
 
-	asid = to_kvm_svm(source_kvm)->sev_info.asid;
+	memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
+	       sizeof(source_sev));
 
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
@@ -1760,8 +1784,16 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	/* Set enc_context_owner and copy its encryption context over */
 	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
-	mirror_sev->asid = asid;
 	mirror_sev->active = true;
+	mirror_sev->asid = source_sev.asid;
+	mirror_sev->fd = source_sev.fd;
+	mirror_sev->es_active = source_sev.es_active;
+	mirror_sev->handle = source_sev.handle;
+	/*
+	 * Do not copy ap_jump_table. Since the mirror does not share the same
+	 * KVM contexts as the original, and they may have different
+	 * memory-views.
+	 */
 
 	mutex_unlock(&kvm->lock);
 	return 0;
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 896b2a50b4aa..a44e2734ff9b 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -354,14 +354,20 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		break;
+	case MSR_IA32_VMX_PINBASED_CTLS:
+		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+		break;
+	case MSR_IA32_VMX_VMFUNC:
+		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
 		break;
 	}
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ac1803dac435..ce30503f5438 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5898,6 +5898,12 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 	case EXIT_REASON_VMFUNC:
 		/* VM functions are emulated through L2->L0 vmexits. */
 		return true;
+	case EXIT_REASON_BUS_LOCK:
+		/*
+		 * At present, bus lock VM exit is never exposed to L1.
+		 * Handle L2's bus locks in L0 directly.
+		 */
+		return true;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 256f8cab4b8b..55de1eb135f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1840,10 +1840,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				    &msr_info->data))
 			return 1;
 		/*
-		 * Enlightened VMCS v1 doesn't have certain fields, but buggy
-		 * Hyper-V versions are still trying to use corresponding
-		 * features when they are exposed. Filter out the essential
-		 * minimum.
+		 * Enlightened VMCS v1 doesn't have certain VMCS fields but
+		 * instead of just ignoring the features, different Hyper-V
+		 * versions are either trying to use them and fail or do some
+		 * sanity checking and refuse to boot. Filter all unsupported
+		 * features out.
 		 */
 		if (!msr_info->host_initiated &&
 		    vmx->nested.enlightened_vmcs_enabled)
@@ -6815,7 +6816,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		 */
 		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (tsx_ctrl)
-			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			tsx_ctrl->mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ec7c2dce506..6d5d6e93f5c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10873,6 +10873,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
+	vcpu->arch.cr3 = 0;
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+
 	/*
 	 * Reset the MMU context if paging was enabled prior to INIT (which is
 	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
@@ -11090,9 +11093,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
+	int ret;
+
 	if (type)
 		return -EINVAL;
 
+	ret = kvm_page_track_init(kvm);
+	if (ret)
+		return ret;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
@@ -11125,7 +11134,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
-	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
 	return static_call(kvm_x86_vm_init)(kvm);
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 16d76f814e9b..ffcc4d29ad50 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1341,9 +1341,10 @@ st:			if (is_imm8(insn->off))
 			if (insn->imm == (BPF_AND | BPF_FETCH) ||
 			    insn->imm == (BPF_OR | BPF_FETCH) ||
 			    insn->imm == (BPF_XOR | BPF_FETCH)) {
-				u8 *branch_target;
 				bool is64 = BPF_SIZE(insn->code) == BPF_DW;
 				u32 real_src_reg = src_reg;
+				u32 real_dst_reg = dst_reg;
+				u8 *branch_target;
 
 				/*
 				 * Can't be implemented with a single x86 insn.
@@ -1354,11 +1355,13 @@ st:			if (is_imm8(insn->off))
 				emit_mov_reg(&prog, true, BPF_REG_AX, BPF_REG_0);
 				if (src_reg == BPF_REG_0)
 					real_src_reg = BPF_REG_AX;
+				if (dst_reg == BPF_REG_0)
+					real_dst_reg = BPF_REG_AX;
 
 				branch_target = prog;
 				/* Load old value */
 				emit_ldx(&prog, BPF_SIZE(insn->code),
-					 BPF_REG_0, dst_reg, insn->off);
+					 BPF_REG_0, real_dst_reg, insn->off);
 				/*
 				 * Perform the (commutative) operation locally,
 				 * put the result in the AUX_REG.
@@ -1369,7 +1372,8 @@ st:			if (is_imm8(insn->off))
 				      add_2reg(0xC0, AUX_REG, real_src_reg));
 				/* Attempt to swap in new value */
 				err = emit_atomic(&prog, BPF_CMPXCHG,
-						  dst_reg, AUX_REG, insn->off,
+						  real_dst_reg, AUX_REG,
+						  insn->off,
 						  BPF_SIZE(insn->code));
 				if (WARN_ON(err))
 					return err;
@@ -1383,11 +1387,10 @@ st:			if (is_imm8(insn->off))
 				/* Restore R0 after clobbering RAX */
 				emit_mov_reg(&prog, true, BPF_REG_0, BPF_REG_AX);
 				break;
-
 			}
 
 			err = emit_atomic(&prog, insn->imm, dst_reg, src_reg,
-						  insn->off, BPF_SIZE(insn->code));
+					  insn->off, BPF_SIZE(insn->code));
 			if (err)
 				return err;
 			break;
@@ -1744,7 +1747,7 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 }
 
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
-			   struct bpf_prog *p, int stack_size, bool mod_ret)
+			   struct bpf_prog *p, int stack_size, bool save_ret)
 {
 	u8 *prog = *pprog;
 	u8 *jmp_insn;
@@ -1777,11 +1780,15 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	if (emit_call(&prog, p->bpf_func, prog))
 		return -EINVAL;
 
-	/* BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
+	/*
+	 * BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
 	 * of the previous call which is then passed on the stack to
 	 * the next BPF program.
+	 *
+	 * BPF_TRAMP_FENTRY trampoline may need to return the return
+	 * value of BPF_PROG_TYPE_STRUCT_OPS prog.
 	 */
-	if (mod_ret)
+	if (save_ret)
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 
 	/* replace 2 nops with JE insn, since jmp target is known */
@@ -1828,13 +1835,15 @@ static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
 }
 
 static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
-		      struct bpf_tramp_progs *tp, int stack_size)
+		      struct bpf_tramp_progs *tp, int stack_size,
+		      bool save_ret)
 {
 	int i;
 	u8 *prog = *pprog;
 
 	for (i = 0; i < tp->nr_progs; i++) {
-		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, false))
+		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size,
+				    save_ret))
 			return -EINVAL;
 	}
 	*pprog = prog;
@@ -1877,6 +1886,23 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 	return 0;
 }
 
+static bool is_valid_bpf_tramp_flags(unsigned int flags)
+{
+	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
+	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+		return false;
+
+	/*
+	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
+	 * and it must be used alone.
+	 */
+	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
+	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
+		return false;
+
+	return true;
+}
+
 /* Example:
  * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
  * its 'struct btf_func_model' will be nr_args=2
@@ -1949,17 +1975,19 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
 	u8 **branches = NULL;
 	u8 *prog;
+	bool save_ret;
 
 	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
 	if (nr_args > 6)
 		return -ENOTSUPP;
 
-	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
-	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+	if (!is_valid_bpf_tramp_flags(flags))
 		return -EINVAL;
 
-	if (flags & BPF_TRAMP_F_CALL_ORIG)
-		stack_size += 8; /* room for return value of orig_call */
+	/* room for return value of orig_call or fentry prog */
+	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
+	if (save_ret)
+		stack_size += 8;
 
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip patched call instruction and point orig_call to actual
@@ -1986,7 +2014,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (fentry->nr_progs)
-		if (invoke_bpf(m, &prog, fentry, stack_size))
+		if (invoke_bpf(m, &prog, fentry, stack_size,
+			       flags & BPF_TRAMP_F_RET_FENTRY_RET))
 			return -EINVAL;
 
 	if (fmod_ret->nr_progs) {
@@ -2033,7 +2062,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (fexit->nr_progs)
-		if (invoke_bpf(m, &prog, fexit, stack_size)) {
+		if (invoke_bpf(m, &prog, fexit, stack_size, false)) {
 			ret = -EINVAL;
 			goto cleanup;
 		}
@@ -2053,9 +2082,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 			ret = -EINVAL;
 			goto cleanup;
 		}
-		/* restore original return value back into RAX */
-		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 	}
+	/* restore return value of orig_call or fentry prog back into RAX */
+	if (save_ret)
+		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 
 	EMIT1(0x5B); /* pop rbx */
 	EMIT1(0xC9); /* leave */
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 3a1038b6eeb3..9360c65169ff 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2662,15 +2662,6 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
 	 * are likely to increase the throughput.
 	 */
 	bfqq->new_bfqq = new_bfqq;
-	/*
-	 * The above assignment schedules the following redirections:
-	 * each time some I/O for bfqq arrives, the process that
-	 * generated that I/O is disassociated from bfqq and
-	 * associated with new_bfqq. Here we increases new_bfqq->ref
-	 * in advance, adding the number of processes that are
-	 * expected to be associated with new_bfqq as they happen to
-	 * issue I/O.
-	 */
 	new_bfqq->ref += process_refs;
 	return new_bfqq;
 }
@@ -2733,10 +2724,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
-	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	/*
 	 * Check delayed stable merge for rotational or non-queueing
 	 * devs. For this branch to be executed, bfqq must not be
@@ -2838,6 +2825,9 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a3ef6cce644c..7dd80acf92c7 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3007,6 +3007,18 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		ndr_desc->target_node = NUMA_NO_NODE;
 	}
 
+	/* Fallback to address based numa information if node lookup failed */
+	if (ndr_desc->numa_node == NUMA_NO_NODE) {
+		ndr_desc->numa_node = memory_add_physaddr_to_nid(spa->address);
+		dev_info(acpi_desc->dev, "changing numa node from %d to %d for nfit region [%pa-%pa]",
+			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+	}
+	if (ndr_desc->target_node == NUMA_NO_NODE) {
+		ndr_desc->target_node = phys_to_target_node(spa->address);
+		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
+			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+	}
+
 	/*
 	 * Persistence domain bits are hierarchical, if
 	 * ACPI_NFIT_CAPABILITY_CACHE_FLUSH is set then
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8c77e14987d4..56f54e6eb987 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1721,6 +1721,25 @@ static int fw_devlink_create_devlink(struct device *con,
 	struct device *sup_dev;
 	int ret = 0;
 
+	/*
+	 * In some cases, a device P might also be a supplier to its child node
+	 * C. However, this would defer the probe of C until the probe of P
+	 * completes successfully. This is perfectly fine in the device driver
+	 * model. device_add() doesn't guarantee probe completion of the device
+	 * by the time it returns.
+	 *
+	 * However, there are a few drivers that assume C will finish probing
+	 * as soon as it's added and before P finishes probing. So, we provide
+	 * a flag to let fw_devlink know not to delay the probe of C until the
+	 * probe of P completes successfully.
+	 *
+	 * When such a flag is set, we can't create device links where P is the
+	 * supplier of C as that would delay the probe of C.
+	 */
+	if (sup_handle->flags & FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD &&
+	    fwnode_is_ancestor_of(sup_handle, con->fwnode))
+		return -EINVAL;
+
 	sup_dev = get_dev_from_fwnode(sup_handle);
 	if (sup_dev) {
 		/*
@@ -1771,14 +1790,21 @@ static int fw_devlink_create_devlink(struct device *con,
 	 * be broken by applying logic. Check for these types of cycles and
 	 * break them so that devices in the cycle probe properly.
 	 *
-	 * If the supplier's parent is dependent on the consumer, then
-	 * the consumer-supplier dependency is a false dependency. So,
-	 * treat it as an invalid link.
+	 * If the supplier's parent is dependent on the consumer, then the
+	 * consumer and supplier have a cyclic dependency. Since fw_devlink
+	 * can't tell which of the inferred dependencies are incorrect, don't
+	 * enforce probe ordering between any of the devices in this cyclic
+	 * dependency. Do this by relaxing all the fw_devlink device links in
+	 * this cycle and by treating the fwnode link between the consumer and
+	 * the supplier as an invalid dependency.
 	 */
 	sup_dev = fwnode_get_next_parent_dev(sup_handle);
 	if (sup_dev && device_is_dependent(con, sup_dev)) {
-		dev_dbg(con, "Not linking to %pfwP - False link\n",
-			sup_handle);
+		dev_info(con, "Fixing up cyclic dependency with %pfwP (%s)\n",
+			 sup_handle, dev_name(sup_dev));
+		device_links_write_lock();
+		fw_devlink_relax_cycle(con, sup_dev);
+		device_links_write_unlock();
 		ret = -EINVAL;
 	} else {
 		/*
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 93708b1938e8..99ab58b877f8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -97,13 +97,18 @@ struct nbd_config {
 
 	atomic_t recv_threads;
 	wait_queue_head_t recv_wq;
-	loff_t blksize;
+	unsigned int blksize_bits;
 	loff_t bytesize;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbg_dir;
 #endif
 };
 
+static inline unsigned int nbd_blksize(struct nbd_config *config)
+{
+	return 1u << config->blksize_bits;
+}
+
 struct nbd_device {
 	struct blk_mq_tag_set tag_set;
 
@@ -147,7 +152,7 @@ static struct dentry *nbd_dbg_dir;
 
 #define NBD_MAGIC 0x68797548
 
-#define NBD_DEF_BLKSIZE 1024
+#define NBD_DEF_BLKSIZE_BITS 10
 
 static unsigned int nbds_max = 16;
 static int max_part = 16;
@@ -350,12 +355,12 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 		loff_t blksize)
 {
 	if (!blksize)
-		blksize = NBD_DEF_BLKSIZE;
+		blksize = 1u << NBD_DEF_BLKSIZE_BITS;
 	if (blksize < 512 || blksize > PAGE_SIZE || !is_power_of_2(blksize))
 		return -EINVAL;
 
 	nbd->config->bytesize = bytesize;
-	nbd->config->blksize = blksize;
+	nbd->config->blksize_bits = __ffs(blksize);
 
 	if (!nbd->task_recv)
 		return 0;
@@ -1370,7 +1375,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args->index = i;
 		queue_work(nbd->recv_workq, &args->work);
 	}
-	return nbd_set_size(nbd, config->bytesize, config->blksize);
+	return nbd_set_size(nbd, config->bytesize, nbd_blksize(config));
 }
 
 static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *bdev)
@@ -1439,11 +1444,11 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_SET_BLKSIZE:
 		return nbd_set_size(nbd, config->bytesize, arg);
 	case NBD_SET_SIZE:
-		return nbd_set_size(nbd, arg, config->blksize);
+		return nbd_set_size(nbd, arg, nbd_blksize(config));
 	case NBD_SET_SIZE_BLOCKS:
-		if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
+		if (check_shl_overflow(arg, config->blksize_bits, &bytesize))
 			return -EINVAL;
-		return nbd_set_size(nbd, bytesize, config->blksize);
+		return nbd_set_size(nbd, bytesize, nbd_blksize(config));
 	case NBD_SET_TIMEOUT:
 		nbd_set_cmd_timeout(nbd, arg);
 		return 0;
@@ -1509,7 +1514,7 @@ static struct nbd_config *nbd_alloc_config(void)
 	atomic_set(&config->recv_threads, 0);
 	init_waitqueue_head(&config->recv_wq);
 	init_waitqueue_head(&config->conn_wait);
-	config->blksize = NBD_DEF_BLKSIZE;
+	config->blksize_bits = NBD_DEF_BLKSIZE_BITS;
 	atomic_set(&config->live_connections, 0);
 	try_module_get(THIS_MODULE);
 	return config;
@@ -1637,7 +1642,7 @@ static int nbd_dev_dbg_init(struct nbd_device *nbd)
 	debugfs_create_file("tasks", 0444, dir, nbd, &nbd_dbg_tasks_fops);
 	debugfs_create_u64("size_bytes", 0444, dir, &config->bytesize);
 	debugfs_create_u32("timeout", 0444, dir, &nbd->tag_set.timeout);
-	debugfs_create_u64("blocksize", 0444, dir, &config->blksize);
+	debugfs_create_u32("blocksize_bits", 0444, dir, &config->blksize_bits);
 	debugfs_create_file("flags", 0444, dir, nbd, &nbd_dbg_flags_fops);
 
 	return 0;
@@ -1841,7 +1846,7 @@ nbd_device_policy[NBD_DEVICE_ATTR_MAX + 1] = {
 static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
-	u64 bsize = config->blksize;
+	u64 bsize = nbd_blksize(config);
 	u64 bytes = config->bytesize;
 
 	if (info->attrs[NBD_ATTR_SIZE_BYTES])
@@ -1850,7 +1855,7 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES])
 		bsize = nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
 
-	if (bytes != config->bytesize || bsize != config->blksize)
+	if (bytes != config->bytesize || bsize != nbd_blksize(config))
 		return nbd_set_size(nbd, bytes, bsize);
 	return 0;
 }
diff --git a/drivers/cpufreq/cpufreq_governor_attr_set.c b/drivers/cpufreq/cpufreq_governor_attr_set.c
index 66b05a326910..a6f365b9cc1a 100644
--- a/drivers/cpufreq/cpufreq_governor_attr_set.c
+++ b/drivers/cpufreq/cpufreq_governor_attr_set.c
@@ -74,8 +74,8 @@ unsigned int gov_attr_set_put(struct gov_attr_set *attr_set, struct list_head *l
 	if (count)
 		return count;
 
-	kobject_put(&attr_set->kobj);
 	mutex_destroy(&attr_set->update_lock);
+	kobject_put(&attr_set->kobj);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gov_attr_set_put);
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index bb88198c874e..aa4e1a500691 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -778,7 +778,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 				    in_place ? DMA_BIDIRECTIONAL
 					     : DMA_TO_DEVICE);
 		if (ret)
-			goto e_ctx;
+			goto e_aad;
 
 		if (in_place) {
 			dst = src;
@@ -863,7 +863,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	op.u.aes.size = 0;
 	ret = cmd_q->ccp->vdata->perform->aes(&op);
 	if (ret)
-		goto e_dst;
+		goto e_final_wa;
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
@@ -873,17 +873,19 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		ret = ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
-			goto e_tag;
+			goto e_final_wa;
 		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
-		if (ret)
-			goto e_tag;
+		if (ret) {
+			ccp_dm_free(&tag);
+			goto e_final_wa;
+		}
 
 		ret = crypto_memneq(tag.address, final_wa.address,
 				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
-e_tag:
+e_final_wa:
 	ccp_dm_free(&final_wa);
 
 e_dst:
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index f5cfc0698799..8ebf369b3ba0 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -468,15 +468,8 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 	mutex_lock(&chip->i2c_lock);
 	ret = regmap_read(chip->regmap, inreg, &reg_val);
 	mutex_unlock(&chip->i2c_lock);
-	if (ret < 0) {
-		/*
-		 * NOTE:
-		 * diagnostic already emitted; that's all we should
-		 * do unless gpio_*_value_cansleep() calls become different
-		 * from their nonsleeping siblings (and report faults).
-		 */
-		return 0;
-	}
+	if (ret < 0)
+		return ret;
 
 	return !!(reg_val & bit);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 7b42636fc7dc..d3247a5cceb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3602,9 +3602,9 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 
 fence_driver_init:
 	/* Fence driver */
-	r = amdgpu_fence_driver_init(adev);
+	r = amdgpu_fence_driver_sw_init(adev);
 	if (r) {
-		dev_err(adev->dev, "amdgpu_fence_driver_init failed\n");
+		dev_err(adev->dev, "amdgpu_fence_driver_sw_init failed\n");
 		amdgpu_vf_error_put(adev, AMDGIM_ERROR_VF_FENCE_INIT_FAIL, 0, 0);
 		goto failed;
 	}
@@ -3631,6 +3631,8 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 		goto release_ras_con;
 	}
 
+	amdgpu_fence_driver_hw_init(adev);
+
 	dev_info(adev->dev,
 		"SE %d, SH per SE %d, CU per SH %d, active_cu_number %d\n",
 			adev->gfx.config.max_shader_engines,
@@ -3798,7 +3800,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 		else
 			drm_atomic_helper_shutdown(adev_to_drm(adev));
 	}
-	amdgpu_fence_driver_fini_hw(adev);
+	amdgpu_fence_driver_hw_fini(adev);
 
 	if (adev->pm_sysfs_en)
 		amdgpu_pm_sysfs_fini(adev);
@@ -3820,7 +3822,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
 	amdgpu_device_ip_fini(adev);
-	amdgpu_fence_driver_fini_sw(adev);
+	amdgpu_fence_driver_sw_fini(adev);
 	release_firmware(adev->firmware.gpu_info_fw);
 	adev->firmware.gpu_info_fw = NULL;
 	adev->accel_working = false;
@@ -3895,7 +3897,7 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 	/* evict vram memory */
 	amdgpu_bo_evict_vram(adev);
 
-	amdgpu_fence_driver_suspend(adev);
+	amdgpu_fence_driver_hw_fini(adev);
 
 	amdgpu_device_ip_suspend_phase2(adev);
 	/* evict remaining vram memory
@@ -3940,8 +3942,7 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		return r;
 	}
-	amdgpu_fence_driver_resume(adev);
-
+	amdgpu_fence_driver_hw_init(adev);
 
 	r = amdgpu_device_ip_late_init(adev);
 	if (r)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 7a7316731911..dc50c05f23fc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -837,6 +837,28 @@ static int convert_tiling_flags_to_modifier(struct amdgpu_framebuffer *afb)
 	return 0;
 }
 
+/* Mirrors the is_displayable check in radeonsi's gfx6_compute_surface */
+static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
+{
+	u64 micro_tile_mode;
+
+	/* Zero swizzle mode means linear */
+	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
+		return 0;
+
+	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
+	switch (micro_tile_mode) {
+	case 0: /* DISPLAY */
+	case 3: /* RENDER */
+		return 0;
+	default:
+		drm_dbg_kms(afb->base.dev,
+			    "Micro tile mode %llu not supported for scanout\n",
+			    micro_tile_mode);
+		return -EINVAL;
+	}
+}
+
 static void get_block_dimensions(unsigned int block_log2, unsigned int cpp,
 				 unsigned int *width, unsigned int *height)
 {
@@ -1103,6 +1125,7 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
 				    const struct drm_mode_fb_cmd2 *mode_cmd,
 				    struct drm_gem_object *obj)
 {
+	struct amdgpu_device *adev = drm_to_adev(dev);
 	int ret, i;
 
 	/*
@@ -1122,6 +1145,14 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
 	if (ret)
 		return ret;
 
+	if (!dev->mode_config.allow_fb_modifiers) {
+		drm_WARN_ONCE(dev, adev->family >= AMDGPU_FAMILY_AI,
+			      "GFX9+ requires FB check based on format modifier\n");
+		ret = check_tiling_flags_gfx6(rfb);
+		if (ret)
+			return ret;
+	}
+
 	if (dev->mode_config.allow_fb_modifiers &&
 	    !(rfb->base.flags & DRM_MODE_FB_MODIFIERS)) {
 		ret = convert_tiling_flags_to_modifier(rfb);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 72d9b92b1754..49884069226a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -417,9 +417,6 @@ int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 	}
 	amdgpu_fence_write(ring, atomic_read(&ring->fence_drv.last_seq));
 
-	if (irq_src)
-		amdgpu_irq_get(adev, irq_src, irq_type);
-
 	ring->fence_drv.irq_src = irq_src;
 	ring->fence_drv.irq_type = irq_type;
 	ring->fence_drv.initialized = true;
@@ -501,7 +498,7 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
 }
 
 /**
- * amdgpu_fence_driver_init - init the fence driver
+ * amdgpu_fence_driver_sw_init - init the fence driver
  * for all possible rings.
  *
  * @adev: amdgpu device pointer
@@ -512,20 +509,20 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
  * amdgpu_fence_driver_start_ring().
  * Returns 0 for success.
  */
-int amdgpu_fence_driver_init(struct amdgpu_device *adev)
+int amdgpu_fence_driver_sw_init(struct amdgpu_device *adev)
 {
 	return 0;
 }
 
 /**
- * amdgpu_fence_driver_fini - tear down the fence driver
+ * amdgpu_fence_driver_hw_fini - tear down the fence driver
  * for all possible rings.
  *
  * @adev: amdgpu device pointer
  *
  * Tear down the fence driver for all possible rings (all asics).
  */
-void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev)
+void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 {
 	int i, r;
 
@@ -534,8 +531,10 @@ void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev)
 
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
+
 		if (!ring->no_scheduler)
-			drm_sched_fini(&ring->sched);
+			drm_sched_stop(&ring->sched, NULL);
+
 		/* You can't wait for HW to signal if it's gone */
 		if (!drm_dev_is_unplugged(&adev->ddev))
 			r = amdgpu_fence_wait_empty(ring);
@@ -553,7 +552,7 @@ void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev)
 	}
 }
 
-void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev)
+void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev)
 {
 	unsigned int i, j;
 
@@ -563,6 +562,9 @@ void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
+		if (!ring->no_scheduler)
+			drm_sched_fini(&ring->sched);
+
 		for (j = 0; j <= ring->fence_drv.num_fences_mask; ++j)
 			dma_fence_put(ring->fence_drv.fences[j]);
 		kfree(ring->fence_drv.fences);
@@ -572,49 +574,18 @@ void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev)
 }
 
 /**
- * amdgpu_fence_driver_suspend - suspend the fence driver
- * for all possible rings.
- *
- * @adev: amdgpu device pointer
- *
- * Suspend the fence driver for all possible rings (all asics).
- */
-void amdgpu_fence_driver_suspend(struct amdgpu_device *adev)
-{
-	int i, r;
-
-	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
-		struct amdgpu_ring *ring = adev->rings[i];
-		if (!ring || !ring->fence_drv.initialized)
-			continue;
-
-		/* wait for gpu to finish processing current batch */
-		r = amdgpu_fence_wait_empty(ring);
-		if (r) {
-			/* delay GPU reset to resume */
-			amdgpu_fence_driver_force_completion(ring);
-		}
-
-		/* disable the interrupt */
-		if (ring->fence_drv.irq_src)
-			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
-				       ring->fence_drv.irq_type);
-	}
-}
-
-/**
- * amdgpu_fence_driver_resume - resume the fence driver
+ * amdgpu_fence_driver_hw_init - enable the fence driver
  * for all possible rings.
  *
  * @adev: amdgpu device pointer
  *
- * Resume the fence driver for all possible rings (all asics).
+ * Enable the fence driver for all possible rings (all asics).
  * Not all asics have all rings, so each asic will only
  * start the fence driver on the rings it has using
  * amdgpu_fence_driver_start_ring().
  * Returns 0 for success.
  */
-void amdgpu_fence_driver_resume(struct amdgpu_device *adev)
+void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev)
 {
 	int i;
 
@@ -623,6 +594,11 @@ void amdgpu_fence_driver_resume(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
+		if (!ring->no_scheduler) {
+			drm_sched_resubmit_jobs(&ring->sched);
+			drm_sched_start(&ring->sched, true);
+		}
+
 		/* enable the interrupt */
 		if (ring->fence_drv.irq_src)
 			amdgpu_irq_get(adev, ring->fence_drv.irq_src,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index e7d3d0dbdd96..9c11ced4312c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -106,9 +106,6 @@ struct amdgpu_fence_driver {
 	struct dma_fence		**fences;
 };
 
-int amdgpu_fence_driver_init(struct amdgpu_device *adev);
-void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev);
-void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev);
 void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring);
 
 int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
@@ -117,8 +114,10 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
 int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 				   struct amdgpu_irq_src *irq_src,
 				   unsigned irq_type);
-void amdgpu_fence_driver_suspend(struct amdgpu_device *adev);
-void amdgpu_fence_driver_resume(struct amdgpu_device *adev);
+void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev);
+void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev);
+int amdgpu_fence_driver_sw_init(struct amdgpu_device *adev);
+void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev);
 int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **fence,
 		      unsigned flags);
 int amdgpu_fence_emit_polling(struct amdgpu_ring *ring, uint32_t *s,
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 6a23c6826e12..88ed0ef88f7e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3598,7 +3598,7 @@ static int gfx_v9_0_mqd_init(struct amdgpu_ring *ring)
 
 	/* set static priority for a queue/ring */
 	gfx_v9_0_mqd_set_priority(ring, mqd);
-	mqd->cp_hqd_quantum = RREG32(mmCP_HQD_QUANTUM);
+	mqd->cp_hqd_quantum = RREG32_SOC15(GC, 0, mmCP_HQD_QUANTUM);
 
 	/* map_queues packet doesn't need activate the queue,
 	 * so only kiq need set this field.
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index 7486e5306786..27e0ca615edc 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -883,6 +883,12 @@ static int sdma_v5_2_start(struct amdgpu_device *adev)
 			msleep(1000);
 	}
 
+	/* TODO: check whether can submit a doorbell request to raise
+	 * a doorbell fence to exit gfxoff.
+	 */
+	if (adev->in_s0ix)
+		amdgpu_gfx_off_ctrl(adev, false);
+
 	sdma_v5_2_soft_reset(adev);
 	/* unhalt the MEs */
 	sdma_v5_2_enable(adev, true);
@@ -891,6 +897,8 @@ static int sdma_v5_2_start(struct amdgpu_device *adev)
 
 	/* start the gfx rings and rlc compute queues */
 	r = sdma_v5_2_gfx_resume(adev);
+	if (adev->in_s0ix)
+		amdgpu_gfx_off_ctrl(adev, true);
 	if (r)
 		return r;
 	r = sdma_v5_2_rlc_resume(adev);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3bb567ea2cef..a03d7682cd8f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1117,6 +1117,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	init_data.asic_id.pci_revision_id = adev->pdev->revision;
 	init_data.asic_id.hw_internal_rev = adev->external_rev_id;
+	init_data.asic_id.chip_id = adev->pdev->device;
 
 	init_data.asic_id.vram_width = adev->gmc.vram_width;
 	/* TODO: initialize init_data.asic_id.vram_type here!!!! */
@@ -1724,6 +1725,7 @@ static int dm_late_init(void *handle)
 		linear_lut[i] = 0xFFFF * i / 15;
 
 	params.set = 0;
+	params.backlight_ramping_override = false;
 	params.backlight_ramping_start = 0xCCCC;
 	params.backlight_ramping_reduction = 0xCCCCCCCC;
 	params.backlight_lut_array_size = 16;
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 83ef72a3ebf4..3c8da3665a27 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1813,14 +1813,13 @@ bool perform_link_training_with_retries(
 		if (panel_mode == DP_PANEL_MODE_EDP) {
 			struct cp_psp *cp_psp = &stream->ctx->cp_psp;
 
-			if (cp_psp && cp_psp->funcs.enable_assr) {
-				if (!cp_psp->funcs.enable_assr(cp_psp->handle, link)) {
-					/* since eDP implies ASSR on, change panel
-					 * mode to disable ASSR
-					 */
-					panel_mode = DP_PANEL_MODE_DEFAULT;
-				}
-			}
+			if (cp_psp && cp_psp->funcs.enable_assr)
+				/* ASSR is bound to fail with unsigned PSP
+				 * verstage used during devlopment phase.
+				 * Report and continue with eDP panel mode to
+				 * perform eDP link training with right settings
+				 */
+				cp_psp->funcs.enable_assr(cp_psp->handle, link);
 		}
 #endif
 
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 06e9a8ed4e03..db9c212a240e 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -861,8 +861,6 @@ void intel_rps_park(struct intel_rps *rps)
 {
 	int adj;
 
-	GEM_BUG_ON(atomic_read(&rps->num_waiters));
-
 	if (!intel_rps_clear_active(rps))
 		return;
 
diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 734c37c5e347..527b59b86312 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -576,7 +576,7 @@ static int prepare_shadow_batch_buffer(struct intel_vgpu_workload *workload)
 
 			/* No one is going to touch shadow bb from now on. */
 			i915_gem_object_flush_map(bb->obj);
-			i915_gem_object_unlock(bb->obj);
+			i915_gem_ww_ctx_fini(&ww);
 		}
 	}
 	return 0;
@@ -630,7 +630,7 @@ static int prepare_shadow_wa_ctx(struct intel_shadow_wa_ctx *wa_ctx)
 		return ret;
 	}
 
-	i915_gem_object_unlock(wa_ctx->indirect_ctx.obj);
+	i915_gem_ww_ctx_fini(&ww);
 
 	/* FIXME: we are not tracking our pinned VMA leaving it
 	 * up to the core to fix up the stray pin_count upon
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 37aef1308573..7db972fa7024 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -914,8 +914,6 @@ static void __i915_request_ctor(void *arg)
 	i915_sw_fence_init(&rq->submit, submit_notify);
 	i915_sw_fence_init(&rq->semaphore, semaphore_notify);
 
-	dma_fence_init(&rq->fence, &i915_fence_ops, &rq->lock, 0, 0);
-
 	rq->capture_list = NULL;
 
 	init_llist_head(&rq->execute_cb);
@@ -978,17 +976,12 @@ __i915_request_create(struct intel_context *ce, gfp_t gfp)
 	rq->ring = ce->ring;
 	rq->execution_mask = ce->engine->mask;
 
-	kref_init(&rq->fence.refcount);
-	rq->fence.flags = 0;
-	rq->fence.error = 0;
-	INIT_LIST_HEAD(&rq->fence.cb_list);
-
 	ret = intel_timeline_get_seqno(tl, rq, &seqno);
 	if (ret)
 		goto err_free;
 
-	rq->fence.context = tl->fence_context;
-	rq->fence.seqno = seqno;
+	dma_fence_init(&rq->fence, &i915_fence_ops, &rq->lock,
+		       tl->fence_context, seqno);
 
 	RCU_INIT_POINTER(rq->timeline, tl);
 	rq->hwsp_seqno = tl->hwsp_seqno;
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 8d68796aa905..1b4a192b19e5 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -239,13 +239,13 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (!privdata->cl_data)
 		return -ENOMEM;
 
-	rc = devm_add_action_or_reset(&pdev->dev, amd_mp2_pci_remove, privdata);
+	mp2_select_ops(privdata);
+
+	rc = amd_sfh_hid_client_init(privdata);
 	if (rc)
 		return rc;
 
-	mp2_select_ops(privdata);
-
-	return amd_sfh_hid_client_init(privdata);
+	return devm_add_action_or_reset(&pdev->dev, amd_mp2_pci_remove, privdata);
 }
 
 static const struct pci_device_id amd_mp2_pci_tbl[] = {
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
index 0790fbd3fc9a..467d789f9bc2 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -56,15 +56,22 @@ static int betopff_init(struct hid_device *hid)
 {
 	struct betopff_device *betopff;
 	struct hid_report *report;
-	struct hid_input *hidinput =
-			list_first_entry(&hid->inputs, struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int field_count = 0;
 	int error;
 	int i, j;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index 95e0807878c7..d70cd3d7f583 100644
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -198,7 +198,9 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
 	}
 
 	ret = u2fzero_recv(dev, &req, &resp);
-	if (ret < 0)
+
+	/* ignore errors or packets without data */
+	if (ret < offsetof(struct u2f_hid_msg, init.data))
 		return 0;
 
 	/* only take the minimum amount of data it is safe to take */
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b234958f883a..c56cb03c1551 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -505,7 +505,7 @@ static void hid_ctrl(struct urb *urb)
 
 	if (unplug) {
 		usbhid->ctrltail = usbhid->ctrlhead;
-	} else {
+	} else if (usbhid->ctrlhead != usbhid->ctrltail) {
 		usbhid->ctrltail = (usbhid->ctrltail + 1) & (HID_CONTROL_FIFO_SIZE - 1);
 
 		if (usbhid->ctrlhead != usbhid->ctrltail &&
@@ -1223,9 +1223,20 @@ static void usbhid_stop(struct hid_device *hid)
 	mutex_lock(&usbhid->mutex);
 
 	clear_bit(HID_STARTED, &usbhid->iofl);
+
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	while (usbhid->ctrltail != usbhid->ctrlhead) {
+		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_OUT) {
+			kfree(usbhid->ctrl[usbhid->ctrltail].raw_report);
+			usbhid->ctrl[usbhid->ctrltail].raw_report = NULL;
+		}
+
+		usbhid->ctrltail = (usbhid->ctrltail + 1) &
+			(HID_CONTROL_FIFO_SIZE - 1);
+	}
 	spin_unlock_irq(&usbhid->lock);
+
 	usb_kill_urb(usbhid->urbin);
 	usb_kill_urb(usbhid->urbout);
 	usb_kill_urb(usbhid->urbctrl);
diff --git a/drivers/hwmon/mlxreg-fan.c b/drivers/hwmon/mlxreg-fan.c
index 116681fde33d..89fe7b9fe26b 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -315,8 +315,8 @@ static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
 {
 	struct mlxreg_fan *fan = cdev->devdata;
 	unsigned long cur_state;
+	int i, config = 0;
 	u32 regval;
-	int i;
 	int err;
 
 	/*
@@ -329,6 +329,12 @@ static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
 	 * overwritten.
 	 */
 	if (state >= MLXREG_FAN_SPEED_MIN && state <= MLXREG_FAN_SPEED_MAX) {
+		/*
+		 * This is configuration change, which is only supported through sysfs.
+		 * For configuration non-zero value is to be returned to avoid thermal
+		 * statistics update.
+		 */
+		config = 1;
 		state -= MLXREG_FAN_MAX_STATE;
 		for (i = 0; i < state; i++)
 			fan->cooling_levels[i] = state;
@@ -343,7 +349,7 @@ static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
 
 		cur_state = MLXREG_FAN_PWM_DUTY2STATE(regval);
 		if (state < cur_state)
-			return 0;
+			return config;
 
 		state = cur_state;
 	}
@@ -359,7 +365,7 @@ static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
 		dev_err(fan->dev, "Failed to write PWM duty\n");
 		return err;
 	}
-	return 0;
+	return config;
 }
 
 static const struct thermal_cooling_device_ops mlxreg_fan_cooling_ops = {
diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 0d68a78be980..ae664613289c 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -340,18 +340,11 @@ static ssize_t occ_show_temp_10(struct device *dev,
 		if (val == OCC_TEMP_SENSOR_FAULT)
 			return -EREMOTEIO;
 
-		/*
-		 * VRM doesn't return temperature, only alarm bit. This
-		 * attribute maps to tempX_alarm instead of tempX_input for
-		 * VRM
-		 */
-		if (temp->fru_type != OCC_FRU_TYPE_VRM) {
-			/* sensor not ready */
-			if (val == 0)
-				return -EAGAIN;
+		/* sensor not ready */
+		if (val == 0)
+			return -EAGAIN;
 
-			val *= 1000;
-		}
+		val *= 1000;
 		break;
 	case 2:
 		val = temp->fru_type;
@@ -886,7 +879,7 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 					     0, i);
 		attr++;
 
-		if (sensors->temp.version > 1 &&
+		if (sensors->temp.version == 2 &&
 		    temp->fru_type == OCC_FRU_TYPE_VRM) {
 			snprintf(attr->name, sizeof(attr->name),
 				 "temp%d_alarm", s);
diff --git a/drivers/hwmon/pmbus/mp2975.c b/drivers/hwmon/pmbus/mp2975.c
index eb94bd5f4e2a..51986adfbf47 100644
--- a/drivers/hwmon/pmbus/mp2975.c
+++ b/drivers/hwmon/pmbus/mp2975.c
@@ -54,7 +54,7 @@
 
 #define MP2975_RAIL2_FUNC	(PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT | \
 				 PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT | \
-				 PMBUS_PHASE_VIRTUAL)
+				 PMBUS_HAVE_POUT | PMBUS_PHASE_VIRTUAL)
 
 struct mp2975_data {
 	struct pmbus_driver_info info;
diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ede66ea6a730..b963a369c5ab 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -100,71 +100,81 @@ struct tmp421_data {
 	s16 temp[4];
 };
 
-static int temp_from_s16(s16 reg)
+static int temp_from_raw(u16 reg, bool extended)
 {
 	/* Mask out status bits */
 	int temp = reg & ~0xf;
 
-	return (temp * 1000 + 128) / 256;
-}
-
-static int temp_from_u16(u16 reg)
-{
-	/* Mask out status bits */
-	int temp = reg & ~0xf;
-
-	/* Add offset for extended temperature range. */
-	temp -= 64 * 256;
+	if (extended)
+		temp = temp - 64 * 256;
+	else
+		temp = (s16)temp;
 
-	return (temp * 1000 + 128) / 256;
+	return DIV_ROUND_CLOSEST(temp * 1000, 256);
 }
 
-static struct tmp421_data *tmp421_update_device(struct device *dev)
+static int tmp421_update_device(struct tmp421_data *data)
 {
-	struct tmp421_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
+	int ret = 0;
 	int i;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
 	    !data->valid) {
-		data->config = i2c_smbus_read_byte_data(client,
-			TMP421_CONFIG_REG_1);
+		ret = i2c_smbus_read_byte_data(client, TMP421_CONFIG_REG_1);
+		if (ret < 0)
+			goto exit;
+		data->config = ret;
 
 		for (i = 0; i < data->channels; i++) {
-			data->temp[i] = i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_MSB[i]) << 8;
-			data->temp[i] |= i2c_smbus_read_byte_data(client,
-				TMP421_TEMP_LSB[i]);
+			ret = i2c_smbus_read_byte_data(client, TMP421_TEMP_MSB[i]);
+			if (ret < 0)
+				goto exit;
+			data->temp[i] = ret << 8;
+
+			ret = i2c_smbus_read_byte_data(client, TMP421_TEMP_LSB[i]);
+			if (ret < 0)
+				goto exit;
+			data->temp[i] |= ret;
 		}
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
 
+exit:
 	mutex_unlock(&data->update_lock);
 
-	return data;
+	if (ret < 0) {
+		data->valid = 0;
+		return ret;
+	}
+
+	return 0;
 }
 
 static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 		       u32 attr, int channel, long *val)
 {
-	struct tmp421_data *tmp421 = tmp421_update_device(dev);
+	struct tmp421_data *tmp421 = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = tmp421_update_device(tmp421);
+	if (ret)
+		return ret;
 
 	switch (attr) {
 	case hwmon_temp_input:
-		if (tmp421->config & TMP421_CONFIG_RANGE)
-			*val = temp_from_u16(tmp421->temp[channel]);
-		else
-			*val = temp_from_s16(tmp421->temp[channel]);
+		*val = temp_from_raw(tmp421->temp[channel],
+				     tmp421->config & TMP421_CONFIG_RANGE);
 		return 0;
 	case hwmon_temp_fault:
 		/*
-		 * The OPEN bit signals a fault. This is bit 0 of the temperature
-		 * register (low byte).
+		 * Any of OPEN or /PVLD bits indicate a hardware mulfunction
+		 * and the conversion result may be incorrect
 		 */
-		*val = tmp421->temp[channel] & 0x01;
+		*val = !!(tmp421->temp[channel] & 0x03);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -177,9 +187,6 @@ static umode_t tmp421_is_visible(const void *data, enum hwmon_sensor_types type,
 {
 	switch (attr) {
 	case hwmon_temp_fault:
-		if (channel == 0)
-			return 0;
-		return 0444;
 	case hwmon_temp_input:
 		return 0444;
 	default:
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 37b25a1474c4..3c1be2c11fdf 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -273,9 +273,6 @@ struct w83791d_data {
 	char valid;			/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	/* array of 2 pointers to subclients */
-	struct i2c_client *lm75[2];
-
 	/* volts */
 	u8 in[NUMBER_OF_VIN];		/* Register value */
 	u8 in_max[NUMBER_OF_VIN];	/* Register value */
@@ -1257,7 +1254,6 @@ static const struct attribute_group w83791d_group_fanpwm45 = {
 static int w83791d_detect_subclients(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	struct w83791d_data *data = i2c_get_clientdata(client);
 	int address = client->addr;
 	int i, id;
 	u8 val;
@@ -1280,22 +1276,19 @@ static int w83791d_detect_subclients(struct i2c_client *client)
 	}
 
 	val = w83791d_read(client, W83791D_REG_I2C_SUBADDR);
-	if (!(val & 0x08))
-		data->lm75[0] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + (val & 0x7));
-	if (!(val & 0x80)) {
-		if (!IS_ERR(data->lm75[0]) &&
-				((val & 0x7) == ((val >> 4) & 0x7))) {
-			dev_err(&client->dev,
-				"duplicate addresses 0x%x, "
-				"use force_subclient\n",
-				data->lm75[0]->addr);
-			return -ENODEV;
-		}
-		data->lm75[1] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + ((val >> 4) & 0x7));
+
+	if (!(val & 0x88) && (val & 0x7) == ((val >> 4) & 0x7)) {
+		dev_err(&client->dev,
+			"duplicate addresses 0x%x, use force_subclient\n", 0x48 + (val & 0x7));
+		return -ENODEV;
 	}
 
+	if (!(val & 0x08))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + (val & 0x7));
+
+	if (!(val & 0x80))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + ((val >> 4) & 0x7));
+
 	return 0;
 }
 
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index abd5c3a722b9..1f175f381350 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -264,9 +264,6 @@ struct w83792d_data {
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	/* array of 2 pointers to subclients */
-	struct i2c_client *lm75[2];
-
 	u8 in[9];		/* Register value */
 	u8 in_max[9];		/* Register value */
 	u8 in_min[9];		/* Register value */
@@ -927,7 +924,6 @@ w83792d_detect_subclients(struct i2c_client *new_client)
 	int address = new_client->addr;
 	u8 val;
 	struct i2c_adapter *adapter = new_client->adapter;
-	struct w83792d_data *data = i2c_get_clientdata(new_client);
 
 	id = i2c_adapter_id(adapter);
 	if (force_subclients[0] == id && force_subclients[1] == address) {
@@ -946,21 +942,19 @@ w83792d_detect_subclients(struct i2c_client *new_client)
 	}
 
 	val = w83792d_read_value(new_client, W83792D_REG_I2C_SUBADDR);
-	if (!(val & 0x08))
-		data->lm75[0] = devm_i2c_new_dummy_device(&new_client->dev, adapter,
-							  0x48 + (val & 0x7));
-	if (!(val & 0x80)) {
-		if (!IS_ERR(data->lm75[0]) &&
-			((val & 0x7) == ((val >> 4) & 0x7))) {
-			dev_err(&new_client->dev,
-				"duplicate addresses 0x%x, use force_subclient\n",
-				data->lm75[0]->addr);
-			return -ENODEV;
-		}
-		data->lm75[1] = devm_i2c_new_dummy_device(&new_client->dev, adapter,
-							  0x48 + ((val >> 4) & 0x7));
+
+	if (!(val & 0x88) && (val & 0x7) == ((val >> 4) & 0x7)) {
+		dev_err(&new_client->dev,
+			"duplicate addresses 0x%x, use force_subclient\n", 0x48 + (val & 0x7));
+		return -ENODEV;
 	}
 
+	if (!(val & 0x08))
+		devm_i2c_new_dummy_device(&new_client->dev, adapter, 0x48 + (val & 0x7));
+
+	if (!(val & 0x80))
+		devm_i2c_new_dummy_device(&new_client->dev, adapter, 0x48 + ((val >> 4) & 0x7));
+
 	return 0;
 }
 
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index e7d0484eabe4..1d2854de1cfc 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -202,7 +202,6 @@ static inline s8 TEMP_TO_REG(long val, s8 min, s8 max)
 }
 
 struct w83793_data {
-	struct i2c_client *lm75[2];
 	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
@@ -1566,7 +1565,6 @@ w83793_detect_subclients(struct i2c_client *client)
 	int address = client->addr;
 	u8 tmp;
 	struct i2c_adapter *adapter = client->adapter;
-	struct w83793_data *data = i2c_get_clientdata(client);
 
 	id = i2c_adapter_id(adapter);
 	if (force_subclients[0] == id && force_subclients[1] == address) {
@@ -1586,21 +1584,19 @@ w83793_detect_subclients(struct i2c_client *client)
 	}
 
 	tmp = w83793_read_value(client, W83793_REG_I2C_SUBADDR);
-	if (!(tmp & 0x08))
-		data->lm75[0] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + (tmp & 0x7));
-	if (!(tmp & 0x80)) {
-		if (!IS_ERR(data->lm75[0])
-		    && ((tmp & 0x7) == ((tmp >> 4) & 0x7))) {
-			dev_err(&client->dev,
-				"duplicate addresses 0x%x, "
-				"use force_subclients\n", data->lm75[0]->addr);
-			return -ENODEV;
-		}
-		data->lm75[1] = devm_i2c_new_dummy_device(&client->dev, adapter,
-							  0x48 + ((tmp >> 4) & 0x7));
+
+	if (!(tmp & 0x88) && (tmp & 0x7) == ((tmp >> 4) & 0x7)) {
+		dev_err(&client->dev,
+			"duplicate addresses 0x%x, use force_subclient\n", 0x48 + (tmp & 0x7));
+		return -ENODEV;
 	}
 
+	if (!(tmp & 0x08))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + (tmp & 0x7));
+
+	if (!(tmp & 0x80))
+		devm_i2c_new_dummy_device(&client->dev, adapter, 0x48 + ((tmp >> 4) & 0x7));
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5d3b8b8d163d..dbbacc8e9273 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1746,15 +1746,16 @@ static void cma_cancel_route(struct rdma_id_private *id_priv)
 	}
 }
 
-static void cma_cancel_listens(struct rdma_id_private *id_priv)
+static void _cma_cancel_listens(struct rdma_id_private *id_priv)
 {
 	struct rdma_id_private *dev_id_priv;
 
+	lockdep_assert_held(&lock);
+
 	/*
 	 * Remove from listen_any_list to prevent added devices from spawning
 	 * additional listen requests.
 	 */
-	mutex_lock(&lock);
 	list_del(&id_priv->list);
 
 	while (!list_empty(&id_priv->listen_list)) {
@@ -1768,6 +1769,12 @@ static void cma_cancel_listens(struct rdma_id_private *id_priv)
 		rdma_destroy_id(&dev_id_priv->id);
 		mutex_lock(&lock);
 	}
+}
+
+static void cma_cancel_listens(struct rdma_id_private *id_priv)
+{
+	mutex_lock(&lock);
+	_cma_cancel_listens(id_priv);
 	mutex_unlock(&lock);
 }
 
@@ -1776,6 +1783,14 @@ static void cma_cancel_operation(struct rdma_id_private *id_priv,
 {
 	switch (state) {
 	case RDMA_CM_ADDR_QUERY:
+		/*
+		 * We can avoid doing the rdma_addr_cancel() based on state,
+		 * only RDMA_CM_ADDR_QUERY has a work that could still execute.
+		 * Notice that the addr_handler work could still be exiting
+		 * outside this state, however due to the interaction with the
+		 * handler_mutex the work is guaranteed not to touch id_priv
+		 * during exit.
+		 */
 		rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
 		break;
 	case RDMA_CM_ROUTE_QUERY:
@@ -1810,6 +1825,8 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 static void destroy_mc(struct rdma_id_private *id_priv,
 		       struct cma_multicast *mc)
 {
+	bool send_only = mc->join_state == BIT(SENDONLY_FULLMEMBER_JOIN);
+
 	if (rdma_cap_ib_mcast(id_priv->id.device, id_priv->id.port_num))
 		ib_sa_free_multicast(mc->sa_mc);
 
@@ -1826,7 +1843,10 @@ static void destroy_mc(struct rdma_id_private *id_priv,
 
 			cma_set_mgid(id_priv, (struct sockaddr *)&mc->addr,
 				     &mgid);
-			cma_igmp_send(ndev, &mgid, false);
+
+			if (!send_only)
+				cma_igmp_send(ndev, &mgid, false);
+
 			dev_put(ndev);
 		}
 
@@ -2574,7 +2594,7 @@ static int cma_listen_on_all(struct rdma_id_private *id_priv)
 	return 0;
 
 err_listen:
-	list_del(&id_priv->list);
+	_cma_cancel_listens(id_priv);
 	mutex_unlock(&lock);
 	if (to_destroy)
 		rdma_destroy_id(&to_destroy->id);
@@ -3410,6 +3430,21 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		if (dst_addr->sa_family == AF_IB) {
 			ret = cma_resolve_ib_addr(id_priv);
 		} else {
+			/*
+			 * The FSM can return back to RDMA_CM_ADDR_BOUND after
+			 * rdma_resolve_ip() is called, eg through the error
+			 * path in addr_handler(). If this happens the existing
+			 * request must be canceled before issuing a new one.
+			 * Since canceling a request is a bit slow and this
+			 * oddball path is rare, keep track once a request has
+			 * been issued. The track turns out to be a permanent
+			 * state since this is the only cancel as it is
+			 * immediately before rdma_resolve_ip().
+			 */
+			if (id_priv->used_resolve_ip)
+				rdma_addr_cancel(&id->route.addr.dev_addr);
+			else
+				id_priv->used_resolve_ip = 1;
 			ret = rdma_resolve_ip(cma_src_addr(id_priv), dst_addr,
 					      &id->route.addr.dev_addr,
 					      timeout_ms, addr_handler,
@@ -3768,9 +3803,13 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 	int ret;
 
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN)) {
+		struct sockaddr_in any_in = {
+			.sin_family = AF_INET,
+			.sin_addr.s_addr = htonl(INADDR_ANY),
+		};
+
 		/* For a well behaved ULP state will be RDMA_CM_IDLE */
-		id->route.addr.src_addr.ss_family = AF_INET;
-		ret = rdma_bind_addr(id, cma_src_addr(id_priv));
+		ret = rdma_bind_addr(id, (struct sockaddr *)&any_in);
 		if (ret)
 			return ret;
 		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
diff --git a/drivers/infiniband/core/cma_priv.h b/drivers/infiniband/core/cma_priv.h
index 5c463da99845..f92f101ea981 100644
--- a/drivers/infiniband/core/cma_priv.h
+++ b/drivers/infiniband/core/cma_priv.h
@@ -91,6 +91,7 @@ struct rdma_id_private {
 	u8			afonly;
 	u8			timeout;
 	u8			min_rnr_timer;
+	u8 used_resolve_ip;
 	enum ib_gid_type	gid_type;
 
 	/*
diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 993f9838b6c8..e1fdeadda437 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -873,14 +873,14 @@ void hfi1_ipoib_tx_timeout(struct net_device *dev, unsigned int q)
 	struct hfi1_ipoib_txq *txq = &priv->txqs[q];
 	u64 completed = atomic64_read(&txq->complete_txreqs);
 
-	dd_dev_info(priv->dd, "timeout txq %llx q %u stopped %u stops %d no_desc %d ring_full %d\n",
-		    (unsigned long long)txq, q,
+	dd_dev_info(priv->dd, "timeout txq %p q %u stopped %u stops %d no_desc %d ring_full %d\n",
+		    txq, q,
 		    __netif_subqueue_stopped(dev, txq->q_idx),
 		    atomic_read(&txq->stops),
 		    atomic_read(&txq->no_desc),
 		    atomic_read(&txq->ring_full));
-	dd_dev_info(priv->dd, "sde %llx engine %u\n",
-		    (unsigned long long)txq->sde,
+	dd_dev_info(priv->dd, "sde %p engine %u\n",
+		    txq->sde,
 		    txq->sde ? txq->sde->this_idx : 0);
 	dd_dev_info(priv->dd, "flow %x\n", txq->flow.as_int);
 	dd_dev_info(priv->dd, "sent %llu completed %llu used %llu\n",
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 1e9c3c5bee68..d763f097599f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -326,19 +326,30 @@ static void set_cq_param(struct hns_roce_cq *hr_cq, u32 cq_entries, int vector,
 	INIT_LIST_HEAD(&hr_cq->rq_list);
 }
 
-static void set_cqe_size(struct hns_roce_cq *hr_cq, struct ib_udata *udata,
-			 struct hns_roce_ib_create_cq *ucmd)
+static int set_cqe_size(struct hns_roce_cq *hr_cq, struct ib_udata *udata,
+			struct hns_roce_ib_create_cq *ucmd)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(hr_cq->ib_cq.device);
 
-	if (udata) {
-		if (udata->inlen >= offsetofend(typeof(*ucmd), cqe_size))
-			hr_cq->cqe_size = ucmd->cqe_size;
-		else
-			hr_cq->cqe_size = HNS_ROCE_V2_CQE_SIZE;
-	} else {
+	if (!udata) {
 		hr_cq->cqe_size = hr_dev->caps.cqe_sz;
+		return 0;
+	}
+
+	if (udata->inlen >= offsetofend(typeof(*ucmd), cqe_size)) {
+		if (ucmd->cqe_size != HNS_ROCE_V2_CQE_SIZE &&
+		    ucmd->cqe_size != HNS_ROCE_V3_CQE_SIZE) {
+			ibdev_err(&hr_dev->ib_dev,
+				  "invalid cqe size %u.\n", ucmd->cqe_size);
+			return -EINVAL;
+		}
+
+		hr_cq->cqe_size = ucmd->cqe_size;
+	} else {
+		hr_cq->cqe_size = HNS_ROCE_V2_CQE_SIZE;
 	}
+
+	return 0;
 }
 
 int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
@@ -366,7 +377,9 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 
 	set_cq_param(hr_cq, attr->cqe, attr->comp_vector, &ucmd);
 
-	set_cqe_size(hr_cq, udata, &ucmd);
+	ret = set_cqe_size(hr_cq, udata, &ucmd);
+	if (ret)
+		return ret;
 
 	ret = alloc_cq_buf(hr_dev, hr_cq, udata, ucmd.buf_addr);
 	if (ret) {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c320891c8763..0ccb0c453f6a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3306,7 +3306,7 @@ static void __hns_roce_v2_cq_clean(struct hns_roce_cq *hr_cq, u32 qpn,
 			dest = get_cqe_v2(hr_cq, (prod_index + nfreed) &
 					  hr_cq->ib_cq.cqe);
 			owner_bit = hr_reg_read(dest, CQE_OWNER);
-			memcpy(dest, cqe, sizeof(*cqe));
+			memcpy(dest, cqe, hr_cq->cqe_size);
 			hr_reg_write(dest, CQE_OWNER, owner_bit);
 		}
 	}
@@ -4411,7 +4411,12 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	hr_qp->path_mtu = ib_mtu;
 
 	mtu = ib_mtu_enum_to_int(ib_mtu);
-	if (WARN_ON(mtu < 0))
+	if (WARN_ON(mtu <= 0))
+		return -EINVAL;
+#define MAX_LP_MSG_LEN 65536
+	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
+	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
+	if (WARN_ON(lp_pktn_ini >= 0xF))
 		return -EINVAL;
 
 	if (attr_mask & IB_QP_PATH_MTU) {
@@ -4419,10 +4424,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		hr_reg_clear(qpc_mask, QPC_MTU);
 	}
 
-#define MAX_LP_MSG_LEN 65536
-	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
-	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
-
 	hr_reg_write(context, QPC_LP_PKTN_INI, lp_pktn_ini);
 	hr_reg_clear(qpc_mask, QPC_LP_PKTN_INI);
 
diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 6b62299abfbb..6dea0a49d171 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3496,7 +3496,7 @@ static void irdma_cm_disconn_true(struct irdma_qp *iwqp)
 	     original_hw_tcp_state == IRDMA_TCP_STATE_TIME_WAIT ||
 	     last_ae == IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE ||
 	     last_ae == IRDMA_AE_BAD_CLOSE ||
-	     last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->reset)) {
+	     last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->rf->reset)) {
 		issue_close = 1;
 		iwqp->cm_id = NULL;
 		qp->term_flags = 0;
@@ -4250,7 +4250,7 @@ void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
 				       teardown_entry);
 		attr.qp_state = IB_QPS_ERR;
 		irdma_modify_qp(&cm_node->iwqp->ibqp, &attr, IB_QP_STATE, NULL);
-		if (iwdev->reset)
+		if (iwdev->rf->reset)
 			irdma_cm_disconn(cm_node->iwqp);
 		irdma_rem_ref_cm_node(cm_node);
 	}
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 00de5ee9a260..7de525a5ccf8 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -176,6 +176,14 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
 		qp->flush_code = FLUSH_GENERAL_ERR;
 		break;
+	case IRDMA_AE_LLP_TOO_MANY_RETRIES:
+		qp->flush_code = FLUSH_RETRY_EXC_ERR;
+		break;
+	case IRDMA_AE_AMP_MWBIND_INVALID_RIGHTS:
+	case IRDMA_AE_AMP_MWBIND_BIND_DISABLED:
+	case IRDMA_AE_AMP_MWBIND_INVALID_BOUNDS:
+		qp->flush_code = FLUSH_MW_BIND_ERR;
+		break;
 	default:
 		qp->flush_code = FLUSH_FATAL_ERR;
 		break;
@@ -1489,7 +1497,7 @@ void irdma_reinitialize_ieq(struct irdma_sc_vsi *vsi)
 
 	irdma_puda_dele_rsrc(vsi, IRDMA_PUDA_RSRC_TYPE_IEQ, false);
 	if (irdma_initialize_ieq(iwdev)) {
-		iwdev->reset = true;
+		iwdev->rf->reset = true;
 		rf->gen_ops.request_reset(rf);
 	}
 }
@@ -1632,13 +1640,13 @@ void irdma_rt_deinit_hw(struct irdma_device *iwdev)
 	case IEQ_CREATED:
 		if (!iwdev->roce_mode)
 			irdma_puda_dele_rsrc(&iwdev->vsi, IRDMA_PUDA_RSRC_TYPE_IEQ,
-					     iwdev->reset);
+					     iwdev->rf->reset);
 		fallthrough;
 	case ILQ_CREATED:
 		if (!iwdev->roce_mode)
 			irdma_puda_dele_rsrc(&iwdev->vsi,
 					     IRDMA_PUDA_RSRC_TYPE_ILQ,
-					     iwdev->reset);
+					     iwdev->rf->reset);
 		break;
 	default:
 		ibdev_warn(&iwdev->ibdev, "bad init_state = %d\n", iwdev->init_state);
diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
index bddf88194d09..d219f64b2c3d 100644
--- a/drivers/infiniband/hw/irdma/i40iw_if.c
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -55,7 +55,7 @@ static void i40iw_close(struct i40e_info *cdev_info, struct i40e_client *client,
 
 	iwdev = to_iwdev(ibdev);
 	if (reset)
-		iwdev->reset = true;
+		iwdev->rf->reset = true;
 
 	iwdev->iw_status = 0;
 	irdma_port_ibevent(iwdev);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 743d9e143a99..b678fe712447 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -346,7 +346,6 @@ struct irdma_device {
 	bool roce_mode:1;
 	bool roce_dcqcn_en:1;
 	bool dcb:1;
-	bool reset:1;
 	bool iw_ooo:1;
 	enum init_completion_state init_state;
 
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index ff705f323233..3dcbb1fbf2c6 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -102,6 +102,8 @@ enum irdma_flush_opcode {
 	FLUSH_REM_OP_ERR,
 	FLUSH_LOC_LEN_ERR,
 	FLUSH_FATAL_ERR,
+	FLUSH_RETRY_EXC_ERR,
+	FLUSH_MW_BIND_ERR,
 };
 
 enum irdma_cmpl_status {
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 5bbe44e54f9a..832e9604766b 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2510,7 +2510,7 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->reset)
+	if (qp->iwdev->rf->reset)
 		return;
 	attr.qp_state = IB_QPS_ERR;
 
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 717147ed0519..fa393c5ea397 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -535,8 +535,7 @@ static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	irdma_qp_rem_ref(&iwqp->ibqp);
 	wait_for_completion(&iwqp->free_qp);
 	irdma_free_lsmm_rsrc(iwqp);
-	if (!iwdev->reset)
-		irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
+	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
 
 	if (!iwqp->user_mode) {
 		if (iwqp->iwscq) {
@@ -2041,7 +2040,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		/* Kmode allocations */
 		int rsize;
 
-		if (entries > rf->max_cqe) {
+		if (entries < 1 || entries > rf->max_cqe) {
 			err_code = -EINVAL;
 			goto cq_free_rsrc;
 		}
@@ -3359,6 +3358,10 @@ static enum ib_wc_status irdma_flush_err_to_ib_wc_status(enum irdma_flush_opcode
 		return IB_WC_LOC_LEN_ERR;
 	case FLUSH_GENERAL_ERR:
 		return IB_WC_WR_FLUSH_ERR;
+	case FLUSH_RETRY_EXC_ERR:
+		return IB_WC_RETRY_EXC_ERR;
+	case FLUSH_MW_BIND_ERR:
+		return IB_WC_MW_BIND_ERR;
 	case FLUSH_FATAL_ERR:
 	default:
 		return IB_WC_FATAL_ERR;
diff --git a/drivers/interconnect/qcom/sdm660.c b/drivers/interconnect/qcom/sdm660.c
index 632dbdd21915..99eef7e2d326 100644
--- a/drivers/interconnect/qcom/sdm660.c
+++ b/drivers/interconnect/qcom/sdm660.c
@@ -44,9 +44,9 @@
 #define NOC_PERM_MODE_BYPASS		(1 << NOC_QOS_MODE_BYPASS)
 
 #define NOC_QOS_PRIORITYn_ADDR(n)	(0x8 + (n * 0x1000))
-#define NOC_QOS_PRIORITY_MASK		0xf
+#define NOC_QOS_PRIORITY_P1_MASK	0xc
+#define NOC_QOS_PRIORITY_P0_MASK	0x3
 #define NOC_QOS_PRIORITY_P1_SHIFT	0x2
-#define NOC_QOS_PRIORITY_P0_SHIFT	0x3
 
 #define NOC_QOS_MODEn_ADDR(n)		(0xc + (n * 0x1000))
 #define NOC_QOS_MODEn_MASK		0x3
@@ -307,7 +307,7 @@ DEFINE_QNODE(slv_bimc_cfg, SDM660_SLAVE_BIMC_CFG, 4, -1, 56, true, -1, 0, -1, 0)
 DEFINE_QNODE(slv_prng, SDM660_SLAVE_PRNG, 4, -1, 44, true, -1, 0, -1, 0);
 DEFINE_QNODE(slv_spdm, SDM660_SLAVE_SPDM, 4, -1, 60, true, -1, 0, -1, 0);
 DEFINE_QNODE(slv_qdss_cfg, SDM660_SLAVE_QDSS_CFG, 4, -1, 63, true, -1, 0, -1, 0);
-DEFINE_QNODE(slv_cnoc_mnoc_cfg, SDM660_SLAVE_BLSP_1, 4, -1, 66, true, -1, 0, -1, SDM660_MASTER_CNOC_MNOC_CFG);
+DEFINE_QNODE(slv_cnoc_mnoc_cfg, SDM660_SLAVE_CNOC_MNOC_CFG, 4, -1, 66, true, -1, 0, -1, SDM660_MASTER_CNOC_MNOC_CFG);
 DEFINE_QNODE(slv_snoc_cfg, SDM660_SLAVE_SNOC_CFG, 4, -1, 70, true, -1, 0, -1, 0);
 DEFINE_QNODE(slv_qm_cfg, SDM660_SLAVE_QM_CFG, 4, -1, 212, true, -1, 0, -1, 0);
 DEFINE_QNODE(slv_clk_ctl, SDM660_SLAVE_CLK_CTL, 4, -1, 47, true, -1, 0, -1, 0);
@@ -624,13 +624,12 @@ static int qcom_icc_noc_set_qos_priority(struct regmap *rmap,
 	/* Must be updated one at a time, P1 first, P0 last */
 	val = qos->areq_prio << NOC_QOS_PRIORITY_P1_SHIFT;
 	rc = regmap_update_bits(rmap, NOC_QOS_PRIORITYn_ADDR(qos->qos_port),
-				NOC_QOS_PRIORITY_MASK, val);
+				NOC_QOS_PRIORITY_P1_MASK, val);
 	if (rc)
 		return rc;
 
-	val = qos->prio_level << NOC_QOS_PRIORITY_P0_SHIFT;
 	return regmap_update_bits(rmap, NOC_QOS_PRIORITYn_ADDR(qos->qos_port),
-				  NOC_QOS_PRIORITY_MASK, val);
+				  NOC_QOS_PRIORITY_P0_MASK, qos->prio_level);
 }
 
 static int qcom_icc_set_noc_qos(struct icc_node *src, u64 max_bw)
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 20fa02c81070..9117874cbfdb 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -33,6 +33,7 @@ struct ipoctal_channel {
 	unsigned int			pointer_read;
 	unsigned int			pointer_write;
 	struct tty_port			tty_port;
+	bool				tty_registered;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
@@ -81,22 +82,34 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	return 0;
 }
 
-static int ipoctal_open(struct tty_struct *tty, struct file *file)
+static int ipoctal_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel = dev_get_drvdata(tty->dev);
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
-	int err;
-
-	tty->driver_data = channel;
+	int res;
 
 	if (!ipack_get_carrier(ipoctal->dev))
 		return -EBUSY;
 
-	err = tty_port_open(&channel->tty_port, tty, file);
-	if (err)
-		ipack_put_carrier(ipoctal->dev);
+	res = tty_standard_install(driver, tty);
+	if (res)
+		goto err_put_carrier;
+
+	tty->driver_data = channel;
+
+	return 0;
+
+err_put_carrier:
+	ipack_put_carrier(ipoctal->dev);
+
+	return res;
+}
+
+static int ipoctal_open(struct tty_struct *tty, struct file *file)
+{
+	struct ipoctal_channel *channel = tty->driver_data;
 
-	return err;
+	return tty_port_open(&channel->tty_port, tty, file);
 }
 
 static void ipoctal_reset_stats(struct ipoctal_stats *stats)
@@ -264,7 +277,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	int res;
 	int i;
 	struct tty_driver *tty;
-	char name[20];
 	struct ipoctal_channel *channel;
 	struct ipack_region *region;
 	void __iomem *addr;
@@ -355,8 +367,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	/* Fill struct tty_driver with ipoctal data */
 	tty->owner = THIS_MODULE;
 	tty->driver_name = KBUILD_MODNAME;
-	sprintf(name, KBUILD_MODNAME ".%d.%d.", bus_nr, slot);
-	tty->name = name;
+	tty->name = kasprintf(GFP_KERNEL, KBUILD_MODNAME ".%d.%d.", bus_nr, slot);
+	if (!tty->name) {
+		res = -ENOMEM;
+		goto err_put_driver;
+	}
 	tty->major = 0;
 
 	tty->minor_start = 0;
@@ -372,8 +387,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	res = tty_register_driver(tty);
 	if (res) {
 		dev_err(&ipoctal->dev->dev, "Can't register tty driver.\n");
-		put_tty_driver(tty);
-		return res;
+		goto err_free_name;
 	}
 
 	/* Save struct tty_driver for use it when uninstalling the device */
@@ -384,7 +398,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 		channel = &ipoctal->channel[i];
 		tty_port_init(&channel->tty_port);
-		tty_port_alloc_xmit_buf(&channel->tty_port);
+		res = tty_port_alloc_xmit_buf(&channel->tty_port);
+		if (res)
+			continue;
 		channel->tty_port.ops = &ipoctal_tty_port_ops;
 
 		ipoctal_reset_stats(&channel->stats);
@@ -392,13 +408,15 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		spin_lock_init(&channel->lock);
 		channel->pointer_read = 0;
 		channel->pointer_write = 0;
-		tty_dev = tty_port_register_device(&channel->tty_port, tty, i, NULL);
+		tty_dev = tty_port_register_device_attr(&channel->tty_port, tty,
+							i, NULL, channel, NULL);
 		if (IS_ERR(tty_dev)) {
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
+			tty_port_free_xmit_buf(&channel->tty_port);
 			tty_port_destroy(&channel->tty_port);
 			continue;
 		}
-		dev_set_drvdata(tty_dev, channel);
+		channel->tty_registered = true;
 	}
 
 	/*
@@ -410,6 +428,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 				       ipoctal_irq_handler, ipoctal);
 
 	return 0;
+
+err_free_name:
+	kfree(tty->name);
+err_put_driver:
+	put_tty_driver(tty);
+
+	return res;
 }
 
 static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
@@ -649,6 +674,7 @@ static void ipoctal_cleanup(struct tty_struct *tty)
 
 static const struct tty_operations ipoctal_fops = {
 	.ioctl =		NULL,
+	.install =		ipoctal_install,
 	.open =			ipoctal_open,
 	.close =		ipoctal_close,
 	.write =		ipoctal_write_tty,
@@ -691,12 +717,17 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	for (i = 0; i < NR_CHANNELS; i++) {
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
+
+		if (!channel->tty_registered)
+			continue;
+
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&channel->tty_port);
 		tty_port_destroy(&channel->tty_port);
 	}
 
 	tty_unregister_driver(ipoctal->tty_drv);
+	kfree(ipoctal->tty_drv->name);
 	put_tty_driver(ipoctal->tty_drv);
 	kfree(ipoctal);
 }
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d402e456f27d..7d0ab19c38bb 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1140,8 +1140,8 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			continue;
 		length = 0;
 		switch (c) {
-		/* SOF0: baseline JPEG */
-		case SOF0:
+		/* JPEG_MARKER_SOF0: baseline JPEG */
+		case JPEG_MARKER_SOF0:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
@@ -1172,7 +1172,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			notfound = 0;
 			break;
 
-		case DQT:
+		case JPEG_MARKER_DQT:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
@@ -1185,7 +1185,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			skip(&jpeg_buffer, length);
 			break;
 
-		case DHT:
+		case JPEG_MARKER_DHT:
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
@@ -1198,15 +1198,15 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			skip(&jpeg_buffer, length);
 			break;
 
-		case SOS:
+		case JPEG_MARKER_SOS:
 			sos = jpeg_buffer.curr - 2; /* 0xffda */
 			break;
 
 		/* skip payload-less markers */
-		case RST ... RST + 7:
-		case SOI:
-		case EOI:
-		case TEM:
+		case JPEG_MARKER_RST ... JPEG_MARKER_RST + 7:
+		case JPEG_MARKER_SOI:
+		case JPEG_MARKER_EOI:
+		case JPEG_MARKER_TEM:
 			break;
 
 		/* skip uninteresting payload markers */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index a77d93c098ce..8473a019bb5f 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -37,15 +37,15 @@
 #define EXYNOS3250_IRQ_TIMEOUT		0x10000000
 
 /* a selection of JPEG markers */
-#define TEM				0x01
-#define SOF0				0xc0
-#define DHT				0xc4
-#define RST				0xd0
-#define SOI				0xd8
-#define EOI				0xd9
-#define	SOS				0xda
-#define DQT				0xdb
-#define DHP				0xde
+#define JPEG_MARKER_TEM				0x01
+#define JPEG_MARKER_SOF0				0xc0
+#define JPEG_MARKER_DHT				0xc4
+#define JPEG_MARKER_RST				0xd0
+#define JPEG_MARKER_SOI				0xd8
+#define JPEG_MARKER_EOI				0xd9
+#define	JPEG_MARKER_SOS				0xda
+#define JPEG_MARKER_DQT				0xdb
+#define JPEG_MARKER_DHP				0xde
 
 /* Flags that indicate a format can be used for capture/output */
 #define SJPEG_FMT_FLAG_ENC_CAPTURE	(1 << 0)
@@ -187,11 +187,11 @@ struct s5p_jpeg_marker {
  * @fmt:	driver-specific format of this queue
  * @w:		image width
  * @h:		image height
- * @sos:	SOS marker's position relative to the buffer beginning
- * @dht:	DHT markers' positions relative to the buffer beginning
- * @dqt:	DQT markers' positions relative to the buffer beginning
- * @sof:	SOF0 marker's position relative to the buffer beginning
- * @sof_len:	SOF0 marker's payload length (without length field itself)
+ * @sos:	JPEG_MARKER_SOS's position relative to the buffer beginning
+ * @dht:	JPEG_MARKER_DHT' positions relative to the buffer beginning
+ * @dqt:	JPEG_MARKER_DQT' positions relative to the buffer beginning
+ * @sof:	JPEG_MARKER_SOF0's position relative to the buffer beginning
+ * @sof_len:	JPEG_MARKER_SOF0's payload length (without length field itself)
  * @size:	image buffer size in bytes
  */
 struct s5p_jpeg_q_data {
diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 3e729a17b35f..48d52baec1a1 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -24,6 +24,7 @@ static const u8 COMMAND_VERSION[] = { 'v' };
 // End transmit and repeat reset command so we exit sump mode
 static const u8 COMMAND_RESET[] = { 0xff, 0xff, 0, 0, 0, 0, 0 };
 static const u8 COMMAND_SMODE_ENTER[] = { 's' };
+static const u8 COMMAND_SMODE_EXIT[] = { 0 };
 static const u8 COMMAND_TXSTART[] = { 0x26, 0x24, 0x25, 0x03 };
 
 #define REPLY_XMITCOUNT 't'
@@ -309,12 +310,30 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 		buf[i] = cpu_to_be16(v);
 	}
 
-	buf[count] = cpu_to_be16(0xffff);
+	buf[count] = 0xffff;
 
 	irtoy->tx_buf = buf;
 	irtoy->tx_len = size;
 	irtoy->emitted = 0;
 
+	// There is an issue where if the unit is receiving IR while the
+	// first TXSTART command is sent, the device might end up hanging
+	// with its led on. It does not respond to any command when this
+	// happens. To work around this, re-enter sample mode.
+	err = irtoy_command(irtoy, COMMAND_SMODE_EXIT,
+			    sizeof(COMMAND_SMODE_EXIT), STATE_RESET);
+	if (err) {
+		dev_err(irtoy->dev, "exit sample mode: %d\n", err);
+		return err;
+	}
+
+	err = irtoy_command(irtoy, COMMAND_SMODE_ENTER,
+			    sizeof(COMMAND_SMODE_ENTER), STATE_COMMAND);
+	if (err) {
+		dev_err(irtoy->dev, "enter sample mode: %d\n", err);
+		return err;
+	}
+
 	err = irtoy_command(irtoy, COMMAND_TXSTART, sizeof(COMMAND_TXSTART),
 			    STATE_TX);
 	kfree(buf);
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index e49ca0f7fe9a..1543a5dd9425 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -582,6 +582,8 @@ static void renesas_sdhi_reset(struct tmio_mmc_host *host)
 		/* Unknown why but without polling reset status, it will hang */
 		read_poll_timeout(reset_control_status, ret, ret == 0, 1, 100,
 				  false, priv->rstc);
+		/* At least SDHI_VER_GEN2_SDR50 needs manual release of reset */
+		sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
 		priv->needs_adjust_hs400 = false;
 		renesas_sdhi_set_clock(host, host->clk_cache);
 	} else if (priv->scc_ctl) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1c122a1f2f97..66b4f4a9832a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2775,8 +2775,8 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Port Control 2: don't force a good FCS, set the maximum frame size to
-	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
+	/* Port Control 2: don't force a good FCS, set the MTU size to
+	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
 	 * received packets as usual, disable ARP mirroring and don't send a
 	 * copy of all transmitted/received frames on this port to the CPU.
@@ -2795,7 +2795,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		return err;
 
 	if (chip->info->ops->port_set_jumbo_size) {
-		err = chip->info->ops->port_set_jumbo_size(chip, port, 10240);
+		err = chip->info->ops->port_set_jumbo_size(chip, port, 10218);
 		if (err)
 			return err;
 	}
@@ -2885,10 +2885,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	if (chip->info->ops->port_set_jumbo_size)
-		return 10240;
+		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632;
-	return 1522;
+		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -2896,6 +2896,9 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+		new_mtu += EDSA_HLEN;
+
 	mv88e6xxx_reg_lock(chip);
 	if (chip->info->ops->port_set_jumbo_size)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
@@ -3657,7 +3660,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3682,6 +3684,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_validate = mv88e6185_phylink_validate,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6165_ops = {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 675b1f3e43b7..59f316cc8583 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -18,6 +18,7 @@
 #include <linux/timecounter.h>
 #include <net/dsa.h>
 
+#define EDSA_HLEN		8
 #define MV88E6XXX_N_FID		4096
 
 /* PVT limits for 4-bit port and 5-bit switch */
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 815b0f681d69..5848112036b0 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -232,6 +232,8 @@ int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu)
 	u16 val;
 	int err;
 
+	mtu += ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &val);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f77e2ee64a60..451028c57af8 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1277,6 +1277,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 	u16 reg;
 	int err;
 
+	size += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c84f6c226743..cf00709caea4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -541,8 +541,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 
 	if (phy_interface_mode_is_rgmii(phy_mode)) {
 		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
-		val &= ~ENETC_PM0_IFM_EN_AUTO;
-		val &= ENETC_PM0_IFM_IFMODE_MASK;
+		val &= ~(ENETC_PM0_IFM_EN_AUTO | ENETC_PM0_IFM_IFMODE_MASK);
 		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e0b7c3c44e7b..32987bd134a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -750,7 +750,6 @@ struct hnae3_tc_info {
 	u8 prio_tc[HNAE3_MAX_USER_PRIO]; /* TC indexed by prio */
 	u16 tqp_count[HNAE3_MAX_TC];
 	u16 tqp_offset[HNAE3_MAX_TC];
-	unsigned long tc_en; /* bitmap of TC enabled */
 	u8 num_tc; /* Total number of enabled TCs */
 	bool mqprio_active;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9faa3712ea5b..114692c4f797 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -620,13 +620,9 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 			return ret;
 		}
 
-		for (i = 0; i < HNAE3_MAX_TC; i++) {
-			if (!test_bit(i, &tc_info->tc_en))
-				continue;
-
+		for (i = 0; i < tc_info->num_tc; i++)
 			netdev_set_tc_queue(netdev, i, tc_info->tqp_count[i],
 					    tc_info->tqp_offset[i]);
-		}
 	}
 
 	ret = netif_set_real_num_tx_queues(netdev, queue_size);
@@ -776,6 +772,11 @@ static int hns3_nic_net_open(struct net_device *netdev)
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
+	if (!test_bit(HNS3_NIC_STATE_DOWN, &priv->state)) {
+		netdev_warn(netdev, "net open repeatedly!\n");
+		return 0;
+	}
+
 	netif_carrier_off(netdev);
 
 	ret = hns3_nic_set_real_num_queue(netdev);
@@ -4825,12 +4826,9 @@ static void hns3_init_tx_ring_tc(struct hns3_nic_priv *priv)
 	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
 	int i;
 
-	for (i = 0; i < HNAE3_MAX_TC; i++) {
+	for (i = 0; i < tc_info->num_tc; i++) {
 		int j;
 
-		if (!test_bit(i, &tc_info->tc_en))
-			continue;
-
 		for (j = 0; j < tc_info->tqp_count[i]; j++) {
 			struct hnae3_queue *q;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82061ab6930f..83ee0f41322c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -312,33 +312,8 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 	return ret_val;
 }
 
-/**
- * hns3_self_test - self test
- * @ndev: net device
- * @eth_test: test cmd
- * @data: test result
- */
-static void hns3_self_test(struct net_device *ndev,
-			   struct ethtool_test *eth_test, u64 *data)
+static void hns3_set_selftest_param(struct hnae3_handle *h, int (*st_param)[2])
 {
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hnae3_handle *h = priv->ae_handle;
-	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
-	bool if_running = netif_running(ndev);
-	int test_index = 0;
-	u32 i;
-
-	if (hns3_nic_resetting(ndev)) {
-		netdev_err(ndev, "dev resetting!");
-		return;
-	}
-
-	/* Only do offline selftest, or pass by default */
-	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
-		return;
-
-	netif_dbg(h, drv, ndev, "self test start");
-
 	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
 	st_param[HNAE3_LOOP_APP][1] =
 			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
@@ -355,13 +330,26 @@ static void hns3_self_test(struct net_device *ndev,
 	st_param[HNAE3_LOOP_PHY][0] = HNAE3_LOOP_PHY;
 	st_param[HNAE3_LOOP_PHY][1] =
 			h->flags & HNAE3_SUPPORT_PHY_LOOPBACK;
+}
+
+static void hns3_selftest_prepare(struct net_device *ndev,
+				  bool if_running, int (*st_param)[2])
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test start\n");
+
+	hns3_set_selftest_param(h, st_param);
 
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
-	if (h->ae_algo->ops->enable_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter &&
+	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -373,6 +361,36 @@ static void hns3_self_test(struct net_device *ndev,
 		h->ae_algo->ops->halt_autoneg(h, true);
 
 	set_bit(HNS3_NIC_STATE_TESTING, &priv->state);
+}
+
+static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+
+	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
+
+	if (h->ae_algo->ops->halt_autoneg)
+		h->ae_algo->ops->halt_autoneg(h, false);
+
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
+	if (h->ae_algo->ops->enable_vlan_filter &&
+	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		h->ae_algo->ops->enable_vlan_filter(h, true);
+#endif
+
+	if (if_running)
+		ndev->netdev_ops->ndo_open(ndev);
+
+	if (netif_msg_ifdown(h))
+		netdev_info(ndev, "self test end\n");
+}
+
+static void hns3_do_selftest(struct net_device *ndev, int (*st_param)[2],
+			     struct ethtool_test *eth_test, u64 *data)
+{
+	int test_index = 0;
+	u32 i;
 
 	for (i = 0; i < HNS3_SELF_TEST_TYPE_NUM; i++) {
 		enum hnae3_loop loop_type = (enum hnae3_loop)st_param[i][0];
@@ -391,21 +409,32 @@ static void hns3_self_test(struct net_device *ndev,
 
 		test_index++;
 	}
+}
 
-	clear_bit(HNS3_NIC_STATE_TESTING, &priv->state);
-
-	if (h->ae_algo->ops->halt_autoneg)
-		h->ae_algo->ops->halt_autoneg(h, false);
+/**
+ * hns3_nic_self_test - self test
+ * @ndev: net device
+ * @eth_test: test cmd
+ * @data: test result
+ */
+static void hns3_self_test(struct net_device *ndev,
+			   struct ethtool_test *eth_test, u64 *data)
+{
+	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
+	bool if_running = netif_running(ndev);
 
-#if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (h->ae_algo->ops->enable_vlan_filter)
-		h->ae_algo->ops->enable_vlan_filter(h, true);
-#endif
+	if (hns3_nic_resetting(ndev)) {
+		netdev_err(ndev, "dev resetting!");
+		return;
+	}
 
-	if (if_running)
-		ndev->netdev_ops->ndo_open(ndev);
+	/* Only do offline selftest, or pass by default */
+	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
+		return;
 
-	netif_dbg(h, drv, ndev, "self test end\n");
+	hns3_selftest_prepare(ndev, if_running, st_param);
+	hns3_do_selftest(ndev, st_param, eth_test, data);
+	hns3_selftest_restore(ndev, if_running);
 }
 
 static void hns3_update_limit_promisc_mode(struct net_device *netdev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index eb748aa35952..0f0bf3d503bf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -472,7 +472,7 @@ int hclge_cmd_queue_init(struct hclge_dev *hdev)
 	return ret;
 }
 
-static int hclge_firmware_compat_config(struct hclge_dev *hdev)
+static int hclge_firmware_compat_config(struct hclge_dev *hdev, bool en)
 {
 	struct hclge_firmware_compat_cmd *req;
 	struct hclge_desc desc;
@@ -480,13 +480,16 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_COMPAT_CFG, false);
 
-	req = (struct hclge_firmware_compat_cmd *)desc.data;
+	if (en) {
+		req = (struct hclge_firmware_compat_cmd *)desc.data;
 
-	hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
-	hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
-	if (hnae3_dev_phy_imp_supported(hdev))
-		hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
-	req->compat = cpu_to_le32(compat);
+		hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
+		if (hnae3_dev_phy_imp_supported(hdev))
+			hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
+
+		req->compat = cpu_to_le32(compat);
+	}
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
@@ -543,7 +546,7 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	/* ask the firmware to enable some features, driver can work without
 	 * it.
 	 */
-	ret = hclge_firmware_compat_config(hdev);
+	ret = hclge_firmware_compat_config(hdev, true);
 	if (ret)
 		dev_warn(&hdev->pdev->dev,
 			 "Firmware compatible features not enabled(%d).\n",
@@ -573,6 +576,8 @@ static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
 
 void hclge_cmd_uninit(struct hclge_dev *hdev)
 {
+	hclge_firmware_compat_config(hdev, false);
+
 	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 	/* wait to ensure that the firmware completes the possible left
 	 * over commands.
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 39f56f245d84..c90bfde2aecf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -224,6 +224,10 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	}
 
 	hclge_tm_schd_info_update(hdev, num_tc);
+	if (num_tc > 1)
+		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
+	else
+		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
 
 	ret = hclge_ieee_ets_to_tm_info(hdev, ets);
 	if (ret)
@@ -285,8 +289,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	u8 i, j, pfc_map, *prio_tc;
 	int ret;
 
-	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
-	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
+	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
 		return -EINVAL;
 
 	if (pfc->pfc_en == hdev->tm_info.pfc_en)
@@ -420,8 +423,6 @@ static int hclge_mqprio_qopt_check(struct hclge_dev *hdev,
 static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
 				   struct tc_mqprio_qopt_offload *mqprio_qopt)
 {
-	int i;
-
 	memset(tc_info, 0, sizeof(*tc_info));
 	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
 	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
@@ -430,9 +431,6 @@ static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
 	       sizeof_field(struct hnae3_tc_info, tqp_count));
 	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
 	       sizeof_field(struct hnae3_tc_info, tqp_offset));
-
-	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
-		set_bit(tc_info->prio_tc[i], &tc_info->tc_en);
 }
 
 static int hclge_config_tc(struct hclge_dev *hdev,
@@ -498,12 +496,17 @@ static int hclge_setup_tc(struct hnae3_handle *h,
 	return hclge_notify_init_up(hdev);
 
 err_out:
-	/* roll-back */
-	memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
-	if (hclge_config_tc(hdev, &kinfo->tc_info))
-		dev_err(&hdev->pdev->dev,
-			"failed to roll back tc configuration\n");
-
+	if (!tc) {
+		dev_warn(&hdev->pdev->dev,
+			 "failed to destroy mqprio, will active after reset, ret = %d\n",
+			 ret);
+	} else {
+		/* roll-back */
+		memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
+		if (hclge_config_tc(hdev, &kinfo->tc_info))
+			dev_err(&hdev->pdev->dev,
+				"failed to roll back tc configuration\n");
+	}
 	hclge_notify_init_up(hdev);
 
 	return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 90a72c79fec9..9920e76b4f41 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8701,15 +8701,8 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	}
 
 	/* check if we just hit the duplicate */
-	if (!ret) {
-		dev_warn(&hdev->pdev->dev, "VF %u mac(%pM) exists\n",
-			 vport->vport_id, addr);
-		return 0;
-	}
-
-	dev_err(&hdev->pdev->dev,
-		"PF failed to add unicast entry(%pM) in the MAC table\n",
-		addr);
+	if (!ret)
+		return -EEXIST;
 
 	return ret;
 }
@@ -8861,7 +8854,13 @@ static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
 		} else {
 			set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 				&vport->state);
-			break;
+
+			/* If one unicast mac address is existing in hardware,
+			 * we need to try whether other unicast mac addresses
+			 * are new addresses that can be added.
+			 */
+			if (ret != -EEXIST)
+				break;
 		}
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 44618cc4cca1..f314dbd3ce11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -687,12 +687,10 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		if (hdev->hw_tc_map & BIT(i) && i < kinfo->tc_info.num_tc) {
-			set_bit(i, &kinfo->tc_info.tc_en);
 			kinfo->tc_info.tqp_offset[i] = i * kinfo->rss_size;
 			kinfo->tc_info.tqp_count[i] = kinfo->rss_size;
 		} else {
 			/* Set to default queue if TC is disable */
-			clear_bit(i, &kinfo->tc_info.tc_en);
 			kinfo->tc_info.tqp_offset[i] = 0;
 			kinfo->tc_info.tqp_count[i] = 1;
 		}
@@ -729,14 +727,6 @@ static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
 		hdev->tm_info.prio_tc[i] =
 			(i >= hdev->tm_info.num_tc) ? 0 : i;
-
-	/* DCB is enabled if we have more than 1 TC or pfc_en is
-	 * non-zero.
-	 */
-	if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
 }
 
 static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
@@ -767,10 +757,10 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 
 static void hclge_update_fc_mode_by_dcb_flag(struct hclge_dev *hdev)
 {
-	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE)) {
+	if (hdev->tm_info.num_tc == 1 && !hdev->tm_info.pfc_en) {
 		if (hdev->fc_mode_last_time == HCLGE_FC_PFC)
 			dev_warn(&hdev->pdev->dev,
-				 "DCB is disable, but last mode is FC_PFC\n");
+				 "Only 1 tc used, but last mode is FC_PFC\n");
 
 		hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
 	} else if (hdev->tm_info.fc_mode != HCLGE_FC_PFC) {
@@ -796,7 +786,7 @@ static void hclge_update_fc_mode(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_pfc_info_init(struct hclge_dev *hdev)
+void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
 {
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		hclge_update_fc_mode(hdev);
@@ -812,7 +802,7 @@ static void hclge_tm_schd_info_init(struct hclge_dev *hdev)
 
 	hclge_tm_vport_info_update(hdev);
 
-	hclge_pfc_info_init(hdev);
+	hclge_tm_pfc_info_update(hdev);
 }
 
 static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
@@ -1558,19 +1548,6 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc)
 	hclge_tm_schd_info_init(hdev);
 }
 
-void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
-{
-	/* DCB is enabled if we have more than 1 TC or pfc_en is
-	 * non-zero.
-	 */
-	if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
-
-	hclge_pfc_info_init(hdev);
-}
-
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init)
 {
 	int ret;
@@ -1616,7 +1593,7 @@ int hclge_tm_vport_map_update(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE))
+	if (hdev->tm_info.num_tc == 1 && !hdev->tm_info.pfc_en)
 		return 0;
 
 	return hclge_tm_bp_setup(hdev);
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1b0958bd24f6..1fa68ebe9432 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2437,11 +2437,15 @@ static void e100_get_drvinfo(struct net_device *netdev,
 		sizeof(info->bus_info));
 }
 
-#define E100_PHY_REGS 0x1C
+#define E100_PHY_REGS 0x1D
 static int e100_get_regs_len(struct net_device *netdev)
 {
 	struct nic *nic = netdev_priv(netdev);
-	return 1 + E100_PHY_REGS + sizeof(nic->mem->dump_buf);
+
+	/* We know the number of registers, and the size of the dump buffer.
+	 * Calculate the total size in bytes.
+	 */
+	return (1 + E100_PHY_REGS) * sizeof(u32) + sizeof(nic->mem->dump_buf);
 }
 
 static void e100_get_regs(struct net_device *netdev,
@@ -2455,14 +2459,18 @@ static void e100_get_regs(struct net_device *netdev,
 	buff[0] = ioread8(&nic->csr->scb.cmd_hi) << 24 |
 		ioread8(&nic->csr->scb.cmd_lo) << 16 |
 		ioread16(&nic->csr->scb.status);
-	for (i = E100_PHY_REGS; i >= 0; i--)
-		buff[1 + E100_PHY_REGS - i] =
-			mdio_read(netdev, nic->mii.phy_id, i);
+	for (i = 0; i < E100_PHY_REGS; i++)
+		/* Note that we read the registers in reverse order. This
+		 * ordering is the ABI apparently used by ethtool and other
+		 * applications.
+		 */
+		buff[1 + i] = mdio_read(netdev, nic->mii.phy_id,
+					E100_PHY_REGS - 1 - i);
 	memset(nic->mem->dump_buf, 0, sizeof(nic->mem->dump_buf));
 	e100_exec_cb(nic, NULL, e100_dump);
 	msleep(10);
-	memcpy(&buff[2 + E100_PHY_REGS], nic->mem->dump_buf,
-		sizeof(nic->mem->dump_buf));
+	memcpy(&buff[1 + E100_PHY_REGS], nic->mem->dump_buf,
+	       sizeof(nic->mem->dump_buf));
 }
 
 static void e100_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 4ceaca0f6ce3..21321d164708 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3204,7 +3204,7 @@ static unsigned int ixgbe_max_channels(struct ixgbe_adapter *adapter)
 		max_combined = ixgbe_max_rss_indices(adapter);
 	}
 
-	return max_combined;
+	return min_t(int, max_combined, num_online_cpus());
 }
 
 static void ixgbe_get_channels(struct net_device *dev,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 14aea40da50f..77350e5fdf97 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10112,6 +10112,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 	bool need_reset;
+	int num_queues;
 
 	if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
 		return -EINVAL;
@@ -10161,11 +10162,14 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	/* Kick start the NAPI context if there is an AF_XDP socket open
 	 * on that queue id. This so that receiving will start.
 	 */
-	if (need_reset && prog)
-		for (i = 0; i < adapter->num_rx_queues; i++)
+	if (need_reset && prog) {
+		num_queues = min_t(int, adapter->num_rx_queues,
+				   adapter->num_xdp_queues);
+		for (i = 0; i < num_queues; i++)
 			if (adapter->xdp_ring[i]->xsk_pool)
 				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
 						       XDP_WAKEUP_RX);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 1e672bc36c4d..a6878e5f922a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1272,7 +1272,6 @@ static void mlx4_en_do_set_rx_mode(struct work_struct *work)
 	if (!netif_carrier_ok(dev)) {
 		if (!mlx4_en_QUERY_PORT(mdev, priv->port)) {
 			if (priv->port_state.link_state) {
-				priv->last_link_state = MLX4_DEV_EVENT_PORT_UP;
 				netif_carrier_on(dev);
 				en_dbg(LINK, priv, "Link Up\n");
 			}
@@ -1560,26 +1559,36 @@ static void mlx4_en_service_task(struct work_struct *work)
 	mutex_unlock(&mdev->state_lock);
 }
 
-static void mlx4_en_linkstate(struct work_struct *work)
+static void mlx4_en_linkstate(struct mlx4_en_priv *priv)
+{
+	struct mlx4_en_port_state *port_state = &priv->port_state;
+	struct mlx4_en_dev *mdev = priv->mdev;
+	struct net_device *dev = priv->dev;
+	bool up;
+
+	if (mlx4_en_QUERY_PORT(mdev, priv->port))
+		port_state->link_state = MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN;
+
+	up = port_state->link_state == MLX4_PORT_STATE_DEV_EVENT_PORT_UP;
+	if (up == netif_carrier_ok(dev))
+		netif_carrier_event(dev);
+	if (!up) {
+		en_info(priv, "Link Down\n");
+		netif_carrier_off(dev);
+	} else {
+		en_info(priv, "Link Up\n");
+		netif_carrier_on(dev);
+	}
+}
+
+static void mlx4_en_linkstate_work(struct work_struct *work)
 {
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
 						 linkstate_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
-	int linkstate = priv->link_state;
 
 	mutex_lock(&mdev->state_lock);
-	/* If observable port state changed set carrier state and
-	 * report to system log */
-	if (priv->last_link_state != linkstate) {
-		if (linkstate == MLX4_DEV_EVENT_PORT_DOWN) {
-			en_info(priv, "Link Down\n");
-			netif_carrier_off(priv->dev);
-		} else {
-			en_info(priv, "Link Up\n");
-			netif_carrier_on(priv->dev);
-		}
-	}
-	priv->last_link_state = linkstate;
+	mlx4_en_linkstate(priv);
 	mutex_unlock(&mdev->state_lock);
 }
 
@@ -2082,9 +2091,11 @@ static int mlx4_en_open(struct net_device *dev)
 	mlx4_en_clear_stats(dev);
 
 	err = mlx4_en_start_port(dev);
-	if (err)
+	if (err) {
 		en_err(priv, "Failed starting port:%d\n", priv->port);
-
+		goto out;
+	}
+	mlx4_en_linkstate(priv);
 out:
 	mutex_unlock(&mdev->state_lock);
 	return err;
@@ -3171,7 +3182,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	spin_lock_init(&priv->stats_lock);
 	INIT_WORK(&priv->rx_mode_task, mlx4_en_do_set_rx_mode);
 	INIT_WORK(&priv->restart_task, mlx4_en_restart);
-	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate);
+	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate_work);
 	INIT_DELAYED_WORK(&priv->stats_task, mlx4_en_do_get_stats);
 	INIT_DELAYED_WORK(&priv->service_task, mlx4_en_service_task);
 #ifdef CONFIG_RFS_ACCEL
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index f3d1a20201ef..6bf558c5ec10 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -552,7 +552,6 @@ struct mlx4_en_priv {
 
 	struct mlx4_hwq_resources res;
 	int link_state;
-	int last_link_state;
 	bool port_up;
 	int port;
 	int registered;
diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 5cc00d22c708..6ecc4eb30e74 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -4,8 +4,6 @@
 #
 
 obj-$(CONFIG_KS8842) += ks8842.o
-obj-$(CONFIG_KS8851) += ks8851.o
-ks8851-objs = ks8851_common.o ks8851_spi.o
-obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
-ks8851_mll-objs = ks8851_common.o ks8851_par.o
+obj-$(CONFIG_KS8851) += ks8851_common.o ks8851_spi.o
+obj-$(CONFIG_KS8851_MLL) += ks8851_common.o ks8851_par.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 831518466de2..0f9c5457b93e 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1057,6 +1057,7 @@ int ks8851_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_suspend);
 
 int ks8851_resume(struct device *dev)
 {
@@ -1070,6 +1071,7 @@ int ks8851_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_resume);
 #endif
 
 static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
@@ -1243,6 +1245,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 err_reg_io:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ks8851_probe_common);
 
 int ks8851_remove_common(struct device *dev)
 {
@@ -1261,3 +1264,8 @@ int ks8851_remove_common(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_remove_common);
+
+MODULE_DESCRIPTION("KS8851 Network driver");
+MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 58a854666c62..c14de5fcedea 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -380,15 +380,6 @@ static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
 					  &ionic_dbg_intr_stats_desc[i]);
 		(*buf)++;
 	}
-	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->napi_stats,
-					  &ionic_dbg_napi_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-		**buf = txqcq->napi_stats.work_done_cntr[i];
-		(*buf)++;
-	}
 	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
 		**buf = txstats->sg_cntr[i];
 		(*buf)++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2218bc3a624b..86151a817b79 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -486,6 +486,10 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
 		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
 				     eee_tw_timer);
+		if (priv->hw->xpcs)
+			xpcs_config_eee(priv->hw->xpcs,
+					priv->plat->mult_fact_100ns,
+					true);
 	}
 
 	if (priv->plat->has_gmac4 && priv->tx_lpi_timer <= STMMAC_ET_MAX) {
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index e60e38c1f09d..5e49f7a919b6 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -337,7 +337,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	/* Start MHI channels */
 	err = mhi_prepare_for_transfer(mhi_dev);
 	if (err)
-		goto out_err;
+		return err;
 
 	/* Number of transfer descriptors determines size of the queue */
 	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
@@ -347,7 +347,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	else
 		err = register_netdev(ndev);
 	if (err)
-		goto out_err;
+		return err;
 
 	if (mhi_netdev->proto) {
 		err = mhi_netdev->proto->init(mhi_netdev);
@@ -359,8 +359,6 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 
 out_err_proto:
 	unregister_netdevice(ndev);
-out_err:
-	free_netdev(ndev);
 	return err;
 }
 
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index e79297a4bae8..27b6a3f507ae 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -27,7 +27,12 @@
 #define MII_BCM7XXX_SHD_2_ADDR_CTRL	0xe
 #define MII_BCM7XXX_SHD_2_CTRL_STAT	0xf
 #define MII_BCM7XXX_SHD_2_BIAS_TRIM	0x1a
+#define MII_BCM7XXX_SHD_3_PCS_CTRL	0x0
+#define MII_BCM7XXX_SHD_3_PCS_STATUS	0x1
+#define MII_BCM7XXX_SHD_3_EEE_CAP	0x2
 #define MII_BCM7XXX_SHD_3_AN_EEE_ADV	0x3
+#define MII_BCM7XXX_SHD_3_EEE_LP	0x4
+#define MII_BCM7XXX_SHD_3_EEE_WK_ERR	0x5
 #define MII_BCM7XXX_SHD_3_PCS_CTRL_2	0x6
 #define  MII_BCM7XXX_PCS_CTRL_2_DEF	0x4400
 #define MII_BCM7XXX_SHD_3_AN_STAT	0xb
@@ -216,25 +221,37 @@ static int bcm7xxx_28nm_resume(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
-static int phy_set_clr_bits(struct phy_device *dev, int location,
-					int set_mask, int clr_mask)
+static int __phy_set_clr_bits(struct phy_device *dev, int location,
+			      int set_mask, int clr_mask)
 {
 	int v, ret;
 
-	v = phy_read(dev, location);
+	v = __phy_read(dev, location);
 	if (v < 0)
 		return v;
 
 	v &= ~clr_mask;
 	v |= set_mask;
 
-	ret = phy_write(dev, location, v);
+	ret = __phy_write(dev, location, v);
 	if (ret < 0)
 		return ret;
 
 	return v;
 }
 
+static int phy_set_clr_bits(struct phy_device *dev, int location,
+			    int set_mask, int clr_mask)
+{
+	int ret;
+
+	mutex_lock(&dev->mdio.bus->mdio_lock);
+	ret = __phy_set_clr_bits(dev, location, set_mask, clr_mask);
+	mutex_unlock(&dev->mdio.bus->mdio_lock);
+
+	return ret;
+}
+
 static int bcm7xxx_28nm_ephy_01_afe_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -398,6 +415,93 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
 	return bcm7xxx_28nm_ephy_apd_enable(phydev);
 }
 
+#define MII_BCM7XXX_REG_INVALID	0xff
+
+static u8 bcm7xxx_28nm_ephy_regnum_to_shd(u16 regnum)
+{
+	switch (regnum) {
+	case MDIO_CTRL1:
+		return MII_BCM7XXX_SHD_3_PCS_CTRL;
+	case MDIO_STAT1:
+		return MII_BCM7XXX_SHD_3_PCS_STATUS;
+	case MDIO_PCS_EEE_ABLE:
+		return MII_BCM7XXX_SHD_3_EEE_CAP;
+	case MDIO_AN_EEE_ADV:
+		return MII_BCM7XXX_SHD_3_AN_EEE_ADV;
+	case MDIO_AN_EEE_LPABLE:
+		return MII_BCM7XXX_SHD_3_EEE_LP;
+	case MDIO_PCS_EEE_WK_ERR:
+		return MII_BCM7XXX_SHD_3_EEE_WK_ERR;
+	default:
+		return MII_BCM7XXX_REG_INVALID;
+	}
+}
+
+static bool bcm7xxx_28nm_ephy_dev_valid(int devnum)
+{
+	return devnum == MDIO_MMD_AN || devnum == MDIO_MMD_PCS;
+}
+
+static int bcm7xxx_28nm_ephy_read_mmd(struct phy_device *phydev,
+				      int devnum, u16 regnum)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+				 MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = __phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	ret = __phy_read(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	__phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+			   MII_BCM7XXX_SHD_MODE_2);
+	return ret;
+}
+
+static int bcm7xxx_28nm_ephy_write_mmd(struct phy_device *phydev,
+				       int devnum, u16 regnum, u16 val)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+				 MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = __phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	/* Write the desired value in the shadow register */
+	__phy_write(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT, val);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	return __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+				  MII_BCM7XXX_SHD_MODE_2);
+}
+
 static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -595,6 +699,8 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
 	.remove		= bcm7xxx_28nm_remove,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..ee8313a4ac71 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -525,6 +525,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	    NULL == bus->read || NULL == bus->write)
 		return -EINVAL;
 
+	if (bus->parent && bus->parent->of_node)
+		bus->parent->of_node->fwnode.flags |=
+					FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD;
+
 	BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
 	       bus->state != MDIOBUS_UNREGISTERED);
 
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3c7120ec7079..6a0799f5b05f 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2353,7 +2353,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2376,7 +2376,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3136,7 +3136,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 4c8ee1cff4d4..4cb71dd1998c 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1178,7 +1178,10 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 
 static void smsc95xx_handle_link_change(struct net_device *net)
 {
+	struct usbnet *dev = netdev_priv(net);
+
 	phy_print_status(net->phydev);
+	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
 }
 
 static int smsc95xx_start_phy(struct usbnet *dev)
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ffa894f7312a..0adae76eb8df 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1867,8 +1867,8 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		bcn_int -= data->bcn_delta;
 		data->bcn_delta = 0;
 	}
-	hrtimer_forward(&data->beacon_timer, hrtimer_get_expires(timer),
-			ns_to_ktime(bcn_int * NSEC_PER_USEC));
+	hrtimer_forward_now(&data->beacon_timer,
+			    ns_to_ktime(bcn_int * NSEC_PER_USEC));
 	return HRTIMER_RESTART;
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e2374319df61..9b6f78eac937 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -980,6 +980,7 @@ EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
 blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 {
 	struct nvme_command *cmd = nvme_req(req)->cmd;
+	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
 	blk_status_t ret = BLK_STS_OK;
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
@@ -1028,7 +1029,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 		return BLK_STS_IOERR;
 	}
 
-	nvme_req(req)->genctr++;
+	if (!(ctrl->quirks & NVME_QUIRK_SKIP_CID_GEN))
+		nvme_req(req)->genctr++;
 	cmd->common.command_id = nvme_cid(req);
 	trace_nvme_setup_cmd(req, cmd);
 	return ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 26511794629b..12393a72662e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -149,6 +149,12 @@ enum nvme_quirks {
 	 * 48 bits.
 	 */
 	NVME_QUIRK_DMA_ADDRESS_BITS_48		= (1 << 16),
+
+	/*
+	 * The controller requires the command_id value be be limited, so skip
+	 * encoding the generation sequence number.
+	 */
+	NVME_QUIRK_SKIP_CID_GEN			= (1 << 17),
 };
 
 /*
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c246fdacba2e..4f22fbafe964 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3282,7 +3282,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2005),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR |
 				NVME_QUIRK_128_BYTES_SQES |
-				NVME_QUIRK_SHARED_TAGS },
+				NVME_QUIRK_SHARED_TAGS |
+				NVME_QUIRK_SKIP_CID_GEN },
 
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index a89d24a040af..9b524969eff7 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2012-2014, 2016-2021 The Linux Foundation. All rights reserved.
  */
 
 #include <linux/gpio/driver.h>
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <linux/spmi.h>
 #include <linux/types.h>
 
 #include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
@@ -171,6 +172,8 @@ struct pmic_gpio_state {
 	struct pinctrl_dev *ctrl;
 	struct gpio_chip chip;
 	struct irq_chip irq;
+	u8 usid;
+	u8 pid_base;
 };
 
 static const struct pinconf_generic_params pmic_gpio_bindings[] = {
@@ -949,12 +952,36 @@ static int pmic_gpio_child_to_parent_hwirq(struct gpio_chip *chip,
 					   unsigned int *parent_hwirq,
 					   unsigned int *parent_type)
 {
-	*parent_hwirq = child_hwirq + 0xc0;
+	struct pmic_gpio_state *state = gpiochip_get_data(chip);
+
+	*parent_hwirq = child_hwirq + state->pid_base;
 	*parent_type = child_type;
 
 	return 0;
 }
 
+static void *pmic_gpio_populate_parent_fwspec(struct gpio_chip *chip,
+					     unsigned int parent_hwirq,
+					     unsigned int parent_type)
+{
+	struct pmic_gpio_state *state = gpiochip_get_data(chip);
+	struct irq_fwspec *fwspec;
+
+	fwspec = kzalloc(sizeof(*fwspec), GFP_KERNEL);
+	if (!fwspec)
+		return NULL;
+
+	fwspec->fwnode = chip->irq.parent_domain->fwnode;
+
+	fwspec->param_count = 4;
+	fwspec->param[0] = state->usid;
+	fwspec->param[1] = parent_hwirq;
+	/* param[2] must be left as 0 */
+	fwspec->param[3] = parent_type;
+
+	return fwspec;
+}
+
 static int pmic_gpio_probe(struct platform_device *pdev)
 {
 	struct irq_domain *parent_domain;
@@ -965,6 +992,7 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 	struct pmic_gpio_pad *pad, *pads;
 	struct pmic_gpio_state *state;
 	struct gpio_irq_chip *girq;
+	const struct spmi_device *parent_spmi_dev;
 	int ret, npins, i;
 	u32 reg;
 
@@ -984,6 +1012,9 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 
 	state->dev = &pdev->dev;
 	state->map = dev_get_regmap(dev->parent, NULL);
+	parent_spmi_dev = to_spmi_device(dev->parent);
+	state->usid = parent_spmi_dev->usid;
+	state->pid_base = reg >> 8;
 
 	pindesc = devm_kcalloc(dev, npins, sizeof(*pindesc), GFP_KERNEL);
 	if (!pindesc)
@@ -1059,7 +1090,7 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 	girq->fwnode = of_node_to_fwnode(state->dev->of_node);
 	girq->parent_domain = parent_domain;
 	girq->child_to_parent_hwirq = pmic_gpio_child_to_parent_hwirq;
-	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_alloc_arg = pmic_gpio_populate_parent_fwspec;
 	girq->child_offset_to_irq = pmic_gpio_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate = pmic_gpio_domain_translate;
 
diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 2e4e97a626a5..7b03b497d93b 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -118,12 +118,30 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 	{ }
 };
 
+/*
+ * Some devices, even non convertible ones, can send incorrect SW_TABLET_MODE
+ * reports. Accept such reports only from devices in this list.
+ */
+static const struct dmi_system_id dmi_auto_add_switch[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "31" /* Convertible */),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "32" /* Detachable */),
+		},
+	},
+	{} /* Array terminator */
+};
+
 struct intel_hid_priv {
 	struct input_dev *input_dev;
 	struct input_dev *array;
 	struct input_dev *switches;
 	bool wakeup_mode;
-	bool dual_accel;
+	bool auto_add_switch;
 };
 
 #define HID_EVENT_FILTER_UUID	"eeec56b3-4442-408f-a792-4edd4d758054"
@@ -452,10 +470,8 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	 * Some convertible have unreliable VGBS return which could cause incorrect
 	 * SW_TABLET_MODE report, in these cases we enable support when receiving
 	 * the first event instead of during driver setup.
-	 *
-	 * See dual_accel_detect.h for more info on the dual_accel check.
 	 */
-	if (!priv->switches && !priv->dual_accel && (event == 0xcc || event == 0xcd)) {
+	if (!priv->switches && priv->auto_add_switch && (event == 0xcc || event == 0xcd)) {
 		dev_info(&device->dev, "switch event received, enable switches supports\n");
 		err = intel_hid_switches_setup(device);
 		if (err)
@@ -596,7 +612,8 @@ static int intel_hid_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
-	priv->dual_accel = dual_accel_detect();
+	/* See dual_accel_detect.h for more info on the dual_accel check. */
+	priv->auto_add_switch = dmi_check_system(dmi_auto_add_switch) && !dual_accel_detect();
 
 	err = intel_hid_input_setup(device);
 	if (err) {
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 3dd519dfc473..d0096cd7096a 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -15,8 +15,6 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/ptp_kvm.h>
 
-struct pvclock_vsyscall_time_info *hv_clock;
-
 static phys_addr_t clock_pair_gpa;
 static struct kvm_clock_pairing clock_pair;
 
@@ -28,8 +26,7 @@ int kvm_arch_ptp_init(void)
 		return -ENODEV;
 
 	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
-	hv_clock = pvclock_get_pvti_cpu0_va();
-	if (!hv_clock)
+	if (!pvclock_get_pvti_cpu0_va())
 		return -ENODEV;
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
@@ -64,10 +61,8 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
 	struct pvclock_vcpu_time_info *src;
 	unsigned int version;
 	long ret;
-	int cpu;
 
-	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
+	src = this_cpu_pvti();
 
 	do {
 		/*
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 9748165e08e9..f19f02e75115 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -77,12 +77,13 @@ EXPORT_SYMBOL(ccwgroup_set_online);
 /**
  * ccwgroup_set_offline() - disable a ccwgroup device
  * @gdev: target ccwgroup device
+ * @call_gdrv: Call the registered gdrv set_offline function
  *
  * This function attempts to put the ccwgroup device into the offline state.
  * Returns:
  *  %0 on success and a negative error value on failure.
  */
-int ccwgroup_set_offline(struct ccwgroup_device *gdev)
+int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv)
 {
 	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
 	int ret = -EINVAL;
@@ -91,11 +92,16 @@ int ccwgroup_set_offline(struct ccwgroup_device *gdev)
 		return -EAGAIN;
 	if (gdev->state == CCWGROUP_OFFLINE)
 		goto out;
+	if (!call_gdrv) {
+		ret = 0;
+		goto offline;
+	}
 	if (gdrv->set_offline)
 		ret = gdrv->set_offline(gdev);
 	if (ret)
 		goto out;
 
+offline:
 	gdev->state = CCWGROUP_OFFLINE;
 out:
 	atomic_set(&gdev->onoff, 0);
@@ -124,7 +130,7 @@ static ssize_t ccwgroup_online_store(struct device *dev,
 	if (value == 1)
 		ret = ccwgroup_set_online(gdev);
 	else if (value == 0)
-		ret = ccwgroup_set_offline(gdev);
+		ret = ccwgroup_set_offline(gdev, true);
 	else
 		ret = -EINVAL;
 out:
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f4d554ea0c93..52bdb2c8c085 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -877,7 +877,6 @@ struct qeth_card {
 	struct napi_struct napi;
 	struct qeth_rx rx;
 	struct delayed_work buffer_reclaim_work;
-	struct work_struct close_dev_work;
 };
 
 static inline bool qeth_card_hw_is_reachable(struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 51f7f4e680c3..f5bad10f3f44 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -71,15 +71,6 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
 
-static void qeth_close_dev_handler(struct work_struct *work)
-{
-	struct qeth_card *card;
-
-	card = container_of(work, struct qeth_card, close_dev_work);
-	QETH_CARD_TEXT(card, 2, "cldevhdl");
-	ccwgroup_set_offline(card->gdev);
-}
-
 static const char *qeth_get_cardname(struct qeth_card *card)
 {
 	if (IS_VM_NIC(card)) {
@@ -797,10 +788,12 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	case IPA_CMD_STOPLAN:
 		if (cmd->hdr.return_code == IPA_RC_VEPA_TO_VEB_TRANSITION) {
 			dev_err(&card->gdev->dev,
-				"Interface %s is down because the adjacent port is no longer in reflective relay mode\n",
+				"Adjacent port of interface %s is no longer in reflective relay mode, trigger recovery\n",
 				netdev_name(card->dev));
-			schedule_work(&card->close_dev_work);
+			/* Set offline, then probably fail to set online: */
+			qeth_schedule_recovery(card);
 		} else {
+			/* stay online for subsequent STARTLAN */
 			dev_warn(&card->gdev->dev,
 				 "The link for interface %s on CHPID 0x%X failed\n",
 				 netdev_name(card->dev), card->info.chpid);
@@ -1559,7 +1552,6 @@ static void qeth_setup_card(struct qeth_card *card)
 	INIT_LIST_HEAD(&card->ipato.entries);
 	qeth_init_qdio_info(card);
 	INIT_DELAYED_WORK(&card->buffer_reclaim_work, qeth_buffer_reclaim_work);
-	INIT_WORK(&card->close_dev_work, qeth_close_dev_handler);
 	hash_init(card->rx_mode_addrs);
 	hash_init(card->local_addrs4);
 	hash_init(card->local_addrs6);
@@ -5556,7 +5548,8 @@ static int qeth_do_reset(void *data)
 		dev_info(&card->gdev->dev,
 			 "Device successfully recovered!\n");
 	} else {
-		ccwgroup_set_offline(card->gdev);
+		qeth_set_offline(card, disc, true);
+		ccwgroup_set_offline(card->gdev, false);
 		dev_warn(&card->gdev->dev,
 			 "The qeth device driver failed to recover an error on the device\n");
 	}
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index d7cdd9cfe485..3dbe592ca97a 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2218,7 +2218,6 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 	if (gdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
 
-	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 }
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index f0d6f205c53c..5ba38499e3e2 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1965,7 +1965,6 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	if (cgdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
 
-	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 390b07bf92b9..ccbded3353bd 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1254,3 +1254,4 @@ MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
 MODULE_FIRMWARE(FW_FNAME_T6);
+MODULE_SOFTDEP("pre: cxgb4");
diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
index 725ca2a23fb2..52be01333c6e 100644
--- a/drivers/scsi/elx/libefc/efc_device.c
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -928,22 +928,21 @@ __efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
 		break;
 
 	case EFC_EVT_NPORT_TOPOLOGY_NOTIFY: {
-		enum efc_nport_topology topology =
-					(enum efc_nport_topology)arg;
+		enum efc_nport_topology *topology = arg;
 
 		WARN_ON(node->nport->domain->attached);
 
 		WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
 
 		node_printf(node, "topology notification, topology=%d\n",
-			    topology);
+			    *topology);
 
 		/* At the time the PLOGI was received, the topology was unknown,
 		 * so we didn't know which node would perform the domain attach:
 		 * 1. The node from which the PLOGI was sent (p2p) or
 		 * 2. The node to which the FLOGI was sent (fabric).
 		 */
-		if (topology == EFC_NPORT_TOPO_P2P) {
+		if (*topology == EFC_NPORT_TOPO_P2P) {
 			/* if this is p2p, need to attach to the domain using
 			 * the d_id from the PLOGI received
 			 */
diff --git a/drivers/scsi/elx/libefc/efc_fabric.c b/drivers/scsi/elx/libefc/efc_fabric.c
index d397220d9e54..3270ce40196c 100644
--- a/drivers/scsi/elx/libefc/efc_fabric.c
+++ b/drivers/scsi/elx/libefc/efc_fabric.c
@@ -107,7 +107,6 @@ void
 efc_fabric_notify_topology(struct efc_node *node)
 {
 	struct efc_node *tmp_node;
-	enum efc_nport_topology topology = node->nport->topology;
 	unsigned long index;
 
 	/*
@@ -118,7 +117,7 @@ efc_fabric_notify_topology(struct efc_node *node)
 		if (tmp_node != node) {
 			efc_node_post_event(tmp_node,
 					    EFC_EVT_NPORT_TOPOLOGY_NOTIFY,
-					    (void *)topology);
+					    &node->nport->topology);
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2f67ec1df3e6..82b6f4c2eb4a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3935,7 +3935,6 @@ struct qla_hw_data {
 		uint32_t	scm_supported_f:1;
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
-		uint32_t	max_req_queue_warned:1;
 		uint32_t	plogi_template_valid:1;
 		uint32_t	port_isolated:1;
 	} flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d9fb093a60a1..2aa8f519aae6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4201,6 +4201,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ql_dbg(ql_dbg_init, vha, 0x0125,
 		    "INTa mode: Enabled.\n");
 		ha->flags.mr_intr_valid = 1;
+		/* Set max_qpair to 0, as MSI-X and MSI in not enabled */
+		ha->max_qpairs = 0;
 	}
 
 clear_risc_ints:
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index a7259733e470..9316d7d91e2a 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -109,19 +109,24 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 		return -EINVAL;
 	}
 
-	if (ha->queue_pair_map[qidx]) {
-		*handle = ha->queue_pair_map[qidx];
-		ql_log(ql_log_info, vha, 0x2121,
-		    "Returning existing qpair of %p for idx=%x\n",
-		    *handle, qidx);
-		return 0;
-	}
+	/* Use base qpair if max_qpairs is 0 */
+	if (!ha->max_qpairs) {
+		qpair = ha->base_qpair;
+	} else {
+		if (ha->queue_pair_map[qidx]) {
+			*handle = ha->queue_pair_map[qidx];
+			ql_log(ql_log_info, vha, 0x2121,
+			       "Returning existing qpair of %p for idx=%x\n",
+			       *handle, qidx);
+			return 0;
+		}
 
-	qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
-	if (qpair == NULL) {
-		ql_log(ql_log_warn, vha, 0x2122,
-		    "Failed to allocate qpair\n");
-		return -EINVAL;
+		qpair = qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
+		if (!qpair) {
+			ql_log(ql_log_warn, vha, 0x2122,
+			       "Failed to allocate qpair\n");
+			return -EINVAL;
+		}
 	}
 	*handle = qpair;
 
@@ -728,18 +733,9 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 
 	WARN_ON(vha->nvme_local_port);
 
-	if (ha->max_req_queues < 3) {
-		if (!ha->flags.max_req_queue_warned)
-			ql_log(ql_log_info, vha, 0x2120,
-			       "%s: Disabling FC-NVME due to lack of free queue pairs (%d).\n",
-			       __func__, ha->max_req_queues);
-		ha->flags.max_req_queue_warned = 1;
-		return ret;
-	}
-
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
-		(uint8_t)(ha->max_req_queues - 2));
+		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
 
 	pinfo.node_name = wwn_to_u64(vha->node_name);
 	pinfo.port_name = wwn_to_u64(vha->port_name);
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index e6c334bfb4c2..40acca04d03b 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -128,6 +128,81 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
+{
+	struct ufs_pa_layer_attr pwr_info = hba->pwr_info;
+	int ret;
+
+	pwr_info.lane_rx = lanes;
+	pwr_info.lane_tx = lanes;
+	ret = ufshcd_config_pwr_mode(hba, &pwr_info);
+	if (ret)
+		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
+			__func__, lanes, ret);
+	return ret;
+}
+
+static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (ufshcd_is_hs_mode(dev_max_params) &&
+		    (hba->pwr_info.lane_rx != 2 || hba->pwr_info.lane_tx != 2))
+			ufs_intel_set_lanes(hba, 2);
+		memcpy(dev_req_params, dev_max_params, sizeof(*dev_req_params));
+		break;
+	case POST_CHANGE:
+		if (ufshcd_is_hs_mode(dev_req_params)) {
+			u32 peer_granularity;
+
+			usleep_range(1000, 1250);
+			err = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+						  &peer_granularity);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
+{
+	u32 granularity, peer_granularity;
+	u32 pa_tactivate, peer_pa_tactivate;
+	int ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &peer_granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &pa_tactivate);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &peer_pa_tactivate);
+	if (ret)
+		goto out;
+
+	if (granularity == peer_granularity) {
+		u32 new_peer_pa_tactivate = pa_tactivate + 2;
+
+		ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_TACTIVATE), new_peer_pa_tactivate);
+	}
+out:
+	return ret;
+}
+
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -351,6 +426,7 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 	struct ufs_host *ufs_host;
 	int err;
 
+	hba->nop_out_timeout = 200;
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
 	hba->caps |= UFSHCD_CAP_CRYPTO;
 	err = ufs_intel_common_init(hba);
@@ -381,6 +457,8 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.pwr_change_notify	= ufs_intel_lkf_pwr_change_notify,
+	.apply_dev_quirks	= ufs_intel_lkf_apply_dev_quirks,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3a204324151a..a3f5af088122 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -330,8 +330,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	int off = (int)tag - hba->nutrs;
-	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
+	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
@@ -4767,7 +4766,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
-					       NOP_OUT_TIMEOUT);
+					  hba->nop_out_timeout);
 
 		if (!err || err == -ETIMEDOUT)
 			break;
@@ -9403,6 +9402,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->dev = dev;
 	*hba_handle = hba;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
+	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 
 	INIT_LIST_HEAD(&hba->clk_list_head);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 86d4765a17b8..aa95deffb873 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -814,6 +814,7 @@ struct ufs_hba {
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
 	ktime_t last_dme_cmd_tstamp;
+	int nop_out_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 31d8449ca1d2..fc769c52c6d3 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -918,7 +918,7 @@ static int hantro_probe(struct platform_device *pdev)
 		if (!vpu->variant->irqs[i].handler)
 			continue;
 
-		if (vpu->variant->num_clocks > 1) {
+		if (vpu->variant->num_irqs > 1) {
 			irq_name = vpu->variant->irqs[i].name;
 			irq = platform_get_irq_byname(vpu->pdev, irq_name);
 		} else {
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 32c13ecb22d8..a8168ac2fbd0 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -135,7 +135,7 @@ void cedrus_prepare_format(struct v4l2_pix_format *pix_fmt)
 		sizeimage = bytesperline * height;
 
 		/* Chroma plane size. */
-		sizeimage += bytesperline * height / 2;
+		sizeimage += bytesperline * ALIGN(height, 64) / 2;
 
 		break;
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index cb72393f92d3..153d4a88ec9a 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1219,8 +1219,25 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	new_row_size = new_cols << 1;
 	new_screen_size = new_row_size * new_rows;
 
-	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
-		return 0;
+	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows) {
+		/*
+		 * This function is being called here to cover the case
+		 * where the userspace calls the FBIOPUT_VSCREENINFO twice,
+		 * passing the same fb_var_screeninfo containing the fields
+		 * yres/xres equal to a number non-multiple of vc_font.height
+		 * and yres_virtual/xres_virtual equal to number lesser than the
+		 * vc_font.height and yres/xres.
+		 * In the second call, the struct fb_var_screeninfo isn't
+		 * being modified by the underlying driver because of the
+		 * if above, and this causes the fbcon_display->vrows to become
+		 * negative and it eventually leads to out-of-bound
+		 * access by the imageblit function.
+		 * To give the correct values to the struct and to not have
+		 * to deal with possible errors from the code below, we call
+		 * the resize_screen here as well.
+		 */
+		return resize_screen(vc, new_cols, new_rows, user);
+	}
 
 	if (new_screen_size > KMALLOC_MAX_SIZE || !new_screen_size)
 		return -EINVAL;
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 546dfc1e2349..71cf3f503f16 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1677,7 +1677,7 @@ config WDT_MTX1
 
 config SIBYTE_WDOG
 	tristate "Sibyte SoC hardware watchdog"
-	depends on CPU_SB1 || (MIPS && COMPILE_TEST)
+	depends on CPU_SB1
 	help
 	  Watchdog driver for the built in watchdog hardware in Sibyte
 	  SoC processors.  There are apparently two watchdog timers
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 439ed81e755a..964be729ed0a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -630,7 +630,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
-				elf_type |= MAP_FIXED_NOREPLACE;
+				elf_type |= MAP_FIXED;
 			else if (no_base && interp_elf_ex->e_type == ET_DYN)
 				load_addr = -vaddr;
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 8129a430d789..2f117c57160d 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -528,7 +528,7 @@ void debugfs_create_file_size(const char *name, umode_t mode,
 {
 	struct dentry *de = debugfs_create_file(name, mode, parent, data, fops);
 
-	if (de)
+	if (!IS_ERR(de))
 		d_inode(de)->i_size = file_size;
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file_size);
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index ffb295aa891c..74b172a4adda 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -551,7 +551,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 	struct dir_private_info *info = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct fname *fname;
-	int	ret;
+	int ret = 0;
 
 	if (!info) {
 		info = ext4_htree_create_dir_info(file, ctx->pos);
@@ -599,7 +599,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 						   info->curr_minor_hash,
 						   &info->next_hash);
 			if (ret < 0)
-				return ret;
+				goto finished;
 			if (ret == 0) {
 				ctx->pos = ext4_get_htree_eof(file);
 				break;
@@ -630,7 +630,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 	}
 finished:
 	info->last_pos = ctx->pos;
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int ext4_release_dir(struct inode *inode, struct file *filp)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 92ad64b89d9b..b1933e3513d6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5908,7 +5908,7 @@ void ext4_ext_replay_shrink_inode(struct inode *inode, ext4_lblk_t end)
 }
 
 /* Check if *cur is a hole and if it is, skip it */
-static void skip_hole(struct inode *inode, ext4_lblk_t *cur)
+static int skip_hole(struct inode *inode, ext4_lblk_t *cur)
 {
 	int ret;
 	struct ext4_map_blocks map;
@@ -5917,9 +5917,12 @@ static void skip_hole(struct inode *inode, ext4_lblk_t *cur)
 	map.m_len = ((inode->i_size) >> inode->i_sb->s_blocksize_bits) - *cur;
 
 	ret = ext4_map_blocks(NULL, inode, &map, 0);
+	if (ret < 0)
+		return ret;
 	if (ret != 0)
-		return;
+		return 0;
 	*cur = *cur + map.m_len;
+	return 0;
 }
 
 /* Count number of blocks used by this inode and update i_blocks */
@@ -5968,7 +5971,9 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
 	 * iblocks by total number of differences found.
 	 */
 	cur = 0;
-	skip_hole(inode, &cur);
+	ret = skip_hole(inode, &cur);
+	if (ret < 0)
+		goto out;
 	path = ext4_find_extent(inode, cur, NULL, 0);
 	if (IS_ERR(path))
 		goto out;
@@ -5987,8 +5992,12 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
 		}
 		cur = max(cur + 1, le32_to_cpu(ex->ee_block) +
 					ext4_ext_get_actual_len(ex));
-		skip_hole(inode, &cur);
-
+		ret = skip_hole(inode, &cur);
+		if (ret < 0) {
+			ext4_ext_drop_refs(path);
+			kfree(path);
+			break;
+		}
 		path2 = ext4_find_extent(inode, cur, NULL, 0);
 		if (IS_ERR(path2)) {
 			ext4_ext_drop_refs(path);
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index e8195229c252..782d05a3f97a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -893,6 +893,12 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 					    sizeof(lrange), (u8 *)&lrange, crc))
 				return -ENOSPC;
 		} else {
+			unsigned int max = (map.m_flags & EXT4_MAP_UNWRITTEN) ?
+				EXT_UNWRITTEN_MAX_LEN : EXT_INIT_MAX_LEN;
+
+			/* Limit the number of blocks in one extent */
+			map.m_len = min(max, map.m_len);
+
 			fc_ext.fc_ino = cpu_to_le32(inode->i_ino);
 			ex = (struct ext4_extent *)&fc_ext.fc_ex;
 			ex->ee_block = cpu_to_le32(map.m_lblk);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d8de607849df..73daf9443e5e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1640,6 +1640,7 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int ret;
 	bool allocated = false;
+	bool reserved = false;
 
 	/*
 	 * If the cluster containing lblk is shared with a delayed,
@@ -1656,6 +1657,7 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 		ret = ext4_da_reserve_space(inode);
 		if (ret != 0)   /* ENOSPC */
 			goto errout;
+		reserved = true;
 	} else {   /* bigalloc */
 		if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
 			if (!ext4_es_scan_clu(inode,
@@ -1668,6 +1670,7 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 					ret = ext4_da_reserve_space(inode);
 					if (ret != 0)   /* ENOSPC */
 						goto errout;
+					reserved = true;
 				} else {
 					allocated = true;
 				}
@@ -1678,6 +1681,8 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 	}
 
 	ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
+	if (ret && reserved)
+		ext4_da_release_space(inode, 1);
 
 errout:
 	return ret;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 970013c93d3e..59c25a95050a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -661,7 +661,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 		 * constraints, it may not be safe to do it right here so we
 		 * defer superblock flushing to a workqueue.
 		 */
-		if (continue_fs)
+		if (continue_fs && journal)
 			schedule_work(&EXT4_SB(sb)->s_error_work);
 		else
 			ext4_commit_super(sb);
@@ -1351,6 +1351,12 @@ static void ext4_destroy_inode(struct inode *inode)
 				true);
 		dump_stack();
 	}
+
+	if (EXT4_I(inode)->i_reserved_data_blocks)
+		ext4_msg(inode->i_sb, KERN_ERR,
+			 "Inode %lu (%p): i_reserved_data_blocks (%u) not cleared!",
+			 inode->i_ino, EXT4_I(inode),
+			 EXT4_I(inode)->i_reserved_data_blocks);
 }
 
 static void init_once(void *foo)
@@ -3185,17 +3191,17 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
  */
 static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
 {
-	loff_t res = EXT4_NDIR_BLOCKS;
+	unsigned long long upper_limit, res = EXT4_NDIR_BLOCKS;
 	int meta_blocks;
-	loff_t upper_limit;
-	/* This is calculated to be the largest file size for a dense, block
+
+	/*
+	 * This is calculated to be the largest file size for a dense, block
 	 * mapped file such that the file's total number of 512-byte sectors,
 	 * including data and all indirect blocks, does not exceed (2^48 - 1).
 	 *
 	 * __u32 i_blocks_lo and _u16 i_blocks_high represent the total
 	 * number of 512-byte sectors of the file.
 	 */
-
 	if (!has_huge_files) {
 		/*
 		 * !has_huge_files or implies that the inode i_block field
@@ -3238,7 +3244,7 @@ static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
 	if (res > MAX_LFS_FILESIZE)
 		res = MAX_LFS_FILESIZE;
 
-	return res;
+	return (loff_t)res;
 }
 
 static ext4_fsblk_t descriptor_loc(struct super_block *sb,
@@ -5183,12 +5189,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_ea_block_cache = NULL;
 
 	if (sbi->s_journal) {
+		/* flush s_error_work before journal destroy. */
+		flush_work(&sbi->s_error_work);
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
+	/* flush s_error_work before sbi destroy */
 	flush_work(&sbi->s_error_work);
 	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 77e159a0346b..60a4372aa4d7 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -177,7 +177,7 @@ static int build_merkle_tree(struct file *filp,
 	 * (level 0) and ascending to the root node (level 'num_levels - 1').
 	 * Then at the end (level 'num_levels'), calculate the root hash.
 	 */
-	blocks = (inode->i_size + params->block_size - 1) >>
+	blocks = ((u64)inode->i_size + params->block_size - 1) >>
 		 params->log_blocksize;
 	for (level = 0; level <= params->num_levels; level++) {
 		err = build_merkle_tree_level(filp, level, blocks, params,
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 60ff8af7219f..92df87f5fa38 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -89,7 +89,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 	 */
 
 	/* Compute number of levels and the number of blocks in each level */
-	blocks = (inode->i_size + params->block_size - 1) >> log_blocksize;
+	blocks = ((u64)inode->i_size + params->block_size - 1) >> log_blocksize;
 	pr_debug("Data is %lld bytes (%llu blocks)\n", inode->i_size, blocks);
 	while (blocks > 1) {
 		if (params->num_levels >= FS_VERITY_MAX_LEVELS) {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e8e2b0393ca9..11da5671d4f0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -553,6 +553,8 @@ struct btf_func_model {
  * programs only. Should not be used with normal calls and indirect calls.
  */
 #define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
+/* Return the return value of fentry prog. Only used by bpf_struct_ops. */
+#define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 59828516ebaf..9f4ad719bfe3 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -22,10 +22,15 @@ struct device;
  * LINKS_ADDED:	The fwnode has already be parsed to add fwnode links.
  * NOT_DEVICE:	The fwnode will never be populated as a struct device.
  * INITIALIZED: The hardware corresponding to fwnode has been initialized.
+ * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
+ *			     driver needs its child devices to be bound with
+ *			     their respective drivers as soon as they are
+ *			     added.
  */
-#define FWNODE_FLAG_LINKS_ADDED		BIT(0)
-#define FWNODE_FLAG_NOT_DEVICE		BIT(1)
-#define FWNODE_FLAG_INITIALIZED		BIT(2)
+#define FWNODE_FLAG_LINKS_ADDED			BIT(0)
+#define FWNODE_FLAG_NOT_DEVICE			BIT(1)
+#define FWNODE_FLAG_INITIALIZED			BIT(2)
+#define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	BIT(3)
 
 struct fwnode_handle {
 	struct fwnode_handle *secondary;
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 3ab2563b1a23..7fd7f6093612 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -597,5 +597,5 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
 		     u8 rt_family, unsigned char *flags, bool skip_oif);
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
-		    int nh_weight, u8 rt_family);
+		    int nh_weight, u8 rt_family, u32 nh_tclassid);
 #endif  /* _NET_FIB_H */
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 10e1777877e6..28085b995ddc 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -325,7 +325,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
 
-		if (fib_add_nexthop(skb, nhc, weight, rt_family) < 0)
+		if (fib_add_nexthop(skb, nhc, weight, rt_family, 0) < 0)
 			return -EMSGSIZE;
 	}
 
diff --git a/include/net/sock.h b/include/net/sock.h
index f23cb259b0e2..d28b9bb5ef5a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -487,8 +487,10 @@ struct sock {
 	u8			sk_prefer_busy_poll;
 	u16			sk_busy_poll_budget;
 #endif
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	ktime_t			sk_stamp;
 #if BITS_PER_LONG==32
diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
index 989e1517332d..7a08ed2acd60 100644
--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -98,6 +98,7 @@ struct snd_rawmidi_file {
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *input;
 	struct snd_rawmidi_substream *output;
+	unsigned int user_pversion;	/* supported protocol version */
 };
 
 struct snd_rawmidi_str {
diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index d17c061950df..9c5121e6ead4 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -783,6 +783,7 @@ struct snd_rawmidi_status {
 
 #define SNDRV_RAWMIDI_IOCTL_PVERSION	_IOR('W', 0x00, int)
 #define SNDRV_RAWMIDI_IOCTL_INFO	_IOR('W', 0x01, struct snd_rawmidi_info)
+#define SNDRV_RAWMIDI_IOCTL_USER_PVERSION _IOW('W', 0x02, int)
 #define SNDRV_RAWMIDI_IOCTL_PARAMS	_IOWR('W', 0x10, struct snd_rawmidi_params)
 #define SNDRV_RAWMIDI_IOCTL_STATUS	_IOWR('W', 0x20, struct snd_rawmidi_status)
 #define SNDRV_RAWMIDI_IOCTL_DROP	_IOW('W', 0x30, int)
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 70f6fd4fa305..2ce17447fb76 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -367,6 +367,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 		const struct btf_type *mtype, *ptype;
 		struct bpf_prog *prog;
 		u32 moff;
+		u32 flags;
 
 		moff = btf_member_bit_offset(t, member) / 8;
 		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
@@ -430,10 +431,12 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 
 		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
 		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
+		flags = st_ops->func_models[i].ret_size > 0 ?
+			BPF_TRAMP_F_RET_FENTRY_RET : 0;
 		err = arch_prepare_bpf_trampoline(NULL, image,
 						  st_map->image + PAGE_SIZE,
-						  &st_ops->func_models[i], 0,
-						  tprogs, NULL);
+						  &st_ops->func_models[i],
+						  flags, tprogs, NULL);
 		if (err < 0)
 			goto reset_unlock;
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0a28a8095d3e..c019611fbc8f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -827,7 +827,7 @@ int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
-		if (!capable(CAP_SYS_ADMIN)) {
+		if (!bpf_capable()) {
 			atomic_long_sub(pages, &bpf_jit_current);
 			return -EPERM;
 		}
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 57124614363d..e7af18857371 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -537,9 +537,17 @@ static struct attribute *sugov_attrs[] = {
 };
 ATTRIBUTE_GROUPS(sugov);
 
+static void sugov_tunables_free(struct kobject *kobj)
+{
+	struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
+
+	kfree(to_sugov_tunables(attr_set));
+}
+
 static struct kobj_type sugov_tunables_ktype = {
 	.default_groups = sugov_groups,
 	.sysfs_ops = &governor_sysfs_ops,
+	.release = &sugov_tunables_free,
 };
 
 /********************** cpufreq governor interface *********************/
@@ -639,12 +647,10 @@ static struct sugov_tunables *sugov_tunables_alloc(struct sugov_policy *sg_polic
 	return tunables;
 }
 
-static void sugov_tunables_free(struct sugov_tunables *tunables)
+static void sugov_clear_global_tunables(void)
 {
 	if (!have_governor_per_policy())
 		global_tunables = NULL;
-
-	kfree(tunables);
 }
 
 static int sugov_init(struct cpufreq_policy *policy)
@@ -707,7 +713,7 @@ static int sugov_init(struct cpufreq_policy *policy)
 fail:
 	kobject_put(&tunables->attr_set.kobj);
 	policy->governor_data = NULL;
-	sugov_tunables_free(tunables);
+	sugov_clear_global_tunables();
 
 stop_kthread:
 	sugov_kthread_stop(sg_policy);
@@ -734,7 +740,7 @@ static void sugov_exit(struct cpufreq_policy *policy)
 	count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
 	policy->governor_data = NULL;
 	if (!count)
-		sugov_tunables_free(tunables);
+		sugov_clear_global_tunables();
 
 	mutex_unlock(&global_tunables_lock);
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7e08e3d947c2..2c879cd02a5f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -173,16 +173,22 @@ static ssize_t sched_scaling_write(struct file *filp, const char __user *ubuf,
 				   size_t cnt, loff_t *ppos)
 {
 	char buf[16];
+	unsigned int scaling;
 
 	if (cnt > 15)
 		cnt = 15;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
+	buf[cnt] = '\0';
 
-	if (kstrtouint(buf, 10, &sysctl_sched_tunable_scaling))
+	if (kstrtouint(buf, 10, &scaling))
 		return -EINVAL;
 
+	if (scaling >= SCHED_TUNABLESCALING_END)
+		return -EINVAL;
+
+	sysctl_sched_tunable_scaling = scaling;
 	if (sched_update_scaling())
 		return -EINVAL;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 30a6984a58f7..423ec671a306 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4898,8 +4898,12 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	/* update hierarchical throttle state */
 	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
 
-	if (!cfs_rq->load.weight)
+	/* Nothing to run but something to decay (on_list)? Complete the branch */
+	if (!cfs_rq->load.weight) {
+		if (cfs_rq->on_list)
+			goto unthrottle_throttle;
 		return;
+	}
 
 	task_delta = cfs_rq->h_nr_running;
 	idle_task_delta = cfs_rq->idle_h_nr_running;
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 1e2d10f86011..cdc842d090db 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -66,6 +66,7 @@ choice
 config KASAN_GENERIC
 	bool "Generic mode"
 	depends on HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
@@ -86,6 +87,7 @@ config KASAN_GENERIC
 config KASAN_SW_TAGS
 	bool "Software tag-based mode"
 	depends on HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
diff --git a/mm/util.c b/mm/util.c
index c18202b3e659..8bd4a20262a9 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -593,6 +593,10 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
+	/* Don't even allow crazy sizes */
+	if (WARN_ON_ONCE(size > INT_MAX))
+		return NULL;
+
 	return __vmalloc_node(size, 1, flags, node,
 			__builtin_return_address(0));
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index a3eea6e0b30a..4a08ae6de578 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1366,6 +1366,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(sock_setsockopt);
 
+static const struct cred *sk_get_peer_cred(struct sock *sk)
+{
+	const struct cred *cred;
+
+	spin_lock(&sk->sk_peer_lock);
+	cred = get_cred(sk->sk_peer_cred);
+	spin_unlock(&sk->sk_peer_lock);
+
+	return cred;
+}
 
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
@@ -1542,7 +1552,11 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
+
+		spin_lock(&sk->sk_peer_lock);
 		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		spin_unlock(&sk->sk_peer_lock);
+
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
@@ -1550,20 +1564,23 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 	case SO_PEERGROUPS:
 	{
+		const struct cred *cred;
 		int ret, n;
 
-		if (!sk->sk_peer_cred)
+		cred = sk_get_peer_cred(sk);
+		if (!cred)
 			return -ENODATA;
 
-		n = sk->sk_peer_cred->group_info->ngroups;
+		n = cred->group_info->ngroups;
 		if (len < n * sizeof(gid_t)) {
 			len = n * sizeof(gid_t);
+			put_cred(cred);
 			return put_user(len, optlen) ? -EFAULT : -ERANGE;
 		}
 		len = n * sizeof(gid_t);
 
-		ret = groups_to_user((gid_t __user *)optval,
-				     sk->sk_peer_cred->group_info);
+		ret = groups_to_user((gid_t __user *)optval, cred->group_info);
+		put_cred(cred);
 		if (ret)
 			return ret;
 		goto lenout;
@@ -1921,9 +1938,10 @@ static void __sk_destruct(struct rcu_head *head)
 		sk->sk_frag.page = NULL;
 	}
 
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	/* We do not need to acquire sk->sk_peer_lock, we are the last user. */
+	put_cred(sk->sk_peer_cred);
 	put_pid(sk->sk_peer_pid);
+
 	if (likely(sk->sk_net_refcnt))
 		put_net(sock_net(sk));
 	sk_prot_free(sk->sk_prot_creator, sk);
@@ -3124,6 +3142,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_peer_pid 	=	NULL;
 	sk->sk_peer_cred	=	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=	0;
 	sk->sk_rcvlowat		=	1;
 	sk->sk_rcvtimeo		=	MAX_SCHEDULE_TIMEOUT;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4c0c33e4710d..27fdd86b9cee 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1663,7 +1663,7 @@ EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight, u8 rt_family)
+		    int nh_weight, u8 rt_family, u32 nh_tclassid)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1681,6 +1681,9 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 
 	rtnh->rtnh_flags = flags;
 
+	if (nh_tclassid && nla_put_u32(skb, RTA_FLOW, nh_tclassid))
+		goto nla_put_failure;
+
 	/* length of rtnetlink header + attributes */
 	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
 
@@ -1708,14 +1711,13 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	}
 
 	for_nexthops(fi) {
-		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
-				    AF_INET) < 0)
-			goto nla_put_failure;
+		u32 nh_tclassid = 0;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		if (nh->nh_tclassid &&
-		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
-			goto nla_put_failure;
+		nh_tclassid = nh->nh_tclassid;
 #endif
+		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
+				    AF_INET, nh_tclassid) < 0)
+			goto nla_put_failure;
 	} endfor_nexthops(fi);
 
 mp_end:
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1a742b710e54..915ea635b2d5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1053,7 +1053,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
@@ -1361,7 +1361,7 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 	}
 
 	up->len += size;
-	if (!(up->corkflag || (flags&MSG_MORE)))
+	if (!(READ_ONCE(up->corkflag) || (flags&MSG_MORE)))
 		ret = udp_push_pending_frames(sk);
 	if (!ret)
 		ret = size;
@@ -2662,9 +2662,9 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case UDP_CORK:
 		if (val != 0) {
-			up->corkflag = 1;
+			WRITE_ONCE(up->corkflag, 1);
 		} else {
-			up->corkflag = 0;
+			WRITE_ONCE(up->corkflag, 0);
 			lock_sock(sk);
 			push_pending_frames(sk);
 			release_sock(sk);
@@ -2787,7 +2787,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 
 	switch (optname) {
 	case UDP_CORK:
-		val = up->corkflag;
+		val = READ_ONCE(up->corkflag);
 		break;
 
 	case UDP_ENCAP:
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 603340302101..0aeff2ce17b9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5700,14 +5700,15 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 
 		if (fib_add_nexthop(skb, &rt->fib6_nh->nh_common,
-				    rt->fib6_nh->fib_nh_weight, AF_INET6) < 0)
+				    rt->fib6_nh->fib_nh_weight, AF_INET6,
+				    0) < 0)
 			goto nla_put_failure;
 
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
 			if (fib_add_nexthop(skb, &sibling->fib6_nh->nh_common,
 					    sibling->fib6_nh->fib_nh_weight,
-					    AF_INET6) < 0)
+					    AF_INET6, 0) < 0)
 				goto nla_put_failure;
 		}
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index c5e15e94bb00..80ae024d13c8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1303,7 +1303,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
 	int ulen = len;
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 204830a55240..3fbd0b9ff913 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2012-2013, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
  * Copyright 2012-2013, cozybit Inc.
+ * Copyright (C) 2021 Intel Corporation
  */
 
 #include "mesh.h"
@@ -588,7 +589,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 	/* only transmit to PS STA with announced, non-zero awake window */
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
-	    (!elems->awake_window || !le16_to_cpu(*elems->awake_window)))
+	    (!elems->awake_window || !get_unaligned_le16(elems->awake_window)))
 		return;
 
 	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index e5935e3d7a07..8c6416129d5b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -392,10 +392,6 @@ static bool rate_control_send_low(struct ieee80211_sta *pubsta,
 	int mcast_rate;
 	bool use_basicrate = false;
 
-	if (ieee80211_is_tx_data(txrc->skb) &&
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
-		return false;
-
 	if (!pubsta || rc_no_data_or_no_ack_use_min(txrc)) {
 		__rate_control_send_low(txrc->hw, sband, pubsta, info,
 					txrc->rate_idx_mask);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fa09a369214d..751e601c4623 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2209,7 +2209,11 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 			}
 
 			vht_mcs = iterator.this_arg[4] >> 4;
+			if (vht_mcs > 11)
+				vht_mcs = 0;
 			vht_nss = iterator.this_arg[4] & 0xF;
+			if (!vht_nss || vht_nss > 8)
+				vht_nss = 1;
 			break;
 
 		/*
@@ -3380,6 +3384,14 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
 		goto out;
 
+	/* If n == 2, the "while (*frag_tail)" loop above didn't execute
+	 * and  frag_tail should be &skb_shinfo(head)->frag_list.
+	 * However, ieee80211_amsdu_prepare_head() can reallocate it.
+	 * Reload frag_tail to have it pointing to the correct place.
+	 */
+	if (n == 2)
+		frag_tail = &skb_shinfo(head)->frag_list;
+
 	/*
 	 * Pad out the previous subframe to a multiple of 4 by adding the
 	 * padding to the next one, that's being added. Note that head->len
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index bca47fad5a16..4eed23e27610 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -520,6 +520,9 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
@@ -749,6 +752,9 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index f48eb6315bbb..292374fb0779 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -36,7 +36,7 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 	struct sock *sk;
 
 	net = sock_net(in_skb->sk);
-	msk = mptcp_token_get_sock(req->id.idiag_cookie[0]);
+	msk = mptcp_token_get_sock(net, req->id.idiag_cookie[0]);
 	if (!msk)
 		goto out_nosk;
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 89251cbe9f1a..81103b29c0af 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1558,9 +1558,7 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 
 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
 		if (addresses_equal(&entry->addr, &addr.addr, true)) {
-			ret = mptcp_nl_addr_backup(net, &entry->addr, bkup);
-			if (ret)
-				return ret;
+			mptcp_nl_addr_backup(net, &entry->addr, bkup);
 
 			if (bkup)
 				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6ac564d584c1..c8a49e92e66f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -680,7 +680,7 @@ int mptcp_token_new_connect(struct sock *sk);
 void mptcp_token_accept(struct mptcp_subflow_request_sock *r,
 			struct mptcp_sock *msk);
 bool mptcp_token_exists(u32 token);
-struct mptcp_sock *mptcp_token_get_sock(u32 token);
+struct mptcp_sock *mptcp_token_get_sock(struct net *net, u32 token);
 struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
 					 long *s_num);
 void mptcp_token_destroy(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 966f777d35ce..1f3039b829a7 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -86,7 +86,7 @@ static struct mptcp_sock *subflow_token_join_request(struct request_sock *req)
 	struct mptcp_sock *msk;
 	int local_id;
 
-	msk = mptcp_token_get_sock(subflow_req->token);
+	msk = mptcp_token_get_sock(sock_net(req_to_sk(req)), subflow_req->token);
 	if (!msk) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINNOTOKEN);
 		return NULL;
diff --git a/net/mptcp/syncookies.c b/net/mptcp/syncookies.c
index 37127781aee9..7f22526346a7 100644
--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -108,18 +108,12 @@ bool mptcp_token_join_cookie_init_state(struct mptcp_subflow_request_sock *subfl
 
 	e->valid = 0;
 
-	msk = mptcp_token_get_sock(e->token);
+	msk = mptcp_token_get_sock(net, e->token);
 	if (!msk) {
 		spin_unlock_bh(&join_entry_locks[i]);
 		return false;
 	}
 
-	/* If this fails, the token got re-used in the mean time by another
-	 * mptcp socket in a different netns, i.e. entry is outdated.
-	 */
-	if (!net_eq(sock_net((struct sock *)msk), net))
-		goto err_put;
-
 	subflow_req->remote_nonce = e->remote_nonce;
 	subflow_req->local_nonce = e->local_nonce;
 	subflow_req->backup = e->backup;
@@ -128,11 +122,6 @@ bool mptcp_token_join_cookie_init_state(struct mptcp_subflow_request_sock *subfl
 	subflow_req->msk = msk;
 	spin_unlock_bh(&join_entry_locks[i]);
 	return true;
-
-err_put:
-	spin_unlock_bh(&join_entry_locks[i]);
-	sock_put((struct sock *)msk);
-	return false;
 }
 
 void __init mptcp_join_cookie_init(void)
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index a98e554b034f..e581b341c5be 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -231,6 +231,7 @@ bool mptcp_token_exists(u32 token)
 
 /**
  * mptcp_token_get_sock - retrieve mptcp connection sock using its token
+ * @net: restrict to this namespace
  * @token: token of the mptcp connection to retrieve
  *
  * This function returns the mptcp connection structure with the given token.
@@ -238,7 +239,7 @@ bool mptcp_token_exists(u32 token)
  *
  * returns NULL if no connection with the given token value exists.
  */
-struct mptcp_sock *mptcp_token_get_sock(u32 token)
+struct mptcp_sock *mptcp_token_get_sock(struct net *net, u32 token)
 {
 	struct hlist_nulls_node *pos;
 	struct token_bucket *bucket;
@@ -251,11 +252,15 @@ struct mptcp_sock *mptcp_token_get_sock(u32 token)
 again:
 	sk_nulls_for_each_rcu(sk, pos, &bucket->msk_chain) {
 		msk = mptcp_sk(sk);
-		if (READ_ONCE(msk->token) != token)
+		if (READ_ONCE(msk->token) != token ||
+		    !net_eq(sock_net(sk), net))
 			continue;
+
 		if (!refcount_inc_not_zero(&sk->sk_refcnt))
 			goto not_found;
-		if (READ_ONCE(msk->token) != token) {
+
+		if (READ_ONCE(msk->token) != token ||
+		    !net_eq(sock_net(sk), net)) {
 			sock_put(sk);
 			goto again;
 		}
diff --git a/net/mptcp/token_test.c b/net/mptcp/token_test.c
index e1bd6f0a0676..5d984bec1cd8 100644
--- a/net/mptcp/token_test.c
+++ b/net/mptcp/token_test.c
@@ -11,6 +11,7 @@ static struct mptcp_subflow_request_sock *build_req_sock(struct kunit *test)
 			    GFP_USER);
 	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, req);
 	mptcp_token_init_request((struct request_sock *)req);
+	sock_net_set((struct sock *)req, &init_net);
 	return req;
 }
 
@@ -22,7 +23,7 @@ static void mptcp_token_test_req_basic(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, 0,
 			mptcp_token_new_request((struct request_sock *)req));
 	KUNIT_EXPECT_NE(test, 0, (int)req->token);
-	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(req->token));
+	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(&init_net, req->token));
 
 	/* cleanup */
 	mptcp_token_destroy_request((struct request_sock *)req);
@@ -55,6 +56,7 @@ static struct mptcp_sock *build_msk(struct kunit *test)
 	msk = kunit_kzalloc(test, sizeof(struct mptcp_sock), GFP_USER);
 	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, msk);
 	refcount_set(&((struct sock *)msk)->sk_refcnt, 1);
+	sock_net_set((struct sock *)msk, &init_net);
 	return msk;
 }
 
@@ -74,11 +76,11 @@ static void mptcp_token_test_msk_basic(struct kunit *test)
 			mptcp_token_new_connect((struct sock *)icsk));
 	KUNIT_EXPECT_NE(test, 0, (int)ctx->token);
 	KUNIT_EXPECT_EQ(test, ctx->token, msk->token);
-	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(ctx->token));
+	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(&init_net, ctx->token));
 	KUNIT_EXPECT_EQ(test, 2, (int)refcount_read(&sk->sk_refcnt));
 
 	mptcp_token_destroy(msk);
-	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(ctx->token));
+	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(&init_net, ctx->token));
 }
 
 static void mptcp_token_test_accept(struct kunit *test)
@@ -90,11 +92,11 @@ static void mptcp_token_test_accept(struct kunit *test)
 			mptcp_token_new_request((struct request_sock *)req));
 	msk->token = req->token;
 	mptcp_token_accept(req, msk);
-	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(msk->token));
+	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(&init_net, msk->token));
 
 	/* this is now a no-op */
 	mptcp_token_destroy_request((struct request_sock *)req);
-	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(msk->token));
+	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(&init_net, msk->token));
 
 	/* cleanup */
 	mptcp_token_destroy(msk);
@@ -116,7 +118,7 @@ static void mptcp_token_test_destroyed(struct kunit *test)
 
 	/* simulate race on removal */
 	refcount_set(&sk->sk_refcnt, 0);
-	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(msk->token));
+	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(&init_net, msk->token));
 
 	/* cleanup */
 	mptcp_token_destroy(msk);
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6186358eac7c..6e391308431d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -130,11 +130,11 @@ htable_size(u8 hbits)
 {
 	size_t hsize;
 
-	/* We must fit both into u32 in jhash and size_t */
+	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable)) / sizeof(struct hbucket *)
+	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index c100c6b112c8..2c467c422dc6 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1468,6 +1468,10 @@ int __init ip_vs_conn_init(void)
 	int idx;
 
 	/* Compute size and mask */
+	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
+		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
+		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
+	}
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d31dbccbe7bd..4f074d7653b8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -75,6 +75,9 @@ static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
+/* serialize hash resizes and nf_ct_iterate_cleanup */
+static DEFINE_MUTEX(nf_conntrack_mutex);
+
 #define GC_SCAN_INTERVAL	(120u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
@@ -2192,28 +2195,31 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	spinlock_t *lockp;
 
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
+		struct hlist_nulls_head *hslot = &nf_conntrack_hash[*bucket];
+
+		if (hlist_nulls_empty(hslot))
+			continue;
+
 		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
 		local_bh_disable();
 		nf_conntrack_lock(lockp);
-		if (*bucket < nf_conntrack_htable_size) {
-			hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_REPLY)
-					continue;
-				/* All nf_conn objects are added to hash table twice, one
-				 * for original direction tuple, once for the reply tuple.
-				 *
-				 * Exception: In the IPS_NAT_CLASH case, only the reply
-				 * tuple is added (the original tuple already existed for
-				 * a different object).
-				 *
-				 * We only need to call the iterator once for each
-				 * conntrack, so we just use the 'reply' direction
-				 * tuple while iterating.
-				 */
-				ct = nf_ct_tuplehash_to_ctrack(h);
-				if (iter(ct, data))
-					goto found;
-			}
+		hlist_nulls_for_each_entry(h, n, hslot, hnnode) {
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_REPLY)
+				continue;
+			/* All nf_conn objects are added to hash table twice, one
+			 * for original direction tuple, once for the reply tuple.
+			 *
+			 * Exception: In the IPS_NAT_CLASH case, only the reply
+			 * tuple is added (the original tuple already existed for
+			 * a different object).
+			 *
+			 * We only need to call the iterator once for each
+			 * conntrack, so we just use the 'reply' direction
+			 * tuple while iterating.
+			 */
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				goto found;
 		}
 		spin_unlock(lockp);
 		local_bh_enable();
@@ -2231,26 +2237,20 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 				  void *data, u32 portid, int report)
 {
-	unsigned int bucket = 0, sequence;
+	unsigned int bucket = 0;
 	struct nf_conn *ct;
 
 	might_sleep();
 
-	for (;;) {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-
-		while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
-			/* Time to push up daises... */
+	mutex_lock(&nf_conntrack_mutex);
+	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
+		/* Time to push up daises... */
 
-			nf_ct_delete(ct, portid, report);
-			nf_ct_put(ct);
-			cond_resched();
-		}
-
-		if (!read_seqcount_retry(&nf_conntrack_generation, sequence))
-			break;
-		bucket = 0;
+		nf_ct_delete(ct, portid, report);
+		nf_ct_put(ct);
+		cond_resched();
 	}
+	mutex_unlock(&nf_conntrack_mutex);
 }
 
 struct iter_data {
@@ -2486,8 +2486,10 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	if (!hash)
 		return -ENOMEM;
 
+	mutex_lock(&nf_conntrack_mutex);
 	old_size = nf_conntrack_htable_size;
 	if (old_size == hashsize) {
+		mutex_unlock(&nf_conntrack_mutex);
 		kvfree(hash);
 		return 0;
 	}
@@ -2523,6 +2525,8 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	nf_conntrack_all_unlock();
 	local_bh_enable();
 
+	mutex_unlock(&nf_conntrack_mutex);
+
 	synchronize_net();
 	kvfree(old_hash);
 	return 0;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..b9546defdc28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4336,7 +4336,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 	alloc_size = sizeof(*set) + size + udlen;
-	if (alloc_size < size)
+	if (alloc_size < size || alloc_size > INT_MAX)
 		return -ENOMEM;
 	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)
@@ -9599,7 +9599,6 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		table->use--;
 		nf_tables_chain_destroy(&ctx);
 	}
-	list_del(&table->list);
 	nf_tables_table_destroy(&ctx);
 }
 
@@ -9612,6 +9611,8 @@ static void __nft_release_tables(struct net *net)
 		if (nft_table_has_owner(table))
 			continue;
 
+		list_del(&table->list);
+
 		__nft_release_table(net, table);
 	}
 }
@@ -9619,31 +9620,38 @@ static void __nft_release_tables(struct net *net)
 static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
+	struct nft_table *table, *to_delete[8];
 	struct nftables_pernet *nft_net;
 	struct netlink_notify *n = ptr;
-	struct nft_table *table, *nt;
 	struct net *net = n->net;
-	bool release = false;
+	unsigned int deleted;
+	bool restart = false;
 
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(net);
+	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
+again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
 			__nft_release_hook(net, table);
-			release = true;
+			list_del_rcu(&table->list);
+			to_delete[deleted++] = table;
+			if (deleted >= ARRAY_SIZE(to_delete))
+				break;
 		}
 	}
-	if (release) {
+	if (deleted) {
+		restart = deleted >= ARRAY_SIZE(to_delete);
 		synchronize_rcu();
-		list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
-			if (nft_table_has_owner(table) &&
-			    n->portid == table->nlpid)
-				__nft_release_table(net, table);
-		}
+		while (deleted)
+			__nft_release_table(net, to_delete[--deleted]);
+
+		if (restart)
+			goto again;
 	}
 	mutex_unlock(&nft_net->commit_mutex);
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 272bcdb1392d..f69cc73c5813 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_log.h>
 
 /* Used for matches where *info is larger than X byte */
 #define NFT_MATCH_LARGE_THRESH	192
@@ -257,8 +258,22 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	nft_compat_wait_for_destructors();
 
 	ret = xt_check_target(&par, size, proto, inv);
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -ENOENT) {
+			const char *modname = NULL;
+
+			if (strcmp(target->name, "LOG") == 0)
+				modname = "nf_log_syslog";
+			else if (strcmp(target->name, "NFLOG") == 0)
+				modname = "nfnetlink_log";
+
+			if (modname &&
+			    nft_request_module(ctx->net, "%s", modname) == -EAGAIN)
+				return -EAGAIN;
+		}
+
 		return ret;
+	}
 
 	/* The standard target cannot be used */
 	if (!target->target)
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index 2ff75f7637b0..f39244f9c0ed 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -44,6 +44,7 @@ log_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int log_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_log_info *loginfo = par->targinfo;
+	int ret;
 
 	if (par->family != NFPROTO_IPV4 && par->family != NFPROTO_IPV6)
 		return -EINVAL;
@@ -58,7 +59,14 @@ static int log_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	}
 
-	return nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+	if (ret != 0 && !par->nft_compat) {
+		request_module("%s", "nf_log_syslog");
+
+		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_LOG);
+	}
+
+	return ret;
 }
 
 static void log_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index fb5793208059..e660c3710a10 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -42,13 +42,21 @@ nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_nflog_info *info = par->targinfo;
+	int ret;
 
 	if (info->flags & ~XT_NFLOG_MASK)
 		return -EINVAL;
 	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
 		return -EINVAL;
 
-	return nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	if (ret != 0 && !par->nft_compat) {
+		request_module("%s", "nfnetlink_log");
+
+		ret = nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+	}
+
+	return ret;
 }
 
 static void nflog_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index d7869a984881..d2a4e31d963d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2188,18 +2188,24 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 
 	arg->count = arg->skip;
 
+	rcu_read_lock();
 	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
 		/* don't return filters that are being deleted */
 		if (!refcount_inc_not_zero(&f->refcnt))
 			continue;
+		rcu_read_unlock();
+
 		if (arg->fn(tp, f, arg) < 0) {
 			__fl_put(f);
 			arg->stop = 1;
+			rcu_read_lock();
 			break;
 		}
 		__fl_put(f);
 		arg->count++;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	arg->cookie = id;
 }
 
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 5ef86fdb1176..1f1786021d9c 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -702,7 +702,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 		ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
 
 		/* Break out if chunk length is less then minimal. */
-		if (ntohs(ch->length) < sizeof(_ch))
+		if (!ch || ntohs(ch->length) < sizeof(_ch))
 			break;
 
 		ch_end = offset + SCTP_PAD4(ntohs(ch->length));
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 91ff09d833e8..f96ee27d9ff2 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -600,20 +600,42 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 static void init_peercred(struct sock *sk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(task_tgid(current));
 	sk->sk_peer_cred = get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static int unix_listen(struct socket *sock, int backlog)
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 6c0a4a67ad2e..6f30231bdb88 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -873,12 +873,21 @@ static long snd_rawmidi_ioctl(struct file *file, unsigned int cmd, unsigned long
 			return -EINVAL;
 		}
 	}
+	case SNDRV_RAWMIDI_IOCTL_USER_PVERSION:
+		if (get_user(rfile->user_pversion, (unsigned int __user *)arg))
+			return -EFAULT;
+		return 0;
+
 	case SNDRV_RAWMIDI_IOCTL_PARAMS:
 	{
 		struct snd_rawmidi_params params;
 
 		if (copy_from_user(&params, argp, sizeof(struct snd_rawmidi_params)))
 			return -EFAULT;
+		if (rfile->user_pversion < SNDRV_PROTOCOL_VERSION(2, 0, 2)) {
+			params.mode = 0;
+			memset(params.reserved, 0, sizeof(params.reserved));
+		}
 		switch (params.stream) {
 		case SNDRV_RAWMIDI_STREAM_OUTPUT:
 			if (rfile->output == NULL)
diff --git a/sound/firewire/motu/amdtp-motu.c b/sound/firewire/motu/amdtp-motu.c
index 5388b85fb60e..a18c2c033e83 100644
--- a/sound/firewire/motu/amdtp-motu.c
+++ b/sound/firewire/motu/amdtp-motu.c
@@ -276,10 +276,11 @@ static void __maybe_unused copy_message(u64 *frames, __be32 *buffer,
 
 	/* This is just for v2/v3 protocol. */
 	for (i = 0; i < data_blocks; ++i) {
-		*frames = (be32_to_cpu(buffer[1]) << 16) |
-			  (be32_to_cpu(buffer[2]) >> 16);
+		*frames = be32_to_cpu(buffer[1]);
+		*frames <<= 16;
+		*frames |= be32_to_cpu(buffer[2]) >> 16;
+		++frames;
 		buffer += data_block_quadlets;
-		frames++;
 	}
 }
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 70516527ebce..0b9230a274b0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6442,6 +6442,20 @@ static void alc_fixup_thinkpad_acpi(struct hda_codec *codec,
 	hda_fixup_thinkpad_acpi(codec, fix, action);
 }
 
+/* Fixup for Lenovo Legion 15IMHg05 speaker output on headset removal. */
+static void alc287_fixup_legion_15imhg05_speakers(struct hda_codec *codec,
+						  const struct hda_fixup *fix,
+						  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gen.suppress_auto_mute = 1;
+		break;
+	}
+}
+
 /* for alc295_fixup_hp_top_speakers */
 #include "hp_x360_helper.c"
 
@@ -6659,6 +6673,10 @@ enum {
 	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
 	ALC255_FIXUP_ACER_HEADPHONE_AND_MIC,
 	ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST,
+	ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS,
+	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
+	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
+	ALC287_FIXUP_13S_GEN2_SPEAKERS
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8249,6 +8267,113 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
 	},
+	[ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS] = {
+		.type = HDA_FIXUP_VERBS,
+		//.v.verbs = legion_15imhg05_coefs,
+		.v.verbs = (const struct hda_verb[]) {
+			 // set left speaker Legion 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 // set right speaker Legion 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			 {}
+		},
+		.chained = true,
+		.chain_id = ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
+	},
+	[ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_legion_15imhg05_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE,
+	},
+	[ALC287_FIXUP_YOGA7_14ITL_SPEAKERS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			 // set left speaker Yoga 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 // set right speaker Yoga 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x46 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			 {}
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE,
+	},
+	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8643,6 +8768,10 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
+	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index a961f837cd09..bda66b30e063 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -1073,6 +1073,16 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm_get_sync;
 
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = imx_pcm_dma_init(pdev, IMX_ESAI_DMABUF_SIZE);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to init imx pcm dma: %d\n", ret);
+		goto err_pm_get_sync;
+	}
+
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_esai_component,
 					      &fsl_esai_dai, 1);
 	if (ret) {
@@ -1082,12 +1092,6 @@ static int fsl_esai_probe(struct platform_device *pdev)
 
 	INIT_WORK(&esai_priv->work, fsl_esai_hw_reset);
 
-	ret = imx_pcm_dma_init(pdev, IMX_ESAI_DMABUF_SIZE);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to init imx pcm dma: %d\n", ret);
-		goto err_pm_get_sync;
-	}
-
 	return ret;
 
 err_pm_get_sync:
diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 8c0c75ce9490..9f90989ac59a 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -737,18 +737,23 @@ static int fsl_micfil_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	regcache_cache_only(micfil->regmap, true);
 
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to pcm register\n");
+		return ret;
+	}
+
 	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_micfil_component,
 					      &fsl_micfil_dai, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register component %s\n",
 			fsl_micfil_component.name);
-		return ret;
 	}
 
-	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
-	if (ret)
-		dev_err(&pdev->dev, "failed to pcm register\n");
-
 	return ret;
 }
 
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 223fcd15bfcc..38f6362099d5 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1152,11 +1152,10 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm_get_sync;
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
-					      &sai->cpu_dai_drv, 1);
-	if (ret)
-		goto err_pm_get_sync;
-
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
 	if (sai->soc_data->use_imx_pcm) {
 		ret = imx_pcm_dma_init(pdev, IMX_SAI_DMABUF_SIZE);
 		if (ret)
@@ -1167,6 +1166,11 @@ static int fsl_sai_probe(struct platform_device *pdev)
 			goto err_pm_get_sync;
 	}
 
+	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
+					      &sai->cpu_dai_drv, 1);
+	if (ret)
+		goto err_pm_get_sync;
+
 	return ret;
 
 err_pm_get_sync:
diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 8ffb1a6048d6..1c53719bb61e 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -1434,16 +1434,20 @@ static int fsl_spdif_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	regcache_cache_only(spdif_priv->regmap, true);
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_spdif_component,
-					      &spdif_priv->cpu_dai_drv, 1);
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = imx_pcm_dma_init(pdev, IMX_SPDIF_DMABUF_SIZE);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to register DAI: %d\n", ret);
+		dev_err_probe(&pdev->dev, ret, "imx_pcm_dma_init failed\n");
 		goto err_pm_disable;
 	}
 
-	ret = imx_pcm_dma_init(pdev, IMX_SPDIF_DMABUF_SIZE);
+	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_spdif_component,
+					      &spdif_priv->cpu_dai_drv, 1);
 	if (ret) {
-		dev_err_probe(&pdev->dev, ret, "imx_pcm_dma_init failed\n");
+		dev_err(&pdev->dev, "failed to register DAI: %d\n", ret);
 		goto err_pm_disable;
 	}
 
diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index fb7c29fc39d7..477d16713e72 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1217,18 +1217,23 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	regcache_cache_only(xcvr->regmap, true);
 
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = devm_snd_dmaengine_pcm_register(dev, NULL, 0);
+	if (ret) {
+		dev_err(dev, "failed to pcm register\n");
+		return ret;
+	}
+
 	ret = devm_snd_soc_register_component(dev, &fsl_xcvr_comp,
 					      &fsl_xcvr_dai, 1);
 	if (ret) {
 		dev_err(dev, "failed to register component %s\n",
 			fsl_xcvr_comp.name);
-		return ret;
 	}
 
-	ret = devm_snd_dmaengine_pcm_register(dev, NULL, 0);
-	if (ret)
-		dev_err(dev, "failed to pcm register\n");
-
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/common/mtk-afe-fe-dai.c b/sound/soc/mediatek/common/mtk-afe-fe-dai.c
index 3cb2adf420bb..ab7bbd53bb01 100644
--- a/sound/soc/mediatek/common/mtk-afe-fe-dai.c
+++ b/sound/soc/mediatek/common/mtk-afe-fe-dai.c
@@ -334,9 +334,11 @@ int mtk_afe_suspend(struct snd_soc_component *component)
 			devm_kcalloc(dev, afe->reg_back_up_list_num,
 				     sizeof(unsigned int), GFP_KERNEL);
 
-	for (i = 0; i < afe->reg_back_up_list_num; i++)
-		regmap_read(regmap, afe->reg_back_up_list[i],
-			    &afe->reg_back_up[i]);
+	if (afe->reg_back_up) {
+		for (i = 0; i < afe->reg_back_up_list_num; i++)
+			regmap_read(regmap, afe->reg_back_up_list[i],
+				    &afe->reg_back_up[i]);
+	}
 
 	afe->suspended = true;
 	afe->runtime_suspend(dev);
@@ -356,12 +358,13 @@ int mtk_afe_resume(struct snd_soc_component *component)
 
 	afe->runtime_resume(dev);
 
-	if (!afe->reg_back_up)
+	if (!afe->reg_back_up) {
 		dev_dbg(dev, "%s no reg_backup\n", __func__);
-
-	for (i = 0; i < afe->reg_back_up_list_num; i++)
-		mtk_regmap_write(regmap, afe->reg_back_up_list[i],
-				 afe->reg_back_up[i]);
+	} else {
+		for (i = 0; i < afe->reg_back_up_list_num; i++)
+			mtk_regmap_write(regmap, afe->reg_back_up_list[i],
+					 afe->reg_back_up[i]);
+	}
 
 	afe->suspended = false;
 	return 0;
diff --git a/sound/soc/sof/imx/imx8.c b/sound/soc/sof/imx/imx8.c
index 12fedf0984bd..7e9723a10d02 100644
--- a/sound/soc/sof/imx/imx8.c
+++ b/sound/soc/sof/imx/imx8.c
@@ -365,7 +365,14 @@ static int imx8_remove(struct snd_sof_dev *sdev)
 /* on i.MX8 there is 1 to 1 match between type and BAR idx */
 static int imx8_get_bar_index(struct snd_sof_dev *sdev, u32 type)
 {
-	return type;
+	/* Only IRAM and SRAM bars are valid */
+	switch (type) {
+	case SOF_FW_BLK_TYPE_IRAM:
+	case SOF_FW_BLK_TYPE_SRAM:
+		return type;
+	default:
+		return -EINVAL;
+	}
 }
 
 static void imx8_ipc_msg_data(struct snd_sof_dev *sdev,
diff --git a/sound/soc/sof/imx/imx8m.c b/sound/soc/sof/imx/imx8m.c
index cb822d953767..892e1482f97f 100644
--- a/sound/soc/sof/imx/imx8m.c
+++ b/sound/soc/sof/imx/imx8m.c
@@ -228,7 +228,14 @@ static int imx8m_remove(struct snd_sof_dev *sdev)
 /* on i.MX8 there is 1 to 1 match between type and BAR idx */
 static int imx8m_get_bar_index(struct snd_sof_dev *sdev, u32 type)
 {
-	return type;
+	/* Only IRAM and SRAM bars are valid */
+	switch (type) {
+	case SOF_FW_BLK_TYPE_IRAM:
+	case SOF_FW_BLK_TYPE_SRAM:
+		return type;
+	default:
+		return -EINVAL;
+	}
 }
 
 static void imx8m_ipc_msg_data(struct snd_sof_dev *sdev,
diff --git a/sound/soc/sof/xtensa/core.c b/sound/soc/sof/xtensa/core.c
index bbb9a2282ed9..f6e3411b33cf 100644
--- a/sound/soc/sof/xtensa/core.c
+++ b/sound/soc/sof/xtensa/core.c
@@ -122,9 +122,9 @@ static void xtensa_stack(struct snd_sof_dev *sdev, void *oops, u32 *stack,
 	 * 0x0049fbb0: 8000f2d0 0049fc00 6f6c6c61 00632e63
 	 */
 	for (i = 0; i < stack_words; i += 4) {
-		hex_dump_to_buffer(stack + i * 4, 16, 16, 4,
+		hex_dump_to_buffer(stack + i, 16, 16, 4,
 				   buf, sizeof(buf), false);
-		dev_err(sdev->dev, "0x%08x: %s\n", stack_ptr + i, buf);
+		dev_err(sdev->dev, "0x%08x: %s\n", stack_ptr + i * 4, buf);
 	}
 }
 
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 10911a8cad0f..2df880cefdae 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1649,11 +1649,17 @@ static bool btf_is_non_static(const struct btf_type *t)
 static int find_glob_sym_btf(struct src_obj *obj, Elf64_Sym *sym, const char *sym_name,
 			     int *out_btf_sec_id, int *out_btf_id)
 {
-	int i, j, n = btf__get_nr_types(obj->btf), m, btf_id = 0;
+	int i, j, n, m, btf_id = 0;
 	const struct btf_type *t;
 	const struct btf_var_secinfo *vi;
 	const char *name;
 
+	if (!obj->btf) {
+		pr_warn("failed to find BTF info for object '%s'\n", obj->filename);
+		return -EINVAL;
+	}
+
+	n = btf__get_nr_types(obj->btf);
 	for (i = 1; i <= n; i++) {
 		t = btf__type_by_id(obj->btf, i);
 
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index bc925cf19e2d..f1428e32a505 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -58,6 +58,24 @@ void __weak arch_handle_alternative(unsigned short feature, struct special_alt *
 {
 }
 
+static bool reloc2sec_off(struct reloc *reloc, struct section **sec, unsigned long *off)
+{
+	switch (reloc->sym->type) {
+	case STT_FUNC:
+		*sec = reloc->sym->sec;
+		*off = reloc->sym->offset + reloc->addend;
+		return true;
+
+	case STT_SECTION:
+		*sec = reloc->sym->sec;
+		*off = reloc->addend;
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 			 struct section *sec, int idx,
 			 struct special_alt *alt)
@@ -91,15 +109,14 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 		WARN_FUNC("can't find orig reloc", sec, offset + entry->orig);
 		return -1;
 	}
-	if (orig_reloc->sym->type != STT_SECTION) {
-		WARN_FUNC("don't know how to handle non-section reloc symbol %s",
-			   sec, offset + entry->orig, orig_reloc->sym->name);
+	if (!reloc2sec_off(orig_reloc, &alt->orig_sec, &alt->orig_off)) {
+		WARN_FUNC("don't know how to handle reloc symbol type %d: %s",
+			   sec, offset + entry->orig,
+			   orig_reloc->sym->type,
+			   orig_reloc->sym->name);
 		return -1;
 	}
 
-	alt->orig_sec = orig_reloc->sym->sec;
-	alt->orig_off = orig_reloc->addend;
-
 	if (!entry->group || alt->new_len) {
 		new_reloc = find_reloc_by_dest(elf, sec, offset + entry->new);
 		if (!new_reloc) {
@@ -116,8 +133,13 @@ static int get_alt_entry(struct elf *elf, struct special_entry *entry,
 		if (arch_is_retpoline(new_reloc->sym))
 			return 1;
 
-		alt->new_sec = new_reloc->sym->sec;
-		alt->new_off = (unsigned int)new_reloc->addend;
+		if (!reloc2sec_off(new_reloc, &alt->new_sec, &alt->new_off)) {
+			WARN_FUNC("don't know how to handle reloc symbol type %d: %s",
+				  sec, offset + entry->new,
+				  new_reloc->sym->type,
+				  new_reloc->sym->name);
+			return -1;
+		}
 
 		/* _ASM_EXTABLE_EX hack */
 		if (alt->new_off >= 0x7ffffff0)
diff --git a/tools/perf/arch/x86/util/iostat.c b/tools/perf/arch/x86/util/iostat.c
index eeafe97b8105..792cd75ade33 100644
--- a/tools/perf/arch/x86/util/iostat.c
+++ b/tools/perf/arch/x86/util/iostat.c
@@ -432,7 +432,7 @@ void iostat_print_metric(struct perf_stat_config *config, struct evsel *evsel,
 	u8 die = ((struct iio_root_port *)evsel->priv)->die;
 	struct perf_counts_values *count = perf_counts(evsel->counts, die, 0);
 
-	if (count->run && count->ena) {
+	if (count && count->run && count->ena) {
 		if (evsel->prev_raw_counts && !out->force_header) {
 			struct perf_counts_values *prev_count =
 				perf_counts(evsel->prev_raw_counts, die, 0);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 634375937db9..36033a7372f9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2406,6 +2406,8 @@ int cmd_stat(int argc, const char **argv)
 			goto out;
 		} else if (verbose)
 			iostat_list(evsel_list, &stat_config);
+		if (iostat_mode == IOSTAT_RUN && !target__has_cpu(&target))
+			target.system_wide = true;
 	}
 
 	if (add_default_attributes())
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index a288035eb362..c756284b3b13 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -20,6 +20,23 @@
 /* For bsearch. We try to unwind functions in shared object. */
 #include <stdlib.h>
 
+/*
+ * The test will assert frames are on the stack but tail call optimizations lose
+ * the frame of the caller. Clang can disable this optimization on a called
+ * function but GCC currently (11/2020) lacks this attribute. The barrier is
+ * used to inhibit tail calls in these cases.
+ */
+#ifdef __has_attribute
+#if __has_attribute(disable_tail_calls)
+#define NO_TAIL_CALL_ATTRIBUTE __attribute__((disable_tail_calls))
+#define NO_TAIL_CALL_BARRIER
+#endif
+#endif
+#ifndef NO_TAIL_CALL_ATTRIBUTE
+#define NO_TAIL_CALL_ATTRIBUTE
+#define NO_TAIL_CALL_BARRIER __asm__ __volatile__("" : : : "memory");
+#endif
+
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
 			struct perf_sample *sample,
@@ -91,7 +108,7 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 	return strcmp((const char *) symbol, funcs[idx]);
 }
 
-noinline int test_dwarf_unwind__thread(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__thread(struct thread *thread)
 {
 	struct perf_sample sample;
 	unsigned long cnt = 0;
@@ -122,7 +139,7 @@ noinline int test_dwarf_unwind__thread(struct thread *thread)
 
 static int global_unwind_retval = -INT_MAX;
 
-noinline int test_dwarf_unwind__compare(void *p1, void *p2)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__compare(void *p1, void *p2)
 {
 	/* Any possible value should be 'thread' */
 	struct thread *thread = *(struct thread **)p1;
@@ -141,7 +158,7 @@ noinline int test_dwarf_unwind__compare(void *p1, void *p2)
 	return p1 - p2;
 }
 
-noinline int test_dwarf_unwind__krava_3(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__krava_3(struct thread *thread)
 {
 	struct thread *array[2] = {thread, thread};
 	void *fp = &bsearch;
@@ -160,14 +177,22 @@ noinline int test_dwarf_unwind__krava_3(struct thread *thread)
 	return global_unwind_retval;
 }
 
-noinline int test_dwarf_unwind__krava_2(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__krava_2(struct thread *thread)
 {
-	return test_dwarf_unwind__krava_3(thread);
+	int ret;
+
+	ret =  test_dwarf_unwind__krava_3(thread);
+	NO_TAIL_CALL_BARRIER;
+	return ret;
 }
 
-noinline int test_dwarf_unwind__krava_1(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__krava_1(struct thread *thread)
 {
-	return test_dwarf_unwind__krava_2(thread);
+	int ret;
+
+	ret =  test_dwarf_unwind__krava_2(thread);
+	NO_TAIL_CALL_BARRIER;
+	return ret;
 }
 
 int test__dwarf_unwind(struct test *test __maybe_unused, int subtest __maybe_unused)
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f405b20c1e6c..93f1f124ef89 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -374,7 +374,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		     $(TRUNNER_BPF_PROGS_DIR)/%.c			\
 		     $(TRUNNER_BPF_PROGS_DIR)/*.h			\
 		     $$(INCLUDE_DIR)/vmlinux.h				\
-		     $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)
+		     $(wildcard $(BPFDIR)/bpf_*.h)			\
+		     | $(TRUNNER_OUTPUT) $$(BPFOBJ)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS))
 
diff --git a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
index 59ea56945e6c..b497bb85b667 100755
--- a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
+++ b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
@@ -112,6 +112,14 @@ setup()
 	ip netns add "${NS2}"
 	ip netns add "${NS3}"
 
+	# rp_filter gets confused by what these tests are doing, so disable it
+	ip netns exec ${NS1} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${NS1} sysctl -wq net.ipv4.conf.default.rp_filter=0
+	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.default.rp_filter=0
+	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.default.rp_filter=0
+
 	ip link add veth1 type veth peer name veth2
 	ip link add veth3 type veth peer name veth4
 	ip link add veth5 type veth peer name veth6
@@ -236,11 +244,6 @@ setup()
 	ip -netns ${NS1} -6 route add ${IPv6_GRE}/128 dev veth5 via ${IPv6_6} ${VRF}
 	ip -netns ${NS2} -6 route add ${IPv6_GRE}/128 dev veth7 via ${IPv6_8} ${VRF}
 
-	# rp_filter gets confused by what these tests are doing, so disable it
-	ip netns exec ${NS1} sysctl -wq net.ipv4.conf.all.rp_filter=0
-	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.all.rp_filter=0
-	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.all.rp_filter=0
-
 	TMPFILE=$(mktemp /tmp/test_lwt_ip_encap.XXXXXX)
 
 	sleep 1  # reduce flakiness
