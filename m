Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094F1679A1A
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbjAXNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbjAXNoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E0C4672D;
        Tue, 24 Jan 2023 05:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00A38B811DA;
        Tue, 24 Jan 2023 13:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDF9C433D2;
        Tue, 24 Jan 2023 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567789;
        bh=RGlr1LkGioBLIozP1bfdUdUeK4FQ6SN15MftzeI9kik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1QSxUgfdB4li9GKUH5tuEBC82LAsb4xddWD9+5D3WePFUYcCAc+mqzubPnvpLWja
         GF6rpDzc+VNqN6uVf76vnlfh2M+cvc41LpGGVSR911rqoQRXjn2JZD5kBqovYyEyMa
         OPVvVWwd7rDuKWTABG3CNwav4TGYoFVCQc2aYeY+JXN3QKjc/B3Z5oDxkZpgGz56jE
         rnoXzbX7l6c2M+WMz5lglgjcmkc5laZE5iXq9X/Zb/XrTXhIYCh3f7TUh7CKyZb7Sd
         WLeUlhEwt8loDWxBO6Q/s+23vHzzuoxt8mXrrGnRUU2+YelzpifHsjYPaXujMscwyd
         CfOpxgjU8Attw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, leoyang.li@nxp.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        eagle.zhou@nxp.com, ming.qian@nxp.com, shijie.qin@nxp.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/14] arm64: dts: freescale: Fix pca954x i2c-mux node names
Date:   Tue, 24 Jan 2023 08:42:46 -0500
Message-Id: <20230124134257.637523-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134257.637523-1-sashal@kernel.org>
References: <20230124134257.637523-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b025b4f5c288e29bbea421613a5b4eacf9261fbb ]

"make dtbs_check":

    arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dtb: pca9547@77: $nodename:0: 'pca9547@77' does not match '^(i2c-?)?mux'
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dtb: pca9547@77: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'i2c@4' were unexpected)
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    ...

Fix this by renaming PCA954x nodes to "i2c-mux", to match the I2C bus
multiplexer/switch DT bindings and the Generic Names Recommendation in
the Devicetree Specification.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts    | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts  | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi   | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi   | 2 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi  | 2 +-
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts    | 4 ++--
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts        | 2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
index e22c5e77fecd..9615f3b9ee60 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
@@ -110,7 +110,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
index fea167d222cf..14856bc79b22 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
@@ -70,7 +70,7 @@ fpga: board-control@2,0 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
index eec62c63dafe..9ee9928f71b4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
@@ -76,7 +76,7 @@ &duart1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
index 41d8b15f25a5..aa52ff73ff9e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
@@ -53,7 +53,7 @@ flash@2 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index 1bfbce69cc8b..ee8e932628d1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -136,7 +136,7 @@ mdio2_aquantia_phy: ethernet-phy@0 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
index d3f03dcbb8c3..a9c6682a3955 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
@@ -245,7 +245,7 @@ rx8035: rtc@32 {
 &i2c3 {
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
index 10d2fe091965..8d96d18c3697 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
@@ -44,7 +44,7 @@ cpld@3,0 {
 
 &i2c0 {
 	status = "okay";
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
index 4b71c4fcb35f..787e408da002 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
@@ -44,7 +44,7 @@ cpld@3,0 {
 
 &i2c0 {
 	status = "okay";
-	pca9547@75 {
+	i2c-mux@75 {
 		compatible = "nxp,pca9547";
 		reg = <0x75>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
index afb455210bd0..d32a52ab00a4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
@@ -54,7 +54,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
index 74c09891600f..6357078185ed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
@@ -214,7 +214,7 @@ &i2c3 {
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
index f70fb32b96b0..cf14ab5f7404 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
@@ -133,7 +133,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_i2c1_pca9546>;
@@ -216,7 +216,7 @@ &i2c4 {
 	pinctrl-0 = <&pinctrl_i2c4>;
 	status = "okay";
 
-	pca9546: i2cmux@70 {
+	pca9546: i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 863232a47004..4497763d57cc 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -61,7 +61,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_lpi2c1 &pinctrl_ioexp_rst>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9646", "nxp,pca9546";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.0

