Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B09D6662B
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfGLF31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37993 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:27 -0400
Received: by mail-pl1-f195.google.com with SMTP id az7so4203660plb.5
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0RCljGeD4tzeQJetzsGgy9r5JSUQjn098IzF6ZdUW0=;
        b=ulsmDQGtyVvfNWx5Zo0lXZZXUOf82ZFYWRtPMKIzeKLZEz3LQdiCR03FjQzHTfdy2y
         CVjPXKLsSc0BgptX/fOwvMXV/U9uYVWZPsOP6DSSK7qGV9y5XBFEE3Pl4RLNu9xM2Hiz
         aA93Dd4vN6TllQNFpdPXbuiNRhxznOnFXjR8QAAwWi5InfpDVW+WOmdoYdcTlh+jzpYl
         CdBsIhCwsbEhYpNbir1K/g17O/lo/RhqM0EXfdpc0VMCMturMeqfnMissX3VFQ0uFXkJ
         yeN4bjHfyYOnfNuhtfagMnkRzxUwAoLJcx3tMa3xFMxbb55lt8o598rojMNtEOxT6aG3
         zNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0RCljGeD4tzeQJetzsGgy9r5JSUQjn098IzF6ZdUW0=;
        b=ZdRCY5YOWX3rqSjqLaMcIBzCacw4+5nU/xss9ziiDWmw09UqCzYIl4k+41Bh1Nd8sY
         iAsVRdQggb+3WeC9G55YThSpwX9QZFbPIZwy9eEh3TEkfCkP40xaMg1djLsS+2lWk5G+
         jy18mfP0lGfe1Kd+g84bzk5Z5NtsG2FBkEsvjKZQ+SnuQ+6sNqzo1pjNnVn1Ow3WXT3O
         XA74YrYIjNQXd4HITIg1yfO7L+JGbL1Wg9MikN3YpCRI0KepFCEi1aImSVtVhQR7XL4X
         9xQ2EP8mtjBF83nwD5MUkxCt3nzkjHJDpxiEtvJ/9UXbZDf68lhGkQXvN8xHOOAYAPIn
         DpwA==
X-Gm-Message-State: APjAAAU2vaG5stHMvPdUifpzWOCXFJO5uvFcn7tYtkoZfj3zyOY0guf4
        XGmdxXmBIogfr5iYJg8bJpO2v6tUfaA=
X-Google-Smtp-Source: APXvYqyUB0WGysAwEjCSP5uT8/Jz9S7uh5PgzrZ/l7+QJJDz49N6ZdtoP3typjucGn2JE499R9idNA==
X-Received: by 2002:a17:902:a612:: with SMTP id u18mr8864924plq.181.1562909365963;
        Thu, 11 Jul 2019 22:29:25 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id p23sm7571929pfn.10.2019.07.11.22.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:25 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 10/43] arm64: kasan: instrument user memory access API
Date:   Fri, 12 Jul 2019 10:57:58 +0530
Message-Id: <8df1bde82656584cb537f322ae744836a41b597a.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

