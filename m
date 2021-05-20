Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9910238AB8C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbhETLZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240544AbhETLXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E827061439;
        Thu, 20 May 2021 10:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505518;
        bh=WQfgM7ZoBlcn0q0ZndU0b98p6G+CR1wQVtqSdzHtEnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkdjR92I7VOxTXgLFbqXAP9B5RnNI1KZ5/C38cE6jDpG8PPlYKbIoamDUGcXPx40o
         vhavgxScGPklFN2+VYWzmIiniYY2QCBX7TcB/UNSbE/vQ9Wlf5M7PXGSl04k+qdCH/
         VyE+k9/OgsNP3WNi5zjtOQ3+6vRs8oN9qbO4LXpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.4 171/190] MIPS: Reinstate platform `__div64_32 handler
Date:   Thu, 20 May 2021 11:23:55 +0200
Message-Id: <20210520092107.826421550@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit c49f71f60754acbff37505e1d16ca796bf8a8140 upstream.

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

- Rename the original `do_div' macro to `__div64_32'.  Use the combined
  `x' constraint referring to the MD accumulator as a whole, replacing
  the original individual `h' and `l' constraints used for $hi and $lo
  registers respectively, of which `h' has been obsoleted with GCC 4.4.
  Update surrounding code accordingly.

  We have since removed support for GCC versions before 4.9, so no need
  for a special arrangement here; GCC has supported the `x' constraint
  since forever anyway, or at least going back to 1991.

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

Fixes: c21004cd5b4c ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Reported-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.30+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/div64.h |   57 ++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 16 deletions(-)

--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
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
@@ -51,18 +44,50 @@
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
+	unsigned long long __modquot;					\
+	unsigned long long __quot;					\
+	unsigned long long __div;					\
+	unsigned long __mod;						\
+									\
+	__div = (*n);							\
+	__radix = (base);						\
+									\
+	__high = __div >> 32;						\
+	__low = __div;							\
+	__upper = __high;						\
+									\
+	if (__high) {							\
+		__asm__("divu	$0, %z1, %z2"				\
+		: "=x" (__modquot)					\
+		: "Jr" (__high), "Jr" (__radix));			\
+		__upper = __modquot >> 32;				\
+		__high = __modquot;					\
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


