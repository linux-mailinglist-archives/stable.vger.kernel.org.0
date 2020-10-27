Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2829B24C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761269AbgJ0Oio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761262AbgJ0Oim (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA8A21D7B;
        Tue, 27 Oct 2020 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809521;
        bh=wdOqpZ6Ylcq/j1fen1D/FIij8X1xej+ubyKQqre/Igk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf0M9190xjGs978P+J9uxV599UM8eElp7BF78HtikRZ9vBvr8P2PjdaPQ4BQ95N15
         XOm1p24GaKMJ9DV0B6oy+Ewe4QwA1nTGLwoF23Y/Qi+8+kfdVtHIbt8zkSx7Xl8+lX
         t/bLtDp/FSBMRF4BoC3RJUUVb0Od/hWFi3FJjAMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/408] powerpc/tau: Check processor type before enabling TAU interrupt
Date:   Tue, 27 Oct 2020 14:52:44 +0100
Message-Id: <20201027135505.554273766@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 5e3119e15fed5b9a9a7e528665ff098a4a8dbdbc ]

According to Freescale's documentation, MPC74XX processors have an
erratum that prevents the TAU interrupt from working, so don't try to
use it when running on those processors.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c281611544768e758bd58fe812cf702a5bd2d042.1599260540.git.fthain@telegraphics.com.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/tau_6xx.c  | 33 ++++++++++++++-------------------
 arch/powerpc/platforms/Kconfig |  5 ++---
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
index b8d7e7d498e0a..614b5b272d9c6 100644
--- a/arch/powerpc/kernel/tau_6xx.c
+++ b/arch/powerpc/kernel/tau_6xx.c
@@ -40,6 +40,8 @@ static struct tau_temp
 	unsigned char grew;
 } tau[NR_CPUS];
 
+static bool tau_int_enable;
+
 #undef DEBUG
 
 /* TODO: put these in a /proc interface, with some sanity checks, and maybe
@@ -54,22 +56,13 @@ static struct tau_temp
 
 static void set_thresholds(unsigned long cpu)
 {
-#ifdef CONFIG_TAU_INT
-	/*
-	 * setup THRM1,
-	 * threshold, valid bit, enable interrupts, interrupt when below threshold
-	 */
-	mtspr(SPRN_THRM1, THRM1_THRES(tau[cpu].low) | THRM1_V | THRM1_TIE | THRM1_TID);
+	u32 maybe_tie = tau_int_enable ? THRM1_TIE : 0;
 
-	/* setup THRM2,
-	 * threshold, valid bit, enable interrupts, interrupt when above threshold
-	 */
-	mtspr (SPRN_THRM2, THRM1_THRES(tau[cpu].high) | THRM1_V | THRM1_TIE);
-#else
-	/* same thing but don't enable interrupts */
-	mtspr(SPRN_THRM1, THRM1_THRES(tau[cpu].low) | THRM1_V | THRM1_TID);
-	mtspr(SPRN_THRM2, THRM1_THRES(tau[cpu].high) | THRM1_V);
-#endif
+	/* setup THRM1, threshold, valid bit, interrupt when below threshold */
+	mtspr(SPRN_THRM1, THRM1_THRES(tau[cpu].low) | THRM1_V | maybe_tie | THRM1_TID);
+
+	/* setup THRM2, threshold, valid bit, interrupt when above threshold */
+	mtspr(SPRN_THRM2, THRM1_THRES(tau[cpu].high) | THRM1_V | maybe_tie);
 }
 
 static void TAUupdate(int cpu)
@@ -142,9 +135,8 @@ static void tau_timeout(void * info)
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 
-#ifndef CONFIG_TAU_INT
-	TAUupdate(cpu);
-#endif
+	if (!tau_int_enable)
+		TAUupdate(cpu);
 
 	size = tau[cpu].high - tau[cpu].low;
 	if (size > min_window && ! tau[cpu].grew) {
@@ -225,6 +217,9 @@ static int __init TAU_init(void)
 		return 1;
 	}
 
+	tau_int_enable = IS_ENABLED(CONFIG_TAU_INT) &&
+			 !strcmp(cur_cpu_spec->platform, "ppc750");
+
 	tau_workq = alloc_workqueue("tau", WQ_UNBOUND, 1, 0);
 	if (!tau_workq)
 		return -ENOMEM;
@@ -234,7 +229,7 @@ static int __init TAU_init(void)
 	queue_work(tau_workq, &tau_work);
 
 	pr_info("Thermal assist unit using %s, shrink_timer: %d ms\n",
-		IS_ENABLED(CONFIG_TAU_INT) ? "interrupts" : "workqueue", shrink_timer);
+		tau_int_enable ? "interrupts" : "workqueue", shrink_timer);
 	tau_initialized = 1;
 
 	return 0;
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index d82e3664ffdf8..92d7f2a7936e7 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -219,9 +219,8 @@ config TAU
 	  temperature within 2-4 degrees Celsius. This option shows the current
 	  on-die temperature in /proc/cpuinfo if the cpu supports it.
 
-	  Unfortunately, on some chip revisions, this sensor is very inaccurate
-	  and in many cases, does not work at all, so don't assume the cpu
-	  temp is actually what /proc/cpuinfo says it is.
+	  Unfortunately, this sensor is very inaccurate when uncalibrated, so
+	  don't assume the cpu temp is actually what /proc/cpuinfo says it is.
 
 config TAU_INT
 	bool "Interrupt driven TAU driver (DANGEROUS)"
-- 
2.25.1



