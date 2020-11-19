Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17D62B9E9B
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgKSXmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgKSXmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:42:19 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66635C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:19 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 62so5672356pgg.12
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VsAH24nCwdbfXV7PNf9uLzvgtpdhVap5YSYEZ8o1DkQ=;
        b=JUP6DAFA8Z7iUTyCCWhGb7dCpaXufTGZQhTnIEZOvyDPjy1BnWgGa3Se/o05q2Gwma
         6/UKMp31i4mvHNTp5xgGIk1Jjnql4uXlwNdlLCx8ax3Un1Pe4C2CicUICFuaVHg46JtQ
         m+WP0P01p9G3632oHS1q5gm4RzfX8ggnnTMy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VsAH24nCwdbfXV7PNf9uLzvgtpdhVap5YSYEZ8o1DkQ=;
        b=diyl/Fx06ZwxdytTgMZyBVQBRHT6JJxaW84kaDxhe3qDctaFpKwAftGLkqEMSJeBe+
         5L7eycAPev2N1fbPg2jLmoUHsGbYjMOUeAh/2EjhUBC8DIvfzafmmH5viFHL9SrAbuU1
         BGmeLjFVKp4ioOPLufs64WKOlCDS9q+lLE75PVgEDz+N9lBALeDwKad/NBWk07UegvzH
         GeDyyVcAXLVIq9GqkT1dXLlIY3IYuHDe7sWygNhZFXxue/cff+oDzmhrkkWOUWUGiUAQ
         XWeg/T9IQZ7mZZUVYsyZxpPOYO/2T+rAV7nI3BApJd/M2GYs57Ob5MLVEnPwHMuzMYEW
         8W2g==
X-Gm-Message-State: AOAM5328RsAF2AYoSnFQJmF9bxHJPFdDeuZZ2YKnatvdxrpjRPDpNpAC
        4Nqkp5W9RbiHtM2wq/2ca7VRZjgwGacYqg==
X-Google-Smtp-Source: ABdhPJwW60zBW+fMlYuypDz2z9lWO/QfuZjbgQ7CM212Tczfrh7g7Ma4tAEjogkNrjLqSvt+oPJiig==
X-Received: by 2002:a65:608b:: with SMTP id t11mr14553411pgu.72.1605829338689;
        Thu, 19 Nov 2020 15:42:18 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id 203sm1088805pfw.116.2020.11.19.15.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:42:18 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.19 3/7] powerpc: Add a framework for user access tracking
Date:   Fri, 20 Nov 2020 10:41:59 +1100
Message-Id: <20201119234203.370400-4-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119234203.370400-1-dja@axtens.net>
References: <20201119234203.370400-1-dja@axtens.net>
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
 arch/powerpc/include/asm/kup.h       | 36 ++++++++++++++++++++++++++
 arch/powerpc/include/asm/uaccess.h   | 38 ++++++++++++++++++++++------
 arch/powerpc/lib/checksum_wrappers.c |  4 +++
 4 files changed, 74 insertions(+), 8 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kup.h

diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
index 2a7b01f97a56..1eabc20dddd3 100644
--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -35,6 +35,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 {
 	int oldval = 0, ret;
 
+	allow_write_to_user(uaddr, sizeof(*uaddr));
 	pagefault_disable();
 
 	switch (op) {
@@ -61,6 +62,7 @@ static inline int arch_futex_atomic_op_inuser(int op, int oparg, int *oval,
 
 	*oval = oldval;
 
+	prevent_write_to_user(uaddr, sizeof(*uaddr));
 	return ret;
 }
 
@@ -74,6 +76,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	allow_write_to_user(uaddr, sizeof(*uaddr));
         __asm__ __volatile__ (
         PPC_ATOMIC_ENTRY_BARRIER
 "1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
@@ -94,6 +97,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
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
index 38a25ff8afb7..b604bb140a30 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/extable.h>
+#include <asm/kup.h>
 
 /*
  * The fs value determines whether argument validity checking should be
@@ -141,6 +142,7 @@ extern long __put_user_bad(void);
 #define __put_user_size(x, ptr, size, retval)			\
 do {								\
 	retval = 0;						\
+	allow_write_to_user(ptr, size);				\
 	switch (size) {						\
 	  case 1: __put_user_asm(x, ptr, retval, "stb"); break;	\
 	  case 2: __put_user_asm(x, ptr, retval, "sth"); break;	\
@@ -148,6 +150,7 @@ do {								\
 	  case 8: __put_user_asm2(x, ptr, retval); break;	\
 	  default: __put_user_bad();				\
 	}							\
+	prevent_write_to_user(ptr, size);			\
 } while (0)
 
 #define __put_user_nocheck(x, ptr, size)			\
@@ -240,6 +243,7 @@ do {								\
 	__chk_user_ptr(ptr);					\
 	if (size > sizeof(x))					\
 		(x) = __get_user_bad();				\
+	allow_read_from_user(ptr, size);			\
 	switch (size) {						\
 	case 1: __get_user_asm(x, ptr, retval, "lbz"); break;	\
 	case 2: __get_user_asm(x, ptr, retval, "lhz"); break;	\
@@ -247,6 +251,7 @@ do {								\
 	case 8: __get_user_asm2(x, ptr, retval);  break;	\
 	default: (x) = __get_user_bad();			\
 	}							\
+	prevent_read_from_user(ptr, size);			\
 } while (0)
 
 /*
@@ -306,16 +311,22 @@ extern unsigned long __copy_tofrom_user(void __user *to,
 static inline unsigned long
 raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
+	unsigned long ret;
+
 	barrier_nospec();
-	return __copy_tofrom_user(to, from, n);
+	allow_user_access(to, from, n);
+	ret = __copy_tofrom_user(to, from, n);
+	prevent_user_access(to, from, n);
+	return ret;
 }
 #endif /* __powerpc64__ */
 
 static inline unsigned long raw_copy_from_user(void *to,
 		const void __user *from, unsigned long n)
 {
+	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		unsigned long ret = 1;
+		ret = 1;
 
 		switch (n) {
 		case 1:
@@ -340,14 +351,18 @@ static inline unsigned long raw_copy_from_user(void *to,
 	}
 
 	barrier_nospec();
-	return __copy_tofrom_user((__force void __user *)to, from, n);
+	allow_read_from_user(from, n);
+	ret = __copy_tofrom_user((__force void __user *)to, from, n);
+	prevent_read_from_user(from, n);
+	return ret;
 }
 
 static inline unsigned long raw_copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
+	unsigned long ret;
 	if (__builtin_constant_p(n) && (n <= 8)) {
-		unsigned long ret = 1;
+		ret = 1;
 
 		switch (n) {
 		case 1:
@@ -367,17 +382,24 @@ static inline unsigned long raw_copy_to_user(void __user *to,
 			return 0;
 	}
 
-	return __copy_tofrom_user(to, (__force const void __user *)from, n);
+	allow_write_to_user(to, n);
+	ret = __copy_tofrom_user(to, (__force const void __user *)from, n);
+	prevent_write_to_user(to, n);
+	return ret;
 }
 
 extern unsigned long __clear_user(void __user *addr, unsigned long size);
 
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
index a0cb63fb76a1..8d83c39be7e4 100644
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

