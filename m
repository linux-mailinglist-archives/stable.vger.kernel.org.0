Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A883A18C9
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfH2Lfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42079 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfH2Lfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id i30so1854585pfk.9
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O+J5pz+r7c0NpS1D8X6SYhx9QHuTsDp1UjRErYyLM4s=;
        b=oZTPTec0QCZyIdYWeoFDwwmLFP9g4lc0dbPQ/YV/Da2dsknHe6hU0UrVQ4lKyjcwHL
         ythaQ75viCx336XmpgjZGoZvhFyjdwlsqgHBHvQk9PBGbD8d4drBBMLFsOTWEUWhVV1T
         ad5FhTlYfhoP8xBkXaztzU1nDsDlDYbVbZ0uSEPlqF63pwu15tJl3IxJbzE6xsrg07M2
         mAqCLPLR5a5s5AxsLhfs2ki+B/4gTV8AqSfT1mlyNowc+oBuTifKnCT1XSZAaIFJeGAi
         oPFzIhprwBPwaEt8QRs226mpGYFBXaFhdXyv+O2ggl7op8bq3FLoQ5KncK3dPUrJgaP2
         IIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+J5pz+r7c0NpS1D8X6SYhx9QHuTsDp1UjRErYyLM4s=;
        b=MRgjcP3XVSkd0kQ6q32witFCAvzOjzeuM0UVhrlLW+VMrQHntgfE+EVJnyfJgniWBx
         74GVnBq7FJkH2s0ZKCQ0n3w9RYKl/oOcRVNh7BLH5eEp1J87CucU4jZ8yGkL5O6tddxZ
         gkEFUwedeiz2aB5NJ6TYRQjc0FYUFMgXmJ/TH3ckOltjmiyxuZ1HW2J1WxSNpGdE80AZ
         fnCQc5crzib8rL8gEBOKYLwDkhchru7yS6GnA1ChbvBBqEMOEDaUdRt3z5aMTDRLLZQK
         vYDoUn4/Sf0axQMIs2088CC27yn+66/KeXc2FdQyd4MQeh1kOLmGtrgoEBSAMjpbAg6E
         YK/g==
X-Gm-Message-State: APjAAAU+rFm/70TEXRoSz9/djGh3UyCi8Mgh6FiDS/GtMppU6rwEI2DM
        NCGVkY2MBDuHer4qG/T2zmmXfTByHcw=
X-Google-Smtp-Source: APXvYqx5cCyndVp1fjZUj19TweYqalLGObVrAA+gqWLeEFI9WssBPr4NWZ3xDid0ZnGQQ+4pZYKEWg==
X-Received: by 2002:a17:90a:77c9:: with SMTP id e9mr8828325pjs.141.1567078531812;
        Thu, 29 Aug 2019 04:35:31 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id z16sm6800192pfr.136.2019.08.29.04.35.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:31 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 15/44] arm64: Add a helper for parking CPUs in a loop
Date:   Thu, 29 Aug 2019 17:04:00 +0530
Message-Id: <a990b94f1fa5ec079a180d333e3d0005e2e7f5ed.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Commit c4bc34d20273db698c51951a1951dba0a722e162 upstream.

Adds a routine which can be used to park CPUs (spinning in kernel)
when they can't be killed.

Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/smp.h   | 8 ++++++++
 arch/arm64/kernel/cpufeature.c | 5 +----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index d9c3d6a6100a..53b53a9b3e5a 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -69,4 +69,12 @@ extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void cpu_die(void);
 
+static inline void cpu_park_loop(void)
+{
+	for (;;) {
+		wfe();
+		wfi();
+	}
+}
+
 #endif /* ifndef __ASM_SMP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b7f01bf47988..4adf18307568 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -868,10 +868,7 @@ void cpu_die_early(void)
 	/* Check if we can park ourselves */
 	if (cpu_ops[cpu] && cpu_ops[cpu]->cpu_die)
 		cpu_ops[cpu]->cpu_die(cpu);
-	asm(
-	"1:	wfe\n"
-	"	wfi\n"
-	"	b	1b");
+	cpu_park_loop();
 }
 
 /*
-- 
2.21.0.rc0.269.g1a574e7a288b

