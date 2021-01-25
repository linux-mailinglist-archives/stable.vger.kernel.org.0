Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D612302ABC
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbhAYSvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbhAYSto (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB75120758;
        Mon, 25 Jan 2021 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600543;
        bh=gGUduK6MdbqDUC7gU/Os07HogcN1GBUxcwWnvsA0Gz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuvjXjVG0AYU5lgB3e89cpQsZv5G6oGRPK59algbzxk+X7ithZP7PRvVGU+qn3N2T
         tpw13ZpYTzyJT7hsVB5Ib88A6taBE3TsGisqF6AGYiArZPCJdCQ4b+OxAnAroOIpdR
         8DD8LcaCEa1KNuQr0nIHyd430CFJStrGLTn9YgkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/199] arm64: make atomic helpers __always_inline
Date:   Mon, 25 Jan 2021 19:37:56 +0100
Message-Id: <20210125183218.544109444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



