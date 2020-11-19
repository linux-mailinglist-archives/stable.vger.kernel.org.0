Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC252B9EB7
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgKSXxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgKSXxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:53:14 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C346C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:53:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q5so6083768pfk.6
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WdJTyDtre4qZBSWjv4bPJBYuF4c610K3523Sy2wX22g=;
        b=M97HH+tRHN3hsWJkHUi4MjOPg1vHEu774dJtyeBCcJa+rk+nxLIyh4Utm/Kdot6mzw
         UeXqHKWfdeWUNLazzywfwamj370mKefew4/bTIC8fYA5utLa+sGPBs9iBu7AZh8uONci
         1DXB80gRURHnwprb2ZG8tjY/JVHTVbA2U4BLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WdJTyDtre4qZBSWjv4bPJBYuF4c610K3523Sy2wX22g=;
        b=aNMQ+s7uWq3I7gBGfPYldG1cLj5iUjdcHnGtdQsJX7ck/0IuhU6cxH50jM4RNrlJhk
         X5sSv8vm7hEW8BiWHUhBn/l6sx39yPqvvjIkNwVZ6jqOWsc1oJRBmCz5KwmLZpdNUA5T
         erGW8DtTaNxnCR/TxnDKt7FOzZe/iT2d+t0KsqODPXcAAatdGJLridMYjb/EfRA7khzt
         oleh4XmwIBZnEkd5dBFQCxTRaYwcy2DPn+AiGJcmhZ+mBBZmSKfDjrY8B+RG535IrM6X
         WM3GujnvdC93Ean2zlgIk5upsfGgaxvfHi0nhqXQkJMcpqjV1u0Tgein03uOEeVNUbTZ
         QOtw==
X-Gm-Message-State: AOAM532ELkzmy05ch/Wn7wSrrSRkPWN4skwumiGmltol3hkm/PSZrowi
        95s7Ut6yWTYy8KCHfYa/TCJppNsmi8uuAg==
X-Google-Smtp-Source: ABdhPJy+84WmxjHQ4P7mV7F4wQJ7dU5dD3wD5ZM3/2PVdiK/c8bTO+CdFR72dpwYJqwZR7WykCNjzA==
X-Received: by 2002:a63:585e:: with SMTP id i30mr6861257pgm.160.1605829992322;
        Thu, 19 Nov 2020 15:53:12 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id h3sm1047268pfo.170.2020.11.19.15.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:53:11 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.14 6/8] powerpc: Fix __clear_user() with KUAP enabled
Date:   Fri, 20 Nov 2020 10:52:42 +1100
Message-Id: <20201119235244.373127-7-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235244.373127-1-dja@axtens.net>
References: <20201119235244.373127-1-dja@axtens.net>
MIME-Version: 1.0
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
---
 arch/powerpc/include/asm/uaccess.h | 9 +++++++--
 arch/powerpc/lib/string.S          | 4 ++--
 arch/powerpc/lib/string_64.S       | 6 +++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index f5a56f103197..6cba56b911d9 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -390,7 +390,7 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 	return ret;
 }
 
-extern unsigned long __clear_user(void __user *addr, unsigned long size);
+unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
@@ -398,12 +398,17 @@ static inline unsigned long clear_user(void __user *addr, unsigned long size)
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
 extern __must_check long strnlen_user(const char __user *str, long n);
 
diff --git a/arch/powerpc/lib/string.S b/arch/powerpc/lib/string.S
index 0378def28d41..7ef5497f3f97 100644
--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -88,7 +88,7 @@ _GLOBAL(memchr)
 EXPORT_SYMBOL(memchr)
 
 #ifdef CONFIG_PPC32
-_GLOBAL(__clear_user)
+_GLOBAL(__arch_clear_user)
 	addi	r6,r3,-4
 	li	r3,0
 	li	r5,0
@@ -128,5 +128,5 @@ _GLOBAL(__clear_user)
 	EX_TABLE(1b, 91b)
 	EX_TABLE(8b, 92b)
 
-EXPORT_SYMBOL(__clear_user)
+EXPORT_SYMBOL(__arch_clear_user)
 #endif
diff --git a/arch/powerpc/lib/string_64.S b/arch/powerpc/lib/string_64.S
index 56aac4c22025..ea3798f4f25f 100644
--- a/arch/powerpc/lib/string_64.S
+++ b/arch/powerpc/lib/string_64.S
@@ -29,7 +29,7 @@ PPC64_CACHES:
 	.section	".text"
 
 /**
- * __clear_user: - Zero a block of memory in user space, with less checking.
+ * __arch_clear_user: - Zero a block of memory in user space, with less checking.
  * @to:   Destination address, in user space.
  * @n:    Number of bytes to zero.
  *
@@ -70,7 +70,7 @@ err3;	stb	r0,0(r3)
 	mr	r3,r4
 	blr
 
-_GLOBAL_TOC(__clear_user)
+_GLOBAL_TOC(__arch_clear_user)
 	cmpdi	r4,32
 	neg	r6,r3
 	li	r0,0
@@ -193,4 +193,4 @@ err1;	dcbz	0,r3
 	cmpdi	r4,32
 	blt	.Lshort_clear
 	b	.Lmedium_clear
-EXPORT_SYMBOL(__clear_user)
+EXPORT_SYMBOL(__arch_clear_user)
-- 
2.25.1

