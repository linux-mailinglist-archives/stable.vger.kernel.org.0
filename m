Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE12E4110
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439219AbgL1ONF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439259AbgL1OLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1432207B6;
        Mon, 28 Dec 2020 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164622;
        bh=w+JspG33Y9P17KIQ2DqBwKdz0hex3HC8iOGwrKsGLA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpaVTNyFd/tnmAs2on/cL2+renxNpYMbATdhXF4LmKloH6H4Z1jCY5YlCIEkpcdv8
         viRrzy+2MKrKjwzkkXvUNRrFbXHVSZH0K+xgSydpzkAqdSPGdtK7CFt9lxpOV1x9cL
         34uFXRdXxRk5vcz7MW5H44A/PJYqOw7m2iVAH728=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/717] arm64: dts: qcom: c630: Polish i2c-hid devices
Date:   Mon, 28 Dec 2020 13:43:56 +0100
Message-Id: <20201228125032.398166454@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index d03ca31907466..60c6ab8162e21 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -264,23 +264,28 @@
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
 
@@ -288,15 +293,15 @@
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
 
@@ -304,7 +309,7 @@
 	status = "okay";
 	clock-frequency = <400000>;
 
-	hid@5c {
+	ecsh: hid@5c {
 		compatible = "hid-over-i2c";
 		reg = <0x5c>;
 		hid-descr-addr = <0x1>;
@@ -312,7 +317,7 @@
 		interrupts-extended = <&tlmm 92 IRQ_TYPE_LEVEL_LOW>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&i2c12_hid_active>;
+		pinctrl-0 = <&i2c11_hid_active>;
 	};
 };
 
@@ -426,7 +431,7 @@
 &tlmm {
 	gpio-reserved-ranges = <0 4>, <81 4>;
 
-	i2c2_hid_active: i2c2-hid-active {
+	i2c3_hid_active: i2c2-hid-active {
 		pins = <37>;
 		function = "gpio";
 
@@ -435,7 +440,7 @@
 		drive-strength = <2>;
 	};
 
-	i2c6_hid_active: i2c6-hid-active {
+	i2c5_hid_active: i2c5-hid-active {
 		pins = <125>;
 		function = "gpio";
 
@@ -444,7 +449,7 @@
 		drive-strength = <2>;
 	};
 
-	i2c12_hid_active: i2c12-hid-active {
+	i2c11_hid_active: i2c11-hid-active {
 		pins = <92>;
 		function = "gpio";
 
-- 
2.27.0



