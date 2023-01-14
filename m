Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266C966AAC5
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjANJxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjANJxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:53:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550D8A2
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDCF9B808C5
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1BAC433EF;
        Sat, 14 Jan 2023 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689988;
        bh=p7pNAp5OE2GHFbDY94VWMgimD324/dPN39G+wjyqwxU=;
        h=Subject:To:Cc:From:Date:From;
        b=ydaVHQgLuiEaFdXV8//nEACMxha498OqlEr7nfsjmVf1PnCB6QTdOGRclzbD8UXIG
         pV/fhXtsedpphflDXS7kHZRPD6XgrD/g5g6Q4YOCAgtuDxODCpF866mDer6fdj1l2/
         yIxEZ71x4vZJdMpOWGMcsHnifK+kvzJFPHcNt8QA=
Subject: FAILED: patch "[PATCH] arm64: cmpxchg_double*: hazard against entire exchange" failed to apply to 4.14-stable tree
To:     mark.rutland@arm.com, arnd@arndb.de, boqun.feng@gmail.com,
        catalin.marinas@arm.com, peterz@infradead.org,
        steve.capper@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:53:05 +0100
Message-ID: <1673689985241254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

031af50045ea ("arm64: cmpxchg_double*: hazard against entire exchange variable")
b2c3ccbd0011 ("arm64: atomics: remove LL/SC trampolines")
8e6082e94aac ("arm64: atomics: format whitespace consistently")
4f6cdf296cc4 ("Merge branches 'for-next/acpi', 'for-next/cpufeatures', 'for-next/csum', 'for-next/e0pd', 'for-next/entry', 'for-next/kbuild', 'for-next/kexec/cleanup', 'for-next/kexec/file-kdump', 'for-next/misc', 'for-next/nofpsimd', 'for-next/perf' and 'for-next/scs' into for-next/core")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 031af50045ea97ed4386eb3751ca2c134d0fc911 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 4 Jan 2023 15:16:26 +0000
Subject: [PATCH] arm64: cmpxchg_double*: hazard against entire exchange
 variable

The inline assembly for arm64's cmpxchg_double*() implementations use a
+Q constraint to hazard against other accesses to the memory location
being exchanged. However, the pointer passed to the constraint is a
pointer to unsigned long, and thus the hazard only applies to the first
8 bytes of the location.

GCC can take advantage of this, assuming that other portions of the
location are unchanged, leading to a number of potential problems.

This is similar to what we fixed back in commit:

  fee960bed5e857eb ("arm64: xchg: hazard against entire exchange variable")

... but we forgot to adjust cmpxchg_double*() similarly at the same
time.

The same problem applies, as demonstrated with the following test:

| struct big {
|         u64 lo, hi;
| } __aligned(128);
|
| unsigned long foo(struct big *b)
| {
|         u64 hi_old, hi_new;
|
|         hi_old = b->hi;
|         cmpxchg_double_local(&b->lo, &b->hi, 0x12, 0x34, 0x56, 0x78);
|         hi_new = b->hi;
|
|         return hi_old ^ hi_new;
| }

... which GCC 12.1.0 compiles as:

| 0000000000000000 <foo>:
|    0:   d503233f        paciasp
|    4:   aa0003e4        mov     x4, x0
|    8:   1400000e        b       40 <foo+0x40>
|    c:   d2800240        mov     x0, #0x12                       // #18
|   10:   d2800681        mov     x1, #0x34                       // #52
|   14:   aa0003e5        mov     x5, x0
|   18:   aa0103e6        mov     x6, x1
|   1c:   d2800ac2        mov     x2, #0x56                       // #86
|   20:   d2800f03        mov     x3, #0x78                       // #120
|   24:   48207c82        casp    x0, x1, x2, x3, [x4]
|   28:   ca050000        eor     x0, x0, x5
|   2c:   ca060021        eor     x1, x1, x6
|   30:   aa010000        orr     x0, x0, x1
|   34:   d2800000        mov     x0, #0x0                        // #0    <--- BANG
|   38:   d50323bf        autiasp
|   3c:   d65f03c0        ret
|   40:   d2800240        mov     x0, #0x12                       // #18
|   44:   d2800681        mov     x1, #0x34                       // #52
|   48:   d2800ac2        mov     x2, #0x56                       // #86
|   4c:   d2800f03        mov     x3, #0x78                       // #120
|   50:   f9800091        prfm    pstl1strm, [x4]
|   54:   c87f1885        ldxp    x5, x6, [x4]
|   58:   ca0000a5        eor     x5, x5, x0
|   5c:   ca0100c6        eor     x6, x6, x1
|   60:   aa0600a6        orr     x6, x5, x6
|   64:   b5000066        cbnz    x6, 70 <foo+0x70>
|   68:   c8250c82        stxp    w5, x2, x3, [x4]
|   6c:   35ffff45        cbnz    w5, 54 <foo+0x54>
|   70:   d2800000        mov     x0, #0x0                        // #0     <--- BANG
|   74:   d50323bf        autiasp
|   78:   d65f03c0        ret

Notice that at the lines with "BANG" comments, GCC has assumed that the
higher 8 bytes are unchanged by the cmpxchg_double() call, and that
`hi_old ^ hi_new` can be reduced to a constant zero, for both LSE and
LL/SC versions of cmpxchg_double().

This patch fixes the issue by passing a pointer to __uint128_t into the
+Q constraint, ensuring that the compiler hazards against the entire 16
bytes being modified.

With this change, GCC 12.1.0 compiles the above test as:

| 0000000000000000 <foo>:
|    0:   f9400407        ldr     x7, [x0, #8]
|    4:   d503233f        paciasp
|    8:   aa0003e4        mov     x4, x0
|    c:   1400000f        b       48 <foo+0x48>
|   10:   d2800240        mov     x0, #0x12                       // #18
|   14:   d2800681        mov     x1, #0x34                       // #52
|   18:   aa0003e5        mov     x5, x0
|   1c:   aa0103e6        mov     x6, x1
|   20:   d2800ac2        mov     x2, #0x56                       // #86
|   24:   d2800f03        mov     x3, #0x78                       // #120
|   28:   48207c82        casp    x0, x1, x2, x3, [x4]
|   2c:   ca050000        eor     x0, x0, x5
|   30:   ca060021        eor     x1, x1, x6
|   34:   aa010000        orr     x0, x0, x1
|   38:   f9400480        ldr     x0, [x4, #8]
|   3c:   d50323bf        autiasp
|   40:   ca0000e0        eor     x0, x7, x0
|   44:   d65f03c0        ret
|   48:   d2800240        mov     x0, #0x12                       // #18
|   4c:   d2800681        mov     x1, #0x34                       // #52
|   50:   d2800ac2        mov     x2, #0x56                       // #86
|   54:   d2800f03        mov     x3, #0x78                       // #120
|   58:   f9800091        prfm    pstl1strm, [x4]
|   5c:   c87f1885        ldxp    x5, x6, [x4]
|   60:   ca0000a5        eor     x5, x5, x0
|   64:   ca0100c6        eor     x6, x6, x1
|   68:   aa0600a6        orr     x6, x5, x6
|   6c:   b5000066        cbnz    x6, 78 <foo+0x78>
|   70:   c8250c82        stxp    w5, x2, x3, [x4]
|   74:   35ffff45        cbnz    w5, 5c <foo+0x5c>
|   78:   f9400480        ldr     x0, [x4, #8]
|   7c:   d50323bf        autiasp
|   80:   ca0000e0        eor     x0, x7, x0
|   84:   d65f03c0        ret

... sampling the high 8 bytes before and after the cmpxchg, and
performing an EOR, as we'd expect.

For backporting, I've tested this atop linux-4.9.y with GCC 5.5.0. Note
that linux-4.9.y is oldest currently supported stable release, and
mandates GCC 5.1+. Unfortunately I couldn't get a GCC 5.1 binary to run
on my machines due to library incompatibilities.

I've also used a standalone test to check that we can use a __uint128_t
pointer in a +Q constraint at least as far back as GCC 4.8.5 and LLVM
3.9.1.

Fixes: 5284e1b4bc8a ("arm64: xchg: Implement cmpxchg_double")
Fixes: e9a4b795652f ("arm64: cmpxchg_dbl: patch in lse instructions when supported by the CPU")
Reported-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/lkml/Y6DEfQXymYVgL3oJ@boqun-archlinux/
Reported-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/Y6GXoO4qmH9OIZ5Q@hirez.programming.kicks-ass.net/
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20230104151626.3262137-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index 0890e4f568fb..cbb3d961123b 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -315,7 +315,7 @@ __ll_sc__cmpxchg_double##name(unsigned long old1,			\
 	"	cbnz	%w0, 1b\n"					\
 	"	" #mb "\n"						\
 	"2:"								\
-	: "=&r" (tmp), "=&r" (ret), "+Q" (*(unsigned long *)ptr)	\
+	: "=&r" (tmp), "=&r" (ret), "+Q" (*(__uint128_t *)ptr)		\
 	: "r" (old1), "r" (old2), "r" (new1), "r" (new2)		\
 	: cl);								\
 									\
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index 52075e93de6c..a94d6dacc029 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -311,7 +311,7 @@ __lse__cmpxchg_double##name(unsigned long old1,				\
 	"	eor	%[old2], %[old2], %[oldval2]\n"			\
 	"	orr	%[old1], %[old1], %[old2]"			\
 	: [old1] "+&r" (x0), [old2] "+&r" (x1),				\
-	  [v] "+Q" (*(unsigned long *)ptr)				\
+	  [v] "+Q" (*(__uint128_t *)ptr)				\
 	: [new1] "r" (x2), [new2] "r" (x3), [ptr] "r" (x4),		\
 	  [oldval1] "r" (oldval1), [oldval2] "r" (oldval2)		\
 	: cl);								\

