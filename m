Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2524D3312
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiCIQLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbiCIQJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A19944762;
        Wed,  9 Mar 2022 08:07:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8397615FA;
        Wed,  9 Mar 2022 16:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEB4C340EF;
        Wed,  9 Mar 2022 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842058;
        bh=XWfPsTF81CkXJlNPj4xrj7j+Msen4QvmkKqcXNCg8eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4isVWofkXvwoq5uNn5k36eIgbcUPP4q6PqjE85O2CFF9yFmhhoXFf8g+mEhNV9vy
         amCmuLHnyLRC8L4/Qf8M5fVQCn7UUXhHHjkNnEmR1Wudg3kYO1jDPfft/hOQ4yAX+7
         e5LDhreBorWIyBHj8irvA9LVziXcmqU2OtheqWdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 26/43] arm64: entry: Move the trampoline data page before the text page
Date:   Wed,  9 Mar 2022 17:00:10 +0100
Message-Id: <20220309155900.494948760@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fixmap.h |    2 +-
 arch/arm64/kernel/entry.S       |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -62,8 +62,8 @@ enum fixed_addresses {
 #endif /* CONFIG_ACPI_APEI_GHES */
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	FIX_ENTRY_TRAMP_DATA,
 	FIX_ENTRY_TRAMP_TEXT,
+	FIX_ENTRY_TRAMP_DATA,
 #define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT))
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 	__end_of_permanent_fixed_addresses,
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -644,6 +644,11 @@ alternative_else_nop_endif
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
@@ -660,7 +665,7 @@ alternative_else_nop_endif
 2:
 	tramp_map_kernel	x30
 #ifdef CONFIG_RANDOMIZE_BASE
-	adr	x30, tramp_vectors + PAGE_SIZE
+	tramp_data_page		x30
 alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	ldr	x30, [x30]
 #else
@@ -851,7 +856,7 @@ SYM_CODE_START(__sdei_asm_entry_trampoli
 1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_SDEI_TTBR1)]
 
 #ifdef CONFIG_RANDOMIZE_BASE
-	adr	x4, tramp_vectors + PAGE_SIZE
+	tramp_data_page		x4
 	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
 	ldr	x4, [x4]
 #else


