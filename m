Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBCF2F0BE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfE3EG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbfE3DRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB84123B5C;
        Thu, 30 May 2019 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186252;
        bh=4qFf+ReEGAlxmB+u/dhYnW1b0I/eQL6fC26LheLmXMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sL0TzuQpEzVjAW6TwhmfmwsXRGb2JHlSwd4Fg8ya7lyVqdzfBX+6Qdl71i4oiyms
         5loC9HBGKkgc0tZ6EsF6tyStD1s6p2SbiSqBuFj1TM5YWtZz40N6PHBN1p1sujE80/
         ok7Zo7Kgg769oiMIXR5b6jDvZnKbAyp5WDZ4dahA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/276] clk: rockchip: Make rkpwm a critical clock on rk3288
Date:   Wed, 29 May 2019 20:05:30 -0700
Message-Id: <20190530030536.122559536@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index c6cd6d28af56f..64191694ff6e9 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -676,7 +676,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_TZPC, "pclk_tzpc", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 3, GFLAGS),
 	GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 9, GFLAGS),
 	GATE(PCLK_EFUSE256, "pclk_efuse_256", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 10, GFLAGS),
-	GATE(PCLK_RKPWM, "pclk_rkpwm", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 11, GFLAGS),
+	GATE(PCLK_RKPWM, "pclk_rkpwm", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 11, GFLAGS),
 
 	/* ddrctrl [DDR Controller PHY clock] gates */
 	GATE(0, "nclk_ddrupctl0", "ddrphy", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 4, GFLAGS),
@@ -817,6 +817,8 @@ static const char *const rk3288_critical_clocks[] __initconst = {
 	"pclk_pd_pmu",
 	"pclk_pmu_niu",
 	"pmu_hclk_otg0",
+	/* pwm-regulators on some boards, so handoff-critical later */
+	"pclk_rkpwm",
 };
 
 static void __iomem *rk3288_cru_base;
-- 
2.20.1



