Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F30424AAF4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgHTAGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbgHTADl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:03:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905EB214F1;
        Thu, 20 Aug 2020 00:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881821;
        bh=yCm5y4Uai+qjD/UrAJ0fgpyeB5mCDfWpo/kMVMdxoJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR+H8c4TGW/jB7CrbSciSlgONAtiihMP8S051q8JXQrCWob87MaVHdP+lhyVGSu1+
         ABovJHcZHtg3nuuIwfqlEHohlVQz7OFHNwA7lf7w/bWF3j2CyCNnhM9ldxhEwp9NL/
         t0jqlWRUNzGlNG2PNJ/ipJo9TKLXJtx2pCIE74Aw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/13] cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0
Date:   Wed, 19 Aug 2020 20:03:24 -0400
Message-Id: <20200820000328.215755-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000328.215755-1-sashal@kernel.org>
References: <20200820000328.215755-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 4daca379c703ff55edc065e8e5173dcfeecf0148 ]

The MSR_TURBO_RATIO_LIMIT can be 0. This is not an error. User can update
this MSR via BIOS settings on some systems or can use msr tools to update.
Also some systems boot with value = 0.

This results in display of cpufreq/cpuinfo_max_freq wrong. This value
will be equal to cpufreq/base_frequency, even though turbo is enabled.

But platform will still function normally in HWP mode as we get max
1-core frequency from the MSR_HWP_CAPABILITIES. This MSR is already used
to calculate cpu->pstate.turbo_freq, which is used for to set
policy->cpuinfo.max_freq. But some other places cpu->pstate.turbo_pstate
is used. For example to set policy->max.

To fix this, also update cpu->pstate.turbo_pstate when updating
cpu->pstate.turbo_freq.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 1aa0b05c8cbdf..5c41dc9aaa46d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1378,6 +1378,7 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 
 		intel_pstate_get_hwp_max(cpu->cpu, &phy_max, &current_max);
 		cpu->pstate.turbo_freq = phy_max * cpu->pstate.scaling;
+		cpu->pstate.turbo_pstate = phy_max;
 	} else {
 		cpu->pstate.turbo_freq = cpu->pstate.turbo_pstate * cpu->pstate.scaling;
 	}
-- 
2.25.1

