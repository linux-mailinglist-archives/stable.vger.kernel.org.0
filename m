Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7544DE052
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbiCRRvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239855AbiCRRvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:51:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDCC118EEAC;
        Fri, 18 Mar 2022 10:49:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C294F1570;
        Fri, 18 Mar 2022 10:49:46 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 228BA3F7B4;
        Fri, 18 Mar 2022 10:49:46 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 15/22] arm64: entry: Add macro for reading symbol addresses from the trampoline
Date:   Fri, 18 Mar 2022 17:48:35 +0000
Message-Id: <20220318174842.2321061-16-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318174842.2321061-1-james.morse@arm.com>
References: <20220318174842.2321061-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b28a8eebe81c186fdb1a0078263b30576c8e1f42 upstream.

The trampoline code needs to use the address of symbols in the wider
kernel, e.g. vectors. PC-relative addressing wouldn't work as the
trampoline code doesn't run at the address the linker expected.

tramp_ventry uses a literal pool, unless CONFIG_RANDOMIZE_BASE is
set, in which case it uses the data page as a literal pool because
the data page can be unmapped when running in user-space, which is
required for CPUs vulnerable to meltdown.

Pull this logic out as a macro, instead of adding a third copy
of it.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 3e391b1f6f3e..43bc04bd18d9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -970,6 +970,15 @@ alternative_else_nop_endif
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
+	.macro tramp_data_read_var	dst, var
+#ifdef CONFIG_RANDOMIZE_BASE
+	tramp_data_page		\dst
+	add	\dst, \dst, #:lo12:__entry_tramp_data_\var
+	ldr	\dst, [\dst]
+#else
+	ldr	\dst, =\var
+#endif
+	.endm
 
 #define BHB_MITIGATION_NONE	0
 #define BHB_MITIGATION_LOOP	1
@@ -1000,13 +1009,8 @@ alternative_else_nop_endif
 	b	.
 2:
 	tramp_map_kernel	x30
-#ifdef CONFIG_RANDOMIZE_BASE
-	tramp_data_page		x30
 alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
-	ldr	x30, [x30]
-#else
-	ldr	x30, =vectors
-#endif
+	tramp_data_read_var	x30, vectors
 	prfm	plil1strm, [x30, #(1b - \vector_start)]
 	msr	vbar_el1, x30
 	isb
@@ -1086,7 +1090,12 @@ END(tramp_exit_compat)
 	.align PAGE_SHIFT
 	.globl	__entry_tramp_data_start
 __entry_tramp_data_start:
+__entry_tramp_data_vectors:
 	.quad	vectors
+#ifdef CONFIG_ARM_SDE_INTERFACE
+__entry_tramp_data___sdei_asm_handler:
+	.quad	__sdei_asm_handler
+#endif /* CONFIG_ARM_SDE_INTERFACE */
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
@@ -1213,13 +1222,7 @@ ENTRY(__sdei_asm_entry_trampoline)
 	 */
 1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
 
-#ifdef CONFIG_RANDOMIZE_BASE
-	tramp_data_page		x4
-	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
-	ldr	x4, [x4]
-#else
-	ldr	x4, =__sdei_asm_handler
-#endif
+	tramp_data_read_var     x4, __sdei_asm_handler
 	br	x4
 ENDPROC(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
@@ -1242,12 +1245,6 @@ ENDPROC(__sdei_asm_exit_trampoline)
 NOKPROBE(__sdei_asm_exit_trampoline)
 	.ltorg
 .popsection		// .entry.tramp.text
-#ifdef CONFIG_RANDOMIZE_BASE
-.pushsection ".rodata", "a"
-__sdei_asm_trampoline_next_handler:
-	.quad	__sdei_asm_handler
-.popsection		// .rodata
-#endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 /*
-- 
2.30.2

