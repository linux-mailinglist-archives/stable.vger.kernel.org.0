Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F7B202B03
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgFUO0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 10:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730120AbgFUO0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 10:26:01 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02ECD2083E;
        Sun, 21 Jun 2020 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592749561;
        bh=W0GxbCl0T6tlIURC2FrWHy0pl7O2r2pLvdotzPz142k=;
        h=From:To:Cc:Subject:Date:From;
        b=niQc58EJh7aqd2Rg73A6I9LirIVVVZpJv5bB7kacWxGD6weZMCUkjN5OQImAXUaRu
         7AFFXZEL9t9bAGVG+sLBSSfSq/YsixTIdoiK/R4Xookn0JIdT6QiaUkiPv61wSm7JY
         SeOgaGnPdd6SsMA057+6q5cQ3sdo8GEkSXK0WF6Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jn0v1-0056g4-EX; Sun, 21 Jun 2020 15:25:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, stable@vger.kernel.org
Subject: [PATCH] irqchip/gic: Atomically update affinity
Date:   Sun, 21 Jun 2020 15:25:37 +0100
Message-Id: <20200621142537.784191-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, jason@lakedaemon.net, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/irqchip/irq-gic.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

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
-- 
2.26.2

