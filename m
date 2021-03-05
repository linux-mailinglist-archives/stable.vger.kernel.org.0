Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56E732EC99
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 14:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhCEN4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 08:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhCEMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A07A65004;
        Fri,  5 Mar 2021 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947840;
        bh=IZVccgKSxNMf7IaaICO8A6Pd2jXvFkJqxLh0vnr2xNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNHYGjPMappeWD+OOoD0OC8L64BKtpX59ZqmH7cb61Fvw5V8AJ0lpqOSqi2+gYYRI
         JDark+fiYN9itemuUcuumDyN2Zs/BslD3FuopUVasNs5PZI11u8StVaKCEiitcbeza
         u5t+6c42xC0/1nwtL4mEyXxjGSh6ynavLLl6ZdiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 06/52] arm64: Avoid redundant type conversions in xchg() and cmpxchg()
Date:   Fri,  5 Mar 2021 13:21:37 +0100
Message-Id: <20210305120853.968677334@linuxfoundation.org>
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

From: Will Deacon <will.deacon@arm.com>

commit 5ef3fe4cecdf82fdd71ce78988403963d01444d4 upstream.

Our atomic instructions (either LSE atomics of LDXR/STXR sequences)
natively support byte, half-word, word and double-word memory accesses
so there is no need to mask the data register prior to being stored.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[bwh: Backported to 4.19: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h |   53 +++++++--------
 arch/arm64/include/asm/atomic_lse.h   |   46 ++++++-------
 arch/arm64/include/asm/cmpxchg.h      |  116 +++++++++++++++++-----------------
 3 files changed, 108 insertions(+), 107 deletions(-)

--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -248,48 +248,49 @@ __LL_SC_PREFIX(atomic64_dec_if_positive(
 }
 __LL_SC_EXPORT(atomic64_dec_if_positive);
 
-#define __CMPXCHG_CASE(w, sz, name, mb, acq, rel, cl)			\
-__LL_SC_INLINE unsigned long						\
-__LL_SC_PREFIX(__cmpxchg_case_##name(volatile void *ptr,		\
-				     unsigned long old,			\
-				     unsigned long new))		\
+#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\
+__LL_SC_INLINE u##sz							\
+__LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\
+					 unsigned long old,		\
+					 u##sz new))			\
 {									\
-	unsigned long tmp, oldval;					\
+	unsigned long tmp;						\
+	u##sz oldval;							\
 									\
 	asm volatile(							\
 	"	prfm	pstl1strm, %[v]\n"				\
-	"1:	ld" #acq "xr" #sz "\t%" #w "[oldval], %[v]\n"		\
+	"1:	ld" #acq "xr" #sfx "\t%" #w "[oldval], %[v]\n"		\
 	"	eor	%" #w "[tmp], %" #w "[oldval], %" #w "[old]\n"	\
 	"	cbnz	%" #w "[tmp], 2f\n"				\
-	"	st" #rel "xr" #sz "\t%w[tmp], %" #w "[new], %[v]\n"	\
+	"	st" #rel "xr" #sfx "\t%w[tmp], %" #w "[new], %[v]\n"	\
 	"	cbnz	%w[tmp], 1b\n"					\
 	"	" #mb "\n"						\
 	"2:"								\
 	: [tmp] "=&r" (tmp), [oldval] "=&r" (oldval),			\
-	  [v] "+Q" (*(unsigned long *)ptr)				\
+	  [v] "+Q" (*(u##sz *)ptr)					\
 	: [old] "Lr" (old), [new] "r" (new)				\
 	: cl);								\
 									\
 	return oldval;							\
 }									\
-__LL_SC_EXPORT(__cmpxchg_case_##name);
+__LL_SC_EXPORT(__cmpxchg_case_##name##sz);
 
-__CMPXCHG_CASE(w, b,     1,        ,  ,  ,         )
-__CMPXCHG_CASE(w, h,     2,        ,  ,  ,         )
-__CMPXCHG_CASE(w,  ,     4,        ,  ,  ,         )
-__CMPXCHG_CASE( ,  ,     8,        ,  ,  ,         )
-__CMPXCHG_CASE(w, b, acq_1,        , a,  , "memory")
-__CMPXCHG_CASE(w, h, acq_2,        , a,  , "memory")
-__CMPXCHG_CASE(w,  , acq_4,        , a,  , "memory")
-__CMPXCHG_CASE( ,  , acq_8,        , a,  , "memory")
-__CMPXCHG_CASE(w, b, rel_1,        ,  , l, "memory")
-__CMPXCHG_CASE(w, h, rel_2,        ,  , l, "memory")
-__CMPXCHG_CASE(w,  , rel_4,        ,  , l, "memory")
-__CMPXCHG_CASE( ,  , rel_8,        ,  , l, "memory")
-__CMPXCHG_CASE(w, b,  mb_1, dmb ish,  , l, "memory")
-__CMPXCHG_CASE(w, h,  mb_2, dmb ish,  , l, "memory")
-__CMPXCHG_CASE(w,  ,  mb_4, dmb ish,  , l, "memory")
-__CMPXCHG_CASE( ,  ,  mb_8, dmb ish,  , l, "memory")
+__CMPXCHG_CASE(w, b,     ,  8,        ,  ,  ,         )
+__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         )
+__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         )
+__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,         )
+__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory")
+__CMPXCHG_CASE(w, h, acq_, 16,        , a,  , "memory")
+__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")
+__CMPXCHG_CASE( ,  , acq_, 64,        , a,  , "memory")
+__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memory")
+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory")
+__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "memory")
+__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")
+__CMPXCHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory")
+__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l, "memory")
+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory")
+__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory")
 
 #undef __CMPXCHG_CASE
 
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -480,24 +480,24 @@ static inline long atomic64_dec_if_posit
 
 #define __LL_SC_CMPXCHG(op)	__LL_SC_CALL(__cmpxchg_case_##op)
 
-#define __CMPXCHG_CASE(w, sz, name, mb, cl...)				\
-static inline unsigned long __cmpxchg_case_##name(volatile void *ptr,	\
-						  unsigned long old,	\
-						  unsigned long new)	\
+#define __CMPXCHG_CASE(w, sfx, name, sz, mb, cl...)			\
+static inline u##sz __cmpxchg_case_##name##sz(volatile void *ptr,	\
+					      unsigned long old,	\
+					      u##sz new)		\
 {									\
 	register unsigned long x0 asm ("x0") = (unsigned long)ptr;	\
 	register unsigned long x1 asm ("x1") = old;			\
-	register unsigned long x2 asm ("x2") = new;			\
+	register u##sz x2 asm ("x2") = new;				\
 									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
 	ARM64_LSE_ATOMIC_INSN(						\
 	/* LL/SC */							\
-	__LL_SC_CMPXCHG(name)						\
+	__LL_SC_CMPXCHG(name##sz)					\
 	__nops(2),							\
 	/* LSE atomics */						\
 	"	mov	" #w "30, %" #w "[old]\n"			\
-	"	cas" #mb #sz "\t" #w "30, %" #w "[new], %[v]\n"		\
+	"	cas" #mb #sfx "\t" #w "30, %" #w "[new], %[v]\n"	\
 	"	mov	%" #w "[ret], " #w "30")			\
 	: [ret] "+r" (x0), [v] "+Q" (*(unsigned long *)ptr)		\
 	: [old] "r" (x1), [new] "r" (x2)				\
@@ -506,22 +506,22 @@ static inline unsigned long __cmpxchg_ca
 	return x0;							\
 }
 
-__CMPXCHG_CASE(w, b,     1,   )
-__CMPXCHG_CASE(w, h,     2,   )
-__CMPXCHG_CASE(w,  ,     4,   )
-__CMPXCHG_CASE(x,  ,     8,   )
-__CMPXCHG_CASE(w, b, acq_1,  a, "memory")
-__CMPXCHG_CASE(w, h, acq_2,  a, "memory")
-__CMPXCHG_CASE(w,  , acq_4,  a, "memory")
-__CMPXCHG_CASE(x,  , acq_8,  a, "memory")
-__CMPXCHG_CASE(w, b, rel_1,  l, "memory")
-__CMPXCHG_CASE(w, h, rel_2,  l, "memory")
-__CMPXCHG_CASE(w,  , rel_4,  l, "memory")
-__CMPXCHG_CASE(x,  , rel_8,  l, "memory")
-__CMPXCHG_CASE(w, b,  mb_1, al, "memory")
-__CMPXCHG_CASE(w, h,  mb_2, al, "memory")
-__CMPXCHG_CASE(w,  ,  mb_4, al, "memory")
-__CMPXCHG_CASE(x,  ,  mb_8, al, "memory")
+__CMPXCHG_CASE(w, b,     ,  8,   )
+__CMPXCHG_CASE(w, h,     , 16,   )
+__CMPXCHG_CASE(w,  ,     , 32,   )
+__CMPXCHG_CASE(x,  ,     , 64,   )
+__CMPXCHG_CASE(w, b, acq_,  8,  a, "memory")
+__CMPXCHG_CASE(w, h, acq_, 16,  a, "memory")
+__CMPXCHG_CASE(w,  , acq_, 32,  a, "memory")
+__CMPXCHG_CASE(x,  , acq_, 64,  a, "memory")
+__CMPXCHG_CASE(w, b, rel_,  8,  l, "memory")
+__CMPXCHG_CASE(w, h, rel_, 16,  l, "memory")
+__CMPXCHG_CASE(w,  , rel_, 32,  l, "memory")
+__CMPXCHG_CASE(x,  , rel_, 64,  l, "memory")
+__CMPXCHG_CASE(w, b,  mb_,  8, al, "memory")
+__CMPXCHG_CASE(w, h,  mb_, 16, al, "memory")
+__CMPXCHG_CASE(w,  ,  mb_, 32, al, "memory")
+__CMPXCHG_CASE(x,  ,  mb_, 64, al, "memory")
 
 #undef __LL_SC_CMPXCHG
 #undef __CMPXCHG_CASE
--- a/arch/arm64/include/asm/cmpxchg.h
+++ b/arch/arm64/include/asm/cmpxchg.h
@@ -30,46 +30,46 @@
  * barrier case is generated as release+dmb for the former and
  * acquire+release for the latter.
  */
-#define __XCHG_CASE(w, sz, name, mb, nop_lse, acq, acq_lse, rel, cl)	\
-static inline unsigned long __xchg_case_##name(unsigned long x,		\
-					       volatile void *ptr)	\
-{									\
-	unsigned long ret, tmp;						\
-									\
-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
-	/* LL/SC */							\
-	"	prfm	pstl1strm, %2\n"				\
-	"1:	ld" #acq "xr" #sz "\t%" #w "0, %2\n"			\
-	"	st" #rel "xr" #sz "\t%w1, %" #w "3, %2\n"		\
-	"	cbnz	%w1, 1b\n"					\
-	"	" #mb,							\
-	/* LSE atomics */						\
-	"	swp" #acq_lse #rel #sz "\t%" #w "3, %" #w "0, %2\n"	\
-		__nops(3)						\
-	"	" #nop_lse)						\
-	: "=&r" (ret), "=&r" (tmp), "+Q" (*(unsigned long *)ptr)	\
-	: "r" (x)							\
-	: cl);								\
-									\
-	return ret;							\
+#define __XCHG_CASE(w, sfx, name, sz, mb, nop_lse, acq, acq_lse, rel, cl)	\
+static inline u##sz __xchg_case_##name##sz(u##sz x, volatile void *ptr)		\
+{										\
+	u##sz ret;								\
+	unsigned long tmp;							\
+										\
+	asm volatile(ARM64_LSE_ATOMIC_INSN(					\
+	/* LL/SC */								\
+	"	prfm	pstl1strm, %2\n"					\
+	"1:	ld" #acq "xr" #sfx "\t%" #w "0, %2\n"				\
+	"	st" #rel "xr" #sfx "\t%w1, %" #w "3, %2\n"			\
+	"	cbnz	%w1, 1b\n"						\
+	"	" #mb,								\
+	/* LSE atomics */							\
+	"	swp" #acq_lse #rel #sfx "\t%" #w "3, %" #w "0, %2\n"		\
+		__nops(3)							\
+	"	" #nop_lse)							\
+	: "=&r" (ret), "=&r" (tmp), "+Q" (*(u##sz *)ptr)			\
+	: "r" (x)								\
+	: cl);									\
+										\
+	return ret;								\
 }
 
-__XCHG_CASE(w, b,     1,        ,    ,  ,  ,  ,         )
-__XCHG_CASE(w, h,     2,        ,    ,  ,  ,  ,         )
-__XCHG_CASE(w,  ,     4,        ,    ,  ,  ,  ,         )
-__XCHG_CASE( ,  ,     8,        ,    ,  ,  ,  ,         )
-__XCHG_CASE(w, b, acq_1,        ,    , a, a,  , "memory")
-__XCHG_CASE(w, h, acq_2,        ,    , a, a,  , "memory")
-__XCHG_CASE(w,  , acq_4,        ,    , a, a,  , "memory")
-__XCHG_CASE( ,  , acq_8,        ,    , a, a,  , "memory")
-__XCHG_CASE(w, b, rel_1,        ,    ,  ,  , l, "memory")
-__XCHG_CASE(w, h, rel_2,        ,    ,  ,  , l, "memory")
-__XCHG_CASE(w,  , rel_4,        ,    ,  ,  , l, "memory")
-__XCHG_CASE( ,  , rel_8,        ,    ,  ,  , l, "memory")
-__XCHG_CASE(w, b,  mb_1, dmb ish, nop,  , a, l, "memory")
-__XCHG_CASE(w, h,  mb_2, dmb ish, nop,  , a, l, "memory")
-__XCHG_CASE(w,  ,  mb_4, dmb ish, nop,  , a, l, "memory")
-__XCHG_CASE( ,  ,  mb_8, dmb ish, nop,  , a, l, "memory")
+__XCHG_CASE(w, b,     ,  8,        ,    ,  ,  ,  ,         )
+__XCHG_CASE(w, h,     , 16,        ,    ,  ,  ,  ,         )
+__XCHG_CASE(w,  ,     , 32,        ,    ,  ,  ,  ,         )
+__XCHG_CASE( ,  ,     , 64,        ,    ,  ,  ,  ,         )
+__XCHG_CASE(w, b, acq_,  8,        ,    , a, a,  , "memory")
+__XCHG_CASE(w, h, acq_, 16,        ,    , a, a,  , "memory")
+__XCHG_CASE(w,  , acq_, 32,        ,    , a, a,  , "memory")
+__XCHG_CASE( ,  , acq_, 64,        ,    , a, a,  , "memory")
+__XCHG_CASE(w, b, rel_,  8,        ,    ,  ,  , l, "memory")
+__XCHG_CASE(w, h, rel_, 16,        ,    ,  ,  , l, "memory")
+__XCHG_CASE(w,  , rel_, 32,        ,    ,  ,  , l, "memory")
+__XCHG_CASE( ,  , rel_, 64,        ,    ,  ,  , l, "memory")
+__XCHG_CASE(w, b,  mb_,  8, dmb ish, nop,  , a, l, "memory")
+__XCHG_CASE(w, h,  mb_, 16, dmb ish, nop,  , a, l, "memory")
+__XCHG_CASE(w,  ,  mb_, 32, dmb ish, nop,  , a, l, "memory")
+__XCHG_CASE( ,  ,  mb_, 64, dmb ish, nop,  , a, l, "memory")
 
 #undef __XCHG_CASE
 
@@ -80,13 +80,13 @@ static __always_inline  unsigned long __
 {									\
 	switch (size) {							\
 	case 1:								\
-		return __xchg_case##sfx##_1(x, ptr);			\
+		return __xchg_case##sfx##_8(x, ptr);			\
 	case 2:								\
-		return __xchg_case##sfx##_2(x, ptr);			\
+		return __xchg_case##sfx##_16(x, ptr);			\
 	case 4:								\
-		return __xchg_case##sfx##_4(x, ptr);			\
+		return __xchg_case##sfx##_32(x, ptr);			\
 	case 8:								\
-		return __xchg_case##sfx##_8(x, ptr);			\
+		return __xchg_case##sfx##_64(x, ptr);			\
 	default:							\
 		BUILD_BUG();						\
 	}								\
@@ -123,13 +123,13 @@ static __always_inline unsigned long __c
 {									\
 	switch (size) {							\
 	case 1:								\
-		return __cmpxchg_case##sfx##_1(ptr, (u8)old, new);	\
+		return __cmpxchg_case##sfx##_8(ptr, (u8)old, new);	\
 	case 2:								\
-		return __cmpxchg_case##sfx##_2(ptr, (u16)old, new);	\
+		return __cmpxchg_case##sfx##_16(ptr, (u16)old, new);	\
 	case 4:								\
-		return __cmpxchg_case##sfx##_4(ptr, old, new);		\
+		return __cmpxchg_case##sfx##_32(ptr, old, new);		\
 	case 8:								\
-		return __cmpxchg_case##sfx##_8(ptr, old, new);		\
+		return __cmpxchg_case##sfx##_64(ptr, old, new);		\
 	default:							\
 		BUILD_BUG();						\
 	}								\
@@ -197,16 +197,16 @@ __CMPXCHG_GEN(_mb)
 	__ret; \
 })
 
-#define __CMPWAIT_CASE(w, sz, name)					\
-static inline void __cmpwait_case_##name(volatile void *ptr,		\
-					 unsigned long val)		\
+#define __CMPWAIT_CASE(w, sfx, sz)					\
+static inline void __cmpwait_case_##sz(volatile void *ptr,		\
+				       unsigned long val)		\
 {									\
 	unsigned long tmp;						\
 									\
 	asm volatile(							\
 	"	sevl\n"							\
 	"	wfe\n"							\
-	"	ldxr" #sz "\t%" #w "[tmp], %[v]\n"			\
+	"	ldxr" #sfx "\t%" #w "[tmp], %[v]\n"			\
 	"	eor	%" #w "[tmp], %" #w "[tmp], %" #w "[val]\n"	\
 	"	cbnz	%" #w "[tmp], 1f\n"				\
 	"	wfe\n"							\
@@ -215,10 +215,10 @@ static inline void __cmpwait_case_##name
 	: [val] "r" (val));						\
 }
 
-__CMPWAIT_CASE(w, b, 1);
-__CMPWAIT_CASE(w, h, 2);
-__CMPWAIT_CASE(w,  , 4);
-__CMPWAIT_CASE( ,  , 8);
+__CMPWAIT_CASE(w, b, 8);
+__CMPWAIT_CASE(w, h, 16);
+__CMPWAIT_CASE(w,  , 32);
+__CMPWAIT_CASE( ,  , 64);
 
 #undef __CMPWAIT_CASE
 
@@ -229,13 +229,13 @@ static __always_inline void __cmpwait##s
 {									\
 	switch (size) {							\
 	case 1:								\
-		return __cmpwait_case##sfx##_1(ptr, (u8)val);		\
+		return __cmpwait_case##sfx##_8(ptr, (u8)val);		\
 	case 2:								\
-		return __cmpwait_case##sfx##_2(ptr, (u16)val);		\
+		return __cmpwait_case##sfx##_16(ptr, (u16)val);		\
 	case 4:								\
-		return __cmpwait_case##sfx##_4(ptr, val);		\
+		return __cmpwait_case##sfx##_32(ptr, val);		\
 	case 8:								\
-		return __cmpwait_case##sfx##_8(ptr, val);		\
+		return __cmpwait_case##sfx##_64(ptr, val);		\
 	default:							\
 		BUILD_BUG();						\
 	}								\


