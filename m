Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E6F12F18F
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgABWLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgABWLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B343D21582;
        Thu,  2 Jan 2020 22:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003100;
        bh=MgInnI9rBtUuTBZbaRpOVlK8CZPmjqXevC8yS5bKwYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbF+e/fiK7p6xUv+W3kzPzeNvL3vUCzKXzgwv2Ujtx1n9zqhDKeyNEA0qIpaJcuZv
         dDTfganEtx1YYU7w3RRnRuB9toNzDSmMCgt+2YEUflrWckrNPBUgS0+qshxJbI1miE
         Fc3vWgyJX1wgWdGV3RVKj30vHmIlnQto87J1nDO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/191] Revert "MIPS: futex: Emit Loongson3 sync workarounds within asm"
Date:   Thu,  2 Jan 2020 23:04:44 +0100
Message-Id: <20200102215830.136388186@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d754a529a8be55f009c6679d772c472c1632cd5b which was
commit 3c1d3f0979721a39dd2980c97466127ce65aa130 upstream.

This breaks the build and should be reverted.

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/barrier.h |   13 ++++++-------
 arch/mips/include/asm/futex.h   |   15 ++++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -218,14 +218,13 @@
  * ordering will be done by smp_llsc_mb() and friends.
  */
 #if defined(CONFIG_WEAK_REORDERING_BEYOND_LLSC) && defined(CONFIG_SMP)
-# define __WEAK_LLSC_MB		sync
-# define smp_llsc_mb() \
-	__asm__ __volatile__(__stringify(__WEAK_LLSC_MB) : : :"memory")
-# define __LLSC_CLOBBER
+#define __WEAK_LLSC_MB		"	sync	\n"
+#define smp_llsc_mb()		__asm__ __volatile__(__WEAK_LLSC_MB : : :"memory")
+#define __LLSC_CLOBBER
 #else
-# define __WEAK_LLSC_MB
-# define smp_llsc_mb()		do { } while (0)
-# define __LLSC_CLOBBER		"memory"
+#define __WEAK_LLSC_MB		"		\n"
+#define smp_llsc_mb()		do { } while (0)
+#define __LLSC_CLOBBER		"memory"
 #endif
 
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -16,7 +16,6 @@
 #include <asm/barrier.h>
 #include <asm/compiler.h>
 #include <asm/errno.h>
-#include <asm/sync.h>
 #include <asm/war.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)		\
@@ -33,7 +32,7 @@
 		"	.set	arch=r4000			\n"	\
 		"2:	sc	$1, %2				\n"	\
 		"	beqzl	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB)				\
+		__WEAK_LLSC_MB						\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -51,19 +50,19 @@
 		  "i" (-EFAULT)						\
 		: "memory");						\
 	} else if (cpu_has_llsc) {					\
+		loongson_llsc_mb();					\
 		__asm__ __volatile__(					\
 		"	.set	push				\n"	\
 		"	.set	noat				\n"	\
 		"	.set	push				\n"	\
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
-		"	" __SYNC(full, loongson3_war) "		\n"	\
 		"1:	"user_ll("%1", "%4")" # __futex_atomic_op\n"	\
 		"	.set	pop				\n"	\
 		"	" insn	"				\n"	\
 		"	.set	"MIPS_ISA_ARCH_LEVEL"		\n"	\
 		"2:	"user_sc("$1", "%2")"			\n"	\
 		"	beqz	$1, 1b				\n"	\
-		__stringify(__WEAK_LLSC_MB)				\
+		__WEAK_LLSC_MB						\
 		"3:						\n"	\
 		"	.insn					\n"	\
 		"	.set	pop				\n"	\
@@ -148,7 +147,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		"	.set	arch=r4000				\n"
 		"2:	sc	$1, %2					\n"
 		"	beqzl	$1, 1b					\n"
-		__stringify(__WEAK_LLSC_MB)
+		__WEAK_LLSC_MB
 		"3:							\n"
 		"	.insn						\n"
 		"	.set	pop					\n"
@@ -165,13 +164,13 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		  "i" (-EFAULT)
 		: "memory");
 	} else if (cpu_has_llsc) {
+		loongson_llsc_mb();
 		__asm__ __volatile__(
 		"# futex_atomic_cmpxchg_inatomic			\n"
 		"	.set	push					\n"
 		"	.set	noat					\n"
 		"	.set	push					\n"
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
-		"	" __SYNC(full, loongson3_war) "			\n"
 		"1:	"user_ll("%1", "%3")"				\n"
 		"	bne	%1, %z4, 3f				\n"
 		"	.set	pop					\n"
@@ -179,7 +178,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		"	.set	"MIPS_ISA_ARCH_LEVEL"			\n"
 		"2:	"user_sc("$1", "%2")"				\n"
 		"	beqz	$1, 1b					\n"
-		"3:	" __SYNC_ELSE(full, loongson3_war, __WEAK_LLSC_MB) "\n"
+		__WEAK_LLSC_MB
+		"3:							\n"
 		"	.insn						\n"
 		"	.set	pop					\n"
 		"	.section .fixup,\"ax\"				\n"
@@ -194,6 +194,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		: GCC_OFF_SMALL_ASM() (*uaddr), "Jr" (oldval), "Jr" (newval),
 		  "i" (-EFAULT)
 		: "memory");
+		loongson_llsc_mb();
 	} else
 		return -ENOSYS;
 


