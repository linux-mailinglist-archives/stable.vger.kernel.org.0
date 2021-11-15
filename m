Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C8144FFCF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 09:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhKOIOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 03:14:04 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:59663 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237699AbhKOIL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 03:11:58 -0500
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Ht1zy2wDzz9sSH;
        Mon, 15 Nov 2021 09:09:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 534-YWwFuTM5; Mon, 15 Nov 2021 09:09:02 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Ht1zy21SVz9sS8;
        Mon, 15 Nov 2021 09:09:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 310398B767;
        Mon, 15 Nov 2021 09:09:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Y4-LfATikjwy; Mon, 15 Nov 2021 09:09:02 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.108])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0714A8B763;
        Mon, 15 Nov 2021 09:09:02 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1) with ESMTPS id 1AF88qax124551
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 09:08:52 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1/Submit) id 1AF88qag124549;
        Mon, 15 Nov 2021 09:08:52 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: [PATCH] powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX
Date:   Mon, 15 Nov 2021 09:08:36 +0100
Message-Id: <a21e9a057fe2d247a535aff0d157a54eefee017a.1636963688.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1636963711; l=3023; s=20211009; h=from:subject:message-id; bh=QjlloAOT34rm4P6Ampq2mLsAuz/+XGuRRPRzFfnQoTk=; b=5lgyXXPQdqZtbMlt0p/+CZjTUCoK4TKZPSW7w7xxVCi2qshKJ5tS5sRrKDCIW2hmkNLhFkVYglv7 7KrLpwo9DQ+PSMdwTmkEaSioaAhoD6USyD6lxxIckN/UW0FZinc5
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As spotted and explained in commit c12ab8dbc492 ("powerpc/8xx: Fix
Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST"), the selection
of STRICT_KERNEL_RWX without selecting DEBUG_RODATA_TEST has spotted
the lack of the DIRTY bit in the pinned kernel data TLBs.

This problem should have been detected a lot earlier if things had
been working as expected. But due to an incredible level of chance or
mishap, this went undetected because of a set of bugs: In fact the
DTLBs were not pinned, because instead of setting the reserve bit
in MD_CTR, it was set in MI_CTR that is the register for ITLBs.

But then, another huge bug was there: the physical address was
reset to 0 at the boundary between RO and RW areas, leading to the
same physical space being mapped at both 0xc0000000 and 0xc8000000.
This had by miracle no consequence until now because the entry was
not really pinned so it was overwritten soon enough to go undetected.

Of course, now that we really pin the DTLBs, it must be fixed as well.

Depends-on: c12ab8dbc492 ("powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST")
Fixes: f76c8f6d257c ("powerpc/8xx: Add function to set pinned TLBs")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/kernel/head_8xx.S | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 2d596881b70e..0d073b9fd52c 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -733,6 +733,7 @@ _GLOBAL(mmu_pin_tlb)
 #ifdef CONFIG_PIN_TLB_DATA
 	LOAD_REG_IMMEDIATE(r6, PAGE_OFFSET)
 	LOAD_REG_IMMEDIATE(r7, MI_SVALID | MI_PS8MEG | _PMD_ACCESSED)
+	li	r8, 0
 #ifdef CONFIG_PIN_TLB_IMMR
 	li	r0, 3
 #else
@@ -741,26 +742,26 @@ _GLOBAL(mmu_pin_tlb)
 	mtctr	r0
 	cmpwi	r4, 0
 	beq	4f
-	LOAD_REG_IMMEDIATE(r8, 0xf0 | _PAGE_RO | _PAGE_SPS | _PAGE_SH | _PAGE_PRESENT)
 	LOAD_REG_ADDR(r9, _sinittext)
 
 2:	ori	r0, r6, MD_EVALID
+	ori	r12, r8, 0xf0 | _PAGE_RO | _PAGE_SPS | _PAGE_SH | _PAGE_PRESENT
 	mtspr	SPRN_MD_CTR, r5
 	mtspr	SPRN_MD_EPN, r0
 	mtspr	SPRN_MD_TWC, r7
-	mtspr	SPRN_MD_RPN, r8
+	mtspr	SPRN_MD_RPN, r12
 	addi	r5, r5, 0x100
 	addis	r6, r6, SZ_8M@h
 	addis	r8, r8, SZ_8M@h
 	cmplw	r6, r9
 	bdnzt	lt, 2b
-
-4:	LOAD_REG_IMMEDIATE(r8, 0xf0 | _PAGE_DIRTY | _PAGE_SPS | _PAGE_SH | _PAGE_PRESENT)
+4:
 2:	ori	r0, r6, MD_EVALID
+	ori	r12, r8, 0xf0 | _PAGE_DIRTY | _PAGE_SPS | _PAGE_SH | _PAGE_PRESENT
 	mtspr	SPRN_MD_CTR, r5
 	mtspr	SPRN_MD_EPN, r0
 	mtspr	SPRN_MD_TWC, r7
-	mtspr	SPRN_MD_RPN, r8
+	mtspr	SPRN_MD_RPN, r12
 	addi	r5, r5, 0x100
 	addis	r6, r6, SZ_8M@h
 	addis	r8, r8, SZ_8M@h
@@ -781,7 +782,7 @@ _GLOBAL(mmu_pin_tlb)
 #endif
 #if defined(CONFIG_PIN_TLB_IMMR) || defined(CONFIG_PIN_TLB_DATA)
 	lis	r0, (MD_RSV4I | MD_TWAM)@h
-	mtspr	SPRN_MI_CTR, r0
+	mtspr	SPRN_MD_CTR, r0
 #endif
 	mtspr	SPRN_SRR1, r10
 	mtspr	SPRN_SRR0, r11
-- 
2.31.1

