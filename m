Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965D766655
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfGLFa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38165 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so3797051pfn.5
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PDeednBQHQCWJxR0NKh3z84Gd8kBTabHNB90hamsE18=;
        b=fg+1pG/65q1qXXBewk6qvQ3fXz3wzzkJ7zUevy8Y1aRCJChOX+8X7X3JDJPcYtWKI2
         VO4DcEBZ9cyrhoulmGddYbjt5ggPKQHxtm8F3clPGhci3I1aXUQmLQJRB7Ezb8gl8fLi
         FhkAa/BV2XsSz+9MFltsJX4GzpC+8DMP6ODQsCzXh5nf80aw/2plK5nWH5JiYQ2ocbn1
         BaKR8GDvosIPOqJOo7vrd6f/ByVec4o3rRBqiMJ/jO7ZzqAfXXTufXDJ1StpfdiAn6gi
         cnMvgYBDyPFw+RExwgQW9uLq9kLoB/Z/shDKW1HTqmD70MPowKwbZVLiMB0qfnwh/Hw6
         +TPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDeednBQHQCWJxR0NKh3z84Gd8kBTabHNB90hamsE18=;
        b=NrZNThsBZCrTnhDPsGN5xaCQp9YSeCsAlfyPTRo9fGLn/a9fvajIK5/rRtN1Awhp57
         wQcA41oOkq/uwkDxORmvvOLilyRl+hwmsqJUt0qy7E3aYO/coZl8pqU6Bu6NCy9qou3K
         EcDwZD+jd9DrJiWawPPSPK3PQ8T2Qpp/duxUarGrFw6JH/6UJKO4ZrV+DUbDS2rcVwzs
         FCA/e394HyFC/Hs/E8uUfqrFLoVgvHPHCs+ybOHvNwUntMkxL8Dqqv4jBEjBYcGx9Tg2
         ssBY6IjUfK4wwRGaVNRwREBPr80meNnS6wNZTzIK1oKk5zTyMqZCyswXNhVDU4aHRWio
         N2dA==
X-Gm-Message-State: APjAAAVTH5lZ+rRXg8F3sKKRI1px3Wj/pLUsnwtZbK4GDEa7X6mGYr5M
        ZfVkFjyOtp+P+yH2k0wULjGtZnv/rIg=
X-Google-Smtp-Source: APXvYqzW2ZFdIDBVTYKNu8BFlnnBclltK1PVkRmVauZ0T/9ZSkmOtGZ5z0BYckQlNm2+hJU6Y866SQ==
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr9448970pjs.73.1562909456962;
        Thu, 11 Jul 2019 22:30:56 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id s67sm7989665pjb.8.2019.07.11.22.30.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:56 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 43/43] arm64: futex: Mask __user pointers prior to dereference
Date:   Fri, 12 Jul 2019 10:58:31 +0530
Message-Id: <dfed1476d16176056ead7c124c75895c10937969.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

