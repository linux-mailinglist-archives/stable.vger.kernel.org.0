Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826804F3E46
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351473AbiDEMWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344137AbiDEKjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B92654C;
        Tue,  5 Apr 2022 03:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB765B81C98;
        Tue,  5 Apr 2022 10:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B866C385A1;
        Tue,  5 Apr 2022 10:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154300;
        bh=QLM2ZEVgjYzkdh/AaHI6bLcEGIY3utV+z9bS4wM40eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fze3qrAXgUh6i/7ntK3d1VIWLBUD3HlgE33cuPvRdR82tD1Fy9nqsw3NEy5KP4Wgk
         7KHTPgQYUvp9kLZcGf970do1d7EODZ5Tg/1rJ/zlW6LhGabENJsYWIdVDwftt0DB3Q
         Iaeu7MEGzbtHLy/xOSdr8a4XWHiR9DPlhb13SC8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abel Vesa <abel.vesa@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/599] ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk
Date:   Tue,  5 Apr 2022 09:33:07 +0200
Message-Id: <20220405070313.498928825@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@nxp.com>

[ Upstream commit 4cb7df64c732b2b9918424095c11660c2a8c4a33 ]

The audio_mclk_root_clk was added as a gate with the CCGR121 (0x4790),
but according to the reference manual, there is no such gate. Moreover,
the consumer driver of the mentioned clock might gate it and leave
the ECSPI2 (the true owner of that gate) hanging. So lets use the
audio_mclk_post_div, which is the parent.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-colibri.dtsi     | 4 ++--
 arch/arm/boot/dts/imx7-mba7.dtsi        | 2 +-
 arch/arm/boot/dts/imx7d-nitrogen7.dts   | 2 +-
 arch/arm/boot/dts/imx7d-pico-hobbit.dts | 4 ++--
 arch/arm/boot/dts/imx7d-pico-pi.dts     | 4 ++--
 arch/arm/boot/dts/imx7d-sdb.dts         | 4 ++--
 arch/arm/boot/dts/imx7s-warp.dts        | 4 ++--
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-colibri.dtsi b/arch/arm/boot/dts/imx7-colibri.dtsi
index 62b771c1d5a9..f1c60b0cb143 100644
--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -40,7 +40,7 @@
 
 		dailink_master: simple-audio-card,codec {
 			sound-dai = <&codec>;
-			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		};
 	};
 };
@@ -293,7 +293,7 @@
 		compatible = "fsl,sgtl5000";
 		#sound-dai-cells = <0>;
 		reg = <0x0a>;
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_sai1_mclk>;
 		VDDA-supply = <&reg_module_3v3_avdd>;
diff --git a/arch/arm/boot/dts/imx7-mba7.dtsi b/arch/arm/boot/dts/imx7-mba7.dtsi
index 50abf18ad30b..887497e3bb4b 100644
--- a/arch/arm/boot/dts/imx7-mba7.dtsi
+++ b/arch/arm/boot/dts/imx7-mba7.dtsi
@@ -250,7 +250,7 @@
 	tlv320aic32x4: audio-codec@18 {
 		compatible = "ti,tlv320aic32x4";
 		reg = <0x18>;
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		clock-names = "mclk";
 		ldoin-supply = <&reg_audio_3v3>;
 		iov-supply = <&reg_audio_3v3>;
diff --git a/arch/arm/boot/dts/imx7d-nitrogen7.dts b/arch/arm/boot/dts/imx7d-nitrogen7.dts
index e0751e6ba3c0..a31de900139d 100644
--- a/arch/arm/boot/dts/imx7d-nitrogen7.dts
+++ b/arch/arm/boot/dts/imx7d-nitrogen7.dts
@@ -288,7 +288,7 @@
 	codec: wm8960@1a {
 		compatible = "wlf,wm8960";
 		reg = <0x1a>;
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		clock-names = "mclk";
 		wlf,shared-lrclk;
 	};
diff --git a/arch/arm/boot/dts/imx7d-pico-hobbit.dts b/arch/arm/boot/dts/imx7d-pico-hobbit.dts
index 7b2198a9372c..d917dc4f2f22 100644
--- a/arch/arm/boot/dts/imx7d-pico-hobbit.dts
+++ b/arch/arm/boot/dts/imx7d-pico-hobbit.dts
@@ -31,7 +31,7 @@
 
 		dailink_master: simple-audio-card,codec {
 			sound-dai = <&sgtl5000>;
-			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		};
 	};
 };
@@ -41,7 +41,7 @@
 		#sound-dai-cells = <0>;
 		reg = <0x0a>;
 		compatible = "fsl,sgtl5000";
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		VDDA-supply = <&reg_2p5v>;
 		VDDIO-supply = <&reg_vref_1v8>;
 	};
diff --git a/arch/arm/boot/dts/imx7d-pico-pi.dts b/arch/arm/boot/dts/imx7d-pico-pi.dts
index 70bea95c06d8..f263e391e24c 100644
--- a/arch/arm/boot/dts/imx7d-pico-pi.dts
+++ b/arch/arm/boot/dts/imx7d-pico-pi.dts
@@ -31,7 +31,7 @@
 
 		dailink_master: simple-audio-card,codec {
 			sound-dai = <&sgtl5000>;
-			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		};
 	};
 };
@@ -41,7 +41,7 @@
 		#sound-dai-cells = <0>;
 		reg = <0x0a>;
 		compatible = "fsl,sgtl5000";
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		VDDA-supply = <&reg_2p5v>;
 		VDDIO-supply = <&reg_vref_1v8>;
 	};
diff --git a/arch/arm/boot/dts/imx7d-sdb.dts b/arch/arm/boot/dts/imx7d-sdb.dts
index ac0751bc1177..6823b9f1a2a3 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -378,14 +378,14 @@
 	codec: wm8960@1a {
 		compatible = "wlf,wm8960";
 		reg = <0x1a>;
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		clock-names = "mclk";
 		wlf,shared-lrclk;
 		wlf,hp-cfg = <2 2 3>;
 		wlf,gpio-cfg = <1 3>;
 		assigned-clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_SRC>,
 				  <&clks IMX7D_PLL_AUDIO_POST_DIV>,
-				  <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+				  <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		assigned-clock-parents = <&clks IMX7D_PLL_AUDIO_POST_DIV>;
 		assigned-clock-rates = <0>, <884736000>, <12288000>;
 	};
diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index d6b4888fa686..e035dd5bf4f6 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -75,7 +75,7 @@
 
 		dailink_master: simple-audio-card,codec {
 			sound-dai = <&codec>;
-			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		};
 	};
 };
@@ -232,7 +232,7 @@
 		#sound-dai-cells = <0>;
 		reg = <0x0a>;
 		compatible = "fsl,sgtl5000";
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_sai1_mclk>;
 		VDDA-supply = <&vgen4_reg>;
-- 
2.34.1



