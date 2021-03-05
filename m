Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E962832E9B4
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhCEMe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232173AbhCEMd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FFA964F23;
        Fri,  5 Mar 2021 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947639;
        bh=FTAW4QqHvb29GyAjqVidyQcYMxSOuWoKsmGr0LTjH3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGgH44xV6yfgcOAWf6dJaFm+QA5mz5TPkCMe0eV8pK4TQiKQoeJCOMgHXuRvclPOx
         p9p9jdO1xC5KrMUTwmoftMFC9gzLlNy6IXEFtSoyw+oP/y+Rc1DXcRQhgNysd+yNwk
         aYJN/b2JO7j6StDgCaiXTbHqrEjJhK1AljQNfnEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        linux-mips@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4 23/72] MIPS: Drop 32-bit asm string functions
Date:   Fri,  5 Mar 2021 13:21:25 +0100
Message-Id: <20210305120858.481470995@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
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

Signed-off-by: Paul Burton <paul.burton@mips.com>
URL: https://lore.kernel.org/linux-mips/a2a35f1cf58d6db19eb4af9b4ae21e35@dlink.ru/
Cc: Alexander Lobakin <alobakin@dlink.ru>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/string.h |  121 -----------------------------------------
 1 file changed, 121 deletions(-)

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
 


