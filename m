Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5901432EC9B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 14:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCEN4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 08:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhCEMhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 203D565004;
        Fri,  5 Mar 2021 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947845;
        bh=FushAJf8Gwe16QHcyOgMcpaObvnUCNA6BY2jUdbPlOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNrfQZlLe6DMa/DoYl/LqbSAR98Mk1ABU/SUOIIqHsDfJlgyJV8cH6JX7SxZOYAnG
         gIw2Tt2mq39Q3MaUq89o94vSYxxDhcD24SIEJ7xwJHo+mRiMjqdpKu3cdmr+YyErY/
         0Y+x+QWyooouXwRwYpr860fR+o07Uz7gh9zmft7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        Will Deacon <will@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 08/52] arm64: Use correct ll/sc atomic constraints
Date:   Fri,  5 Mar 2021 13:21:39 +0100
Message-Id: <20210305120854.066015556@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

commit 580fa1b874711d633f9b145b7777b0e83ebf3787 upstream.

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
[bwh: Backported to 4.19: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h |   89 +++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 42 deletions(-)

--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -37,7 +37,7 @@
  * (the optimize attribute silently ignores these options).
  */
 
-#define ATOMIC_OP(op, asm_op)						\
+#define ATOMIC_OP(op, asm_op, constraint)				\
 __LL_SC_INLINE void							\
 __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v))				\
 {									\
@@ -51,11 +51,11 @@ __LL_SC_PREFIX(atomic_##op(int i, atomic
 "	stxr	%w1, %w0, %2\n"						\
 "	cbnz	%w1, 1b"						\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i));							\
+	: #constraint "r" (i));						\
 }									\
 __LL_SC_EXPORT(atomic_##op);
 
-#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, constraint)\
 __LL_SC_INLINE int							\
 __LL_SC_PREFIX(atomic_##op##_return##name(int i, atomic_t *v))		\
 {									\
@@ -70,14 +70,14 @@ __LL_SC_PREFIX(atomic_##op##_return##nam
 "	cbnz	%w1, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
 }									\
 __LL_SC_EXPORT(atomic_##op##_return##name);
 
-#define ATOMIC_FETCH_OP(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC_FETCH_OP(name, mb, acq, rel, cl, op, asm_op, constraint)	\
 __LL_SC_INLINE int							\
 __LL_SC_PREFIX(atomic_fetch_##op##name(int i, atomic_t *v))		\
 {									\
@@ -92,7 +92,7 @@ __LL_SC_PREFIX(atomic_fetch_##op##name(i
 "	cbnz	%w2, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
@@ -110,8 +110,8 @@ __LL_SC_EXPORT(atomic_fetch_##op##name);
 	ATOMIC_FETCH_OP (_acquire,        , a,  , "memory", __VA_ARGS__)\
 	ATOMIC_FETCH_OP (_release,        ,  , l, "memory", __VA_ARGS__)
 
-ATOMIC_OPS(add, add)
-ATOMIC_OPS(sub, sub)
+ATOMIC_OPS(add, add, I)
+ATOMIC_OPS(sub, sub, J)
 
 #undef ATOMIC_OPS
 #define ATOMIC_OPS(...)							\
@@ -121,17 +121,17 @@ ATOMIC_OPS(sub, sub)
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
 __LL_SC_PREFIX(atomic64_##op(long i, atomic64_t *v))			\
 {									\
@@ -145,11 +145,11 @@ __LL_SC_PREFIX(atomic64_##op(long i, ato
 "	stxr	%w1, %0, %2\n"						\
 "	cbnz	%w1, 1b"						\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i));							\
+	: #constraint "r" (i));						\
 }									\
 __LL_SC_EXPORT(atomic64_##op);
 
-#define ATOMIC64_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC64_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, constraint)\
 __LL_SC_INLINE long							\
 __LL_SC_PREFIX(atomic64_##op##_return##name(long i, atomic64_t *v))	\
 {									\
@@ -164,14 +164,14 @@ __LL_SC_PREFIX(atomic64_##op##_return##n
 "	cbnz	%w1, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
 }									\
 __LL_SC_EXPORT(atomic64_##op##_return##name);
 
-#define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op)		\
+#define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op, constraint)\
 __LL_SC_INLINE long							\
 __LL_SC_PREFIX(atomic64_fetch_##op##name(long i, atomic64_t *v))	\
 {									\
@@ -186,7 +186,7 @@ __LL_SC_PREFIX(atomic64_fetch_##op##name
 "	cbnz	%w2, 1b\n"						\
 "	" #mb								\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
-	: "Ir" (i)							\
+	: #constraint "r" (i)						\
 	: cl);								\
 									\
 	return result;							\
@@ -204,8 +204,8 @@ __LL_SC_EXPORT(atomic64_fetch_##op##name
 	ATOMIC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\
 	ATOMIC64_FETCH_OP (_release,,  , l, "memory", __VA_ARGS__)
 
-ATOMIC64_OPS(add, add)
-ATOMIC64_OPS(sub, sub)
+ATOMIC64_OPS(add, add, I)
+ATOMIC64_OPS(sub, sub, J)
 
 #undef ATOMIC64_OPS
 #define ATOMIC64_OPS(...)						\
@@ -215,10 +215,10 @@ ATOMIC64_OPS(sub, sub)
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
@@ -248,7 +248,7 @@ __LL_SC_PREFIX(atomic64_dec_if_positive(
 }
 __LL_SC_EXPORT(atomic64_dec_if_positive);
 
-#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\
+#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl, constraint)	\
 __LL_SC_INLINE u##sz							\
 __LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\
 					 unsigned long old,		\
@@ -268,29 +268,34 @@ __LL_SC_PREFIX(__cmpxchg_case_##name##sz
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
 


