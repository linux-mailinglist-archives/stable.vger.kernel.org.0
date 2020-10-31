Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F332A16F2
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgJaLmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbgJaLms (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3062F20731;
        Sat, 31 Oct 2020 11:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144567;
        bh=5sYGZ8RU2vIqUVsw7t71gFMAPZQxxErK7vl1GhC8G3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKd95eNLZW9wPimY4jSkKIF2bd9y7PaYl0qEugY+5wmdnoGyBmst/kDoxBojiji68
         Ya/ZceDg2oJWuxAaOTQNEF2iFLARkUL4Tv1mwNI7CMKUIGBP5KFd3GJuA3qPseRI2v
         18ZKCDXwsBCt4CKRxNFZ8v0Y8GEfZDb+xTxTdPfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stafford Horne <shorne@gmail.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 5.8 68/70] openrisc: Fix issue with get_user for 64-bit values
Date:   Sat, 31 Oct 2020 12:36:40 +0100
Message-Id: <20201031113502.741451469@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

commit d877322bc1adcab9850732275670409e8bcca4c4 upstream.

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
barrowed from riscv.

    arch/openrisc/include/asm/uaccess.h:240:8: warning: cast to pointer from integer of different size

I tested this in a small unit test to check reading between 64-bit and
32-bit pointers to 64-bit and 32-bit values in all combinations.  Also I
ran make C=1 to confirm no new sparse warnings came up.  It all looks
clean to me.

Link: https://lore.kernel.org/lkml/202008200453.ohnhqkjQ%25lkp@intel.com/
Signed-off-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/openrisc/include/asm/uaccess.h |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

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
 


