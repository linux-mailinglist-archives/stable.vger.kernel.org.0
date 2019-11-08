Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88BEF53FC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbfKHSxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732122AbfKHSxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:53:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6394221924;
        Fri,  8 Nov 2019 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239187;
        bh=wWaSGquZttpkiodZtGCya6CUBupEyEa+hsEPnt/d0+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNu0oEOloR4fdV/kZoiEAt7C+6zEcMS9UZwZTpRGlJiW0UD13SrseDL66SYcfbNHs
         8W6dZeGwO0Fv8XQAVQomKng/thrnxnShQzdT27vr/OaMyi54+y/D7ij4NplA+ObyZI
         RDTcm53TtCLH7us/8UwqsYw7/TwsLCzcPKL/YDks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 29/75] ARM: uaccess: remove put_user() code duplication
Date:   Fri,  8 Nov 2019 19:49:46 +0100
Message-Id: <20191108174737.076997190@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

Commit 9f73bd8bb445e0cbe4bcef6d4cfc788f1e184007 upstream.

Remove the code duplication between put_user() and __put_user().  The
code which selected the implementation based upon the pointer size, and
declared the local variable to hold the value to be put are common to
both implementations.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/uaccess.h |  106 ++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -238,49 +238,23 @@ extern int __put_user_2(void *, unsigned
 extern int __put_user_4(void *, unsigned int);
 extern int __put_user_8(void *, unsigned long long);
 
-#define __put_user_x(__r2, __p, __e, __l, __s)				\
-	   __asm__ __volatile__ (					\
-		__asmeq("%0", "r0") __asmeq("%2", "r2")			\
-		__asmeq("%3", "r1")					\
-		"bl	__put_user_" #__s				\
-		: "=&r" (__e)						\
-		: "0" (__p), "r" (__r2), "r" (__l)			\
-		: "ip", "lr", "cc")
-
-#define __put_user_check(x, p)						\
+#define __put_user_check(__pu_val, __ptr, __err, __s)			\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
-		const typeof(*(p)) __user *__tmp_p = (p);		\
-		register const typeof(*(p)) __r2 asm("r2") = (x);	\
-		register const typeof(*(p)) __user *__p asm("r0") = __tmp_p; \
+		register typeof(__pu_val) __r2 asm("r2") = __pu_val;	\
+		register const void __user *__p asm("r0") = __ptr;	\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
-		unsigned int __ua_flags = uaccess_save_and_enable();	\
-		switch (sizeof(*(__p))) {				\
-		case 1:							\
-			__put_user_x(__r2, __p, __e, __l, 1);		\
-			break;						\
-		case 2:							\
-			__put_user_x(__r2, __p, __e, __l, 2);		\
-			break;						\
-		case 4:							\
-			__put_user_x(__r2, __p, __e, __l, 4);		\
-			break;						\
-		case 8:							\
-			__put_user_x(__r2, __p, __e, __l, 8);		\
-			break;						\
-		default: __e = __put_user_bad(); break;			\
-		}							\
-		uaccess_restore(__ua_flags);				\
-		__e;							\
+		__asm__ __volatile__ (					\
+			__asmeq("%0", "r0") __asmeq("%2", "r2")		\
+			__asmeq("%3", "r1")				\
+			"bl	__put_user_" #__s			\
+			: "=&r" (__e)					\
+			: "0" (__p), "r" (__r2), "r" (__l)		\
+			: "ip", "lr", "cc");				\
+		__err = __e;						\
 	})
 
-#define put_user(x, p)							\
-	({								\
-		might_fault();						\
-		__put_user_check(x, p);					\
-	 })
-
 #else /* CONFIG_MMU */
 
 /*
@@ -298,7 +272,7 @@ static inline void set_fs(mm_segment_t f
 }
 
 #define get_user(x, p)	__get_user(x, p)
-#define put_user(x, p)	__put_user(x, p)
+#define __put_user_check __put_user_nocheck
 
 #endif /* CONFIG_MMU */
 
@@ -389,36 +363,54 @@ do {									\
 #define __get_user_asm_word(x, addr, err)			\
 	__get_user_asm(x, addr, err, ldr)
 
+
+#define __put_user_switch(x, ptr, __err, __fn)				\
+	do {								\
+		const __typeof__(*(ptr)) __user *__pu_ptr = (ptr);	\
+		__typeof__(*(ptr)) __pu_val = (x);			\
+		unsigned int __ua_flags;				\
+		might_fault();						\
+		__ua_flags = uaccess_save_and_enable();			\
+		switch (sizeof(*(ptr))) {				\
+		case 1: __fn(__pu_val, __pu_ptr, __err, 1); break;	\
+		case 2:	__fn(__pu_val, __pu_ptr, __err, 2); break;	\
+		case 4:	__fn(__pu_val, __pu_ptr, __err, 4); break;	\
+		case 8:	__fn(__pu_val, __pu_ptr, __err, 8); break;	\
+		default: __err = __put_user_bad(); break;		\
+		}							\
+		uaccess_restore(__ua_flags);				\
+	} while (0)
+
+#define put_user(x, ptr)						\
+({									\
+	int __pu_err = 0;						\
+	__put_user_switch((x), (ptr), __pu_err, __put_user_check);	\
+	__pu_err;							\
+})
+
 #define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
-	__put_user_err((x), (ptr), __pu_err);				\
+	__put_user_switch((x), (ptr), __pu_err, __put_user_nocheck);	\
 	__pu_err;							\
 })
 
 #define __put_user_error(x, ptr, err)					\
 ({									\
-	__put_user_err((x), (ptr), err);				\
+	__put_user_switch((x), (ptr), (err), __put_user_nocheck);	\
 	(void) 0;							\
 })
 
-#define __put_user_err(x, ptr, err)					\
-do {									\
-	unsigned long __pu_addr = (unsigned long)(ptr);			\
-	unsigned int __ua_flags;					\
-	__typeof__(*(ptr)) __pu_val = (x);				\
-	__chk_user_ptr(ptr);						\
-	might_fault();							\
-	__ua_flags = uaccess_save_and_enable();				\
-	switch (sizeof(*(ptr))) {					\
-	case 1: __put_user_asm_byte(__pu_val, __pu_addr, err);	break;	\
-	case 2: __put_user_asm_half(__pu_val, __pu_addr, err);	break;	\
-	case 4: __put_user_asm_word(__pu_val, __pu_addr, err);	break;	\
-	case 8:	__put_user_asm_dword(__pu_val, __pu_addr, err);	break;	\
-	default: __put_user_bad();					\
-	}								\
-	uaccess_restore(__ua_flags);					\
-} while (0)
+#define __put_user_nocheck(x, __pu_ptr, __err, __size)			\
+	do {								\
+		unsigned long __pu_addr = (unsigned long)__pu_ptr;	\
+		__put_user_nocheck_##__size(x, __pu_addr, __err);	\
+	} while (0)
+
+#define __put_user_nocheck_1 __put_user_asm_byte
+#define __put_user_nocheck_2 __put_user_asm_half
+#define __put_user_nocheck_4 __put_user_asm_word
+#define __put_user_nocheck_8 __put_user_asm_dword
 
 #define __put_user_asm(x, __pu_addr, err, instr)		\
 	__asm__ __volatile__(					\


