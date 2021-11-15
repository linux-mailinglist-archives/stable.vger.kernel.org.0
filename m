Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B191451EB2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348547AbhKPAhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344938AbhKOTZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3432636EA;
        Mon, 15 Nov 2021 19:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003229;
        bh=lWzXz7YK30/LfxHfXGr0JHKMYURieNx3gsFwnmZ3kZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDQzeuSFskXQf2qUVwiTHePJsLkh4ZI4ns94YncVFhc+Jla+c0TVsaZVT8SYXSiu7
         qep71ajn6LwSRxhIWm500i51ONpL6/NaU5lIG9SNfR1WNMekgNPeY3JAcrp3kmgi/X
         5bq9SND4RY1zyj99s3h+Ce5neM5fy9KC/3QDMGgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Guo Ren <guoren@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 859/917] irqchip/sifive-plic: Fixup EOI failed when masked
Date:   Mon, 15 Nov 2021 18:05:54 +0100
Message-Id: <20211115165458.162687044@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 69ea463021be0d159ab30f96195fb0dd18ee2272 upstream.

When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in a driver,
only the first interrupt is handled, and following interrupts are never
delivered (initially reported in [1]).

That's because the RISC-V PLIC cannot EOI masked interrupts, as explained
in the description of Interrupt Completion in the PLIC spec [2]:

<quote>
The PLIC signals it has completed executing an interrupt handler by
writing the interrupt ID it received from the claim to the claim/complete
register. The PLIC does not check whether the completion ID is the same
as the last claim ID for that target. If the completion ID does not match
an interrupt source that *is currently enabled* for the target, the
completion is silently ignored.
</quote>

Re-enable the interrupt before completion if it has been masked during
the handling, and remask it afterwards.

[1] http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
[2] https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc

Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Atish Patra <atish.patra@wdc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
[maz: amended commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211105094748.3894453-1-guoren@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-sifive-plic.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -163,7 +163,13 @@ static void plic_irq_eoi(struct irq_data
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


