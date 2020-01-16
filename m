Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CB313E89D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404612AbgAPRdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404589AbgAPRag (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CC02472C;
        Thu, 16 Jan 2020 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195835;
        bh=3bs2tt+BQ2aDv4/lJ7CKnWz3MwHNBltAwpNAaDCYLDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPZ8F3cS7N738lJD/6eWbG0Uhba+5z3HRZD6gLSa5wqHuehvPGtyAvbG3rSujufwN
         PRJ5FwVIjWtjpSHuCqb4t0RqFAY9+ShJmvKz136O9EGDI8eOBFFEHCuzn8fK1TET5m
         nyhV3dHFKXpuc1GB7pandRuHKTy/JkO2Y7afjfjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marian Mihailescu <mihailescu2m@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 340/371] clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume
Date:   Thu, 16 Jan 2020 12:23:32 -0500
Message-Id: <20200116172403.18149-283-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marian Mihailescu <mihailescu2m@gmail.com>

[ Upstream commit e21be0d1d7bd7f78a77613f6bcb6965e72b22fc1 ]

Save and restore top PLL related configuration registers for big (APLL)
and LITTLE (KPLL) cores during suspend/resume cycle. So far, CPU clocks
were reset to default values after suspend/resume cycle and performance
after system resume was affected when performance governor has been selected.

Fixes: 773424326b51 ("clk: samsung: exynos5420: add more registers to restore list")
Signed-off-by: Marian Mihailescu <mihailescu2m@gmail.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 47a14f93f869..2f54df5bef8e 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -170,6 +170,8 @@ static const unsigned long exynos5x_clk_regs[] __initconst = {
 	GATE_BUS_CPU,
 	GATE_SCLK_CPU,
 	CLKOUT_CMU_CPU,
+	APLL_CON0,
+	KPLL_CON0,
 	CPLL_CON0,
 	DPLL_CON0,
 	EPLL_CON0,
-- 
2.20.1

