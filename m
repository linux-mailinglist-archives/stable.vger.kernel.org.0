Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966104DC601
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiCQMsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiCQMsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9911EE8F7;
        Thu, 17 Mar 2022 05:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10E73B81E01;
        Thu, 17 Mar 2022 12:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38335C340E9;
        Thu, 17 Mar 2022 12:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521214;
        bh=bwGdvWEkCvM+ShDhuTEyeUA7HFdoJ+UIzBTuToGlzUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4gw+BTn+KorDcRT+HNO8ssL6D5oWX1tP3s8kqYR+KVpiDNYg7Dv4gVf/XAkfyFwV
         v0bYiOfq030UeAfOm3K/fZppNVVo/heK14QF9C9txKLnx+kdTeRUaCRof/f/nuh+uk
         V6idgN81mqE2ZMIqsB9aDiIs8eG0VZ08yBeb8OSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/43] arm64: entry: Allow the trampoline text to occupy multiple pages
Date:   Thu, 17 Mar 2022 13:45:26 +0100
Message-Id: <20220317124528.099239203@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fixmap.h   |  6 ++++--
 arch/arm64/include/asm/sections.h |  5 +++++
 arch/arm64/kernel/entry.S         |  2 +-
 arch/arm64/kernel/vmlinux.lds.S   |  2 +-
 arch/arm64/mm/mmu.c               | 12 +++++++++---
 5 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 2e0977c7564c..928a96b9b161 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -63,9 +63,11 @@ enum fixed_addresses {
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
index 25a73aab438f..a75f2882cc7c 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -20,4 +20,9 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 
+static inline size_t entry_tramp_text_size(void)
+{
+	return __entry_tramp_text_end - __entry_tramp_text_start;
+}
+
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index bb456f596c43..c1cebaf68e0c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1059,7 +1059,7 @@ alternative_else_nop_endif
 	.endm
 
 	.macro tramp_data_page	dst
-	adr	\dst, .entry.tramp.text
+	adr_l	\dst, .entry.tramp.text
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1f82cf631c3c..fbab044b3a39 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -276,7 +276,7 @@ ASSERT(__hibernate_exit_text_end - (__hibernate_exit_text_start & ~(SZ_4K - 1))
 	<= SZ_4K, "Hibernate exit text too big or misaligned")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
 /*
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 99bc0289ab2b..5cf575f23af2 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -583,6 +583,8 @@ early_param("rodata", parse_rodata);
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
+	int i;
+
 	pgprot_t prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 	phys_addr_t pa_start = __pa_symbol(__entry_tramp_text_start);
 
@@ -591,11 +593,15 @@ static int __init map_entry_trampoline(void)
 
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
 
-- 
2.34.1



