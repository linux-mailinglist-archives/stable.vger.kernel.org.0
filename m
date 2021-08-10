Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792453E5649
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbhHJJIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbhHJJII (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB90EC061798;
        Tue, 10 Aug 2021 02:07:46 -0700 (PDT)
Date:   Tue, 10 Aug 2021 09:07:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586463;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IuWigQeLnGaq31vRyhCNwa1Rq+IhfYNU1Rv5pSyk9rM=;
        b=YaZnFr3eM+2yD+YhRUOnzjZZw5Mm049411iwutpfX0BCf7iPGFnfwex20pR9hIN8PgpvAw
        CJWKG/wAV32ObZx6ihHH3J4E100a/DTjVZvZ9J1vyEOpBNaZj06xmPNyaCdE0WWw7ZwhzF
        egHR5KJ9XVmeX/rw/ma8e/xjvJeIjetKxmIGM7TdJHUNvhRr8FAMGgojjYUOf+ix53NJ7V
        fQPaA91m3BG7i8PQxPZnC9rdv/e2lUpkRdGWAWPtCdF3+H8pCJO95DS0KGiV8D+rmsDCFK
        5ZBv/oMpWv7g4T5M6mZsexeSqCrfqsCU7tT24wTnngcncmgPQUOzjml4vapB9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586463;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IuWigQeLnGaq31vRyhCNwa1Rq+IhfYNU1Rv5pSyk9rM=;
        b=qif0DK8G4+HTgCi8mFeY615y1X+JU4Cvmlopvjt5peE910GJWkxqNyUQXA5EjB2trH9bVs
        FLhWBax0xyj+GtCw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] x86/ioapic: Force affinity setup before startup
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.832143400@linutronix.de>
References: <20210729222542.832143400@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646280.395.1270819604479337700.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     0c0e37dc11671384e53ba6ede53a4d91162a2cc5
Gitweb:        https://git.kernel.org/tip/0c0e37dc11671384e53ba6ede53a4d91162a2cc5
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:49 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:21 +02:00

x86/ioapic: Force affinity setup before startup

The IO/APIC cannot handle interrupt affinity changes safely after startup
other than from an interrupt handler. The startup sequence in the generic
interrupt code violates that assumption.

Mark the irq chip with the new IRQCHIP_AFFINITY_PRE_STARTUP flag so that
the default interrupt setting happens before the interrupt is started up
for the first time.

Fixes: 18404756765c ("genirq: Expose default irq affinity mask (take 3)")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.832143400@linutronix.de


---
 arch/x86/kernel/apic/io_apic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5c691a..39224e0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1986,7 +1986,8 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct irq_chip ioapic_ir_chip __read_mostly = {
@@ -1999,7 +2000,8 @@ static struct irq_chip ioapic_ir_chip __read_mostly = {
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static inline void init_IO_APIC_traps(void)
