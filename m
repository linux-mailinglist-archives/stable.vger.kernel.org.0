Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6D205F1A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390976AbgFWU31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389433AbgFWU30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:29:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C4B62064B;
        Tue, 23 Jun 2020 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944166;
        bh=ycKibgpvqpaTzDGa1RwVCoCM+vNuXe2xAOkllgyZWxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLWoExXWj4N+mh2rY77JF9+id9ET6fnRjxU1s84Dvy8rwhPoh7lZehdmmuf6L2j0C
         Pn+iz6zyA2jrduIpLFkfOg5GEp4P3+59ZlMG1QkXitvYncueSIB35VTEvp2+IxeIXu
         jndEvvm2T4V8NHlX3Y3N/Ez6AL03j2fEfSzGe+j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Qian Cai <cai@lca.pw>, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/314] powerpc/64s/pgtable: fix an undefined behaviour
Date:   Tue, 23 Jun 2020 21:56:03 +0200
Message-Id: <20200623195346.895059149@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a143d394ff46f..e1eb8aa9cfbbb 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -998,10 +998,25 @@ extern struct page *pgd_page(pgd_t pgd);
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



