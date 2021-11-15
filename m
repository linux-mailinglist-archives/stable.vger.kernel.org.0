Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E342D451149
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243747AbhKOTD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:03:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243259AbhKOTA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CEFA61AA2;
        Mon, 15 Nov 2021 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000036;
        bh=uyDSCMG8nRy2/VVy9gWDgHJeX1p+EAuKtPxR1I8ee3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyHLyWaUJsBHusiKH7DFJaZpgFQyFLHVBQemkn9jymFiqBHFcRERyxcHtjcTIzZ2r
         io9Jzfs/njuyl54UsdN2jwMBTPUT+Yl1g6J9Vnnx4f/KNsE/WwqDdzviFMhOrdKCVg
         H8p7lE5tyTJpQb9KK2Tomhy42fox0ZwsmHelWcHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 514/849] cpufreq: intel_pstate: Fix cpu->pstate.turbo_freq initialization
Date:   Mon, 15 Nov 2021 17:59:57 +0100
Message-Id: <20211115165437.675915916@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
 drivers/cpufreq/intel_pstate.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e7cd3882bda4d..2789cad7403d8 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -615,9 +615,8 @@ static void intel_pstate_hybrid_hwp_calibrate(struct cpudata *cpu)
 	 * the scaling factor is too high, so recompute it so that the HWP_CAP
 	 * highest performance corresponds to the maximum turbo frequency.
 	 */
-	if (turbo_freq < cpu->pstate.turbo_pstate * scaling) {
-		pr_debug("CPU%d: scaling too high (%d)\n", cpu->cpu, scaling);
-
+	cpu->pstate.turbo_freq = cpu->pstate.turbo_pstate * scaling;
+	if (turbo_freq < cpu->pstate.turbo_freq) {
 		cpu->pstate.turbo_freq = turbo_freq;
 		scaling = DIV_ROUND_UP(turbo_freq, cpu->pstate.turbo_pstate);
 	}
-- 
2.33.0



