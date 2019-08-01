Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63BD7D741
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfHAIUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44941 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbfHAIUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so33575299pfe.11
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q3Hwoo9R0gf8T8wycN6BweSX3iAbrjmdi48iA1QA7vM=;
        b=v8tPuBm6a8N9wJvJ6WAtxxYn28Qs2iZZ+IRbRYjgYx4IpcRLyS8mfcmqz0ytzoCpos
         jv/ffuYFA83lpwHniP5fhlZ/kXp4M11tAuygaRg5myeIMrI0qD/rxAxB27MRhzupZe+M
         ztLh+JDQ8NvxiNwGo4nApbsJ7fy4V8q8kKKPaKdaoGsGu/zjSHMfybem2XwIWx7RPEKg
         54NjDRDdLSpZw1taU2sXbgFmkRC/GEk0bCDtAIIXIb4BUwKjQYprsIXx9A6faIcBhh01
         LX4ZbPwaUAG4xSFQoW/swck/IwVK0wLaGDiUB0fZN0idxlNoOdpYJqsxB8SjDJV4oO5t
         QY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3Hwoo9R0gf8T8wycN6BweSX3iAbrjmdi48iA1QA7vM=;
        b=p6BBciPvd5ziBVL6/EHVtYzN1LijhyPElvcNjNua25ytM2yDiQbLtXaK9mHmtLc0EE
         XOnAm8NZa0LYEcI5gJSvK/KRsq0GkR2mk8EqVMa82dYItFpVPQGdxXoV1ThNmp4/llQv
         pFhjO/kWnasFU+Jol0aO8lPHozCr7EAcSviL+9uEasZ809RFSmfg6PAF6df0GrGXGFdU
         5HBsAcMg3CrR/1mbsCeFTQ+WalOPjhthU6xInP1gPEkS772RKYMsrtiiNfh6EhaaaHzA
         iGx0V5WbXfNdO8rZAzSlMWIcV1LeaZEonoeBcwdvkKLAAMc1MSnzjaGyoP2BPq6LiGUh
         H1Aw==
X-Gm-Message-State: APjAAAUhzBs5ZYyPMpxW6BtGxylhHeM6cLDat+uwsedOfzHCG/D6cWxn
        qwVdLtQvkS0rfobdQ1VS1kmpqvwwP7w=
X-Google-Smtp-Source: APXvYqw8AMtygXdme66bHjkErIZoCNT+9NxIrlMt51jVywqWqjAheNw422/KO4VB26xRqouz4epcaA==
X-Received: by 2002:a62:f20b:: with SMTP id m11mr52253396pfh.125.1564647645675;
        Thu, 01 Aug 2019 01:20:45 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id n98sm4013483pjc.26.2019.08.01.01.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:45 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 27/47] ARM: spectre-v1: mitigate user accesses
Date:   Thu,  1 Aug 2019 13:46:11 +0530
Message-Id: <86231c8cbaacc44285a235db704e1029ae8ec64a.1564646727.git.viresh.kumar@linaro.org>
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

Commit a3c0f84765bb429ba0fd23de1c57b5e1591c9389 upstream.

Spectre variant 1 attacks are about this sequence of pseudo-code:

	index = load(user-manipulated pointer);
	access(base + index * stride);

In order for the cache side-channel to work, the access() must me made
to memory which userspace can detect whether cache lines have been
loaded.  On 32-bit ARM, this must be either user accessible memory, or
a kernel mapping of that same user accessible memory.

The problem occurs when the load() speculatively loads privileged data,
and the subsequent access() is made to user accessible memory.

Any load() which makes use of a user-maniplated pointer is a potential
problem if the data it has loaded is used in a subsequent access.  This
also applies for the access() if the data loaded by that access is used
by a subsequent access.

Harden the get_user() accessors against Spectre attacks by forcing out
of bounds addresses to a NULL pointer.  This prevents get_user() being
used as the load() step above.  As a side effect, put_user() will also
be affected even though it isn't implicated.

Also harden copy_from_user() by redoing the bounds check within the
arm_copy_from_user() code, and NULLing the pointer if out of bounds.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/assembler.h | 4 ++++
 arch/arm/lib/copy_from_user.S    | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 307901f88a1e..483481c6937e 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -454,6 +454,10 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	adds	\tmp, \addr, #\size - 1
 	sbcccs	\tmp, \tmp, \limit
 	bcs	\bad
+#ifdef CONFIG_CPU_SPECTRE
+	movcs	\addr, #0
+	csdb
+#endif
 #endif
 	.endm
 
diff --git a/arch/arm/lib/copy_from_user.S b/arch/arm/lib/copy_from_user.S
index 1512bebfbf1b..d36329cefedc 100644
--- a/arch/arm/lib/copy_from_user.S
+++ b/arch/arm/lib/copy_from_user.S
@@ -90,6 +90,15 @@
 	.text
 
 ENTRY(arm_copy_from_user)
+#ifdef CONFIG_CPU_SPECTRE
+	get_thread_info r3
+	ldr	r3, [r3, #TI_ADDR_LIMIT]
+	adds	ip, r1, r2	@ ip=addr+size
+	sub	r3, r3, #1	@ addr_limit - 1
+	cmpcc	ip, r3		@ if (addr+size > addr_limit - 1)
+	movcs	r1, #0		@ addr = NULL
+	csdb
+#endif
 
 #include "copy_template.S"
 
-- 
2.21.0.rc0.269.g1a574e7a288b

