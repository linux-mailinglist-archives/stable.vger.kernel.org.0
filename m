Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9EC368FFA
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 12:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhDWKCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 06:02:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45022 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbhDWKCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 06:02:37 -0400
Date:   Fri, 23 Apr 2021 10:01:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619172120;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ctPKG45ue98PndveiHWoeQwtbJhxuQPb+ZLRXSwDsY=;
        b=wqA6+cxpXjEgQBItRj6Ntmh/NGU4LIU2hDl+08lPSgFWcKkH0G2d1v31akk3g7/phVjQSZ
        bdmekIz/CR0egQnG3Yf/HQAtLRZJq6OZVSytujJBrxRDHXkZFkJmKbddlqi2i/388moKAW
        P42mlpisczpEDOhJCRlvHVBAru/rYxcfziecDScp9Bn+vAK0q6cqQmDhEG/LwmRmXKPrKM
        tH2svs9q+hQCmafg2+Tfdri2e8MQ5h9WHIs7CHubwp13R9yj8KJJo6GjhVD3Al86Ohv2aT
        feoGFxH/iew2Vjo67tdqPWnhrfYdj9hBDxiKBjOP+B4sdwZoyYUTTyo/R4yPHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619172120;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ctPKG45ue98PndveiHWoeQwtbJhxuQPb+ZLRXSwDsY=;
        b=kTtH6H36c45k67t2ij0ROyIBnMucE2uEOrY4QGHT3yrspak7Axrotz3aDi28fO7N/FlvrO
        stjYGMYIHsiOp5Cg==
From:   "irqchip-bot for He Ying" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/gic-v3: Do not enable irqs when
 handling spurious interrups
Cc:     He Ying <heying24@huawei.com>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20210423083516.170111-1-heying24@huawei.com>
References: <20210423083516.170111-1-heying24@huawei.com>
MIME-Version: 1.0
Message-ID: <161917211934.29796.1841651233234902273.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     dd223f479a5b2cba5ba5c0afddf726df02a4f08f
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/dd223f479a5b2cba5ba5c0afddf726df02a4f08f
Author:        He Ying <heying24@huawei.com>
AuthorDate:    Fri, 23 Apr 2021 04:35:16 -04:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Fri, 23 Apr 2021 10:55:48 +01:00

irqchip/gic-v3: Do not enable irqs when handling spurious interrups

We triggered the following error while running our 4.19 kernel
with the pseudo-NMI patches backported to it:

[   14.816231] ------------[ cut here ]------------
[   14.816231] kernel BUG at irq.c:99!
[   14.816232] Internal error: Oops - BUG: 0 [#1] SMP
[   14.816232] Process swapper/0 (pid: 0, stack limit = 0x(____ptrval____))
[   14.816233] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O      4.19.95.aarch64 #14
[   14.816233] Hardware name: evb (DT)
[   14.816234] pstate: 80400085 (Nzcv daIf +PAN -UAO)
[   14.816234] pc : asm_nmi_enter+0x94/0x98
[   14.816235] lr : asm_nmi_enter+0x18/0x98
[   14.816235] sp : ffff000008003c50
[   14.816235] pmr_save: 00000070
[   14.816237] x29: ffff000008003c50 x28: ffff0000095f56c0
[   14.816238] x27: 0000000000000000 x26: ffff000008004000
[   14.816239] x25: 00000000015e0000 x24: ffff8008fb916000
[   14.816240] x23: 0000000020400005 x22: ffff0000080817cc
[   14.816241] x21: ffff000008003da0 x20: 0000000000000060
[   14.816242] x19: 00000000000003ff x18: ffffffffffffffff
[   14.816243] x17: 0000000000000008 x16: 003d090000000000
[   14.816244] x15: ffff0000095ea6c8 x14: ffff8008fff5ab40
[   14.816244] x13: ffff8008fff58b9d x12: 0000000000000000
[   14.816245] x11: ffff000008c8a200 x10: 000000008e31fca5
[   14.816246] x9 : ffff000008c8a208 x8 : 000000000000000f
[   14.816247] x7 : 0000000000000004 x6 : ffff8008fff58b9e
[   14.816248] x5 : 0000000000000000 x4 : 0000000080000000
[   14.816249] x3 : 0000000000000000 x2 : 0000000080000000
[   14.816250] x1 : 0000000000120000 x0 : ffff0000095f56c0
[   14.816251] Call trace:
[   14.816251]  asm_nmi_enter+0x94/0x98
[   14.816251]  el1_irq+0x8c/0x180                    (IRQ C)
[   14.816252]  gic_handle_irq+0xbc/0x2e4
[   14.816252]  el1_irq+0xcc/0x180                    (IRQ B)
[   14.816253]  arch_timer_handler_virt+0x38/0x58
[   14.816253]  handle_percpu_devid_irq+0x90/0x240
[   14.816253]  generic_handle_irq+0x34/0x50
[   14.816254]  __handle_domain_irq+0x68/0xc0
[   14.816254]  gic_handle_irq+0xf8/0x2e4
[   14.816255]  el1_irq+0xcc/0x180                    (IRQ A)
[   14.816255]  arch_cpu_idle+0x34/0x1c8
[   14.816255]  default_idle_call+0x24/0x44
[   14.816256]  do_idle+0x1d0/0x2c8
[   14.816256]  cpu_startup_entry+0x28/0x30
[   14.816256]  rest_init+0xb8/0xc8
[   14.816257]  start_kernel+0x4c8/0x4f4
[   14.816257] Code: 940587f1 d5384100 b9401001 36a7fd01 (d4210000)
[   14.816258] Modules linked in: start_dp(O) smeth(O)
[   15.103092] ---[ end trace 701753956cb14aa8 ]---
[   15.103093] Kernel panic - not syncing: Fatal exception in interrupt
[   15.103099] SMP: stopping secondary CPUs
[   15.103100] Kernel Offset: disabled
[   15.103100] CPU features: 0x36,a2400218
[   15.103100] Memory Limit: none

which is cause by a 'BUG_ON(in_nmi())' in nmi_enter().

>From the call trace, we can find three interrupts (noted A, B, C above):
interrupt (A) is preempted by (B), which is further interrupted by (C).

Subsequent investigations show that (B) results in nmi_enter() being
called, but that it actually is a spurious interrupt. Furthermore,
interrupts are reenabled in the context of (B), and (C) fires with
NMI priority. We end-up with a nested NMI situation, something
we definitely do not want to (and cannot) handle.

The bug here is that spurious interrupts should never result in any
state change, and we should just return to the interrupted context.
Moving the handling of spurious interrupts as early as possible in
the GICv3 handler fixes this issue.

Fixes: 3f1f3234bc2d ("irqchip/gic-v3: Switch to PMR masking before calling IRQ handler")
Signed-off-by: He Ying <heying24@huawei.com>
[maz: rewrote commit message, corrected Fixes: tag]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210423083516.170111-1-heying24@huawei.com
Cc: stable@vger.kernel.org
---
 drivers/irqchip/irq-gic-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index eb0ee35..0040402 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -648,6 +648,10 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 
 	irqnr = gic_read_iar();
 
+	/* Check for special IDs first */
+	if ((irqnr >= 1020 && irqnr <= 1023))
+		return;
+
 	if (gic_supports_nmi() &&
 	    unlikely(gic_read_rpr() == GICD_INT_NMI_PRI)) {
 		gic_handle_nmi(irqnr, regs);
@@ -659,10 +663,6 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		gic_arch_enable_irqs();
 	}
 
-	/* Check for special IDs first */
-	if ((irqnr >= 1020 && irqnr <= 1023))
-		return;
-
 	if (static_branch_likely(&supports_deactivate_key))
 		gic_write_eoir(irqnr);
 	else
