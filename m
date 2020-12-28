Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E012E3BDF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405329AbgL1Nzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405305AbgL1Nzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03494208B3;
        Mon, 28 Dec 2020 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163705;
        bh=enyYp1RREGkqlwVMOjJ0E6lyt8k5cPr33S8pIMNSTL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ek6n+CclVrdjLIsSSs353M0RMC+jkFAvN7LsiNqhUt/y/jlUU8J87jwwftdHvNrlB
         vqZwmPDNBywZPr3uAofUUbtLY47NfLAuJw4ty2Y8KOeFGndoGfNAulK5T9FyB+hzIv
         XHTDbiRDpzjD88HlWOg9EEQjTzfK47MWDN0fdN9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 380/453] powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at
Date:   Mon, 28 Dec 2020 13:50:16 +0100
Message-Id: <20201228124955.491076531@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit d85be8a49e733dcd23674aa6202870d54bf5600d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/book3s/32/pgtable.h |    4 ++--
 arch/powerpc/include/asm/nohash/pgtable.h    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -557,9 +557,9 @@ static inline void __set_pte_at(struct m
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
 
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -199,9 +199,9 @@ static inline void __set_pte_at(struct m
 	 */
 	if (IS_ENABLED(CONFIG_PPC32) && IS_ENABLED(CONFIG_PTE_64BIT) && !percpu) {
 		__asm__ __volatile__("\
-			stw%U0%X0 %2,%0\n\
+			stw%X0 %2,%0\n\
 			eieio\n\
-			stw%U0%X0 %L2,%1"
+			stw%X1 %L2,%1"
 		: "=m" (*ptep), "=m" (*((unsigned char *)ptep+4))
 		: "r" (pte) : "memory");
 		return;


