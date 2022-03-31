Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2AF4EE0BB
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiCaSge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiCaSgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:36:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 674AE1F0820;
        Thu, 31 Mar 2022 11:34:44 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31511139F;
        Thu, 31 Mar 2022 11:34:44 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87E3C3F718;
        Thu, 31 Mar 2022 11:34:43 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, catalin.marinas@arm.com
Subject: [stable:PATCH v4.14.274 17/27] arm64: entry: Allow the trampoline text to occupy multiple pages
Date:   Thu, 31 Mar 2022 19:33:50 +0100
Message-Id: <20220331183400.73183-18-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220331183400.73183-1-james.morse@arm.com>
References: <20220331183400.73183-1-james.morse@arm.com>
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

commit a9c406e6462ff14956d690de7bbe5131a5677dc9 upstream.

Adding a second set of vectors to .entry.tramp.text will make it
larger than a single 4K page.

Allow the trampoline text to occupy up to three pages by adding two
more fixmap slots. Previous changes to tramp_valias allowed it to reach
beyond a single page.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/fixmap.h   |  6 ++++--
 arch/arm64/include/asm/sections.h |  6 ++++++
 arch/arm64/kernel/entry.S         |  2 +-
 arch/arm64/kernel/vmlinux.lds.S   |  2 +-
 arch/arm64/mm/mmu.c               | 11 ++++++++---
 5 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index c0cfc6d3bf9f..3c962ef081f8 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -59,9 +59,11 @@ enum fixed_addresses {
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
 
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 941267caa39c..8d3f1eab58e0 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -28,5 +28,11 @@ extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
+extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
+
+static inline size_t entry_tramp_text_size(void)
+{
+	return __entry_tramp_text_end - __entry_tramp_text_start;
+}
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a58da4779b06..f50539bdf5be 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1018,7 +1018,7 @@ alternative_else_nop_endif
 	.endm
 
 	.macro tramp_data_page	dst
-	adr	\dst, .entry.tramp.text
+	adr_l	\dst, .entry.tramp.text
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 4c11d3e64aef..6543c58f26ec 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -258,7 +258,7 @@ ASSERT(__hibernate_exit_text_end - (__hibernate_exit_text_start & ~(SZ_4K - 1))
 	<= SZ_4K, "Hibernate exit text too big or misaligned")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
 /*
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e02a6326c800..4d472907194d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -532,6 +532,7 @@ early_param("rodata", parse_rodata);
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
+	int i;
 	extern char __entry_tramp_text_start[];
 
 	pgprot_t prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
@@ -542,11 +543,15 @@ static int __init map_entry_trampoline(void)
 
 	/* Map only the text into the trampoline page table */
 	memset(tramp_pg_dir, 0, PGD_SIZE);
-	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
-			     prot, pgd_pgtable_alloc, 0);
+	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
+			     entry_tramp_text_size(), prot, pgd_pgtable_alloc,
+			     0);
 
 	/* Map both the text and data into the kernel page table */
-	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
+	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
+		__set_fixmap(FIX_ENTRY_TRAMP_TEXT1 - i,
+			     pa_start + i * PAGE_SIZE, prot);
+
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
 		extern char __entry_tramp_data_start[];
 
-- 
2.30.2

