Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC24E28C6
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348490AbiCUOAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349068AbiCUN6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC37710FE4;
        Mon, 21 Mar 2022 06:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98ADDB81675;
        Mon, 21 Mar 2022 13:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BB9C340E8;
        Mon, 21 Mar 2022 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871046;
        bh=2ZwFpI+wDLBpmHQSH1fw6SGZf/nBWgyhZbm7P1A0tns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKtZ+z0cNfo/kH8oJw0noYKRs2Hz8uXzjq8506xlslBzrIFvARCqWHY1pzO5PKxAn
         c7MpD/804e51lXkt9WTWlJ1OOx93z7g5WDzQO7n+If322PKeoAcR9i6xwngu9INQkg
         mLRSlC5gR+ZUzijYVwkAnyFWUqmrBhJ0nWSJ299k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.19 37/57] arm64: entry: Add macro for reading symbol addresses from the trampoline
Date:   Mon, 21 Mar 2022 14:52:18 +0100
Message-Id: <20220321133223.070748131@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/kernel/entry.S |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

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


