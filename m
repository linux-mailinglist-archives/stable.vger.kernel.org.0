Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55B8383869
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343752AbhEQPw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345176AbhEQPuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F272261D50;
        Mon, 17 May 2021 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262754;
        bh=MW3yIXAfcBoXXRXxaYwi0JgwfVDxofXfnrb2vjB8MxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpjayRiupZWewhtP2GmW1AYEWX/IRCNLj+wHobzunT7jX2dJOcX0Dp7MUAu7Uc8RG
         +bWcOs+qYCelBdGGMfK/dxyP2AtV0ubKkq1FCcpdi494FmPLamNnDZ/YasatOygsvD
         oL/s8Jkb4IcnnHrb/BdXTPWEUy7SgsepvWuyNd5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 268/289] MIPS: Avoid handcoded DIVU in `__div64_32 altogether
Date:   Mon, 17 May 2021 16:03:13 +0200
Message-Id: <20210517140314.170544498@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 25ab14cbe9d1b66fda44c71a2db7582a31b6f5cd upstream.

Remove the inline asm with a DIVU instruction from `__div64_32' and use
plain C code for the intended DIVMOD calculation instead.  GCC is smart
enough to know that both the quotient and the remainder are calculated
with single DIVU, so with ISAs up to R5 the same instruction is actually
produced with overall similar code.

For R6 compiled code will work, but separate DIVU and MODU instructions
will be produced, which are also interlocked, so scalar implementations
will likely not perform as well as older ISAs with their asynchronous MD
unit.  Likely still faster then the generic algorithm though.

This removes a compilation error for R6 however where the original DIVU
instruction is not supported anymore and the MDU accumulator registers
have been removed and consequently GCC complains as to a constraint it
cannot find a register for:

In file included from ./include/linux/math.h:5,
                 from ./include/linux/kernel.h:13,
                 from mm/page-writeback.c:15:
./include/linux/math64.h: In function 'div_u64_rem':
./arch/mips/include/asm/div64.h:76:17: error: inconsistent operand constraints in an 'asm'
   76 |                 __asm__("divu   $0, %z1, %z2"                           \
      |                 ^~~~~~~
./include/asm-generic/div64.h:245:25: note: in expansion of macro '__div64_32'
  245 |                 __rem = __div64_32(&(n), __base);       \
      |                         ^~~~~~~~~~
./include/linux/math64.h:91:22: note: in expansion of macro 'do_div'
   91 |         *remainder = do_div(dividend, divisor);
      |                      ^~~~~~

This has passed correctness verification with test_div64 and reduced the
module's average execution time down to 1.0404s from 1.0445s with R3400
@40MHz.  The module's MIPS I machine code has also shrunk by 12 bytes or
3 instructions.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/div64.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -58,7 +58,6 @@
 
 #define __div64_32(n, base) ({						\
 	unsigned long __upper, __low, __high, __radix;			\
-	unsigned long long __modquot;					\
 	unsigned long long __quot;					\
 	unsigned long long __div;					\
 	unsigned long __mod;						\
@@ -73,11 +72,8 @@
 		__upper = __high;					\
 		__high = 0;						\
 	} else {							\
-		__asm__("divu	$0, %z1, %z2"				\
-		: "=x" (__modquot)					\
-		: "Jr" (__high), "Jr" (__radix));			\
-		__upper = __modquot >> 32;				\
-		__high = __modquot;					\
+		__upper = __high % __radix;				\
+		__high /= __radix;					\
 	}								\
 									\
 	__mod = do_div64_32(__low, __upper, __low, __radix);		\


