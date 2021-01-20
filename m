Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FC22FC7FF
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbhATCao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbhATB3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF302233FC;
        Wed, 20 Jan 2021 01:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106042;
        bh=8bj+lnRpNczUZo35PzLngMNOFbjrf+wRcmr3i5pK/UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3aVfbhOrH+ycyS65ij8DmuLHZbrBO2CWyKDZMGZ6zqqbdve4mTaHTp/VlCGoD7rd
         L7WZ44/sAua9eNi4Ik2I71j8PWHbklOO+hZiwZoNEQCXqeUlZUSvf6ZXHdcUQETfw7
         jrndKz3t+NQNdogmP1kd7B2PvLvceHnTS+tEuTjRnwvEUvfSQS4vR8TeFIWJqDszDb
         gPvBWHlRlMwZhYFEcuSDR1OGlGfEQ2/8flelr0nCbB5BuqvpNc01H8L9CLiweC3Pc2
         zIYLpxgfyDk0LJndc/Kys0yXqJkPlZYKktY84gEXKFENBO61F4dTzUr0aK9mfUU/nK
         MjNq5iYW0r1LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 13/26] arm64: make atomic helpers __always_inline
Date:   Tue, 19 Jan 2021 20:26:50 -0500
Message-Id: <20210120012704.770095-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c35a824c31834d947fb99b0c608c1b9f922b4ba0 ]

With UBSAN enabled and building with clang, there are occasionally
warnings like

WARNING: modpost: vmlinux.o(.text+0xc533ec): Section mismatch in reference from the function arch_atomic64_or() to the variable .init.data:numa_nodes_parsed
The function arch_atomic64_or() references
the variable __initdata numa_nodes_parsed.
This is often because arch_atomic64_or lacks a __initdata
annotation or the annotation of numa_nodes_parsed is wrong.

for functions that end up not being inlined as intended but operating
on __initdata variables. Mark these as __always_inline, along with
the corresponding asm-generic wrappers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210108092024.4034860-1-arnd@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/atomic.h     | 10 +++++-----
 include/asm-generic/bitops/atomic.h |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 9543b5e0534d2..6e0f48ddfc656 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -17,7 +17,7 @@
 #include <asm/lse.h>
 
 #define ATOMIC_OP(op)							\
-static inline void arch_##op(int i, atomic_t *v)			\
+static __always_inline void arch_##op(int i, atomic_t *v)		\
 {									\
 	__lse_ll_sc_body(op, i, v);					\
 }
@@ -32,7 +32,7 @@ ATOMIC_OP(atomic_sub)
 #undef ATOMIC_OP
 
 #define ATOMIC_FETCH_OP(name, op)					\
-static inline int arch_##op##name(int i, atomic_t *v)			\
+static __always_inline int arch_##op##name(int i, atomic_t *v)		\
 {									\
 	return __lse_ll_sc_body(op##name, i, v);			\
 }
@@ -56,7 +56,7 @@ ATOMIC_FETCH_OPS(atomic_sub_return)
 #undef ATOMIC_FETCH_OPS
 
 #define ATOMIC64_OP(op)							\
-static inline void arch_##op(long i, atomic64_t *v)			\
+static __always_inline void arch_##op(long i, atomic64_t *v)		\
 {									\
 	__lse_ll_sc_body(op, i, v);					\
 }
@@ -71,7 +71,7 @@ ATOMIC64_OP(atomic64_sub)
 #undef ATOMIC64_OP
 
 #define ATOMIC64_FETCH_OP(name, op)					\
-static inline long arch_##op##name(long i, atomic64_t *v)		\
+static __always_inline long arch_##op##name(long i, atomic64_t *v)	\
 {									\
 	return __lse_ll_sc_body(op##name, i, v);			\
 }
@@ -94,7 +94,7 @@ ATOMIC64_FETCH_OPS(atomic64_sub_return)
 #undef ATOMIC64_FETCH_OP
 #undef ATOMIC64_FETCH_OPS
 
-static inline long arch_atomic64_dec_if_positive(atomic64_t *v)
+static __always_inline long arch_atomic64_dec_if_positive(atomic64_t *v)
 {
 	return __lse_ll_sc_body(atomic64_dec_if_positive, v);
 }
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index dd90c9792909d..0e7316a86240b 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -11,19 +11,19 @@
  * See Documentation/atomic_bitops.txt for details.
  */
 
-static inline void set_bit(unsigned int nr, volatile unsigned long *p)
+static __always_inline void set_bit(unsigned int nr, volatile unsigned long *p)
 {
 	p += BIT_WORD(nr);
 	atomic_long_or(BIT_MASK(nr), (atomic_long_t *)p);
 }
 
-static inline void clear_bit(unsigned int nr, volatile unsigned long *p)
+static __always_inline void clear_bit(unsigned int nr, volatile unsigned long *p)
 {
 	p += BIT_WORD(nr);
 	atomic_long_andnot(BIT_MASK(nr), (atomic_long_t *)p);
 }
 
-static inline void change_bit(unsigned int nr, volatile unsigned long *p)
+static __always_inline void change_bit(unsigned int nr, volatile unsigned long *p)
 {
 	p += BIT_WORD(nr);
 	atomic_long_xor(BIT_MASK(nr), (atomic_long_t *)p);
-- 
2.27.0

