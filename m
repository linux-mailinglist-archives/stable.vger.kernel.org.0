Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E4032D5AD
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhCDOtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhCDOtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:49:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD789C061574;
        Thu,  4 Mar 2021 06:48:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lHpHH-00014W-VI; Thu, 04 Mar 2021 15:48:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     Paul Burton <paul.burton@mips.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        linux-mips@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4.y] MIPS: Drop 32-bit asm string functions
Date:   Thu,  4 Mar 2021 15:48:14 +0100
Message-Id: <20210304144814.14131-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 3c0be5849259b729580c23549330973a2dd513a2 upstream.

We have assembly implementations of strcpy(), strncpy(), strcmp() &
strncmp() which:

 - Are simple byte-at-a-time loops with no particular optimizations. As
   a comment in the code describes, they're "rather naive".

 - Offer no clear performance advantage over the generic C
   implementations - in microbenchmarks performed by Alexander Lobakin
   the asm functions sometimes win & sometimes lose, but generally not
   by large margins in either direction.

 - Don't support 64-bit kernels, where we already make use of the
   generic C implementations.

 - Tend to bloat kernel code size due to inlining.

 - Don't support CONFIG_FORTIFY_SOURCE.

 - Won't support nanoMIPS without rework.

For all of these reasons, delete the asm implementations & make use of
the generic C implementations for 32-bit kernels just like we already do
for 64-bit kernels.

[ stable note: mips32 strncpy does not pad remaining dest buf which causes
  nftables iifname compare failures ].

Signed-off-by: Paul Burton <paul.burton@mips.com>
URL: https://lore.kernel.org/linux-mips/a2a35f1cf58d6db19eb4af9b4ae21e35@dlink.ru/
Cc: Alexander Lobakin <alobakin@dlink.ru>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 arch/mips/include/asm/string.h | 121 ---------------------------------
 1 file changed, 121 deletions(-)

diff --git a/arch/mips/include/asm/string.h b/arch/mips/include/asm/string.h
index 29030cb398ee..1de3bbce8e88 100644
--- a/arch/mips/include/asm/string.h
+++ b/arch/mips/include/asm/string.h
@@ -10,127 +10,6 @@
 #ifndef _ASM_STRING_H
 #define _ASM_STRING_H
 
-
-/*
- * Most of the inline functions are rather naive implementations so I just
- * didn't bother updating them for 64-bit ...
- */
-#ifdef CONFIG_32BIT
-
-#ifndef IN_STRING_C
-
-#define __HAVE_ARCH_STRCPY
-static __inline__ char *strcpy(char *__dest, __const__ char *__src)
-{
-  char *__xdest = __dest;
-
-  __asm__ __volatile__(
-	".set\tnoreorder\n\t"
-	".set\tnoat\n"
-	"1:\tlbu\t$1,(%1)\n\t"
-	"addiu\t%1,1\n\t"
-	"sb\t$1,(%0)\n\t"
-	"bnez\t$1,1b\n\t"
-	"addiu\t%0,1\n\t"
-	".set\tat\n\t"
-	".set\treorder"
-	: "=r" (__dest), "=r" (__src)
-	: "0" (__dest), "1" (__src)
-	: "memory");
-
-  return __xdest;
-}
-
-#define __HAVE_ARCH_STRNCPY
-static __inline__ char *strncpy(char *__dest, __const__ char *__src, size_t __n)
-{
-  char *__xdest = __dest;
-
-  if (__n == 0)
-    return __xdest;
-
-  __asm__ __volatile__(
-	".set\tnoreorder\n\t"
-	".set\tnoat\n"
-	"1:\tlbu\t$1,(%1)\n\t"
-	"subu\t%2,1\n\t"
-	"sb\t$1,(%0)\n\t"
-	"beqz\t$1,2f\n\t"
-	"addiu\t%0,1\n\t"
-	"bnez\t%2,1b\n\t"
-	"addiu\t%1,1\n"
-	"2:\n\t"
-	".set\tat\n\t"
-	".set\treorder"
-	: "=r" (__dest), "=r" (__src), "=r" (__n)
-	: "0" (__dest), "1" (__src), "2" (__n)
-	: "memory");
-
-  return __xdest;
-}
-
-#define __HAVE_ARCH_STRCMP
-static __inline__ int strcmp(__const__ char *__cs, __const__ char *__ct)
-{
-  int __res;
-
-  __asm__ __volatile__(
-	".set\tnoreorder\n\t"
-	".set\tnoat\n\t"
-	"lbu\t%2,(%0)\n"
-	"1:\tlbu\t$1,(%1)\n\t"
-	"addiu\t%0,1\n\t"
-	"bne\t$1,%2,2f\n\t"
-	"addiu\t%1,1\n\t"
-	"bnez\t%2,1b\n\t"
-	"lbu\t%2,(%0)\n\t"
-#if defined(CONFIG_CPU_R3000)
-	"nop\n\t"
-#endif
-	"move\t%2,$1\n"
-	"2:\tsubu\t%2,$1\n"
-	"3:\t.set\tat\n\t"
-	".set\treorder"
-	: "=r" (__cs), "=r" (__ct), "=r" (__res)
-	: "0" (__cs), "1" (__ct));
-
-  return __res;
-}
-
-#endif /* !defined(IN_STRING_C) */
-
-#define __HAVE_ARCH_STRNCMP
-static __inline__ int
-strncmp(__const__ char *__cs, __const__ char *__ct, size_t __count)
-{
-	int __res;
-
-	__asm__ __volatile__(
-	".set\tnoreorder\n\t"
-	".set\tnoat\n"
-	"1:\tlbu\t%3,(%0)\n\t"
-	"beqz\t%2,2f\n\t"
-	"lbu\t$1,(%1)\n\t"
-	"subu\t%2,1\n\t"
-	"bne\t$1,%3,3f\n\t"
-	"addiu\t%0,1\n\t"
-	"bnez\t%3,1b\n\t"
-	"addiu\t%1,1\n"
-	"2:\n\t"
-#if defined(CONFIG_CPU_R3000)
-	"nop\n\t"
-#endif
-	"move\t%3,$1\n"
-	"3:\tsubu\t%3,$1\n\t"
-	".set\tat\n\t"
-	".set\treorder"
-	: "=r" (__cs), "=r" (__ct), "=r" (__count), "=r" (__res)
-	: "0" (__cs), "1" (__ct), "2" (__count));
-
-	return __res;
-}
-#endif /* CONFIG_32BIT */
-
 #define __HAVE_ARCH_MEMSET
 extern void *memset(void *__s, int __c, size_t __count);
 
-- 
2.26.2

