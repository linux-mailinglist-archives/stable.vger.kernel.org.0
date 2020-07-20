Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C78226B8E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbgGTQml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730249AbgGTPnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:43:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CB520773;
        Mon, 20 Jul 2020 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259803;
        bh=DDE4MV+UVz+utgNs90ZX1nxcGpr1BUDKlUVFvene7KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3XYt2YAxeQulLDmDRiHt4TOQXZIm/x+B4cAvjwelixtlTFY3aMr3FiuNt35vVkKg
         Jyg8wdCiZ8qBR8d3AvWx2skz9y4RUrl8ONzeEqz3J02EX7cdMcXDgINJwq9shBSmly
         G2prmAVXW3UtHe8bI5+fyhukaDwH9g/h/5gvv+NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.9 85/86] irqchip/gic: Atomically update affinity
Date:   Mon, 20 Jul 2020 17:37:21 +0200
Message-Id: <20200720152757.554539964@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 005c34ae4b44f085120d7f371121ec7ded677761 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/irqchip/irq-gic.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -324,10 +324,8 @@ static int gic_irq_set_vcpu_affinity(str
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
@@ -337,12 +335,7 @@ static int gic_set_affinity(struct irq_d
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	gic_lock_irqsave(flags);
-	mask = 0xff << shift;
-	bit = gic_cpu_map[cpu] << shift;
-	val = readl_relaxed(reg) & ~mask;
-	writel_relaxed(val | bit, reg);
-	gic_unlock_irqrestore(flags);
+	writeb_relaxed(gic_cpu_map[cpu], reg);
 
 	return IRQ_SET_MASK_OK_DONE;
 }


