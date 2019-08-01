Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A2A7D734
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfHAIUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39703 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfHAIUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:23 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so33735901pgi.6
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VABKBorQUfKeR09TGNvFzk8y3IzwO2qu0Xfufvbef4=;
        b=DQ933P7SMaIFNCoCn0GqwaK/0IZY/MQGe032YpW1qdQHOrKfg4wKeqsXlDQVKZp0cc
         81qb/0UgC76sCT2JV07Le889UA4G/BvPP0vlB2dVbTJQNW1Jh7czJEybCFtWFUPPacTG
         439AI1hpjbQILEDhSvJDccyEBpTNNNiZqDOeRMdrB0xXQVEYu3GYesW+xQ0RKiBDbGLv
         SPH7LTUJrXZ2f1YThMR+WzDzaoLiaDI57SdlpXgEJfRa4nG/ej87gKdtE/SSsq3svfnR
         Kh/fsSvWO5ZqhBj8Hg0Ee44Rx8z7AD6NZx/Izoca3CxQFzSiJeU6vM7DnJnSWFQPFw6o
         pfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VABKBorQUfKeR09TGNvFzk8y3IzwO2qu0Xfufvbef4=;
        b=SKla13uQQe0p5bszJcq+q8I1aJX3P2qpI6B8V0zHeSAuWbaPE/cR3PyKlkRKBrWcOO
         hJ3BlzNoUUajulUmIrjqXL3KTdSTnXGAxPquZEFZEZ9rmQkzpv0H02jJGu8DZ9S4h7o+
         lqFhUyWCDcwKfVvh79SfaHm+0dJJHyo94gv66cfc/xQ2GgrNHvTeEdjRcB76hC2poSrD
         ebgLRRa21O9GwE3Z8Gmw2LWwSVgtJQh5oi2C6vvrljYU+Pi865hIuj+FCfY+p2m+hlcO
         djMTaySe5aS01TptQFmX7SClIE9WRed6gx6HWUWn0fm/txJ3qZa+2Bzvvi0WMciL/7ss
         oWBQ==
X-Gm-Message-State: APjAAAV1rOOAD5qCZ5hYa8b4NflhrtzvCXNBsciRMumdz0aerKnD0uZI
        tXoWD5DvhpbTpMyK0LLgJcPY9KKdC+s=
X-Google-Smtp-Source: APXvYqw+DyMm0xB//RzNX38fJJ8GmnaUVfpXzbcLL1yA8V1oXi2z/rLKYj8PHIKkXmcxU7xY6RKPXA==
X-Received: by 2002:a65:6546:: with SMTP id a6mr64618724pgw.220.1564647622525;
        Thu, 01 Aug 2019 01:20:22 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id i14sm109862834pfk.0.2019.08.01.01.20.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:22 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 18/47] ARM: spectre-v2: warn about incorrect context switching functions
Date:   Thu,  1 Aug 2019 13:46:02 +0530
Message-Id: <b3b43e3f06ea7bf416a7d03789c4ecd2050976b3.1564646727.git.viresh.kumar@linaro.org>
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

Commit c44f366ea7c85e1be27d08f2f0880f4120698125 upstream.

Warn at error level if the context switching function is not what we
are expecting.  This can happen with big.Little systems, which we
currently do not support.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/proc-v7-bugs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index da25a38e1897..5544b82a2e7a 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -12,6 +12,8 @@
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DEFINE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
 
+extern void cpu_v7_iciallu_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
+extern void cpu_v7_bpiall_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
 extern void cpu_v7_smc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
 extern void cpu_v7_hvc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
 
@@ -50,6 +52,8 @@ static void cpu_v7_spectre_init(void)
 	case ARM_CPU_PART_CORTEX_A17:
 	case ARM_CPU_PART_CORTEX_A73:
 	case ARM_CPU_PART_CORTEX_A75:
+		if (processor.switch_mm != cpu_v7_bpiall_switch_mm)
+			goto bl_error;
 		per_cpu(harden_branch_predictor_fn, cpu) =
 			harden_branch_predictor_bpiall;
 		spectre_v2_method = "BPIALL";
@@ -57,6 +61,8 @@ static void cpu_v7_spectre_init(void)
 
 	case ARM_CPU_PART_CORTEX_A15:
 	case ARM_CPU_PART_BRAHMA_B15:
+		if (processor.switch_mm != cpu_v7_iciallu_switch_mm)
+			goto bl_error;
 		per_cpu(harden_branch_predictor_fn, cpu) =
 			harden_branch_predictor_iciallu;
 		spectre_v2_method = "ICIALLU";
@@ -82,6 +88,8 @@ static void cpu_v7_spectre_init(void)
 					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 			if ((int)res.a0 != 0)
 				break;
+			if (processor.switch_mm != cpu_v7_hvc_switch_mm && cpu)
+				goto bl_error;
 			per_cpu(harden_branch_predictor_fn, cpu) =
 				call_hvc_arch_workaround_1;
 			processor.switch_mm = cpu_v7_hvc_switch_mm;
@@ -93,6 +101,8 @@ static void cpu_v7_spectre_init(void)
 					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 			if ((int)res.a0 != 0)
 				break;
+			if (processor.switch_mm != cpu_v7_smc_switch_mm && cpu)
+				goto bl_error;
 			per_cpu(harden_branch_predictor_fn, cpu) =
 				call_smc_arch_workaround_1;
 			processor.switch_mm = cpu_v7_smc_switch_mm;
@@ -109,6 +119,11 @@ static void cpu_v7_spectre_init(void)
 	if (spectre_v2_method)
 		pr_info("CPU%u: Spectre v2: using %s workaround\n",
 			smp_processor_id(), spectre_v2_method);
+	return;
+
+bl_error:
+	pr_err("CPU%u: Spectre v2: incorrect context switching function, system vulnerable\n",
+		cpu);
 }
 #else
 static void cpu_v7_spectre_init(void)
-- 
2.21.0.rc0.269.g1a574e7a288b

