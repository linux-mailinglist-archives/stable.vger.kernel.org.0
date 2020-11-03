Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230762A574F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732749AbgKCVlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732455AbgKCU4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A0C223AC;
        Tue,  3 Nov 2020 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436967;
        bh=Ox6EAYXddyowK9vq1ujPy0x+HFrAmMft5NObU/+yisA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtuoSxi8T486O9K3P7RzUDpkLE5wPFEL85eN/yX4LjvREoCxRVVyI3svNfWIo4RQb
         GxcACztm/7No9eGJvefCvj2yEmveqHc/9icnvRuQxPw0Ny0acTXk0WDrq3jW2um/Al
         K3mNKHIq0AlWQY4BfULPQJdMXmmSURqayZ4lCIyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/214] ARM: dts: s5pv210: move fixed clocks under root node
Date:   Tue,  3 Nov 2020 21:35:38 +0100
Message-Id: <20201103203258.863307363@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -52,34 +52,26 @@
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
2.27.0



