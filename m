Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E17119341
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfLJVIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbfLJVIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B5320652;
        Tue, 10 Dec 2019 21:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012099;
        bh=wlb3aptF+UfvJxTE3wVtDGZpzjjtOcE5vPI8R5fDwa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CU7PPcRlNsW5jw7g1y789J25/FS8ry+xn3ptPCsE4bhy5Y85UTtYCksy8SztkJ/ks
         jhHqGh09NOmVfjga31qjPOWNLH/brSWZuHA2qSZbem0yD5f82TRa3GRcY7Jm9fXl/B
         B0eMeGkndejSulFcsPNXaAtXHX//Rb8a9nrAxRdw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 075/350] MIPS: futex: Emit Loongson3 sync workarounds within asm
Date:   Tue, 10 Dec 2019 16:03:00 -0500
Message-Id: <20191210210735.9077-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

[ Upstream commit 3c1d3f0979721a39dd2980c97466127ce65aa130 ]

Generate the sync instructions required to workaround Loongson3 LL/SC
errata within inline asm blocks, which feels a little safer than doing
it from C where strictly speaking the compiler would be well within its
rights to insert a memory access between the separate asm statements we
previously had, containing sync & ll instructions respectively.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/barrier.h | 13 +++++++------
 arch/mips/include/asm/futex.h   | 15 +++++++--------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index 9228f73862205..fb842965d541d 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -218,13 +218,14 @@
  * ordering will be done by smp_llsc_mb() and friends.
  */
 #if defined(CONFIG_WEAK_REORDERING_BEYOND_LLSC) && defined(CONFIG_SMP)
-#define __WEAK_LLSC_MB		"	sync	\n"
-#define smp_llsc_mb()		__asm__ __volatile__(__WEAK_LLSC_MB : : :"memory")
-#define __LLSC_CLOBBER
+# define __WEAK_LLSC_MB		sync
+# define smp_llsc_mb() \
+	__asm__ __volatile__(__stringify(__WEAK_LLSC_MB) : : :"memory")
+# define __LLSC_CLOBBER
 #else
-#define __WEAK_LLSC_MB		"		\n"
-#define smp_llsc_mb()		do { } while (0)
-#define __LLSC_CLOBBER		"memory"
+# define __WEAK_LLSC_MB
+# define smp_llsc_mb()		do { } while (0)
+# define __LLSC_CLOBBER		"memory"
 #endif
 
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
diff --git a/arch/mips/include/asm/futex.h b/arch/mips/include/asm/futex.h
index b83b0397462d9..54cf205309316 100644
--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -16,6 +16,7 @@
 #include <asm/barrier.h>
 #include <asm/compiler.h>
 #include <asm/errno.h>
+#include <asm/sync.h>
 #include <asm/war.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)		\
@@ -32,7 +33,7 @@
 		"	.set	arch=r4000			\n"	\
 		"2:	sc	$1, %2				\n"	\
 		"	beqzl	$1, 1b				\n"	\
-		__WEAK_LLSC_MB						\
+		__stringify(__WEAK_LLSC_MB)				\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -50,19 +51,19 @@
 		  "i" (-EFAULT)						\
 		: "memory");						\
 	} else if (cpu_has_llsc) {					\
-		loongson_llsc_mb();					\
 		__asm__ __volatile__(					\
 		"	.set	push				\n"	\
 		"	.set	noat				\n"	\
 		"	.set	push				\n"	\
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
+		"	" __SYNC(full, loongson3_war) "		\n"	\
 		"1:	"user_ll("%1", "%4")" # __futex_atomic_op\n"	\
 		"	.set	pop				\n"	\
 		"	" insn	"				\n"	\
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
 		"2:	"user_sc("$1", "%2")"			\n"	\
 		"	beqz	$1, 1b				\n"	\
-		__WEAK_LLSC_MB						\
+		__stringify(__WEAK_LLSC_MB)				\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -147,7 +148,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		"	.set	arch=r4000				\n"
 		"2:	sc	$1, %2					\n"
 		"	beqzl	$1, 1b					\n"
-		__WEAK_LLSC_MB
+		__stringify(__WEAK_LLSC_MB)
 		"3:							\n"
 		"	.insn						\n"
 		"	.set	pop					\n"
@@ -164,13 +165,13 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		  "i" (-EFAULT)
 		: "memory");
 	} else if (cpu_has_llsc) {
-		loongson_llsc_mb();
 		__asm__ __volatile__(
 		"# futex_atomic_cmpxchg_inatomic			\n"
 		"	.set	push					\n"
 		"	.set	noat					\n"
 		"	.set	push					\n"
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
+		"	" __SYNC(full, loongson3_war) "			\n"
 		"1:	"user_ll("%1", "%3")"				\n"
 		"	bne	%1, %z4, 3f				\n"
 		"	.set	pop					\n"
@@ -178,8 +179,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 		"2:	"user_sc("$1", "%2")"				\n"
 		"	beqz	$1, 1b					\n"
-		__WEAK_LLSC_MB
-		"3:							\n"
+		"3:	" __SYNC_ELSE(full, loongson3_war, __WEAK_LLSC_MB) "\n"
 		"	.insn						\n"
 		"	.set	pop					\n"
 		"	.section .fixup,\"ax\"				\n"
@@ -194,7 +194,6 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		: GCC_OFF_SMALL_ASM() (*uaddr), "Jr" (oldval), "Jr" (newval),
 		  "i" (-EFAULT)
 		: "memory");
-		loongson_llsc_mb();
 	} else
 		return -ENOSYS;
 
-- 
2.20.1

