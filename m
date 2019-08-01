Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9627D748
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbfHAIVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38498 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHAIVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so33616890pfn.5
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wHzU+tsn1pgRkzbIeM8fvpGsFHg5ebHOWm4gu/3Evbs=;
        b=rSAt52egga0c/9SEqscpsTeaeRsAwWlmYF0iaTkpWJoaWK26cLxh1XXD3+NxAq/QWX
         e51h9rVl9tyo1SrN4FSuHn+LzRPvxPmAHV0U4kBLerPw9KrfQoopYk5P3tGth+es5E0Y
         YBWVssklLvqnj1o7gKAxxhzEdoSSG+BAZ8ZmLMUZ4DEguwsJ5rpIDTXGxDipk1+rl/XV
         c/4dWbmNolrf5BFUguxC80+PwGpxs65sg1LAZxJteThDQF1k36lH6Imic2YFyELTHcBm
         CFZ6AD07r38paUBn0ey5jIRShqphH8w0uSpcsCXs7KwRWjk742hItzwGw4+avKLlyJs4
         +Fvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wHzU+tsn1pgRkzbIeM8fvpGsFHg5ebHOWm4gu/3Evbs=;
        b=DdSLSrZ+6mtRolYYfZJ7npBWpigXQMS9jHLpFxv1eA6SekiEsCOQ8nsrRH3W5eM1tX
         IhN4zhxnGimvJz4vT8A04KglGkZKkWEMBeL7zmynCKk8K9CEMxUdKyIcTpb3Nlx5q9Bm
         /Xasol/KeC24lASJ2sXVBBTU/WTY1VNnnZJhVyMAsejDmvntOQQil5OZKhzgdqNGuLaU
         TUwubku3XttGzFAM8HCI84tDz1OVIpzWErBTHObhSn5XyTyWSMz8Q0nq8hD32646whrs
         tuMqGgWJxXDwAObHVqco9CzWBoCP3CNHVi5HwL90orvMipDVOO8CPH+O1kAbAyPAfNAF
         qTtg==
X-Gm-Message-State: APjAAAUyVr8RQWdx+v1WsYIR+cbk6y5yDaI/S75O/HhKNqNFF7M8vA0Q
        9rGikRvSllu23QV4Ifjyi+XW08FpJEA=
X-Google-Smtp-Source: APXvYqwnwqiIvKejRHzstn3Je3SR7S3F9vIbsAZ8AdQb5YEbOGH5uf8ZF72xNnezn80fnlz56U48mg==
X-Received: by 2002:a65:4489:: with SMTP id l9mr121289891pgq.207.1564647660710;
        Thu, 01 Aug 2019 01:21:00 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 30sm6971178pjk.17.2019.08.01.01.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:00 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 33/47] ARM: uaccess: remove put_user() code duplication
Date:   Thu,  1 Aug 2019 13:46:17 +0530
Message-Id: <c3bd0d39dd5cda75a761d39f94b12a68d508391a.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

Commit 9f73bd8bb445e0cbe4bcef6d4cfc788f1e184007 upstream.

Remove the code duplication between put_user() and __put_user().  The
code which selected the implementation based upon the pointer size, and
declared the local variable to hold the value to be put are common to
both implementations.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/uaccess.h | 106 +++++++++++++++------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index a782201a2629..94b1bf53b820 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -253,49 +253,23 @@ extern int __put_user_2(void *, unsigned int);
 extern int __put_user_4(void *, unsigned int);
 extern int __put_user_8(void *, unsigned long long);
 
-#define __put_user_x(__r2, __p, __e, __l, __s)				\
-	   __asm__ __volatile__ (					\
-		__asmeq("%0", "r0") __asmeq("%2", "r2")			\
-		__asmeq("%3", "r1")					\
-		"bl	__put_user_" #__s				\
-		: "=&r" (__e)						\
-		: "0" (__p), "r" (__r2), "r" (__l)			\
-		: "ip", "lr", "cc")
-
-#define __put_user_check(x, p)						\
+#define __put_user_check(__pu_val, __ptr, __err, __s)			\
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
-		const typeof(*(p)) __user *__tmp_p = (p);		\
-		register typeof(*(p)) __r2 asm("r2") = (x);	\
-		register const typeof(*(p)) __user *__p asm("r0") = __tmp_p; \
+		register typeof(__pu_val) __r2 asm("r2") = __pu_val;	\
+		register const void __user *__p asm("r0") = __ptr;	\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
-		unsigned int __ua_flags = uaccess_save_and_enable();	\
-		switch (sizeof(*(__p))) {				\
-		case 1:							\
-			__put_user_x(__r2, __p, __e, __l, 1);		\
-			break;						\
-		case 2:							\
-			__put_user_x(__r2, __p, __e, __l, 2);		\
-			break;						\
-		case 4:							\
-			__put_user_x(__r2, __p, __e, __l, 4);		\
-			break;						\
-		case 8:							\
-			__put_user_x(__r2, __p, __e, __l, 8);		\
-			break;						\
-		default: __e = __put_user_bad(); break;			\
-		}							\
-		uaccess_restore(__ua_flags);				\
-		__e;							\
+		__asm__ __volatile__ (					\
+			__asmeq("%0", "r0") __asmeq("%2", "r2")		\
+			__asmeq("%3", "r1")				\
+			"bl	__put_user_" #__s			\
+			: "=&r" (__e)					\
+			: "0" (__p), "r" (__r2), "r" (__l)		\
+			: "ip", "lr", "cc");				\
+		__err = __e;						\
 	})
 
-#define put_user(x, p)							\
-	({								\
-		might_fault();						\
-		__put_user_check(x, p);					\
-	 })
-
 #else /* CONFIG_MMU */
 
 /*
@@ -313,7 +287,7 @@ static inline void set_fs(mm_segment_t fs)
 }
 
 #define get_user(x, p)	__get_user(x, p)
-#define put_user(x, p)	__put_user(x, p)
+#define __put_user_check __put_user_nocheck
 
 #endif /* CONFIG_MMU */
 
@@ -408,36 +382,54 @@ do {									\
 	__get_user_asm(x, addr, err, ldr)
 #endif
 
+
+#define __put_user_switch(x, ptr, __err, __fn)				\
+	do {								\
+		const __typeof__(*(ptr)) __user *__pu_ptr = (ptr);	\
+		__typeof__(*(ptr)) __pu_val = (x);			\
+		unsigned int __ua_flags;				\
+		might_fault();						\
+		__ua_flags = uaccess_save_and_enable();			\
+		switch (sizeof(*(ptr))) {				\
+		case 1: __fn(__pu_val, __pu_ptr, __err, 1); break;	\
+		case 2:	__fn(__pu_val, __pu_ptr, __err, 2); break;	\
+		case 4:	__fn(__pu_val, __pu_ptr, __err, 4); break;	\
+		case 8:	__fn(__pu_val, __pu_ptr, __err, 8); break;	\
+		default: __err = __put_user_bad(); break;		\
+		}							\
+		uaccess_restore(__ua_flags);				\
+	} while (0)
+
+#define put_user(x, ptr)						\
+({									\
+	int __pu_err = 0;						\
+	__put_user_switch((x), (ptr), __pu_err, __put_user_check);	\
+	__pu_err;							\
+})
+
 #define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
-	__put_user_err((x), (ptr), __pu_err);				\
+	__put_user_switch((x), (ptr), __pu_err, __put_user_nocheck);	\
 	__pu_err;							\
 })
 
 #define __put_user_error(x, ptr, err)					\
 ({									\
-	__put_user_err((x), (ptr), err);				\
+	__put_user_switch((x), (ptr), (err), __put_user_nocheck);	\
 	(void) 0;							\
 })
 
-#define __put_user_err(x, ptr, err)					\
-do {									\
-	unsigned long __pu_addr = (unsigned long)(ptr);			\
-	unsigned int __ua_flags;					\
-	__typeof__(*(ptr)) __pu_val = (x);				\
-	__chk_user_ptr(ptr);						\
-	might_fault();							\
-	__ua_flags = uaccess_save_and_enable();				\
-	switch (sizeof(*(ptr))) {					\
-	case 1: __put_user_asm_byte(__pu_val, __pu_addr, err);	break;	\
-	case 2: __put_user_asm_half(__pu_val, __pu_addr, err);	break;	\
-	case 4: __put_user_asm_word(__pu_val, __pu_addr, err);	break;	\
-	case 8:	__put_user_asm_dword(__pu_val, __pu_addr, err);	break;	\
-	default: __put_user_bad();					\
-	}								\
-	uaccess_restore(__ua_flags);					\
-} while (0)
+#define __put_user_nocheck(x, __pu_ptr, __err, __size)			\
+	do {								\
+		unsigned long __pu_addr = (unsigned long)__pu_ptr;	\
+		__put_user_nocheck_##__size(x, __pu_addr, __err);	\
+	} while (0)
+
+#define __put_user_nocheck_1 __put_user_asm_byte
+#define __put_user_nocheck_2 __put_user_asm_half
+#define __put_user_nocheck_4 __put_user_asm_word
+#define __put_user_nocheck_8 __put_user_asm_dword
 
 #define __put_user_asm(x, __pu_addr, err, instr)		\
 	__asm__ __volatile__(					\
-- 
2.21.0.rc0.269.g1a574e7a288b

