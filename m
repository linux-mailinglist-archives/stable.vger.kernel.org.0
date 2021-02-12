Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BDA319B90
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 09:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhBLI6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 03:58:04 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:34443 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhBLI6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 03:58:03 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DcS6y19thzB09b7;
        Fri, 12 Feb 2021 09:57:14 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id oKM2_lEypWxp; Fri, 12 Feb 2021 09:57:14 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DcS6y0Pf7zB09b5;
        Fri, 12 Feb 2021 09:57:14 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 059198B84B;
        Fri, 12 Feb 2021 09:57:15 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id SN8BfrB5wnyV; Fri, 12 Feb 2021 09:57:14 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C6DB78B842;
        Fri, 12 Feb 2021 09:57:14 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 8606F672F8; Fri, 12 Feb 2021 08:57:14 +0000 (UTC)
Message-Id: <f6d16f3321f1dc89b77ada1c7d961fae4089766e.1613120077.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH for 5.10] powerpc/32: Preserve cr1 in exception prolog stack check to
 fix build error
To:     fedora.dm0@gmail.com, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date:   Fri, 12 Feb 2021 08:57:14 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport of 3642eb21256a ("powerpc/32: Preserve cr1 in
exception prolog stack check to fix build error") for kernel 5.10

It fixes the build failure on v5.10 reported by kernel test robot
and by David Michael.

This fix is not in Linux tree yet, it is in next branch in powerpc tree.

(cherry picked from commit 3642eb21256a317ac14e9ed560242c6d20cf06d9)

THREAD_ALIGN_SHIFT = THREAD_SHIFT + 1 = PAGE_SHIFT + 1
Maximum PAGE_SHIFT is 18 for 256k pages so
THREAD_ALIGN_SHIFT is 19 at the maximum.

No need to clobber cr1, it can be preserved when moving r1
into CR when we check stack overflow.

This reduces the number of instructions in Machine Check Exception
prolog and fixes a build failure reported by the kernel test robot
on v5.10 stable when building with RTAS + VMAP_STACK + KVM. That
build failure is due to too many instructions in the prolog hence
not fitting between 0x200 and 0x300. Allthough the problem doesn't
show up in mainline, it is still worth the change.

Fixes: 98bf2d3f4970 ("powerpc/32s: Fix RTAS machine check with VMAP stack")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5ae4d545e3ac58e133d2599e0deb88843cb494fc.1612768623.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/kernel/head_32.h        | 2 +-
 arch/powerpc/kernel/head_book3s_32.S | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head_32.h
index c88e66adecb5..fef0b34a77c9 100644
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -56,7 +56,7 @@
 1:
 	tophys_novmstack r11, r11
 #ifdef CONFIG_VMAP_STACK
-	mtcrf	0x7f, r1
+	mtcrf	0x3f, r1
 	bt	32 - THREAD_ALIGN_SHIFT, stack_overflow
 #endif
 .endm
diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index d66da35f2e8d..2729d8fa6e77 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -280,12 +280,6 @@ MachineCheck:
 7:	EXCEPTION_PROLOG_2
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 #ifdef CONFIG_PPC_CHRP
-#ifdef CONFIG_VMAP_STACK
-	mfspr	r4, SPRN_SPRG_THREAD
-	tovirt(r4, r4)
-	lwz	r4, RTAS_SP(r4)
-	cmpwi	cr1, r4, 0
-#endif
 	beq	cr1, machine_check_tramp
 	twi	31, 0, 0
 #else
-- 
2.25.0

