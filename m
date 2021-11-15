Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CCE45223F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376899AbhKPBKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245108AbhKOTTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2301C63446;
        Mon, 15 Nov 2021 18:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000919;
        bh=onHz6mkg1pW0j1NGiyStz+qOsokjE1K5p1KKWc/42pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaIcEKm7hxDxNrZvHjeR2fTN6FsbYW6JY/YLteNRkhhuqTC6pSnzTOVeXWqMbz+VR
         tWJo4i1G+gGsIf10msCYtrLuyasa7OrBSqsMALGPOaKjU/scuB9TO1TNmhjXDsr15v
         xHPwviOZAoIoj5dB8D9zr/WjN/bmUrCpFQddEEpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 842/849] powerpc/85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n
Date:   Mon, 15 Nov 2021 18:05:25 +0100
Message-Id: <20211115165448.733227699@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

commit c45361abb9185b1e172bd75eff51ad5f601ccae4 upstream.

When CONFIG_SMP=y, timebase synchronization is required when the second
kernel is started.

arch/powerpc/kernel/smp.c:
  int __cpu_up(unsigned int cpu, struct task_struct *tidle)
  {
  	...
  	if (smp_ops->give_timebase)
  		smp_ops->give_timebase();
  	...
  }

  void start_secondary(void *unused)
  {
  	...
  	if (smp_ops->take_timebase)
  		smp_ops->take_timebase();
  	...
  }

When CONFIG_HOTPLUG_CPU=n and CONFIG_KEXEC_CORE=n,
 smp_85xx_ops.give_timebase is NULL,
 smp_85xx_ops.take_timebase is NULL,
As a result, the timebase is not synchronized.

Timebase  synchronization does not depend on CONFIG_HOTPLUG_CPU.

Fixes: 56f1ba280719 ("powerpc/mpc85xx: refactor the PM operations")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210929033646.39630-3-nixiaoming@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/85xx/Makefile         |    4 +++-
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c |    4 ++++
 arch/powerpc/platforms/85xx/smp.c            |   12 ++++++------
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/arch/powerpc/platforms/85xx/Makefile
+++ b/arch/powerpc/platforms/85xx/Makefile
@@ -3,7 +3,9 @@
 # Makefile for the PowerPC 85xx linux kernel.
 #
 obj-$(CONFIG_SMP) += smp.o
-obj-$(CONFIG_FSL_PMC)		  += mpc85xx_pm_ops.o
+ifneq ($(CONFIG_FSL_CORENET_RCPM),y)
+obj-$(CONFIG_SMP) += mpc85xx_pm_ops.o
+endif
 
 obj-y += common.o
 
--- a/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c
@@ -17,6 +17,7 @@
 
 static struct ccsr_guts __iomem *guts;
 
+#ifdef CONFIG_FSL_PMC
 static void mpc85xx_irq_mask(int cpu)
 {
 
@@ -49,6 +50,7 @@ static void mpc85xx_cpu_up_prepare(int c
 {
 
 }
+#endif
 
 static void mpc85xx_freeze_time_base(bool freeze)
 {
@@ -76,10 +78,12 @@ static const struct of_device_id mpc85xx
 
 static const struct fsl_pm_ops mpc85xx_pm_ops = {
 	.freeze_time_base = mpc85xx_freeze_time_base,
+#ifdef CONFIG_FSL_PMC
 	.irq_mask = mpc85xx_irq_mask,
 	.irq_unmask = mpc85xx_irq_unmask,
 	.cpu_die = mpc85xx_cpu_die,
 	.cpu_up_prepare = mpc85xx_cpu_up_prepare,
+#endif
 };
 
 int __init mpc85xx_setup_pmc(void)
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -40,7 +40,6 @@ struct epapr_spin_table {
 	u32	pir;
 };
 
-#ifdef CONFIG_HOTPLUG_CPU
 static u64 timebase;
 static int tb_req;
 static int tb_valid;
@@ -112,6 +111,7 @@ static void mpc85xx_take_timebase(void)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 static void smp_85xx_cpu_offline_self(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -495,21 +495,21 @@ void __init mpc85xx_smp_init(void)
 		smp_85xx_ops.probe = NULL;
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
 #ifdef CONFIG_FSL_CORENET_RCPM
+	/* Assign a value to qoriq_pm_ops on PPC_E500MC */
 	fsl_rcpm_init();
-#endif
-
-#ifdef CONFIG_FSL_PMC
+#else
+	/* Assign a value to qoriq_pm_ops on !PPC_E500MC */
 	mpc85xx_setup_pmc();
 #endif
 	if (qoriq_pm_ops) {
 		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
 		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
+#ifdef CONFIG_HOTPLUG_CPU
 		smp_85xx_ops.cpu_offline_self = smp_85xx_cpu_offline_self;
 		smp_85xx_ops.cpu_die = qoriq_cpu_kill;
-	}
 #endif
+	}
 	smp_ops = &smp_85xx_ops;
 
 #ifdef CONFIG_KEXEC_CORE


