Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F1F2A55D6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbgKCVWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732706AbgKCVFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:05:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3E3205ED;
        Tue,  3 Nov 2020 21:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437512;
        bh=iDgrYRZJ8qBsgk7xPw/ojIMR0LaiwnxmtGDZobuGfn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFkteBSn5L9tWIPbDCHcfPbBD2/wfzGXaUj6PZwJ0VJ3Gar4S4xXE7bv9CpvEOvGo
         JEKkihaP/63FBJ3nLpG83HXbVrJIihYnodl2GVOJi3aI9B9voB71QdiOu6dd3Ilxhs
         gaZJtYPVARw7TD3c63hfJRDDGZl6vJB7kSDx8/oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/191] ARM: dts: s5pv210: remove dedicated audio-subsystem node
Date:   Tue,  3 Nov 2020 21:36:40 +0100
Message-Id: <20201103203243.662207642@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 6c17a2974abf68a58517f75741b15c4aba42b4b8 ]

The 'audio-subsystem' node is an artificial creation, not representing
real hardware.  The hardware is described by its nodes - AUDSS clock
controller and I2S0.

Remove the 'audio-subsystem' node along with its undocumented compatible
to fix dtbs_check warnings like:

  audio-subsystem: $nodename:0: 'audio-subsystem' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/20200907161141.31034-9-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210.dtsi | 65 +++++++++++++++-------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
index 37d251b1f74a7..020a864623ff4 100644
--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -217,43 +217,36 @@
 			status = "disabled";
 		};
 
-		audio-subsystem {
-			compatible = "samsung,s5pv210-audss", "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges;
-
-			clk_audss: clock-controller@eee10000 {
-				compatible = "samsung,s5pv210-audss-clock";
-				reg = <0xeee10000 0x1000>;
-				clock-names = "hclk", "xxti",
-						"fout_epll",
-						"sclk_audio0";
-				clocks = <&clocks DOUT_HCLKP>, <&xxti>,
-						<&clocks FOUT_EPLL>,
-						<&clocks SCLK_AUDIO0>;
-				#clock-cells = <1>;
-			};
+		clk_audss: clock-controller@eee10000 {
+			compatible = "samsung,s5pv210-audss-clock";
+			reg = <0xeee10000 0x1000>;
+			clock-names = "hclk", "xxti",
+				      "fout_epll",
+				      "sclk_audio0";
+			clocks = <&clocks DOUT_HCLKP>, <&xxti>,
+				 <&clocks FOUT_EPLL>,
+				 <&clocks SCLK_AUDIO0>;
+			#clock-cells = <1>;
+		};
 
-			i2s0: i2s@eee30000 {
-				compatible = "samsung,s5pv210-i2s";
-				reg = <0xeee30000 0x1000>;
-				interrupt-parent = <&vic2>;
-				interrupts = <16>;
-				dma-names = "rx", "tx", "tx-sec";
-				dmas = <&pdma1 9>, <&pdma1 10>, <&pdma1 11>;
-				clock-names = "iis",
-						"i2s_opclk0",
-						"i2s_opclk1";
-				clocks = <&clk_audss CLK_I2S>,
-						<&clk_audss CLK_I2S>,
-						<&clk_audss CLK_DOUT_AUD_BUS>;
-				samsung,idma-addr = <0xc0010000>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&i2s0_bus>;
-				#sound-dai-cells = <0>;
-				status = "disabled";
-			};
+		i2s0: i2s@eee30000 {
+			compatible = "samsung,s5pv210-i2s";
+			reg = <0xeee30000 0x1000>;
+			interrupt-parent = <&vic2>;
+			interrupts = <16>;
+			dma-names = "rx", "tx", "tx-sec";
+			dmas = <&pdma1 9>, <&pdma1 10>, <&pdma1 11>;
+			clock-names = "iis",
+				      "i2s_opclk0",
+				      "i2s_opclk1";
+			clocks = <&clk_audss CLK_I2S>,
+				 <&clk_audss CLK_I2S>,
+				 <&clk_audss CLK_DOUT_AUD_BUS>;
+			samsung,idma-addr = <0xc0010000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2s0_bus>;
+			#sound-dai-cells = <0>;
+			status = "disabled";
 		};
 
 		i2s1: i2s@e2100000 {
-- 
2.27.0



