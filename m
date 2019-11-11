Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF68F7DB3
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbfKKS6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfKKS6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC89E21655;
        Mon, 11 Nov 2019 18:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498687;
        bh=0bcH6ifp+XOXvLJmWDoEIZrItJiF6xsztx9f9rbDPCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alS5Npk7nXJs3lYTlUDeYbV2djfq61ChVjHqaNWoubo4998j7erGM6iSu/DC6wKDK
         yhy28QYlE1Vr8Sl1HyPTzB27SR4mRI8qTOFwHR1+IEI9fsEXAGmeoOY4qh/4+LgXXG
         yj6Hk0j3GPag0Rl0ac3jl15AGlyZc/OlUDvlJCnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 190/193] clk: imx8m: Use SYS_PLL1_800M as intermediate parent of CLK_ARM
Date:   Mon, 11 Nov 2019 19:29:32 +0100
Message-Id: <20191111181515.101557356@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit b234fe9558615098d8d62516e7041ad7f99ebcea ]

During cpu frequency switching the main "CLK_ARM" is reparented to an
intermediate "step" clock. On imx8mm and imx8mn the 24M oscillator is
used for this purpose but it is extremely slow, increasing wakeup
latencies to the point that i2c transactions can timeout and system
becomes unresponsive.

Fix by switching the "step" clk to SYS_PLL1_800M, matching the behavior
of imx8m cpufreq drivers in imx vendor tree.

This bug was not immediately apparent because upstream arm64 defconfig
uses the "performance" governor by default so no cpufreq transitions
happen.

Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
Fixes: 96d6392b54db ("clk: imx: Add support for i.MX8MN clock driver")

Cc: stable@vger.kernel.org
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Link: https://lkml.kernel.org/r/f5d2b9c53f1ed5ccb1dd3c6624f56759d92e1689.1571771777.git.leonard.crestez@nxp.com
Acked-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
index 6f46bcb1d6432..59ce93691e970 100644
--- a/drivers/clk/imx/clk-imx8mm.c
+++ b/drivers/clk/imx/clk-imx8mm.c
@@ -666,7 +666,7 @@ static int __init imx8mm_clocks_init(struct device_node *ccm_node)
 					   clks[IMX8MM_CLK_A53_DIV],
 					   clks[IMX8MM_CLK_A53_SRC],
 					   clks[IMX8MM_ARM_PLL_OUT],
-					   clks[IMX8MM_CLK_24M]);
+					   clks[IMX8MM_SYS_PLL1_800M]);
 
 	imx_check_clocks(clks, ARRAY_SIZE(clks));
 
-- 
2.20.1



