Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDF13A030B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbhFHTMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237375AbhFHTJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E8056193D;
        Tue,  8 Jun 2021 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178083;
        bh=cY6VT926SNEyst44QszIgpzwRY/AFAg5Fg+7tS4wOxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ/vXDkV0IXCKMXO8NsaBQvMz1XLbFsHLwxl3MOUm8jV0cqcDlQJyzDPAGjzXgkpl
         4dNmq4MWqAAIJOCDP/cbbphEp0cVxp01+W1tXV8Vd9oJU5yIMeLF8OK/94GJZbMMFJ
         NQ1xetTDu4AfNKMl/loGQTBiiJW2VDMlJsuYzK1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 070/161] arm64: dts: zii-ultra: remove second GEN_3V3 regulator instance
Date:   Tue,  8 Jun 2021 20:26:40 +0200
Message-Id: <20210608175947.824388011@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit e98d98028989e023e0cbff539dc616c4e5036839 ]

When adding the sound support a second instance of the GEN_3V3 regulator was
added by accident. Remove it and point the consumers to the first instance.

Fixes: 663a5b5efa51 ("arm64: dts: zii-ultra: add sound support")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mq-zii-ultra-rmb3.dts   | 10 +++++-----
 .../boot/dts/freescale/imx8mq-zii-ultra.dtsi  | 19 +++++--------------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-rmb3.dts b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-rmb3.dts
index 631e01c1b9fd..be1e7d6f0ecb 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-rmb3.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-rmb3.dts
@@ -88,11 +88,11 @@
 		pinctrl-0 = <&pinctrl_codec2>;
 		reg = <0x18>;
 		#sound-dai-cells = <0>;
-		HPVDD-supply = <&reg_3p3v>;
-		SPRVDD-supply = <&reg_3p3v>;
-		SPLVDD-supply = <&reg_3p3v>;
-		AVDD-supply = <&reg_3p3v>;
-		IOVDD-supply = <&reg_3p3v>;
+		HPVDD-supply = <&reg_gen_3p3>;
+		SPRVDD-supply = <&reg_gen_3p3>;
+		SPLVDD-supply = <&reg_gen_3p3>;
+		AVDD-supply = <&reg_gen_3p3>;
+		IOVDD-supply = <&reg_gen_3p3>;
 		DVDD-supply = <&vgen4_reg>;
 		reset-gpios = <&gpio3 4 GPIO_ACTIVE_HIGH>;
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
index 4dc8383478ee..1e5d34e81ab7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
@@ -77,15 +77,6 @@
 		regulator-always-on;
 	};
 
-	reg_3p3v: regulator-3p3v {
-		compatible = "regulator-fixed";
-		vin-supply = <&reg_3p3_main>;
-		regulator-name = "GEN_3V3";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		regulator-always-on;
-	};
-
 	reg_usdhc2_vmmc: regulator-vsd-3v3 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_usdhc2>;
@@ -415,11 +406,11 @@
 		pinctrl-0 = <&pinctrl_codec1>;
 		reg = <0x18>;
 		#sound-dai-cells = <0>;
-		HPVDD-supply = <&reg_3p3v>;
-		SPRVDD-supply = <&reg_3p3v>;
-		SPLVDD-supply = <&reg_3p3v>;
-		AVDD-supply = <&reg_3p3v>;
-		IOVDD-supply = <&reg_3p3v>;
+		HPVDD-supply = <&reg_gen_3p3>;
+		SPRVDD-supply = <&reg_gen_3p3>;
+		SPLVDD-supply = <&reg_gen_3p3>;
+		AVDD-supply = <&reg_gen_3p3>;
+		IOVDD-supply = <&reg_gen_3p3>;
 		DVDD-supply = <&vgen4_reg>;
 		reset-gpios = <&gpio3 3 GPIO_ACTIVE_LOW>;
 	};
-- 
2.30.2



