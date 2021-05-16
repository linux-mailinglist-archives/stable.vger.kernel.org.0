Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B1B381BFB
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 04:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhEPCP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 22:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhEPCOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 22:14:33 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E940C06138B
        for <stable@vger.kernel.org>; Sat, 15 May 2021 18:58:20 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 2EBEE92009C; Sun, 16 May 2021 03:58:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 208EC92009B;
        Sun, 16 May 2021 03:58:19 +0200 (CEST)
Date:   Sun, 16 May 2021 03:58:19 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     stable@vger.kernel.org
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.12] MIPS: Reinstate platform `__div64_32' handler
Message-ID: <alpine.DEB.2.21.2105160318070.3032@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Our current MIPS platform `__div64_32' handler is inactive, because it 
is incorrectly only enabled for 64-bit configurations, for which generic 
`do_div' code does not call it anyway.

The handler is not suitable for being called from there though as it 
only calculates 32 bits of the quotient under the assumption the 64-bit 
divident has been suitably reduced.  Code for such reduction used to be 
there, however it has been incorrectly removed with commit c21004cd5b4c 
("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."), which should 
have only updated an obsoleted constraint for an inline asm involving 
$hi and $lo register outputs, while possibly wiring the original MIPS 
variant of the `do_div' macro as `__div64_32' handler for the generic 
`do_div' implementation

Correct the handler as follows then:

- Revert most of the commit referred, however retaining the current 
  formatting, except for the final two instructions of the inline asm 
  sequence, which the original commit missed.  Omit the original 64-bit 
  parts though.

- Rename the original `do_div' macro to `__div64_32'.  Remove the inline 
  asm with a DIVU instruction and use plain C code for the intended DIVMOD 
  calculation instead.  GCC is smart enough to know that both the quotient 
  and the remainder are calculated with single DIVU, so with ISAs up to R5 
  the same instruction is actually produced with overall similar code.

  For R6 compiled code will work, but separate DIVU and MODU instructions 
  will be produced, which are also interlocked, so scalar implementations 
  will likely not perform as well as older ISAs with their asynchronous MD 
  unit.  Likely still faster than the generic algorithm though.

- Rename the `__base' local variable in `__div64_32' to `__radix' to 
  avoid a conflict with a local variable in `do_div'.

- Actually enable this code for 32-bit rather than 64-bit configurations
  by qualifying it with BITS_PER_LONG being 32 instead of 64.  Include 
  <asm/bitsperlong.h> for this macro rather than <linux/types.h> as we 
  don't need anything else.

- Finally include <asm-generic/div64.h> last rather than first.

This has passed correctness verification with test_div64 and reduced the 
module's average execution time down to 1.0668s and 0.2629s from 2.1529s 
and 0.5647s respectively for an R3400 CPU @40MHz and a 5Kc CPU @160MHz.  
For a reference 64-bit `do_div' code where we have the DDIVU instruction 
available to do the whole calculation right away averages at 0.0660s for 
the latter CPU.

Reported-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: c21004cd5b4c ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Cc: stable@vger.kernel.org # v2.6.30+
---
Hi,

 This is a backported version of commit c49f71f60754 with a fix for MIPSr6 
compilation, that is commit 25ab14cbe9d1 included and the commit message 
amended accordingly.  I have folded intermediate commit c1d337d45ec0 into 
this change as well, as trivially obvious and mechanically in the way 
between the two former changes, though strictly speaking an enhancement 
rather than a fix.  This way the state between master and stable branches 
is consistent.

 Rationale: the three changes could be applied separately as with master, 
however we'd have an unnecessary intermediate MIPSr6 build regression, 
which caused the drop of the original fix.

 This is for 5.12-stable and before.  Let me know if you'd prefer me to 
resolve this differently, or otherwise please apply.

 NB verified with a couple of representative defconfigs and booted on hw 
where available (with the test_div64 test module backported and enabled).

  Maciej
---
 arch/mips/include/asm/div64.h |   55 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 16 deletions(-)

Index: linux-malta-stable/arch/mips/include/asm/div64.h
===================================================================
--- linux-malta-stable.orig/arch/mips/include/asm/div64.h
+++ linux-malta-stable/arch/mips/include/asm/div64.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000, 2004  Maciej W. Rozycki
+ * Copyright (C) 2000, 2004, 2021  Maciej W. Rozycki
  * Copyright (C) 2003, 07 Ralf Baechle (ralf@linux-mips.org)
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,25 +9,18 @@
 #ifndef __ASM_DIV64_H
 #define __ASM_DIV64_H
 
-#include <asm-generic/div64.h>
-
-#if BITS_PER_LONG == 64
+#include <asm/bitsperlong.h>
 
-#include <linux/types.h>
+#if BITS_PER_LONG == 32
 
 /*
  * No traps on overflows for any of these...
  */
 
-#define __div64_32(n, base)						\
-({									\
+#define do_div64_32(res, high, low, base) ({				\
 	unsigned long __cf, __tmp, __tmp2, __i;				\
 	unsigned long __quot32, __mod32;				\
-	unsigned long __high, __low;					\
-	unsigned long long __n;						\
 									\
-	__high = *__n >> 32;						\
-	__low = __n;							\
 	__asm__(							\
 	"	.set	push					\n"	\
 	"	.set	noat					\n"	\
@@ -51,18 +44,48 @@
 	"	subu	%0, %0, %z6				\n"	\
 	"	addiu	%2, %2, 1				\n"	\
 	"3:							\n"	\
-	"	bnez	%4, 0b\n\t"					\
-	"	 srl	%5, %1, 0x1f\n\t"				\
+	"	bnez	%4, 0b					\n"	\
+	"	 srl	%5, %1, 0x1f				\n"	\
 	"	.set	pop"						\
 	: "=&r" (__mod32), "=&r" (__tmp),				\
 	  "=&r" (__quot32), "=&r" (__cf),				\
 	  "=&r" (__i), "=&r" (__tmp2)					\
-	: "Jr" (base), "0" (__high), "1" (__low));			\
+	: "Jr" (base), "0" (high), "1" (low));				\
 									\
-	(__n) = __quot32;						\
+	(res) = __quot32;						\
 	__mod32;							\
 })
 
-#endif /* BITS_PER_LONG == 64 */
+#define __div64_32(n, base) ({						\
+	unsigned long __upper, __low, __high, __radix;			\
+	unsigned long long __quot;					\
+	unsigned long long __div;					\
+	unsigned long __mod;						\
+									\
+	__div = (*n);							\
+	__radix = (base);						\
+									\
+	__high = __div >> 32;						\
+	__low = __div;							\
+									\
+	if (__high < __radix) {						\
+		__upper = __high;					\
+		__high = 0;						\
+	} else {							\
+		__upper = __high % __radix;				\
+		__high /= __radix;					\
+	}								\
+									\
+	__mod = do_div64_32(__low, __upper, __low, __radix);		\
+									\
+	__quot = __high;						\
+	__quot = __quot << 32 | __low;					\
+	(*n) = __quot;							\
+	__mod;								\
+})
+
+#endif /* BITS_PER_LONG == 32 */
+
+#include <asm-generic/div64.h>
 
 #endif /* __ASM_DIV64_H */
