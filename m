Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62948F4BCD
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKHMgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfKHMgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:44 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59D85224BF;
        Fri,  8 Nov 2019 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216603;
        bh=4lic9VVv02uu+11nFQSQncU+RZDYa/ynCOkd+yZp7UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIzmS/ezt6s9Qf2HInMX42ABlkCxJS7INOvDVOMXp/Czwf5QkpM3xAXeSlyY3GNpU
         zF6CNRUcifl4MOM3Tb1IzUWSLS8NjEGIBfR3N+H6LL4YAMq2FfzwBxWVsU7xZpO5Jp
         A/3p7aHvinFQupaINRQ0O2GPB4/a/mB6nhcp1h1Q=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 19/50] ARM: bugs: hook processor bug checking into SMP and suspend paths
Date:   Fri,  8 Nov 2019 13:35:23 +0100
Message-Id: <20191108123554.29004-20-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
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
2.20.1

