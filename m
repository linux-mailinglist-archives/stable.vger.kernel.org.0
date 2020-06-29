Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6420120DF06
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbgF2Ubm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732418AbgF2TZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19764253A5;
        Mon, 29 Jun 2020 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445271;
        bh=WWtlE9F9oGPy+3JOawg5z2NrU7PrVBTChs+JNKsyu44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+mbuWkdysAPSTdGxeYXMXSFMjAHelYMcOeSUCJl5qgoeVJp+6ekYMws61UkvlUhv
         v+xJUEmijOHCq802xsZAAfEZknzuETf+pg30HiEvyShjGuGnkG6VlPeeLMZzG689ej
         a5d3rdE5wJSAMvZosedoKhAypT73OO12Cy6GtZ2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/191] powerpc/64s/pgtable: fix an undefined behaviour
Date:   Mon, 29 Jun 2020 11:37:46 -0400
Message-Id: <20200629154007.2495120-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit c2e929b18cea6cbf71364f22d742d9aad7f4677a ]

Booting a power9 server with hash MMU could trigger an undefined
behaviour because pud_offset(p4d, 0) will do,

0 >> (PAGE_SHIFT:16 + PTE_INDEX_SIZE:8 + H_PMD_INDEX_SIZE:10)

Fix it by converting pud_index() and friends to static inline
functions.

UBSAN: shift-out-of-bounds in arch/powerpc/mm/ptdump/ptdump.c:282:15
shift exponent 34 is too large for 32-bit type 'int'
CPU: 6 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc4-next-20200303+ #13
Call Trace:
dump_stack+0xf4/0x164 (unreliable)
ubsan_epilogue+0x18/0x78
__ubsan_handle_shift_out_of_bounds+0x160/0x21c
walk_pagetables+0x2cc/0x700
walk_pud at arch/powerpc/mm/ptdump/ptdump.c:282
(inlined by) walk_pagetables at arch/powerpc/mm/ptdump/ptdump.c:311
ptdump_check_wx+0x8c/0xf0
mark_rodata_ro+0x48/0x80
kernel_init+0x74/0x194
ret_from_kernel_thread+0x5c/0x74

Suggested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/20200306044852.3236-1-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 9fd77f8794a0d..315758c841878 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -754,10 +754,25 @@ extern struct page *pgd_page(pgd_t pgd);
 #define pud_page_vaddr(pud)	__va(pud_val(pud) & ~PUD_MASKED_BITS)
 #define pgd_page_vaddr(pgd)	__va(pgd_val(pgd) & ~PGD_MASKED_BITS)
 
-#define pgd_index(address) (((address) >> (PGDIR_SHIFT)) & (PTRS_PER_PGD - 1))
-#define pud_index(address) (((address) >> (PUD_SHIFT)) & (PTRS_PER_PUD - 1))
-#define pmd_index(address) (((address) >> (PMD_SHIFT)) & (PTRS_PER_PMD - 1))
-#define pte_index(address) (((address) >> (PAGE_SHIFT)) & (PTRS_PER_PTE - 1))
+static inline unsigned long pgd_index(unsigned long address)
+{
+	return (address >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1);
+}
+
+static inline unsigned long pud_index(unsigned long address)
+{
+	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
+}
+
+static inline unsigned long pmd_index(unsigned long address)
+{
+	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
+}
+
+static inline unsigned long pte_index(unsigned long address)
+{
+	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+}
 
 /*
  * Find an entry in a page-table-directory.  We combine the address region
-- 
2.25.1

