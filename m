Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E932F4503
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 08:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbhAMHNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 02:13:32 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:2782 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbhAMHNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 02:13:31 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DFzDC65HVz9v264;
        Wed, 13 Jan 2021 08:12:43 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id eYutyGajjNq4; Wed, 13 Jan 2021 08:12:43 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DFzDC4hw3z9v262;
        Wed, 13 Jan 2021 08:12:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 948A58B7D8;
        Wed, 13 Jan 2021 08:12:44 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id whwj6TNEj0IH; Wed, 13 Jan 2021 08:12:44 +0100 (CET)
Received: from localhost.localdomain (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 70E178B772;
        Wed, 13 Jan 2021 08:12:44 +0100 (CET)
Received: by localhost.localdomain (Postfix, from userid 0)
        id 4EAE0660E6; Wed, 13 Jan 2021 07:12:44 +0000 (UTC)
Message-Id: <af07f8f0bb734bc1f906c1f79219f81c13c6ad2c.1610521804.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH for 4.9/4.14] powerpc: Fix incorrect stw{, ux, u, x} instructions in
 __set_pte_at
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date:   Wed, 13 Jan 2021 07:12:44 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Backport for 4.9 and 4.14

(cherry picked from commit d85be8a49e733dcd23674aa6202870d54bf5600d)

The placeholder for instruction selection should use the second
argument's operand, which is %1, not %0. This could generate incorrect
assembly code if the memory addressing of operand %0 is a different
form from that of operand %1.

Also remove the %Un placeholder because having %Un placeholders
for two operands which are based on the same local var (ptep) doesn't
make much sense. By the way, it doesn't change the current behaviour
because "<>" constraint is missing for the associated "=m".

[chleroy: revised commit log iaw segher's comments and removed %U0]

Fixes: 9bf2b5cdc5fe ("powerpc: Fixes for CONFIG_PTE_64BIT for SMP support")
Cc: <stable@vger.kernel.org> # v2.6.28+
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/96354bd77977a6a933fe9020da57629007fdb920.1603358942.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/include/asm/book3s/32/pgtable.h | 4 ++--
 arch/powerpc/include/asm/nohash/pgtable.h    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 016579ef16d3..ec98abca0df0 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -414,9 +414,9 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 	if (pte_val(*ptep) & _PAGE_HASHPTE)
 		flush_hash_entry(mm, ptep, addr);
 	__asm__ __volatile__("\
-		stw%U0%X0 %2,%0\n\
+		stw%X0 %2,%0\n\
 		eieio\n\
-		stw%U0%X0 %L2,%1"
+		stw%X1 %L2,%1"
 	: "=m" (*ptep), "=m" (*((unsigned char *)ptep+4))
 	: "r" (pte) : "memory");
 
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index 5c68f4a59f75..e9171b8242e4 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -157,9 +157,9 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 		flush_hash_entry(mm, ptep, addr);
 #endif
 	__asm__ __volatile__("\
-		stw%U0%X0 %2,%0\n\
+		stw%X0 %2,%0\n\
 		eieio\n\
-		stw%U0%X0 %L2,%1"
+		stw%X1 %L2,%1"
 	: "=m" (*ptep), "=m" (*((unsigned char *)ptep+4))
 	: "r" (pte) : "memory");
 
-- 
2.25.0

