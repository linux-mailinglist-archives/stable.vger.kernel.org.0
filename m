Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857F42017E3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391802AbgFSQol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388431AbgFSOnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:43:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E960E20CC7;
        Fri, 19 Jun 2020 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577783;
        bh=GYEJjnVY8KxcLVgy66MTRYDQJ+J6hTQrdgqTAXH7Ni0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/5YlCcCjOUIZz0gRoSEvgeilLWc+hC4WEyIBAIapsGXvRpL4xgGYMddqDbZv3U68
         /I0Icuy7AR8KmyuK/MTuKva7WTcdqI6s3QrS21J/dbyx4b4sf1nk8I+GScUCwdn91d
         VsVyTCWTrT+VVgyMuKMLYewJbXtStNCOpPh/7NWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 086/128] mips: Add udelay lpj numbers adjustment
Date:   Fri, 19 Jun 2020 16:33:00 +0200
Message-Id: <20200619141624.692512845@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a7f81261c781..b7f7e08e1ce4 100644
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



