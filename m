Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D3CA18C1
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfH2LfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39859 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfH2LfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id y200so1864731pfb.6
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhknZxKgdAl94bBxAtLuZWwcExNsXFBEnXwKzdceJOY=;
        b=LgifRp0t619ipGp00hh6dJHvv1uAk/0lLN4nMJx7053wZL01Xo3V+bapPzFDdViOUp
         b6FXPazVzXMFSLGUSo+IBihcXbSIPMyXnuipSxfwCsLk79fmTDQK3tnvB6rBjPmFk5nX
         dj/KSzwdu4MUsPkemMgJfLUro/TGvONKORl7YRTuS7HSWN5DRpddUuDLANfiZ4bws/7r
         ZiMSIVUSkhQDiO4n1+dvAJIyEv6uregm37gdIkfTJtrUvs0QeNudbNKjJ+mT+jE5Zfrg
         fWX+7DdPGBbtLxl8SZH1R5NoUj4WR3eP0A6iPg5rFaLu085Pg6+Kw6lg5wSgGXJ9e5fL
         MzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhknZxKgdAl94bBxAtLuZWwcExNsXFBEnXwKzdceJOY=;
        b=auChsq2oDktOZkxZyxtTqa3opR0FnjB3oKU99PBKHL1z3dWWlFk7NruoXd7WPksPDN
         yJryigUSWbbGUbC1Ew0yu2T7SVF2PurQarQDGgtCrtQqRgwb7XwvS6yDXShSCiaGghGz
         9HLLdCJ+4p81lCqlOaM/NYMjfsUMLPBoqyxtqMSNVbnW8jeeMKP3igrr2OhA+Wjp+LCt
         Ox3Wc8x9cxVOzKfyT+nBswL3kicE9dgQ07DZSTvqiKs57f2hjfnwPGtTmuRcPCMsvmaF
         qTjow0IFtl+nn2gjwTj4Z/MwwD5RU2YfRBZx38yRLz82jjcLHm8DIl/tlQNqNfty/mZk
         V7Yg==
X-Gm-Message-State: APjAAAUKJACS3bIhp+DKlfWpWUSxKGey5YktnVKok5QN6WhGsYbWbGVi
        ca0Du/EFpwep+beGN1jZfYNzJ2GDUQY=
X-Google-Smtp-Source: APXvYqxmEmG+lq+I9erc/qBO7+RAykjZPAK1EUQqX/Yb+djWwrTCXJB3vXP1lQPLDkdWLDQgOMYY/g==
X-Received: by 2002:a63:a35c:: with SMTP id v28mr7957325pgn.144.1567078521464;
        Thu, 29 Aug 2019 04:35:21 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id p90sm6496358pjp.7.2019.08.29.04.35.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:20 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 11/44] arm64: uaccess: Mask __user pointers for __arch_{clear, copy_*}_user
Date:   Thu, 29 Aug 2019 17:03:56 +0530
Message-Id: <821430ff13f625eca9e0a9700ddc161cbc7965ff.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit f71c2ffcb20dd8626880747557014bb9a61eb90e upstream.

Like we've done for get_user and put_user, ensure that user pointers
are masked before invoking the underlying __arch_{clear,copy_*}_user
operations.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: fixup for v4.4 style uaccess primitives ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/uaccess.h | 18 ++++++++++--------
 arch/arm64/kernel/arm64ksyms.c   |  4 ++--
 arch/arm64/lib/clear_user.S      |  6 +++---
 arch/arm64/lib/copy_in_user.S    |  4 ++--
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 693a0d784534..f2f5a152f372 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -303,19 +303,18 @@ do {									\
 
 extern unsigned long __must_check __arch_copy_from_user(void *to, const void __user *from, unsigned long n);
 extern unsigned long __must_check __arch_copy_to_user(void __user *to, const void *from, unsigned long n);
-extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
-extern unsigned long __must_check __clear_user(void __user *addr, unsigned long n);
+extern unsigned long __must_check __arch_copy_in_user(void __user *to, const void __user *from, unsigned long n);
 
 static inline unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	kasan_check_write(to, n);
-	return  __arch_copy_from_user(to, from, n);
+	return __arch_copy_from_user(to, __uaccess_mask_ptr(from), n);
 }
 
 static inline unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	kasan_check_read(from, n);
-	return  __arch_copy_to_user(to, from, n);
+	return __arch_copy_to_user(__uaccess_mask_ptr(to), from, n);
 }
 
 static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
@@ -338,22 +337,25 @@ static inline unsigned long __must_check copy_to_user(void __user *to, const voi
 	return n;
 }
 
-static inline unsigned long __must_check copy_in_user(void __user *to, const void __user *from, unsigned long n)
+static inline unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	if (access_ok(VERIFY_READ, from, n) && access_ok(VERIFY_WRITE, to, n))
-		n = __copy_in_user(to, from, n);
+		n = __arch_copy_in_user(__uaccess_mask_ptr(to), __uaccess_mask_ptr(from), n);
 	return n;
 }
+#define copy_in_user __copy_in_user
 
 #define __copy_to_user_inatomic __copy_to_user
 #define __copy_from_user_inatomic __copy_from_user
 
-static inline unsigned long __must_check clear_user(void __user *to, unsigned long n)
+extern unsigned long __must_check __arch_clear_user(void __user *to, unsigned long n);
+static inline unsigned long __must_check __clear_user(void __user *to, unsigned long n)
 {
 	if (access_ok(VERIFY_WRITE, to, n))
-		n = __clear_user(__uaccess_mask_ptr(to), n);
+		n = __arch_clear_user(__uaccess_mask_ptr(to), n);
 	return n;
 }
+#define clear_user	__clear_user
 
 extern long strncpy_from_user(char *dest, const char __user *src, long count);
 
diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
index c654df05b7d7..abe4e0984dbb 100644
--- a/arch/arm64/kernel/arm64ksyms.c
+++ b/arch/arm64/kernel/arm64ksyms.c
@@ -35,8 +35,8 @@ EXPORT_SYMBOL(clear_page);
 	/* user mem (segment) */
 EXPORT_SYMBOL(__arch_copy_from_user);
 EXPORT_SYMBOL(__arch_copy_to_user);
-EXPORT_SYMBOL(__clear_user);
-EXPORT_SYMBOL(__copy_in_user);
+EXPORT_SYMBOL(__arch_clear_user);
+EXPORT_SYMBOL(__arch_copy_in_user);
 
 	/* physical memory */
 EXPORT_SYMBOL(memstart_addr);
diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index a9723c71c52b..fc6bb0f83511 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -24,7 +24,7 @@
 
 	.text
 
-/* Prototype: int __clear_user(void *addr, size_t sz)
+/* Prototype: int __arch_clear_user(void *addr, size_t sz)
  * Purpose  : clear some user memory
  * Params   : addr - user memory address to clear
  *          : sz   - number of bytes to clear
@@ -32,7 +32,7 @@
  *
  * Alignment fixed up by hardware.
  */
-ENTRY(__clear_user)
+ENTRY(__arch_clear_user)
 ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	mov	x2, x1			// save the size for fixup return
@@ -57,7 +57,7 @@ USER(9f, strb	wzr, [x0]	)
 ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	ret
-ENDPROC(__clear_user)
+ENDPROC(__arch_clear_user)
 
 	.section .fixup,"ax"
 	.align	2
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index 81c8fc93c100..0219aa85b3cc 100644
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -67,7 +67,7 @@
 	.endm
 
 end	.req	x5
-ENTRY(__copy_in_user)
+ENTRY(__arch_copy_in_user)
 ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	add	end, x0, x2
@@ -76,7 +76,7 @@ ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	mov	x0, #0
 	ret
-ENDPROC(__copy_in_user)
+ENDPROC(__arch_copy_in_user)
 
 	.section .fixup,"ax"
 	.align	2
-- 
2.21.0.rc0.269.g1a574e7a288b

