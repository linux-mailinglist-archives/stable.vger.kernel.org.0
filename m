Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7A66C9A1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjAPQxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbjAPQwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:52:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F65D32E4B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E64561084
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41702C433F0;
        Mon, 16 Jan 2023 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887050;
        bh=AEr4C//lQSwjzBU6hLE68T7mhesAZzGVTvVipoH2nz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jjp+EunTDrv3hXmR/CDb6DQRJyFLpI3cjxQlgIU1PZGXDyiOLTYiUhKubRXXUz8Sd
         ViIgVRDXtNqA5zdkIm1tSRI7PXbYkkIKMvpbg8poGlkJHiunOWqPEJvmGRm5+mLzT9
         L/IeAcYiDQe3wr4l6ARmH3V1npeEmuphf6d17Ivk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 647/658] arm64: atomics: format whitespace consistently
Date:   Mon, 16 Jan 2023 16:52:15 +0100
Message-Id: <20230116154939.082773117@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 8e6082e94aac6d0338883b5953631b662a5a9188 ]

The code for the atomic ops is formatted inconsistently, and while this
is not a functional problem it is rather distracting when working on
them.

Some have ops have consistent indentation, e.g.

| #define ATOMIC_OP_ADD_RETURN(name, mb, cl...)                           \
| static inline int __lse_atomic_add_return##name(int i, atomic_t *v)     \
| {                                                                       \
|         u32 tmp;                                                        \
|                                                                         \
|         asm volatile(                                                   \
|         __LSE_PREAMBLE                                                  \
|         "       ldadd" #mb "    %w[i], %w[tmp], %[v]\n"                 \
|         "       add     %w[i], %w[i], %w[tmp]"                          \
|         : [i] "+r" (i), [v] "+Q" (v->counter), [tmp] "=&r" (tmp)        \
|         : "r" (v)                                                       \
|         : cl);                                                          \
|                                                                         \
|         return i;                                                       \
| }

While others have negative indentation for some lines, and/or have
misaligned trailing backslashes, e.g.

| static inline void __lse_atomic_##op(int i, atomic_t *v)                        \
| {                                                                       \
|         asm volatile(                                                   \
|         __LSE_PREAMBLE                                                  \
| "       " #asm_op "     %w[i], %[v]\n"                                  \
|         : [i] "+r" (i), [v] "+Q" (v->counter)                           \
|         : "r" (v));                                                     \
| }

This patch makes the indentation consistent and also aligns the trailing
backslashes. This makes the code easier to read for those (like myself)
who are easily distracted by these inconsistencies.

This is intended as a cleanup.
There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20211210151410.2782645-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 031af50045ea ("arm64: cmpxchg_double*: hazard against entire exchange variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h | 86 +++++++++++++--------------
 arch/arm64/include/asm/atomic_lse.h   | 14 ++---
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index 7b012148bfd6..f5743c911303 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -44,11 +44,11 @@ __ll_sc_atomic_##op(int i, atomic_t *v)					\
 									\
 	asm volatile("// atomic_" #op "\n"				\
 	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%w0, %2\n"						\
-"	" #asm_op "	%w0, %w0, %w3\n"				\
-"	stxr	%w1, %w0, %2\n"						\
-"	cbnz	%w1, 1b\n")						\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ldxr	%w0, %2\n"					\
+	"	" #asm_op "	%w0, %w0, %w3\n"			\
+	"	stxr	%w1, %w0, %2\n"					\
+	"	cbnz	%w1, 1b\n")					\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i));				\
 }
@@ -62,12 +62,12 @@ __ll_sc_atomic_##op##_return##name(int i, atomic_t *v)			\
 									\
 	asm volatile("// atomic_" #op "_return" #name "\n"		\
 	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ld" #acq "xr	%w0, %2\n"					\
-"	" #asm_op "	%w0, %w0, %w3\n"				\
-"	st" #rel "xr	%w1, %w0, %2\n"					\
-"	cbnz	%w1, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ld" #acq "xr	%w0, %2\n"				\
+	"	" #asm_op "	%w0, %w0, %w3\n"			\
+	"	st" #rel "xr	%w1, %w0, %2\n"				\
+	"	cbnz	%w1, 1b\n"					\
+	"	" #mb )							\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -84,12 +84,12 @@ __ll_sc_atomic_fetch_##op##name(int i, atomic_t *v)			\
 									\
 	asm volatile("// atomic_fetch_" #op #name "\n"			\
 	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %3\n"					\
-"1:	ld" #acq "xr	%w0, %3\n"					\
-"	" #asm_op "	%w1, %w0, %w4\n"				\
-"	st" #rel "xr	%w2, %w1, %3\n"					\
-"	cbnz	%w2, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %3\n"				\
+	"1:	ld" #acq "xr	%w0, %3\n"				\
+	"	" #asm_op "	%w1, %w0, %w4\n"			\
+	"	st" #rel "xr	%w2, %w1, %3\n"				\
+	"	cbnz	%w2, 1b\n"					\
+	"	" #mb )							\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -143,11 +143,11 @@ __ll_sc_atomic64_##op(s64 i, atomic64_t *v)				\
 									\
 	asm volatile("// atomic64_" #op "\n"				\
 	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%0, %2\n"						\
-"	" #asm_op "	%0, %0, %3\n"					\
-"	stxr	%w1, %0, %2\n"						\
-"	cbnz	%w1, 1b")						\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ldxr	%0, %2\n"					\
+	"	" #asm_op "	%0, %0, %3\n"				\
+	"	stxr	%w1, %0, %2\n"					\
+	"	cbnz	%w1, 1b")					\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i));				\
 }
@@ -161,12 +161,12 @@ __ll_sc_atomic64_##op##_return##name(s64 i, atomic64_t *v)		\
 									\
 	asm volatile("// atomic64_" #op "_return" #name "\n"		\
 	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ld" #acq "xr	%0, %2\n"					\
-"	" #asm_op "	%0, %0, %3\n"					\
-"	st" #rel "xr	%w1, %0, %2\n"					\
-"	cbnz	%w1, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ld" #acq "xr	%0, %2\n"				\
+	"	" #asm_op "	%0, %0, %3\n"				\
+	"	st" #rel "xr	%w1, %0, %2\n"				\
+	"	cbnz	%w1, 1b\n"					\
+	"	" #mb )							\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -176,19 +176,19 @@ __ll_sc_atomic64_##op##_return##name(s64 i, atomic64_t *v)		\
 
 #define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op, constraint)\
 static inline long							\
-__ll_sc_atomic64_fetch_##op##name(s64 i, atomic64_t *v)		\
+__ll_sc_atomic64_fetch_##op##name(s64 i, atomic64_t *v)			\
 {									\
 	s64 result, val;						\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_fetch_" #op #name "\n"		\
 	__LL_SC_FALLBACK(						\
-"	prfm	pstl1strm, %3\n"					\
-"1:	ld" #acq "xr	%0, %3\n"					\
-"	" #asm_op "	%1, %0, %4\n"					\
-"	st" #rel "xr	%w2, %1, %3\n"					\
-"	cbnz	%w2, 1b\n"						\
-"	" #mb )								\
+	"	prfm	pstl1strm, %3\n"				\
+	"1:	ld" #acq "xr	%0, %3\n"				\
+	"	" #asm_op "	%1, %0, %4\n"				\
+	"	st" #rel "xr	%w2, %1, %3\n"				\
+	"	cbnz	%w2, 1b\n"					\
+	"	" #mb )							\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -241,14 +241,14 @@ __ll_sc_atomic64_dec_if_positive(atomic64_t *v)
 
 	asm volatile("// atomic64_dec_if_positive\n"
 	__LL_SC_FALLBACK(
-"	prfm	pstl1strm, %2\n"
-"1:	ldxr	%0, %2\n"
-"	subs	%0, %0, #1\n"
-"	b.lt	2f\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b\n"
-"	dmb	ish\n"
-"2:")
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldxr	%0, %2\n"
+	"	subs	%0, %0, #1\n"
+	"	b.lt	2f\n"
+	"	stlxr	%w1, %0, %2\n"
+	"	cbnz	%w1, 1b\n"
+	"	dmb	ish\n"
+	"2:")
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
 	:
 	: "cc", "memory");
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index da3280f639cd..ab661375835e 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -11,11 +11,11 @@
 #define __ASM_ATOMIC_LSE_H
 
 #define ATOMIC_OP(op, asm_op)						\
-static inline void __lse_atomic_##op(int i, atomic_t *v)			\
+static inline void __lse_atomic_##op(int i, atomic_t *v)		\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op "	%w[i], %[v]\n"					\
+	"	" #asm_op "	%w[i], %[v]\n"				\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v));							\
 }
@@ -32,7 +32,7 @@ static inline int __lse_atomic_fetch_##op##name(int i, atomic_t *v)	\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op #mb "	%w[i], %w[i], %[v]"				\
+	"	" #asm_op #mb "	%w[i], %w[i], %[v]"			\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v)							\
 	: cl);								\
@@ -130,7 +130,7 @@ static inline int __lse_atomic_sub_return##name(int i, atomic_t *v)	\
 	"	add	%w[i], %w[i], %w[tmp]"				\
 	: [i] "+&r" (i), [v] "+Q" (v->counter), [tmp] "=&r" (tmp)	\
 	: "r" (v)							\
-	: cl);							\
+	: cl);								\
 									\
 	return i;							\
 }
@@ -168,7 +168,7 @@ static inline void __lse_atomic64_##op(s64 i, atomic64_t *v)		\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op "	%[i], %[v]\n"					\
+	"	" #asm_op "	%[i], %[v]\n"				\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v));							\
 }
@@ -185,7 +185,7 @@ static inline long __lse_atomic64_fetch_##op##name(s64 i, atomic64_t *v)\
 {									\
 	asm volatile(							\
 	__LSE_PREAMBLE							\
-"	" #asm_op #mb "	%[i], %[i], %[v]"				\
+	"	" #asm_op #mb "	%[i], %[i], %[v]"			\
 	: [i] "+r" (i), [v] "+Q" (v->counter)				\
 	: "r" (v)							\
 	: cl);								\
@@ -272,7 +272,7 @@ static inline void __lse_atomic64_sub(s64 i, atomic64_t *v)
 }
 
 #define ATOMIC64_OP_SUB_RETURN(name, mb, cl...)				\
-static inline long __lse_atomic64_sub_return##name(s64 i, atomic64_t *v)	\
+static inline long __lse_atomic64_sub_return##name(s64 i, atomic64_t *v)\
 {									\
 	unsigned long tmp;						\
 									\
-- 
2.35.1



