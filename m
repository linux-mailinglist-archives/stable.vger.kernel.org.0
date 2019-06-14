Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A4E45260
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfFNDMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43793 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so661562pgv.10
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QZmd1kVLh8a0enxFfoIC/p5hW82ft4CjkM7ASI4iKD4=;
        b=EvZ8YJG4wMc9LRAO6zkuZDB6vSMjpc5gH6HrZCzProPQlk2T5U44R+xBWLpmPhGOl1
         EYtvILwKXnEhHhYC4hhnw0FLXZWT16beuQnjDfHqyhxbcF1goUL0Fu4gXpO1oNVzy5gi
         2gzTcM/BWmzycyhn5rSzl9dP8Jkw9xDSdvIMLeHKQVYMDAgVH/bo2yXFqIYo8r3Ixml5
         HVm8knVEon61EpTiy1YxUfObhlo4wvz+shhRrnO5/g3U6lYwZV/lODFQCepgLvFqGced
         AO1fcHmxMHwR4NplGJhXum/Ogb6ZdMDHtvWtC0uAePx4nzM2LU2xR6nIFcuf7NdLI1SF
         z5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QZmd1kVLh8a0enxFfoIC/p5hW82ft4CjkM7ASI4iKD4=;
        b=iY6Wp0H4FBE13PrTnxf2+ScDbuHVm314LkdNS9fboLe6zWo8sU+VtpGhq7Js/rGKpP
         LHS0o/hH7PJNTkFk4R/O9BN0Qh1UICMJMNpk6NKO90TPYI9U81msb50b5FoYcbFhBkdD
         W7tkzF4PjHNmaC5dp26lcwPWARbKvKWWI+AvnigroOedsqtV3ffJk4n3Aj3AXwoO49Wi
         3kLeJnh47NDYF/c6qf5RgAWquE0gOkq8XdOSGo22v7GahWfPZ4JR5ZWGiRrkJk6eHP5T
         kH+xTwISYOQEeRjIA5xMXN3uz3X+PikoiJ0HXXd9y47uK3q/YJQu7YG4+zGZhCOOStJt
         odZA==
X-Gm-Message-State: APjAAAVJBB7KeiWw9M2myZB4QsFAeZTLEruJrWaVxSXEEk+gvuHoVEp6
        yG/Yyj9e1P4KElumJs3YtJtL6Q==
X-Google-Smtp-Source: APXvYqx3siDfJdE96lBsZdB9DtFQr1ZpNWzKGo5dP44HA8C8Ry/tMqyMeRfDgDx8gJYyYbwGnrGPXg==
X-Received: by 2002:a17:90a:8902:: with SMTP id u2mr8561016pjn.96.1560481919775;
        Thu, 13 Jun 2019 20:11:59 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id e127sm1035402pfe.98.2019.06.13.20.11.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:11:59 -0700 (PDT)
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
Subject: [PATCH v4.4 02/45] arm64: Implement array_index_mask_nospec()
Date:   Fri, 14 Jun 2019 08:37:45 +0530
Message-Id: <3f1bc5e6cfd1d72a2e3612aca52a3811f38332cf.1560480942.git.viresh.kumar@linaro.org>
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

