Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D325E21706E
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgGGPRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbgGGPRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:17:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36CCF20663;
        Tue,  7 Jul 2020 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135024;
        bh=jg37BOgnRVux8mq45Jft7hfVe7BKUumcFyBY9H09wFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1dpUb33xos+E1Kvfn8rvfEhim+gaBB1RIR/rdQgZw+XG51NfVdG6X2N3TihbYzg5
         O7O7F02n9gAY8FELmmB8I5wmDhiPISraPm+108X3z0F86tmAW5ovhkwxqXTvHy8sY8
         bJAQUKsfVFAuPP0rzUbWRc/WeVyeijtI2bCg8xSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.14 25/27] irqchip/gic: Atomically update affinity
Date:   Tue,  7 Jul 2020 17:15:52 +0200
Message-Id: <20200707145750.147315412@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
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
 drivers/irqchip/irq-gic.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

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
@@ -337,13 +335,7 @@ static int gic_set_affinity(struct irq_d
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


