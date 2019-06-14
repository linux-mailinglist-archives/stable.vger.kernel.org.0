Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0784526A
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfFNDMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43234 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so482789pfg.10
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0RCljGeD4tzeQJetzsGgy9r5JSUQjn098IzF6ZdUW0=;
        b=EnlNIWxbtRThqYC1UTEAMR6ZJHxB7MpeNcyku2RIUxsBNKOca6sb1cLziSGn027QKB
         xznFwEiVWEV8QHdgGzBQHOdJP4StFOzj+T+DkX9dTluJJf8uG+du5rxm1et9ARIS4deq
         66iFIpfeZzOLGx1fURdbEC387LYqMrJQSrtZLWzTDvQchdMd1/rZXOX3E/SOVTzo6dCL
         xuHUISGzQnmY2wjzUcLfRKDKV7ZobrQBu81lBSzvcyKSlwqFr+8EckIrP2mAwjn1Evh5
         Bl9CmZx5NM0LTXYNykjnVOtsoLVfbdR7BydQbSayQDn36dpSKcpA4Ry6vcT2xzpM4fFG
         s2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0RCljGeD4tzeQJetzsGgy9r5JSUQjn098IzF6ZdUW0=;
        b=Zy51fU71vlIv7e30Mb2YLRPFXs5lEvgSyayFBj4Kt0HbqlXV67DYR7nSTnRxOxIOpE
         FzLIPBcNuQjx4msz11+pcwuD04xowOmbzV7n+BMS3D9RmgVICcGl7Lq67HF7xcnj5Mh8
         Qtal1Y7zrT1uLfVcwNI1B83+Av8ANpXfPJ3TrXY6fH9UtEeP+k4i2shi8gEiyc0FVlIx
         RbJaOlWKlIFSaFflLUAR1T/6WfWBFjg5mYM7Ib5K7GujP4vSYXZLwM7UZ1kj2UBpaKH+
         e67BDCgkfFbre8YEbFGCE3N5emydEwpoZguDOngZuRlUa/SyEvikWIfiJFGyeWZOTyR0
         30EQ==
X-Gm-Message-State: APjAAAW13qoJkS1tdfkWWqN/PmsKYrIVhl1DmQaAivCWvR+4qYMet2oW
        PEU3gef4Yqa5h7/BrF2asebhXA==
X-Google-Smtp-Source: APXvYqxwj5PgnFL+hOW4VhWZf44B0eCA35gPND0EA8N17oIb8+BzUrMIq4Sg8lSadnjSM11F+Kg9DA==
X-Received: by 2002:a63:68b:: with SMTP id 133mr32205733pgg.385.1560481943068;
        Thu, 13 Jun 2019 20:12:23 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id n140sm1075830pfd.132.2019.06.13.20.12.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:22 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 11/45] arm64: kasan: instrument user memory access API
Date:   Fri, 14 Jun 2019 08:37:54 +0530
Message-Id: <565bddf471412bbd64d0ece7f9d91b9c937cae19.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linaro.org>

commit bffe1baff5d57521b0c41b6997c41ff1993e9818 upstream.

The upstream commit 1771c6e1a567ea0ba2cccc0a4ffe68a1419fd8ef
("x86/kasan: instrument user memory access API") added KASAN instrument to
x86 user memory access API, so added such instrument to ARM64 too.

Define __copy_to/from_user in C in order to add kasan_check_read/write call,
rename assembly implementation to __arch_copy_to/from_user.

Tested by test_kasan module.

Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/uaccess.h | 25 +++++++++++++++++++++----
 arch/arm64/kernel/arm64ksyms.c   |  4 ++--
 arch/arm64/lib/copy_from_user.S  |  4 ++--
 arch/arm64/lib/copy_to_user.S    |  4 ++--
 4 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index a34324436ce1..693a0d784534 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -22,6 +22,7 @@
  * User space memory access functions
  */
 #include <linux/bitops.h>
+#include <linux/kasan-checks.h>
 #include <linux/string.h>
 #include <linux/thread_info.h>
 
@@ -300,15 +301,29 @@ do {									\
 
 #define put_user	__put_user
 
-extern unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n);
-extern unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n);
+extern unsigned long __must_check __arch_copy_from_user(void *to, const void __user *from, unsigned long n);
+extern unsigned long __must_check __arch_copy_to_user(void __user *to, const void *from, unsigned long n);
 extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
 extern unsigned long __must_check __clear_user(void __user *addr, unsigned long n);
 
+static inline unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	kasan_check_write(to, n);
+	return  __arch_copy_from_user(to, from, n);
+}
+
+static inline unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	kasan_check_read(from, n);
+	return  __arch_copy_to_user(to, from, n);
+}
+
 static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
 {
+	kasan_check_write(to, n);
+
 	if (access_ok(VERIFY_READ, from, n))
-		n = __copy_from_user(to, from, n);
+		n = __arch_copy_from_user(to, from, n);
 	else /* security hole - plug it */
 		memset(to, 0, n);
 	return n;
@@ -316,8 +331,10 @@ static inline unsigned long __must_check copy_from_user(void *to, const void __u
 
 static inline unsigned long __must_check copy_to_user(void __user *to, const void *from, unsigned long n)
 {
+	kasan_check_read(from, n);
+
 	if (access_ok(VERIFY_WRITE, to, n))
-		n = __copy_to_user(to, from, n);
+		n = __arch_copy_to_user(to, from, n);
 	return n;
 }
 
diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
index 3b6d8cc9dfe0..c654df05b7d7 100644
--- a/arch/arm64/kernel/arm64ksyms.c
+++ b/arch/arm64/kernel/arm64ksyms.c
@@ -33,8 +33,8 @@ EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 
 	/* user mem (segment) */
-EXPORT_SYMBOL(__copy_from_user);
-EXPORT_SYMBOL(__copy_to_user);
+EXPORT_SYMBOL(__arch_copy_from_user);
+EXPORT_SYMBOL(__arch_copy_to_user);
 EXPORT_SYMBOL(__clear_user);
 EXPORT_SYMBOL(__copy_in_user);
 
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 4699cd74f87e..281e75db899a 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -66,7 +66,7 @@
 	.endm
 
 end	.req	x5
-ENTRY(__copy_from_user)
+ENTRY(__arch_copy_from_user)
 ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	add	end, x0, x2
@@ -75,7 +75,7 @@ ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	mov	x0, #0				// Nothing to copy
 	ret
-ENDPROC(__copy_from_user)
+ENDPROC(__arch_copy_from_user)
 
 	.section .fixup,"ax"
 	.align	2
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 7512bbbc07ac..db4d187de61f 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -65,7 +65,7 @@
 	.endm
 
 end	.req	x5
-ENTRY(__copy_to_user)
+ENTRY(__arch_copy_to_user)
 ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	add	end, x0, x2
@@ -74,7 +74,7 @@ ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_HAS_PAN, \
 	    CONFIG_ARM64_PAN)
 	mov	x0, #0
 	ret
-ENDPROC(__copy_to_user)
+ENDPROC(__arch_copy_to_user)
 
 	.section .fixup,"ax"
 	.align	2
-- 
2.21.0.rc0.269.g1a574e7a288b

