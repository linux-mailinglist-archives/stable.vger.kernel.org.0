Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBA0531CEB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbiEWRj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbiEWRgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE05635C;
        Mon, 23 May 2022 10:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D405D60BD3;
        Mon, 23 May 2022 17:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC34C385AA;
        Mon, 23 May 2022 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326922;
        bh=XuJqssLHAYRSvGU8Ajeukhh8M9uJA/q0j2R7aBNCtUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thowyEjyLECiFPvPpC4ghd4FAWjZzIamHjE1ylrmCWNaCI5WQEDFDNGpmGNsOuYcc
         TsjEi9Mp5OHJukrmOjdLdkdXVEGnwukPcbtN9a9idXwUgHHpoJvPJuFsupFu6XgmrJ
         VZjonjdrDdn33aqkMLNxhCDaheoICxRDhnqIQFiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 068/158] arm64: dts: qcom: sm8250: dont enable rx/tx macro by default
Date:   Mon, 23 May 2022 19:03:45 +0200
Message-Id: <20220523165842.172033471@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 18019eb62efb68c9b365acca9c4fcb2e0d459487 ]

Enabling rxmacro and txmacro nodes by defaults makes Qualcomm RB5 to
crash and reboot while probing audio devices. Disable these device tree
nodes by default and enabled them only when necessary (for the
SM8250-MTP board).

Fixes: 24f52ef0c4bf ("arm64: dts: qcom: sm8250: Add nodes for tx and rx macros with soundwire masters")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220401185814.519653-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts | 12 ++++++++++++
 arch/arm64/boot/dts/qcom/sm8250.dtsi    |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
index fb99cc2827c7..7ab3627cc347 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
@@ -622,6 +622,10 @@ &qupv3_id_2 {
 	status = "okay";
 };
 
+&rxmacro {
+	status = "okay";
+};
+
 &slpi {
 	status = "okay";
 	firmware-name = "qcom/sm8250/slpi.mbn";
@@ -773,6 +777,8 @@ right_spkr: wsa8810-left@0,4{
 };
 
 &swr1 {
+	status = "okay";
+
 	wcd_rx: wcd9380-rx@0,4 {
 		compatible = "sdw20217010d00";
 		reg = <0 4>;
@@ -781,6 +787,8 @@ wcd_rx: wcd9380-rx@0,4 {
 };
 
 &swr2 {
+	status = "okay";
+
 	wcd_tx: wcd9380-tx@0,3 {
 		compatible = "sdw20217010d00";
 		reg = <0 3>;
@@ -819,6 +827,10 @@ config {
 	};
 };
 
+&txmacro {
+	status = "okay";
+};
+
 &uart12 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index a92230bec1dd..bd212f6c351f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2150,6 +2150,7 @@ rxmacro: rxmacro@3200000 {
 			pinctrl-0 = <&rx_swr_active>;
 			compatible = "qcom,sm8250-lpass-rx-macro";
 			reg = <0 0x3200000 0 0x1000>;
+			status = "disabled";
 
 			clocks = <&q6afecc LPASS_CLK_ID_TX_CORE_MCLK LPASS_CLK_ATTRIBUTE_COUPLE_NO>,
 				<&q6afecc LPASS_CLK_ID_TX_CORE_NPL_MCLK  LPASS_CLK_ATTRIBUTE_COUPLE_NO>,
@@ -2168,6 +2169,7 @@ rxmacro: rxmacro@3200000 {
 		swr1: soundwire-controller@3210000 {
 			reg = <0 0x3210000 0 0x2000>;
 			compatible = "qcom,soundwire-v1.5.1";
+			status = "disabled";
 			interrupts = <GIC_SPI 298 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&rxmacro>;
 			clock-names = "iface";
@@ -2195,6 +2197,7 @@ txmacro: txmacro@3220000 {
 			pinctrl-0 = <&tx_swr_active>;
 			compatible = "qcom,sm8250-lpass-tx-macro";
 			reg = <0 0x3220000 0 0x1000>;
+			status = "disabled";
 
 			clocks = <&q6afecc LPASS_CLK_ID_TX_CORE_MCLK LPASS_CLK_ATTRIBUTE_COUPLE_NO>,
 				 <&q6afecc LPASS_CLK_ID_TX_CORE_NPL_MCLK  LPASS_CLK_ATTRIBUTE_COUPLE_NO>,
@@ -2218,6 +2221,7 @@ swr2: soundwire-controller@3230000 {
 			compatible = "qcom,soundwire-v1.5.1";
 			interrupts-extended = <&intc GIC_SPI 297 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "core";
+			status = "disabled";
 
 			clocks = <&txmacro>;
 			clock-names = "iface";
-- 
2.35.1



