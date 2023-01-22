Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE6676FED
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjAVP0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjAVP0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4BF22DEE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F5A60BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69939C4339B;
        Sun, 22 Jan 2023 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401200;
        bh=22IKduFFDWu4MaWV/mjLJM7EPNvxu8Rlpb6coLyuO8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTL7kqjekomb7mWZQkIjq93Kw4uDYo2sp+LCcRjwBoEyoKX+qR6lMuNue8muj27E9
         huqwqcYO1AOC8prXDLt1Hifs81FIDgCBdaC1N6ZTaMVwvKNVRAPMAuch4t/CCLS5S8
         SOw0Snpp4MvXMGrTF7a/ZscS3Br7zmDKDMTLs4EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 148/193] arm64: efi: Execute runtime services from a dedicated stack
Date:   Sun, 22 Jan 2023 16:04:37 +0100
Message-Id: <20230122150253.146222167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit ff7a167961d1b97e0e205f245f806e564d3505e7 upstream.

With the introduction of PRMT in the ACPI subsystem, the EFI rts
workqueue is no longer the only caller of efi_call_virt_pointer() in the
kernel. This means the EFI runtime services lock is no longer sufficient
to manage concurrent calls into firmware, but also that firmware calls
may occur that are not marshalled via the workqueue mechanism, but
originate directly from the caller context.

For added robustness, and to ensure that the runtime services have 8 KiB
of stack space available as per the EFI spec, introduce a spinlock
protected EFI runtime stack of 8 KiB, where the spinlock also ensures
serialization between the EFI rts workqueue (which itself serializes EFI
runtime calls) and other callers of efi_call_virt_pointer().

While at it, use the stack pivot to avoid reloading the shadow call
stack pointer from the ordinary stack, as doing so could produce a
gadget to defeat it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/efi.h       |    3 +++
 arch/arm64/kernel/efi-rt-wrapper.S |   13 ++++++++++++-
 arch/arm64/kernel/efi.c            |   27 +++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -25,6 +25,7 @@ int efi_set_mapping_permissions(struct m
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
+	spin_lock(&efi_rt_lock);					\
 })
 
 #undef arch_efi_call_virt
@@ -33,10 +34,12 @@ int efi_set_mapping_permissions(struct m
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
+	spin_unlock(&efi_rt_lock);					\
 	__efi_fpsimd_end();						\
 	efi_virtmap_unload();						\
 })
 
+extern spinlock_t efi_rt_lock;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -16,6 +16,12 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	 */
 	stp	x1, x18, [sp, #16]
 
+	ldr_l	x16, efi_rt_stack_top
+	mov	sp, x16
+#ifdef CONFIG_SHADOW_CALL_STACK
+	str	x18, [sp, #-16]!
+#endif
+
 	/*
 	 * We are lucky enough that no EFI runtime services take more than
 	 * 5 arguments, so all are passed in registers rather than via the
@@ -29,6 +35,7 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	mov	x4, x6
 	blr	x8
 
+	mov	sp, x29
 	ldp	x1, x2, [sp, #16]
 	cmp	x2, x18
 	ldp	x29, x30, [sp], #32
@@ -42,6 +49,10 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	 * called with preemption disabled and a separate shadow stack is used
 	 * for interrupts.
 	 */
-	mov	x18, x2
+#ifdef CONFIG_SHADOW_CALL_STACK
+	ldr_l	x18, efi_rt_stack_top
+	ldr	x18, [x18, #-16]
+#endif
+
 	b	efi_handle_corrupted_x18	// tail call
 SYM_FUNC_END(__efi_rt_asm_wrapper)
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -144,3 +144,30 @@ asmlinkage efi_status_t efi_handle_corru
 	pr_err_ratelimited(FW_BUG "register x18 corrupted by EFI %s\n", f);
 	return s;
 }
+
+DEFINE_SPINLOCK(efi_rt_lock);
+
+asmlinkage u64 *efi_rt_stack_top __ro_after_init;
+
+/* EFI requires 8 KiB of stack space for runtime services */
+static_assert(THREAD_SIZE >= SZ_8K);
+
+static int __init arm64_efi_rt_init(void)
+{
+	void *p;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	p = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN, GFP_KERNEL,
+			   NUMA_NO_NODE, &&l);
+l:	if (!p) {
+		pr_warn("Failed to allocate EFI runtime stack\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return -ENOMEM;
+	}
+
+	efi_rt_stack_top = p + THREAD_SIZE;
+	return 0;
+}
+core_initcall(arm64_efi_rt_init);


