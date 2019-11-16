Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC3DFF12C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfKPPtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbfKPPtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:11 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A868E20729;
        Sat, 16 Nov 2019 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919350;
        bh=10WOfMG8uWhuBI/BUbcgjMuv9twpfwR//L0iuBIhDvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4PpV3D7lQgNHLBobRUOIyJ+AckFXbgnshyyakOkD0HIiATE4Drx+8CqoeOl+lrTk
         wZEa5pHK1a2YWnp52MTdd5Xp1O2tiVc6yC29xSJ9inMczyWsxhCunh3jfLx0i6VtTR
         0qfxyw4c3dXAxrmnNuqoqW3Cj2bunwywA1jZQaE0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kyeongdon Kim <kyeongdon.kim@lge.com>,
        Alexander Potapenko <glider@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 078/150] arm64: lib: use C string functions with KASAN enabled
Date:   Sat, 16 Nov 2019 10:46:16 -0500
Message-Id: <20191116154729.9573-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

[ Upstream commit 19a2ca0fb560fd7be7b5293c6b652c6d6078dcde ]

ARM64 has asm implementation of memchr(), memcmp(), str[r]chr(),
str[n]cmp(), str[n]len().  KASAN don't see memory accesses in asm code,
thus it can potentially miss many bugs.

Ifdef out __HAVE_ARCH_* defines of these functions when KASAN is enabled,
so the generic implementations from lib/string.c will be used.

We can't just remove the asm functions because efistub uses them.  And we
can't have two non-weak functions either, so declare the asm functions as
weak.

Link: http://lkml.kernel.org/r/20180920135631.23833-2-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Kyeongdon Kim <kyeongdon.kim@lge.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/string.h | 14 ++++++++------
 arch/arm64/kernel/arm64ksyms.c  |  7 +++++--
 arch/arm64/lib/memchr.S         |  2 +-
 arch/arm64/lib/memcmp.S         |  2 +-
 arch/arm64/lib/strchr.S         |  2 +-
 arch/arm64/lib/strcmp.S         |  2 +-
 arch/arm64/lib/strlen.S         |  2 +-
 arch/arm64/lib/strncmp.S        |  2 +-
 arch/arm64/lib/strnlen.S        |  2 +-
 arch/arm64/lib/strrchr.S        |  2 +-
 10 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/string.h b/arch/arm64/include/asm/string.h
index dd95d33a5bd5d..03a6c256b7ec4 100644
--- a/arch/arm64/include/asm/string.h
+++ b/arch/arm64/include/asm/string.h
@@ -16,6 +16,7 @@
 #ifndef __ASM_STRING_H
 #define __ASM_STRING_H
 
+#ifndef CONFIG_KASAN
 #define __HAVE_ARCH_STRRCHR
 extern char *strrchr(const char *, int c);
 
@@ -34,6 +35,13 @@ extern __kernel_size_t strlen(const char *);
 #define __HAVE_ARCH_STRNLEN
 extern __kernel_size_t strnlen(const char *, __kernel_size_t);
 
+#define __HAVE_ARCH_MEMCMP
+extern int memcmp(const void *, const void *, size_t);
+
+#define __HAVE_ARCH_MEMCHR
+extern void *memchr(const void *, int, __kernel_size_t);
+#endif
+
 #define __HAVE_ARCH_MEMCPY
 extern void *memcpy(void *, const void *, __kernel_size_t);
 extern void *__memcpy(void *, const void *, __kernel_size_t);
@@ -42,16 +50,10 @@ extern void *__memcpy(void *, const void *, __kernel_size_t);
 extern void *memmove(void *, const void *, __kernel_size_t);
 extern void *__memmove(void *, const void *, __kernel_size_t);
 
-#define __HAVE_ARCH_MEMCHR
-extern void *memchr(const void *, int, __kernel_size_t);
-
 #define __HAVE_ARCH_MEMSET
 extern void *memset(void *, int, __kernel_size_t);
 extern void *__memset(void *, int, __kernel_size_t);
 
-#define __HAVE_ARCH_MEMCMP
-extern int memcmp(const void *, const void *, size_t);
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE
 void memcpy_flushcache(void *dst, const void *src, size_t cnt);
diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
index 66be504edb6cf..9eedf839e7393 100644
--- a/arch/arm64/kernel/arm64ksyms.c
+++ b/arch/arm64/kernel/arm64ksyms.c
@@ -44,20 +44,23 @@ EXPORT_SYMBOL(__arch_copy_in_user);
 EXPORT_SYMBOL(memstart_addr);
 
 	/* string / mem functions */
+#ifndef CONFIG_KASAN
 EXPORT_SYMBOL(strchr);
 EXPORT_SYMBOL(strrchr);
 EXPORT_SYMBOL(strcmp);
 EXPORT_SYMBOL(strncmp);
 EXPORT_SYMBOL(strlen);
 EXPORT_SYMBOL(strnlen);
+EXPORT_SYMBOL(memcmp);
+EXPORT_SYMBOL(memchr);
+#endif
+
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(__memset);
 EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(__memmove);
-EXPORT_SYMBOL(memchr);
-EXPORT_SYMBOL(memcmp);
 
 	/* atomic bitops */
 EXPORT_SYMBOL(set_bit);
diff --git a/arch/arm64/lib/memchr.S b/arch/arm64/lib/memchr.S
index 4444c1d25f4bb..0f164a4baf52a 100644
--- a/arch/arm64/lib/memchr.S
+++ b/arch/arm64/lib/memchr.S
@@ -30,7 +30,7 @@
  * Returns:
  *	x0 - address of first occurrence of 'c' or 0
  */
-ENTRY(memchr)
+WEAK(memchr)
 	and	w1, w1, #0xff
 1:	subs	x2, x2, #1
 	b.mi	2f
diff --git a/arch/arm64/lib/memcmp.S b/arch/arm64/lib/memcmp.S
index 2a4e239bd17a0..fb295f52e9f87 100644
--- a/arch/arm64/lib/memcmp.S
+++ b/arch/arm64/lib/memcmp.S
@@ -58,7 +58,7 @@ pos		.req	x11
 limit_wd	.req	x12
 mask		.req	x13
 
-ENTRY(memcmp)
+WEAK(memcmp)
 	cbz	limit, .Lret0
 	eor	tmp1, src1, src2
 	tst	tmp1, #7
diff --git a/arch/arm64/lib/strchr.S b/arch/arm64/lib/strchr.S
index dae0cf5591f99..7c83091d1bcdd 100644
--- a/arch/arm64/lib/strchr.S
+++ b/arch/arm64/lib/strchr.S
@@ -29,7 +29,7 @@
  * Returns:
  *	x0 - address of first occurrence of 'c' or 0
  */
-ENTRY(strchr)
+WEAK(strchr)
 	and	w1, w1, #0xff
 1:	ldrb	w2, [x0], #1
 	cmp	w2, w1
diff --git a/arch/arm64/lib/strcmp.S b/arch/arm64/lib/strcmp.S
index 471fe61760ef6..7d5d15398bfbc 100644
--- a/arch/arm64/lib/strcmp.S
+++ b/arch/arm64/lib/strcmp.S
@@ -60,7 +60,7 @@ tmp3		.req	x9
 zeroones	.req	x10
 pos		.req	x11
 
-ENTRY(strcmp)
+WEAK(strcmp)
 	eor	tmp1, src1, src2
 	mov	zeroones, #REP8_01
 	tst	tmp1, #7
diff --git a/arch/arm64/lib/strlen.S b/arch/arm64/lib/strlen.S
index 55ccc8e24c084..8e0b14205dcb4 100644
--- a/arch/arm64/lib/strlen.S
+++ b/arch/arm64/lib/strlen.S
@@ -56,7 +56,7 @@ pos		.req	x12
 #define REP8_7f 0x7f7f7f7f7f7f7f7f
 #define REP8_80 0x8080808080808080
 
-ENTRY(strlen)
+WEAK(strlen)
 	mov	zeroones, #REP8_01
 	bic	src, srcin, #15
 	ands	tmp1, srcin, #15
diff --git a/arch/arm64/lib/strncmp.S b/arch/arm64/lib/strncmp.S
index e267044761c6f..66bd145935d9e 100644
--- a/arch/arm64/lib/strncmp.S
+++ b/arch/arm64/lib/strncmp.S
@@ -64,7 +64,7 @@ limit_wd	.req	x13
 mask		.req	x14
 endloop		.req	x15
 
-ENTRY(strncmp)
+WEAK(strncmp)
 	cbz	limit, .Lret0
 	eor	tmp1, src1, src2
 	mov	zeroones, #REP8_01
diff --git a/arch/arm64/lib/strnlen.S b/arch/arm64/lib/strnlen.S
index eae38da6e0bb3..355be04441fe6 100644
--- a/arch/arm64/lib/strnlen.S
+++ b/arch/arm64/lib/strnlen.S
@@ -59,7 +59,7 @@ limit_wd	.req	x14
 #define REP8_7f 0x7f7f7f7f7f7f7f7f
 #define REP8_80 0x8080808080808080
 
-ENTRY(strnlen)
+WEAK(strnlen)
 	cbz	limit, .Lhit_limit
 	mov	zeroones, #REP8_01
 	bic	src, srcin, #15
diff --git a/arch/arm64/lib/strrchr.S b/arch/arm64/lib/strrchr.S
index 61eabd9a289a6..f3b9f8e2917c6 100644
--- a/arch/arm64/lib/strrchr.S
+++ b/arch/arm64/lib/strrchr.S
@@ -29,7 +29,7 @@
  * Returns:
  *	x0 - address of last occurrence of 'c' or 0
  */
-ENTRY(strrchr)
+WEAK(strrchr)
 	mov	x3, #0
 	and	w1, w1, #0xff
 1:	ldrb	w2, [x0], #1
-- 
2.20.1

