Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE1C681071
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbjA3ODi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbjA3OD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEBA83E0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1C34B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411F6C433EF;
        Mon, 30 Jan 2023 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087397;
        bh=ItEvHt2B5btUuy6Y7JSILpJ70H93E8QtbKfpbKDTKCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8bqNI4CqeDRWcoOyvacLlXJmTo1URBVZEVhSlXhfAlqfPnPmZhuqjv7/2AYOuZ0k
         nglEEk8AfEbxnbxtLkpLY54v16gp9wuJJDoTyBu1lTjc18XnSevS/5Tb2lUZscTv87
         VADlZsIbCq5MqdWl+h8+we33mcEJuONEC5dt4wO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/313] arm64: efi: Recover from synchronous exceptions occurring in firmware
Date:   Mon, 30 Jan 2023 14:50:29 +0100
Message-Id: <20230130134345.730672956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit e8dfdf3162eb549d064b8c10b1564f7e8ee82591 ]

Unlike x86, which has machinery to deal with page faults that occur
during the execution of EFI runtime services, arm64 has nothing like
that, and a synchronous exception raised by firmware code brings down
the whole system.

With more EFI based systems appearing that were not built to run Linux
(such as the Windows-on-ARM laptops based on Qualcomm SOCs), as well as
the introduction of PRM (platform specific firmware routines that are
callable just like EFI runtime services), we are more likely to run into
issues of this sort, and it is much more likely that we can identify and
work around such issues if they don't bring down the system entirely.

Since we already use a EFI runtime services call wrapper in assembler,
we can quite easily add some code that captures the execution state at
the point where the call is made, allowing us to revert to this state
and proceed execution if the call triggered a synchronous exception.

Given that the kernel and the firmware don't share any data structures
that could end up in an indeterminate state, we can happily continue
running, as long as we mark the EFI runtime services as unavailable from
that point on.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 8a9a1a18731e ("arm64: efi: Avoid workqueue to check whether EFI runtime is live")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/efi.h            |  8 +++++++
 arch/arm64/kernel/efi-rt-wrapper.S      | 32 +++++++++++++++++++++----
 arch/arm64/kernel/efi.c                 | 22 +++++++++++++++++
 arch/arm64/mm/fault.c                   |  4 ++++
 drivers/firmware/efi/runtime-wrappers.c |  1 +
 5 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index b9f3165075c9..0edaf8e385b8 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,8 +14,16 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
+
+bool efi_runtime_fixup_exception(struct pt_regs *regs, const char *msg);
 #else
 #define efi_init()
+
+static inline
+bool efi_runtime_fixup_exception(struct pt_regs *regs, const char *msg)
+{
+	return false;
+}
 #endif
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 2d3c4b02393e..d872d18101d8 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -7,7 +7,7 @@
 #include <asm/assembler.h>
 
 SYM_FUNC_START(__efi_rt_asm_wrapper)
-	stp	x29, x30, [sp, #-32]!
+	stp	x29, x30, [sp, #-112]!
 	mov	x29, sp
 
 	/*
@@ -17,11 +17,21 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	 */
 	stp	x1, x18, [sp, #16]
 
+	/*
+	 * Preserve all callee saved registers and preserve the stack pointer
+	 * value at the base of the EFI runtime stack so we can recover from
+	 * synchronous exceptions occurring while executing the firmware
+	 * routines.
+	 */
+	stp	x19, x20, [sp, #32]
+	stp	x21, x22, [sp, #48]
+	stp	x23, x24, [sp, #64]
+	stp	x25, x26, [sp, #80]
+	stp	x27, x28, [sp, #96]
+
 	ldr_l	x16, efi_rt_stack_top
 	mov	sp, x16
-#ifdef CONFIG_SHADOW_CALL_STACK
-	str	x18, [sp, #-16]!
-#endif
+	stp	x18, x29, [sp, #-16]!
 
 	/*
 	 * We are lucky enough that no EFI runtime services take more than
@@ -39,7 +49,7 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	mov	sp, x29
 	ldp	x1, x2, [sp, #16]
 	cmp	x2, x18
-	ldp	x29, x30, [sp], #32
+	ldp	x29, x30, [sp], #112
 	b.ne	0f
 	ret
 0:
@@ -57,3 +67,15 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 
 	b	efi_handle_corrupted_x18	// tail call
 SYM_FUNC_END(__efi_rt_asm_wrapper)
+
+SYM_CODE_START(__efi_rt_asm_recover)
+	mov	sp, x30
+
+	ldp	x19, x20, [sp, #32]
+	ldp	x21, x22, [sp, #48]
+	ldp	x23, x24, [sp, #64]
+	ldp	x25, x26, [sp, #80]
+	ldp	x27, x28, [sp, #96]
+	ldp	x29, x30, [sp], #112
+	ret
+SYM_CODE_END(__efi_rt_asm_recover)
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 386bd81ca12b..fab05de2e12d 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -149,6 +149,28 @@ DEFINE_SPINLOCK(efi_rt_lock);
 
 asmlinkage u64 *efi_rt_stack_top __ro_after_init;
 
+asmlinkage efi_status_t __efi_rt_asm_recover(void);
+
+bool efi_runtime_fixup_exception(struct pt_regs *regs, const char *msg)
+{
+	 /* Check whether the exception occurred while running the firmware */
+	if (current_work() != &efi_rts_work.work || regs->pc >= TASK_SIZE_64)
+		return false;
+
+	pr_err(FW_BUG "Unable to handle %s in EFI runtime service\n", msg);
+	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
+	regs->regs[0]	= EFI_ABORTED;
+	regs->regs[30]	= efi_rt_stack_top[-1];
+	regs->pc	= (u64)__efi_rt_asm_recover;
+
+	if (IS_ENABLED(CONFIG_SHADOW_CALL_STACK))
+		regs->regs[18] = efi_rt_stack_top[-2];
+
+	return true;
+}
+
 /* EFI requires 8 KiB of stack space for runtime services */
 static_assert(THREAD_SIZE >= SZ_8K);
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 74f76514a48d..3eb2825d08cf 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -30,6 +30,7 @@
 #include <asm/bug.h>
 #include <asm/cmpxchg.h>
 #include <asm/cpufeature.h>
+#include <asm/efi.h>
 #include <asm/exception.h>
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
@@ -397,6 +398,9 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 		msg = "paging request";
 	}
 
+	if (efi_runtime_fixup_exception(regs, msg))
+		return;
+
 	die_kernel_fault(msg, addr, esr, regs);
 }
 
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 60075e0e4943..1fba4e09cdcf 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -84,6 +84,7 @@ struct efi_runtime_work efi_rts_work;
 	else								\
 		pr_err("Failed to queue work to efi_rts_wq.\n");	\
 									\
+	WARN_ON_ONCE(efi_rts_work.status == EFI_ABORTED);		\
 exit:									\
 	efi_rts_work.efi_rts_id = EFI_NONE;				\
 	efi_rts_work.status;						\
-- 
2.39.0



