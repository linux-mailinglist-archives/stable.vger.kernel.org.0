Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DCC2B9EB5
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgKSXxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKSXxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:53:09 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BEDC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:53:08 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id v5so2035792pff.10
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1KKTCa+MnnuFlnnES4VgVAqb5G8ahj/pCQWAXIcfb+8=;
        b=Exy2EIqGXsqFt54gIq3a59LDkjtkHTRtztiuR0c4UDnRPnTMo+Q1627zKzkpbunla5
         dza1x6JajDIIqYa8mF8yJVl875PTY0Ws7gHYLXMIa1DsDuZS+GxQ/oKP+q+ailOYboJL
         qNUTYQbwUAz89t4GkZWGSEgmbd90SsE0L/JGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1KKTCa+MnnuFlnnES4VgVAqb5G8ahj/pCQWAXIcfb+8=;
        b=MCAO8f+RW69YLStEiwIB/dObQKafwnK8K3/D3tkP4R+4SdGPRrXDrUFXxX/HOlYOhA
         0spssUoqkt7+FVNBL+YAjW///F47I9UChGcoH2MRyh6r2wsUBP6Wry8EMA75F+upt7sl
         BM4RXPrMokV9uPQ4g9FoZzYcoXpjBJU4nze76cFNbTI8e0y4LIa1N8Zx6ppY5D+BNRAB
         1aJmoH/QmjDGMeHJeGdDmF66dFxls48GrWICuL9kZT1MJKlq6QdFv/wbhzzRqXCLVM5n
         9WMXduEZRf4UYefx+Wg0m4n/wYFx/CR38MvBGlWb7bNWhcwVcNY3fG3gvGF0RdVI6T9D
         QGmg==
X-Gm-Message-State: AOAM530kSd0EWDdGtzuolDuQoUNNQwaRHguPdOfmOM1oS2AUwvf4o/YZ
        cm0tXd4hTJkYiphq3BYYxHEqSoBdMZx5CA==
X-Google-Smtp-Source: ABdhPJwLXII5ZNUcTu/ncr49ZlI1Q3xytiY3bWiq7wC+pS/aaM8ywuLh3DM1vSYzU2VKEOaCueq3wQ==
X-Received: by 2002:a62:293:0:b029:197:96c2:bef6 with SMTP id 141-20020a6202930000b029019796c2bef6mr8131141pfc.62.1605829988235;
        Thu, 19 Nov 2020 15:53:08 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id c8sm1000908pjd.13.2020.11.19.15.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:53:07 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.14 5/8] powerpc: Implement user_access_begin and friends
Date:   Fri, 20 Nov 2020 10:52:41 +1100
Message-Id: <20201119235244.373127-6-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235244.373127-1-dja@axtens.net>
References: <20201119235244.373127-1-dja@axtens.net>
MIME-Version: 1.0
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
---
 arch/powerpc/include/asm/uaccess.h | 76 ++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index f07528ba5b52..f5a56f103197 100644
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
@@ -331,33 +352,40 @@ static inline unsigned long raw_copy_from_user(void *to,
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
@@ -379,4 +407,14 @@ static inline unsigned long clear_user(void __user *addr, unsigned long size)
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
-- 
2.25.1

