Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10424700A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgHQR7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388535AbgHQQKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFD620658;
        Mon, 17 Aug 2020 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680590;
        bh=goIVZLnPHYga4mM1xBSpILMUHF3Z9nJtFXK/ua98o4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbbRSO508bDlGsAIDGS5mBZfXOCp85JLXAtFCpOdTG8EyNXdIIkhNpfu7MVId1UX8
         lVbWIwELyybweZpviPojB1TO0mOGcbkVsHop3rRZHDiz6P9wPTiUYm/t4eyphwr37s
         F+GgjBfH+PDB+/iJ8o93K5vysdg0V4SkiVAg51IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 247/270] Revert "parisc: Use ldcw instruction for SMP spinlock release barrier"
Date:   Mon, 17 Aug 2020 17:17:28 +0200
Message-Id: <20200817143808.121518283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 6e9f06ee6c9566f3606d93182ac8f803a148504b upstream.

This reverts commit 9e5c602186a692a7e848c0da17aed40f49d30519.
No need to use the ldcw instruction as SMP spinlock release barrier.
Revert it to gain back speed again.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/spinlock.h |    4 ---
 arch/parisc/kernel/entry.S         |   43 +++++++++++++++++--------------------
 arch/parisc/kernel/syscall.S       |   16 +++----------
 3 files changed, 24 insertions(+), 39 deletions(-)

--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -37,11 +37,7 @@ static inline void arch_spin_unlock(arch
 	volatile unsigned int *a;
 
 	a = __ldcw_align(x);
-#ifdef CONFIG_SMP
-	(void) __ldcw(a);
-#else
 	mb();
-#endif
 	*a = 1;
 }
 
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -454,9 +454,8 @@
 	nop
 	LDREG		0(\ptp),\pte
 	bb,<,n		\pte,_PAGE_PRESENT_BIT,3f
-	LDCW		0(\tmp),\tmp1
 	b		\fault
-	stw		\spc,0(\tmp)
+	stw,ma		\spc,0(\tmp)
 99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
 #endif
 2:	LDREG		0(\ptp),\pte
@@ -465,22 +464,20 @@
 	.endm
 
 	/* Release pa_tlb_lock lock without reloading lock address. */
-	.macro		tlb_unlock0	spc,tmp,tmp1
+	.macro		tlb_unlock0	spc,tmp
 #ifdef CONFIG_SMP
 98:	or,COND(=)	%r0,\spc,%r0
-	LDCW		0(\tmp),\tmp1
-	or,COND(=)	%r0,\spc,%r0
-	stw		\spc,0(\tmp)
+	stw,ma		\spc,0(\tmp)
 99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
 #endif
 	.endm
 
 	/* Release pa_tlb_lock lock. */
-	.macro		tlb_unlock1	spc,tmp,tmp1
+	.macro		tlb_unlock1	spc,tmp
 #ifdef CONFIG_SMP
 98:	load_pa_tlb_lock \tmp
 99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
-	tlb_unlock0	\spc,\tmp,\tmp1
+	tlb_unlock0	\spc,\tmp
 #endif
 	.endm
 
@@ -1163,7 +1160,7 @@ dtlb_miss_20w:
 	
 	idtlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1189,7 +1186,7 @@ nadtlb_miss_20w:
 
 	idtlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1223,7 +1220,7 @@ dtlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1256,7 +1253,7 @@ nadtlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1285,7 +1282,7 @@ dtlb_miss_20:
 
 	idtlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1313,7 +1310,7 @@ nadtlb_miss_20:
 	
 	idtlbt		pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1420,7 +1417,7 @@ itlb_miss_20w:
 	
 	iitlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1444,7 +1441,7 @@ naitlb_miss_20w:
 
 	iitlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1478,7 +1475,7 @@ itlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1502,7 +1499,7 @@ naitlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1532,7 +1529,7 @@ itlb_miss_20:
 
 	iitlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1552,7 +1549,7 @@ naitlb_miss_20:
 
 	iitlbt          pte,prot
 
-	tlb_unlock1	spc,t0,t1
+	tlb_unlock1	spc,t0
 	rfir
 	nop
 
@@ -1582,7 +1579,7 @@ dbit_trap_20w:
 		
 	idtlbt          pte,prot
 
-	tlb_unlock0	spc,t0,t1
+	tlb_unlock0	spc,t0
 	rfir
 	nop
 #else
@@ -1608,7 +1605,7 @@ dbit_trap_11:
 
 	mtsp            t1, %sr1     /* Restore sr1 */
 
-	tlb_unlock0	spc,t0,t1
+	tlb_unlock0	spc,t0
 	rfir
 	nop
 
@@ -1628,7 +1625,7 @@ dbit_trap_20:
 	
 	idtlbt		pte,prot
 
-	tlb_unlock0	spc,t0,t1
+	tlb_unlock0	spc,t0
 	rfir
 	nop
 #endif
--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -640,9 +640,7 @@ cas_action:
 	sub,<>	%r28, %r25, %r0
 2:	stw	%r24, 0(%r26)
 	/* Free lock */
-#ifdef CONFIG_SMP
-	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-#endif
+	sync
 	stw	%r20, 0(%sr2,%r20)
 #if ENABLE_LWS_DEBUG
 	/* Clear thread register indicator */
@@ -657,9 +655,7 @@ cas_action:
 3:		
 	/* Error occurred on load or store */
 	/* Free lock */
-#ifdef CONFIG_SMP
-	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-#endif
+	sync
 	stw	%r20, 0(%sr2,%r20)
 #if ENABLE_LWS_DEBUG
 	stw	%r0, 4(%sr2,%r20)
@@ -861,9 +857,7 @@ cas2_action:
 
 cas2_end:
 	/* Free lock */
-#ifdef CONFIG_SMP
-	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-#endif
+	sync
 	stw	%r20, 0(%sr2,%r20)
 	/* Enable interrupts */
 	ssm	PSW_SM_I, %r0
@@ -874,9 +868,7 @@ cas2_end:
 22:
 	/* Error occurred on load or store */
 	/* Free lock */
-#ifdef CONFIG_SMP
-	LDCW	0(%sr2,%r20), %r1			/* Barrier */
-#endif
+	sync
 	stw	%r20, 0(%sr2,%r20)
 	ssm	PSW_SM_I, %r0
 	ldo	1(%r0),%r28


