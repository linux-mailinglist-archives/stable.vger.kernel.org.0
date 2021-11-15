Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C41451407
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348892AbhKOUAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344190AbhKOTYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3053633C4;
        Mon, 15 Nov 2021 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002416;
        bh=xNqQO3mPqgyvCdRZPK92RTQO982H4+8Vu3X3hGqZIFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17IfwFXZlNC2Gk5qLeSBfyy5UWW/TBRpH0xLimC3Lr+8nBrJZX7Jhxzk0PC+a1cI5
         gPyVsH/H9VEuiZD3RgybZVKtEHZpJldECsZIweBX8ZlswhJGO54gmhCfcP1z8Szpgj
         4JGG/+J35/oOwgS9JEutZUg9f+oZWLzUgpWXwn5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 525/917] cpufreq: intel_pstate: Fix cpu->pstate.turbo_freq initialization
Date:   Mon, 15 Nov 2021 18:00:20 +0100
Message-Id: <20211115165446.564714772@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit c72bcf0ab87a92634e58af62e89af0f40dfd0b88 ]

Fix a problem in active mode that cpu->pstate.turbo_freq is initialized
only if HWP-to-frequency scaling factor is refined.

In passive mode, this problem is not exposed, because
cpu->pstate.turbo_freq is set again, later in
intel_cpufreq_cpu_init()->intel_pstate_get_hwp_cap().

Fixes: eb3693f0521e ("cpufreq: intel_pstate: hybrid: CPU-specific scaling factor")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 8c176b7dae415..fc7a429f22d33 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -537,7 +537,8 @@ static void intel_pstate_hybrid_hwp_adjust(struct cpudata *cpu)
 	 * scaling factor is too high, so recompute it to make the HWP_CAP
 	 * highest performance correspond to the maximum turbo frequency.
 	 */
-	if (turbo_freq < cpu->pstate.turbo_pstate * scaling) {
+	cpu->pstate.turbo_freq = cpu->pstate.turbo_pstate * scaling;
+	if (turbo_freq < cpu->pstate.turbo_freq) {
 		cpu->pstate.turbo_freq = turbo_freq;
 		scaling = DIV_ROUND_UP(turbo_freq, cpu->pstate.turbo_pstate);
 		cpu->pstate.scaling = scaling;
-- 
2.33.0



