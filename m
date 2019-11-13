Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8005FA30B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfKMCHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbfKMCAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDE922467;
        Wed, 13 Nov 2019 02:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610433;
        bh=Zgkwqrff4/iY33NyPBf0FfOVn1J4uPqkRyaGWhNjPxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ovz5ZaFhDZH21SEeqCmayfYg5MFUMQ3HNzaJQ1B+aKklzyC2MAT8Yrm/e0+3UfVEX
         No6A9yBJLLqqfmOo2CMuIzXRvKsUjXzWcIB1aJOogtVirlj8+BLCXo1AseRWPWfEwG
         RTgLWw06+4vp/A+p59c/3BGufD/1O4Ta1lqsxHBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 35/68] clk: samsung: Use clk_hw API for calling clk framework from clk notifiers
Date:   Tue, 12 Nov 2019 20:58:59 -0500
Message-Id: <20191113015932.12655-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 1da220e3a5d22fccda0bc8542997abc1d1741268 ]

clk_notifier_register() documentation states, that the provided notifier
callbacks associated with the notifier must not re-enter into the clk
framework by calling any top-level clk APIs. Fix this by replacing
clk_get_rate() calls with clk_hw_get_rate(), which is safe in this
context.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <snawrocki@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-cpu.c | 6 +++---
 drivers/clk/samsung/clk-cpu.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/samsung/clk-cpu.c b/drivers/clk/samsung/clk-cpu.c
index 8bf7e805fd349..1271315b0c25b 100644
--- a/drivers/clk/samsung/clk-cpu.c
+++ b/drivers/clk/samsung/clk-cpu.c
@@ -152,7 +152,7 @@ static int exynos_cpuclk_pre_rate_change(struct clk_notifier_data *ndata,
 			struct exynos_cpuclk *cpuclk, void __iomem *base)
 {
 	const struct exynos_cpuclk_cfg_data *cfg_data = cpuclk->cfg;
-	unsigned long alt_prate = clk_get_rate(cpuclk->alt_parent);
+	unsigned long alt_prate = clk_hw_get_rate(cpuclk->alt_parent);
 	unsigned long alt_div = 0, alt_div_mask = DIV_MASK;
 	unsigned long div0, div1 = 0, mux_reg;
 	unsigned long flags;
@@ -280,7 +280,7 @@ static int exynos5433_cpuclk_pre_rate_change(struct clk_notifier_data *ndata,
 			struct exynos_cpuclk *cpuclk, void __iomem *base)
 {
 	const struct exynos_cpuclk_cfg_data *cfg_data = cpuclk->cfg;
-	unsigned long alt_prate = clk_get_rate(cpuclk->alt_parent);
+	unsigned long alt_prate = clk_hw_get_rate(cpuclk->alt_parent);
 	unsigned long alt_div = 0, alt_div_mask = DIV_MASK;
 	unsigned long div0, div1 = 0, mux_reg;
 	unsigned long flags;
@@ -432,7 +432,7 @@ int __init exynos_register_cpu_clock(struct samsung_clk_provider *ctx,
 	else
 		cpuclk->clk_nb.notifier_call = exynos_cpuclk_notifier_cb;
 
-	cpuclk->alt_parent = __clk_lookup(alt_parent);
+	cpuclk->alt_parent = __clk_get_hw(__clk_lookup(alt_parent));
 	if (!cpuclk->alt_parent) {
 		pr_err("%s: could not lookup alternate parent %s\n",
 				__func__, alt_parent);
diff --git a/drivers/clk/samsung/clk-cpu.h b/drivers/clk/samsung/clk-cpu.h
index d4b6b517fe1b4..bd38c6aa38970 100644
--- a/drivers/clk/samsung/clk-cpu.h
+++ b/drivers/clk/samsung/clk-cpu.h
@@ -49,7 +49,7 @@ struct exynos_cpuclk_cfg_data {
  */
 struct exynos_cpuclk {
 	struct clk_hw				hw;
-	struct clk				*alt_parent;
+	struct clk_hw				*alt_parent;
 	void __iomem				*ctrl_base;
 	spinlock_t				*lock;
 	const struct exynos_cpuclk_cfg_data	*cfg;
-- 
2.20.1

