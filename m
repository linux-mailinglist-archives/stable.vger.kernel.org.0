Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52701F2785
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgFHXqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387553AbgFHX0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:26:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668512064C;
        Mon,  8 Jun 2020 23:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658776;
        bh=SqVHw7je2X5s8JwVsx+Av0VwbuYw1mf97YZ/CeNZ7SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVLWAwwANLCYrHFezU+5ViOYNjlCVxs7ygJIVU1AoRqHCmom1dCbXwVMydOJLZCER
         GD/tzfB5J3QhuIZPWFTcGUrtHhsLUzJG3i9qUA4Jn1levyL/Y7GoRR/Mmrey+FFvJo
         mwVVCKuj6FcBXPhRrznrSKwfy83WH3AbByKW/vZM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 56/72] mips: Add udelay lpj numbers adjustment
Date:   Mon,  8 Jun 2020 19:24:44 -0400
Message-Id: <20200608232500.3369581-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit ed26aacfb5f71eecb20a51c4467da440cb719d66 ]

Loops-per-jiffies is a special number which represents a number of
noop-loop cycles per CPU-scheduler quantum - jiffies. As you
understand aside from CPU-specific implementation it depends on
the CPU frequency. So when a platform has the CPU frequency fixed,
we have no problem and the current udelay interface will work
just fine. But as soon as CPU-freq driver is enabled and the cores
frequency changes, we'll end up with distorted udelay's. In order
to fix this we have to accordinly adjust the per-CPU udelay_val
(the same as the global loops_per_jiffy) number. This can be done
in the CPU-freq transition event handler. We subscribe to that event
in the MIPS arch time-inititalization method.

Co-developed-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Signed-off-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/time.c | 70 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index a6ebc8135112..df18f386d457 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -22,12 +22,82 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
+#include <linux/cpufreq.h>
+#include <linux/delay.h>
 
 #include <asm/cpu-features.h>
 #include <asm/cpu-type.h>
 #include <asm/div64.h>
 #include <asm/time.h>
 
+#ifdef CONFIG_CPU_FREQ
+
+static DEFINE_PER_CPU(unsigned long, pcp_lpj_ref);
+static DEFINE_PER_CPU(unsigned long, pcp_lpj_ref_freq);
+static unsigned long glb_lpj_ref;
+static unsigned long glb_lpj_ref_freq;
+
+static int cpufreq_callback(struct notifier_block *nb,
+			    unsigned long val, void *data)
+{
+	struct cpufreq_freqs *freq = data;
+	struct cpumask *cpus = freq->policy->cpus;
+	unsigned long lpj;
+	int cpu;
+
+	/*
+	 * Skip lpj numbers adjustment if the CPU-freq transition is safe for
+	 * the loops delay. (Is this possible?)
+	 */
+	if (freq->flags & CPUFREQ_CONST_LOOPS)
+		return NOTIFY_OK;
+
+	/* Save the initial values of the lpjes for future scaling. */
+	if (!glb_lpj_ref) {
+		glb_lpj_ref = boot_cpu_data.udelay_val;
+		glb_lpj_ref_freq = freq->old;
+
+		for_each_online_cpu(cpu) {
+			per_cpu(pcp_lpj_ref, cpu) =
+				cpu_data[cpu].udelay_val;
+			per_cpu(pcp_lpj_ref_freq, cpu) = freq->old;
+		}
+	}
+
+	/*
+	 * Adjust global lpj variable and per-CPU udelay_val number in
+	 * accordance with the new CPU frequency.
+	 */
+	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
+	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new)) {
+		loops_per_jiffy = cpufreq_scale(glb_lpj_ref,
+						glb_lpj_ref_freq,
+						freq->new);
+
+		for_each_cpu(cpu, cpus) {
+			lpj = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
+					    per_cpu(pcp_lpj_ref_freq, cpu),
+					    freq->new);
+			cpu_data[cpu].udelay_val = (unsigned int)lpj;
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpufreq_notifier = {
+	.notifier_call  = cpufreq_callback,
+};
+
+static int __init register_cpufreq_notifier(void)
+{
+	return cpufreq_register_notifier(&cpufreq_notifier,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+core_initcall(register_cpufreq_notifier);
+
+#endif /* CONFIG_CPU_FREQ */
+
 /*
  * forward reference
  */
-- 
2.25.1

