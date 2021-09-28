Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD57B41A812
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhI1GBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239423AbhI1F7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B31061368;
        Tue, 28 Sep 2021 05:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808621;
        bh=dT/0ijY4wMft8N/PMs/O8z766eKLlFc43XEtjuJfa2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHwB20HAKMw5xPVoH9/UU3Ei4kPa8gLhiOLdgDOPs+uOzCF6wHVt3O8mFd5rVwXG2
         QZxHLPpzxQAntfM8cYXyPKtzqFVcQUXC+f7B+ggA92C55uIhF6QPsDRKMkurin49k7
         iUafOqjBv10BS6XGGT9s1+lhp0eW6u4OnCXkaBCMwxpwwTuxR+rcBhLKku2lscyijC
         Z7PiYQ5CS7qxwScxuXegdXPj1gUAbvQUlYZdcD3kmjkAq6R2CXyD2ar6JpqX8hSqUF
         1107Yk94Z1Ibza77S2ykn9eqVuvPw4CLvbPp+7YkrN5ho9TTIZPCDa1l2o0zW4eRsX
         tzjiSbfy9vyAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.10 21/23] irqchip/gic: Work around broken Renesas integration
Date:   Tue, 28 Sep 2021 01:56:42 -0400
Message-Id: <20210928055645.172544-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
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
index 6053245a4754..176f5f06432d 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -107,6 +107,8 @@ static DEFINE_RAW_SPINLOCK(cpu_map_lock);
 
 #endif
 
+static DEFINE_STATIC_KEY_FALSE(needs_rmw_access);
+
 /*
  * The GIC mapping of CPU interfaces does not necessarily match
  * the logical CPU numbering.  Let's use a mapping as returned
@@ -777,6 +779,25 @@ static int gic_pm_init(struct gic_chip_data *gic)
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
@@ -791,7 +812,10 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	writeb_relaxed(gic_cpu_map[cpu], reg);
+	if (static_branch_unlikely(&needs_rmw_access))
+		rmw_writeb(gic_cpu_map[cpu], reg);
+	else
+		writeb_relaxed(gic_cpu_map[cpu], reg);
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
 	return IRQ_SET_MASK_OK_DONE;
@@ -1384,6 +1408,30 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
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
@@ -1400,6 +1448,8 @@ static int gic_of_setup(struct gic_chip_data *gic, struct device_node *node)
 	if (of_property_read_u32(node, "cpu-offset", &gic->percpu_offset))
 		gic->percpu_offset = 0;
 
+	gic_enable_of_quirks(node, gic_quirks, gic);
+
 	return 0;
 
 error:
-- 
2.33.0

