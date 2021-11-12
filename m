Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8D44EB2E
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 17:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhKLQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 11:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhKLQRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 11:17:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69363C061766;
        Fri, 12 Nov 2021 08:15:02 -0800 (PST)
Date:   Fri, 12 Nov 2021 16:15:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636733701;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwubUX8ElWI7HDQBRs6iKFhCP+MJ2gNTthLF+UykuNY=;
        b=uf83b3MnCREb/xCvyTsW8G2b9MaFKkBu61zF2jw2oVnGlRqLorDcQN+34bsRypgsbYarxK
        KKBUxymnLoGZdSCRi+il/CAOgAw+jKHvOO/z4nLXLi/f4V7bvliuNK6v3ZJlnOTHYKNENh
        PrnLMZgD7A5hiLDfOTVktD1JV53SGIPXVlcji/auixTNgbl3GkFGiObSrQTGo2j2lE+CeT
        +JTaRiRa8UzPxT/TQf3H74PnAHBKMaEPKiQ8DsM7T8iKHfS4XVcq5FjwncNhbRs8EY3D4o
        UZeVLwzGdS9Vy+h/PMoPZeqE193FqW0hyQoxZrkFC25kL9mpMVaJIWjwF2Ux2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636733701;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwubUX8ElWI7HDQBRs6iKFhCP+MJ2gNTthLF+UykuNY=;
        b=N5vXFVMOCpdd2uJ0KXlNEiQl9OeHppo1+qjsNxIDPTAcf1H4QIQdSTGJ5hP9Cbtk5OVhs7
        3X2g6+uTD3hxnwBA==
From:   "irqchip-bot for Guo Ren" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-fixes] irqchip/sifive-plic: Fixup EOI failed
 when masked
Cc:     Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Guo Ren <guoren@linux.alibaba.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>, Marc Zyngier <maz@kernel.org>
In-Reply-To: <20211105094748.3894453-1-guoren@kernel.org>
References: <20211105094748.3894453-1-guoren@kernel.org>
MIME-Version: 1.0
Message-ID: <163673370017.414.6466255977362659814.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-fixes branch of irqchip:

Commit-ID:     69ea463021be0d159ab30f96195fb0dd18ee2272
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/69ea463021be0d159ab30f96195fb0dd18ee2272
Author:        Guo Ren <guoren@linux.alibaba.com>
AuthorDate:    Fri, 05 Nov 2021 17:47:48 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Fri, 12 Nov 2021 16:09:51 

irqchip/sifive-plic: Fixup EOI failed when masked

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
---
 drivers/irqchip/irq-sifive-plic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index cf74cfa..259065d 100644
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
