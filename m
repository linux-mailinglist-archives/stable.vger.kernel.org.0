Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001822E3B24
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405168AbgL1Nqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404993AbgL1NqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03D0E205CB;
        Mon, 28 Dec 2020 13:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163146;
        bh=ZMz1VaCoNoltprG8mhf06g9t/TJKHaD2DDu0AwVhxso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc62AZlwcud0hvvfKX4q7yIayYn5MW+u+3BHFRja+CFA992JUTWF1l8HbOWINQ2HR
         ZEC+t2RsrcUIFxEMgOk1m8Q3JI38pM6PjtISs0Q2hNxMpRy4347I6DlRs63+0lIUXy
         hhAC1H9Ukug0LOBcXGBzQkmkLQF3MsPUNNJXNVeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/453] arm64: dts: qcom: c630: Polish i2c-hid devices
Date:   Mon, 28 Dec 2020 13:47:03 +0100
Message-Id: <20201228124946.209170540@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 11d0e4f281565ef757479764ce7fd8d35eeb01b0 ]

The numbering of the i2c busses differs from ACPI and a number of typos
was made in the original patch. Further more the irq flags for the
various resources was not correct and i2c3 only has one of the two
client devices active in any one device.

Also label the various devices, for easier comparison with the ACPI
tables.

Tested-by: Steev Klimaszewski <steev@kali.org>
Fixes: 44acee207844 ("arm64: dts: qcom: Add Lenovo Yoga C630")
Link: https://lore.kernel.org/r/20201130165924.319708-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 31 +++++++++++--------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index ded120d3aef58..f539b3655f6b9 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -244,23 +244,28 @@
 	status = "okay";
 	clock-frequency = <400000>;
 
-	hid@15 {
+	tsel: hid@15 {
 		compatible = "hid-over-i2c";
 		reg = <0x15>;
 		hid-descr-addr = <0x1>;
 
-		interrupts-extended = <&tlmm 37 IRQ_TYPE_EDGE_RISING>;
+		interrupts-extended = <&tlmm 37 IRQ_TYPE_LEVEL_HIGH>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c3_hid_active>;
 	};
 
-	hid@2c {
+	tsc2: hid@2c {
 		compatible = "hid-over-i2c";
 		reg = <0x2c>;
 		hid-descr-addr = <0x20>;
 
-		interrupts-extended = <&tlmm 37 IRQ_TYPE_EDGE_RISING>;
+		interrupts-extended = <&tlmm 37 IRQ_TYPE_LEVEL_HIGH>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&i2c2_hid_active>;
+		pinctrl-0 = <&i2c3_hid_active>;
+
+		status = "disabled";
 	};
 };
 
@@ -268,15 +273,15 @@
 	status = "okay";
 	clock-frequency = <400000>;
 
-	hid@10 {
+	tsc1: hid@10 {
 		compatible = "hid-over-i2c";
 		reg = <0x10>;
 		hid-descr-addr = <0x1>;
 
-		interrupts-extended = <&tlmm 125 IRQ_TYPE_EDGE_FALLING>;
+		interrupts-extended = <&tlmm 125 IRQ_TYPE_LEVEL_LOW>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&i2c6_hid_active>;
+		pinctrl-0 = <&i2c5_hid_active>;
 	};
 };
 
@@ -284,7 +289,7 @@
 	status = "okay";
 	clock-frequency = <400000>;
 
-	hid@5c {
+	ecsh: hid@5c {
 		compatible = "hid-over-i2c";
 		reg = <0x5c>;
 		hid-descr-addr = <0x1>;
@@ -292,7 +297,7 @@
 		interrupts-extended = <&tlmm 92 IRQ_TYPE_LEVEL_LOW>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&i2c12_hid_active>;
+		pinctrl-0 = <&i2c11_hid_active>;
 	};
 };
 
@@ -335,7 +340,7 @@
 &tlmm {
 	gpio-reserved-ranges = <0 4>, <81 4>;
 
-	i2c2_hid_active: i2c2-hid-active {
+	i2c3_hid_active: i2c2-hid-active {
 		pins = <37>;
 		function = "gpio";
 
@@ -344,7 +349,7 @@
 		drive-strength = <2>;
 	};
 
-	i2c6_hid_active: i2c6-hid-active {
+	i2c5_hid_active: i2c5-hid-active {
 		pins = <125>;
 		function = "gpio";
 
@@ -353,7 +358,7 @@
 		drive-strength = <2>;
 	};
 
-	i2c12_hid_active: i2c12-hid-active {
+	i2c11_hid_active: i2c11-hid-active {
 		pins = <92>;
 		function = "gpio";
 
-- 
2.27.0



