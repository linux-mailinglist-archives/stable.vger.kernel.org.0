Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D021299C13
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410518AbgJZXyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410510AbgJZXyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B2D20770;
        Mon, 26 Oct 2020 23:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756479;
        bh=NNHRkHNwnAuoOXQ5XBDK/xGixqeP5LvrsDlGrNR8SLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkz0EDgrHSM+1NO1w08dfLmri/28nmzwYgeApFuITEWyW3ohIpPBg/Q3C+k5iijVi
         Tc/Z9cv1ubE8uVOrsRAOORmXr4wB2nklre5Hhal2ugrDr2lhuUeChYPHXyM8a3xDhx
         XREEt+yUIy0C+Mbw5F9r1KfBgJ7Q+y4GpvPPRZIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 123/132] ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings
Date:   Mon, 26 Oct 2020 19:51:55 -0400
Message-Id: <20201026235205.1023962-123-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit ea4e792f3c8931fffec4d700cf6197d84e9f35a6 ]

There is no need to keep DMA controller nodes under AMBA bus node.
Remove the "amba" node to fix dtschema warnings like:

  amba: $nodename:0: 'amba' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/20200907161141.31034-6-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210.dtsi | 49 +++++++++++++++-------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
index 1b0ee884e91db..84e4447931de5 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -128,35 +128,28 @@ wakeup-interrupt-controller {
 			};
 		};
 
-		amba {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			compatible = "simple-bus";
-			ranges;
-
-			pdma0: dma@e0900000 {
-				compatible = "arm,pl330", "arm,primecell";
-				reg = <0xe0900000 0x1000>;
-				interrupt-parent = <&vic0>;
-				interrupts = <19>;
-				clocks = <&clocks CLK_PDMA0>;
-				clock-names = "apb_pclk";
-				#dma-cells = <1>;
-				#dma-channels = <8>;
-				#dma-requests = <32>;
-			};
+		pdma0: dma@e0900000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0xe0900000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <19>;
+			clocks = <&clocks CLK_PDMA0>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
 
-			pdma1: dma@e0a00000 {
-				compatible = "arm,pl330", "arm,primecell";
-				reg = <0xe0a00000 0x1000>;
-				interrupt-parent = <&vic0>;
-				interrupts = <20>;
-				clocks = <&clocks CLK_PDMA1>;
-				clock-names = "apb_pclk";
-				#dma-cells = <1>;
-				#dma-channels = <8>;
-				#dma-requests = <32>;
-			};
+		pdma1: dma@e0a00000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0xe0a00000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <20>;
+			clocks = <&clocks CLK_PDMA1>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
 		};
 
 		adc: adc@e1700000 {
-- 
2.25.1

