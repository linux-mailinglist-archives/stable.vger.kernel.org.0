Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3813368EE4
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 10:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhDWIfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 04:35:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16616 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241368AbhDWIfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 04:35:50 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FRSGS0nlWz1BGtK;
        Fri, 23 Apr 2021 16:32:48 +0800 (CST)
Received: from huawei.com (10.67.174.47) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Fri, 23 Apr 2021
 16:35:05 +0800
From:   He Ying <heying24@huawei.com>
To:     <tglx@linutronix.de>, <maz@kernel.org>,
        <julien.thierry.kdev@gmail.com>, <catalin.marinas@arm.com>,
        <mark.rutland@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <heying24@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] irqchip/gic-v3: Do not enable irqs when handling spurious interrups
Date:   Fri, 23 Apr 2021 04:35:16 -0400
Message-ID: <20210423083516.170111-1-heying24@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.47]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found this problem in our kernel src tree:

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

I look into this issue and find that it's caused by 'BUG_ON(in_nmi())'
in nmi_enter(). From the call trace, we can find three interrupts which
I mark as IRQ A, B and C. By adding some prints, I find the IRQ B also
calls nmi_enter(), but its priority is not GICD_INT_NMI_PRI and its irq
number is 1023. It enables irq by calling gic_arch_enable_irqs() in
gic_handle_irq(). At this moment, IRQ C preempts the IRQ B and it's
an NMI but current context is already in nmi. So that may be the problem.

When handling spurious interrupts, we shouldn't enable irqs. That's
because for spurious interrupts we may enter nmi context in el1_irq()
because current PMR may be GIC_PRIO_IRQOFF. If we enable irqs at this
time, another NMI may happen and preempt this spurious interrupt
but the context is already in nmi. That causes a bug on if nested NMI
is not supported. Even for nested nmi, it's not a normal scenario.

Though the issue is reported on our private tree, I think it also
exists on the latest tree for the reasons above. To fix this issue,
check spurious interrupts right after the read of ICC_IAR1_EL1 and
return directly for spurious interrupts.

Fixes: 17ce302f3117 ("arm64: Fix interrupt tracing in the presence of NMIs")
Signed-off-by: He Ying <heying24@huawei.com>
---

v2:
- Move the check right after the read of ICC_IAR1_EL1 suggested by Marc.

 drivers/irqchip/irq-gic-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 94b89258d045..37a23aa6de37 100644
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
-- 
2.17.1

