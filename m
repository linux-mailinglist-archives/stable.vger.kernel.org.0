Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916DA7D74D
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbfHAIVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33139 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731122AbfHAIVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so33613467pfq.0
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QT52cSxWVIebfDc1oGBa7p8CuPEmaq03dkPYlQrFIZw=;
        b=pilV4a1PZ7oAn8kiAPyEMpIAXatrnWAY7F56eSYPB9vrKy4dh5U8N9TvLKEbGs/trC
         gCp08Y6foQq6IHiA6lZOSHoJ6GRRFGq9rri/60LMEZnonPys5z/6SoXnZNJl65mFs7ci
         JJmSUxzGYnlU1VdgyralvPmw6VwExqh6And5XbOEm19Y4zpQ8SRF02sImAKc6nW5yDiZ
         GxV3IOIraRaflGL69TuNQCaZhm8vxrZbqpITFaNwdJKixpvFTRCpAsy9bhn2OggnWT/L
         3IaRBmLuHoo60PO01b2vc6dsTtslHml6G7AGm53sc8Nrlagct8eYTSp2XXwebHHH3mvI
         26dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QT52cSxWVIebfDc1oGBa7p8CuPEmaq03dkPYlQrFIZw=;
        b=OVYIOt6/KaGXTGIxeoPYaSE+p+SFWgGZZem3GyQsyUmsCQCtQa5Vc5qP7+vSdZMrm9
         F1cQJQKFnOdBCQisdPV8EoTY/0YYchR0e3wWCzoPr7Z+uEeZFa+5vwrhA45CfJR5xka8
         +N5AiuezJtzuWV3R0On2gEtu5o/KUQCOiZ51zEGj+q4XJUaPBOnE1TPyg5L1bIBRXEwP
         8qZmCqVU27rIKJ2j/lyTM6+FkosDycgC4/Ebb4JpJQSKMAZdx+gKfbjPT+UuWkjL52sJ
         2jov647anKrZREwEQaCMRR0M1x81C/XQGvdNFWKqdr7zzlZ/vvZO4LqY9wRKaiqhWkfh
         ewTg==
X-Gm-Message-State: APjAAAXJMHwPC+Vq5hcBfHeOipRohA/qndKArMbIkHAsOnC2plv9dfEM
        yktdkJxHerfBI3P5kTUXcsSMwES5g24=
X-Google-Smtp-Source: APXvYqxw/r6K9JzFk05Y40bsfHjiFIbz6DEqzJ1Bn+TrAgnfGxSab1T57zF2H7EyzRKqi+mVFuyHHw==
X-Received: by 2002:a63:a35e:: with SMTP id v30mr57674126pgn.129.1564647665858;
        Thu, 01 Aug 2019 01:21:05 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id p1sm76262663pff.74.2019.08.01.01.21.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:05 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 35/47] ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization
Date:   Thu,  1 Aug 2019 13:46:19 +0530
Message-Id: <56d194e7c07733a1cb99457e07067b6db64560ef.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit afaf6838f4bc896a711180b702b388b8cfa638fc upstream.

Introduce C and asm helpers to sanitize user address, taking the
address range they target into account.

Use asm helper for existing sanitization in __copy_from_user().

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/assembler.h | 11 +++++++++++
 arch/arm/include/asm/uaccess.h   | 26 ++++++++++++++++++++++++++
 arch/arm/lib/copy_from_user.S    |  6 +-----
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 483481c6937e..f2624fbd0336 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -461,6 +461,17 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #endif
 	.endm
 
+	.macro uaccess_mask_range_ptr, addr:req, size:req, limit:req, tmp:req
+#ifdef CONFIG_CPU_SPECTRE
+	sub	\tmp, \limit, #1
+	subs	\tmp, \tmp, \addr	@ tmp = limit - 1 - addr
+	addhs	\tmp, \tmp, #1		@ if (tmp >= 0) {
+	subhss	\tmp, \tmp, \size	@ tmp = limit - (addr + size) }
+	movlo	\addr, #0		@ if (tmp < 0) addr = NULL
+	csdb
+#endif
+	.endm
+
 	.macro	uaccess_disable, tmp, isb=1
 #ifdef CONFIG_CPU_SW_DOMAIN_PAN
 	/*
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 7f96a942d9a0..9a3b6de2edac 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -137,6 +137,32 @@ static inline void set_fs(mm_segment_t fs)
 #define __inttype(x) \
 	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 
+/*
+ * Sanitise a uaccess pointer such that it becomes NULL if addr+size
+ * is above the current addr_limit.
+ */
+#define uaccess_mask_range_ptr(ptr, size)			\
+	((__typeof__(ptr))__uaccess_mask_range_ptr(ptr, size))
+static inline void __user *__uaccess_mask_range_ptr(const void __user *ptr,
+						    size_t size)
+{
+	void __user *safe_ptr = (void __user *)ptr;
+	unsigned long tmp;
+
+	asm volatile(
+	"	sub	%1, %3, #1\n"
+	"	subs	%1, %1, %0\n"
+	"	addhs	%1, %1, #1\n"
+	"	subhss	%1, %1, %2\n"
+	"	movlo	%0, #0\n"
+	: "+r" (safe_ptr), "=&r" (tmp)
+	: "r" (size), "r" (current_thread_info()->addr_limit)
+	: "cc");
+
+	csdb();
+	return safe_ptr;
+}
+
 /*
  * Single-value transfer routines.  They automatically use the right
  * size if we just have the right pointer type.  Note that the functions
diff --git a/arch/arm/lib/copy_from_user.S b/arch/arm/lib/copy_from_user.S
index d36329cefedc..e32b51838439 100644
--- a/arch/arm/lib/copy_from_user.S
+++ b/arch/arm/lib/copy_from_user.S
@@ -93,11 +93,7 @@ ENTRY(arm_copy_from_user)
 #ifdef CONFIG_CPU_SPECTRE
 	get_thread_info r3
 	ldr	r3, [r3, #TI_ADDR_LIMIT]
-	adds	ip, r1, r2	@ ip=addr+size
-	sub	r3, r3, #1	@ addr_limit - 1
-	cmpcc	ip, r3		@ if (addr+size > addr_limit - 1)
-	movcs	r1, #0		@ addr = NULL
-	csdb
+	uaccess_mask_range_ptr r1, r2, r3, ip
 #endif
 
 #include "copy_template.S"
-- 
2.21.0.rc0.269.g1a574e7a288b

