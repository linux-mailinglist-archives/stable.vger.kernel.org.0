Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE7F4A8B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbfKHLin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732788AbfKHLim (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7900E21D7E;
        Fri,  8 Nov 2019 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213122;
        bh=V4E15JTP8Ncram5dpMtDGj4oBuQLPirvzgjhs8k4/tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYn2jH9n1jsJaZJgFFeOTHlmbMWxmfPVlEHeB3k8kJOF5O+lhmcgjSqKPdqm+I8B7
         xF41ZqYsTQrxHIgARqnq68drn45rtpsEzwlYPW+Qq4l5IfKEWbkAwm0HasMcHJCJkh
         tmAye8b+990TjcUNGLJBvBhIWkIhgwUo7swvCRtU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 041/205] ARM: dts: exynos: Fix HDMI-HPD line handling on Arndale
Date:   Fri,  8 Nov 2019 06:35:08 -0500
Message-Id: <20191108113752.12502-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Hajda <a.hajda@samsung.com>

[ Upstream commit 21cb5a27483a3cfdbcb7508a06a30c0a485e1211 ]

HDMI-HPD was set active low, moreover by default pincontrol chip sets
pull-down on the pin. As a result HDMI driver assumes TV is always
connected regardless of actual state.  The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-arndale.dts  | 4 +++-
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index bb3fcd652b5d7..9c8ab4b7fb2cf 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -149,9 +149,11 @@
 };
 
 &hdmi {
+	pinctrl-names = "default";
+	pinctrl-0 = <&hdmi_hpd>;
 	status = "okay";
 	ddc = <&i2c_ddc>;
-	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_LOW>;
+	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
 	vdd_osc-supply = <&ldo10_reg>;
 	vdd_pll-supply = <&ldo8_reg>;
 	vdd-supply = <&ldo8_reg>;
diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index b25d520393b8b..d31a68672bfac 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -599,6 +599,11 @@
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
+
+	hdmi_hpd: hdmi-hpd {
+		samsung,pins = "gpx3-7";
+		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
+	};
 };
 
 &pinctrl_1 {
-- 
2.20.1

