Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6711B4E4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbfLKPXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732666AbfLKPXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 339A722B48;
        Wed, 11 Dec 2019 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077786;
        bh=m0Xi4nTk+oGEpyZ0wdmXOfeFk6InEJHjaHdGJ/1h9rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y20i9oFh1j67nkyLtbsIl/xOya9QZq6Q72+Id2to2Q+rlfyAyAR1AyEV7rERsAq8G
         pwWndSWxDs1Dgz7O7rrfRvOf+E13XS44M9CD4W7fzb9CNnh7sEN7tPghd5r5Xh5WwT
         fsWiX9AZEI0uM9dJO7HWOfQUe//chM2hRY3Fis9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/243] powerpc/math-emu: Update macros from GCC
Date:   Wed, 11 Dec 2019 16:05:32 +0100
Message-Id: <20191211150350.655949194@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit b682c8692442711684befe413cf93cf01c5324ea ]

The add_ssaaaa, sub_ddmmss, umul_ppmm and udiv_qrnnd macros originate
from GCC's longlong.h which in turn was copied from GMP's longlong.h a
few decades ago.

This was found when compiling with clang:

   arch/powerpc/math-emu/fnmsub.c:46:2: error: invalid use of a cast in a
   inline asm context requiring an l-value: remove the cast or build with
   -fheinous-gnu-extensions
           FP_ADD_D(R, T, B);
           ^~~~~~~~~~~~~~~~~
   ...

   ./arch/powerpc/include/asm/sfp-machine.h:283:27: note: expanded from
   macro 'sub_ddmmss'
                  : "=r" ((USItype)(sh)),                                  \
                          ~~~~~~~~~~^~~

Segher points out: this was fixed in GCC over 16 years ago
( https://gcc.gnu.org/r56600 ), and in GMP (where it comes from)
presumably before that.

Update the add_ssaaaa, sub_ddmmss, umul_ppmm and udiv_qrnnd macros to
the latest GCC version in order to git rid of the invalid casts. These
were taken as-is from GCC's longlong in order to make future syncs
obvious. Other parts of sfp-machine.h were left as-is as the file
contains more features than present in longlong.h.

Link: https://github.com/ClangBuiltLinux/linux/issues/260
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/sfp-machine.h | 92 ++++++++------------------
 1 file changed, 29 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/include/asm/sfp-machine.h b/arch/powerpc/include/asm/sfp-machine.h
index d89beaba26ff9..8b957aabb826d 100644
--- a/arch/powerpc/include/asm/sfp-machine.h
+++ b/arch/powerpc/include/asm/sfp-machine.h
@@ -213,30 +213,18 @@
  * respectively.  The result is placed in HIGH_SUM and LOW_SUM.  Overflow
  * (i.e. carry out) is not stored anywhere, and is lost.
  */
-#define add_ssaaaa(sh, sl, ah, al, bh, bl)				\
+#define add_ssaaaa(sh, sl, ah, al, bh, bl) \
   do {									\
     if (__builtin_constant_p (bh) && (bh) == 0)				\
-      __asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{aze|addze} %0,%2"		\
-	     : "=r" ((USItype)(sh)),					\
-	       "=&r" ((USItype)(sl))					\
-	     : "%r" ((USItype)(ah)),					\
-	       "%r" ((USItype)(al)),					\
-	       "rI" ((USItype)(bl)));					\
-    else if (__builtin_constant_p (bh) && (bh) ==~(USItype) 0)		\
-      __asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{ame|addme} %0,%2"		\
-	     : "=r" ((USItype)(sh)),					\
-	       "=&r" ((USItype)(sl))					\
-	     : "%r" ((USItype)(ah)),					\
-	       "%r" ((USItype)(al)),					\
-	       "rI" ((USItype)(bl)));					\
+      __asm__ ("add%I4c %1,%3,%4\n\taddze %0,%2"		\
+	     : "=r" (sh), "=&r" (sl) : "r" (ah), "%r" (al), "rI" (bl));\
+    else if (__builtin_constant_p (bh) && (bh) == ~(USItype) 0)		\
+      __asm__ ("add%I4c %1,%3,%4\n\taddme %0,%2"		\
+	     : "=r" (sh), "=&r" (sl) : "r" (ah), "%r" (al), "rI" (bl));\
     else								\
-      __asm__ ("{a%I5|add%I5c} %1,%4,%5\n\t{ae|adde} %0,%2,%3"		\
-	     : "=r" ((USItype)(sh)),					\
-	       "=&r" ((USItype)(sl))					\
-	     : "%r" ((USItype)(ah)),					\
-	       "r" ((USItype)(bh)),					\
-	       "%r" ((USItype)(al)),					\
-	       "rI" ((USItype)(bl)));					\
+      __asm__ ("add%I5c %1,%4,%5\n\tadde %0,%2,%3"		\
+	     : "=r" (sh), "=&r" (sl)					\
+	     : "%r" (ah), "r" (bh), "%r" (al), "rI" (bl));		\
   } while (0)
 
 /* sub_ddmmss is used in op-2.h and udivmodti4.c and should be equivalent to
@@ -248,44 +236,24 @@
  * and LOW_DIFFERENCE.  Overflow (i.e. carry out) is not stored anywhere,
  * and is lost.
  */
-#define sub_ddmmss(sh, sl, ah, al, bh, bl)				\
+#define sub_ddmmss(sh, sl, ah, al, bh, bl) \
   do {									\
     if (__builtin_constant_p (ah) && (ah) == 0)				\
-      __asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfze|subfze} %0,%2"	\
-	       : "=r" ((USItype)(sh)),					\
-		 "=&r" ((USItype)(sl))					\
-	       : "r" ((USItype)(bh)),					\
-		 "rI" ((USItype)(al)),					\
-		 "r" ((USItype)(bl)));					\
-    else if (__builtin_constant_p (ah) && (ah) ==~(USItype) 0)		\
-      __asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfme|subfme} %0,%2"	\
-	       : "=r" ((USItype)(sh)),					\
-		 "=&r" ((USItype)(sl))					\
-	       : "r" ((USItype)(bh)),					\
-		 "rI" ((USItype)(al)),					\
-		 "r" ((USItype)(bl)));					\
+      __asm__ ("subf%I3c %1,%4,%3\n\tsubfze %0,%2"	\
+	       : "=r" (sh), "=&r" (sl) : "r" (bh), "rI" (al), "r" (bl));\
+    else if (__builtin_constant_p (ah) && (ah) == ~(USItype) 0)		\
+      __asm__ ("subf%I3c %1,%4,%3\n\tsubfme %0,%2"	\
+	       : "=r" (sh), "=&r" (sl) : "r" (bh), "rI" (al), "r" (bl));\
     else if (__builtin_constant_p (bh) && (bh) == 0)			\
-      __asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{ame|addme} %0,%2"		\
-	       : "=r" ((USItype)(sh)),					\
-		 "=&r" ((USItype)(sl))					\
-	       : "r" ((USItype)(ah)),					\
-		 "rI" ((USItype)(al)),					\
-		 "r" ((USItype)(bl)));					\
-    else if (__builtin_constant_p (bh) && (bh) ==~(USItype) 0)		\
-      __asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{aze|addze} %0,%2"		\
-	       : "=r" ((USItype)(sh)),					\
-		 "=&r" ((USItype)(sl))					\
-	       : "r" ((USItype)(ah)),					\
-		 "rI" ((USItype)(al)),					\
-		 "r" ((USItype)(bl)));					\
+      __asm__ ("subf%I3c %1,%4,%3\n\taddme %0,%2"		\
+	       : "=r" (sh), "=&r" (sl) : "r" (ah), "rI" (al), "r" (bl));\
+    else if (__builtin_constant_p (bh) && (bh) == ~(USItype) 0)		\
+      __asm__ ("subf%I3c %1,%4,%3\n\taddze %0,%2"		\
+	       : "=r" (sh), "=&r" (sl) : "r" (ah), "rI" (al), "r" (bl));\
     else								\
-      __asm__ ("{sf%I4|subf%I4c} %1,%5,%4\n\t{sfe|subfe} %0,%3,%2"	\
-	       : "=r" ((USItype)(sh)),					\
-		 "=&r" ((USItype)(sl))					\
-	       : "r" ((USItype)(ah)),					\
-		 "r" ((USItype)(bh)),					\
-		 "rI" ((USItype)(al)),					\
-		 "r" ((USItype)(bl)));					\
+      __asm__ ("subf%I4c %1,%5,%4\n\tsubfe %0,%3,%2"	\
+	       : "=r" (sh), "=&r" (sl)					\
+	       : "r" (ah), "r" (bh), "rI" (al), "r" (bl));		\
   } while (0)
 
 /* asm fragments for mul and div */
@@ -294,13 +262,10 @@
  * UWtype integers MULTIPLER and MULTIPLICAND, and generates a two UWtype
  * word product in HIGH_PROD and LOW_PROD.
  */
-#define umul_ppmm(ph, pl, m0, m1)					\
+#define umul_ppmm(ph, pl, m0, m1) \
   do {									\
     USItype __m0 = (m0), __m1 = (m1);					\
-    __asm__ ("mulhwu %0,%1,%2"						\
-	     : "=r" ((USItype)(ph))					\
-	     : "%r" (__m0),						\
-               "r" (__m1));						\
+    __asm__ ("mulhwu %0,%1,%2" : "=r" (ph) : "%r" (m0), "r" (m1));	\
     (pl) = __m0 * __m1;							\
   } while (0)
 
@@ -312,9 +277,10 @@
  * significant bit of DENOMINATOR must be 1, then the pre-processor symbol
  * UDIV_NEEDS_NORMALIZATION is defined to 1.
  */
-#define udiv_qrnnd(q, r, n1, n0, d)					\
+#define udiv_qrnnd(q, r, n1, n0, d) \
   do {									\
-    UWtype __d1, __d0, __q1, __q0, __r1, __r0, __m;			\
+    UWtype __d1, __d0, __q1, __q0;					\
+    UWtype __r1, __r0, __m;						\
     __d1 = __ll_highpart (d);						\
     __d0 = __ll_lowpart (d);						\
 									\
@@ -325,7 +291,7 @@
     if (__r1 < __m)							\
       {									\
 	__q1--, __r1 += (d);						\
-	if (__r1 >= (d)) /* we didn't get carry when adding to __r1 */	\
+	if (__r1 >= (d)) /* i.e. we didn't get carry when adding to __r1 */\
 	  if (__r1 < __m)						\
 	    __q1--, __r1 += (d);					\
       }									\
-- 
2.20.1



