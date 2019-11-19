Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C761013B1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKSF01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbfKSF0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67099222ED;
        Tue, 19 Nov 2019 05:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141183;
        bh=V4E15JTP8Ncram5dpMtDGj4oBuQLPirvzgjhs8k4/tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5yxcXlOcecwKKpcbFECt5HKnr6UWSrNda89KGjekr+EwFfzcwJlELRDxJXm80x5v
         YV57xaRaD7U1TeyUUsLEDGEtaQmkRa7Z0gaSwlzE0QN8A+/obqWh0gWEAZ7DCRTrVF
         6UVqYB3CAR40orMhRp/vFY/28NVcuCC0xX6bpcbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/422] ARM: dts: exynos: Fix HDMI-HPD line handling on Arndale
Date:   Tue, 19 Nov 2019 06:14:30 +0100
Message-Id: <20191119051404.317414910@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



