Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10FD2B9EB4
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKSXxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKSXxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:53:04 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6DC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:53:04 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b63so6060820pfg.12
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NAVGBVBne1H/frJQYxiNaO9h8BpIPF5Kruh+CggtOp8=;
        b=mfszcpAf8CTKT9FfP6AyUnEkj/cMkVHnimbU2hblnFE2wYdr4jc9Pe8nVnQrRA213Y
         5fJO3sWD+yJ9y7cibKrNQafOW+pJeIkqj4HMghVQfWs6tsDYOXRvgiJsAxrf7JOpmR/y
         1jmMuM2XO+AUWjx5+8MNWgDZXTXFNW9gW2ZOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NAVGBVBne1H/frJQYxiNaO9h8BpIPF5Kruh+CggtOp8=;
        b=Bg93kkGnodvU0NkISM/oPsjdgfkbdNiiSjs40zIp2uOGHlDQvrFegG1K6CTZtSCAyA
         sekf9mkWxBLSGijfIeSJg+9dAVbU9DC15tcnPuwvz7RdRCUgOM3ZvcP7aUPWwdK0vq2T
         9D6p7K8j8KF2uNcrApIvcbaa+zh9pezKlvYOWfB0TS0PPzVIU1+n2wgW5avdePNNVwtl
         bgu1Acx5uVZ/3cnarsD85BH8kb3L3p2OslNF0wHHp6cTb9hARvr+3iPG7dfwY9yKNMU8
         Z3gllnzWF0dTg6ZM4gzFEWmXrk2X0GQnLXZAaUpwc3f/+/Gr/ANwSztrT0R2ng1OBSn2
         IUoA==
X-Gm-Message-State: AOAM530wANgU8V7X5gtZaPtILII0QOMO8lS3wZFzYqS+SFRN0aJnsXJb
        LlhwR89phl0J1ECEhu1qI5H9QjdFLmWzqQ==
X-Google-Smtp-Source: ABdhPJxp3RcRxv+ODZ33OIIg/Mg6JVS0zRDODmR7tCwNa5Y2uq2vTxyvvR4zkAsWPLjES0YlhIuBjQ==
X-Received: by 2002:a17:90b:a02:: with SMTP id gg2mr2560350pjb.225.1605829983991;
        Thu, 19 Nov 2020 15:53:03 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id r8sm1114782pfq.197.2020.11.19.15.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:53:03 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.14 4/8] powerpc: Add a framework for user access tracking
Date:   Fri, 20 Nov 2020 10:52:40 +1100
Message-Id: <20201119235244.373127-5-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235244.373127-1-dja@axtens.net>
References: <20201119235244.373127-1-dja@axtens.net>
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
index 3c7d85945229..cbcb97c43d82 100644
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
index 3865d1d23597..f07528ba5b52 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -7,6 +7,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/extable.h>
+#include <asm/kup.h>
 
 /*
  * The fs value determines whether argument validity checking should be
@@ -132,6 +133,7 @@ extern long __put_user_bad(void);
 #define __put_user_size(x, ptr, size, retval)			\
 do {								\
 	retval = 0;						\
+	allow_write_to_user(ptr, size);				\
 	switch (size) {						\
 	  case 1: __put_user_asm(x, ptr, retval, "stb"); break;	\
 	  case 2: __put_user_asm(x, ptr, retval, "sth"); break;	\
@@ -139,6 +141,7 @@ do {								\
 	  case 8: __put_user_asm2(x, ptr, retval); break;	\
 	  default: __put_user_bad();				\
 	}							\
+	prevent_write_to_user(ptr, size);			\
 } while (0)
 
 #define __put_user_nocheck(x, ptr, size)			\
@@ -214,6 +217,7 @@ do {								\
 	__chk_user_ptr(ptr);					\
 	if (size > sizeof(x))					\
 		(x) = __get_user_bad();				\
+	allow_read_from_user(ptr, size);			\
 	switch (size) {						\
 	case 1: __get_user_asm(x, ptr, retval, "lbz"); break;	\
 	case 2: __get_user_asm(x, ptr, retval, "lhz"); break;	\
@@ -221,6 +225,7 @@ do {								\
 	case 8: __get_user_asm2(x, ptr, retval);  break;	\
 	default: (x) = __get_user_bad();			\
 	}							\
+	prevent_read_from_user(ptr, size);			\
 } while (0)
 
 /*
@@ -280,16 +285,22 @@ extern unsigned long __copy_tofrom_user(void __user *to,
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
@@ -314,14 +325,18 @@ static inline unsigned long raw_copy_from_user(void *to,
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
@@ -341,17 +356,24 @@ static inline unsigned long raw_copy_to_user(void __user *to,
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

