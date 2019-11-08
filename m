Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C671F55D8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390234AbfKHTFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391102AbfKHTFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B16214DB;
        Fri,  8 Nov 2019 19:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239909;
        bh=j0dq07s5gcJmAjlTqbRFwDv0S35OH9GkUrQKdW+7wE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJpY6ox7LlGWJl6mtvPZt9IM6akr7/tTI6eGfKoFBfwFv5rLu0huaWIueKUYsW+Rx
         uYuosR8e0a8pKUy0SJTLLvZiiozv3l6ar1xj7YKHIzq7Mjvsu9U7QrfR3oqwdO5Vg0
         LSwT1ZASn1pgyotbY6/GPauHt7luaL5Pnixb1HEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Cole-Baker <sigmaris@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 023/140] arm64: dts: rockchip: fix Rockpro64 RK808 interrupt line
Date:   Fri,  8 Nov 2019 19:49:11 +0100
Message-Id: <20191108174904.564888785@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Cole-Baker <sigmaris@gmail.com>

[ Upstream commit deea9f5fc32040fd6f6132f2260ba410fb5cf98c ]

Fix the pinctrl and interrupt specifier for RK808 to use GPIO3_B2. On the
Rockpro64 schematic [1] page 16, it shows GPIO3_B2 used for the interrupt
line PMIC_INT_L from the RK808, and there's a note which translates as:
"PMU termination GPIO1_C5 changed to this".

Tested by setting an RTC wakealarm and checking /proc/interrupts counters.
Without this patch, neither the rockchip_gpio_irq counter for the RK808,
nor the RTC alarm counter increment when the alarm time is reached.
With this patch, both interrupt counters increment by 1 as expected.

[1] http://files.pine64.org/doc/rockpro64/rockpro64_v21-SCH.pdf

Fixes: e4f3fb490967 ("arm64: dts: rockchip: add initial dts support for Rockpro64")
Signed-off-by: Hugh Cole-Baker <sigmaris@gmail.com>
Link: https://lore.kernel.org/r/20190921131457.36258-1-sigmaris@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
index eb55940620060..5818b85255123 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -240,8 +240,8 @@
 	rk808: pmic@1b {
 		compatible = "rockchip,rk808";
 		reg = <0x1b>;
-		interrupt-parent = <&gpio1>;
-		interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio3>;
+		interrupts = <10 IRQ_TYPE_LEVEL_LOW>;
 		#clock-cells = <1>;
 		clock-output-names = "xin32k", "rk808-clkout2";
 		pinctrl-names = "default";
@@ -567,7 +567,7 @@
 
 	pmic {
 		pmic_int_l: pmic-int-l {
-			rockchip,pins = <1 RK_PC5 RK_FUNC_GPIO &pcfg_pull_up>;
+			rockchip,pins = <3 RK_PB2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 
 		vsel1_gpio: vsel1-gpio {
-- 
2.20.1



