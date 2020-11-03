Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A915E2A574E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732425AbgKCU4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:56:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732446AbgKCU4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166A62053B;
        Tue,  3 Nov 2020 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436965;
        bh=Q6bPBsa9iLZA5r6OQv9C/a455aoIqI5/OK+YTcw688A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VU6mDDZhCdYYli0cw9LCPkqWZNUWhq5HHh8MqKcTntts3fNQ7jTv35p+SiqtTDGpC
         7vobPRcX9h+DH8B4kk1CGc3BARU97zrNoTN9sJRwpR9VXtRPSGUgJbW/uXFsMsBo/Z
         4KWqw1iO+axXSRp08RxrI4qTfEufcMxclcdvH/2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/214] ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings
Date:   Tue,  3 Nov 2020 21:35:37 +0100
Message-Id: <20201103203258.751771490@linuxfoundation.org>
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
index 2ad642f51fd92..8b194da334a5c 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -128,35 +128,28 @@
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
 
 		spi0: spi@e1300000 {
-- 
2.27.0



