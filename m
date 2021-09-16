Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104CC40E3C2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242484AbhIPQwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344811AbhIPQsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 773DB6152A;
        Thu, 16 Sep 2021 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809654;
        bh=z/4J4XbmUrKfI5L90mELf+5NEgxHoccYKRJ5V+/q0lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=po7AAqAkQ8o7FqHC08Uoee/7qsX1mkhLGEM5tquDe0dJP3tiGk6MiGABqXF+Ahe4R
         CrjyP8RG38wrKDrp+WYZi0AbQrdYvkV1x0rM6fng3srX23ibkYY1TqPnrdBGEaNa3M
         xbNuxWzabcxVWXWBERPBU4y5OXAneHFd3Tx7rNSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 233/380] arm64: dts: qcom: sdm630: Fix TLMM node and pinctrl configuration
Date:   Thu, 16 Sep 2021 17:59:50 +0200
Message-Id: <20210916155812.007133347@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 36a0d47aee6a8cfd3c6cf4274732d8ef994a25b4 ]

Previous pinctrl configuration was wrong. Fix it and clean up how
multi-pin states are described.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210728222542.54269-9-konrad.dybcio@somainline.org
[bjorn: Polished the commit message]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 212 ++++++++++++++++++---------
 1 file changed, 139 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index 5ea3884b3ccb..5b73659f2a75 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -522,14 +522,18 @@ tcsr_mutex_regs: syscon@1f40000 {
 			reg = <0x01f40000 0x20000>;
 		};
 
-		tlmm: pinctrl@3000000 {
+		tlmm: pinctrl@3100000 {
 			compatible = "qcom,sdm630-pinctrl";
-			reg = <0x03000000 0xc00000>;
+			reg = <0x03100000 0x400000>,
+				  <0x03500000 0x400000>,
+				  <0x03900000 0x400000>;
+			reg-names = "south", "center", "north";
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
-			#gpio-cells = <0x2>;
+			gpio-ranges = <&tlmm 0 0 114>;
+			#gpio-cells = <2>;
 			interrupt-controller;
-			#interrupt-cells = <0x2>;
+			#interrupt-cells = <2>;
 
 			blsp1_uart1_default: blsp1-uart1-default {
 				pins = "gpio0", "gpio1", "gpio2", "gpio3";
@@ -549,40 +553,48 @@ blsp1_uart2_default: blsp1-uart2-default {
 				bias-disable;
 			};
 
-			blsp2_uart1_tx_active: blsp2-uart1-tx-active {
-				pins = "gpio16";
-				drive-strength = <2>;
-				bias-disable;
-			};
-
-			blsp2_uart1_tx_sleep: blsp2-uart1-tx-sleep {
-				pins = "gpio16";
-				drive-strength = <2>;
-				bias-pull-up;
-			};
+			blsp2_uart1_default: blsp2-uart1-active {
+				tx-rts {
+					pins = "gpio16", "gpio19";
+					function = "blsp_uart5";
+					drive-strength = <2>;
+					bias-disable;
+				};
 
-			blsp2_uart1_rxcts_active: blsp2-uart1-rxcts-active {
-				pins = "gpio17", "gpio18";
-				drive-strength = <2>;
-				bias-disable;
-			};
+				rx {
+					/*
+					 * Avoid garbage data while BT module
+					 * is powered off or not driving signal
+					 */
+					pins = "gpio17";
+					function = "blsp_uart5";
+					drive-strength = <2>;
+					bias-pull-up;
+				};
 
-			blsp2_uart1_rxcts_sleep: blsp2-uart1-rxcts-sleep {
-				pins = "gpio17", "gpio18";
-				drive-strength = <2>;
-				bias-no-pull;
+				cts {
+					/* Match the pull of the BT module */
+					pins = "gpio18";
+					function = "blsp_uart5";
+					drive-strength = <2>;
+					bias-pull-down;
+				};
 			};
 
-			blsp2_uart1_rfr_active: blsp2-uart1-rfr-active {
-				pins = "gpio19";
-				drive-strength = <2>;
-				bias-disable;
-			};
+			blsp2_uart1_sleep: blsp2-uart1-sleep {
+				tx {
+					pins = "gpio16";
+					function = "gpio";
+					drive-strength = <2>;
+					bias-pull-up;
+				};
 
-			blsp2_uart1_rfr_sleep: blsp2-uart1-rfr-sleep {
-				pins = "gpio19";
-				drive-strength = <2>;
-				bias-no-pull;
+				rx-cts-rts {
+					pins = "gpio17", "gpio18", "gpio19";
+					function = "gpio";
+					drive-strength = <2>;
+					bias-no-pull;
+				};
 			};
 
 			i2c1_default: i2c1-default {
@@ -681,50 +693,106 @@ i2c8_sleep: i2c8-sleep {
 				bias-pull-up;
 			};
 
-			sdc1_clk_on: sdc1-clk-on {
-				pins = "sdc1_clk";
-				bias-disable;
-				drive-strength = <16>;
-			};
+			sdc1_state_on: sdc1-on {
+				clk {
+					pins = "sdc1_clk";
+					bias-disable;
+					drive-strength = <16>;
+				};
 
-			sdc1_clk_off: sdc1-clk-off {
-				pins = "sdc1_clk";
-				bias-disable;
-				drive-strength = <2>;
-			};
+				cmd {
+					pins = "sdc1_cmd";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
 
-			sdc1_cmd_on: sdc1-cmd-on {
-				pins = "sdc1_cmd";
-				bias-pull-up;
-				drive-strength = <10>;
-			};
+				data {
+					pins = "sdc1_data";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
 
-			sdc1_cmd_off: sdc1-cmd-off {
-				pins = "sdc1_cmd";
-				bias-pull-up;
-				drive-strength = <2>;
+				rclk {
+					pins = "sdc1_rclk";
+					bias-pull-down;
+				};
 			};
 
-			sdc1_data_on: sdc1-data-on {
-				pins = "sdc1_data";
-				bias-pull-up;
-				drive-strength = <8>;
-			};
+			sdc1_state_off: sdc1-off {
+				clk {
+					pins = "sdc1_clk";
+					bias-disable;
+					drive-strength = <2>;
+				};
 
-			sdc1_data_off: sdc1-data-off {
-				pins = "sdc1_data";
-				bias-pull-up;
-				drive-strength = <2>;
+				cmd {
+					pins = "sdc1_cmd";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				data {
+					pins = "sdc1_data";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				rclk {
+					pins = "sdc1_rclk";
+					bias-pull-down;
+				};
 			};
 
-			sdc1_rclk_on: sdc1-rclk-on {
-				pins = "sdc1_rclk";
-				bias-pull-down;
+			sdc2_state_on: sdc2-on {
+				clk {
+					pins = "sdc2_clk";
+					bias-disable;
+					drive-strength = <16>;
+				};
+
+				cmd {
+					pins = "sdc2_cmd";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
+
+				data {
+					pins = "sdc2_data";
+					bias-pull-up;
+					drive-strength = <10>;
+				};
+
+				sd-cd {
+					pins = "gpio54";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
 			};
 
-			sdc1_rclk_off: sdc1-rclk-off {
-				pins = "sdc1_rclk";
-				bias-pull-down;
+			sdc2_state_off: sdc2-off {
+				clk {
+					pins = "sdc2_clk";
+					bias-disable;
+					drive-strength = <2>;
+				};
+
+				cmd {
+					pins = "sdc2_cmd";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				data {
+					pins = "sdc2_data";
+					bias-pull-up;
+					drive-strength = <2>;
+				};
+
+				sd-cd {
+					pins = "gpio54";
+					bias-disable;
+					drive-strength = <2>;
+				};
 			};
 		};
 
@@ -818,8 +886,8 @@ sdhc_1: sdhci@c0c4000 {
 			clock-names = "core", "iface", "xo", "ice";
 
 			pinctrl-names = "default", "sleep";
-			pinctrl-0 = <&sdc1_clk_on &sdc1_cmd_on &sdc1_data_on &sdc1_rclk_on>;
-			pinctrl-1 = <&sdc1_clk_off &sdc1_cmd_off &sdc1_data_off &sdc1_rclk_off>;
+			pinctrl-0 = <&sdc1_state_on>;
+			pinctrl-1 = <&sdc1_state_off>;
 
 			bus-width = <8>;
 			non-removable;
@@ -964,10 +1032,8 @@ blsp2_uart1: serial@c1af000 {
 			dmas = <&blsp2_dma 0>, <&blsp2_dma 1>;
 			dma-names = "tx", "rx";
 			pinctrl-names = "default", "sleep";
-			pinctrl-0 = <&blsp2_uart1_tx_active &blsp2_uart1_rxcts_active
-				&blsp2_uart1_rfr_active>;
-			pinctrl-1 = <&blsp2_uart1_tx_sleep &blsp2_uart1_rxcts_sleep
-				&blsp2_uart1_rfr_sleep>;
+			pinctrl-0 = <&blsp2_uart1_default>;
+			pinctrl-1 = <&blsp2_uart1_sleep>;
 			status = "disabled";
 		};
 
-- 
2.30.2



