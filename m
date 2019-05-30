Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D998D2EBA0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfE3DOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbfE3DOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91E924502;
        Thu, 30 May 2019 03:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186078;
        bh=wpFLMUdKh6awHahOy9KGYWpTkPUbg8nLPGHSCdP0rJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpkBQKgUGzJjdTsvIyqL9dHDrREWIbvMkzaHuUq0xvs7iQoyoQKALbDjKcg5yyzJP
         qkvgYVycWrnncrVNVjkSQoq5PK/joDTyN0MnkHYN7HpPz7yZwYubbV9Zdrlhr+wWM9
         E87SAVyohDdvjDjGSlq0xmPNjk1nGOgh3hSor3YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 196/346] clk: rockchip: Make rkpwm a critical clock on rk3288
Date:   Wed, 29 May 2019 20:04:29 -0700
Message-Id: <20190530030551.141081148@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dfe7fb21cd9e730230d55a79bc72cf2ece67cdd5 ]

Most rk3288-based boards are derived from the EVB and thus use a PWM
regulator for the logic rail.  However, most rk3288-based boards don't
specify the PWM regulator in their device tree.  We'll deal with that
by making it critical.

NOTE: it's important to make it critical and not just IGNORE_UNUSED
because all PWMs in the system share the same clock.  We don't want
another PWM user to turn the clock on and off and kill the logic rail.

This change is in preparation for actually having the PWMs in the
rk3288 device tree actually point to the proper PWM clock.  Up until
now they've all pointed to the clock for the old IP block and they've
all worked due to the fact that rkpwm was IGNORE_UNUSED and that the
clock rates for both clocks were the same.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 623c5f684987c..355d6a3611dbf 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -697,7 +697,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_TZPC, "pclk_tzpc", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 3, GFLAGS),
 	GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 9, GFLAGS),
 	GATE(PCLK_EFUSE256, "pclk_efuse_256", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 10, GFLAGS),
-	GATE(PCLK_RKPWM, "pclk_rkpwm", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 11, GFLAGS),
+	GATE(PCLK_RKPWM, "pclk_rkpwm", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 11, GFLAGS),
 
 	/* ddrctrl [DDR Controller PHY clock] gates */
 	GATE(0, "nclk_ddrupctl0", "ddrphy", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 4, GFLAGS),
@@ -838,6 +838,8 @@ static const char *const rk3288_critical_clocks[] __initconst = {
 	"pclk_pd_pmu",
 	"pclk_pmu_niu",
 	"pmu_hclk_otg0",
+	/* pwm-regulators on some boards, so handoff-critical later */
+	"pclk_rkpwm",
 };
 
 static void __iomem *rk3288_cru_base;
-- 
2.20.1



