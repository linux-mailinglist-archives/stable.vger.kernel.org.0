Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194986432EE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiLETcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiLETcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:32:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20F726AE5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:27:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92464612FE
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E1AC433C1;
        Mon,  5 Dec 2022 19:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268443;
        bh=1oWFaXyJkLlXDfLwnQTgrWueCPxizwa0tzSMjUnwR14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=098idSqxHT4ZG/LEuyrk+Jj1d/xBYwXUvPWkpyX/HhTUvTxQZJSIwcCNKBcxliIiT
         +8aLcZVgSpLjuvFYgkKc2sOAAwT4Si5f8LNlVQJtgWBrLUYOWSQ1/VJI9BYC1BBPlb
         4B5PedE06oP07/O5mxBLkcrgVtZ3JAq4KQSWEOiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 104/124] riscv: Sync efi page tables kernel mappings before switching
Date:   Mon,  5 Dec 2022 20:10:10 +0100
Message-Id: <20221205190811.381527756@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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
index f74879a8f1ea..e229d7be4b66 100644
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
 
 #define ARCH_EFI_IRQ_FLAGS_MASK (SR_IE | SR_SPIE)
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 947f23d7b6af..59dc12b5b7e8 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -127,6 +127,13 @@ static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 #define __p4d_free_tlb(tlb, p4d, addr)  p4d_free((tlb)->mm, p4d)
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
@@ -135,9 +142,7 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
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



