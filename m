Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF1FA18CB
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfH2Lfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37116 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfH2Lfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so1452831pgp.4
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NiMpS2GtyMwnZTpxG4MhAWhnIU6AXgssIk4MKZtthvc=;
        b=DkQ5KEtwOugRSGpIbnGMVx5+YOPlvoYR36xfUhOaGYeT/642RhAsocGr8Th/WUdMoN
         pbfbTIupvPLeeF4eKA0gaKKiNUTTfiqhng3jRi2/mesaUlM8FfUJy60fPPQpbrvOa6dx
         tMRZdPSiZ1j0Xc/nULVnSBaO1iH6JZhw197vA46m/frrCrXLwCMMvtlqnZ3xqBMQiu+S
         5ZbtLepugDfLjhmtjtIRmPSyk/oggkBM3WYWa5xzYdmHf2jZKc5EfOkbVQZxFz9r4UEs
         ZgeJdVjak8guvMbbkgganKHwSDHdDfxiubAwJ2M3zedEYn+hdITSrp3gZWc61k6TEcuK
         sw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NiMpS2GtyMwnZTpxG4MhAWhnIU6AXgssIk4MKZtthvc=;
        b=TeGGaKGoyPR5Dni9qoszy8gmeuOeYnOj7Oyp8AtDiS0OG9509gM1hiKmPm5tH0//7n
         Sd6lLM3oQp+VQ85UyWfHB1LrwSS7AjNt6Km6h6U1i2DHUOxFGH7VHzOswGDqyq00TKGx
         JzLt3ELbgJH+xElEGm+5BvPGYEx3WsbJebDD0h5JMeJwdJc/BbENwmCR87RyewDP1SEc
         XluKgZ+9a8YogcXTrEt2SSLAspGejZZRBmOHfrNZ1vlUlclIWbhPxLjP0XYf+NDIzKq5
         N+/m12h2CjoTjXh8PdmULWwB6z0VGp67/8+VX+xxwNSu/xd+ZE2N/C6DWqQ+m6ZhfZwL
         9UDg==
X-Gm-Message-State: APjAAAVppLcP6+FdFo3kQO2f5l1Akm7MJrHzsWPdnpImylN1j/ZsVaAr
        hwUKfkA6M/MM3HVqwgxqChON36AoGz4=
X-Google-Smtp-Source: APXvYqwmURVSuLg/ase0fyn7iRT7UmlDDNv+cMigrGIzWasm1pmN7jVx9NKSdlN1Ted+/DI99yu6xg==
X-Received: by 2002:a63:d23:: with SMTP id c35mr7876121pgl.376.1567078538027;
        Thu, 29 Aug 2019 04:35:38 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e3sm2298962pjr.9.2019.08.29.04.35.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:36 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 17/44] arm64: Verify CPU errata work arounds on hotplugged CPU
Date:   Thu, 29 Aug 2019 17:04:02 +0530
Message-Id: <97b4e62862a368bd9eb87df8f48f7b95368e2479.1567077734.git.viresh.kumar@linaro.org>
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

