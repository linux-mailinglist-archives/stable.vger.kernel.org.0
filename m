Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572EF4F39EC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378869AbiDELjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354132AbiDEKLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2186C49925;
        Tue,  5 Apr 2022 02:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB0336167E;
        Tue,  5 Apr 2022 09:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC7AC385A2;
        Tue,  5 Apr 2022 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152655;
        bh=LuZ72yR3zA8xYuhPdNlrC+HdmP3HwSUgVvw+BOohrac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUDYOzl6RVYpb9q5PNx5N1ETw+o3tq2K/erJwsN56fepq/zqAlGnIY8aOvWg0ghza
         7jOr1UO8j90LE357XTxbdBAHhQalGvg3kb7qD5xaZB2Kmrpa+Gt/JG2NeJUGDP+aCC
         ztOrzJEljUp0NpxitkjqmfHCQsiDODi4l1qHkeeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 5.15 854/913] ARM: iop32x: offset IRQ numbers by 1
Date:   Tue,  5 Apr 2022 09:31:56 +0200
Message-Id: <20220405070405.426878489@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 9d67412f24cc3a2c05f35f7c856addb07a2960ce upstream.

iop32x is one of the last platforms to use IRQ 0, and this has apparently
stopped working in a 2014 cleanup without anyone noticing. This interrupt
is used for the DMA engine, so most likely this has not actually worked
in the past 7 years, but it's also not essential for using this board.

I'm splitting out this change from my GENERIC_IRQ_MULTI_HANDLER
conversion so it can be backported if anyone cares.

Fixes: a71b092a9c68 ("ARM: Convert handle_IRQ to use __handle_domain_irq")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[ardb: take +1 offset into account in mask/unmask and init as well]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com> # ARMv7M
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-iop32x/include/mach/entry-macro.S |    2 
 arch/arm/mach-iop32x/include/mach/irqs.h        |    2 
 arch/arm/mach-iop32x/irq.c                      |    6 +-
 arch/arm/mach-iop32x/irqs.h                     |   60 ++++++++++++------------
 4 files changed, 37 insertions(+), 33 deletions(-)

--- a/arch/arm/mach-iop32x/include/mach/entry-macro.S
+++ b/arch/arm/mach-iop32x/include/mach/entry-macro.S
@@ -20,7 +20,7 @@
 	mrc     p6, 0, \irqstat, c8, c0, 0	@ Read IINTSRC
 	cmp     \irqstat, #0
 	clzne   \irqnr, \irqstat
-	rsbne   \irqnr, \irqnr, #31
+	rsbne   \irqnr, \irqnr, #32
 	.endm
 
 	.macro arch_ret_to_user, tmp1, tmp2
--- a/arch/arm/mach-iop32x/include/mach/irqs.h
+++ b/arch/arm/mach-iop32x/include/mach/irqs.h
@@ -9,6 +9,6 @@
 #ifndef __IRQS_H
 #define __IRQS_H
 
-#define NR_IRQS			32
+#define NR_IRQS			33
 
 #endif
--- a/arch/arm/mach-iop32x/irq.c
+++ b/arch/arm/mach-iop32x/irq.c
@@ -32,14 +32,14 @@ static void intstr_write(u32 val)
 static void
 iop32x_irq_mask(struct irq_data *d)
 {
-	iop32x_mask &= ~(1 << d->irq);
+	iop32x_mask &= ~(1 << (d->irq - 1));
 	intctl_write(iop32x_mask);
 }
 
 static void
 iop32x_irq_unmask(struct irq_data *d)
 {
-	iop32x_mask |= 1 << d->irq;
+	iop32x_mask |= 1 << (d->irq - 1);
 	intctl_write(iop32x_mask);
 }
 
@@ -65,7 +65,7 @@ void __init iop32x_init_irq(void)
 	    machine_is_em7210())
 		*IOP3XX_PCIIRSR = 0x0f;
 
-	for (i = 0; i < NR_IRQS; i++) {
+	for (i = 1; i < NR_IRQS; i++) {
 		irq_set_chip_and_handler(i, &ext_chip, handle_level_irq);
 		irq_clear_status_flags(i, IRQ_NOREQUEST | IRQ_NOPROBE);
 	}
--- a/arch/arm/mach-iop32x/irqs.h
+++ b/arch/arm/mach-iop32x/irqs.h
@@ -7,36 +7,40 @@
 #ifndef __IOP32X_IRQS_H
 #define __IOP32X_IRQS_H
 
+/* Interrupts in Linux start at 1, hardware starts at 0 */
+
+#define IOP_IRQ(x) ((x) + 1)
+
 /*
  * IOP80321 chipset interrupts
  */
-#define IRQ_IOP32X_DMA0_EOT	0
-#define IRQ_IOP32X_DMA0_EOC	1
-#define IRQ_IOP32X_DMA1_EOT	2
-#define IRQ_IOP32X_DMA1_EOC	3
-#define IRQ_IOP32X_AA_EOT	6
-#define IRQ_IOP32X_AA_EOC	7
-#define IRQ_IOP32X_CORE_PMON	8
-#define IRQ_IOP32X_TIMER0	9
-#define IRQ_IOP32X_TIMER1	10
-#define IRQ_IOP32X_I2C_0	11
-#define IRQ_IOP32X_I2C_1	12
-#define IRQ_IOP32X_MESSAGING	13
-#define IRQ_IOP32X_ATU_BIST	14
-#define IRQ_IOP32X_PERFMON	15
-#define IRQ_IOP32X_CORE_PMU	16
-#define IRQ_IOP32X_BIU_ERR	17
-#define IRQ_IOP32X_ATU_ERR	18
-#define IRQ_IOP32X_MCU_ERR	19
-#define IRQ_IOP32X_DMA0_ERR	20
-#define IRQ_IOP32X_DMA1_ERR	21
-#define IRQ_IOP32X_AA_ERR	23
-#define IRQ_IOP32X_MSG_ERR	24
-#define IRQ_IOP32X_SSP		25
-#define IRQ_IOP32X_XINT0	27
-#define IRQ_IOP32X_XINT1	28
-#define IRQ_IOP32X_XINT2	29
-#define IRQ_IOP32X_XINT3	30
-#define IRQ_IOP32X_HPI		31
+#define IRQ_IOP32X_DMA0_EOT	IOP_IRQ(0)
+#define IRQ_IOP32X_DMA0_EOC	IOP_IRQ(1)
+#define IRQ_IOP32X_DMA1_EOT	IOP_IRQ(2)
+#define IRQ_IOP32X_DMA1_EOC	IOP_IRQ(3)
+#define IRQ_IOP32X_AA_EOT	IOP_IRQ(6)
+#define IRQ_IOP32X_AA_EOC	IOP_IRQ(7)
+#define IRQ_IOP32X_CORE_PMON	IOP_IRQ(8)
+#define IRQ_IOP32X_TIMER0	IOP_IRQ(9)
+#define IRQ_IOP32X_TIMER1	IOP_IRQ(10)
+#define IRQ_IOP32X_I2C_0	IOP_IRQ(11)
+#define IRQ_IOP32X_I2C_1	IOP_IRQ(12)
+#define IRQ_IOP32X_MESSAGING	IOP_IRQ(13)
+#define IRQ_IOP32X_ATU_BIST	IOP_IRQ(14)
+#define IRQ_IOP32X_PERFMON	IOP_IRQ(15)
+#define IRQ_IOP32X_CORE_PMU	IOP_IRQ(16)
+#define IRQ_IOP32X_BIU_ERR	IOP_IRQ(17)
+#define IRQ_IOP32X_ATU_ERR	IOP_IRQ(18)
+#define IRQ_IOP32X_MCU_ERR	IOP_IRQ(19)
+#define IRQ_IOP32X_DMA0_ERR	IOP_IRQ(20)
+#define IRQ_IOP32X_DMA1_ERR	IOP_IRQ(21)
+#define IRQ_IOP32X_AA_ERR	IOP_IRQ(23)
+#define IRQ_IOP32X_MSG_ERR	IOP_IRQ(24)
+#define IRQ_IOP32X_SSP		IOP_IRQ(25)
+#define IRQ_IOP32X_XINT0	IOP_IRQ(27)
+#define IRQ_IOP32X_XINT1	IOP_IRQ(28)
+#define IRQ_IOP32X_XINT2	IOP_IRQ(29)
+#define IRQ_IOP32X_XINT3	IOP_IRQ(30)
+#define IRQ_IOP32X_HPI		IOP_IRQ(31)
 
 #endif


