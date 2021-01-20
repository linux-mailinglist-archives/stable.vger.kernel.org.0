Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7F92FC6C1
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbhATB23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729973AbhATB2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEF1123339;
        Wed, 20 Jan 2021 01:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105992;
        bh=gGUduK6MdbqDUC7gU/Os07HogcN1GBUxcwWnvsA0Gz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=re3HOL3kisEQN3mHesF5PEzfplBhA+/pa4zcM2TLmkc3VOwSLUg7A7jaTqHHAnhnO
         TeBust6mBptUheQDihZ/43dwexgie518GReIBjBkeQyS5UE5adlbUO/jxRZLH+MBKk
         rFtN9/8jj+LwK6TRkgsHWrJ1NVRqmnkCmXmmLtghVhx7waxtbW9yeiPT7xO1E4Fzba
         UEkNmv4LbggDYeKo7T6NNjjcB0uSU+QKyJwcmzHck7loU2oYY6UWiK43k3+mGCBiMw
         CC25eHUl2fDp0C7iRC3MV9psOtW9fUMzuhYOZ8x5yjv+zP/vK9/64whzo3q2KtWRFs
         Dhc4bFqGZMa8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 23/45] arm64: make atomic helpers __always_inline
Date:   Tue, 19 Jan 2021 20:25:40 -0500
Message-Id: <20210120012602.769683-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
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
index 015ddffaf6caa..b56a4b2bc2486 100644
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

