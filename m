Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F972B9E9D
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgKSXm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgKSXm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:42:27 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED77C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:26 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id v21so5699489pgi.2
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CO20go03reExwdX6pJaWo+Dz1ubTdlVdM4q25e4Iy40=;
        b=hyF0f+omB8Go2TbQW3IwmTCcDHA1VYvhSqaGwDwiOUwnGaxQUVRIf5LwE0zo5clE5F
         SKusZNgStksN7EZVXP6wfS7jT4rWPYSBFb2ByGv3SmagSir9AIXGYtzmGLz158ksq/dG
         vp8f5yka+M7iB+oCZhudG8IcHCUb0N6hSeCuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CO20go03reExwdX6pJaWo+Dz1ubTdlVdM4q25e4Iy40=;
        b=tr6B7UedWmKLZtkvg5tXmqatjWlYMHb8OLL71FU5Y+FGlvlJTGkMv/vqeSjsp2jnJr
         FFA7tZNYSuoW59dwsjj5G93Hyiu4hqcXb2nhpJqy5WY3NTUIVaRZjp9cQwuxIXAa1jVu
         WSryOHw6xwhlv5wTtIrj+fUbQwNfneHyz0vLW7QWJkRAmCZW1VrmqI6RKaFRohhOwVda
         dnVMjSBLyeLlWO+v/gvvLfsi5YmwLvVJXGl6r18Qb4nvKpIxGB1YS5sJMB6VIBuRw48o
         IYq2pQ/GGRNJC4JQPoL4M2d6BTjPT+KTBWBjBtpYiAA7yRSnjudnqdDw0dk/KiG9mxie
         FO7w==
X-Gm-Message-State: AOAM530Khw/gpPHcMcmwfSvAeMJWDckz+EhUPFh8+VEXv5KmpFF/hr/R
        3ousRJk81OkJNJvXgqDaxUf9bgg12ZRiaQ==
X-Google-Smtp-Source: ABdhPJwHJiQatmq9gjacQvr41MDKuRdHixRQDlkZ+Mrd8gXbcIvZlcA2wdrXY1nVthsKO+KpZqwWwA==
X-Received: by 2002:a63:d815:: with SMTP id b21mr14890148pgh.450.1605829346292;
        Thu, 19 Nov 2020 15:42:26 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id q23sm1067031pfg.192.2020.11.19.15.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:42:25 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.19 5/7] powerpc: Fix __clear_user() with KUAP enabled
Date:   Fri, 20 Nov 2020 10:42:01 +1100
Message-Id: <20201119234203.370400-6-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119234203.370400-1-dja@axtens.net>
References: <20201119234203.370400-1-dja@axtens.net>
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
 arch/powerpc/lib/string_32.S       | 4 ++--
 arch/powerpc/lib/string_64.S       | 6 +++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 463e3d3dd0a3..15d9706a9f9c 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -416,7 +416,7 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 	return ret;
 }
 
-extern unsigned long __clear_user(void __user *addr, unsigned long size);
+unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
@@ -424,12 +424,17 @@ static inline unsigned long clear_user(void __user *addr, unsigned long size)
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
 
diff --git a/arch/powerpc/lib/string_32.S b/arch/powerpc/lib/string_32.S
index f69a6aab7bfb..1ddb26394e8a 100644
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

