Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86EF5CA60
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfGBIDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfGBIDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AEAB2184B;
        Tue,  2 Jul 2019 08:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054612;
        bh=29iVjL43COetC4HE2QtP8mHrhTybEpva3vP4Pue+hlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1DZkLqdvX97WxhWgSm90FSsEjHUb0kAarEqiyn0lrC5l+hoVxmw1xOab6qc+kF4z
         ej3wapFSaU2Uenh3XVOc56cr4YZPlBvxYjv1cUkQXxF2A6FWjmmPFYNMDUzHoEkjxU
         9QpnbV83RIH6M5PB1ND92BjG1NbzmZDhj+p6koj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Archer Yan <ayan@wavecomp.com>
Subject: [PATCH 5.1 29/55] irqchip/mips-gic: Use the correct local interrupt map registers
Date:   Tue,  2 Jul 2019 10:01:37 +0200
Message-Id: <20190702080125.633072236@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 6d4d367d0e9ffab4d64a3436256a6a052dc1195d upstream.

The MIPS GIC contains a block of registers used to map local interrupts
to a particular CPU interrupt pin. Since these registers are found at a
consecutive range of addresses we access them using an index, via the
(read|write)_gic_v[lo]_map accessor functions. We currently use values
from enum mips_gic_local_interrupt as those indices.

Unfortunately whilst enum mips_gic_local_interrupt provides the correct
offsets for bits in the pending & mask registers, the ordering of the
map registers is subtly different... Compared with the ordering of
pending & mask bits, the map registers move the FDC from the end of the
list to index 3 after the timer interrupt. As a result the performance
counter & software interrupts are therefore at indices 4-6 rather than
indices 3-5.

Notably this causes problems with performance counter interrupts being
incorrectly mapped on some systems, and presumably will also cause
problems for FDC interrupts.

Introduce a function to map from enum mips_gic_local_interrupt to the
index of the corresponding map register, and use it to ensure we access
the map registers for the correct interrupts.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: a0dc5cb5e31b ("irqchip: mips-gic: Simplify gic_local_irq_domain_map()")
Fixes: da61fcf9d62a ("irqchip: mips-gic: Use irq_cpu_online to (un)mask all-VP(E) IRQs")
Reported-and-tested-by: Archer Yan <ayan@wavecomp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/mips-gic.h |   30 ++++++++++++++++++++++++++++++
 drivers/irqchip/irq-mips-gic.c   |    4 ++--
 2 files changed, 32 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/mips-gic.h
+++ b/arch/mips/include/asm/mips-gic.h
@@ -315,6 +315,36 @@ static inline bool mips_gic_present(void
 }
 
 /**
+ * mips_gic_vx_map_reg() - Return GIC_Vx_<intr>_MAP register offset
+ * @intr: A GIC local interrupt
+ *
+ * Determine the index of the GIC_VL_<intr>_MAP or GIC_VO_<intr>_MAP register
+ * within the block of GIC map registers. This is almost the same as the order
+ * of interrupts in the pending & mask registers, as used by enum
+ * mips_gic_local_interrupt, but moves the FDC interrupt & thus offsets the
+ * interrupts after it...
+ *
+ * Return: The map register index corresponding to @intr.
+ *
+ * The return value is suitable for use with the (read|write)_gic_v[lo]_map
+ * accessor functions.
+ */
+static inline unsigned int
+mips_gic_vx_map_reg(enum mips_gic_local_interrupt intr)
+{
+	/* WD, Compare & Timer are 1:1 */
+	if (intr <= GIC_LOCAL_INT_TIMER)
+		return intr;
+
+	/* FDC moves to after Timer... */
+	if (intr == GIC_LOCAL_INT_FDC)
+		return GIC_LOCAL_INT_TIMER + 1;
+
+	/* As a result everything else is offset by 1 */
+	return intr + 1;
+}
+
+/**
  * gic_get_c0_compare_int() - Return cp0 count/compare interrupt virq
  *
  * Determine the virq number to use for the coprocessor 0 count/compare
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -388,7 +388,7 @@ static void gic_all_vpes_irq_cpu_online(
 	intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
 	cd = irq_data_get_irq_chip_data(d);
 
-	write_gic_vl_map(intr, cd->map);
+	write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
 	if (cd->mask)
 		write_gic_vl_smask(BIT(intr));
 }
@@ -517,7 +517,7 @@ static int gic_irq_domain_map(struct irq
 	spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
-		write_gic_vo_map(intr, map);
+		write_gic_vo_map(mips_gic_vx_map_reg(intr), map);
 	}
 	spin_unlock_irqrestore(&gic_lock, flags);
 


