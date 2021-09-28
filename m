Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD3341A7C3
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbhI1F7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238924AbhI1F6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884686128C;
        Tue, 28 Sep 2021 05:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808594;
        bh=Vyp65lF8I7F1LMg011ze4pcDp+F4AJwyEL3Les0tYUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkDvUGBYDUM0zoSYc5TaVEGd4dMVj+uQ6E2GMaSLIYG8yEZLQx2F6sTYbsqNx0Bms
         aZCQJbZg/l6ZDAL1j+JPcf/zxPDf9HztQJXJwqL5Ly+yjvMqRKg38q7DToI2PBUWRX
         hE9nKPPB6Vb3n4CrloDqtMNV5UUcXy1VdcRFNjGrIysTFhjazUk1y3ArPa8MJFuQRW
         372lx+zQRFwbR49BXZdahfjxQqkLscE56K7L3yIcZO+WzH8nGpbD48FM21HDNqQiuT
         Iuoh9QhkVvvQGEUI8CUUbnQLkeO7GOL3+HmdEzGThwVBajOEHa1qA8TsOvhh0AQ7Jc
         SFLUkXGsxyfMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.14 34/40] irqchip/gic: Work around broken Renesas integration
Date:   Tue, 28 Sep 2021 01:55:18 -0400
Message-Id: <20210928055524.172051-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit b78f26926b17cc289e4f16b63363abe0aa2e8efc ]

Geert reported that the GIC driver locks up on a Renesas system
since 005c34ae4b44f085 ("irqchip/gic: Atomically update affinity")
fixed the driver to use writeb_relaxed() instead of writel_relaxed().

As it turns out, the interconnect used on this system mandates
32bit wide accesses for all MMIO transactions, even if the GIC
architecture specifically mandates for some registers to be byte
accessible. Gahhh...

Work around the issue by crudly detecting the offending system,
and falling back to an inefficient RMW+lock implementation.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic.c | 52 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d329ec3d64d8..5f22c9d65e57 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -107,6 +107,8 @@ static DEFINE_RAW_SPINLOCK(cpu_map_lock);
 
 #endif
 
+static DEFINE_STATIC_KEY_FALSE(needs_rmw_access);
+
 /*
  * The GIC mapping of CPU interfaces does not necessarily match
  * the logical CPU numbering.  Let's use a mapping as returned
@@ -774,6 +776,25 @@ static int gic_pm_init(struct gic_chip_data *gic)
 #endif
 
 #ifdef CONFIG_SMP
+static void rmw_writeb(u8 bval, void __iomem *addr)
+{
+	static DEFINE_RAW_SPINLOCK(rmw_lock);
+	unsigned long offset = (unsigned long)addr & 3UL;
+	unsigned long shift = offset * 8;
+	unsigned long flags;
+	u32 val;
+
+	raw_spin_lock_irqsave(&rmw_lock, flags);
+
+	addr -= offset;
+	val = readl_relaxed(addr);
+	val &= ~GENMASK(shift + 7, shift);
+	val |= bval << shift;
+	writel_relaxed(val, addr);
+
+	raw_spin_unlock_irqrestore(&rmw_lock, flags);
+}
+
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
@@ -788,7 +809,10 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	writeb_relaxed(gic_cpu_map[cpu], reg);
+	if (static_branch_unlikely(&needs_rmw_access))
+		rmw_writeb(gic_cpu_map[cpu], reg);
+	else
+		writeb_relaxed(gic_cpu_map[cpu], reg);
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
 	return IRQ_SET_MASK_OK_DONE;
@@ -1375,6 +1399,30 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
 	return true;
 }
 
+static bool gic_enable_rmw_access(void *data)
+{
+	/*
+	 * The EMEV2 class of machines has a broken interconnect, and
+	 * locks up on accesses that are less than 32bit. So far, only
+	 * the affinity setting requires it.
+	 */
+	if (of_machine_is_compatible("renesas,emev2")) {
+		static_branch_enable(&needs_rmw_access);
+		return true;
+	}
+
+	return false;
+}
+
+static const struct gic_quirk gic_quirks[] = {
+	{
+		.desc		= "broken byte access",
+		.compatible	= "arm,pl390",
+		.init		= gic_enable_rmw_access,
+	},
+	{ },
+};
+
 static int gic_of_setup(struct gic_chip_data *gic, struct device_node *node)
 {
 	if (!gic || !node)
@@ -1391,6 +1439,8 @@ static int gic_of_setup(struct gic_chip_data *gic, struct device_node *node)
 	if (of_property_read_u32(node, "cpu-offset", &gic->percpu_offset))
 		gic->percpu_offset = 0;
 
+	gic_enable_of_quirks(node, gic_quirks, gic);
+
 	return 0;
 
 error:
-- 
2.33.0

