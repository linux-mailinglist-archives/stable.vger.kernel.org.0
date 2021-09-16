Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D1240E6AE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348803AbhIPRYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346893AbhIPRV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4278561BB3;
        Thu, 16 Sep 2021 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810561;
        bh=Fl89BLpZqkI7d42dfLouRxVDKhNQxznxdmuRukWnMdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed33caLHRAH7lV2DfN07B39f0Z9V/ezOkT6x+h4L0vQYonDENHklxilMVv7Cnsl9S
         AsHxRikEMFjv2HoXrQ0YI8fuDrJXwRfpq31B5wB1weArsP1lsF0R88w1J2R0FMKZei
         +nDyOV7qx34mhTTmdtYHjtIHsjwwM0P71vvrZGtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 186/432] arm64: dts: qcom: Fix usb entries for SA8155p adp board
Date:   Thu, 16 Sep 2021 17:58:55 +0200
Message-Id: <20210916155817.045010293@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

[ Upstream commit 12dd4ebda47abd5e3907da386b6fe1d8181ad179 ]

SA8155p adp board has two USB A-type receptacles called
USB-portB and USB-portC respectively.

While USB-portB is a USB High-Speed connector/interface, the
USB-portC one is a USB 3.1 Super-Speed connector/interface.

Also the USB-portB is used as the USB emergency
download port (for image download purposes).

Enable both the ports on the board in USB Host mode (since all
the USB interfaces are brought out to USB Type A
connectors).

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Link: https://lore.kernel.org/r/20210627114616.717101-4-bhupesh.sharma@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts | 60 ++++++++++++++++++++----
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
index 0da7a3b8d1bf..5ae2ddc65f7e 100644
--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -307,10 +307,6 @@ &qupv3_id_1 {
 	status = "okay";
 };
 
-&tlmm {
-	gpio-reserved-ranges = <0 4>;
-};
-
 &uart2 {
 	status = "okay";
 };
@@ -337,6 +333,16 @@ &ufs_mem_phy {
 	vdda-pll-max-microamp = <18300>;
 };
 
+&usb_1 {
+	status = "okay";
+};
+
+&usb_1_dwc3 {
+	dr_mode = "host";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&usb2phy_ac_en1_default>;
+};
 
 &usb_1_hsphy {
 	status = "okay";
@@ -346,15 +352,51 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
+	status = "disabled";
+};
+
+&usb_2 {
 	status = "okay";
-	vdda-phy-supply = <&vreg_l8c_1p2>;
-	vdda-pll-supply = <&vdda_usb_ss_dp_core_1>;
 };
 
-&usb_1 {
+&usb_2_dwc3 {
+	dr_mode = "host";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&usb2phy_ac_en2_default>;
+};
+
+&usb_2_hsphy {
 	status = "okay";
+	vdda-pll-supply = <&vdd_usb_hs_core>;
+	vdda33-supply = <&vdda_usb_hs_3p1>;
+	vdda18-supply = <&vdda_usb_hs_1p8>;
 };
 
-&usb_1_dwc3 {
-	dr_mode = "peripheral";
+&usb_2_qmpphy {
+	status = "okay";
+	vdda-phy-supply = <&vreg_l8c_1p2>;
+	vdda-pll-supply = <&vdda_usb_ss_dp_core_1>;
+};
+
+&tlmm {
+	gpio-reserved-ranges = <0 4>;
+
+	usb2phy_ac_en1_default: usb2phy_ac_en1_default {
+		mux {
+			pins = "gpio113";
+			function = "usb2phy_ac";
+			bias-disable;
+			drive-strength = <2>;
+		};
+	};
+
+	usb2phy_ac_en2_default: usb2phy_ac_en2_default {
+		mux {
+			pins = "gpio123";
+			function = "usb2phy_ac";
+			bias-disable;
+			drive-strength = <2>;
+		};
+	};
 };
-- 
2.30.2



