Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C481812EC34
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgABWQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbgABWQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE8ED21582;
        Thu,  2 Jan 2020 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003380;
        bh=P9zYL2IjlJKQhbkr4O2SVoC2nzZza+pLAq77UjV2kn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dm5vCe0nA05XBME4DOcLVOHwxB1aaJLKG6SZ3VPQlWMLVa9255wLbQFjJe/+JtK1Z
         ilRZiIngD0wYE3e+JeF8VohF1YEhILSjfB8BeLf8n0GUqIqYszrJYatnTqFZmQP7ga
         H5JuZ5bceoSYlih/6LZWNeLFFqUbUx9V/+Ba6NQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f25ecf4b2982d8c7a640@syzkaller-ppc64.appspotmail.com,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 5.4 136/191] powerpc: Fix __clear_user() with KUAP enabled
Date:   Thu,  2 Jan 2020 23:06:58 +0100
Message-Id: <20200102215844.202313478@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/uaccess.h |    9 +++++++--
 arch/powerpc/lib/string_32.S       |    4 ++--
 arch/powerpc/lib/string_64.S       |    6 +++---
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -401,7 +401,7 @@ copy_to_user_mcsafe(void __user *to, con
 	return n;
 }
 
-extern unsigned long __clear_user(void __user *addr, unsigned long size);
+unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
@@ -409,12 +409,17 @@ static inline unsigned long clear_user(v
 	might_fault();
 	if (likely(access_ok(addr, size))) {
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
 extern __must_check long strnlen_user(const char __user *str, long n);
 
--- a/arch/powerpc/lib/string_32.S
+++ b/arch/powerpc/lib/string_32.S
@@ -17,7 +17,7 @@ CACHELINE_BYTES = L1_CACHE_BYTES
 LG_CACHELINE_BYTES = L1_CACHE_SHIFT
 CACHELINE_MASK = (L1_CACHE_BYTES-1)
 
-_GLOBAL(__clear_user)
+_GLOBAL(__arch_clear_user)
 /*
  * Use dcbz on the complete cache lines in the destination
  * to set them to zero.  This requires that the destination
@@ -87,4 +87,4 @@ _GLOBAL(__clear_user)
 	EX_TABLE(8b, 91b)
 	EX_TABLE(9b, 91b)
 
-EXPORT_SYMBOL(__clear_user)
+EXPORT_SYMBOL(__arch_clear_user)
--- a/arch/powerpc/lib/string_64.S
+++ b/arch/powerpc/lib/string_64.S
@@ -17,7 +17,7 @@ PPC64_CACHES:
 	.section	".text"
 
 /**
- * __clear_user: - Zero a block of memory in user space, with less checking.
+ * __arch_clear_user: - Zero a block of memory in user space, with less checking.
  * @to:   Destination address, in user space.
  * @n:    Number of bytes to zero.
  *
@@ -58,7 +58,7 @@ err3;	stb	r0,0(r3)
 	mr	r3,r4
 	blr
 
-_GLOBAL_TOC(__clear_user)
+_GLOBAL_TOC(__arch_clear_user)
 	cmpdi	r4,32
 	neg	r6,r3
 	li	r0,0
@@ -181,4 +181,4 @@ err1;	dcbz	0,r3
 	cmpdi	r4,32
 	blt	.Lshort_clear
 	b	.Lmedium_clear
-EXPORT_SYMBOL(__clear_user)
+EXPORT_SYMBOL(__arch_clear_user)


