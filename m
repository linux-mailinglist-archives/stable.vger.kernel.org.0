Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D810CA18BD
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfH2LfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35774 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfH2LfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so1457053pgv.2
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lt3w372XAiP2T5A3AE8p2nBAFVuCKsgxbI6J0UJSdP8=;
        b=w34Lfs1Qqs58LGmtolXD4m8NuERCbaTGl+FkcIHv817QZ4KWsO2vTcuI6Mx2gTcM4Q
         3bKnw0mvesmQ+NPRMoZNsIDSREQdQV7hdSNJo0lpexFV/SG7ii/cwDMH7lxzQyN6Q2lK
         RBJ5fBWK47IUN/p/NIwZqvWAKE/F4fxxRF3JK4AfHAz71RLUaM4IH20p5z0mB1g9sPAc
         YD76t/u7pLj1CF3JvTIl2F3NKZ5zIqzHM8aCE8cT1lgp1x5n0RxvGLtBOJYnw3dS/V2D
         6YNsG3i/dJHFutF8HbVNmcfKrNF1iEOMIpW0UeuPYopUkDjxPDLmzAokpEDXFxNkimum
         HBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lt3w372XAiP2T5A3AE8p2nBAFVuCKsgxbI6J0UJSdP8=;
        b=DxjuxZyFH9NcmCbfcN3eBXmuNJLrJGUqlaFhUKJSiYF3YNjoKUZ4vaAI0eTmh8xNa9
         Clh8PRE123oHPZk0GH3K5WG4EN289P8droEdVeYfe6Kv2quXCKIIjiGbcyXD0fFgp8Qd
         PPRwZWsqrKCvhPmfkX0aIJNK4s82ZbblGUaqaGlmAR4uGriQi2Lh7M0nTGNW8tTPo8yv
         IQK1mZyukXWlSIorjW3KY0DBnMCMRneAejvLu7Gs3Y5LGwtelaV0MM/uevHVZW3K4ImN
         eKS+JTFKwtTaf2vVNJJqREHopJ2Py7yidugxW1EwU6XRIVlnZiSyqsDL5+fo2ZQwwZsF
         0slQ==
X-Gm-Message-State: APjAAAVxD5WTMlZAeYA2KsKrUjMXKZYM5JyHhj6mgdgsEN0DpBekL4ym
        RR7qkQw1xZeE7D1n2dR77oUKhW9Ph10=
X-Google-Smtp-Source: APXvYqwx+fqeB+pn0ZHKuXRhZy+/4LS/RCtV8lbSFMSR+8TY125WQPcn5xEcV3sp/1sa81Pcpx4uLw==
X-Received: by 2002:a62:db43:: with SMTP id f64mr11200661pfg.38.1567078513287;
        Thu, 29 Aug 2019 04:35:13 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id u69sm1878521pgu.77.2019.08.29.04.35.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:12 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 08/44] arm64: uaccess: Don't bother eliding access_ok checks in __{get, put}_user
Date:   Thu, 29 Aug 2019 17:03:53 +0530
Message-Id: <40fe1d91c9cd8d78ae952b821185681621f92b10.1567077734.git.viresh.kumar@linaro.org>
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

commit 84624087dd7e3b482b7b11c170ebc1f329b3a218 upstream.

access_ok isn't an expensive operation once the addr_limit for the current
thread has been loaded into the cache. Given that the initial access_ok
check preceding a sequence of __{get,put}_user operations will take
the brunt of the miss, we can make the __* variants identical to the
full-fat versions, which brings with it the benefits of address masking.

The likely cost in these sequences will be from toggling PAN/UAO, which
we can address later by implementing the *_unsafe versions.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Fixed conflicts around {__get_user|__put_user}_unaligned macros ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/uaccess.h | 62 ++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index fc11c50af558..a34324436ce1 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -200,30 +200,35 @@ do {									\
 			CONFIG_ARM64_PAN));				\
 } while (0)
 
-#define __get_user(x, ptr)						\
+#define __get_user_check(x, ptr, err)					\
 ({									\
-	int __gu_err = 0;						\
-	__get_user_err((x), (ptr), __gu_err);				\
-	__gu_err;							\
+	__typeof__(*(ptr)) __user *__p = (ptr);				\
+	might_fault();							\
+	if (access_ok(VERIFY_READ, __p, sizeof(*__p))) {		\
+		__p = uaccess_mask_ptr(__p);				\
+		__get_user_err((x), __p, (err));			\
+	} else {							\
+		(x) = 0; (err) = -EFAULT;				\
+	}								\
 })
 
 #define __get_user_error(x, ptr, err)					\
 ({									\
-	__get_user_err((x), (ptr), (err));				\
+	__get_user_check((x), (ptr), (err));				\
 	(void)0;							\
 })
 
-#define __get_user_unaligned __get_user
-
-#define get_user(x, ptr)						\
+#define __get_user(x, ptr)						\
 ({									\
-	__typeof__(*(ptr)) __user *__p = (ptr);				\
-	might_fault();							\
-	access_ok(VERIFY_READ, __p, sizeof(*__p)) ?			\
-		__p = uaccess_mask_ptr(__p), __get_user((x), __p) :	\
-		((x) = 0, -EFAULT);					\
+	int __gu_err = 0;						\
+	__get_user_check((x), (ptr), __gu_err);				\
+	__gu_err;							\
 })
 
+#define __get_user_unaligned __get_user
+
+#define get_user	__get_user
+
 #define __put_user_asm(instr, reg, x, addr, err)			\
 	asm volatile(							\
 	"1:	" instr "	" reg "1, [%2]\n"			\
@@ -266,30 +271,35 @@ do {									\
 			CONFIG_ARM64_PAN));				\
 } while (0)
 
-#define __put_user(x, ptr)						\
+#define __put_user_check(x, ptr, err)					\
 ({									\
-	int __pu_err = 0;						\
-	__put_user_err((x), (ptr), __pu_err);				\
-	__pu_err;							\
+	__typeof__(*(ptr)) __user *__p = (ptr);				\
+	might_fault();							\
+	if (access_ok(VERIFY_WRITE, __p, sizeof(*__p))) {		\
+		__p = uaccess_mask_ptr(__p);				\
+		__put_user_err((x), __p, (err));			\
+	} else	{							\
+		(err) = -EFAULT;					\
+	}								\
 })
 
 #define __put_user_error(x, ptr, err)					\
 ({									\
-	__put_user_err((x), (ptr), (err));				\
+	__put_user_check((x), (ptr), (err));				\
 	(void)0;							\
 })
 
-#define __put_user_unaligned __put_user
-
-#define put_user(x, ptr)						\
+#define __put_user(x, ptr)						\
 ({									\
-	__typeof__(*(ptr)) __user *__p = (ptr);				\
-	might_fault();							\
-	access_ok(VERIFY_WRITE, __p, sizeof(*__p)) ?			\
-		__p = uaccess_mask_ptr(__p), __put_user((x), __p) :	\
-		-EFAULT;						\
+	int __pu_err = 0;						\
+	__put_user_check((x), (ptr), __pu_err);				\
+	__pu_err;							\
 })
 
+#define __put_user_unaligned __put_user
+
+#define put_user	__put_user
+
 extern unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n);
 extern unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n);
 extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
-- 
2.21.0.rc0.269.g1a574e7a288b

