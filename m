Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D3D6896A1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbjBCKbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbjBCKaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A89A07CA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2041761E93
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC8BC433D2;
        Fri,  3 Feb 2023 10:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420174;
        bh=zDpHAm1OUlImzdPXBA0SE2thcz18ap7cRJsY/4du8Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NV46xF5WHRVVS603upbpjDTccM0+EjpZuyBMhx66dem8xzMjrYIbflaqNV6dhFdG3
         UJ8dViL38jCAo5AcN+2J5J5cguKboh2RVJQOKtM81PMTq8yyc2vk1sHZlEzMV8FQY7
         BQ5kS91/CAl2PrRs1SR/dw6yovW0GWjdPuir93pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baoquan He <bhe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 105/134] x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL
Date:   Fri,  3 Feb 2023 11:13:30 +0100
Message-Id: <20230203101028.565304817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 5fa55950729d0762a787451dc52862c3f850f859 upstream.

Baoquan reported that after triggering a crash the subsequent crash-kernel
fails to boot about half of the time. It triggers a NULL pointer
dereference in the periodic tick code.

This happens because the legacy timer interrupt (IRQ0) is resent in
software which happens in soft interrupt (tasklet) context. In this context
get_irq_regs() returns NULL which leads to the NULL pointer dereference.

The reason for the resend is a spurious APIC interrupt on the IRQ0 vector
which is captured and leads to a resend when the legacy timer interrupt is
enabled. This is wrong because the legacy PIC interrupts are level
triggered and therefore should never be resent in software, but nothing
ever sets the IRQ_LEVEL flag on those interrupts, so the core code does not
know about their trigger type.

Ensure that IRQ_LEVEL is set when the legacy PCI interrupts are set up.

Fixes: a4633adcdbc1 ("[PATCH] genirq: add genirq sw IRQ-retrigger")
Reported-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Baoquan He <bhe@redhat.com>
Link: https://lore.kernel.org/r/87mt6rjrra.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/i8259.c   |    1 +
 arch/x86/kernel/irqinit.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -114,6 +114,7 @@ static void make_8259A_irq(unsigned int
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
 	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
+	irq_set_status_flags(irq, IRQ_LEVEL);
 	enable_irq(irq);
 	lapic_assign_legacy_vector(irq, true);
 }
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -72,8 +72,10 @@ void __init init_ISA_irqs(void)
 
 	legacy_pic->init(0);
 
-	for (i = 0; i < nr_legacy_irqs(); i++)
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		irq_set_chip_and_handler(i, chip, handle_level_irq);
+		irq_set_status_flags(i, IRQ_LEVEL);
+	}
 }
 
 void __init init_IRQ(void)


