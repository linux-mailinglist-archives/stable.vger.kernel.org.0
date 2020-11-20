Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9836D2B9F05
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 01:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgKTAHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 19:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTAHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 19:07:32 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FABC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:32 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 62so5718329pgg.12
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rOgkIUDv1jgPnTWrUFJlC6eZsnuFHauRIqe9KxVY0Rg=;
        b=kFg/CPwwyLUv5bx7ZlMNuVGM2cPGfefvKwH6/T4m/8wnkr6jx6ArjdK58abg1UHSX3
         PbYAJ56KLtImQk+t5nkGxW8aZnou3ffn7Mz6WAx8pYd54b5TCAfilrBXzILDY1RM092e
         twpt4QjuAY3JOurx85yuyf70npumlG9fKdnjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rOgkIUDv1jgPnTWrUFJlC6eZsnuFHauRIqe9KxVY0Rg=;
        b=Cpg9sWYzYH+l+cQsRjxlno/H60hRbUQPUzQ5B/QUAzKrAIDt0T2qC+0F6v2eRPhWkX
         1sc7nvzKbji7ut6TmuF8yP95+IJTgmx6QS27mQwG5lP/JWpWR0VNiZKuggPzptm3DjHF
         Y36wanvSmgFvgs1CauzamHnG/BQd5euobufHD42RsyXHXiMHjKc1ULfekV6Vqbz41fEc
         Qvgb/H5YjByBkXJIdonN5ead85V4G29JGHdpv/RUWQgw2UHQpTxbldyARsGy2RDpHMQO
         /4hIioZc2zlYi8EkuzflTVDMP6RQhx4euIxRzZDosOmm32fUt2BahH0hrRvP30WYKW95
         dd9w==
X-Gm-Message-State: AOAM531CuAz4jztnv4ZmW7riuFmDtubgRrkJb3ngzb+up/ff2az/GSU3
        SslV9pZ0gO5F4vnlYRcI7LFdhrqJ1mLRCg==
X-Google-Smtp-Source: ABdhPJx+yRjWkmXluqabaDWWvBMZv0pRjotjubrwRyStWTLa6GO6Kpb5RtCjJbSnWPJKYCoBM43/fw==
X-Received: by 2002:a62:37c4:0:b029:197:bfa9:2078 with SMTP id e187-20020a6237c40000b0290197bfa92078mr4043130pfa.15.1605830851518;
        Thu, 19 Nov 2020 16:07:31 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id r36sm865496pgb.75.2020.11.19.16.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:07:31 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.4 6/8] powerpc: Fix __clear_user() with KUAP enabled
Date:   Fri, 20 Nov 2020 11:07:02 +1100
Message-Id: <20201120000704.374811-7-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120000704.374811-1-dja@axtens.net>
References: <20201120000704.374811-1-dja@axtens.net>
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
 arch/powerpc/kernel/ppc_ksyms.c    | 3 +++
 arch/powerpc/lib/string.S          | 2 +-
 arch/powerpc/lib/string_64.S       | 4 ++--
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index f0195ad25836..edf211b5ada0 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -471,7 +471,7 @@ static inline unsigned long __copy_to_user(void __user *to,
 	return __copy_to_user_inatomic(to, from, size);
 }
 
-extern unsigned long __clear_user(void __user *addr, unsigned long size);
+unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
@@ -479,12 +479,17 @@ static inline unsigned long clear_user(void __user *addr, unsigned long size)
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
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 202963ee013a..b92debacb821 100644
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
diff --git a/arch/powerpc/lib/string.S b/arch/powerpc/lib/string.S
index c80fb49ce607..93c4c34ad091 100644
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
diff --git a/arch/powerpc/lib/string_64.S b/arch/powerpc/lib/string_64.S
index 7bd9549a90a2..14d26ad2cd69 100644
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
-- 
2.25.1

