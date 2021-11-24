Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2045C613
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbhKXOFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353582AbhKXOAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25980632CB;
        Wed, 24 Nov 2021 13:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759346;
        bh=sJ6udqFJBxNLseHgsy5drVBNsnIIQCQ5L9fvkpsZKjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWSpEj9oHzsYXBfFrawsuw5O3lHXgDtBFsYZ4fn7zNQFzeBA4UNXLKKS7/5i1E/Go
         AhCa+8oRsdDyyS+zUZIGvBvotatBRfaK82pFU5ibuKNiEOAUvlikUquCg/xpSiur60
         lZa8j3bmrQEjOKdz1Dve3ofEy9e674CpEotZpLHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 210/279] powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX
Date:   Wed, 24 Nov 2021 12:58:17 +0100
Message-Id: <20211124115725.991965634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 1e35eba4055149c578baf0318d2f2f89ea3c44a0 upstream.

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

Fixes: f76c8f6d257c ("powerpc/8xx: Add function to set pinned TLBs")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Depends-on: c12ab8dbc492 ("powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a21e9a057fe2d247a535aff0d157a54eefee017a.1636963688.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_8xx.S |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

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


