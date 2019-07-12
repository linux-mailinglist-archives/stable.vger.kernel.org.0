Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D6C66632
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfGLF3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44826 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so3990128pgl.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NiMpS2GtyMwnZTpxG4MhAWhnIU6AXgssIk4MKZtthvc=;
        b=ZxWyb/8VZoLdoUn2uKUudf3sdZhjRD6a7pJM14TVwK7g/vHOIHZfykI1dtfLhHIfYn
         3cSWJiC6CWJC6W1uMbsdf6OYsFlIxC64jvs4VHLK9L5lIWKJ8/JQAM/NV7qhXlQP4aMQ
         YY6r4gKLHQwZzJBywyvMiJPxbDmJ5WJF1z+CF5F8cyZRRtgISkKLkQ7pTx4QGi8Q9r/4
         zas1OTYOclfwi531Lep+sfcTpCDvGycbUzp1Id0F1FOMJWc6d1ZrGlWDS8k9FXU1Rqvu
         rdQqv2AtNzI9gcxIvkDftOsnSlr139CUY3GegXmenTrJ9g96NbW2QGGTmBARNxkXD9my
         jzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NiMpS2GtyMwnZTpxG4MhAWhnIU6AXgssIk4MKZtthvc=;
        b=fGafjCusM1pQREjpDNjgTsuUcql5/BvcK02pXPRk11i3IBhyAkpa8LcCQo026SG6ra
         QTfKWlBOYIW1SXmuFHOKTyB6yA+2MI1NgYa/BNa314EuIATw+iPIJZB8GqetuwxIZl2V
         bevnNeD2liaKUn0lNnqm6q66mm0mU5zlfEtaM284xJEjxTyGORKvx8YrkkX16tNZsZ5a
         4ZBhWAndlXiKOI3tjEKcNv4odHT7232JI/GR699eOT8I8KKsJyDBBJnpLaW7E7egeJ3b
         2BaFEPdfo0VUCCh6xQD2wfkSmoRJxSJ6+p/8Ns6bScJdKkl6Uuq8BfizYEpAKFS/u5un
         aprQ==
X-Gm-Message-State: APjAAAVY/nxeW0wjghs+7fexG/85k16FFmad2wIlrOkm1SswIJcCDanj
        A4FpaHN1ZwsaoYhc6XJRa5CFLFoPr44=
X-Google-Smtp-Source: APXvYqx/Tk4AViCSWTjUMRe/TZvkHhLkrEkE3+RlS2ORyipfV5gjtHSPq5lheadSb5cU+/DklVHmmA==
X-Received: by 2002:a63:4185:: with SMTP id o127mr8346896pga.82.1562909382331;
        Thu, 11 Jul 2019 22:29:42 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id r13sm8444561pfr.25.2019.07.11.22.29.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:41 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 16/43] arm64: Verify CPU errata work arounds on hotplugged CPU
Date:   Fri, 12 Jul 2019 10:58:04 +0530
Message-Id: <69ba9cb57c88ef7c15651a3f474a209dabe9d89b.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 6a6efbb45b7d95c84840010095367eb06a64f342 upstream.

CPU Errata work arounds are detected and applied to the
kernel code at boot time and the data is then freed up.
If a new hotplugged CPU requires a work around which
was not applied at boot time, there is nothing we can
do but simply fail the booting.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ Viresh: Resolved rebase conflict ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h |  2 ++
 arch/arm64/kernel/cpu_errata.c      | 20 ++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c      |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4c31e14c0f0e..dd1aab8e52aa 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -173,6 +173,8 @@ void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 			    const char *info);
 void check_local_cpu_errata(void);
 
+void verify_local_cpu_errata(void);
+
 #ifdef CONFIG_HOTPLUG_CPU
 void verify_local_cpu_capabilities(void);
 #else
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0971d80d3623..a3567881c01b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -116,6 +116,26 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	}
 };
 
+/*
+ * The CPU Errata work arounds are detected and applied at boot time
+ * and the related information is freed soon after. If the new CPU requires
+ * an errata not detected at boot, fail this CPU.
+ */
+void verify_local_cpu_errata(void)
+{
+	const struct arm64_cpu_capabilities *caps = arm64_errata;
+
+	for (; caps->matches; caps++)
+		if (!cpus_have_cap(caps->capability) &&
+			caps->matches(caps, SCOPE_LOCAL_CPU)) {
+			pr_crit("CPU%d: Requires work around for %s, not detected"
+					" at boot time\n",
+				smp_processor_id(),
+				caps->desc ? : "an erratum");
+			cpu_die_early();
+		}
+}
+
 void check_local_cpu_errata(void)
 {
 	update_cpu_capabilities(arm64_errata, "enabling workaround for");
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a0273cd8be51..9a4b638b1c18 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -872,6 +872,8 @@ void verify_local_cpu_capabilities(void)
 	if (!sys_caps_initialised)
 		return;
 
+	verify_local_cpu_errata();
+
 	caps = arm64_features;
 	for (i = 0; caps[i].matches; i++) {
 		if (!cpus_have_cap(caps[i].capability) || !caps[i].sys_reg)
-- 
2.21.0.rc0.269.g1a574e7a288b

