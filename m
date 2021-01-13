Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387D02F449B
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 07:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbhAMGlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 01:41:04 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:45188 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbhAMGlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 01:41:04 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DFyVr3cxXz9v19k;
        Wed, 13 Jan 2021 07:40:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id EMDs00W3DDJQ; Wed, 13 Jan 2021 07:40:20 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DFyVr2rr1z9v19h;
        Wed, 13 Jan 2021 07:40:20 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3D4D28B7D8;
        Wed, 13 Jan 2021 07:40:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 6G-e-0LeGsur; Wed, 13 Jan 2021 07:40:21 +0100 (CET)
Received: from localhost.localdomain (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 126E38B772;
        Wed, 13 Jan 2021 07:40:21 +0100 (CET)
Received: by localhost.localdomain (Postfix, from userid 0)
        id 7938866387; Wed, 13 Jan 2021 06:40:20 +0000 (UTC)
Message-Id: <790e46767a5f10ae991969b064682c8c82f96bc3.1610519852.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH for 5.10] powerpc/32s: Fix RTAS machine check with VMAP stack
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date:   Wed, 13 Jan 2021 06:40:20 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport for 5.10

(cherry picked from commit 98bf2d3f4970179c702ef64db658e0553bc6ef3a)

When we have VMAP stack, exception prolog 1 sets r1, not r11.

When it is not an RTAS machine check, don't trash r1 because it is
needed by prolog 1.

Fixes: da7bb43ab9da ("powerpc/32: Fix vmap stack - Properly set r1 before activating MMU")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Squash in fixup for RTAS machine check from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bc77d61d1c18940e456a2dee464f1e2eda65a3f0.1608621048.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/kernel/head_book3s_32.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index a0dda2a1f2df..d66da35f2e8d 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -262,10 +262,19 @@ __secondary_hold_acknowledge:
 MachineCheck:
 	EXCEPTION_PROLOG_0
 #ifdef CONFIG_PPC_CHRP
+#ifdef CONFIG_VMAP_STACK
+	mr	r11, r1
+	mfspr	r1, SPRN_SPRG_THREAD
+	lwz	r1, RTAS_SP(r1)
+	cmpwi	cr1, r1, 0
+	bne	cr1, 7f
+	mr	r1, r11
+#else
 	mfspr	r11, SPRN_SPRG_THREAD
 	lwz	r11, RTAS_SP(r11)
 	cmpwi	cr1, r11, 0
 	bne	cr1, 7f
+#endif
 #endif /* CONFIG_PPC_CHRP */
 	EXCEPTION_PROLOG_1 for_rtas=1
 7:	EXCEPTION_PROLOG_2
-- 
2.25.0

