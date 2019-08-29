Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44216A18C0
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfH2LfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39000 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfH2LfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so1447323pgi.6
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0RCljGeD4tzeQJetzsGgy9r5JSUQjn098IzF6ZdUW0=;
        b=YQZAocWE/Welr7WRITfOLe4k71VJ3o73iNoy5U68EnvNd/kov60mxq6VyFnAGdI3z1
         kX22zmb22BAPFRkFCmaG5FOIh1dkAYq8scp1IRlE5ncHbjLjCWbfVjJmSeMqK/kKLRHF
         N5nOg9icHMENULVrjw1m5OTHAfi+lpDGYgwr7Byvh296dstGG789EbcPm9ZnAhsGpYYL
         OkIu/6H8TtJapgSe5eDufK/hrIoE9KAvsamjBjsPU9kopIYdqRTAJ/twAlv9XMZLHa3y
         tDLZ+mtme85/IL7YaoZo7Q84OR4gAqamt6lInXqRxbYqk7JfhX+ozPO9N2ueoG2dXH10
         QGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0RCljGeD4tzeQJetzsGgy9r5JSUQjn098IzF6ZdUW0=;
        b=sjQgvLe1AgzZjtPTChj2IvBfH7BvoW77U7I716pFrDS3Z/R06GF8BIFeZBHmco1+Ub
         7PELLlKo+WSs9ESGzL4tev1g91LIS2NWeL1dGWb7ukjdbC9kJ6QcLaUE2IZk0TIJZzrc
         kZx5OTOt7Bu8tcx3dykJ35LyeEp0Xm2U2GKGgAgfW9PaJCv9g+A/nVxTwCEgRt9SQdEQ
         d//OHHjAmOA/QWp7+IpBWaZtA1V13V8io9mHgP5KfdwE8z9972h7TA+jyCrkwzkAngSk
         l6HvOrwhlMqMEghMOFFKgblg7OWpIMa5dgo5vN2L0+J20Cy1GXT2bR3ppDpwI9vpdeSy
         h7AA==
X-Gm-Message-State: APjAAAX4+SSG4aPmCDITtv1FP1s1/8yHxJO+OoexNNX06yIPGNhXwAzN
        LIS6FrhZrinYgLPJvSFSB6GqRCZ2lK8=
X-Google-Smtp-Source: APXvYqwr2CWv87LcgZAjl4+RX4erWvqeZF5XD6wrXnP5fsPqeyrefFy48THZT9mm7thTXdSMimrMOg==
X-Received: by 2002:a62:7e11:: with SMTP id z17mr10432571pfc.211.1567078518584;
        Thu, 29 Aug 2019 04:35:18 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id y8sm5502563pfr.140.2019.08.29.04.35.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:18 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 10/44] arm64: kasan: instrument user memory access API
Date:   Thu, 29 Aug 2019 17:03:55 +0530
Message-Id: <0e906aabc5057c5e23f1092747eaa842d20dd8b3.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
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

