Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDACB3D2836
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhGVPzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGVPzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8E561363;
        Thu, 22 Jul 2021 16:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971777;
        bh=Go4BnhS7I+BzIFCkuG3oPI8y+rCTGjbENw+4CLLHny0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbS7gJtqzdhb1PouEQ3xBu/OPbKKRUOEylUSapesRvSSuApxJBiDj6BojJH7gtYdC
         YiYwWK6UIucuZdOFYaBZVcH3ohMBlggJcyiBS3fnMri/ZrZnK6Zr300T57beoJJHhD
         FkZ1ILAtSWP5vU3dtQAd1Af3kI8FBIBZYOqEyJvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/125] arm64: dts: rockchip: fix regulator-gpio states array
Date:   Thu, 22 Jul 2021 18:30:13 +0200
Message-Id: <20210722155625.422030706@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit b82f8e2992534aab0fa762a37376be30df263701 ]

A test with the command below gives this error:

/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dt.yaml:
sdmmcio-regulator: states:0:
[1800000, 1, 3300000, 0] is too long

dtbs_check expects regulator-gpio states in a format
of 2 per item, so fix them all.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/
regulator/gpio-regulator.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210510215840.16270-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts       | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts   | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts       | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi | 2 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi         | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index 7a96be10eaf0..bce6f8b7db43 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -78,8 +78,8 @@
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 		gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x0
-			  3300000 0x1>;
+		states = <1800000 0x0>,
+			 <3300000 0x1>;
 		vin-supply = <&vcc5v0_sys>;
 	};
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
index 1eecad724f04..83a0bdbe00d6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts
@@ -71,8 +71,8 @@
 		regulator-settling-time-us = <5000>;
 		regulator-type = "voltage";
 		startup-delay-us = <2000>;
-		states = <1800000 0x1
-			  3300000 0x0>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
 		vin-supply = <&vcc_io_33>;
 	};
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
index b76282e704de..daa9a0c601a9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -45,8 +45,8 @@
 	vcc_sdio: sdmmcio-regulator {
 		compatible = "regulator-gpio";
 		gpios = <&grf_gpio 0 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x1
-			  3300000 0x0>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
 		regulator-name = "vcc_sdio";
 		regulator-type = "voltage";
 		regulator-min-microvolt = <1800000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
index 60cd1c18cd4e..e9ecffc409c0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
@@ -245,7 +245,7 @@ pp1800_pcie: &pp1800_s0 {
 };
 
 &ppvar_sd_card_io {
-	states = <1800000 0x0 3300000 0x1>;
+	states = <1800000 0x0>, <3300000 0x1>;
 	regulator-max-microvolt = <3300000>;
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index 32dcaf210085..765b24a2bcbf 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -247,8 +247,8 @@
 		enable-active-high;
 		enable-gpio = <&gpio2 2 GPIO_ACTIVE_HIGH>;
 		gpios = <&gpio2 28 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x1
-			  3000000 0x0>;
+		states = <1800000 0x1>,
+			 <3000000 0x0>;
 
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3000000>;
-- 
2.30.2



