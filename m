Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27D61AF11B
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDROyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgDROld (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:41:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D4CA22244;
        Sat, 18 Apr 2020 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220892;
        bh=yQHRGgg3m1GX/ZcnnSRuq3xEturIrft/FV/zlgGBQcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txVXuX4FsPgaEmcG0mrN+6F5X/LTHswtn5TV/tFY3ygEPrgoZxMj2hDlP5k0GumFe
         w5gqie5tMAryC19/868rTsWfDr3FgKFfm/MDMrTMbja2avJo7e8U/t36aJwwSkyRLb
         0Zgw+vOjgh9RLvWc3REYEil1+HG4qlw+eiLw2l0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 35/78] Revert "powerpc/64: irq_work avoid interrupt when called with hardware irqs enabled"
Date:   Sat, 18 Apr 2020 10:40:04 -0400
Message-Id: <20200418144047.9013-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit abc3fce76adbdfa8f87272c784b388cd20b46049 ]

This reverts commit ebb37cf3ffd39fdb6ec5b07111f8bb2f11d92c5f.

That commit does not play well with soft-masked irq state
manipulations in idle, interrupt replay, and possibly others due to
tracing code sometimes using irq_work_queue (e.g., in
trace_hardirqs_on()). That can cause PACA_IRQ_DEC to become set when
it is not expected, and be ignored or cleared or cause warnings.

The net result seems to be missing an irq_work until the next timer
interrupt in the worst case which is usually not going to be noticed,
however it could be a long time if the tick is disabled, which is
against the spirit of irq_work and might cause real problems.

The idea is still solid, but it would need more work. It's not really
clear if it would be worth added complexity, so revert this for
now (not a straight revert, but replace with a comment explaining why
we might see interrupts happening, and gives git blame something to
find).

Fixes: ebb37cf3ffd3 ("powerpc/64: irq_work avoid interrupt when called with hardware irqs enabled")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200402120401.1115883-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 44 +++++++++++---------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 11301a1187f33..0e0a2227af7d7 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -522,35 +522,6 @@ static inline void clear_irq_work_pending(void)
 		"i" (offsetof(struct paca_struct, irq_work_pending)));
 }
 
-void arch_irq_work_raise(void)
-{
-	preempt_disable();
-	set_irq_work_pending_flag();
-	/*
-	 * Non-nmi code running with interrupts disabled will replay
-	 * irq_happened before it re-enables interrupts, so setthe
-	 * decrementer there instead of causing a hardware exception
-	 * which would immediately hit the masked interrupt handler
-	 * and have the net effect of setting the decrementer in
-	 * irq_happened.
-	 *
-	 * NMI interrupts can not check this when they return, so the
-	 * decrementer hardware exception is raised, which will fire
-	 * when interrupts are next enabled.
-	 *
-	 * BookE does not support this yet, it must audit all NMI
-	 * interrupt handlers to ensure they call nmi_enter() so this
-	 * check would be correct.
-	 */
-	if (IS_ENABLED(CONFIG_BOOKE) || !irqs_disabled() || in_nmi()) {
-		set_dec(1);
-	} else {
-		hard_irq_disable();
-		local_paca->irq_happened |= PACA_IRQ_DEC;
-	}
-	preempt_enable();
-}
-
 #else /* 32-bit */
 
 DEFINE_PER_CPU(u8, irq_work_pending);
@@ -559,16 +530,27 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 #define test_irq_work_pending()		__this_cpu_read(irq_work_pending)
 #define clear_irq_work_pending()	__this_cpu_write(irq_work_pending, 0)
 
+#endif /* 32 vs 64 bit */
+
 void arch_irq_work_raise(void)
 {
+	/*
+	 * 64-bit code that uses irq soft-mask can just cause an immediate
+	 * interrupt here that gets soft masked, if this is called under
+	 * local_irq_disable(). It might be possible to prevent that happening
+	 * by noticing interrupts are disabled and setting decrementer pending
+	 * to be replayed when irqs are enabled. The problem there is that
+	 * tracing can call irq_work_raise, including in code that does low
+	 * level manipulations of irq soft-mask state (e.g., trace_hardirqs_on)
+	 * which could get tangled up if we're messing with the same state
+	 * here.
+	 */
 	preempt_disable();
 	set_irq_work_pending_flag();
 	set_dec(1);
 	preempt_enable();
 }
 
-#endif /* 32 vs 64 bit */
-
 #else  /* CONFIG_IRQ_WORK */
 
 #define test_irq_work_pending()	0
-- 
2.20.1

