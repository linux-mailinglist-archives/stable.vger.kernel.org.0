Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5872A18C8
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfH2Lfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33201 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfH2Lfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id go14so1457264plb.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZERHer/S6V7v3IyXGHBRQXsjn5NA4nSXv7B2aoThKNw=;
        b=IKKCbODsWP1UqJxIEV6Bfp2AqAC3Q/r0uWJ2QI9EEp/nBCW8Djdn6c7BX718jtGwOK
         t2V3BjtDhWGc0pHePPoA+TpkuzPHNqqWDJkDTWfCI5+csokkit/xYobK/zw+XyD5u+Jm
         u9DxwOHZgmfQHbVa/myrVi16KRIUDEalhL7WqcS8a3ss3gKo4NC04T6Q5l5lSOH6TD5B
         PnbN78U/TyeB30y0zFag0X5UjTq6lH1/l2CJe3dUqicd3gyn+LohzNokaCtUQLoWNCTO
         ICeige/+bZxebev7udCVlGwl634g0ngiT8vQvelsTWSEn7l14fz1FRG60iF20bFpxFOh
         9/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZERHer/S6V7v3IyXGHBRQXsjn5NA4nSXv7B2aoThKNw=;
        b=fF4R6va7RoSYCy5zixpM+0tsVoN4Sp2WJuBN3bfP+eOncmBokmoJwcTPjmkhHh6NbN
         UpsvFzfrSWfSyGt49rbrlnxD/ywTtQhaGGa/aazLXLKYgmXCoRpu2bI00taJwcAdqnif
         EDCrXYeIbwsHYBAtWKUDOui1HPR+4GPnAiNDr9uIeg8pVDoh5ir/EMqf2wSydJODh982
         bwMkuTy/yuZy5ICsGcXYbAI/E7G0b4CNDRFdkTS43g4Qeoqt4gd9k5X2MznkaA2v5IUt
         VweT5cGco5IwOp5ICExWh/gbakhdosHcx91CkqD2mtz3GR0k7rYvgYEZp4U0u9alB3TO
         3Otg==
X-Gm-Message-State: APjAAAX4Al195z6+ijpyKLbZoy04V+Mf1jM4ojVcRZGDqlqd6QGsnMM/
        fq9dqYG4KlbKdBdTZxUGQ8CFXNwIqtM=
X-Google-Smtp-Source: APXvYqzeb/3nmmVEBvXKtWKMiKGmBJPB2z8T6hw2Cr3J53pmgf5VQRlmQ0+5ZQYsmBnmLAV2pbABpg==
X-Received: by 2002:a17:902:d907:: with SMTP id c7mr306952plz.126.1567078529021;
        Thu, 29 Aug 2019 04:35:29 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id a18sm1855103pgl.44.2019.08.29.04.35.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:28 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 14/44] arm64: Introduce cpu_die_early
Date:   Thu, 29 Aug 2019 17:03:59 +0530
Message-Id: <9f45e596fc1718310503f80b04d91eeb138d2ef5.1567077734.git.viresh.kumar@linaro.org>
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

commit ee02a15919cf86c004142edaa05b43f7ff10edf0 upstream.

Or in other words, make fail_incapable_cpu() reusable.

We use fail_incapable_cpu() to kill a secondary CPU early during the
bringup, which doesn't have the system advertised capabilities.
This patch makes the routine more generic, to kill a secondary
booting CPU, getting rid of the dependency on capability struct.
This can be used by checks which are not necessarily attached to
a capability struct (e.g, cpu ASIDBits).

In that process, renames the function to cpu_die_early() to better
match its functionality. This will be moved to arch/arm64/kernel/smp.c
later.

Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d0c82bc02de4..b7f01bf47988 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -853,15 +853,15 @@ static inline void set_sys_caps_initialised(void)
 }
 
 /*
- * Park the CPU which doesn't have the capability as advertised
- * by the system.
+ * Kill the calling secondary CPU, early in bringup before it is turned
+ * online.
  */
-static void fail_incapable_cpu(char *cap_type,
-				 const struct arm64_cpu_capabilities *cap)
+void cpu_die_early(void)
 {
 	int cpu = smp_processor_id();
 
-	pr_crit("CPU%d: missing %s : %s\n", cpu, cap_type, cap->desc);
+	pr_crit("CPU%d: will not boot\n", cpu);
+
 	/* Mark this CPU absent */
 	set_cpu_present(cpu, 0);
 
@@ -902,8 +902,11 @@ void verify_local_cpu_capabilities(void)
 		 * If the new CPU misses an advertised feature, we cannot proceed
 		 * further, park the cpu.
 		 */
-		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i]))
-			fail_incapable_cpu("arm64_features", &caps[i]);
+		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i])) {
+			pr_crit("CPU%d: missing feature: %s\n",
+					smp_processor_id(), caps[i].desc);
+			cpu_die_early();
+		}
 		if (caps[i].enable)
 			caps[i].enable(NULL);
 	}
@@ -911,8 +914,11 @@ void verify_local_cpu_capabilities(void)
 	for (i = 0, caps = arm64_hwcaps; caps[i].matches; i++) {
 		if (!cpus_have_hwcap(&caps[i]))
 			continue;
-		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i]))
-			fail_incapable_cpu("arm64_hwcaps", &caps[i]);
+		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i])) {
+			pr_crit("CPU%d: missing HWCAP: %s\n",
+					smp_processor_id(), caps[i].desc);
+			cpu_die_early();
+		}
 	}
 }
 
-- 
2.21.0.rc0.269.g1a574e7a288b

