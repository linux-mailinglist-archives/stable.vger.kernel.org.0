Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC9247429
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgHQTGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbgHQPoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:44:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B21F22D0B;
        Mon, 17 Aug 2020 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679058;
        bh=CKEwHfjYMaMRptnZa9Xtr3VDwhMRZ/6+GvzVOGRbGrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZG4vJBYmgu78cwFgckCnOZ2P0cbM3ZuE5hkJnWNddZ6bftlDiIrl2rcotyjcurlKD
         1P3fa083qXF4DeWCaOQRcloaoFGP04MaSFCHWuNFlGHC01nPTnDlJI5wjxorm+xY6J
         ef8CQFgJr4BxU1gIGnCtJh0ooeDMQ7i0A3D9QgxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 081/393] memory: samsung: exynos5422-dmc: Do not ignore return code of regmap_read()
Date:   Mon, 17 Aug 2020 17:12:11 +0200
Message-Id: <20200817143823.547062832@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 22a43d6628336..3460ba55fd596 100644
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



