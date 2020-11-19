Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F92B9EEF
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgKSX6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgKSX6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:58:02 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312C4C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:02 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j19so5704925pgg.5
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kbTGqy8jF+pkIJv91OTGvsFywbVjaRoFlBY2ACHNNzM=;
        b=hbzc5yW7LBZJMx9GIhybXwxVi9tP11eUQfg/M4W5vmYWpg0YtAFn9dAXEV1rXgYWur
         ZlLYJsRbGEC73UM04Mbc1/4jK4cdvAcnUkHR50csfY/bRKCTWP5R2ULgJcKHkmArHC2t
         mKKm8WzVJt9R8wh+WvJF8QMVHRuCWFYV8yST8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbTGqy8jF+pkIJv91OTGvsFywbVjaRoFlBY2ACHNNzM=;
        b=Eb509VchHDYcjgA7eNuA5ZfsNopSjAjK81iT5d8jfjzhQbjJ+GwEEzDo+/4W/Iv/zg
         pJzoQ9VRLVc85QfEv2p4ycPRLDibDNJ9row5Uf0llXe+LhUlPz9daDCpuvDAF+QuAQYd
         Y380k+IK90Sqf4FkM1zpWLaHpZXFtOJnmwP7Z2N3T2dQAWFIewBEOeZGiyAaJwWqhovi
         hiVcRtE/22yJL+6sxXg9OgKO1yD50O1eygRoat6vfgM4kRuMlxZXMP8Bapad1db02PYV
         QwFxd5Tbo1XU0jV1touY0VqVr6QMOFKNHTA70aub1sPlVkTWvxhqB9Y+VzCBNOmIZOcf
         g6Cw==
X-Gm-Message-State: AOAM530ovVS0MZYVEFvWfHuZQ7vTWWDfp0Q5vRSO34jjuIn9IjYLJQOn
        Ghgd7XeJdL/C3Idcvb3VnwC1toXfsVAfoQ==
X-Google-Smtp-Source: ABdhPJwAEQUG+nP6gO2/ZRAZ0Yt/mr1qPvCp9lEdjA36G2DwRAcE2B3OvrWtlPcVrGmDF5gIPIgisQ==
X-Received: by 2002:a62:828b:0:b029:18b:d8ec:6438 with SMTP id w133-20020a62828b0000b029018bd8ec6438mr11317528pfd.38.1605830281374;
        Thu, 19 Nov 2020 15:58:01 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id l9sm972591pjy.10.2020.11.19.15.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:58:00 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 4/8] powerpc: Add a framework for user access tracking
Date:   Fri, 20 Nov 2020 10:57:39 +1100
Message-Id: <20201119235743.373635-5-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235743.373635-1-dja@axtens.net>
References: <20201119235743.373635-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

Backported from commit de78a9c42a79 ("powerpc: Add a framework
for Kernel Userspace Access Protection"). Here we don't try to
add the KUAP framework, we just want the helper functions
because we want to put uaccess flush helpers in them.

In terms of fixes, we don't need commit 1d8f739b07bd ("powerpc/kuap:
Fix set direction in allow/prevent_user_access()") as we don't have
real KUAP. Likewise as all our allows are noops and all our prevents
are just flushes, we don't need commit 9dc086f1e9ef ("powerpc/futex:
Fix incorrect user access blocking") The other 2 fixes we do need.

The original description is:

This patch implements a framework for Kernel Userspace Access
Protection.

Then subarches will have the possibility to provide their own
implementation by providing setup_kuap() and
allow/prevent_user_access().

Some platforms will need to know the area accessed and whether it is
accessed from read, write or both. Therefore source, destination and
size and handed over to the two functions.

mpe: Rename to allow/prevent rather than unlock/lock, and add
read/write wrappers. Drop the 32-bit code for now until we have an
implementation for it. Add kuap to pt_regs for 64-bit as well as
32-bit. Don't split strings, use pr_crit_ratelimited().

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/include/asm/futex.h     |  4 +++
 arch/powerpc/include/asm/kup.h       | 36 +++++++++++++++++++++++++
 arch/powerpc/include/asm/uaccess.h   | 39 +++++++++++++++++++++-------
 arch/powerpc/lib/checksum_wrappers.c |  4 +++
 4 files changed, 74 insertions(+), 9 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kup.h

diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
index b73ab8a7ebc3..10746519b351 100644
--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -36,6 +36,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 {
 	int oldval = 0, ret;
 
+	allow_write_to_user(uaddr, sizeof(*uaddr));
 	pagefault_disable();
 
 	switch (op) {
@@ -62,6 +63,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 
 	*oval = oldval;
 
+	prevent_write_to_user(uaddr, sizeof(*uaddr));
 	return ret;
 }
 
@@ -75,6 +77,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	allow_write_to_user(uaddr, sizeof(*uaddr));
         __asm__ __volatile__ (
         PPC_ATOMIC_ENTRY_BARRIER
 "1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
@@ -97,6 +100,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
         : "cc", "memory");
 
 	*uval = prev;
+	prevent_write_to_user(uaddr, sizeof(*uaddr));
         return ret;
 }
 
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
new file mode 100644
index 000000000000..7895d5eeaf21
--- /dev/null
+++ b/arch/powerpc/include/asm/kup.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_KUP_H_
+#define _ASM_POWERPC_KUP_H_
+
+#ifndef __ASSEMBLY__
+
+#include <asm/pgtable.h>
+
+static inline void allow_user_access(void __user *to, const void __user *from,
+				     unsigned long size) { }
+static inline void prevent_user_access(void __user *to, const void __user *from,
+				       unsigned long size) { }
+
+static inline void allow_read_from_user(const void __user *from, unsigned long size)
+{
+	allow_user_access(NULL, from, size);
+}
+
+static inline void allow_write_to_user(void __user *to, unsigned long size)
+{
+	allow_user_access(to, NULL, size);
+}
+
+static inline void prevent_read_from_user(const void __user *from, unsigned long size)
+{
+	prevent_user_access(NULL, from, size);
+}
+
+static inline void prevent_write_to_user(void __user *to, unsigned long size)
+{
+	prevent_user_access(to, NULL, size);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_POWERPC_KUP_H_ */
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index da852153c1f8..9521028eebfa 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -9,6 +9,7 @@
 #include <asm/asm-compat.h>
 #include <asm/processor.h>
 #include <asm/page.h>
+#include <asm/kup.h>
 
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
@@ -164,6 +165,7 @@ extern long __put_user_bad(void);
 #define __put_user_size(x, ptr, size, retval)			\
 do {								\
 	retval = 0;						\
+	allow_write_to_user(ptr, size);				\
 	switch (size) {						\
 	  case 1: __put_user_asm(x, ptr, retval, "stb"); break;	\
 	  case 2: __put_user_asm(x, ptr, retval, "sth"); break;	\
@@ -171,6 +173,7 @@ do {								\
 	  case 8: __put_user_asm2(x, ptr, retval); break;	\
 	  default: __put_user_bad();				\
 	}							\
+	prevent_write_to_user(ptr, size);			\
 } while (0)
 
 #define __put_user_nocheck(x, ptr, size)			\
@@ -252,6 +255,7 @@ do {								\
 	__chk_user_ptr(ptr);					\
 	if (size > sizeof(x))					\
 		(x) = __get_user_bad();				\
+	allow_read_from_user(ptr, size);			\
 	switch (size) {						\
 	case 1: __get_user_asm(x, ptr, retval, "lbz"); break;	\
 	case 2: __get_user_asm(x, ptr, retval, "lhz"); break;	\
@@ -259,6 +263,7 @@ do {								\
 	case 8: __get_user_asm2(x, ptr, retval);  break;	\
 	default: (x) = __get_user_bad();			\
 	}							\
+	prevent_read_from_user(ptr, size);			\
 } while (0)
 
 #define __get_user_nocheck(x, ptr, size)			\
@@ -312,9 +317,14 @@ extern unsigned long __copy_tofrom_user(void __user *to,
 static inline unsigned long copy_from_user(void *to,
 		const void __user *from, unsigned long n)
 {
+	unsigned long ret;
+
 	if (likely(access_ok(VERIFY_READ, from, n))) {
 		check_object_size(to, n, false);
-		return __copy_tofrom_user((__force void __user *)to, from, n);
+		allow_user_access(to, from, n);
+		ret = __copy_tofrom_user((__force void __user *)to, from, n);
+		prevent_user_access(to, from, n);
+		return ret;
 	}
 	memset(to, 0, n);
 	return n;
@@ -347,8 +357,9 @@ extern unsigned long copy_in_user(void __user *to, const void __user *from,
 static inline unsigned long __copy_from_user_inatomic(void *to,
 		const void __user *from, unsigned long n)
 {
+	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		unsigned long ret = 1;
+		ret = 1;
 
 		switch (n) {
 		case 1:
@@ -375,14 +386,18 @@ static inline unsigned long __copy_from_user_inatomic(void *to,
 	check_object_size(to, n, false);
 
 	barrier_nospec();
-	return __copy_tofrom_user((__force void __user *)to, from, n);
+	allow_read_from_user(from, n);
+	ret = __copy_tofrom_user((__force void __user *)to, from, n);
+	prevent_read_from_user(from, n);
+	return ret;
 }
 
 static inline unsigned long __copy_to_user_inatomic(void __user *to,
 		const void *from, unsigned long n)
 {
+	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		unsigned long ret = 1;
+		ret = 1;
 
 		switch (n) {
 		case 1:
@@ -403,8 +418,10 @@ static inline unsigned long __copy_to_user_inatomic(void __user *to,
 	}
 
 	check_object_size(from, n, true);
-
-	return __copy_tofrom_user(to, (__force const void __user *)from, n);
+	allow_write_to_user(to, n);
+	ret = __copy_tofrom_user(to, (__force const void __user *)from, n);
+	prevent_write_to_user(to, n);
+	return ret;
 }
 
 static inline unsigned long __copy_from_user(void *to,
@@ -425,10 +442,14 @@ extern unsigned long __clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
+	unsigned long ret = size;
 	might_fault();
-	if (likely(access_ok(VERIFY_WRITE, addr, size)))
-		return __clear_user(addr, size);
-	return size;
+	if (likely(access_ok(VERIFY_WRITE, addr, size))) {
+		allow_write_to_user(addr, size);
+		ret = __clear_user(addr, size);
+		prevent_write_to_user(addr, size);
+	}
+	return ret;
 }
 
 extern long strncpy_from_user(char *dst, const char __user *src, long count);
diff --git a/arch/powerpc/lib/checksum_wrappers.c b/arch/powerpc/lib/checksum_wrappers.c
index 08e3a3356c40..11b58949eb62 100644
--- a/arch/powerpc/lib/checksum_wrappers.c
+++ b/arch/powerpc/lib/checksum_wrappers.c
@@ -29,6 +29,7 @@ __wsum csum_and_copy_from_user(const void __user *src, void *dst,
 	unsigned int csum;
 
 	might_sleep();
+	allow_read_from_user(src, len);
 
 	*err_ptr = 0;
 
@@ -60,6 +61,7 @@ __wsum csum_and_copy_from_user(const void __user *src, void *dst,
 	}
 
 out:
+	prevent_read_from_user(src, len);
 	return (__force __wsum)csum;
 }
 EXPORT_SYMBOL(csum_and_copy_from_user);
@@ -70,6 +72,7 @@ __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
 	unsigned int csum;
 
 	might_sleep();
+	allow_write_to_user(dst, len);
 
 	*err_ptr = 0;
 
@@ -97,6 +100,7 @@ __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
 	}
 
 out:
+	prevent_write_to_user(dst, len);
 	return (__force __wsum)csum;
 }
 EXPORT_SYMBOL(csum_and_copy_to_user);
-- 
2.25.1

