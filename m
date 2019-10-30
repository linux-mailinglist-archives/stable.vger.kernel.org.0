Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C3CEA0B8
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfJ3PvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfJ3PvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:22 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABA1208E3;
        Wed, 30 Oct 2019 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450681;
        bh=j0dq07s5gcJmAjlTqbRFwDv0S35OH9GkUrQKdW+7wE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTvuGCLd5CaTAxK3/sPmdL461wXtFo2GqwAwBjK4cqrdgPoQNpB+X+aRJWNGRMGyS
         DhBXQngevvRpJrM+GuY4sLIKRnuboNWetptSGKi21MZwRq7NOfuRDUlqp2mM9Qujcd
         bUqCIfq9tVZ8eIU3tsmFEwmERyjUmT1xxRJu8DsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Cole-Baker <sigmaris@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 23/81] arm64: dts: rockchip: fix Rockpro64 RK808 interrupt line
Date:   Wed, 30 Oct 2019 11:48:29 -0400
Message-Id: <20191030154928.9432-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

