Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788F7260080
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgIGQuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbgIGQe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 850E321D1A;
        Mon,  7 Sep 2020 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496493;
        bh=RCKCSrE4tU5GQj7iM0MpN+Aw8Ju1nJbqwLZpXZDF2Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHOwiICLhACJClQ5XLSjGNR/k9fLPZAisQY87VeMqa2GVcBDTsQ0VrqYJlEJgNGH/
         X3UOhCS21wE2w+hhziMfniekgI5/9GRH0403sOpzGItmNvKrdyqxnXo9Rq54Kd6GBh
         YZkGFEQPFz+1/ScjhMi70I7YnoUYGZUo7ODohhXw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Francisco Jerez <currojerez@riseup.net>,
        Caleb Callaway <caleb.callaway@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/26] cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled
Date:   Mon,  7 Sep 2020 12:34:21 -0400
Message-Id: <20200907163426.1281284-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163426.1281284-1-sashal@kernel.org>
References: <20200907163426.1281284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francisco Jerez <currojerez@riseup.net>

[ Upstream commit eacc9c5a927e474c173a5d53dd7fb8e306511768 ]

This fixes the behavior of the scaling_max_freq and scaling_min_freq
sysfs files in systems which had turbo disabled by the BIOS.

Caleb noticed that the HWP is programmed to operate in the wrong
P-state range on his system when the CPUFREQ policy min/max frequency
is set via sysfs.  This seems to be because in his system
intel_pstate_get_hwp_max() is returning the maximum turbo P-state even
though turbo was disabled by the BIOS, which causes intel_pstate to
scale kHz frequencies incorrectly e.g. setting the maximum turbo
frequency whenever the maximum guaranteed frequency is requested via
sysfs.

Tested-by: Caleb Callaway <caleb.callaway@intel.com>
Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Minor subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 8fa22aa2ac65b..864a7e8ebdfc3 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -712,7 +712,7 @@ static void intel_pstate_get_hwp_max(unsigned int cpu, int *phy_max,
 
 	rdmsrl_on_cpu(cpu, MSR_HWP_CAPABILITIES, &cap);
 	WRITE_ONCE(all_cpu_data[cpu]->hwp_cap_cached, cap);
-	if (global.no_turbo)
+	if (global.no_turbo || global.turbo_disabled)
 		*current_max = HWP_GUARANTEED_PERF(cap);
 	else
 		*current_max = HWP_HIGHEST_PERF(cap);
-- 
2.25.1

