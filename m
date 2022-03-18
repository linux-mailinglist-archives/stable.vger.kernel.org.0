Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150A54DE04A
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbiCRRvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiCRRvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:51:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A77018EE84;
        Fri, 18 Mar 2022 10:49:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E41C71570;
        Fri, 18 Mar 2022 10:49:44 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 443623F7B4;
        Fri, 18 Mar 2022 10:49:44 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 13/22] arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
Date:   Fri, 18 Mar 2022 17:48:33 +0000
Message-Id: <20220318174842.2321061-14-james.morse@arm.com>
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

commit aff65393fa1401e034656e349abd655cfe272de0 upstream.

kpti is an optional feature, for systems not using kpti a set of
vectors for the spectre-bhb mitigations is needed.

Add another set of vectors, __bp_harden_el1_vectors, that will be
used if a mitigation is needed and kpti is not in use.

The EL1 ventries are repeated verbatim as there is no additional
work needed for entry from EL1.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 22d39c941a6d..54f7657f5d61 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -973,10 +973,11 @@ alternative_else_nop_endif
 	.macro tramp_ventry, vector_start, regsize, kpti
 	.align	7
 1:
-	.if	\kpti == 1
 	.if	\regsize == 64
 	msr	tpidrro_el0, x30	// Restored in kernel_ventry
 	.endif
+
+	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
 	 * entry onto the return stack and using a RET instruction to
@@ -1059,6 +1060,38 @@ __entry_tramp_data_start:
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
+/*
+ * Exception vectors for spectre mitigations on entry from EL1 when
+ * kpti is not in use.
+ */
+	.macro generate_el1_vector
+.Lvector_start\@:
+	kernel_ventry	1, sync_invalid			// Synchronous EL1t
+	kernel_ventry	1, irq_invalid			// IRQ EL1t
+	kernel_ventry	1, fiq_invalid			// FIQ EL1t
+	kernel_ventry	1, error_invalid		// Error EL1t
+
+	kernel_ventry	1, sync				// Synchronous EL1h
+	kernel_ventry	1, irq				// IRQ EL1h
+	kernel_ventry	1, fiq_invalid			// FIQ EL1h
+	kernel_ventry	1, error			// Error EL1h
+
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64, kpti=0
+	.endr
+	.rept 4
+	tramp_ventry	.Lvector_start\@, 32, kpti=0
+	.endr
+	.endm
+
+	.pushsection ".entry.text", "ax"
+	.align	11
+ENTRY(__bp_harden_el1_vectors)
+	generate_el1_vector
+END(__bp_harden_el1_vectors)
+	.popsection
+
+
 /*
  * Register switch for AArch64. The callee-saved registers need to be saved
  * and restored. On entry:
-- 
2.30.2

