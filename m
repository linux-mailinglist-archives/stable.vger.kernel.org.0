Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29B82B9EF1
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgKSX6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgKSX6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:58:10 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A1C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:09 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id j19so5705143pgg.5
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sQSXO/yeAxR3lTlenvJw2/aboUYwdL039sdfFo9gRBY=;
        b=mhtNHRo8uo4sgyq1sXpgeWH+yGpIS3E6F2JCED/3BgDNhMDIDWWrmKwBYsv+M2+Q9W
         IhxU/k2K4OGlcuTuR+6wsHxA4wjHDKyWbkaYgXy0HZa2/TQPGvrodfS7GDpMN/aDWyFm
         ZSXwKJtnO6W1Gjh2bgzbghXByyGhAH+CqF6rY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sQSXO/yeAxR3lTlenvJw2/aboUYwdL039sdfFo9gRBY=;
        b=WjGnTEuTflZhH0qBUjYVsJ15di2jAqIGQotUzoTVbl54J9Z5138/lp3OV7ZePrA1Mt
         VhtkITvzJr+CPO3XXWmhIV445n+ZzshnDh4h3TsVe86TvnxEfLjdlDdh0n+cIwgOuS2A
         hzssGSCKddiF/FJhKbn5Q6kb02DEgjV76mnJ6tUP41TIYcGWK4UNpTYfjgtTDl0Y+AN2
         CEMmE2IMv2Q27SYHmA8tBQ+FEViREI0vJRnoKNzDmOLl8cLqllAg0BB2l0xNG6V8W6z6
         ByATnBmfaH0Q6Lu77JFm1hbm+wBC80Wz05vZREfpxT2ab5iU4gOQh2ZRNJ2aPI6NyQ+F
         YiQA==
X-Gm-Message-State: AOAM530FmTAX9BbWEORpib2TGF432n8Ia/RohqARn31YWXrAnrV6e+wC
        LNh7sr+j+aNvSFqYJqYy4UIqaKhmmhckzg==
X-Google-Smtp-Source: ABdhPJzZVnr3h/X1nhiiPQTRCQg3/W16U3yL+FiTR3yoedb8FxF6XzaDpzmyebmvYLRyaq5i2kAS1Q==
X-Received: by 2002:a17:90a:638f:: with SMTP id f15mr6775930pjj.200.1605830289334;
        Thu, 19 Nov 2020 15:58:09 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id fh22sm908796pjb.45.2020.11.19.15.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:58:08 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 6/8] powerpc: Fix __clear_user() with KUAP enabled
Date:   Fri, 20 Nov 2020 10:57:41 +1100
Message-Id: <20201119235743.373635-7-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235743.373635-1-dja@axtens.net>
References: <20201119235743.373635-1-dja@axtens.net>
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
index a395e440c320..5fc6a9f410f2 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -460,7 +460,7 @@ static inline unsigned long __copy_to_user(void __user *to,
 	return __copy_to_user_inatomic(to, from, size);
 }
 
-extern unsigned long __clear_user(void __user *addr, unsigned long size);
+unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
@@ -468,12 +468,17 @@ static inline unsigned long clear_user(void __user *addr, unsigned long size)
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
diff --git a/arch/powerpc/lib/string.S b/arch/powerpc/lib/string.S
index d13e07603519..4e85411d4a7e 100644
--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -89,7 +89,7 @@ _GLOBAL(memchr)
 EXPORT_SYMBOL(memchr)
 
 #ifdef CONFIG_PPC32
-_GLOBAL(__clear_user)
+_GLOBAL(__arch_clear_user)
 	addi	r6,r3,-4
 	li	r3,0
 	li	r5,0
@@ -130,5 +130,5 @@ _GLOBAL(__clear_user)
 	PPC_LONG	1b,91b
 	PPC_LONG	8b,92b
 	.text
-EXPORT_SYMBOL(__clear_user)
+EXPORT_SYMBOL(__arch_clear_user)
 #endif
diff --git a/arch/powerpc/lib/string_64.S b/arch/powerpc/lib/string_64.S
index 11e6372537fd..347029f65edb 100644
--- a/arch/powerpc/lib/string_64.S
+++ b/arch/powerpc/lib/string_64.S
@@ -28,7 +28,7 @@ PPC64_CACHES:
 	.section	".text"
 
 /**
- * __clear_user: - Zero a block of memory in user space, with less checking.
+ * __arch_clear_user: - Zero a block of memory in user space, with less checking.
  * @to:   Destination address, in user space.
  * @n:    Number of bytes to zero.
  *
@@ -78,7 +78,7 @@ err3;	stb	r0,0(r3)
 	mr	r3,r4
 	blr
 
-_GLOBAL_TOC(__clear_user)
+_GLOBAL_TOC(__arch_clear_user)
 	cmpdi	r4,32
 	neg	r6,r3
 	li	r0,0
@@ -201,4 +201,4 @@ err1;	dcbz	0,r3
 	cmpdi	r4,32
 	blt	.Lshort_clear
 	b	.Lmedium_clear
-EXPORT_SYMBOL(__clear_user)
+EXPORT_SYMBOL(__arch_clear_user)
-- 
2.25.1

