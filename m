Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E076433DA
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiLETkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiLETjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499C32AC5D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B492ACE139F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBFCC433C1;
        Mon,  5 Dec 2022 19:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269021;
        bh=oVOrNB0wgxy9UYvG+J/oOixjmfaLKXTPTti5nfZlH3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1LPYTdyl6nGo+dMRdIBSQMEo+K3RsbQJiWXgNNSSKF96BfIHtI9Ix9KcXRWydPjm
         YW8VMRI2zN4OihTJCpNZ9Rkmf52tGlcTboOAkC245sFB8HsQI90AYwEQTfCFLWsYc+
         DSeR7WHJnZdSCTeKh4cXVArH9KSJEujKzKcHax6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/120] riscv: Sync efi page tables kernel mappings before switching
Date:   Mon,  5 Dec 2022 20:10:36 +0100
Message-Id: <20221205190809.448815773@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 3f105a742725a1b78766a55169f1d827732e62b8 ]

The EFI page table is initially created as a copy of the kernel page table.
With VMAP_STACK enabled, kernel stacks are allocated in the vmalloc area:
if the stack is allocated in a new PGD (one that was not present at the
moment of the efi page table creation or not synced in a previous vmalloc
fault), the kernel will take a trap when switching to the efi page table
when the vmalloc kernel stack is accessed, resulting in a kernel panic.

Fix that by updating the efi kernel mappings before switching to the efi
page table.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Fixes: b91540d52a08 ("RISC-V: Add EFI runtime services")
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20221121133303.1782246-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/efi.h     |  6 +++++-
 arch/riscv/include/asm/pgalloc.h | 11 ++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/efi.h b/arch/riscv/include/asm/efi.h
index cc4f6787f937..1bb8662875dd 100644
--- a/arch/riscv/include/asm/efi.h
+++ b/arch/riscv/include/asm/efi.h
@@ -10,6 +10,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ptrace.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -20,7 +21,10 @@ extern void efi_init(void);
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
-#define arch_efi_call_virt_setup()      efi_virtmap_load()
+#define arch_efi_call_virt_setup()      ({		\
+		sync_kernel_mappings(efi_mm.pgd);	\
+		efi_virtmap_load();			\
+	})
 #define arch_efi_call_virt_teardown()   efi_virtmap_unload()
 
 #define arch_efi_call_virt(p, f, args...) p->f(args)
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 0af6933a7100..98e040332482 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -38,6 +38,13 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
+static inline void sync_kernel_mappings(pgd_t *pgd)
+{
+	memcpy(pgd + USER_PTRS_PER_PGD,
+	       init_mm.pgd + USER_PTRS_PER_PGD,
+	       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+}
+
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
@@ -46,9 +53,7 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (likely(pgd != NULL)) {
 		memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
 		/* Copy kernel mappings */
-		memcpy(pgd + USER_PTRS_PER_PGD,
-			init_mm.pgd + USER_PTRS_PER_PGD,
-			(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+		sync_kernel_mappings(pgd);
 	}
 	return pgd;
 }
-- 
2.35.1



