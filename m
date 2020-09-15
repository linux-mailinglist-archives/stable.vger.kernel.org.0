Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6742C26B746
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgIPAUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgIOOV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:21:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F0792226A;
        Tue, 15 Sep 2020 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179451;
        bh=RCKCSrE4tU5GQj7iM0MpN+Aw8Ju1nJbqwLZpXZDF2Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwDOzYyNM5NZI4I+UA0Xq7+oYtLs21e0KI7OlbMzzUn/gSGwXWmyP71vcPbliAzgB
         jXU68ZTCQ6yRgPq/tWLUZnFeme3vMWqB7V4bN2cJhqxsojkm08Dt1OzGxYKJtLPsrW
         QDWZtugbOwbF0MyfiWVaiPvqGEQxQ9eAAVvSTbdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Caleb Callaway <caleb.callaway@intel.com>,
        Francisco Jerez <currojerez@riseup.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/78] cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled
Date:   Tue, 15 Sep 2020 16:13:00 +0200
Message-Id: <20200915140635.334160236@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



