Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21143A18EE
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfH2Lgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33455 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfH2Lgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so1888850pfq.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PDeednBQHQCWJxR0NKh3z84Gd8kBTabHNB90hamsE18=;
        b=BKnkcJFk3MNXaOvdRyUnOTInsQxotc+5YsfNlBmVE3T89BFUfb0e4L8sFQDeK284l7
         /r4udJ6Sl2cdNixjixGH9bWI5UzZINAkYnN28hma252vuenUeUXIxzaFH2k6tCsNYgsq
         XIiGjsb9f5cHpGVLf0Zi6zL9cwSFVhPlSqbh828PdaAkEgVxOMDq2rt0Jm4Cp3tO+hew
         ksi7yWvIqiYq1hEPUSUrvV61FY55xhOKcLozcHwPv/WTJ1bRQYuBuaroIfcmg0qLl38F
         ojLlMS0ilQ1bLD2QDrzeIs927PecMnilw0p3Z0BWBCNBtwz9O08SyUgwW79XOxF7V8+w
         uA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDeednBQHQCWJxR0NKh3z84Gd8kBTabHNB90hamsE18=;
        b=Vb+q35Xp9pkuirn2Yntl5KqieFpJ48uw4clNjh9ZTgLYjh7MQ+OIig8CKSFk2eTcg8
         6Jq0dQX1Hobw/VTAuPNpSpBv6rG7w+lcX9gEwaBKYQ4oXWDCjZq0CLZ1OHBpW3gSPV5P
         E9WOLqnN3XZfmjqv5LOOSWDNWysO8vYIdhRytQSbVW0rX2E3xqe46agAgH6KU5BuZaBO
         X8++SnI6PcgRRuJsXeTl0yveQoWv9TWWQUXq/wnagRSD9MU3h9es/IQiYTpGRE0/3lua
         6wztwDIWJatxqG3G5sssznsxkyLXE8HxEAnkNo9T7rJSOW1GfYfnMo4PdVVRIgO1zjuQ
         TIZA==
X-Gm-Message-State: APjAAAX289xKFBukfaKsdGNkBs+5dUUiUzOh6XVYNtrxWFB1NaMcL4JE
        bMxg/2etjhfxlxwsCPJRnGDBaESnEq4=
X-Google-Smtp-Source: APXvYqzfTJ4KTAhULOXeqjcaWdsEDWsfY43W4OVpdguRKP0hjHTtCfnJmiRO8UFi+bPmQIHEQeZURQ==
X-Received: by 2002:aa7:81c1:: with SMTP id c1mr10453368pfn.78.1567078609375;
        Thu, 29 Aug 2019 04:36:49 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id k25sm5884224pgt.53.2019.08.29.04.36.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:48 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 44/44] arm64: futex: Mask __user pointers prior to dereference
Date:   Thu, 29 Aug 2019 17:04:29 +0530
Message-Id: <965d727955b4a45ac1f12e67c6a433110ef94871.1567077734.git.viresh.kumar@linaro.org>
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

commit 91b2d3442f6a44dce875670d702af22737ad5eff upstream.

The arm64 futex code has some explicit dereferencing of user pointers
where performing atomic operations in response to a futex command. This
patch uses masking to limit any speculative futex operations to within
the user address space.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/futex.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 34d4d2e2f561..8ab6e83cb629 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -53,9 +53,10 @@
 	: "memory")
 
 static inline int
-arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
+arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 {
 	int oldval = 0, ret, tmp;
+	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
 
 	pagefault_disable();
 
@@ -93,15 +94,17 @@ arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
 			      u32 oldval, u32 newval)
 {
 	int ret = 0;
 	u32 val, tmp;
+	u32 __user *uaddr;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+	if (!access_ok(VERIFY_WRITE, _uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	uaddr = __uaccess_mask_ptr(_uaddr);
 	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
 ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	prfm	pstl1strm, %2\n"
-- 
2.21.0.rc0.269.g1a574e7a288b

