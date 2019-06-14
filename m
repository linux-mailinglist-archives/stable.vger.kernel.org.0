Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C9E45264
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfFNDML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35932 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so499782pfl.3
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oplH30x1zLW/kw5XTQuFI7s72sVvdi1RahKBb4zAIVI=;
        b=Yzltk8JB8mBXf0jZiiOn54g5/T0KcQ7kKV+UgQ9lpUwSlLs7Pt5kZUz7O8VRM5Gywr
         a6759AUaffVtNH/TQGwSHY5oA17fJKXMnvPoFyntQBTfIscQNfo17nFck1DVJjrDtGmA
         +OsNTrb2LaV2WQoX5sd/qPiJek55dGs814vb4bBwWTlq1ot6VHkqG7m98hfa/cY12zOZ
         NVjM5NrthLLacQzOfmEqJDxiugx32DoJGjZw/qboBQpDb5iGkEpwkxHwzJmyDijrFmnK
         zlGHBFAbNvl6JKVjnyBkeDwcgVbmq34wRQMm7GRnJ59Qelhe/pLC0cpTAsYd2dtksl3m
         bQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oplH30x1zLW/kw5XTQuFI7s72sVvdi1RahKBb4zAIVI=;
        b=gxbg4wdEJPL7LAHOOen286EmXDz1Ot08WA4YDWzkDYAksMftUWLDhJ1jfbehxqRUkj
         2z9yzeuBRyzbNMfM+aijXiK+Z43rjqS6enhmBx+Aa5W7rEk/clYkZsq561BYZve+hFzh
         xhYBu1vz0NxEVXH8iqO257kZGGk0Cleauy5C+2Giq13wukkI8C13RnWpwG5l5+aYcjQZ
         xUk/CskgK/ZDIjRHepBb0qouvxirPKn/w/bI7rqnmgiOd7WhnVMCFUuDhP5wpSFctxvt
         s7GgOB+awEQYkV/mww7iG2/FMvs/8nnXZ7SvQaYeSNJt2fFg7eOLOXC5+34B/F3LPBZ6
         GGpw==
X-Gm-Message-State: APjAAAW0CLpmvCxZcRE47ZVbVJtKFzjQCaCHJ1nvkGkW4boegOxx8621
        6PeDgE/jCFKa42fX1AzbPhkfnA==
X-Google-Smtp-Source: APXvYqy5wJDFGT5CTVHTGOqYSsSzofcsN1zQjCYusln8vRIdY/+WOc7URnCgUo7C85NDttUzgH3b+A==
X-Received: by 2002:a63:dc15:: with SMTP id s21mr34323601pgg.215.1560481930079;
        Thu, 13 Jun 2019 20:12:10 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id y1sm1198391pjw.5.2019.06.13.20.12.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:09 -0700 (PDT)
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
Subject: [PATCH v4.4 06/45] arm64: Use pointer masking to limit uaccess speculation
Date:   Fri, 14 Jun 2019 08:37:49 +0530
Message-Id: <33a351b8683ca17c3d6ed3711d2c6fe2ae1a36f3.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

