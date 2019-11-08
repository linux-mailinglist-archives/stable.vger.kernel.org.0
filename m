Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B739F577B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbfKHTWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387616AbfKHSze (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:55:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0A6218AE;
        Fri,  8 Nov 2019 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239333;
        bh=+5huyMqjI7fgVldVohQ+1GuXRgw/Bu4hD6O9RL07Dpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRcq235kkGrjl2sC/x1R0FO+EL0XXg4LAbngkIYJPVEJkpJwPtkxdE/Zk2joy3Fqa
         Cj8EhreRNJplriE13ERp04cpqw8b/EAFM0wf9jpHU1Nq7pg/SKjq18c5Aiy6CM7Ux7
         q3J/WvA6IFRnByseBAg8XXXDcq0vxYMfWyrYV3wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 42/75] ARM: bugs: hook processor bug checking into SMP and suspend paths
Date:   Fri,  8 Nov 2019 19:49:59 +0100
Message-Id: <20191108174749.313487476@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/bugs.h |    2 ++
 arch/arm/kernel/bugs.c      |    5 +++++
 arch/arm/kernel/smp.c       |    4 ++++
 arch/arm/kernel/suspend.c   |    2 ++
 4 files changed, 13 insertions(+)

--- a/arch/arm/include/asm/bugs.h
+++ b/arch/arm/include/asm/bugs.h
@@ -14,8 +14,10 @@ extern void check_writebuffer_bugs(void)
 
 #ifdef CONFIG_MMU
 extern void check_bugs(void);
+extern void check_other_bugs(void);
 #else
 #define check_bugs() do { } while (0)
+#define check_other_bugs() do { } while (0)
 #endif
 
 #endif
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
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <linux/irq_work.h>
 
 #include <linux/atomic.h>
+#include <asm/bugs.h>
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
@@ -396,6 +397,9 @@ asmlinkage void secondary_start_kernel(v
 	 * before we continue - which happens after __cpu_up returns.
 	 */
 	set_cpu_online(cpu, true);
+
+	check_other_bugs();
+
 	complete(&cpu_running);
 
 	local_irq_enable();
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 
+#include <asm/bugs.h>
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
 #include <asm/pgalloc.h>
@@ -34,6 +35,7 @@ int cpu_suspend(unsigned long arg, int (
 		cpu_switch_mm(mm->pgd, mm);
 		local_flush_bp_all();
 		local_flush_tlb_all();
+		check_other_bugs();
 	}
 
 	return ret;


