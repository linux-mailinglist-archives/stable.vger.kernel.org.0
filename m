Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CFD4DE054
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239857AbiCRRvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbiCRRvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:51:04 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3848173F45;
        Fri, 18 Mar 2022 10:49:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5A5E1570;
        Fri, 18 Mar 2022 10:49:39 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05AA83F7B4;
        Fri, 18 Mar 2022 10:49:38 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 07/22] arm64: entry: Move the trampoline data page before the text page
Date:   Fri, 18 Mar 2022 17:48:27 +0000
Message-Id: <20220318174842.2321061-8-james.morse@arm.com>
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

commit c091fb6ae059cda563b2a4d93fdbc548ef34e1d6 upstream.

The trampoline code has a data page that holds the address of the vectors,
which is unmapped when running in user-space. This ensures that with
CONFIG_RANDOMIZE_BASE, the randomised address of the kernel can't be
discovered until after the kernel has been mapped.

If the trampoline text page is extended to include multiple sets of
vectors, it will be larger than a single page, making it tricky to
find the data page without knowing the size of the trampoline text
pages, which will vary with PAGE_SIZE.

Move the data page to appear before the text page. This allows the
data page to be found without knowing the size of the trampoline text
pages. 'tramp_vectors' is used to refer to the beginning of the
.entry.tramp.text section, do that explicitly.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/fixmap.h | 2 +-
 arch/arm64/kernel/entry.S       | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index ec1e6d6fa14c..c0cfc6d3bf9f 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -59,8 +59,8 @@ enum fixed_addresses {
 #endif /* CONFIG_ACPI_APEI_GHES */
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	FIX_ENTRY_TRAMP_DATA,
 	FIX_ENTRY_TRAMP_TEXT,
+	FIX_ENTRY_TRAMP_DATA,
 #define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT))
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 	__end_of_permanent_fixed_addresses,
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 16988a9d1d19..1df718f53a1f 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -967,6 +967,11 @@ alternative_else_nop_endif
 	 */
 	.endm
 
+	.macro tramp_data_page	dst
+	adr	\dst, .entry.tramp.text
+	sub	\dst, \dst, PAGE_SIZE
+	.endm
+
 	.macro tramp_ventry, regsize = 64
 	.align	7
 1:
@@ -983,7 +988,7 @@ alternative_else_nop_endif
 2:
 	tramp_map_kernel	x30
 #ifdef CONFIG_RANDOMIZE_BASE
-	adr	x30, tramp_vectors + PAGE_SIZE
+	tramp_data_page		x30
 alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	ldr	x30, [x30]
 #else
@@ -1131,7 +1136,7 @@ ENTRY(__sdei_asm_entry_trampoline)
 1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
 
 #ifdef CONFIG_RANDOMIZE_BASE
-	adr	x4, tramp_vectors + PAGE_SIZE
+	tramp_data_page		x4
 	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
 	ldr	x4, [x4]
 #else
-- 
2.30.2

