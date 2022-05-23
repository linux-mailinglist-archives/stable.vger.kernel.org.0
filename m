Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBBE530DAE
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 12:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiEWKUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 06:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiEWKUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 06:20:32 -0400
X-Greylist: delayed 456 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 May 2022 03:20:29 PDT
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [83.166.143.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8F149C98
        for <stable@vger.kernel.org>; Mon, 23 May 2022 03:20:29 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L6Cnb2NDFzMr1YN;
        Mon, 23 May 2022 12:12:51 +0200 (CEST)
Received: from philippe-pc.toradex.int (unknown [31.10.206.125])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L6Cnb00W0zlhSMk;
        Mon, 23 May 2022 12:12:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pschenker.ch;
        s=20220412; t=1653300771;
        bh=0MHfiqd0p/6ZwSxqCqDviG7wbBM1Ay/BhTKsKLAU3Yw=;
        h=From:To:Cc:Subject:Date:From;
        b=ookfamOYYS19VZ/w/WCto5kU90RrlG0PG3/42suIuUMqQkGHL9YmPOBPvWfTvRTBX
         O//Vnp7oe8CzmmLFjV5sQE587GrGrDA+w97lWOlutKzWWXIxxIy7Ns/emI3uXCwqWH
         7OnV7hpfTt2uix6ZUez3769A/trFYP4sGU55PvSU=
From:   Philippe Schenker <dev@pschenker.ch>
To:     gregkh@linuxfoundation.org
Cc:     abel.vesa@nxp.com, francesco.dolcini@toradex.com, peng.fan@nxp.com,
        philippe.schenker@toradex.com, stable@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4] ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk
Date:   Mon, 23 May 2022 12:12:27 +0200
Message-Id: <20220523101227.194594-1-dev@pschenker.ch>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@nxp.com>

commit 4cb7df64c732b2b9918424095c11660c2a8c4a33 upstream.

The audio_mclk_root_clk was added as a gate with the CCGR121 (0x4790),
but according to the reference manual, there is no such gate. Moreover,
the consumer driver of the mentioned clock might gate it and leave
the ECSPI2 (the true owner of that gate) hanging. So lets use the
audio_mclk_post_div, which is the parent.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
[ps: backport to 5.4]
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
---
 arch/arm/boot/dts/imx7-colibri.dtsi     | 4 ++--
 arch/arm/boot/dts/imx7-mba7.dtsi        | 2 +-
 arch/arm/boot/dts/imx7d-nitrogen7.dts   | 2 +-
 arch/arm/boot/dts/imx7d-pico-hobbit.dts | 4 ++--
 arch/arm/boot/dts/imx7d-pico-pi.dts     | 4 ++--
 arch/arm/boot/dts/imx7d-sdb.dts         | 2 +-
 arch/arm/boot/dts/imx7s-warp.dts        | 4 ++--
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-colibri.dtsi b/arch/arm/boot/dts/imx7-colibri.dtsi
index 8bba03de51ad..1e61e3862106 100644
--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -77,7 +77,7 @@
 
 		dailink_master: simple-audio-card,codec {
 			sound-dai = <&codec>;
-			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+			clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		};
 	};
 };
@@ -152,7 +152,7 @@
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
index 6b4acea1ef79..ecfa179ccab1 100644
--- a/arch/arm/boot/dts/imx7d-nitrogen7.dts
+++ b/arch/arm/boot/dts/imx7d-nitrogen7.dts
@@ -284,7 +284,7 @@
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
index 869efbc4af42..a97cda17e484 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -356,7 +356,7 @@
 	codec: wm8960@1a {
 		compatible = "wlf,wm8960";
 		reg = <0x1a>;
-		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_CLK>;
+		clocks = <&clks IMX7D_AUDIO_MCLK_ROOT_DIV>;
 		clock-names = "mclk";
 		wlf,shared-lrclk;
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
2.36.1

