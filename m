Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5026AE810
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCGRMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCGRMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15EA16AFB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F876150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B1DC433D2;
        Tue,  7 Mar 2023 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208820;
        bh=aj/sAXKFQTIUwIpn5FAXll2+DdjymBaHdhQIeOBPHMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SClbSbDt4QvtPCSE2tiLjgUE/iodPkp7g08ACZ4ouDeNuGssljn8frEJ0LFL59wpw
         2RVNRhYl3yLEv/FlM9nAVkB952w3y7GSIEI9Gzv6amZTWkDVc7Qhs3OEWxJdofpSwh
         J0oTXc2ZSw7+yIuUs2klSbzJvqEnLOrWUGP3H/Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0020/1001] arm64: dts: qcom: sm8350-sagami: Add GPIO line names for PMIC GPIOs
Date:   Tue,  7 Mar 2023 17:46:32 +0100
Message-Id: <20230307170023.024800483@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7c679f2a2af84edbec0c28171af8c42c6da9af14 ]

Sony ever so graciously provides GPIO line names in their downstream
kernel (though sometimes they are not 100% accurate and you can judge
that by simply looking at them and with what drivers they are used).

Add these to the PDX213&214 DTSIs to better document the hardware.

Diff between 223 and 224:

pm8350b
< 	gpio-line-names = "NC", /* GPIO_1 */
> 	gpio-line-names = "CAM_PWR_A_CS", /* GPIO_1 */
< 			  "NC",
> 			  "CAM_PWR_LD_EN",

pm8350c
< 			  "NC",
> 			  "WLC_TXPWR_EN",

Which is due to different camera power wiring on 213 and lack of an
additional SLG51000 PMIC on 214.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221118152028.59312-3-konrad.dybcio@linaro.org
Stable-dep-of: dcc7cd5c46ca ("arm64: dts: qcom: sm8350-sagami: Rectify GPIO keys")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/sm8350-sony-xperia-sagami-pdx214.dts | 23 +++++++++++++++++++
 .../qcom/sm8350-sony-xperia-sagami-pdx215.dts | 21 +++++++++++++++++
 .../dts/qcom/sm8350-sony-xperia-sagami.dtsi   | 20 ++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx214.dts b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx214.dts
index cc650508dc2d6..e6824c8c2774d 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx214.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx214.dts
@@ -17,3 +17,26 @@ &framebuffer {
 	height = <2520>;
 	stride = <(1080 * 4)>;
 };
+
+&pm8350b_gpios {
+	gpio-line-names = "NC", /* GPIO_1 */
+			  "NC",
+			  "NC",
+			  "NC",
+			  "SNAPSHOT_N",
+			  "NC",
+			  "NC",
+			  "FOCUS_N";
+};
+
+&pm8350c_gpios {
+	gpio-line-names = "FL_STROBE_TRIG_WIDE", /* GPIO_1 */
+			  "FL_STROBE_TRIG_TELE",
+			  "NC",
+			  "NC",
+			  "NC",
+			  "RGBC_IR_PWR_EN",
+			  "NC",
+			  "NC",
+			  "WIDEC_PWR_EN";
+};
diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts
index d4afaa393c9a9..c6f402c3ef352 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts
@@ -68,6 +68,15 @@ slg51000_a_ldo7: ldo7 {
 };
 
 &pm8350b_gpios {
+	gpio-line-names = "CAM_PWR_A_CS", /* GPIO_1 */
+			  "NC",
+			  "NC",
+			  "NC",
+			  "SNAPSHOT_N",
+			  "CAM_PWR_LD_EN",
+			  "NC",
+			  "FOCUS_N";
+
 	cam_pwr_a_cs: cam-pwr-a-cs-state {
 		pins = "gpio1";
 		function = "normal";
@@ -78,6 +87,18 @@ cam_pwr_a_cs: cam-pwr-a-cs-state {
 	};
 };
 
+&pm8350c_gpios {
+	gpio-line-names = "FL_STROBE_TRIG_WIDE", /* GPIO_1 */
+			  "FL_STROBE_TRIG_TELE",
+			  "NC",
+			  "WLC_TXPWR_EN",
+			  "NC",
+			  "RGBC_IR_PWR_EN",
+			  "NC",
+			  "NC",
+			  "WIDEC_PWR_EN";
+};
+
 &tlmm {
 	gpio-line-names = "APPS_I2C_0_SDA", /* GPIO_0 */
 			  "APPS_I2C_0_SCL",
diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
index a10306d82a3a1..41c4101ec8f08 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
@@ -534,6 +534,26 @@ &mpss {
 	firmware-name = "qcom/sm8350/Sony/sagami/modem.mbn";
 };
 
+&pm8350_gpios {
+	gpio-line-names = "ASSIGN1_THERM", /* GPIO_1 */
+			  "LCD_ID",
+			  "SDR_MMW_THERM",
+			  "RF_ID",
+			  "NC",
+			  "FP_LDO_EN",
+			  "SP_ARI_PWR_ALARM",
+			  "NC",
+			  "G_ASSIST_N",
+			  "PM8350_OPTION"; /* GPIO_10 */
+};
+
+&pmk8350_gpios {
+	gpio-line-names = "NC", /* GPIO_1 */
+			  "NC",
+			  "VOL_DOWN_N",
+			  "PMK8350_OPTION";
+};
+
 &pmk8350_rtc {
 	status = "okay";
 };
-- 
2.39.2



