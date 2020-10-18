Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386BA291FC1
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgJRURL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 16:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgJRURL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 16:17:11 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D65C061755
        for <stable@vger.kernel.org>; Sun, 18 Oct 2020 13:17:10 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a200so4729912pfa.10
        for <stable@vger.kernel.org>; Sun, 18 Oct 2020 13:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHh2bMKyWi8itG0tlpCf17j2AL2aFudUN1FRuH686xs=;
        b=JB2XuWfPMfRoVSjJ2ayv2vY2hJ8nTnJ6+/Hp1A4oKypPEOXI7vZQYbXwSPeJ7kntr7
         8ZywekvuCTJLrv0O29W+ErhuPPHQPn/CoJdgaIw9mi1azEDoX82rt4kUSDaBsrZwIu10
         iglpX/aw7YxvdaAI5Fd1nTqNfSAEc/XS56XfSXUesk41toGIyJj8i3L/Uj4apwXK7y6Y
         vLir1MZ6JhWzHxf7+mptYuPgghQxG+9fP4HhLh+LllOux3QSvrRPgwy7QIRIvvJCcFPz
         Zhrt+MTgrtquQCmAGXLTkGD347S3bFlwmLWvdmaVBuAFhoDQ2hVrB/iWv6Mx8naCzlXD
         Yx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHh2bMKyWi8itG0tlpCf17j2AL2aFudUN1FRuH686xs=;
        b=P5aKcWYl80aTd8LxteKjGliYdUftaBvIuU9TqRy/SbqavMkD9ehuwSwxeTwXIm9I2e
         dFAcnzCal7GT/dsnvmgndTFQ1KeF2oTdsLGkfvwOYb+A06JdvKfTqzaYRthVRHBeFSWw
         kUazjQMcNZd7rdyuJz05typVZZBFHHMLhbcixfe/kZAZQD3zIosX0XGSwhXa6kPtURqt
         aPAhzOzgoMNCICXPr5kDtJQcwr0JQ0aLq9hj1ZepxFv5nb/m31GbvnbbJ9aBLoofZvh/
         DVLRUSMmBp+veDdEigQ7a+wJ9dxfTsrW2kYF70Z1mGyAZ/A7l4PP9pn00ZoYDZ8yHezx
         tSfw==
X-Gm-Message-State: AOAM532T6BgAt77iMbv2D6H9kUvwCj+ULYrqs6aDUxrY96dpH8GCO1n4
        f3X9w5Ddxh6UWpYOUJwVEsjHebWW3GY=
X-Google-Smtp-Source: ABdhPJyNlyVPpdxhlX/bSzeKKk7yFjoiXkQ2fyVGGUA1UGAh2dzCreAjtODdTqkDJhNp6F0sR5v36Q==
X-Received: by 2002:a65:5b09:: with SMTP id y9mr11279254pgq.155.1603052229976;
        Sun, 18 Oct 2020 13:17:09 -0700 (PDT)
Received: from localhost (g167.58-98-146.ppp.wakwak.ne.jp. [58.98.146.167])
        by smtp.gmail.com with ESMTPSA id a18sm9025633pgw.50.2020.10.18.13.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 13:17:09 -0700 (PDT)
From:   Stafford Horne <shorne@gmail.com>
To:     stable@vger.kernel.org
Cc:     Openrisc <openrisc@lists.librecores.org>,
        Stafford Horne <shorne@gmail.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 1/1] openrisc: Fix issue with get_user for 64-bit values
Date:   Mon, 19 Oct 2020 05:16:51 +0900
Message-Id: <20201018201651.2604140-2-shorne@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201018201651.2604140-1-shorne@gmail.com>
References: <20201018201651.2604140-1-shorne@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d877322bc1adcab9850732275670409e8bcca4c4 upstream

Backport of v5.9 commit d877322bc1ad for v5.8.y and v5.4.y.

Change in backport:
 - The original commit depends on a series of sparse warning fix
   patches.  This patch elliminates that requirement.

A build failure was raised by kbuild with the following error.

    drivers/android/binder.c: Assembler messages:
    drivers/android/binder.c:3861: Error: unrecognized keyword/register name `l.lwz ?ap,4(r24)'
    drivers/android/binder.c:3866: Error: unrecognized keyword/register name `l.addi ?ap,r0,0'

The issue is with 64-bit get_user() calls on openrisc.  I traced this to
a problem where in the internally in the get_user macros there is a cast
to long __gu_val this causes GCC to think the get_user call is 32-bit.
This binder code is really long and GCC allocates register r30, which
triggers the issue. The 64-bit get_user asm tries to get the 64-bit pair
register, which for r30 overflows the general register names and returns
the dummy register ?ap.

The fix here is to move the temporary variables into the asm macros.  We
use a 32-bit __gu_tmp for 32-bit and smaller macro and a 64-bit tmp in
the 64-bit macro.  The cast in the 64-bit macro has a trick of casting
through __typeof__((x)-(x)) which avoids the below warning.  This was
borrowed from riscv.

    arch/openrisc/include/asm/uaccess.h:240:8: warning: cast to pointer from integer of different size

I tested this in a small unit test to check reading between 64-bit and
32-bit pointers to 64-bit and 32-bit values in all combinations.  Also I
ran make C=1 to confirm no new sparse warnings came up.  It all looks
clean to me.

Link: https://lore.kernel.org/lkml/202008200453.ohnhqkjQ%25lkp@intel.com/
Signed-off-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 arch/openrisc/include/asm/uaccess.h | 35 ++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/openrisc/include/asm/uaccess.h b/arch/openrisc/include/asm/uaccess.h
index 17c24f14615f..6839f8fcf76b 100644
--- a/arch/openrisc/include/asm/uaccess.h
+++ b/arch/openrisc/include/asm/uaccess.h
@@ -164,19 +164,19 @@ struct __large_struct {
 
 #define __get_user_nocheck(x, ptr, size)			\
 ({								\
-	long __gu_err, __gu_val;				\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
-	(x) = (__force __typeof__(*(ptr)))__gu_val;		\
+	long __gu_err;						\
+	__get_user_size((x), (ptr), (size), __gu_err);		\
 	__gu_err;						\
 })
 
 #define __get_user_check(x, ptr, size)					\
 ({									\
-	long __gu_err = -EFAULT, __gu_val = 0;				\
-	const __typeof__(*(ptr)) * __gu_addr = (ptr);			\
-	if (access_ok(__gu_addr, size))			\
-		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+	long __gu_err = -EFAULT;					\
+	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
+	if (access_ok(__gu_addr, size))					\
+		__get_user_size((x), __gu_addr, (size), __gu_err);	\
+	else								\
+		(x) = (__typeof__(*(ptr))) 0;				\
 	__gu_err;							\
 })
 
@@ -190,11 +190,13 @@ do {									\
 	case 2: __get_user_asm(x, ptr, retval, "l.lhz"); break;		\
 	case 4: __get_user_asm(x, ptr, retval, "l.lwz"); break;		\
 	case 8: __get_user_asm2(x, ptr, retval); break;			\
-	default: (x) = __get_user_bad();				\
+	default: (x) = (__typeof__(*(ptr)))__get_user_bad();		\
 	}								\
 } while (0)
 
 #define __get_user_asm(x, addr, err, op)		\
+{							\
+	unsigned long __gu_tmp;				\
 	__asm__ __volatile__(				\
 		"1:	"op" %1,0(%2)\n"		\
 		"2:\n"					\
@@ -208,10 +210,14 @@ do {									\
 		"	.align 2\n"			\
 		"	.long 1b,3b\n"			\
 		".previous"				\
-		: "=r"(err), "=r"(x)			\
-		: "r"(addr), "i"(-EFAULT), "0"(err))
+		: "=r"(err), "=r"(__gu_tmp)		\
+		: "r"(addr), "i"(-EFAULT), "0"(err));	\
+	(x) = (__typeof__(*(addr)))__gu_tmp;		\
+}
 
 #define __get_user_asm2(x, addr, err)			\
+{							\
+	unsigned long long __gu_tmp;			\
 	__asm__ __volatile__(				\
 		"1:	l.lwz %1,0(%2)\n"		\
 		"2:	l.lwz %H1,4(%2)\n"		\
@@ -228,8 +234,11 @@ do {									\
 		"	.long 1b,4b\n"			\
 		"	.long 2b,4b\n"			\
 		".previous"				\
-		: "=r"(err), "=&r"(x)			\
-		: "r"(addr), "i"(-EFAULT), "0"(err))
+		: "=r"(err), "=&r"(__gu_tmp)		\
+		: "r"(addr), "i"(-EFAULT), "0"(err));	\
+	(x) = (__typeof__(*(addr)))(			\
+		(__typeof__((x)-(x)))__gu_tmp);		\
+}
 
 /* more complex routines */
 
-- 
2.26.2

