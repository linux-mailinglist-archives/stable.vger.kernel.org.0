Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA4D4D48D4
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbiCJOOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiCJOOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:14:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4847153381;
        Thu, 10 Mar 2022 06:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 351ED61B94;
        Thu, 10 Mar 2022 14:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45375C340F4;
        Thu, 10 Mar 2022 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921486;
        bh=iUx/VZAJZIJBMnOjtvNPH0MOwTkKmvTeDE8haWcGsAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lb6M3yxrTmQ3ubyyV5QXtR0eBuWZQPrgPcEJFaFEgiFkBCr1+UcLIGH2rWgU04qvx
         UIcuSDR0GYrEN02yxfbxow5D7eb4b3ej+UtcQA1Mb0wyJZydRVdbaiXVr/Yj6hk+cp
         dcIvN88soQsZGwiF/AU9hRiB7uw9WdfNupOrQY1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 30/53] arm64: entry: Add macro for reading symbol addresses from the trampoline
Date:   Thu, 10 Mar 2022 15:09:35 +0100
Message-Id: <20220310140812.701376090@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -646,6 +646,15 @@ alternative_else_nop_endif
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
@@ -676,13 +685,8 @@ alternative_else_nop_endif
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
 alternative_if_not ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM
 	prfm	plil1strm, [x30, #(1b - \vector_start)]
 alternative_else_nop_endif
@@ -765,7 +769,12 @@ SYM_CODE_END(tramp_exit_compat)
 	.pushsection ".rodata", "a"
 	.align PAGE_SHIFT
 SYM_DATA_START(__entry_tramp_data_start)
+__entry_tramp_data_vectors:
 	.quad	vectors
+#ifdef CONFIG_ARM_SDE_INTERFACE
+__entry_tramp_data___sdei_asm_handler:
+	.quad	__sdei_asm_handler
+#endif /* CONFIG_ARM_SDE_INTERFACE */
 SYM_DATA_END(__entry_tramp_data_start)
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
@@ -932,14 +941,7 @@ SYM_CODE_START(__sdei_asm_entry_trampoli
 	 * Remember whether to unmap the kernel on exit.
 	 */
 1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_SDEI_TTBR1)]
-
-#ifdef CONFIG_RANDOMIZE_BASE
-	tramp_data_page		x4
-	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
-	ldr	x4, [x4]
-#else
-	ldr	x4, =__sdei_asm_handler
-#endif
+	tramp_data_read_var     x4, __sdei_asm_handler
 	br	x4
 SYM_CODE_END(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
@@ -962,13 +964,6 @@ SYM_CODE_END(__sdei_asm_exit_trampoline)
 NOKPROBE(__sdei_asm_exit_trampoline)
 	.ltorg
 .popsection		// .entry.tramp.text
-#ifdef CONFIG_RANDOMIZE_BASE
-.pushsection ".rodata", "a"
-SYM_DATA_START(__sdei_asm_trampoline_next_handler)
-	.quad	__sdei_asm_handler
-SYM_DATA_END(__sdei_asm_trampoline_next_handler)
-.popsection		// .rodata
-#endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 /*


