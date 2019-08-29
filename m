Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A339A18B6
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfH2LfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41652 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2LfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so1438120pgg.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oplH30x1zLW/kw5XTQuFI7s72sVvdi1RahKBb4zAIVI=;
        b=Xf1eInn9bQckSytjmO3NZ5/eRTeKWleC2WOGzywPePMbSDrayr5Mvoh1hJJ887odiD
         +uxT7jS9wwYMnJs+l8+wkk+nrt7MjwJhkrzIxqo5TPyhhYIhJqUcSnUt1oHQurOV8I0D
         PnDttS+g1ESZBtPXTLFjE4Go5uctTdGolkIWNPXVhwhp4iDHldgEpjd+1oceDm2jOPE1
         W+s+s4ne77To9Cwp3NuAv/YSwYJ1V/DAaz+vkR4cK0rxOa0W4vE9G9/QI22rQxrq6+nL
         9eyE3wvQitkt67/4NRHaOY4izkTpKZ9zJkDWO5JPe8b86kEXl8PWIPfXeehgxMgfXAdA
         gy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oplH30x1zLW/kw5XTQuFI7s72sVvdi1RahKBb4zAIVI=;
        b=kupokG1LM4mQFd2l1D1pp6gkqPE3F70KytZVvslRusprd7gzzZ2Z+6fgJn3zdltihX
         oDkbWv+7P/aSxe6mspJaAaZukIJF0iae3hSlSmkhpKXQJt0xGKqGhRqro2OlJdsV3pmC
         dhnuWlc8v6qwHshLmcA7V6e0MCTaYFXwpIdTXN2yClIpqa8Q+he4D0/U+IWKIULViQGk
         L1/bOIY+mYIvnVxpYA3Pd8x5uId3XsvTJoML4imf7uObOmo7bzn7mgtPnN+TrdHB3VoU
         nE/j5tuTrdEKqZl+49LgGLMaB5bHiYjd9Txz68kKF6yAbKB4e/V9XIgf6WziBH+OSld/
         bZ/Q==
X-Gm-Message-State: APjAAAUTF8zS3/fjrgYDODWhUbLRQrxLL+GGIooaz5HZDYpQHu8JTrdT
        zWH0ZkmdfLvUta/C3VhKaKlESrwctLQ=
X-Google-Smtp-Source: APXvYqyPp6Af2woejDXifmiwTFcO10cRM9AxOIZl5XK9s7/OHnjwlap+4+uUEbC5/+ahBYM/O6VUwg==
X-Received: by 2002:a17:90b:14c:: with SMTP id em12mr9062547pjb.22.1567078505451;
        Thu, 29 Aug 2019 04:35:05 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id k14sm2591617pfi.98.2019.08.29.04.35.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:04 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 05/44] arm64: Use pointer masking to limit uaccess speculation
Date:   Thu, 29 Aug 2019 17:03:50 +0530
Message-Id: <f26c719baa5df560360fb3bbb7483385dd5cb821.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 4d8efc2d5ee4c9ccfeb29ee8afd47a8660d0c0ce upstream.

Similarly to x86, mitigate speculation past an access_ok() check by
masking the pointer against the address limit before use.

Even if we don't expect speculative writes per se, it is plausible that
a CPU may still speculate at least as far as fetching a cache line for
writing, hence we also harden put_user() and clear_user() for peace of
mind.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/uaccess.h | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index c625cc5531fc..75363d723262 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -121,6 +121,26 @@ static inline unsigned long __range_ok(unsigned long addr, unsigned long size)
 #define access_ok(type, addr, size)	__range_ok((unsigned long)(addr), size)
 #define user_addr_max			get_fs
 
+/*
+ * Sanitise a uaccess pointer such that it becomes NULL if above the
+ * current addr_limit.
+ */
+#define uaccess_mask_ptr(ptr) (__typeof__(ptr))__uaccess_mask_ptr(ptr)
+static inline void __user *__uaccess_mask_ptr(const void __user *ptr)
+{
+	void __user *safe_ptr;
+
+	asm volatile(
+	"	bics	xzr, %1, %2\n"
+	"	csel	%0, %1, xzr, eq\n"
+	: "=&r" (safe_ptr)
+	: "r" (ptr), "r" (current_thread_info()->addr_limit)
+	: "cc");
+
+	csdb();
+	return safe_ptr;
+}
+
 /*
  * The "__xxx" versions of the user access functions do not verify the address
  * space - it must have been done previously with a separate "access_ok()"
@@ -193,7 +213,7 @@ do {									\
 	__typeof__(*(ptr)) __user *__p = (ptr);				\
 	might_fault();							\
 	access_ok(VERIFY_READ, __p, sizeof(*__p)) ?			\
-		__get_user((x), __p) :					\
+		__p = uaccess_mask_ptr(__p), __get_user((x), __p) :	\
 		((x) = 0, -EFAULT);					\
 })
 
@@ -259,7 +279,7 @@ do {									\
 	__typeof__(*(ptr)) __user *__p = (ptr);				\
 	might_fault();							\
 	access_ok(VERIFY_WRITE, __p, sizeof(*__p)) ?			\
-		__put_user((x), __p) :					\
+		__p = uaccess_mask_ptr(__p), __put_user((x), __p) :	\
 		-EFAULT;						\
 })
 
@@ -297,7 +317,7 @@ static inline unsigned long __must_check copy_in_user(void __user *to, const voi
 static inline unsigned long __must_check clear_user(void __user *to, unsigned long n)
 {
 	if (access_ok(VERIFY_WRITE, to, n))
-		n = __clear_user(to, n);
+		n = __clear_user(__uaccess_mask_ptr(to), n);
 	return n;
 }
 
-- 
2.21.0.rc0.269.g1a574e7a288b

