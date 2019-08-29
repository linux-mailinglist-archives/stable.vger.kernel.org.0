Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D525EA18CC
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfH2Lfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42452 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfH2Lfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id p3so1435805pgb.9
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dewjZZw0HbdCyicLrnA8hjXb53SKvhtBESHu+qhlc+Y=;
        b=lIExeLrhz8lGFteYnUQGXqUT/vKMdDZ+m5DwGlBy1q2p8zFsU1ELB6LPa/By6x1CZD
         uTDBAPSQdfhFkOm+UIeg6yuVbvYSGxcd0n9/5KlzKCaBSDc67t0jDk9IhGkuHAj7bUpi
         1jF4m8faXjqozOcmI+BwZ9qXQk/8cRh35d6J9mhXZEIQEc2huML5kncdAHkx3Tc1SYwP
         E2znsQH4RK9ad3AZpCOI90Ih6vxDZtfWfiVaxaCm3glRjJhc4mFQ1deqLHgW/wrSuh07
         NU4PW6+2jP7wmUgDfgi2hg1jdEVXPOa1s53ifhgWvwCoswbYZuTzdVyvnPaTSbmu8pus
         of5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dewjZZw0HbdCyicLrnA8hjXb53SKvhtBESHu+qhlc+Y=;
        b=LDHSR6xuzT7dXecB2owu3xecX/+GI4Mh+DhTnccfc4mskpL74Au/sn6TAOdGALWsnB
         rtUYfe52XQFWLKvL3x8pG0un7ZLvf9AkMt53UXM6/uhXlL5Dp7l/PyqF+f0PK/mjbKaP
         cgLYNQELX4+OhdIKCGxQVn+wzUp10rkKzkZJpM0zPLSB+eFujK50CBVFSR62dpZRomy/
         fysMzcb31knt/ygJWM2iDjAOTJSeuhd4zUJ+B23qymB3r9CXp8YQuvxAjuWh0zZy1s1i
         iXBXmtClRFnupwQJl0SmerQCEyuz+8EBJHJ+LUPNnHyx7m6/Lfo+koxJTugocRKS9neX
         Pk0g==
X-Gm-Message-State: APjAAAUCcGkAW8lxHRBshJFBI4JjnDC6lFR0+ez5GJpdy9vBxDUPaeXG
        FnmDZG9B9gzRUV8TN+qEN9JVr6dueZs=
X-Google-Smtp-Source: APXvYqxoKgb7SNfBlsZvZscecZMbMzxLH57ty0yVul4EL/Q54E1w20FKuoPKMtZ5EKefwhY1rV1dMw==
X-Received: by 2002:a17:90a:1b0d:: with SMTP id q13mr9408117pjq.102.1567078540625;
        Thu, 29 Aug 2019 04:35:40 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e66sm6395757pfe.142.2019.08.29.04.35.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:40 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 18/44] arm64: errata: Calling enable functions for CPU errata too
Date:   Thu, 29 Aug 2019 17:04:03 +0530
Message-Id: <5fa6a176c115529bb675f9b4b33462ae362dcdb3.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

commit 8e2318521bf5837dae093413f81292b59d49d030 upstream.

Currently we call the (optional) enable function for CPU _features_
only. As CPU _errata_ descriptions share the same data structure and
having an enable function is useful for errata as well (for instance
to set bits in SCTLR), lets call it when enumerating erratas too.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h | 2 ++
 arch/arm64/kernel/cpu_errata.c      | 5 +++++
 arch/arm64/kernel/cpufeature.c      | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index dd1aab8e52aa..0267bab6ac18 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -171,7 +171,9 @@ void __init setup_cpu_features(void);
 
 void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 			    const char *info);
+void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps);
 void check_local_cpu_errata(void);
+void __init enable_errata_workarounds(void);
 
 void verify_local_cpu_errata(void);
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a3567881c01b..d9f095439011 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -140,3 +140,8 @@ void check_local_cpu_errata(void)
 {
 	update_cpu_capabilities(arm64_errata, "enabling workaround for");
 }
+
+void __init enable_errata_workarounds(void)
+{
+	enable_cpu_capabilities(arm64_errata);
+}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a4b638b1c18..7773bea6927e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -820,7 +820,7 @@ void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
  * Run through the enabled capabilities and enable() it on all active
  * CPUs
  */
-static void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
+void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 {
 	int i;
 
@@ -923,6 +923,7 @@ void __init setup_cpu_features(void)
 
 	/* Set the CPU feature capabilies */
 	setup_feature_capabilities();
+	enable_errata_workarounds();
 	setup_cpu_hwcaps();
 
 	/* Advertise that we have computed the system capabilities */
-- 
2.21.0.rc0.269.g1a574e7a288b

