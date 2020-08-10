Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07F52410DA
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgHJTJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbgHJTJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE48D22CA1;
        Mon, 10 Aug 2020 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086568;
        bh=hNul+hpMOhhwF35fU5uL+jxA8siVHVf4No5zO0w65EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncjRr/4T9gZRR/vagqYNyissyW9Fa5VLDHAC++lVcybtp+dqZK8iMkDbIys4eMAMR
         6ZhtVTww0n25A0BZMNJIKP2/7DNYiq2D+orhiEXKsjo4cjXe2UrTciCmKCION3oF2j
         XTA8Oo51HsCj8beZG+ypAbcLKUw22E71QD0r2okg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 21/64] memory: samsung: exynos5422-dmc: Do not ignore return code of regmap_read()
Date:   Mon, 10 Aug 2020 15:08:16 -0400
Message-Id: <20200810190859.3793319-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c4f16e96d8fdd62ef12898fc0965c42093bed237 ]

Check for regmap_read() return code before using the read value in
following write in exynos5_switch_timing_regs().  Pass reading error
code to the callers.

This does not introduce proper error handling for such failed reads (and
obviously regmap_write() error is still ignored) because the driver
ignored this in all places.  Therefor it only fixes reported issue while
matching current driver coding style:

       drivers/memory/samsung/exynos5422-dmc.c: In function 'exynos5_switch_timing_regs':
    >> drivers/memory/samsung/exynos5422-dmc.c:216:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 25196d6268e21..85b31d3de57ad 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -270,12 +270,14 @@ static int find_target_freq_idx(struct exynos5_dmc *dmc,
  * This function switches between these banks according to the
  * currently used clock source.
  */
-static void exynos5_switch_timing_regs(struct exynos5_dmc *dmc, bool set)
+static int exynos5_switch_timing_regs(struct exynos5_dmc *dmc, bool set)
 {
 	unsigned int reg;
 	int ret;
 
 	ret = regmap_read(dmc->clk_regmap, CDREX_LPDDR3PHY_CON3, &reg);
+	if (ret)
+		return ret;
 
 	if (set)
 		reg |= EXYNOS5_TIMING_SET_SWI;
@@ -283,6 +285,8 @@ static void exynos5_switch_timing_regs(struct exynos5_dmc *dmc, bool set)
 		reg &= ~EXYNOS5_TIMING_SET_SWI;
 
 	regmap_write(dmc->clk_regmap, CDREX_LPDDR3PHY_CON3, reg);
+
+	return 0;
 }
 
 /**
@@ -516,7 +520,7 @@ exynos5_dmc_switch_to_bypass_configuration(struct exynos5_dmc *dmc,
 	/*
 	 * Delays are long enough, so use them for the new coming clock.
 	 */
-	exynos5_switch_timing_regs(dmc, USE_MX_MSPLL_TIMINGS);
+	ret = exynos5_switch_timing_regs(dmc, USE_MX_MSPLL_TIMINGS);
 
 	return ret;
 }
@@ -577,7 +581,9 @@ exynos5_dmc_change_freq_and_volt(struct exynos5_dmc *dmc,
 
 	clk_set_rate(dmc->fout_bpll, target_rate);
 
-	exynos5_switch_timing_regs(dmc, USE_BPLL_TIMINGS);
+	ret = exynos5_switch_timing_regs(dmc, USE_BPLL_TIMINGS);
+	if (ret)
+		goto disable_clocks;
 
 	ret = clk_set_parent(dmc->mout_mclk_cdrex, dmc->mout_bpll);
 	if (ret)
-- 
2.25.1

