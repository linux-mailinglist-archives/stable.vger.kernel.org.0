Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A91541C18
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382891AbiFGV4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382245AbiFGVuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D306F190D37;
        Tue,  7 Jun 2022 12:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD382618D5;
        Tue,  7 Jun 2022 19:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF89CC385A5;
        Tue,  7 Jun 2022 19:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628918;
        bh=48mLBrfjhKNdMqxK+VO5NBG7tpqLhjZ89rygkSAQFXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRYx9dtnRH42SoeADzGkr+9GUwXzFzsuJO3+6OAmPPxdndtHk0sS6Ovar5TVJT32f
         Y+1AamKPV3In/bvbHoKPItSB6GzFjOOjN40tX8ZkU3XA2QakEMVc50UvxX2dYN1SR/
         DcJrMxgUr3bXZ4slwWhAxPDb4PaLxyeUl7B40VYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 463/879] irqchip/gic-v3: Refactor ISB + EOIR at ack time
Date:   Tue,  7 Jun 2022 18:59:41 +0200
Message-Id: <20220607165016.313615146@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 6efb50923771f392122f5ce69dfc43b08f16e449 ]

There are cases where a context synchronization event is necessary
between an IRQ being raised and being handled, and there are races such
that we cannot rely upon the exception entry being subsequent to the
interrupt being raised. To fix this, we place an ISB between a read of
IAR and the subsequent invocation of an IRQ handler.

When EOI mode 1 is in use, we need to EOI an interrupt prior to invoking
its handler, and we have a write to EOIR for this. As this write to EOIR
requires an ISB, and this is provided by the gic_write_eoir() helper, we
omit the usual ISB in this case, with the logic being:

|	if (static_branch_likely(&supports_deactivate_key))
|		gic_write_eoir(irqnr);
|	else
|		isb();

This is somewhat opaque, and it would be a little clearer if there were
an unconditional ISB, with only the write to EOIR being conditional,
e.g.

|	if (static_branch_likely(&supports_deactivate_key))
|		write_gicreg(irqnr, ICC_EOIR1_EL1);
|
|	isb();

This patch rewrites the code that way, with this logic factored into a
new helper function with comments explaining what the ISB is for, as
were originally laid out in commit:

  39a06b67c2c1256b ("irqchip/gic: Ensure we have an ISB between ack and ->handle_irq")

Note that since then, we removed the IAR polling in commit:

  342677d70ab92142 ("irqchip/gic-v3: Remove acknowledge loop")

... which removed one of the two race conditions.

For consistency, other portions of the driver are made to manipulate
EOIR using write_gicreg() and explcit ISBs, and the gic_write_eoir()
helper function is removed.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220513133038.226182-3-mark.rutland@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/arch_gicv3.h   |  7 +----
 arch/arm64/include/asm/arch_gicv3.h |  6 ----
 drivers/irqchip/irq-gic-v3.c        | 43 ++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 413abfb42989..f82a819eb0db 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -48,6 +48,7 @@ static inline u32 read_ ## a64(void)		\
 	return read_sysreg(a32); 		\
 }						\
 
+CPUIF_MAP(ICC_EOIR1, ICC_EOIR1_EL1)
 CPUIF_MAP(ICC_PMR, ICC_PMR_EL1)
 CPUIF_MAP(ICC_AP0R0, ICC_AP0R0_EL1)
 CPUIF_MAP(ICC_AP0R1, ICC_AP0R1_EL1)
@@ -63,12 +64,6 @@ CPUIF_MAP(ICC_AP1R3, ICC_AP1R3_EL1)
 
 /* Low-level accessors */
 
-static inline void gic_write_eoir(u32 irq)
-{
-	write_sysreg(irq, ICC_EOIR1);
-	isb();
-}
-
 static inline void gic_write_dir(u32 val)
 {
 	write_sysreg(val, ICC_DIR);
diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 8bd5afc7b692..48d4473e8eee 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -26,12 +26,6 @@
  * sets the GP register's most significant bits to 0 with an explicit cast.
  */
 
-static inline void gic_write_eoir(u32 irq)
-{
-	write_sysreg_s(irq, SYS_ICC_EOIR1_EL1);
-	isb();
-}
-
 static __always_inline void gic_write_dir(u32 irq)
 {
 	write_sysreg_s(irq, SYS_ICC_DIR_EL1);
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 7305d84f2df5..0cbc4e25c48d 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -556,7 +556,8 @@ static void gic_irq_nmi_teardown(struct irq_data *d)
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	gic_write_eoir(gic_irq(d));
+	write_gicreg(gic_irq(d), ICC_EOIR1_EL1);
+	isb();
 }
 
 static void gic_eoimode1_eoi_irq(struct irq_data *d)
@@ -640,10 +641,38 @@ static void gic_deactivate_unhandled(u32 irqnr)
 		if (irqnr < 8192)
 			gic_write_dir(irqnr);
 	} else {
-		gic_write_eoir(irqnr);
+		write_gicreg(irqnr, ICC_EOIR1_EL1);
+		isb();
 	}
 }
 
+/*
+ * Follow a read of the IAR with any HW maintenance that needs to happen prior
+ * to invoking the relevant IRQ handler. We must do two things:
+ *
+ * (1) Ensure instruction ordering between a read of IAR and subsequent
+ *     instructions in the IRQ handler using an ISB.
+ *
+ *     It is possible for the IAR to report an IRQ which was signalled *after*
+ *     the CPU took an IRQ exception as multiple interrupts can race to be
+ *     recognized by the GIC, earlier interrupts could be withdrawn, and/or
+ *     later interrupts could be prioritized by the GIC.
+ *
+ *     For devices which are tightly coupled to the CPU, such as PMUs, a
+ *     context synchronization event is necessary to ensure that system
+ *     register state is not stale, as these may have been indirectly written
+ *     *after* exception entry.
+ *
+ * (2) Deactivate the interrupt when EOI mode 1 is in use.
+ */
+static inline void gic_complete_ack(u32 irqnr)
+{
+	if (static_branch_likely(&supports_deactivate_key))
+		write_gicreg(irqnr, ICC_EOIR1_EL1);
+
+	isb();
+}
+
 static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 {
 	bool irqs_enabled = interrupts_enabled(regs);
@@ -652,10 +681,7 @@ static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 	if (irqs_enabled)
 		nmi_enter();
 
-	if (static_branch_likely(&supports_deactivate_key))
-		gic_write_eoir(irqnr);
-	else
-		isb()
+	gic_complete_ack(irqnr);
 
 	/*
 	 * Leave the PSR.I bit set to prevent other NMIs to be
@@ -726,10 +752,7 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		gic_arch_enable_irqs();
 	}
 
-	if (static_branch_likely(&supports_deactivate_key))
-		gic_write_eoir(irqnr);
-	else
-		isb();
+	gic_complete_ack(irqnr);
 
 	if (generic_handle_domain_irq(gic_data.domain, irqnr)) {
 		WARN_ONCE(true, "Unexpected interrupt received!\n");
-- 
2.35.1



