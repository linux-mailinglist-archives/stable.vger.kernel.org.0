Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80BD311463
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhBEWFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232940AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A820F64FD9;
        Fri,  5 Feb 2021 14:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534182;
        bh=jiTbbQFzXUI+nXEB89xV88YHpq32rJvlMvL+kD8fmnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2/kevLxAabWQ6YMFkDbeGvuNFBY9HycslbBIvpBHwIrr/Cj2TwPfccuA6fwl2kNr
         UsTMe9OUaNZ3vT50+81ViIXWvGuL6hs0Ibt/lI12ADxuRMFtkcsbbmqfMU9VuVjE3G
         I7lz8U+yy6My59Rcz23UJlaiBoUxt44UrrV6Rbs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/57] tools/power/x86/intel-speed-select: Set scaling_max_freq to base_frequency
Date:   Fri,  5 Feb 2021 15:06:45 +0100
Message-Id: <20210205140656.800398922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit f981dc171c04c6cf5a35c712543b231ebf805832 ]

When BIOS disables turbo, The scaling_max_freq in cpufreq sysfs will be
limited to config level 0 base frequency. But when user selects a higher
config levels, this will result in higher base frequency. But since
scaling_max_freq is still old base frequency, the performance will still
be limited. So when the turbo is disabled and cpufreq base_frequency is
higher than scaling_max_freq, update the scaling_max_freq to the
base_frequency.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20201221071859.2783957-2-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel-speed-select/isst-config.c      | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index cd089a5058594..97755f35d9910 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -1245,6 +1245,8 @@ static void dump_isst_config(int arg)
 	isst_ctdp_display_information_end(outf);
 }
 
+static void adjust_scaling_max_from_base_freq(int cpu);
+
 static void set_tdp_level_for_cpu(int cpu, void *arg1, void *arg2, void *arg3,
 				  void *arg4)
 {
@@ -1263,6 +1265,9 @@ static void set_tdp_level_for_cpu(int cpu, void *arg1, void *arg2, void *arg3,
 			int pkg_id = get_physical_package_id(cpu);
 			int die_id = get_physical_die_id(cpu);
 
+			/* Wait for updated base frequencies */
+			usleep(2000);
+
 			fprintf(stderr, "Option is set to online/offline\n");
 			ctdp_level.core_cpumask_size =
 				alloc_cpu_set(&ctdp_level.core_cpumask);
@@ -1279,6 +1284,7 @@ static void set_tdp_level_for_cpu(int cpu, void *arg1, void *arg2, void *arg3,
 					if (CPU_ISSET_S(i, ctdp_level.core_cpumask_size, ctdp_level.core_cpumask)) {
 						fprintf(stderr, "online cpu %d\n", i);
 						set_cpu_online_offline(i, 1);
+						adjust_scaling_max_from_base_freq(i);
 					} else {
 						fprintf(stderr, "offline cpu %d\n", i);
 						set_cpu_online_offline(i, 0);
@@ -1436,6 +1442,21 @@ static int set_cpufreq_scaling_min_max(int cpu, int max, int freq)
 	return 0;
 }
 
+static int no_turbo(void)
+{
+	return parse_int_file(0, "/sys/devices/system/cpu/intel_pstate/no_turbo");
+}
+
+static void adjust_scaling_max_from_base_freq(int cpu)
+{
+	int base_freq, scaling_max_freq;
+
+	scaling_max_freq = parse_int_file(0, "/sys/devices/system/cpu/cpu%d/cpufreq/scaling_max_freq", cpu);
+	base_freq = get_cpufreq_base_freq(cpu);
+	if (scaling_max_freq < base_freq || no_turbo())
+		set_cpufreq_scaling_min_max(cpu, 1, base_freq);
+}
+
 static int set_clx_pbf_cpufreq_scaling_min_max(int cpu)
 {
 	struct isst_pkg_ctdp_level_info *ctdp_level;
-- 
2.27.0



