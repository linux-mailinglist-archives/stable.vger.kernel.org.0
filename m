Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FD7328F0B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhCATmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242087AbhCATfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF95652A3;
        Mon,  1 Mar 2021 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619990;
        bh=wgaXRl/06iB34Dd8qvi3yLsKhPmctgt8Zt6Hw5hdfrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2YbpI6nirC0rGtNuDvs/KwZBaIx/0Gl/C0+Vk4HNH/KmrToBVAQvRGUIlqgOs72J
         eM/1z/qgTVAmyO5++/AMNZQn0edmiXqAXel91uvs+LtBttAWKAXpNG1A5SAicQtkvz
         jHS77LDV+Ly/QtiKVR6UP1rv4ccF5YuW3gjPN2DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wendy Wang <wendy.wang@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 624/663] cpufreq: intel_pstate: Get per-CPU max freq via MSR_HWP_CAPABILITIES if available
Date:   Mon,  1 Mar 2021 17:14:32 +0100
Message-Id: <20210301161212.720847259@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

commit 6f67e060083a84a4cc364eab6ae40c717165fb0c upstream.

Currently, when turbo is disabled (either by BIOS or by the user),
the intel_pstate driver reads the max non-turbo frequency from the
package-wide MSR_PLATFORM_INFO(0xce) register.

However, on asymmetric platforms it is possible in theory that small
and big core with HWP enabled might have different max non-turbo CPU
frequency, because MSR_HWP_CAPABILITIES is per-CPU scope according
to Intel Software Developer Manual.

The turbo max freq is already per-CPU in current code, so make
similar change to the max non-turbo frequency as well.

Reported-by: Wendy Wang <wendy.wang@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
[ rjw: Subject and changelog edits ]
Cc: 4.18+ <stable@vger.kernel.org> # 4.18+: a45ee4d4e13b: cpufreq: intel_pstate: Change intel_pstate_get_hwp_max() argument
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1724,11 +1724,9 @@ static void intel_pstate_max_within_limi
 static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 {
 	cpu->pstate.min_pstate = pstate_funcs.get_min();
-	cpu->pstate.max_pstate = pstate_funcs.get_max();
 	cpu->pstate.max_pstate_physical = pstate_funcs.get_max_physical();
 	cpu->pstate.turbo_pstate = pstate_funcs.get_turbo();
 	cpu->pstate.scaling = pstate_funcs.get_scaling();
-	cpu->pstate.max_freq = cpu->pstate.max_pstate * cpu->pstate.scaling;
 
 	if (hwp_active && !hwp_mode_bdw) {
 		unsigned int phy_max, current_max;
@@ -1736,9 +1734,12 @@ static void intel_pstate_get_cpu_pstates
 		intel_pstate_get_hwp_max(cpu, &phy_max, &current_max);
 		cpu->pstate.turbo_freq = phy_max * cpu->pstate.scaling;
 		cpu->pstate.turbo_pstate = phy_max;
+		cpu->pstate.max_pstate = HWP_GUARANTEED_PERF(READ_ONCE(cpu->hwp_cap_cached));
 	} else {
 		cpu->pstate.turbo_freq = cpu->pstate.turbo_pstate * cpu->pstate.scaling;
+		cpu->pstate.max_pstate = pstate_funcs.get_max();
 	}
+	cpu->pstate.max_freq = cpu->pstate.max_pstate * cpu->pstate.scaling;
 
 	if (pstate_funcs.get_aperf_mperf_shift)
 		cpu->aperf_mperf_shift = pstate_funcs.get_aperf_mperf_shift();


