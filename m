Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D757D73D
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfHAIUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:42 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42905 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729760AbfHAIUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so31902830plb.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fgFpO2t01PxhbBlSjah6QrAfkGefLJP0TJCP7weC9qM=;
        b=byvD1gfBsJYYwf5gTuTCDAMb2Ei2f+ddF+FWpNZAOA2FK8nZ3lY/xQ3L6+pqLTCQWx
         S419flQUmSiXQRBMEvOXH7UV/bgf26Xjr0Bt+Am7fJ2KQSVDpuC503n96UEm94uFhX5O
         w9XiAi3qq8Get9zzs1H4q/KVzXYGYhWxOZUJtDPKKBoCMRYrKGT6sVqC8rJX2m6SGbCw
         HJN0yK5KZua6FArn2rWUtxg2hKobGdHn/QAUGFWTZcAThBEitj76Ohj1/xZX1NGznLVu
         bQeaVIEiM0eIDVmu+2/51NGFyncA1KEPNvWvA8OCSS4LQiFKYDINluM5u+BuLJanTATJ
         Pezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fgFpO2t01PxhbBlSjah6QrAfkGefLJP0TJCP7weC9qM=;
        b=ezOhc2gejSXNfIM/YCq8rB5LvqDojYbZbXBxTylMiXEqX0FtZvKQAu55zkZgZcQErO
         XlWh1rOSi6RlBSPyTKaAZWmFAYzVXBL72m4qcYzz1TpPOqR9yjsL3R6YUCE65ExBbfOm
         BzlYZwIj3TmzPMgvkypbzL/Z4FOo1qKejaBYzcnGzqGCcZ93YYzWfvLBBNLsbEkkuS9U
         2qrp2XiXj6cchuag2ZzuhmcEy62y7uIG5fnmikzfiR9DKPsI/Sj8+vYHwt990JxHOcb6
         iyif53PfHhZdoClSJk362wLbqlL1SCXBDa3OtFOmGiPnWft60KO3g0kbQfEXMIhIrJt7
         8cTQ==
X-Gm-Message-State: APjAAAVeh4ut3qH3MpLabGa0Akp1FySlYVOlJkS31D0tARqBWou9ovM8
        u7WzQW+YHLMcrhYYuOGjalYkW1aQfEQ=
X-Google-Smtp-Source: APXvYqx0aQyv9uox76KcN8c63PWcRqTbkztruBFEgMQ41KRiCS37kpJSbzgLdlWeCGAHkE+43u5UdQ==
X-Received: by 2002:a17:902:a9ca:: with SMTP id b10mr49835975plr.69.1564647640760;
        Thu, 01 Aug 2019 01:20:40 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id v12sm3709247pjk.13.2019.08.01.01.20.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:40 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 25/47] ARM: use __inttype() in get_user()
Date:   Thu,  1 Aug 2019 13:46:09 +0530
Message-Id: <ee0c1251878b2ebd4da4bead196caa950274e98c.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit d09fbb327d670737ab40fd8bbb0765ae06b8b739 upstream.

Borrow the x86 implementation of __inttype() to use in get_user() to
select an integer type suitable to temporarily hold the result value.
This is necessary to avoid propagating the volatile nature of the
result argument, which can cause the following warning:

lib/iov_iter.c:413:5: warning: optimization may eliminate reads and/or writes to register variables [-Wvolatile-register-var]

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/uaccess.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index cd8b589111ba..968b50063431 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -122,6 +122,13 @@ static inline void set_fs(mm_segment_t fs)
 		: "cc"); \
 	flag; })
 
+/*
+ * This is a type: either unsigned long, if the argument fits into
+ * that type, or otherwise unsigned long long.
+ */
+#define __inttype(x) \
+	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
+
 /*
  * Single-value transfer routines.  They automatically use the right
  * size if we just have the right pointer type.  Note that the functions
@@ -191,7 +198,7 @@ extern int __get_user_64t_4(void *);
 	({								\
 		unsigned long __limit = current_thread_info()->addr_limit - 1; \
 		register const typeof(*(p)) __user *__p asm("r0") = (p);\
-		register typeof(x) __r2 asm("r2");			\
+		register __inttype(x) __r2 asm("r2");			\
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		unsigned int __ua_flags = uaccess_save_and_enable();	\
-- 
2.21.0.rc0.269.g1a574e7a288b

