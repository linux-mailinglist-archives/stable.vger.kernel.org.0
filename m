Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94F94F68F4
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbiDFSJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbiDFSIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:08:11 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B24B719852D;
        Wed,  6 Apr 2022 09:46:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F8BF12FC;
        Wed,  6 Apr 2022 09:46:31 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E220C3F73B;
        Wed,  6 Apr 2022 09:46:30 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 33/43] arm64: entry: Allow the trampoline text to occupy multiple pages
Date:   Wed,  6 Apr 2022 17:45:36 +0100
Message-Id: <20220406164546.1888528-33-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
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
index feee38303afe..4ffe0d698fa7 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -53,9 +53,11 @@ enum fixed_addresses {
 	FIX_TEXT_POKE0,
 
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
index 4e7e7067afdb..09ebd37d5aa3 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -26,5 +26,11 @@ extern char __hyp_text_start[], __hyp_text_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
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
index 6e1d02d87d45..b9a757216a80 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -917,7 +917,7 @@ __ni_sys_trace:
 	.endm
 
 	.macro tramp_data_page	dst
-	adr	\dst, .entry.tramp.text
+	adr_l	\dst, .entry.tramp.text
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index fa3ffad50a61..17fc1671b990 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -261,7 +261,7 @@ ASSERT(__hibernate_exit_text_end - (__hibernate_exit_text_start & ~(SZ_4K - 1))
 	<= SZ_4K, "Hibernate exit text too big or misaligned")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
 /*
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 60be5bc0984a..36bd50091c4b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -438,6 +438,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
+	int i;
 	extern char __entry_tramp_text_start[];
 
 	pgprot_t prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
@@ -448,11 +449,15 @@ static int __init map_entry_trampoline(void)
 
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

