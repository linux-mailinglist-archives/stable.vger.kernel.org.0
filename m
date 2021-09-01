Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D653FDBA7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345161AbhIAMnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345193AbhIAMky (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D16ED610A2;
        Wed,  1 Sep 2021 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499845;
        bh=5WJS1dpCELoFuKWWplGMrgAb/LCvUI/ySOqljPqtyzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXry/2Zxgxj3dJM85zsLUK6zFe0m+JOnxYHXocGSadW+wMNYRi0lF9LtVp+SjM1aW
         ca9VYKeuRxGiKsDX5/mJyecjZ+ZkepK05qk2Q2g9to2520TsjXCnrV3kosppkSOSEt
         m/UZsiPbwPZtcCxvxmMg883B95yxjY7j/AN4vGww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 101/103] Revert "parisc: Add assembly implementations for memset, strlen, strcpy, strncpy and strcat"
Date:   Wed,  1 Sep 2021 14:28:51 +0200
Message-Id: <20210901122303.926557295@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit f6a3308d6feb351d9854eb8b3f6289a1ac163125 upstream.

This reverts commit 83af58f8068ea3f7b3c537c37a30887bfa585069.

It turns out that at least the assembly implementation for strncpy() was
buggy.  Revert the whole commit and return back to the default coding.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/string.h  |   15 ----
 arch/parisc/kernel/parisc_ksyms.c |    4 -
 arch/parisc/lib/Makefile          |    4 -
 arch/parisc/lib/memset.c          |   72 ++++++++++++++++++++
 arch/parisc/lib/string.S          |  136 --------------------------------------
 5 files changed, 74 insertions(+), 157 deletions(-)
 create mode 100644 arch/parisc/lib/memset.c
 delete mode 100644 arch/parisc/lib/string.S

--- a/arch/parisc/include/asm/string.h
+++ b/arch/parisc/include/asm/string.h
@@ -8,19 +8,4 @@ extern void * memset(void *, int, size_t
 #define __HAVE_ARCH_MEMCPY
 void * memcpy(void * dest,const void *src,size_t count);
 
-#define __HAVE_ARCH_STRLEN
-extern size_t strlen(const char *s);
-
-#define __HAVE_ARCH_STRCPY
-extern char *strcpy(char *dest, const char *src);
-
-#define __HAVE_ARCH_STRNCPY
-extern char *strncpy(char *dest, const char *src, size_t count);
-
-#define __HAVE_ARCH_STRCAT
-extern char *strcat(char *dest, const char *src);
-
-#define __HAVE_ARCH_MEMSET
-extern void *memset(void *, int, size_t);
-
 #endif
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -17,10 +17,6 @@
 
 #include <linux/string.h>
 EXPORT_SYMBOL(memset);
-EXPORT_SYMBOL(strlen);
-EXPORT_SYMBOL(strcpy);
-EXPORT_SYMBOL(strncpy);
-EXPORT_SYMBOL(strcat);
 
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
--- a/arch/parisc/lib/Makefile
+++ b/arch/parisc/lib/Makefile
@@ -3,7 +3,7 @@
 # Makefile for parisc-specific library files
 #
 
-lib-y	:= lusercopy.o bitops.o checksum.o io.o memcpy.o \
-	   ucmpdi2.o delay.o string.o
+lib-y	:= lusercopy.o bitops.o checksum.o io.o memset.o memcpy.o \
+	   ucmpdi2.o delay.o
 
 obj-y	:= iomap.o
--- /dev/null
+++ b/arch/parisc/lib/memset.c
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#include <linux/types.h>
+#include <asm/string.h>
+
+#define OPSIZ (BITS_PER_LONG/8)
+typedef unsigned long op_t;
+
+void *
+memset (void *dstpp, int sc, size_t len)
+{
+  unsigned int c = sc;
+  long int dstp = (long int) dstpp;
+
+  if (len >= 8)
+    {
+      size_t xlen;
+      op_t cccc;
+
+      cccc = (unsigned char) c;
+      cccc |= cccc << 8;
+      cccc |= cccc << 16;
+      if (OPSIZ > 4)
+	/* Do the shift in two steps to avoid warning if long has 32 bits.  */
+	cccc |= (cccc << 16) << 16;
+
+      /* There are at least some bytes to set.
+	 No need to test for LEN == 0 in this alignment loop.  */
+      while (dstp % OPSIZ != 0)
+	{
+	  ((unsigned char *) dstp)[0] = c;
+	  dstp += 1;
+	  len -= 1;
+	}
+
+      /* Write 8 `op_t' per iteration until less than 8 `op_t' remain.  */
+      xlen = len / (OPSIZ * 8);
+      while (xlen > 0)
+	{
+	  ((op_t *) dstp)[0] = cccc;
+	  ((op_t *) dstp)[1] = cccc;
+	  ((op_t *) dstp)[2] = cccc;
+	  ((op_t *) dstp)[3] = cccc;
+	  ((op_t *) dstp)[4] = cccc;
+	  ((op_t *) dstp)[5] = cccc;
+	  ((op_t *) dstp)[6] = cccc;
+	  ((op_t *) dstp)[7] = cccc;
+	  dstp += 8 * OPSIZ;
+	  xlen -= 1;
+	}
+      len %= OPSIZ * 8;
+
+      /* Write 1 `op_t' per iteration until less than OPSIZ bytes remain.  */
+      xlen = len / OPSIZ;
+      while (xlen > 0)
+	{
+	  ((op_t *) dstp)[0] = cccc;
+	  dstp += OPSIZ;
+	  xlen -= 1;
+	}
+      len %= OPSIZ;
+    }
+
+  /* Write the last few bytes.  */
+  while (len > 0)
+    {
+      ((unsigned char *) dstp)[0] = c;
+      dstp += 1;
+      len -= 1;
+    }
+
+  return dstpp;
+}
--- a/arch/parisc/lib/string.S
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *    PA-RISC assembly string functions
- *
- *    Copyright (C) 2019 Helge Deller <deller@gmx.de>
- */
-
-#include <asm/assembly.h>
-#include <linux/linkage.h>
-
-	.section .text.hot
-	.level PA_ASM_LEVEL
-
-	t0 = r20
-	t1 = r21
-	t2 = r22
-
-ENTRY_CFI(strlen, frame=0,no_calls)
-	or,COND(<>) arg0,r0,ret0
-	b,l,n	.Lstrlen_null_ptr,r0
-	depwi	0,31,2,ret0
-	cmpb,COND(<>) arg0,ret0,.Lstrlen_not_aligned
-	ldw,ma	4(ret0),t0
-	cmpib,tr 0,r0,.Lstrlen_loop
-	uxor,nbz r0,t0,r0
-.Lstrlen_not_aligned:
-	uaddcm	arg0,ret0,t1
-	shladd	t1,3,r0,t1
-	mtsar	t1
-	depwi	-1,%sar,32,t0
-	uxor,nbz r0,t0,r0
-.Lstrlen_loop:
-	b,l,n	.Lstrlen_end_loop,r0
-	ldw,ma	4(ret0),t0
-	cmpib,tr 0,r0,.Lstrlen_loop
-	uxor,nbz r0,t0,r0
-.Lstrlen_end_loop:
-	extrw,u,<> t0,7,8,r0
-	addib,tr,n -3,ret0,.Lstrlen_out
-	extrw,u,<> t0,15,8,r0
-	addib,tr,n -2,ret0,.Lstrlen_out
-	extrw,u,<> t0,23,8,r0
-	addi	-1,ret0,ret0
-.Lstrlen_out:
-	bv r0(rp)
-	uaddcm ret0,arg0,ret0
-.Lstrlen_null_ptr:
-	bv,n r0(rp)
-ENDPROC_CFI(strlen)
-
-
-ENTRY_CFI(strcpy, frame=0,no_calls)
-	ldb	0(arg1),t0
-	stb	t0,0(arg0)
-	ldo	0(arg0),ret0
-	ldo	1(arg1),t1
-	cmpb,=	r0,t0,2f
-	ldo	1(arg0),t2
-1:	ldb	0(t1),arg1
-	stb	arg1,0(t2)
-	ldo	1(t1),t1
-	cmpb,<> r0,arg1,1b
-	ldo	1(t2),t2
-2:	bv,n	r0(rp)
-ENDPROC_CFI(strcpy)
-
-
-ENTRY_CFI(strncpy, frame=0,no_calls)
-	ldb	0(arg1),t0
-	stb	t0,0(arg0)
-	ldo	1(arg1),t1
-	ldo	0(arg0),ret0
-	cmpb,=	r0,t0,2f
-	ldo	1(arg0),arg1
-1:	ldo	-1(arg2),arg2
-	cmpb,COND(=),n r0,arg2,2f
-	ldb	0(t1),arg0
-	stb	arg0,0(arg1)
-	ldo	1(t1),t1
-	cmpb,<> r0,arg0,1b
-	ldo	1(arg1),arg1
-2:	bv,n	r0(rp)
-ENDPROC_CFI(strncpy)
-
-
-ENTRY_CFI(strcat, frame=0,no_calls)
-	ldb	0(arg0),t0
-	cmpb,=	t0,r0,2f
-	ldo	0(arg0),ret0
-	ldo	1(arg0),arg0
-1:	ldb	0(arg0),t1
-	cmpb,<>,n r0,t1,1b
-	ldo	1(arg0),arg0
-2:	ldb	0(arg1),t2
-	stb	t2,0(arg0)
-	ldo	1(arg0),arg0
-	ldb	0(arg1),t0
-	cmpb,<>	r0,t0,2b
-	ldo	1(arg1),arg1
-	bv,n	r0(rp)
-ENDPROC_CFI(strcat)
-
-
-ENTRY_CFI(memset, frame=0,no_calls)
-	copy	arg0,ret0
-	cmpb,COND(=) r0,arg0,4f
-	copy	arg0,t2
-	cmpb,COND(=) r0,arg2,4f
-	ldo	-1(arg2),arg3
-	subi	-1,arg3,t0
-	subi	0,t0,t1
-	cmpiclr,COND(>=) 0,t1,arg2
-	ldo	-1(t1),arg2
-	extru arg2,31,2,arg0
-2:	stb	arg1,0(t2)
-	ldo	1(t2),t2
-	addib,>= -1,arg0,2b
-	ldo	-1(arg3),arg3
-	cmpiclr,COND(<=) 4,arg2,r0
-	b,l,n	4f,r0
-#ifdef CONFIG_64BIT
-	depd,*	r0,63,2,arg2
-#else
-	depw	r0,31,2,arg2
-#endif
-	ldo	1(t2),t2
-3:	stb	arg1,-1(t2)
-	stb	arg1,0(t2)
-	stb	arg1,1(t2)
-	stb	arg1,2(t2)
-	addib,COND(>) -4,arg2,3b
-	ldo	4(t2),t2
-4:	bv,n	r0(rp)
-ENDPROC_CFI(memset)
-
-	.end


