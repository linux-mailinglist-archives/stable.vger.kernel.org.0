Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D11BA44E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391163AbfIVSrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391147AbfIVSrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E17F214AF;
        Sun, 22 Sep 2019 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178066;
        bh=JEDXQxD7XcF4gs8ZtNZblO3H6KrpbU4PtWGtaMIjRu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knZMmpdHwonTWzdxaVR/+jekvux54MYig5BTjDuIIjeYgzOm9XUksY372MC8EnAGk
         5Ri4aue0Pb3DBhWkmqS4dKUwikXN6qCNlugCBdykkXcHqCm+saX884e47CjNhPuTzU
         CXiOQ/0QN0h2qryK+OqWhTy2Lf7qMYVzNL7B4cRk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Murray <andrew.murray@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 140/203] arm64: Use correct ll/sc atomic constraints
Date:   Sun, 22 Sep 2019 14:42:46 -0400
Message-Id: <20190922184350.30563-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

[ Upstream commit 580fa1b874711d633f9b145b7777b0e83ebf3787 ]

The A64 ISA accepts distinct (but overlapping) ranges of immediates for:

 * add arithmetic instructions ('I' machine constraint)
 * sub arithmetic instructions ('J' machine constraint)
 * 32-bit logical instructions ('K' machine constraint)
 * 64-bit logical instructions ('L' machine constraint)

... but we currently use the 'I' constraint for many atomic operations
using sub or logical instructions, which is not always valid.

When CONFIG_ARM64_LSE_ATOMICS is not set, this allows invalid immediates
to be passed to instructions, potentially resulting in a build failure.
When CONFIG_ARM64_LSE_ATOMICS is selected the out-of-line ll/sc atomics
always use a register as they have no visibility of the value passed by
the caller.

This patch adds a constraint parameter to the ATOMIC_xx and
__CMPXCHG_CASE macros so that we can pass appropriate constraints for
each case, with uses updated accordingly.

Unfortunately prior to GCC 8.1.0 the 'K' constraint erroneously accepted
'4294967295', so we must instead force the use of a register.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h | 89 ++++++++++++++-------------
 1 file changed, 47 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index c8c850bc3dfb0..6dd011e0b434a 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -26,7 +26,7 @@
  * (the optimize attribute silently ignores these options).
  */
 
-#define ATOMIC_OP(op, asm_op)						\
+#define ATOMIC_OP(op, asm_op, constraint)				\
 __LL_SC_INLINE void							\
 __LL_SC_PREFIX(arch_atomic_##op(int i, atomic_t *v))			\
 {									\
@@ -40,11 +40,11 @@ __LL_SC_PREFIX(arch_atomic_##op(int i, atomic_t *v))			\
 "	stxr	%w1, %w0, %2\n"						\
 "	cbnz	%w1, 1b"						\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i));							\
+	: #constraint "r" (i));						\
 }									\
 __LL_SC_EXPORT(arch_atomic_##op);
 
-#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, constraint)\
 __LL_SC_INLINE int							\
 __LL_SC_PREFIX(arch_atomic_##op##_return##name(int i, atomic_t *v))	\
 {									\
@@ -59,14 +59,14 @@ __LL_SC_PREFIX(arch_atomic_##op##_return##name(int i, atomic_t *v))	\
 "	cbnz	%w1, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
 }									\
 __LL_SC_EXPORT(arch_atomic_##op##_return##name);
 
-#define ATOMIC_FETCH_OP(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC_FETCH_OP(name, mb, acq, rel, cl, op, asm_op, constraint)	\
 __LL_SC_INLINE int							\
 __LL_SC_PREFIX(arch_atomic_fetch_##op##name(int i, atomic_t *v))	\
 {									\
@@ -81,7 +81,7 @@ __LL_SC_PREFIX(arch_atomic_fetch_##op##name(int i, atomic_t *v))	\
 "	cbnz	%w2, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
@@ -99,8 +99,8 @@ __LL_SC_EXPORT(arch_atomic_fetch_##op##name);
 	ATOMIC_FETCH_OP (_acquire,        , a,  , "memory", __VA_ARGS__)\
 	ATOMIC_FETCH_OP (_release,        ,  , l, "memory", __VA_ARGS__)
 
-ATOMIC_OPS(add, add)
-ATOMIC_OPS(sub, sub)
+ATOMIC_OPS(add, add, I)
+ATOMIC_OPS(sub, sub, J)
 
 #undef ATOMIC_OPS
 #define ATOMIC_OPS(...)							\
@@ -110,17 +110,17 @@ ATOMIC_OPS(sub, sub)
 	ATOMIC_FETCH_OP (_acquire,        , a,  , "memory", __VA_ARGS__)\
 	ATOMIC_FETCH_OP (_release,        ,  , l, "memory", __VA_ARGS__)
 
-ATOMIC_OPS(and, and)
-ATOMIC_OPS(andnot, bic)
-ATOMIC_OPS(or, orr)
-ATOMIC_OPS(xor, eor)
+ATOMIC_OPS(and, and, )
+ATOMIC_OPS(andnot, bic, )
+ATOMIC_OPS(or, orr, )
+ATOMIC_OPS(xor, eor, )
 
 #undef ATOMIC_OPS
 #undef ATOMIC_FETCH_OP
 #undef ATOMIC_OP_RETURN
 #undef ATOMIC_OP
 
-#define ATOMIC64_OP(op, asm_op)						\
+#define ATOMIC64_OP(op, asm_op, constraint)				\
 __LL_SC_INLINE void							\
 __LL_SC_PREFIX(arch_atomic64_##op(s64 i, atomic64_t *v))		\
 {									\
@@ -134,11 +134,11 @@ __LL_SC_PREFIX(arch_atomic64_##op(s64 i, atomic64_t *v))		\
 "	stxr	%w1, %0, %2\n"						\
 "	cbnz	%w1, 1b"						\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i));							\
+	: #constraint "r" (i));						\
 }									\
 __LL_SC_EXPORT(arch_atomic64_##op);
 
-#define ATOMIC64_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC64_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, constraint)\
 __LL_SC_INLINE s64							\
 __LL_SC_PREFIX(arch_atomic64_##op##_return##name(s64 i, atomic64_t *v))\
 {									\
@@ -153,14 +153,14 @@ __LL_SC_PREFIX(arch_atomic64_##op##_return##name(s64 i, atomic64_t *v))\
 "	cbnz	%w1, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
 }									\
 __LL_SC_EXPORT(arch_atomic64_##op##_return##name);
 
-#define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op, constraint)\
 __LL_SC_INLINE s64							\
 __LL_SC_PREFIX(arch_atomic64_fetch_##op##name(s64 i, atomic64_t *v))	\
 {									\
@@ -175,7 +175,7 @@ __LL_SC_PREFIX(arch_atomic64_fetch_##op##name(s64 i, atomic64_t *v))	\
 "	cbnz	%w2, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
@@ -193,8 +193,8 @@ __LL_SC_EXPORT(arch_atomic64_fetch_##op##name);
 	ATOMIC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\
 	ATOMIC64_FETCH_OP (_release,,  , l, "memory", __VA_ARGS__)
 
-ATOMIC64_OPS(add, add)
-ATOMIC64_OPS(sub, sub)
+ATOMIC64_OPS(add, add, I)
+ATOMIC64_OPS(sub, sub, J)
 
 #undef ATOMIC64_OPS
 #define ATOMIC64_OPS(...)						\
@@ -204,10 +204,10 @@ ATOMIC64_OPS(sub, sub)
 	ATOMIC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\
 	ATOMIC64_FETCH_OP (_release,,  , l, "memory", __VA_ARGS__)
 
-ATOMIC64_OPS(and, and)
-ATOMIC64_OPS(andnot, bic)
-ATOMIC64_OPS(or, orr)
-ATOMIC64_OPS(xor, eor)
+ATOMIC64_OPS(and, and, L)
+ATOMIC64_OPS(andnot, bic, )
+ATOMIC64_OPS(or, orr, L)
+ATOMIC64_OPS(xor, eor, L)
 
 #undef ATOMIC64_OPS
 #undef ATOMIC64_FETCH_OP
@@ -237,7 +237,7 @@ __LL_SC_PREFIX(arch_atomic64_dec_if_positive(atomic64_t *v))
 }
 __LL_SC_EXPORT(arch_atomic64_dec_if_positive);
 
-#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\
+#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl, constraint)	\
 __LL_SC_INLINE u##sz							\
 __LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\
 					 unsigned long old,		\
@@ -265,29 +265,34 @@ __LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\
 	"2:"								\
 	: [tmp] "=&r" (tmp), [oldval] "=&r" (oldval),			\
 	  [v] "+Q" (*(u##sz *)ptr)					\
-	: [old] "Kr" (old), [new] "r" (new)				\
+	: [old] #constraint "r" (old), [new] "r" (new)			\
 	: cl);								\
 									\
 	return oldval;							\
 }									\
 __LL_SC_EXPORT(__cmpxchg_case_##name##sz);
 
-__CMPXCHG_CASE(w, b,     ,  8,        ,  ,  ,         )
-__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         )
-__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         )
-__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,         )
-__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory")
-__CMPXCHG_CASE(w, h, acq_, 16,        , a,  , "memory")
-__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")
-__CMPXCHG_CASE( ,  , acq_, 64,        , a,  , "memory")
-__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memory")
-__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory")
-__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "memory")
-__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")
-__CMPXCHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory")
-__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l, "memory")
-__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory")
-__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory")
+/*
+ * Earlier versions of GCC (no later than 8.1.0) appear to incorrectly
+ * handle the 'K' constraint for the value 4294967295 - thus we use no
+ * constraint for 32 bit operations.
+ */
+__CMPXCHG_CASE(w, b,     ,  8,        ,  ,  ,         , )
+__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         , )
+__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         , )
+__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,         , L)
+__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory", )
+__CMPXCHG_CASE(w, h, acq_, 16,        , a,  , "memory", )
+__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory", )
+__CMPXCHG_CASE( ,  , acq_, 64,        , a,  , "memory", L)
+__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memory", )
+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory", )
+__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "memory", )
+__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory", L)
+__CMPXCHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory", )
+__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l, "memory", )
+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory", )
+__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory", L)
 
 #undef __CMPXCHG_CASE
 
-- 
2.20.1

