Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5EBA18B3
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH2Le7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:34:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42387 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfH2Le6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:34:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so1434875pgb.9
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QZmd1kVLh8a0enxFfoIC/p5hW82ft4CjkM7ASI4iKD4=;
        b=gtKVgQDc9GJLsqxkdO8KHXtp476POxHclR4w6cx/eJloeqLLtmxIGGY7ToOzR9UfpY
         mtkJxWZmFxaWeQhYjV62uXXInNjF5dDf3djI1IZn1tEjn3YELqzx15He1/yBUkAa2J/g
         yVMauTVFsu9mNLCSBCkJ6jcqVA0VN6/sqzVXuvS61g0flUiw+pRqovwedo858JXI0stW
         K2gPSOtM1b4XhMfLMPiqGfe7kKMa2XLwpUKvz+ZtOKHEsTXbxzuhOcxMppZiT8t0HgNa
         JGxLu/qgJJgU0RhLcEK1vrGGYXoKvf5QIWb0p2jOHiYT8LLyW1KJdljpq4hkNtbUc5Xm
         BZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QZmd1kVLh8a0enxFfoIC/p5hW82ft4CjkM7ASI4iKD4=;
        b=HHJs0hCxghGPLwOLArn7hABzPu5uqtICREBYNo5okjWvkaOyBWUYlG4LfdJZPbwq97
         b4Z/5yFizdGqQUww35Z65pswOlr5RoKIH5biCdgwRuwirwLxIv8baXQY3XgVR9Ql8nIZ
         HqHJpeYaibnXllZdOOdhlqkeXUhaHyd3VZtsItjbx9AqRURwoFjfcj0y9Jon6rGS0cVM
         oXCpCNCMZv3H1f+XRKvZp18WrFFcCV94S7e2VpsGd0SlRG6BvgCpyI+tBjrFGnUZFfIA
         9NqxSNoFTRNEmMsPi+5kNIPdmzTzKbU35h3PU7jcXG6+OiXJ4H1Cl0iqxT+nPnISHkpw
         X91A==
X-Gm-Message-State: APjAAAWxgp7hyeWnIjXxLt5uL5dTssZEYCiFB+IJMc5cTgDhcUk0yxZa
        rI7IdrMOi19YeAfiw5o6IOns2LvYFPY=
X-Google-Smtp-Source: APXvYqwO22ljl8QyLHHOEWlyuVEGRkqUeNBwuzUvKpQv4Nedz3khH8mTN63Qx7dTcn8EznD5ND6ViA==
X-Received: by 2002:a62:1444:: with SMTP id 65mr10603079pfu.145.1567078497711;
        Thu, 29 Aug 2019 04:34:57 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id d20sm2784549pfo.90.2019.08.29.04.34.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:34:57 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 02/44] arm64: Implement array_index_mask_nospec()
Date:   Thu, 29 Aug 2019 17:03:47 +0530
Message-Id: <a01785b993e2b39864ee0cab09695ae23a02b2f5.1567077734.git.viresh.kumar@linaro.org>
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

commit 022620eed3d0bc4bf2027326f599f5ad71c2ea3f upstream.

Provide an optimised, assembly implementation of array_index_mask_nospec()
for arm64 so that the compiler is not in a position to transform the code
in ways which affect its ability to inhibit speculation (e.g. by introducing
conditional branches).

This is similar to the sequence used by x86, modulo architectural differences
in the carry/borrow flags.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/barrier.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 574486634c62..7c25e3e11b6d 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -37,6 +37,27 @@
 #define dma_rmb()	dmb(oshld)
 #define dma_wmb()	dmb(oshst)
 
+/*
+ * Generate a mask for array_index__nospec() that is ~0UL when 0 <= idx < sz
+ * and 0 otherwise.
+ */
+#define array_index_mask_nospec array_index_mask_nospec
+static inline unsigned long array_index_mask_nospec(unsigned long idx,
+						    unsigned long sz)
+{
+	unsigned long mask;
+
+	asm volatile(
+	"	cmp	%1, %2\n"
+	"	sbc	%0, xzr, xzr\n"
+	: "=r" (mask)
+	: "r" (idx), "Ir" (sz)
+	: "cc");
+
+	csdb();
+	return mask;
+}
+
 #define smp_mb()	dmb(ish)
 #define smp_rmb()	dmb(ishld)
 #define smp_wmb()	dmb(ishst)
-- 
2.21.0.rc0.269.g1a574e7a288b

