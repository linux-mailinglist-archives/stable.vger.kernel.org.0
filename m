Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3458299C8C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411304AbgJ0AAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436607AbgJZX4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DF1120770;
        Mon, 26 Oct 2020 23:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756607;
        bh=A+WU2JHvgRBnUx9lmFNdT+CH1MAFfFyUeEleTs/VGzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJwoLlTt23oAW6KtPyfxim3fXjGl51DydGcCQzBqgE8NmyBgVgbnJqpVonzXDAX+z
         2Kzu3rP8CeU9d3dtdFeM81t1WiDGe/VxLJ4yJxTa5XqTW+zsR5zuuXm1W4vUhmTWzd
         ZvpW+U5M0sFJFeg/G7J+X+/niAjQB9sqUFwRcB7c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 75/80] ARM: dts: s5pv210: move fixed clocks under root node
Date:   Mon, 26 Oct 2020 19:55:11 -0400
Message-Id: <20201026235516.1025100-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit d38cae370e5f2094cbc38db3082b8e9509ae52ce ]

The fixed clocks are kept under dedicated 'external-clocks' node, thus a
fake 'reg' was added.  This is not correct with dtschema as fixed-clock
binding does not have a 'reg' property.  Moving fixed clocks out of
'soc' to root node fixes multiple dtbs_check warnings:

  external-clocks: $nodename:0: 'external-clocks' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
  external-clocks: #size-cells:0:0: 0 is not one of [1, 2]
  external-clocks: oscillator@0:reg:0: [0] is too short
  external-clocks: oscillator@1:reg:0: [1] is too short
  external-clocks: 'ranges' is a required property
  oscillator@0: 'reg' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/20200907161141.31034-7-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210.dtsi | 36 +++++++++++++---------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
index 8b194da334a5c..ec41e46edaced 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -52,34 +52,26 @@ cpu@0 {
 		};
 	};
 
+	xxti: oscillator-0 {
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+		clock-output-names = "xxti";
+		#clock-cells = <0>;
+	};
+
+	xusbxti: oscillator-1 {
+		compatible = "fixed-clock";
+		clock-frequency = <0>;
+		clock-output-names = "xusbxti";
+		#clock-cells = <0>;
+	};
+
 	soc {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges;
 
-		external-clocks {
-			compatible = "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			xxti: oscillator@0 {
-				compatible = "fixed-clock";
-				reg = <0>;
-				clock-frequency = <0>;
-				clock-output-names = "xxti";
-				#clock-cells = <0>;
-			};
-
-			xusbxti: oscillator@1 {
-				compatible = "fixed-clock";
-				reg = <1>;
-				clock-frequency = <0>;
-				clock-output-names = "xusbxti";
-				#clock-cells = <0>;
-			};
-		};
-
 		onenand: onenand@b0600000 {
 			compatible = "samsung,s5pv210-onenand";
 			reg = <0xb0600000 0x2000>,
-- 
2.25.1

