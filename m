Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A15157DE08
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiGVJNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbiGVJND (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F3180F40;
        Fri, 22 Jul 2022 02:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D141161EE6;
        Fri, 22 Jul 2022 09:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D901AC341C6;
        Fri, 22 Jul 2022 09:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481029;
        bh=24ob/7h00TzVVLTobzWQ1zjvJdDqDNMmJEr8a2tT7g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vj7FoYnFTZ2CCiaHIL9nn9bPtOKSewad4/8J86reIQtai9fF5j1w6o0y1JooZO6jq
         CYqmWFWHjh2iww4RIPWBlgeQlUHI94xZ0ykaU2znNo2x8Tpp2/27xGUQQtHrm1sefA
         14MKQHSIiWa2rXiYjfxSKxTXa40Yq4tMzvNfKl2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 52/70] KVM: VMX: Prevent RSB underflow before vmenter
Date:   Fri, 22 Jul 2022 11:07:47 +0200
Message-Id: <20220722090653.635310511@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 07853adc29a058c5fd143c14e5ac528448a72ed9 upstream.

On VMX, there are some balanced returns between the time the guest's
SPEC_CTRL value is written, and the vmenter.

Balanced returns (matched by a preceding call) are usually ok, but it's
at least theoretically possible an NMI with a deep call stack could
empty the RSB before one of the returns.

For maximum paranoia, don't allow *any* returns (balanced or otherwise)
between the SPEC_CTRL write and the vmenter.

  [ bp: Fix 32-bit build. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: header conflict fixup at arch/x86/kernel/asm-offsets.c]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/asm-offsets.c   |    6 ++++++
 arch/x86/kernel/cpu/bugs.c      |    4 ++--
 arch/x86/kvm/vmx/capabilities.h |    4 ++--
 arch/x86/kvm/vmx/vmenter.S      |   29 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |    8 --------
 arch/x86/kvm/vmx/vmx.h          |    4 ++--
 arch/x86/kvm/vmx/vmx_ops.h      |    2 +-
 7 files changed, 42 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -18,6 +18,7 @@
 #include <asm/bootparam.h>
 #include <asm/suspend.h>
 #include <asm/tlbflush.h>
+#include "../kvm/vmx/vmx.h"
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -90,4 +91,9 @@ static void __used common(void)
 	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
+
+	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
+		BLANK();
+		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
+	}
 }
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -196,8 +196,8 @@ void __init check_bugs(void)
 }
 
 /*
- * NOTE: For VMX, this function is not called in the vmexit path.
- * It uses vmx_spec_ctrl_restore_host() instead.
+ * NOTE: This function is *only* called for SVM.  VMX spec_ctrl handling is
+ * done in vmenter.S.
  */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -4,8 +4,8 @@
 
 #include <asm/vmx.h>
 
-#include "lapic.h"
-#include "x86.h"
+#include "../lapic.h"
+#include "../x86.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -1,9 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
 #include <asm/asm.h>
+#include <asm/asm-offsets.h>
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
+#include <asm/percpu.h>
 #include <asm/segment.h>
 #include "run_flags.h"
 
@@ -73,6 +75,33 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
+	ALTERNATIVE "jmp .Lspec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL
+
+	/*
+	 * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
+	 * host's, write the MSR.
+	 *
+	 * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
+	 * there must not be any returns or indirect branches between this code
+	 * and vmentry.
+	 */
+	mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
+	movl VMX_spec_ctrl(%_ASM_DI), %edi
+	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
+	cmp %edi, %esi
+	je .Lspec_ctrl_done
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+	xor %edx, %edx
+	mov %edi, %eax
+	wrmsr
+
+.Lspec_ctrl_done:
+
+	/*
+	 * Since vmentry is serializing on affected CPUs, there's no need for
+	 * an LFENCE to stop speculation from skipping the wrmsr.
+	 */
+
 	/* Load @regs to RAX. */
 	mov (%_ASM_SP), %_ASM_AX
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6989,14 +6989,6 @@ static fastpath_t vmx_vcpu_run(struct kv
 
 	kvm_wait_lapic_expire(vcpu);
 
-	/*
-	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
-	 * is no need to worry about the conditional branch over the wrmsr
-	 * being speculatively taken.
-	 */
-	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
-
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
 
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -8,11 +8,11 @@
 #include <asm/intel_pt.h>
 
 #include "capabilities.h"
-#include "kvm_cache_regs.h"
+#include "../kvm_cache_regs.h"
 #include "posted_intr.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
-#include "cpuid.h"
+#include "../cpuid.h"
 #include "run_flags.h"
 
 #define MSR_TYPE_R	1
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -8,7 +8,7 @@
 
 #include "evmcs.h"
 #include "vmcs.h"
-#include "x86.h"
+#include "../x86.h"
 
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,


