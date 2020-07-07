Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C0216DF9
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgGGNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:44:04 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53837 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726805AbgGGNoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 09:44:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4B0581941498;
        Tue,  7 Jul 2020 09:44:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 09:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aGra8q
        EPsEIsfc3LPwbKsH2tdN5+4xBfbVWz3a2sB/I=; b=bydzL8qAWxBRTpBuBAL0go
        ki83/xKZ0AlRY811RnorEYcF9qp//fkQnhW8SBFYmNZFQGnHKo1gVfSUVKOp7r6J
        ZR6K7OKmxGbCgEqxm9iOIKiEfLbJTOqjAoOBIKAJ8h7pJVQNqPJ7PC3dV8wOlZyW
        Y8dDmbYk48bWRlNto605Z8/qickfPUK5BeA9lIagNRe6xUaXsEaSTLYhdjUW++4C
        XMykBX219UxXqwbXPwDZ5RO2ztQXowrvgptDbz0BSsnqJTw3CB5WJX9rNLMmnAY9
        lGRK4Xz0egfVIMT73iIt3fw9HWNAhndDZjYq1M6n2e0wjFWDt6eCK8Om755LTOtg
        ==
X-ME-Sender: <xms:InwEX0RMHV4yqyn7tsoZ0TZeES3wmOEao5t6YVCpqoUDEZ1bIDGeIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:I3wEXxytpPMjNUCBmDn4vS2JxJIaQBMkwRkCos89HSHO-N9L3d3apA>
    <xmx:I3wEXx011YX_EsjiBvU90d_7FTQ6E1T5FFnoX_rNh-haYZRRppHfPQ>
    <xmx:I3wEX4AXH-tFzunqKhCxpHEKYtGJ9b79UlcvjOJ336Bfqj_7aVixFA>
    <xmx:I3wEX4t7SSLyqQbuY0JJ-huE_uRXnwSAt3h9llBCjyj0Tjfq6ABKfw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 922AA30600A6;
        Tue,  7 Jul 2020 09:44:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] irqchip/gic: Atomically update affinity" failed to apply to 4.9-stable tree
To:     maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jul 2020 15:44:01 +0200
Message-ID: <159412944191184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 005c34ae4b44f085120d7f371121ec7ded677761 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Sun, 21 Jun 2020 14:43:15 +0100
Subject: [PATCH] irqchip/gic: Atomically update affinity

The GIC driver uses a RMW sequence to update the affinity, and
relies on the gic_lock_irqsave/gic_unlock_irqrestore sequences
to update it atomically.

But these sequences only expand into anything meaningful if
the BL_SWITCHER option is selected, which almost never happens.

It also turns out that using a RMW and locks is just as silly,
as the GIC distributor supports byte accesses for the GICD_TARGETRn
registers, which when used make the update atomic by definition.

Drop the terminally broken code and replace it by a byte write.

Fixes: 04c8b0f82c7d ("irqchip/gic: Make locking a BL_SWITCHER only feature")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 00de05abd3c3..c17fabd6741e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -329,10 +329,8 @@ static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
-	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
-	u32 val, mask, bit;
-	unsigned long flags;
+	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + gic_irq(d);
+	unsigned int cpu;
 
 	if (!force)
 		cpu = cpumask_any_and(mask_val, cpu_online_mask);
@@ -342,13 +340,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	gic_lock_irqsave(flags);
-	mask = 0xff << shift;
-	bit = gic_cpu_map[cpu] << shift;
-	val = readl_relaxed(reg) & ~mask;
-	writel_relaxed(val | bit, reg);
-	gic_unlock_irqrestore(flags);
-
+	writeb_relaxed(gic_cpu_map[cpu], reg);
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
 	return IRQ_SET_MASK_OK_DONE;

