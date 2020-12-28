Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E2D2E3952
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbgL1NWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387505AbgL1NWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7561020728;
        Mon, 28 Dec 2020 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161699;
        bh=H006yuA7pol3EFGWVK5dz5S9h0LjaxQg5QY/GxtUlTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMHpH64KXp+NhVvMjX2NVNWFteF3xZ5i7uRLLL2AC0SgQkEJJt1Uu5ZgJvmLVgPGm
         MbaXHkjY7123fGl5UYNnoB9/e08QJIDMN/tqlQkYAu2m+ofqldGBAUq4Jb6Wt64zIX
         mw0cwXtsGia45t1hoTHMrjsm4aEHTQbnO6w/CoKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 050/346] arm64: lse: fix LSE atomics with LLVMs integrated assembler
Date:   Mon, 28 Dec 2020 13:46:09 +0100
Message-Id: <20201228124922.210814887@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

commit e0d5896bd356cd577f9710a02d7a474cdf58426b upstream.

Unlike gcc, clang considers each inline assembly block to be independent
and therefore, when using the integrated assembler for inline assembly,
any preambles that enable features must be repeated in each block.

This change defines __LSE_PREAMBLE and adds it to each inline assembly
block that has LSE instructions, which allows them to be compiled also
with clang's assembler.

Link: https://github.com/ClangBuiltLinux/linux/issues/671
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Andrew Murray <andrew.murray@arm.com>
Tested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
[nd: backport adjusted due to missing:
  commit addfc38672c7 ("arm64: atomics: avoid out-of-line ll/sc atomics")]
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/atomic_lse.h |   76 +++++++++++++++++++++++++++---------
 arch/arm64/include/asm/lse.h        |    6 +-
 2 files changed, 60 insertions(+), 22 deletions(-)

--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -32,7 +32,9 @@ static inline void atomic_##op(int i, at
 	register int w0 asm ("w0") = i;					\
 	register atomic_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(__LL_SC_ATOMIC(op),		\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(__LL_SC_ATOMIC(op),			\
 "	" #asm_op "	%w[i], %[v]\n")					\
 	: [i] "+r" (w0), [v] "+Q" (v->counter)				\
 	: "r" (x1)							\
@@ -52,7 +54,9 @@ static inline int atomic_fetch_##op##nam
 	register int w0 asm ("w0") = i;					\
 	register atomic_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC(fetch_##op##name),				\
 	/* LSE atomics */						\
@@ -84,7 +88,9 @@ static inline int atomic_add_return##nam
 	register int w0 asm ("w0") = i;					\
 	register atomic_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC(add_return##name)				\
 	__nops(1),							\
@@ -110,7 +116,9 @@ static inline void atomic_and(int i, ato
 	register int w0 asm ("w0") = i;
 	register atomic_t *x1 asm ("x1") = v;
 
-	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	asm volatile(
+	__LSE_PREAMBLE
+	ARM64_LSE_ATOMIC_INSN(
 	/* LL/SC */
 	__LL_SC_ATOMIC(and)
 	__nops(1),
@@ -128,7 +136,9 @@ static inline int atomic_fetch_and##name
 	register int w0 asm ("w0") = i;					\
 	register atomic_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC(fetch_and##name)					\
 	__nops(1),							\
@@ -154,7 +164,9 @@ static inline void atomic_sub(int i, ato
 	register int w0 asm ("w0") = i;
 	register atomic_t *x1 asm ("x1") = v;
 
-	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	asm volatile(
+	__LSE_PREAMBLE
+	ARM64_LSE_ATOMIC_INSN(
 	/* LL/SC */
 	__LL_SC_ATOMIC(sub)
 	__nops(1),
@@ -172,7 +184,9 @@ static inline int atomic_sub_return##nam
 	register int w0 asm ("w0") = i;					\
 	register atomic_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC(sub_return##name)				\
 	__nops(2),							\
@@ -200,7 +214,9 @@ static inline int atomic_fetch_sub##name
 	register int w0 asm ("w0") = i;					\
 	register atomic_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC(fetch_sub##name)					\
 	__nops(1),							\
@@ -229,7 +245,9 @@ static inline void atomic64_##op(long i,
 	register long x0 asm ("x0") = i;				\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(__LL_SC_ATOMIC64(op),	\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(__LL_SC_ATOMIC64(op),			\
 "	" #asm_op "	%[i], %[v]\n")					\
 	: [i] "+r" (x0), [v] "+Q" (v->counter)				\
 	: "r" (x1)							\
@@ -249,7 +267,9 @@ static inline long atomic64_fetch_##op##
 	register long x0 asm ("x0") = i;				\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC64(fetch_##op##name),				\
 	/* LSE atomics */						\
@@ -281,7 +301,9 @@ static inline long atomic64_add_return##
 	register long x0 asm ("x0") = i;				\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC64(add_return##name)				\
 	__nops(1),							\
@@ -307,7 +329,9 @@ static inline void atomic64_and(long i,
 	register long x0 asm ("x0") = i;
 	register atomic64_t *x1 asm ("x1") = v;
 
-	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	asm volatile(
+	__LSE_PREAMBLE
+	ARM64_LSE_ATOMIC_INSN(
 	/* LL/SC */
 	__LL_SC_ATOMIC64(and)
 	__nops(1),
@@ -325,7 +349,9 @@ static inline long atomic64_fetch_and##n
 	register long x0 asm ("x0") = i;				\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC64(fetch_and##name)				\
 	__nops(1),							\
@@ -351,7 +377,9 @@ static inline void atomic64_sub(long i,
 	register long x0 asm ("x0") = i;
 	register atomic64_t *x1 asm ("x1") = v;
 
-	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	asm volatile(
+	__LSE_PREAMBLE
+	ARM64_LSE_ATOMIC_INSN(
 	/* LL/SC */
 	__LL_SC_ATOMIC64(sub)
 	__nops(1),
@@ -369,7 +397,9 @@ static inline long atomic64_sub_return##
 	register long x0 asm ("x0") = i;				\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC64(sub_return##name)				\
 	__nops(2),							\
@@ -397,7 +427,9 @@ static inline long atomic64_fetch_sub##n
 	register long x0 asm ("x0") = i;				\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_ATOMIC64(fetch_sub##name)				\
 	__nops(1),							\
@@ -422,7 +454,9 @@ static inline long atomic64_dec_if_posit
 {
 	register long x0 asm ("x0") = (long)v;
 
-	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	asm volatile(
+	__LSE_PREAMBLE
+	ARM64_LSE_ATOMIC_INSN(
 	/* LL/SC */
 	__LL_SC_ATOMIC64(dec_if_positive)
 	__nops(6),
@@ -455,7 +489,9 @@ static inline unsigned long __cmpxchg_ca
 	register unsigned long x1 asm ("x1") = old;			\
 	register unsigned long x2 asm ("x2") = new;			\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_CMPXCHG(name)						\
 	__nops(2),							\
@@ -507,7 +543,9 @@ static inline long __cmpxchg_double##nam
 	register unsigned long x3 asm ("x3") = new2;			\
 	register unsigned long x4 asm ("x4") = (unsigned long)ptr;	\
 									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
+	asm volatile(							\
+	__LSE_PREAMBLE							\
+	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
 	__LL_SC_CMPXCHG_DBL(name)					\
 	__nops(3),							\
--- a/arch/arm64/include/asm/lse.h
+++ b/arch/arm64/include/asm/lse.h
@@ -4,6 +4,8 @@
 
 #if defined(CONFIG_AS_LSE) && defined(CONFIG_ARM64_LSE_ATOMICS)
 
+#define __LSE_PREAMBLE	".arch armv8-a+lse\n"
+
 #include <linux/compiler_types.h>
 #include <linux/export.h>
 #include <linux/stringify.h>
@@ -20,8 +22,6 @@
 
 #else	/* __ASSEMBLER__ */
 
-__asm__(".arch_extension	lse");
-
 /* Move the ll/sc atomics out-of-line */
 #define __LL_SC_INLINE		notrace
 #define __LL_SC_PREFIX(x)	__ll_sc_##x
@@ -33,7 +33,7 @@ __asm__(".arch_extension	lse");
 
 /* In-line patching at runtime */
 #define ARM64_LSE_ATOMIC_INSN(llsc, lse)				\
-	ALTERNATIVE(llsc, lse, ARM64_HAS_LSE_ATOMICS)
+	ALTERNATIVE(llsc, __LSE_PREAMBLE lse, ARM64_HAS_LSE_ATOMICS)
 
 #endif	/* __ASSEMBLER__ */
 #else	/* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */


