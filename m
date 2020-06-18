Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8031FE0C3
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgFRBuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731107AbgFRB12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A53CD221ED;
        Thu, 18 Jun 2020 01:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443647;
        bh=QT5kBwObbP0AysuMQaQSlKSxGx98OZTWvIlaNIx3f6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdaqPsC6BX2yxK0tI5VsfsvvqEjYs6Uun/UlsK2AWui3Wj1GXkzLHfFHw8tzPuA7N
         CQtHqfJvVDefhEfx02c4WSid6wsNH5qBnB0lLUXckwfgomNECBwjzDzLpqP9BsVlTZ
         M9OwZWItuBB4q5MNxoH7WqlRs2upVidlqGnsaKek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 068/108] powerpc/64s/pgtable: fix an undefined behaviour
Date:   Wed, 17 Jun 2020 21:25:20 -0400
Message-Id: <20200618012600.608744-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
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
index bcb79a96a6c8..618ee2c0ed53 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -898,10 +898,25 @@ extern struct page *pgd_page(pgd_t pgd);
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

