Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F054EC22C
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345231AbiC3L6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344582AbiC3LxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F37264F4D;
        Wed, 30 Mar 2022 04:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2658B81C23;
        Wed, 30 Mar 2022 11:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DFFC340EE;
        Wed, 30 Mar 2022 11:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640952;
        bh=K8wp9f7c8DZjl995t5b4YxLYOq6G3UpjgyQ/0uJK0k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6EP/n0+iEXDFWcVL4yJmBra26L+/K5vRb6bbu303whjOsVUIRvqtrhktKSIr3LJ8
         v2PSULqUmmJ6cgSgUFJN+/XRbumW/dlGTnm2ehK9ARvD8+zGuBI8c7fMk/2ncsYNjc
         SLrKogsTwHUwqvsbsXcctNXLS7GAj/ddQJlVDoLM46qD1Hs0PDQWedRRTLN98XzQAV
         i1xiCZNsaqRzZAB29Ur0Y00rXROL6422jPj7oxrfs+tZpdjWzHZhqK+rIzd7wqh5RG
         +eipTH5gyCy7z2AMsQXFTO1AL/dI0gRQi8BnHcxXw2YuqZ9Ir5Obr4Wd1xy6C/TuWc
         nN3vq+BIwHwKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abel Vesa <abel.vesa@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kernel@pengutronix.de,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 25/59] ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk
Date:   Wed, 30 Mar 2022 07:47:57 -0400
Message-Id: <20220330114831.1670235-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 49086c6b6a0a..3df6dff7734a 100644
--- a/arch/arm/boot/dts/imx7-mba7.dtsi
+++ b/arch/arm/boot/dts/imx7-mba7.dtsi
@@ -302,7 +302,7 @@
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
index 7813ef960f6e..f053f5122741 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -385,14 +385,14 @@
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
index 569bbd84e371..558b064da743 100644
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

