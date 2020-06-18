Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8471FE715
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgFRBNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgFRBNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B9221D7E;
        Thu, 18 Jun 2020 01:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442796;
        bh=13GwXvTMOXsEYR0IfY7cgtgAMSISLoKBnsBmY4n0ne8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKWy91zrIqBODGqJloj7+6yLKiOsgbYb3vdeZnFZS04/m+7GmXDWTtLtEoewYDfEo
         YDaZZc9hLeXt25IzXqnszTk+OCwS3G9FTGmBTlSIAMoirsi06uR7bgtA+nl8eTIbcl
         RYfyf4EoGjzeJAwEGmzlXMY3SaVFQryljWviXFfQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 238/388] clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1
Date:   Wed, 17 Jun 2020 21:05:35 -0400
Message-Id: <20200618010805.600873-238-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 25bdae0f1c6609ceaf55fe6700654f0be2253d8e ]

Mark the SCLK clock for Exynos5433 I2S1 device with IGNORE_UNUSED flag to
match its behaviour with SCLK clock for AUD_I2S (I2S0) device until
a proper fix for Exynos I2S driver is ready.

This fixes the following synchronous abort issue revealed by the probe
order change caused by the commit 93d2e4322aa7 ("of: platform: Batch
fwnode parsing when adding all top level devices")

Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 50 Comm: kworker/0:1 Not tainted 5.7.0-rc5+ #701
Hardware name: Samsung TM2E board (DT)
Workqueue: events deferred_probe_work_func
pstate: 60000005 (nZCv daif -PAN -UAO)
pc : samsung_i2s_probe+0x768/0x8f0
lr : samsung_i2s_probe+0x688/0x8f0
...
Call trace:
 samsung_i2s_probe+0x768/0x8f0
 platform_drv_probe+0x50/0xa8
 really_probe+0x108/0x370
 driver_probe_device+0x54/0xb8
 __device_attach_driver+0x90/0xc0
 bus_for_each_drv+0x70/0xc8
 __device_attach+0xdc/0x140
 device_initial_probe+0x10/0x18
 bus_probe_device+0x94/0xa0
 deferred_probe_work_func+0x70/0xa8
 process_one_work+0x2a8/0x718
 worker_thread+0x48/0x470
 kthread+0x134/0x160
 ret_from_fork+0x10/0x1c
Code: 17ffffaf d503201f f94086c0 91003000 (88dffc00)
---[ end trace ccf721c9400ddbd6 ]---

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5433.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 4b1aa9382ad2..6f29ecd0442e 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -1706,7 +1706,8 @@ static const struct samsung_gate_clock peric_gate_clks[] __initconst = {
 	GATE(CLK_SCLK_PCM1, "sclk_pcm1", "sclk_pcm1_peric",
 			ENABLE_SCLK_PERIC, 7, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_I2S1, "sclk_i2s1", "sclk_i2s1_peric",
-			ENABLE_SCLK_PERIC, 6, CLK_SET_RATE_PARENT, 0),
+			ENABLE_SCLK_PERIC, 6,
+			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_SPI2, "sclk_spi2", "sclk_spi2_peric", ENABLE_SCLK_PERIC,
 			5, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SPI1, "sclk_spi1", "sclk_spi1_peric", ENABLE_SCLK_PERIC,
-- 
2.25.1

