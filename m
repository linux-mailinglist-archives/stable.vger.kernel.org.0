Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E111845268
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfFNDMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:19 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36175 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id w10so185551plz.3
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lt3w372XAiP2T5A3AE8p2nBAFVuCKsgxbI6J0UJSdP8=;
        b=ARF6EuIOrYoCPrmP9r2NO8meY7IeSPACptb2qiSC3sZkkfZa+YnowaYv5BXUGvg14G
         C6EkcuPeGocTfXv3Ut4XUoAz74Qf4c/opqiS12y2PM49RuCirdTuRfuexd7PCUPelcWM
         seJw+buAjTHBvaLeXrb//UjwS3FIMYl+J0ppj3mNRrBFUjiV76zkc/cIeqUYJrMLNiQK
         Y+o4x5bUuJEAKR+I26nOky6nQqJVT7l01L7J+YkEL/W+Nn8ihvvgxos25+rssBLI28Qz
         pGM5oTBZTZ7Amfmd7RlRVOjJZNYjzjF09r/6nTXVZKIOiFQM2FgaLmhhA/lsVMGV+uFf
         3vEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lt3w372XAiP2T5A3AE8p2nBAFVuCKsgxbI6J0UJSdP8=;
        b=bBdbalL0NtOS05raNvpNZa184AJB4qztYb8lnl4hpxvcu4/5+qdh5/zfoqU2OQ92ZD
         7XUTRvK/v/qGs5axN+Gcp8SGFkCW0DIt8r3t246wy/Jzlp36g8Is7sNmuJzoTGz2RR39
         W9Pi7oDW7SfjAGJciaSFiECoOKNv6HQydBDe//d9Qpmh5/uaUIRY3bP23Ix/U9yllD6x
         p8xVn05Phnx4jy83HzetLKfKJ5lIbS146q9NS6ArkHuGqRo8AbrtuFnqvUyowuKBNizM
         8hqqD4N8eO3UatJUJqs/ZbXSfM07H4v3pUjaaa/PwLW6SaoSwibcW/5DyJtrL3u/F/Q2
         QOSg==
X-Gm-Message-State: APjAAAWsEI3jS0A62bkJLyR5+XDqqUQkJx1JJhflTsOD6BuTaI/3G13c
        wUEpZiMd1Tfq6SfioZVbR6oFrw==
X-Google-Smtp-Source: APXvYqzAxt+yHjCPKcMN7grBUo0yD6uicPzJ1mS+f3xeNkDpNWjg+eJV9ltR8uRyWXwrp+/RwXgwIA==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr86998560plb.314.1560481937851;
        Thu, 13 Jun 2019 20:12:17 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id k20sm1051646pgh.31.2019.06.13.20.12.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:17 -0700 (PDT)
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
Subject: [PATCH v4.4 09/45] arm64: uaccess: Don't bother eliding access_ok checks in __{get, put}_user
Date:   Fri, 14 Jun 2019 08:37:52 +0530
Message-Id: <fa281cb205c71d33bc2d9f971717d4073409f43e.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

