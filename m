Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72266633
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfGLF3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44264 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so3779235pfe.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dewjZZw0HbdCyicLrnA8hjXb53SKvhtBESHu+qhlc+Y=;
        b=RraxYDI8rY3l8FCEiAHhEo/jF2VRtW7EBwuN6QgOaJIetId+svx39XqypWhLfmUrTT
         lTIXBkKHpJceOZybH0cw3Eb3/RF9TuEyx/WZjJXkcrZ9j3BqvInbX96hRhyfSGAwmXIS
         Q2Pvdeop95+IxxRgIsz7iUyv2FNy4qu/Mw9SNHC8/Ru1wH11OhpzxbHfqyCEwQH2p0ou
         Eg/FVPW33VEGUjG8VhkxeyfPzNcYZ1sj8w4zti03EN7k1EKz1tYHqBVhPFrXt+G1mRQR
         3411PQD6zmrFhxAX+x0cFlNSCABaWrV9JQR9E+nAoRhxVTKPs7BYN6DE+ed9FfE+DY+4
         FYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dewjZZw0HbdCyicLrnA8hjXb53SKvhtBESHu+qhlc+Y=;
        b=BzxTJ3XhEqBVbQNh2q8Fn7G84CV5A8KwrgNhP7qk5fvyYsVnlnCwUrqm0+fcj7xfAP
         9b0Ff3cCNOt/VpBjXx3rAD/raHhtVgC50ue2Vxzj9yuMyYDVbq9GdN4alsD+ctmEIQY/
         5w9NZIo5P2xDfimASPkxdIYMpqRLmn7qERLRbML4CgryebZzjDEZ7ZENaSK1qHipJOqm
         Sc34hE+AjonzoTIi+AlN+cxar0HM+eB3dCi3uNsenA1SKDWP39gCTIM9A2BN1wN5b5oi
         2SDhv4aPdGlog267aky6SnNCc+2S5h31Ob9e56L5pnZ7RxtdGM9/UBt+iFcUafmqfJMA
         og7w==
X-Gm-Message-State: APjAAAVK37GmvK0GhccxJ8FPHq+d+n1kDowSMgwRowR0KA9OlklxIe0a
        llqaeb7aoWtq6j5m2ovUNK/k0+PZ4ug=
X-Google-Smtp-Source: APXvYqyMo3XAs9GwgMxTcl9YI3nCgf+EBRCPRE5Oaum2NkKdQ5PH1OGrvSHfZOy0sp2jXh2nNhaCHA==
X-Received: by 2002:a63:6507:: with SMTP id z7mr8252553pgb.186.1562909384890;
        Thu, 11 Jul 2019 22:29:44 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id o130sm12919010pfg.171.2019.07.11.22.29.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:44 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 17/43] arm64: errata: Calling enable functions for CPU errata too
Date:   Fri, 12 Jul 2019 10:58:05 +0530
Message-Id: <1916064968526bf98d502a4f286c951db52eef80.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

