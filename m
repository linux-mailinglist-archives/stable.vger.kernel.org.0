Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C39F2BA8B3
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgKTLF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgKTLF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BD2522264;
        Fri, 20 Nov 2020 11:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870355;
        bh=a2S5f+/gJhqZULooZzR6kzvghA0pOSK0Gc0wiMf5Xe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZCVjaiMv2/1+oAmdqONRENOuPqhCN7JSy9FsYICXU9sLFvr4XTsKyUxCat07/N+d
         cRnVd8+uvNSWYdmWMjUWyvvfQvyxC6Slq+U8s4vAtkXvChnzfh3H3oMiA47ZQJdGR6
         cU9krK5UQ87Wc83RS0WxM7L1raDKU1+9N1a2zLes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 03/14] powerpc: Add a framework for user access tracking
Date:   Fri, 20 Nov 2020 12:03:24 +0100
Message-Id: <20201120104539.969777163@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
References: <20201120104539.806156260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/futex.h     |    4 +++
 arch/powerpc/include/asm/kup.h       |   36 +++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/uaccess.h   |   38 +++++++++++++++++++++++++++--------
 arch/powerpc/lib/checksum_wrappers.c |    4 +++
 4 files changed, 74 insertions(+), 8 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kup.h

--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -35,6 +35,7 @@ static inline int arch_futex_atomic_op_i
 {
 	int oldval = 0, ret;
 
+	allow_write_to_user(uaddr, sizeof(*uaddr));
 	pagefault_disable();
 
 	switch (op) {
@@ -61,6 +62,7 @@ static inline int arch_futex_atomic_op_i
 
 	*oval = oldval;
 
+	prevent_write_to_user(uaddr, sizeof(*uaddr));
 	return ret;
 }
 
@@ -74,6 +76,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	allow_write_to_user(uaddr, sizeof(*uaddr));
         __asm__ __volatile__ (
         PPC_ATOMIC_ENTRY_BARRIER
 "1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
@@ -94,6 +97,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
         : "cc", "memory");
 
 	*uval = prev;
+	prevent_write_to_user(uaddr, sizeof(*uaddr));
         return ret;
 }
 
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
@@ -306,16 +311,22 @@ extern unsigned long __copy_tofrom_user(
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
@@ -340,14 +351,18 @@ static inline unsigned long raw_copy_fro
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
@@ -367,17 +382,24 @@ static inline unsigned long raw_copy_to_
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
--- a/arch/powerpc/lib/checksum_wrappers.c
+++ b/arch/powerpc/lib/checksum_wrappers.c
@@ -29,6 +29,7 @@ __wsum csum_and_copy_from_user(const voi
 	unsigned int csum;
 
 	might_sleep();
+	allow_read_from_user(src, len);
 
 	*err_ptr = 0;
 
@@ -60,6 +61,7 @@ __wsum csum_and_copy_from_user(const voi
 	}
 
 out:
+	prevent_read_from_user(src, len);
 	return (__force __wsum)csum;
 }
 EXPORT_SYMBOL(csum_and_copy_from_user);
@@ -70,6 +72,7 @@ __wsum csum_and_copy_to_user(const void
 	unsigned int csum;
 
 	might_sleep();
+	allow_write_to_user(dst, len);
 
 	*err_ptr = 0;
 
@@ -97,6 +100,7 @@ __wsum csum_and_copy_to_user(const void
 	}
 
 out:
+	prevent_write_to_user(dst, len);
 	return (__force __wsum)csum;
 }
 EXPORT_SYMBOL(csum_and_copy_to_user);


