Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDA238AB8E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbhETLZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240582AbhETLXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B70F61D92;
        Thu, 20 May 2021 10:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505522;
        bh=MW3yIXAfcBoXXRXxaYwi0JgwfVDxofXfnrb2vjB8MxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0Y1s37vrjV5e1pfPrV/BifjcSKBicIXYju+ZMQB28XskHRqQVHXKGcddmSDGThRm
         x78cGffHOWamboaXeO/nblO7WJGlm9WI8MsuDJ9RiCR/6EDOw61FrHmUdKCvMaGzyO
         LIWARLntH6y+JfQbIw0504n0zfqQegE6GgCiLV9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.4 173/190] MIPS: Avoid handcoded DIVU in `__div64_32 altogether
Date:   Thu, 20 May 2021 11:23:57 +0200
Message-Id: <20210520092107.889468580@linuxfoundation.org>
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


