Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE28E592488
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiHNQcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242303AbiHNQaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:30:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D90DBF5;
        Sun, 14 Aug 2022 09:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43C7ECE0B5E;
        Sun, 14 Aug 2022 16:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A65C433C1;
        Sun, 14 Aug 2022 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494311;
        bh=ON/kXxC3offAntPhv8p0Hoo5JwKdH8ee2XaV4xXqYBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEtNcJVmGop6Poq8uYyaVg6C9jgyyHgH6hpMG0MBnKpf6Njth11aRZF87q59O5rV3
         uJ059fkvURrWdsAUh+hwBkkZ67N7hErSoGmRUMWOf6gVbWxgw86+bnEYhIe6yGEpZm
         FBxWOaiJ25vyqUYDoE5osXRdIv27MMsuVx15zG+zZN1UDifef+RyNP+aFKA1EhXe2y
         8WCIZqnROZBS8dF3Kk3BeHkwC/4zvLrO3pDkzVN41CRAhZyr8TcdA16xyWhyAcwbwG
         I9v20A0WjO5wk1x0yzrfEQej8DuTTLSnywrwIvB80UOtVTBZ7VZUWhHgtdviT8jS2c
         XcCxllcgCdgKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, pmladek@suse.com,
        john.ogness@linutronix.de, Julia.Lawall@inria.fr,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.18 22/39] powerpc/watchdog: introduce a NMI watchdog's factor
Date:   Sun, 14 Aug 2022 12:23:11 -0400
Message-Id: <20220814162332.2396012-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit f5e74e836097d1004077390717d4bd95d4a2c27a ]

Introduce a factor which would apply to the NMI watchdog timeout.

This factor is a percentage added to the watchdog_tresh value. The value is
set under the watchdog_mutex protection and lockup_detector_reconfigure()
is called to recompute wd_panic_timeout_tb.

Once the factor is set, it remains until it is set back to 0, which means
no impact.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220713154729.80789-4-ldufour@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/nmi.h |  2 ++
 arch/powerpc/kernel/watchdog.c | 21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/nmi.h b/arch/powerpc/include/asm/nmi.h
index ea0e487f87b1..c3c7adef74de 100644
--- a/arch/powerpc/include/asm/nmi.h
+++ b/arch/powerpc/include/asm/nmi.h
@@ -5,8 +5,10 @@
 #ifdef CONFIG_PPC_WATCHDOG
 extern void arch_touch_nmi_watchdog(void);
 long soft_nmi_interrupt(struct pt_regs *regs);
+void watchdog_nmi_set_timeout_pct(u64 pct);
 #else
 static inline void arch_touch_nmi_watchdog(void) {}
+static inline void watchdog_nmi_set_timeout_pct(u64 pct) {}
 #endif
 
 #ifdef CONFIG_NMI_IPI
diff --git a/arch/powerpc/kernel/watchdog.c b/arch/powerpc/kernel/watchdog.c
index bfc27496fe7e..1d0fe8e9c900 100644
--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -91,6 +91,10 @@ static cpumask_t wd_smp_cpus_pending;
 static cpumask_t wd_smp_cpus_stuck;
 static u64 wd_smp_last_reset_tb;
 
+#ifdef CONFIG_PPC_PSERIES
+static u64 wd_timeout_pct;
+#endif
+
 /*
  * Try to take the exclusive watchdog action / NMI IPI / printing lock.
  * wd_smp_lock must be held. If this fails, we should return and wait
@@ -527,7 +531,13 @@ static int stop_watchdog_on_cpu(unsigned int cpu)
 
 static void watchdog_calc_timeouts(void)
 {
-	wd_panic_timeout_tb = watchdog_thresh * ppc_tb_freq;
+	u64 threshold = watchdog_thresh;
+
+#ifdef CONFIG_PPC_PSERIES
+	threshold += (READ_ONCE(wd_timeout_pct) * threshold) / 100;
+#endif
+
+	wd_panic_timeout_tb = threshold * ppc_tb_freq;
 
 	/* Have the SMP detector trigger a bit later */
 	wd_smp_panic_timeout_tb = wd_panic_timeout_tb * 3 / 2;
@@ -570,3 +580,12 @@ int __init watchdog_nmi_probe(void)
 	}
 	return 0;
 }
+
+#ifdef CONFIG_PPC_PSERIES
+void watchdog_nmi_set_timeout_pct(u64 pct)
+{
+	pr_info("Set the NMI watchdog timeout factor to %llu%%\n", pct);
+	WRITE_ONCE(wd_timeout_pct, pct);
+	lockup_detector_reconfigure();
+}
+#endif
-- 
2.35.1

