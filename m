Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE5B44618A
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 10:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhKEJuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 05:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEJuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 05:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E7FA61053;
        Fri,  5 Nov 2021 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636105686;
        bh=JOH80MQM+ARdKAOqfocajIJekKiO0ckjPSkcV5eTJ6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=bRUUYc42UheVd+lqBiGwbxGbznCjzRk26KuZ5te7exx7ygeJ5/15bNZQboLZItdnz
         1pgj3VWS3Osq/SEVVfsEDRrB1MZLSHBpgS0DCcbwe15wFXK5u9bKKu1UT3TttfCX/d
         AHZzMOjA4A8h2SOCXKI3CZNsPBJjW9zIH0GGCBGqVLdPXffkv96KigvFiMTlDoRZLK
         IUviqWEUOeA6jXVMsmUWupwIGpvavc3vIUdwIIca8xBcFLNh+XHsVpa60uz37zvy0C
         azLx7qZLBPNnOi2exrFihtm9p3Fa47clMfh07H/ZihSFo+D69ghw8NshSKX7ACLV+S
         9xW0ysPLIdFjg==
From:   guoren@kernel.org
To:     guoren@kernel.org, anup@brainfault.org, atish.patra@wdc.com,
        maz@kernel.org, tglx@linutronix.de, palmer@dabbelt.com
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        stable@vger.kernel.org
Subject: [PATCH V7] irqchip/sifive-plic: Fixup EOI failed when masked
Date:   Fri,  5 Nov 2021 17:47:48 +0800
Message-Id: <20211105094748.3894453-1-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in the driver,
only the first interrupt could be handled, and continue irq is blocked by
hw. Because the riscv plic couldn't complete masked irq source which has
been disabled in enable register. The bug was firstly reported in [1].

Here is the description of Interrupt Completion in PLIC spec [2]:

The PLIC signals it has completed executing an interrupt handler by
writing the interrupt ID it received from the claim to the claim/complete
register. The PLIC does not check whether the completion ID is the same
as the last claim ID for that target. If the completion ID does not match
an interrupt source that is currently enabled for the target, the
                         ^^ ^^^^^^^^^ ^^^^^^^
completion is silently ignored.

[1] http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
[2] https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc

Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: stable@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Atish Patra <atish.patra@wdc.com>
Cc: Nikita Shubin <nikita.shubin@maquefel.me>
Cc: incent Pelletier <plr.vincent@gmail.com>

---

Changes since V7:
 - Add Fixes tag
 - Add Tested-by
 - Add Cc stable

Changes since V6:
 - Propagate to plic_irq_eoi for all riscv,plic by Nikita Shubin
 - Remove thead related codes

Changes since V5:
 - Move back to mask/unmask
 - Fixup the problem in eoi callback
 - Remove allwinner,sun20i-d1 IRQCHIP_DECLARE
 - Rewrite comment log

Changes since V4:
 - Update comment by Anup

Changes since V3:
 - Rename "c9xx" to "c900"
 - Add sifive_plic_chip and thead_plic_chip for difference

Changes since V2:
 - Add a separate compatible string "thead,c9xx-plic"
 - set irq_mask/unmask of "plic_chip" to NULL and point
   irq_enable/disable of "plic_chip" to plic_irq_mask/unmask
 - Add a detailed comment block in plic_init() about the
   differences in Claim/Completion process of RISC-V PLIC and C9xx
   PLIC.
---
 drivers/irqchip/irq-sifive-plic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index cf74cfa82045..259065d271ef 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -163,7 +163,13 @@ static void plic_irq_eoi(struct irq_data *d)
 {
 	struct plic_handler *handler = this_cpu_ptr(&plic_handlers);
 
-	writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+	if (irqd_irq_masked(d)) {
+		plic_irq_unmask(d);
+		writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+		plic_irq_mask(d);
+	} else {
+		writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+	}
 }
 
 static struct irq_chip plic_chip = {
-- 
2.25.1

