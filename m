Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8013A2E3F84
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502589AbgL1Oko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:40:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502550AbgL1O2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C0EF207B2;
        Mon, 28 Dec 2020 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165710;
        bh=U1Z0flzWJBHH9gQy1+JgIvX8wmjjFX+LGw6oUg225xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF8mfltcnz5XFdE5hmSDcnxeWBAP8WfIEqSOvAbWku6XjcmeAxKgxuQuxpoSt6Dq+
         Ce+qe+8Aw1ihjivYL9YisR+P7h+Ak6/+AsHhFzxAYTZKtTJtB5n2ax2j+WE2XJg3xN
         hFOCD8MVyEoaOPRqYxZxmqsv4ud8PNKIRhQ5FF8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 610/717] powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()
Date:   Mon, 28 Dec 2020 13:50:08 +0100
Message-Id: <20201228125050.144130251@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 1891ef21d92c4801ea082ee8ed478e304ddc6749 upstream.

fls() and fls64() are using __builtin_ctz() and _builtin_ctzll().
On powerpc, those builtins trivially use ctlzw and ctlzd power
instructions.

Allthough those instructions provide the expected result with
input argument 0, __builtin_ctz() and __builtin_ctzll() are
documented as undefined for value 0.

The easiest fix would be to use fls() and fls64() functions
defined in include/asm-generic/bitops/builtin-fls.h and
include/asm-generic/bitops/fls64.h, but GCC output is not optimal:

00000388 <testfls>:
 388:   2c 03 00 00     cmpwi   r3,0
 38c:   41 82 00 10     beq     39c <testfls+0x14>
 390:   7c 63 00 34     cntlzw  r3,r3
 394:   20 63 00 20     subfic  r3,r3,32
 398:   4e 80 00 20     blr
 39c:   38 60 00 00     li      r3,0
 3a0:   4e 80 00 20     blr

000003b0 <testfls64>:
 3b0:   2c 03 00 00     cmpwi   r3,0
 3b4:   40 82 00 1c     bne     3d0 <testfls64+0x20>
 3b8:   2f 84 00 00     cmpwi   cr7,r4,0
 3bc:   38 60 00 00     li      r3,0
 3c0:   4d 9e 00 20     beqlr   cr7
 3c4:   7c 83 00 34     cntlzw  r3,r4
 3c8:   20 63 00 20     subfic  r3,r3,32
 3cc:   4e 80 00 20     blr
 3d0:   7c 63 00 34     cntlzw  r3,r3
 3d4:   20 63 00 40     subfic  r3,r3,64
 3d8:   4e 80 00 20     blr

When the input of fls(x) is a constant, just check x for nullity and
return either 0 or __builtin_clz(x). Otherwise, use cntlzw instruction
directly.

For fls64() on PPC64, do the same but with __builtin_clzll() and
cntlzd instruction. On PPC32, lets take the generic fls64() which
will use our fls(). The result is as expected:

00000388 <testfls>:
 388:   7c 63 00 34     cntlzw  r3,r3
 38c:   20 63 00 20     subfic  r3,r3,32
 390:   4e 80 00 20     blr

000003a0 <testfls64>:
 3a0:   2c 03 00 00     cmpwi   r3,0
 3a4:   40 82 00 10     bne     3b4 <testfls64+0x14>
 3a8:   7c 83 00 34     cntlzw  r3,r4
 3ac:   20 63 00 20     subfic  r3,r3,32
 3b0:   4e 80 00 20     blr
 3b4:   7c 63 00 34     cntlzw  r3,r3
 3b8:   20 63 00 40     subfic  r3,r3,64
 3bc:   4e 80 00 20     blr

Fixes: 2fcff790dcb4 ("powerpc: Use builtin functions for fls()/__fls()/fls64()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/348c2d3f19ffcff8abe50d52513f989c4581d000.1603375524.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/bitops.h |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -216,15 +216,34 @@ static inline void arch___clear_bit_unlo
  */
 static inline int fls(unsigned int x)
 {
-	return 32 - __builtin_clz(x);
+	int lz;
+
+	if (__builtin_constant_p(x))
+		return x ? 32 - __builtin_clz(x) : 0;
+	asm("cntlzw %0,%1" : "=r" (lz) : "r" (x));
+	return 32 - lz;
 }
 
 #include <asm-generic/bitops/builtin-__fls.h>
 
+/*
+ * 64-bit can do this using one cntlzd (count leading zeroes doubleword)
+ * instruction; for 32-bit we use the generic version, which does two
+ * 32-bit fls calls.
+ */
+#ifdef CONFIG_PPC64
 static inline int fls64(__u64 x)
 {
-	return 64 - __builtin_clzll(x);
+	int lz;
+
+	if (__builtin_constant_p(x))
+		return x ? 64 - __builtin_clzll(x) : 0;
+	asm("cntlzd %0,%1" : "=r" (lz) : "r" (x));
+	return 64 - lz;
 }
+#else
+#include <asm-generic/bitops/fls64.h>
+#endif
 
 #ifdef CONFIG_PPC64
 unsigned int __arch_hweight8(unsigned int w);


