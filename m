Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEF924F803
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHXJY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730237AbgHXIxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99693207DF;
        Mon, 24 Aug 2020 08:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259227;
        bh=yCm5y4Uai+qjD/UrAJ0fgpyeB5mCDfWpo/kMVMdxoJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Anjdi8AHJE391UGGKDFHF/VvFvdBuWvp5X5r0NpeLfcKNCmTGOaQxaw1j+PDtbvMT
         ZhE5CRbw0Wsbmq9hAqgsWkssm+6QsY23py1oq+3tt6wtna1sERaLypkegpe/PfvPM3
         ECtTQKiMKyuVCjVEolzd+xsVdhHRGSLe4hIOW6Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/50] cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0
Date:   Mon, 24 Aug 2020 10:31:29 +0200
Message-Id: <20200824082353.467936239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



