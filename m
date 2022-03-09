Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6F4D3399
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbiCIQNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiCIQM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:12:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315CB14F284;
        Wed,  9 Mar 2022 08:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F9C617AE;
        Wed,  9 Mar 2022 16:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC78C340EC;
        Wed,  9 Mar 2022 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842185;
        bh=JzLWArQNyLuhdGniyCyhpTMXsbAGh4DuRGnz7v0EpTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btjLYoVi91QS/pgz6uO0esb45UW/w7Xwkd1bnj9llvPmXkVmp2S5/Og/K6cmVpG53
         nodbW0R1A41O65e0U/ulcNELDHrm7MoD5mTfNXNK4iBY0rX8ulBOuzXcCx1QfV6zdj
         /sENfEe8gemVToCfQ2KVR4Iz00I3IZfVMHnYgOVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 27/37] arm64: entry: Allow the trampoline text to occupy multiple pages
Date:   Wed,  9 Mar 2022 17:00:28 +0100
Message-Id: <20220309155859.875882625@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
References: <20220309155859.086952723@linuxfoundation.org>
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

commit a9c406e6462ff14956d690de7bbe5131a5677dc9 upstream.

Adding a second set of vectors to .entry.tramp.text will make it
larger than a single 4K page.

Allow the trampoline text to occupy up to three pages by adding two
more fixmap slots. Previous changes to tramp_valias allowed it to reach
beyond a single page.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fixmap.h   |    6 ++++--
 arch/arm64/include/asm/sections.h |    5 +++++
 arch/arm64/kernel/entry.S         |    2 +-
 arch/arm64/kernel/vmlinux.lds.S   |    2 +-
 arch/arm64/mm/mmu.c               |   12 +++++++++---
 5 files changed, 20 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -62,9 +62,11 @@ enum fixed_addresses {
 #endif /* CONFIG_ACPI_APEI_GHES */
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	FIX_ENTRY_TRAMP_TEXT,
+	FIX_ENTRY_TRAMP_TEXT3,
+	FIX_ENTRY_TRAMP_TEXT2,
+	FIX_ENTRY_TRAMP_TEXT1,
 	FIX_ENTRY_TRAMP_DATA,
-#define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT))
+#define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT1))
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 	__end_of_permanent_fixed_addresses,
 
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -23,4 +23,9 @@ extern char __mmuoff_data_start[], __mmu
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
 
+static inline size_t entry_tramp_text_size(void)
+{
+	return __entry_tramp_text_end - __entry_tramp_text_start;
+}
+
 #endif /* __ASM_SECTIONS_H */
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -642,7 +642,7 @@ alternative_else_nop_endif
 	.endm
 
 	.macro tramp_data_page	dst
-	adr	\dst, .entry.tramp.text
+	adr_l	\dst, .entry.tramp.text
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -341,7 +341,7 @@ ASSERT(__hibernate_exit_text_end - (__hi
 	<= SZ_4K, "Hibernate exit text too big or misaligned")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
 #ifdef CONFIG_KVM
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -617,6 +617,8 @@ early_param("rodata", parse_rodata);
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
+	int i;
+
 	pgprot_t prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 	phys_addr_t pa_start = __pa_symbol(__entry_tramp_text_start);
 
@@ -625,11 +627,15 @@ static int __init map_entry_trampoline(v
 
 	/* Map only the text into the trampoline page table */
 	memset(tramp_pg_dir, 0, PGD_SIZE);
-	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
-			     prot, __pgd_pgtable_alloc, 0);
+	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
+			     entry_tramp_text_size(), prot,
+			     __pgd_pgtable_alloc, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
-	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
+	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
+		__set_fixmap(FIX_ENTRY_TRAMP_TEXT1 - i,
+			     pa_start + i * PAGE_SIZE, prot);
+
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
 		extern char __entry_tramp_data_start[];
 


