Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CC511342B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfLDSW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730335AbfLDSFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:05:10 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6AEE20659;
        Wed,  4 Dec 2019 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482710;
        bh=knbKsM2PPdiJ13pHkQSZUjV9t4XeGk2gTHxk015Ntho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAIUtrhl0yPzSfdk8o0Jr1KVkujVu9Pr0MeuCBd2Klno0NoyM8Z4Tbho0YgQZO1P9
         lnUctLIrOw5rSobIM5c2Rmh+5yH18m946Nt2EUVvz2ne8LlrpAgJs7mr+esC/FDVtL
         JOMZXykxrmaOCKPmiLUTqYJi0G1QrlLUy2dPz+BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Scott Wood <oss@buserror.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/209] powerpc/83xx: handle machine check caused by watchdog timer
Date:   Wed,  4 Dec 2019 18:55:17 +0100
Message-Id: <20191204175329.091245216@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 0deae39cec6dab3a66794f3e9e83ca4dc30080f1 ]

When the watchdog timer is set in interrupt mode, it causes a
machine check when it times out. The purpose of this mode is to
ease debugging, not to crash the kernel and reboot the machine.

This patch implements a special handling for that, in order to not
crash the kernel if the watchdog times out while in interrupt or
within the idle task.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[scottwood: added missing #include]
Signed-off-by: Scott Wood <oss@buserror.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cputable.h |  1 +
 arch/powerpc/include/asm/reg.h      |  2 ++
 arch/powerpc/kernel/cputable.c      | 10 ++++++----
 arch/powerpc/platforms/83xx/misc.c  | 17 +++++++++++++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 7e3ccf21830e6..e4451b30d7e32 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -45,6 +45,7 @@ extern int machine_check_e500(struct pt_regs *regs);
 extern int machine_check_e200(struct pt_regs *regs);
 extern int machine_check_47x(struct pt_regs *regs);
 int machine_check_8xx(struct pt_regs *regs);
+int machine_check_83xx(struct pt_regs *regs);
 
 extern void cpu_down_flush_e500v2(void);
 extern void cpu_down_flush_e500mc(void);
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index b779f3ccd4126..05f3c2b3aa0ec 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -733,6 +733,8 @@
 #define   SRR1_PROGTRAP		0x00020000 /* Trap */
 #define   SRR1_PROGADDR		0x00010000 /* SRR0 contains subsequent addr */
 
+#define   SRR1_MCE_MCP		0x00080000 /* Machine check signal caused interrupt */
+
 #define SPRN_HSRR0	0x13A	/* Save/Restore Register 0 */
 #define SPRN_HSRR1	0x13B	/* Save/Restore Register 1 */
 #define   HSRR1_DENORM		0x00100000 /* Denorm exception */
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 760872916013d..da4b0e3792380 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -1185,6 +1185,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.machine_check		= machine_check_generic,
 		.platform		= "ppc603",
 	},
+#ifdef CONFIG_PPC_83xx
 	{	/* e300c1 (a 603e core, plus some) on 83xx */
 		.pvr_mask		= 0x7fff0000,
 		.pvr_value		= 0x00830000,
@@ -1195,7 +1196,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.icache_bsize		= 32,
 		.dcache_bsize		= 32,
 		.cpu_setup		= __setup_cpu_603,
-		.machine_check		= machine_check_generic,
+		.machine_check		= machine_check_83xx,
 		.platform		= "ppc603",
 	},
 	{	/* e300c2 (an e300c1 core, plus some, minus FPU) on 83xx */
@@ -1209,7 +1210,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.icache_bsize		= 32,
 		.dcache_bsize		= 32,
 		.cpu_setup		= __setup_cpu_603,
-		.machine_check		= machine_check_generic,
+		.machine_check		= machine_check_83xx,
 		.platform		= "ppc603",
 	},
 	{	/* e300c3 (e300c1, plus one IU, half cache size) on 83xx */
@@ -1223,7 +1224,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.icache_bsize		= 32,
 		.dcache_bsize		= 32,
 		.cpu_setup		= __setup_cpu_603,
-		.machine_check		= machine_check_generic,
+		.machine_check		= machine_check_83xx,
 		.num_pmcs		= 4,
 		.oprofile_cpu_type	= "ppc/e300",
 		.oprofile_type		= PPC_OPROFILE_FSL_EMB,
@@ -1240,12 +1241,13 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.icache_bsize		= 32,
 		.dcache_bsize		= 32,
 		.cpu_setup		= __setup_cpu_603,
-		.machine_check		= machine_check_generic,
+		.machine_check		= machine_check_83xx,
 		.num_pmcs		= 4,
 		.oprofile_cpu_type	= "ppc/e300",
 		.oprofile_type		= PPC_OPROFILE_FSL_EMB,
 		.platform		= "ppc603",
 	},
+#endif
 	{	/* default match, we assume split I/D cache & TB (non-601)... */
 		.pvr_mask		= 0x00000000,
 		.pvr_value		= 0x00000000,
diff --git a/arch/powerpc/platforms/83xx/misc.c b/arch/powerpc/platforms/83xx/misc.c
index d75c9816a5c92..2b6589fe812dd 100644
--- a/arch/powerpc/platforms/83xx/misc.c
+++ b/arch/powerpc/platforms/83xx/misc.c
@@ -14,6 +14,7 @@
 #include <linux/of_platform.h>
 #include <linux/pci.h>
 
+#include <asm/debug.h>
 #include <asm/io.h>
 #include <asm/hw_irq.h>
 #include <asm/ipic.h>
@@ -150,3 +151,19 @@ void __init mpc83xx_setup_arch(void)
 
 	mpc83xx_setup_pci();
 }
+
+int machine_check_83xx(struct pt_regs *regs)
+{
+	u32 mask = 1 << (31 - IPIC_MCP_WDT);
+
+	if (!(regs->msr & SRR1_MCE_MCP) || !(ipic_get_mcp_status() & mask))
+		return machine_check_generic(regs);
+	ipic_clear_mcp_status(mask);
+
+	if (debugger_fault_handler(regs))
+		return 1;
+
+	die("Watchdog NMI Reset", regs, 0);
+
+	return 1;
+}
-- 
2.20.1



