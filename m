Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA684522B2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352973AbhKPBPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232596AbhKOTMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A72FF6340B;
        Mon, 15 Nov 2021 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000409;
        bh=sVCqPlrg+Xi7x07brtJUh20w41IEVgmlu3X7KuRUbgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6OF6/iguDboPYOe2g9ZS7QciNrGdRS0H+804Xro0L4xMSh7zkPUq8I9Cem8aoL+2
         /C3+V4sOrMc0QgnlJyyqiQJPMuv/S+mveZXg5b+Kqv02jmvJcx/jp8n8aNp/s8Mlwa
         MmJdakgzGpgPFsjov91fob0yJ+giQUn8/a08NiKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 650/849] powerpc/book3e: Fix set_memory_x() and set_memory_nx()
Date:   Mon, 15 Nov 2021 18:02:13 +0100
Message-Id: <20211115165442.253038526@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit b6cb20fdc2735f8b2e082937066c33fe376c2ee2 ]

set_memory_x() calls pte_mkexec() which sets _PAGE_EXEC.
set_memory_nx() calls pte_exprotec() which clears _PAGE_EXEC.

Book3e has 2 bits, UX and SX, which defines the exec rights
resp. for user (PR=1) and for kernel (PR=0).

_PAGE_EXEC is defined as UX only.

An executable kernel page is set with either _PAGE_KERNEL_RWX
or _PAGE_KERNEL_ROX, which both have SX set and UX cleared.

So set_memory_nx() call for an executable kernel page does
nothing because UX is already cleared.

And set_memory_x() on a non-executable kernel page makes it
executable for the user and keeps it non-executable for kernel.

Also, pte_exec() always returns 'false' on kernel pages, because
it checks _PAGE_EXEC which doesn't include SX, so for instance
the W+X check doesn't work.

To fix this:
  - change tlb_low_64e.S to use _PAGE_BAP_UX instead of _PAGE_USER
  - sets both UX and SX in _PAGE_EXEC so that pte_exec() returns
    true whenever one of the two bits is set and pte_exprotect()
    clears both bits.
  - Define a book3e specific version of pte_mkexec() which sets
    either SX or UX based on UR.

Fixes: 1f9ad21c3b38 ("powerpc/mm: Implement set_memory() routines")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c41100f9c144dc5b62e5a751b810190c6b5d42fd.1635226743.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/nohash/32/pgtable.h |  2 ++
 arch/powerpc/include/asm/nohash/64/pgtable.h |  5 -----
 arch/powerpc/include/asm/nohash/pte-book3e.h | 18 ++++++++++++++----
 arch/powerpc/mm/nohash/tlb_low_64e.S         |  8 ++++----
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/nohash/32/pgtable.h b/arch/powerpc/include/asm/nohash/32/pgtable.h
index ac0a5ff48c3ad..d6ba821a56ced 100644
--- a/arch/powerpc/include/asm/nohash/32/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -193,10 +193,12 @@ static inline pte_t pte_wrprotect(pte_t pte)
 }
 #endif
 
+#ifndef pte_mkexec
 static inline pte_t pte_mkexec(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_EXEC);
 }
+#endif
 
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define	pmd_bad(pmd)		(pmd_val(pmd) & _PMD_BAD)
diff --git a/arch/powerpc/include/asm/nohash/64/pgtable.h b/arch/powerpc/include/asm/nohash/64/pgtable.h
index d081704b13fb9..9d2905a474103 100644
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -118,11 +118,6 @@ static inline pte_t pte_wrprotect(pte_t pte)
 	return __pte(pte_val(pte) & ~_PAGE_RW);
 }
 
-static inline pte_t pte_mkexec(pte_t pte)
-{
-	return __pte(pte_val(pte) | _PAGE_EXEC);
-}
-
 #define PMD_BAD_BITS		(PTE_TABLE_SIZE-1)
 #define PUD_BAD_BITS		(PMD_TABLE_SIZE-1)
 
diff --git a/arch/powerpc/include/asm/nohash/pte-book3e.h b/arch/powerpc/include/asm/nohash/pte-book3e.h
index 813918f407653..f798640422c2d 100644
--- a/arch/powerpc/include/asm/nohash/pte-book3e.h
+++ b/arch/powerpc/include/asm/nohash/pte-book3e.h
@@ -48,7 +48,7 @@
 #define _PAGE_WRITETHRU	0x800000 /* W: cache write-through */
 
 /* "Higher level" linux bit combinations */
-#define _PAGE_EXEC		_PAGE_BAP_UX /* .. and was cache cleaned */
+#define _PAGE_EXEC		(_PAGE_BAP_SX | _PAGE_BAP_UX) /* .. and was cache cleaned */
 #define _PAGE_RW		(_PAGE_BAP_SW | _PAGE_BAP_UW) /* User write permission */
 #define _PAGE_KERNEL_RW		(_PAGE_BAP_SW | _PAGE_BAP_SR | _PAGE_DIRTY)
 #define _PAGE_KERNEL_RO		(_PAGE_BAP_SR)
@@ -93,11 +93,11 @@
 /* Permission masks used to generate the __P and __S table */
 #define PAGE_NONE	__pgprot(_PAGE_BASE)
 #define PAGE_SHARED	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RW)
-#define PAGE_SHARED_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RW | _PAGE_EXEC)
+#define PAGE_SHARED_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RW | _PAGE_BAP_UX)
 #define PAGE_COPY	__pgprot(_PAGE_BASE | _PAGE_USER)
-#define PAGE_COPY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_EXEC)
+#define PAGE_COPY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_BAP_UX)
 #define PAGE_READONLY	__pgprot(_PAGE_BASE | _PAGE_USER)
-#define PAGE_READONLY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_EXEC)
+#define PAGE_READONLY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_BAP_UX)
 
 #ifndef __ASSEMBLY__
 static inline pte_t pte_mkprivileged(pte_t pte)
@@ -113,6 +113,16 @@ static inline pte_t pte_mkuser(pte_t pte)
 }
 
 #define pte_mkuser pte_mkuser
+
+static inline pte_t pte_mkexec(pte_t pte)
+{
+	if (pte_val(pte) & _PAGE_BAP_UR)
+		return __pte((pte_val(pte) & ~_PAGE_BAP_SX) | _PAGE_BAP_UX);
+	else
+		return __pte((pte_val(pte) & ~_PAGE_BAP_UX) | _PAGE_BAP_SX);
+}
+#define pte_mkexec pte_mkexec
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/mm/nohash/tlb_low_64e.S b/arch/powerpc/mm/nohash/tlb_low_64e.S
index bf24451f3e71f..9235e720e3572 100644
--- a/arch/powerpc/mm/nohash/tlb_low_64e.S
+++ b/arch/powerpc/mm/nohash/tlb_low_64e.S
@@ -222,7 +222,7 @@ tlb_miss_kernel_bolted:
 
 tlb_miss_fault_bolted:
 	/* We need to check if it was an instruction miss */
-	andi.	r10,r11,_PAGE_EXEC|_PAGE_BAP_SX
+	andi.	r10,r11,_PAGE_BAP_UX|_PAGE_BAP_SX
 	bne	itlb_miss_fault_bolted
 dtlb_miss_fault_bolted:
 	tlb_epilog_bolted
@@ -239,7 +239,7 @@ itlb_miss_fault_bolted:
 	srdi	r15,r16,60		/* get region */
 	bne-	itlb_miss_fault_bolted
 
-	li	r11,_PAGE_PRESENT|_PAGE_EXEC	/* Base perm */
+	li	r11,_PAGE_PRESENT|_PAGE_BAP_UX	/* Base perm */
 
 	/* We do the user/kernel test for the PID here along with the RW test
 	 */
@@ -614,7 +614,7 @@ itlb_miss_fault_e6500:
 
 	/* We do the user/kernel test for the PID here along with the RW test
 	 */
-	li	r11,_PAGE_PRESENT|_PAGE_EXEC	/* Base perm */
+	li	r11,_PAGE_PRESENT|_PAGE_BAP_UX	/* Base perm */
 	oris	r11,r11,_PAGE_ACCESSED@h
 
 	cmpldi	cr0,r15,0			/* Check for user region */
@@ -734,7 +734,7 @@ normal_tlb_miss_done:
 
 normal_tlb_miss_access_fault:
 	/* We need to check if it was an instruction miss */
-	andi.	r10,r11,_PAGE_EXEC
+	andi.	r10,r11,_PAGE_BAP_UX
 	bne	1f
 	ld	r14,EX_TLB_DEAR(r12)
 	ld	r15,EX_TLB_ESR(r12)
-- 
2.33.0



