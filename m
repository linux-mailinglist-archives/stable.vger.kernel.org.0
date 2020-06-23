Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CEC20615A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392184AbgFWUjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392177AbgFWUjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:39:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1921217D9;
        Tue, 23 Jun 2020 20:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944794;
        bh=SSj/Gu+vnua5vgrjvq55p0v4VVLdJec4meTq6j3WJ8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEfJ86EUY11InoTyYbZvLwLfMOE7NiTpM3XL3jVZk/d9lRloj/cw8m7m9QcMEpYov
         2X9lQRUo7phbTG24aYxcT/DZmUvFGMU1uoI3ZINadH2jGwQ8sCLr/Lh9+WPut7OUnX
         ejb6wLKGxFe3gB9lawNr5/+KgEcJUDPC0cnMSmMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/206] clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1
Date:   Tue, 23 Jun 2020 21:57:05 +0200
Message-Id: <20200623195321.713036113@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 302596dc79a2c..0f2a9d767eefe 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -1680,7 +1680,8 @@ static const struct samsung_gate_clock peric_gate_clks[] __initconst = {
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



