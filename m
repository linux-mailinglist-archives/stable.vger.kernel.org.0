Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6144D4BF8
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243905AbiCJOc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244987AbiCJO3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CDDB8B6D;
        Thu, 10 Mar 2022 06:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 975BDB8266E;
        Thu, 10 Mar 2022 14:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97E7C36AF3;
        Thu, 10 Mar 2022 14:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922305;
        bh=Qz6t2IobnC8RCnxQbuaAbH5Pkqhth068M/VMGtTIl+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgIkZMd+Zi9prbMRn9JUD1X8ctFMVNY2Ql3bo4OOplJZTjJceF/i690jP9wnQ6utd
         fC5aKFXLHaP0txY4PqnZF6IDDM3f6me24PFLfDlQOAf0/LxkMVJxTBIM8DvI4/SWp+
         eYK8ODCNPQHzJn2V72cX4ppRNNbQezP84LYXsptI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 35/58] arm64: entry: Add macro for reading symbol addresses from the trampoline
Date:   Thu, 10 Mar 2022 15:18:55 +0100
Message-Id: <20220310140813.873354590@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
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
 arch/arm64/kernel/entry.S |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -816,6 +816,15 @@ alternative_else_nop_endif
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
@@ -846,13 +855,8 @@ alternative_else_nop_endif
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
@@ -935,7 +939,12 @@ SYM_CODE_END(tramp_exit_compat)
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
@@ -1066,13 +1075,7 @@ SYM_CODE_START(__sdei_asm_entry_trampoli
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
 SYM_CODE_END(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
@@ -1095,13 +1098,6 @@ SYM_CODE_END(__sdei_asm_exit_trampoline)
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


