Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9572ABCED
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgKINlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbgKINBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:01:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A9620679;
        Mon,  9 Nov 2020 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926903;
        bh=mhZVlYlOw2yc0uAA3UI/KnbYED2JazQjwZkQeI1Kf+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgC3N8Cp45lkcEwX0xKlVl9D3wbRlUCLElxxdE9UdHO+du6qiCXwfvVM9Q4S2m0UU
         f/6iT8pOsEWm5gxkEEqTSJQ82/GWZcD/pmWIl6XOyx5BKiq4wRJF6C2BFvvioCiI4p
         4zFh6Ld0aunmwH09MGj+nshHpRl4WpwV4px64adQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 042/117] ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings
Date:   Mon,  9 Nov 2020 13:54:28 +0100
Message-Id: <20201109125027.658169262@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
index 0c10ba517cd04..57f64a7160290 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -129,35 +129,28 @@
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



