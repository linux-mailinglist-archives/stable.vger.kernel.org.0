Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD9A66621
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfGLF3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44174 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so4186401plr.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QZmd1kVLh8a0enxFfoIC/p5hW82ft4CjkM7ASI4iKD4=;
        b=JprPlE3jWUXLSHH6IEYKpZVLFEmbjwTJ1SlcNpUv0d1GSCe8JK/f0tNUq3RBbyxDEh
         YaDWpMtRy3kUkllP6k3WuFY7bT6cKPm4KygCT/04Oos2vO+SVgCzlgkPuZ6Xu86jBZYL
         +joRbYQT8HwYfhxbbhQOeFxZKodJnr7G//LB9Lgd6sS6X7pnWILRwWrvwv7pwn92phHu
         2BN/4SfoVMRM1fdlzw8BG9jH+cYIHFnui69Xb6O7cq93/IiqXBB7NpgD6CYe2XA87Kb0
         /vcznTUHRGLdUeHKNW20eSp7yGm7eew+5xU0ZVYuqZO7qU5Kqb4wNcP5DHcXhFQGpWi5
         YpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QZmd1kVLh8a0enxFfoIC/p5hW82ft4CjkM7ASI4iKD4=;
        b=LZbVTkiTdDTvwVtCmkIw74gX9ve0ymqh4Moxka8OBhpCC3LhmqJofSC5jdwJxgaIoD
         mgnF4FDQtWGXjULE0SPTaHSdMHvSjBUKPmfNbhf3f71xcctuMWpbsRAcRyVzvkuy93g7
         C7I0v3s8FKpkSOQWvx0C3ElXAKPHuVjYqd7+XbOztBD75GZS1gv2OHFV/DJ9yjgr0GWS
         PFSa/eaadpWEpD8u3cICteBxNAqKWdbtkN1DWw23wmBAyi6OFcwVgAFRy6uOBu60UnB8
         OrHc8Nh2Q4XVWVRTteWKneu8jIfswmPZsUHC8CPKuNBPioYYUbWS0POWumVYRhJwoBdf
         qO6g==
X-Gm-Message-State: APjAAAWKTa6Hc8W7jsZPM07AHiJGr4Ts9u/3RGC/HHt+UU6Ya2Mb3Iqc
        9uhdBmbifLBN5LNC8mdkEtyFBY95csY=
X-Google-Smtp-Source: APXvYqwHFaJB9Zpe8zTLxMInqnlwGqfIubCK1hUjti0PbcCUDUDRHDy2zd/5RP37X/vJwDpSxuvK+Q==
X-Received: by 2002:a17:902:7043:: with SMTP id h3mr9559497plt.10.1562909344101;
        Thu, 11 Jul 2019 22:29:04 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id b37sm14696355pjc.15.2019.07.11.22.29.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:03 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 02/43] arm64: Implement array_index_mask_nospec()
Date:   Fri, 12 Jul 2019 10:57:50 +0530
Message-Id: <271b3de6a35cd1d184f8c0a21afc0d801bc0b250.1562908074.git.viresh.kumar@linaro.org>
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

