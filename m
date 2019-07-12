Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F7966625
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfGLF3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42695 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so3992189pgb.9
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oplH30x1zLW/kw5XTQuFI7s72sVvdi1RahKBb4zAIVI=;
        b=eaes5zcgp44lXt6A5g4+fUxCC1ls9h/X8hAy28QuZtZMD6AhLT94Fh11hOM2uLjsaT
         obGqKrqcKmP6ZW+32H2nZ7w2JwPPtS4yBtSNQMCAAQD8Pu+SGM2kfXPurwyUrM25/bX6
         LvSH7O2WsNuUTX6AmZ2BWi4PlLRGTfdvNTmGZIyL6k4ZgbDqhRRrqbYaWBXOv+Df2pTn
         LMbeKC/td9b+cPHPvrv173y8fJ6gCLUUKudhxCo09n1btwp/ZFR1i7tQLMGpyqqs/6S8
         2akxlq9oUecJlXcLc/wWJtAjUbaPZQpg+3BrBAHeQR/PGKy380/KeFy2yB/E2mvylW1o
         VlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oplH30x1zLW/kw5XTQuFI7s72sVvdi1RahKBb4zAIVI=;
        b=YzWHSpQ0ssHnQ4C+xS2hgXm5y2loO3L52nwCdxKUiytqrWFOl3IaTcAwX0iY9TcLqt
         DixvwT9Ns+Jwt6pPbXrTVUY6sf+FrQ1saWHfHCNbzy69U0WkkipTY9kC1P1u3twtqYsS
         eEvg22QhSSCMXmcX4QsI4W6Of/36conBWaMJ3LHw3vsx+nvjNcB7d4B3Ux8z1HBxP+27
         tgCpaMG2JNCfxzJt66VH2OvZ1c332bXUhIaChu0KL8dLhRzfRQwq3NmFBeGceJyp225Q
         KAoaFvWF5QoZojvbINlkTCGnL/qEhJ4lmCIu/sudgoegfDTG4FjzwgMNqzDYr/9YTRaF
         l4sA==
X-Gm-Message-State: APjAAAVkdL0Ca0HO2t+FnjOsWD/ahkK6RMTNQiWnxOJB6598ztjQGuUX
        Oh69d0YMyUvWXRe5D59VTdPNyix1bDA=
X-Google-Smtp-Source: APXvYqwrNthjqBlV/RL3WReAfg5hBYhOgQ1sTUVcjfhA0FjZyQO3ukp4Tkq5AsBP1XdlXm5bE9jM2Q==
X-Received: by 2002:a17:90a:d151:: with SMTP id t17mr9328073pjw.60.1562909353263;
        Thu, 11 Jul 2019 22:29:13 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id r9sm10746373pjq.3.2019.07.11.22.29.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:12 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 05/43] arm64: Use pointer masking to limit uaccess speculation
Date:   Fri, 12 Jul 2019 10:57:53 +0530
Message-Id: <99d86496bf2e822479ec7f26faa6a6d31d4e5524.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

