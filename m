Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED17D724
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfHAIUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39680 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbfHAIUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so33735424pgi.6
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5q/embD7eXIzs5RT/nIptjidKOY81lXVOsi7bVlsas=;
        b=h+PuW0lEZY8T/ZZSwYcmqS9Be9NSD84V+yeP0216GYwk6bRO15/K6tS+k7m+kmYupA
         0JtVTHhkqr4MqThyhhe15Tr/RvX0NBStrad4AO09QPjN1W0Fpnb3vcGKhTbnFWmwhkVf
         PDXheBxfY+SrGqDbQn69QmYa0oDZMcsCwhpPLa2+3aAp1x0fFWwErRzhlY7xYLIAbovm
         oNrcN0Dx7h8cx112E5tWi4qqCX8rXkANYfSrxrZOcrqENPoXmPGPkdutnFSJrTg2uE6F
         qt1AuXCict0LQkqKiIc/thfAcWghJFlIq836lYmT9Twij6OOzf0xZnJxVWARLqbXJ8Xu
         rhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5q/embD7eXIzs5RT/nIptjidKOY81lXVOsi7bVlsas=;
        b=Iq3jD4vJc4WfEJ6Z0Q0L4f8k1Ty+WWLI/G9IaJsQg5VRbRqTvVg0t3oFkJqFuTqbeJ
         4gX7NniM17mzooKzRhXI4sKymGEuulxwuiFFjVKyZkPTT4O2R1ydNIiE8M4HJ9KWPWyB
         5LbiTJDELK/sEEpdRpclalsX5bAbkywcYOKOdCf5A1/CUJvP6sWjr79aFF+9UZsDLtnl
         deKAfuL6/g1HCsn1CEThhUL1SvTqcDITn8WdMiEFUf3WtO8bVhFT3mIC7RkkjYGV0fmM
         vmpj5BSiak6bWaKq/4ecnYExISAGw/eREMveODfL8t6RYa3x2L0Pzk+uH+L2lyrSWvRH
         reGQ==
X-Gm-Message-State: APjAAAXr7o5VQ6FVe3umdbotteFPZVzs9yTUSp13No45D5NFLLfz4lb6
        dr++Cdgbmb0lMkUh0LmB43Qgszakw7k=
X-Google-Smtp-Source: APXvYqyWK08+WjQP1VLDl7IvK9pwIh19X0SAufMgR31Cy7cJh22fhyV6le/+wCVq0ulNjX8HRd37MQ==
X-Received: by 2002:a17:90a:d343:: with SMTP id i3mr7511467pjx.15.1564647603787;
        Thu, 01 Aug 2019 01:20:03 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id s22sm78451239pfh.107.2019.08.01.01.20.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:03 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 11/47] ARM: bugs: hook processor bug checking into SMP and suspend paths
Date:   Thu,  1 Aug 2019 13:45:55 +0530
Message-Id: <98b601c1241fbdfff7d7f1e30de696055441d24b.1564646727.git.viresh.kumar@linaro.org>
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

Commit 26602161b5ba795928a5a719fe1d5d9f2ab5c3ef upstream.

Check for CPU bugs when secondary processors are being brought online,
and also when CPUs are resuming from a low power mode.  This gives an
opportunity to check that processor specific bug workarounds are
correctly enabled for all paths that a CPU re-enters the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/bugs.h | 2 ++
 arch/arm/kernel/bugs.c      | 5 +++++
 arch/arm/kernel/smp.c       | 4 ++++
 arch/arm/kernel/suspend.c   | 2 ++
 4 files changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/bugs.h b/arch/arm/include/asm/bugs.h
index ed122d294f3f..73a99c72a930 100644
--- a/arch/arm/include/asm/bugs.h
+++ b/arch/arm/include/asm/bugs.h
@@ -14,8 +14,10 @@ extern void check_writebuffer_bugs(void);
 
 #ifdef CONFIG_MMU
 extern void check_bugs(void);
+extern void check_other_bugs(void);
 #else
 #define check_bugs() do { } while (0)
+#define check_other_bugs() do { } while (0)
 #endif
 
 #endif
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
index 88024028bb70..16e7ba2a9cc4 100644
--- a/arch/arm/kernel/bugs.c
+++ b/arch/arm/kernel/bugs.c
@@ -3,7 +3,12 @@
 #include <asm/bugs.h>
 #include <asm/proc-fns.h>
 
+void check_other_bugs(void)
+{
+}
+
 void __init check_bugs(void)
 {
 	check_writebuffer_bugs();
+	check_other_bugs();
 }
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 0f1c11861147..bafbd29c6e64 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <linux/irq_work.h>
 
 #include <linux/atomic.h>
+#include <asm/bugs.h>
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
@@ -396,6 +397,9 @@ asmlinkage void secondary_start_kernel(void)
 	 * before we continue - which happens after __cpu_up returns.
 	 */
 	set_cpu_online(cpu, true);
+
+	check_other_bugs();
+
 	complete(&cpu_running);
 
 	local_irq_enable();
diff --git a/arch/arm/kernel/suspend.c b/arch/arm/kernel/suspend.c
index 9a2f882a0a2d..134f0d432610 100644
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 
+#include <asm/bugs.h>
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
 #include <asm/pgalloc.h>
@@ -34,6 +35,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 		cpu_switch_mm(mm->pgd, mm);
 		local_flush_bp_all();
 		local_flush_tlb_all();
+		check_other_bugs();
 	}
 
 	return ret;
-- 
2.21.0.rc0.269.g1a574e7a288b

