Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F866662F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfGLF3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43940 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so4183467plb.10
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZERHer/S6V7v3IyXGHBRQXsjn5NA4nSXv7B2aoThKNw=;
        b=LTGjy4RbPjl9R3s4FBJE7KxiWqlXV2Jf5Pd7wO0KzlxPr4SUYEcUciTXuVXj7usHms
         PBQ0GacQJxLledV6d0cVnlYP7EdoN0ibucpvd5Ox2iDnM4lDcvrfAwBw9U3rins3V+uC
         C8hekJ0VKJ136OK57vbzVb/TQ2PkcO7zGjqhj+zavYVK/VEoiPLQXx5n5kxQm+P2TCHu
         QhCYjQR9YE9M+lQtk+SbouEYzEG5+J9vd5nBHptbGKNBegltTaQCKUt7YlzFwAelFi3i
         qFYfmRpohadOUJwGsZgQSyedLaAGEjxeLe/Fn5VrzZ0NCbgkUnncJO0AbbF5RRNRniql
         Ok3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZERHer/S6V7v3IyXGHBRQXsjn5NA4nSXv7B2aoThKNw=;
        b=JIx8lxTEXCoz0656elWgJ/CvVdXLXQgGVUhLXvCGMJ3c+VDJfoqPH6ZMNdg3HW3Ris
         Jkvyl/4lFFgTYEUtmOLUaQ6OBRAlDGnb2VRH+wXTDcR3tTdUj9QebLx/tIU3H8BB/Bgl
         GRQLKwHPBsYPSqIx91noHUz3pzCgZObNc/GPq31yw1RyeUaGO1xmCo9MHbJEXzkl3CtR
         mmWGGVCceGW9i/Q1vSK09YRWxXJWvziIBdr6/mIIQ6bHeE0lF7us+tclKCc2HqyEY+MM
         hFvHtmE9DBo+Vkgew/SRXb9ksfPhtbD9ALbBVUU2bR8fP5n9WwOERuWcHUTLGojx9lDh
         Kfmg==
X-Gm-Message-State: APjAAAVXHfOqEwX1ZKHt9Zn256OoegjUyqKlZ4QtYD+kEUvhi8EAqwIi
        KwfEjKMOVAfk/Gsm4enGeTMQallSkpk=
X-Google-Smtp-Source: APXvYqzkQsNGjcvFC1dsQGwJlq+DhpGSy6v41hr8up7BSid1MOh4Os1JsA+bK4AX8YSqfYHgABj3Mg==
X-Received: by 2002:a17:902:8b88:: with SMTP id ay8mr8861169plb.139.1562909376770;
        Thu, 11 Jul 2019 22:29:36 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id n98sm6937170pjc.26.2019.07.11.22.29.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:36 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 14/43] arm64: Introduce cpu_die_early
Date:   Fri, 12 Jul 2019 10:58:02 +0530
Message-Id: <f6930181f7a0cfb8e126fcbd086e3b093d89136c.1562908075.git.viresh.kumar@linaro.org>
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

