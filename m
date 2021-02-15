Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3855F31BD36
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBOPmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhBOPiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01A3164EB9;
        Mon, 15 Feb 2021 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403265;
        bh=zy1udX7Uonmn/VPosQuKRzFF8NMvD7CIT/Jg8sMmh9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZ3Fq4ASFnQDA02P6XkPDRgdZzpCbFqWI+ilVqwYuD4vere/sBeRQm1qQjVnXAkXi
         YDlbR2rFusGnwWKUboGR4Lo/8ngPJhVDAHLZh5a3nFm+fZZK89UIqOtSDJzYeBYPv1
         2uE2jlCGWx75T9BsKWaj6ceZWRuiBsxIXbRk0gX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 091/104] cpufreq: ACPI: Update arch scale-invariance max perf ratio if CPPC is not there
Date:   Mon, 15 Feb 2021 16:27:44 +0100
Message-Id: <20210215152722.397273996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d11a1d08a082a7dc0ada423d2b2e26e9b6f2525c upstream.

If the maximum performance level taken for computing the
arch_max_freq_ratio value used in the x86 scale-invariance code is
higher than the one corresponding to the cpuinfo.max_freq value
coming from the acpi_cpufreq driver, the scale-invariant utilization
falls below 100% even if the CPU runs at cpuinfo.max_freq or slightly
faster, which causes the schedutil governor to select a frequency
below cpuinfo.max_freq.  That frequency corresponds to a frequency
table entry below the maximum performance level necessary to get to
the "boost" range of CPU frequencies which prevents "boost"
frequencies from being used in some workloads.

While this issue is related to scale-invariance, it may be amplified
by commit db865272d9c4 ("cpufreq: Avoid configuring old governors as
default with intel_pstate") from the 5.10 development cycle which
made it extremely easy to default to schedutil even if the preferred
driver is acpi_cpufreq as long as intel_pstate is built too, because
the mere presence of the latter effectively removes the ondemand
governor from the defaults.  Distro kernels are likely to include
both intel_pstate and acpi_cpufreq on x86, so their users who cannot
use intel_pstate or choose to use acpi_cpufreq may easily be
affectecd by this issue.

If CPPC is available, it can be used to address this issue by
extending the frequency tables created by acpi_cpufreq to cover the
entire available frequency range (including "boost" frequencies) for
each CPU, but if CPPC is not there, acpi_cpufreq has no idea what
the maximum "boost" frequency is and the frequency tables created by
it cannot be extended in a meaningful way, so in that case make it
ask the arch scale-invariance code to to use the "nominal" performance
level for CPU utilization scaling in order to avoid the issue at hand.

Fixes: db865272d9c4 ("cpufreq: Avoid configuring old governors as default with intel_pstate")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smpboot.c      |    1 +
 drivers/cpufreq/acpi-cpufreq.c |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1829,6 +1829,7 @@ void arch_set_max_freq_ratio(bool turbo_
 	arch_max_freq_ratio = turbo_disabled ? SCHED_CAPACITY_SCALE :
 					arch_turbo_freq_ratio;
 }
+EXPORT_SYMBOL_GPL(arch_set_max_freq_ratio);
 
 static bool turbo_disabled(void)
 {
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -806,6 +806,14 @@ static int acpi_cpufreq_cpu_init(struct
 		state_count++;
 		valid_states++;
 		data->first_perf_state = valid_states;
+	} else {
+		/*
+		 * If the maximum "boost" frequency is unknown, ask the arch
+		 * scale-invariance code to use the "nominal" performance for
+		 * CPU utilization scaling so as to prevent the schedutil
+		 * governor from selecting inadequate CPU frequencies.
+		 */
+		arch_set_max_freq_ratio(true);
 	}
 
 	freq_table = kcalloc(state_count, sizeof(*freq_table), GFP_KERNEL);


