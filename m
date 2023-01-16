Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3A866CC25
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbjAPRWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbjAPRWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40202ED59
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4754EB8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB265C433D2;
        Mon, 16 Jan 2023 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888399;
        bh=7fGfK0Z+38+qUSGB8ZPTsLBOxCfhv7ec3LpAQDbDBoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zr+Ukh33d5QdUgS+vwb4PPCkaFGkAhTbvbWWCfcRyMGtwrphjO8KKrFtAcP2PAxfE
         a7lXtNM2Ny5c+slJlgCfDtiOU7rLFFnxbce7utUBLjxpg5dPaXD7QnjerHx3exBbY7
         lK+H6nCg1Dn+hP44q+8vWRF+ijoB4IkOu0uFf5yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 513/521] arm64: cmpxchg_double*: hazard against entire exchange variable
Date:   Mon, 16 Jan 2023 16:52:55 +0100
Message-Id: <20230116154910.158515617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 031af50045ea97ed4386eb3751ca2c134d0fc911 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h | 2 +-
 arch/arm64/include/asm/atomic_lse.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index 1cc42441bc67..a9b315dc7e24 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -320,7 +320,7 @@ __LL_SC_PREFIX(__cmpxchg_double##name(unsigned long old1,		\
 	"	cbnz	%w0, 1b\n"					\
 	"	" #mb "\n"						\
 	"2:"								\
-	: "=&r" (tmp), "=&r" (ret), "+Q" (*(unsigned long *)ptr)	\
+	: "=&r" (tmp), "=&r" (ret), "+Q" (*(__uint128_t *)ptr)		\
 	: "r" (old1), "r" (old2), "r" (new1), "r" (new2)		\
 	: cl);								\
 									\
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index 80cadc789f1a..393d73797e73 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -555,7 +555,7 @@ static inline long __cmpxchg_double##name(unsigned long old1,		\
 	"	eor	%[old2], %[old2], %[oldval2]\n"			\
 	"	orr	%[old1], %[old1], %[old2]")			\
 	: [old1] "+&r" (x0), [old2] "+&r" (x1),				\
-	  [v] "+Q" (*(unsigned long *)ptr)				\
+	  [v] "+Q" (*(__uint128_t *)ptr)				\
 	: [new1] "r" (x2), [new2] "r" (x3), [ptr] "r" (x4),		\
 	  [oldval1] "r" (oldval1), [oldval2] "r" (oldval2)		\
 	: __LL_SC_CLOBBERS, ##cl);					\
-- 
2.35.1



