Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF82BA836
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgKTLFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbgKTLF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616A9206E3;
        Fri, 20 Nov 2020 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870328;
        bh=fedrN5PMUtCfJkE/NZ8sOYVSYtL3qrSOxfaSH6DmO40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzX4Ktx4Ztpal0X7WPmyAj92PiOu2NZTBsRFej10ejN+o0hs2qjtTKU2xuGLg95JU
         QItYig8Id0DAFfq8O6jdWJ3mNIQy2dmBfi3+Z9/CRmn254vaMp71+adORAzQeVVjjW
         1v5DxqZImX/q8ajMct7uSSWWcfw+xumq547oC4Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 05/17] powerpc: Implement user_access_begin and friends
Date:   Fri, 20 Nov 2020 12:03:16 +0100
Message-Id: <20201120104540.675706459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 5cd623333e7cf4e3a334c70529268b65f2a6c2c7 upstream.

Today, when a function like strncpy_from_user() is called,
the userspace access protection is de-activated and re-activated
for every word read.

By implementing user_access_begin and friends, the protection
is de-activated at the beginning of the copy and re-activated at the
end.

Implement user_access_begin(), user_access_end() and
unsafe_get_user(), unsafe_put_user() and unsafe_copy_to_user()

For the time being, we keep user_access_save() and
user_access_restore() as nops.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/36d4fbf9e56a75994aca4ee2214c77b26a5a8d35.1579866752.git.christophe.leroy@c-s.fr
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/uaccess.h |   76 +++++++++++++++++++++++++++----------
 1 file changed, 57 insertions(+), 19 deletions(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -83,9 +83,14 @@
 	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
 #define __get_user(x, ptr) \
-	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)), true)
 #define __put_user(x, ptr) \
-	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)), true)
+
+#define __get_user_allowed(x, ptr) \
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)), false)
+#define __put_user_allowed(x, ptr) \
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)), false)
 
 #define __get_user_inatomic(x, ptr) \
 	__get_user_nosleep((x), (ptr), sizeof(*(ptr)))
@@ -130,10 +135,9 @@ extern long __put_user_bad(void);
 		: "r" (x), "b" (addr), "i" (-EFAULT), "0" (err))
 #endif /* __powerpc64__ */
 
-#define __put_user_size(x, ptr, size, retval)			\
+#define __put_user_size_allowed(x, ptr, size, retval)		\
 do {								\
 	retval = 0;						\
-	allow_write_to_user(ptr, size);				\
 	switch (size) {						\
 	  case 1: __put_user_asm(x, ptr, retval, "stb"); break;	\
 	  case 2: __put_user_asm(x, ptr, retval, "sth"); break;	\
@@ -141,17 +145,26 @@ do {								\
 	  case 8: __put_user_asm2(x, ptr, retval); break;	\
 	  default: __put_user_bad();				\
 	}							\
+} while (0)
+
+#define __put_user_size(x, ptr, size, retval)			\
+do {								\
+	allow_write_to_user(ptr, size);				\
+	__put_user_size_allowed(x, ptr, size, retval);		\
 	prevent_write_to_user(ptr, size);			\
 } while (0)
 
-#define __put_user_nocheck(x, ptr, size)			\
+#define __put_user_nocheck(x, ptr, size, do_allow)			\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
 	if (!is_kernel_addr((unsigned long)__pu_addr))		\
 		might_fault();					\
 	__chk_user_ptr(ptr);					\
-	__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	if (do_allow)								\
+		__put_user_size((x), __pu_addr, (size), __pu_err);		\
+	else									\
+		__put_user_size_allowed((x), __pu_addr, (size), __pu_err);	\
 	__pu_err;						\
 })
 
@@ -211,13 +224,12 @@ extern long __get_user_bad(void);
 		: "b" (addr), "i" (-EFAULT), "0" (err))
 #endif /* __powerpc64__ */
 
-#define __get_user_size(x, ptr, size, retval)			\
+#define __get_user_size_allowed(x, ptr, size, retval)		\
 do {								\
 	retval = 0;						\
 	__chk_user_ptr(ptr);					\
 	if (size > sizeof(x))					\
 		(x) = __get_user_bad();				\
-	allow_read_from_user(ptr, size);			\
 	switch (size) {						\
 	case 1: __get_user_asm(x, ptr, retval, "lbz"); break;	\
 	case 2: __get_user_asm(x, ptr, retval, "lhz"); break;	\
@@ -225,6 +237,12 @@ do {								\
 	case 8: __get_user_asm2(x, ptr, retval);  break;	\
 	default: (x) = __get_user_bad();			\
 	}							\
+} while (0)
+
+#define __get_user_size(x, ptr, size, retval)			\
+do {								\
+	allow_read_from_user(ptr, size);			\
+	__get_user_size_allowed(x, ptr, size, retval);		\
 	prevent_read_from_user(ptr, size);			\
 } while (0)
 
@@ -235,7 +253,7 @@ do {								\
 #define __long_type(x) \
 	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 
-#define __get_user_nocheck(x, ptr, size)			\
+#define __get_user_nocheck(x, ptr, size, do_allow)			\
 ({								\
 	long __gu_err;						\
 	__long_type(*(ptr)) __gu_val;				\
@@ -244,7 +262,10 @@ do {								\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
 	barrier_nospec();					\
-	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	if (do_allow)								\
+		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);		\
+	else									\
+		__get_user_size_allowed(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
@@ -331,33 +352,40 @@ static inline unsigned long raw_copy_fro
 	return ret;
 }
 
-static inline unsigned long raw_copy_to_user(void __user *to,
-		const void *from, unsigned long n)
+static inline unsigned long
+raw_copy_to_user_allowed(void __user *to, const void *from, unsigned long n)
 {
-	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		ret = 1;
+		unsigned long ret = 1;
 
 		switch (n) {
 		case 1:
-			__put_user_size(*(u8 *)from, (u8 __user *)to, 1, ret);
+			__put_user_size_allowed(*(u8 *)from, (u8 __user *)to, 1, ret);
 			break;
 		case 2:
-			__put_user_size(*(u16 *)from, (u16 __user *)to, 2, ret);
+			__put_user_size_allowed(*(u16 *)from, (u16 __user *)to, 2, ret);
 			break;
 		case 4:
-			__put_user_size(*(u32 *)from, (u32 __user *)to, 4, ret);
+			__put_user_size_allowed(*(u32 *)from, (u32 __user *)to, 4, ret);
 			break;
 		case 8:
-			__put_user_size(*(u64 *)from, (u64 __user *)to, 8, ret);
+			__put_user_size_allowed(*(u64 *)from, (u64 __user *)to, 8, ret);
 			break;
 		}
 		if (ret == 0)
 			return 0;
 	}
 
+	return __copy_tofrom_user(to, (__force const void __user *)from, n);
+}
+
+static inline unsigned long
+raw_copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	unsigned long ret;
+
 	allow_write_to_user(to, n);
-	ret = __copy_tofrom_user(to, (__force const void __user *)from, n);
+	ret = raw_copy_to_user_allowed(to, from, n);
 	prevent_write_to_user(to, n);
 	return ret;
 }
@@ -379,4 +407,14 @@ static inline unsigned long clear_user(v
 extern long strncpy_from_user(char *dst, const char __user *src, long count);
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+
+#define user_access_begin(type, ptr, len) access_ok(type, ptr, len)
+#define user_access_end()		  prevent_user_access(NULL, NULL, ~0ul)
+
+#define unsafe_op_wrap(op, err) do { if (unlikely(op)) goto err; } while (0)
+#define unsafe_get_user(x, p, e) unsafe_op_wrap(__get_user_allowed(x, p), e)
+#define unsafe_put_user(x, p, e) unsafe_op_wrap(__put_user_allowed(x, p), e)
+#define unsafe_copy_to_user(d, s, l, e) \
+	unsafe_op_wrap(raw_copy_to_user_allowed(d, s, l), e)
+
 #endif	/* _ARCH_POWERPC_UACCESS_H */


