Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA4D2BA7ED
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgKTLDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTLDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:03:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AAD52222F;
        Fri, 20 Nov 2020 11:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870211;
        bh=qjPwQyoO1sivJ/OQeQhF7DOYuY0uN2zl82LFqxeiZ5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN6H6JZEto2duZbVF1cUH4+dQGnIWsC7gMzvuCkye4dRIE2BvXKT3waBCK1jLrQJv
         KVnrtJbiSbOfQgp7l84CTd/HDYtxTJYlDm2Tiveawy1Y0UznLdqiG7qACILrjqlDFl
         7/8/hSpvOTHv1UNaGwlGtiE3UYGTh284D2GQiA3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        syzbot+f25ecf4b2982d8c7a640@syzkaller-ppc64.appspotmail.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.4 06/15] powerpc: Fix __clear_user() with KUAP enabled
Date:   Fri, 20 Nov 2020 12:03:04 +0100
Message-Id: <20201120104539.864061299@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Donnellan <ajd@linux.ibm.com>

commit 61e3acd8c693a14fc69b824cb5b08d02cb90a6e7 upstream.

The KUAP implementation adds calls in clear_user() to enable and
disable access to userspace memory. However, it doesn't add these to
__clear_user(), which is used in the ptrace regset code.

As there's only one direct user of __clear_user() (the regset code),
and the time taken to set the AMR for KUAP purposes is going to
dominate the cost of a quick access_ok(), there's not much point
having a separate path.

Rename __clear_user() to __arch_clear_user(), and make __clear_user()
just call clear_user().

Reported-by: syzbot+f25ecf4b2982d8c7a640@syzkaller-ppc64.appspotmail.com
Reported-by: Daniel Axtens <dja@axtens.net>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: de78a9c42a79 ("powerpc: Add a framework for Kernel Userspace Access Protection")
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
[mpe: Use __arch_clear_user() for the asm version like arm64 & nds32]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191209132221.15328-1-ajd@linux.ibm.com
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/uaccess.h |    9 +++++++--
 arch/powerpc/kernel/ppc_ksyms.c    |    3 +++
 arch/powerpc/lib/string.S          |    2 +-
 arch/powerpc/lib/string_64.S       |    4 ++--
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -471,7 +471,7 @@ static inline unsigned long __copy_to_us
 	return __copy_to_user_inatomic(to, from, size);
 }
 
-extern unsigned long __clear_user(void __user *addr, unsigned long size);
+unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
@@ -479,12 +479,17 @@ static inline unsigned long clear_user(v
 	might_fault();
 	if (likely(access_ok(VERIFY_WRITE, addr, size))) {
 		allow_write_to_user(addr, size);
-		ret = __clear_user(addr, size);
+		ret = __arch_clear_user(addr, size);
 		prevent_write_to_user(addr, size);
 	}
 	return ret;
 }
 
+static inline unsigned long __clear_user(void __user *addr, unsigned long size)
+{
+	return clear_user(addr, size);
+}
+
 extern long strncpy_from_user(char *dst, const char __user *src, long count);
 extern __must_check long strlen_user(const char __user *str);
 extern __must_check long strnlen_user(const char __user *str, long n);
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -5,6 +5,7 @@
 #include <asm/switch_to.h>
 #include <asm/cacheflush.h>
 #include <asm/epapr_hcalls.h>
+#include <asm/uaccess.h>
 
 EXPORT_SYMBOL(flush_dcache_range);
 EXPORT_SYMBOL(flush_icache_range);
@@ -43,3 +44,5 @@ EXPORT_SYMBOL(epapr_hypercall_start);
 #endif
 
 EXPORT_SYMBOL(current_stack_pointer);
+
+EXPORT_SYMBOL(__arch_clear_user);
--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -122,7 +122,7 @@ _GLOBAL(memchr)
 	blr
 
 #ifdef CONFIG_PPC32
-_GLOBAL(__clear_user)
+_GLOBAL(__arch_clear_user)
 	addi	r6,r3,-4
 	li	r3,0
 	li	r5,0
--- a/arch/powerpc/lib/string_64.S
+++ b/arch/powerpc/lib/string_64.S
@@ -27,7 +27,7 @@ PPC64_CACHES:
 	.section	".text"
 
 /**
- * __clear_user: - Zero a block of memory in user space, with less checking.
+ * __arch_clear_user: - Zero a block of memory in user space, with less checking.
  * @to:   Destination address, in user space.
  * @n:    Number of bytes to zero.
  *
@@ -77,7 +77,7 @@ err3;	stb	r0,0(r3)
 	mr	r3,r4
 	blr
 
-_GLOBAL_TOC(__clear_user)
+_GLOBAL_TOC(__arch_clear_user)
 	cmpdi	r4,32
 	neg	r6,r3
 	li	r0,0


