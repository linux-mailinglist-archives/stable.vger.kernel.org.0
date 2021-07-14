Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F793C8F87
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbhGNTwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240004AbhGNTt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5318961421;
        Wed, 14 Jul 2021 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291882;
        bh=aj3HxPOJKM4Ei30vxcMcaN/Vk5UphhfB5L2vh7AnYhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4wKT/Vy8XTbfQvJBEpJILGs8BJbmmAy8dnVG0Of9bWKUN1BjqDGM41xfzuqpRCQw
         ixNiHYagAQtMsbkhzOBHhVzrDYhXJCH+kAE82XQ1jmfeW1wmcMgoHf43RkdhQUPPaq
         MNyKOkAZPcaFzvLFxm3NHYF1kC/t33sPdPmBw6t3zT/u5BAWgFpp7jRf7JpE1Ac1zw
         uV/c5rDaJUObwaj3wziSGguGEckyr95WCP2XN+LHucbxLWrJrwef7IDJwns8ldQR5C
         t4TrSuSzduIXtfIHyB+nEajz6A24pShyrLmy79hBjdPrM2yvpfAmiQ8sP2OX/7qE7d
         d8braLjWeyPHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 65/88] ARM: dts: stm32: fix stpmic node for stm32mp1 boards
Date:   Wed, 14 Jul 2021 15:42:40 -0400
Message-Id: <20210714194303.54028-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit 4bf4abe19089245b7b12f35e5cafb5477b3e2c48 ]

On some STM32 MP15 boards, stpmic node is not correct which generates
warnings running "make dtbs_check W=1" command. Issues are:

-"regulator-active-discharge" is not a boolean but an uint32.
-"regulator-over-current-protection" is not a valid entry for vref_ddr.
-LDO4 has a fixed voltage (3v3) so min/max entries are not allowed.

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157a-stinger96.dtsi   | 7 ++-----
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi | 5 +----
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi   | 5 +----
 arch/arm/boot/dts/stm32mp15xx-osd32.dtsi       | 7 ++-----
 4 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157a-stinger96.dtsi b/arch/arm/boot/dts/stm32mp157a-stinger96.dtsi
index 58275bcf9e26..4dd138d691c7 100644
--- a/arch/arm/boot/dts/stm32mp157a-stinger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp157a-stinger96.dtsi
@@ -184,8 +184,6 @@ vtt_ddr: ldo3 {
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -208,7 +206,6 @@ v1v8: ldo6 {
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			bst_out: boost {
@@ -219,13 +216,13 @@ bst_out: boost {
 			vbus_otg: pwr_sw1 {
 				regulator-name = "vbus_otg";
 				interrupts = <IT_OCP_OTG 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			};
 
 			vbus_sw: pwr_sw2 {
 				regulator-name = "vbus_sw";
 				interrupts = <IT_OCP_SWOUT 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
index b5601d270c8f..2d9461006810 100644
--- a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
@@ -173,8 +173,6 @@ vtt_ddr: ldo3 {
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -197,7 +195,6 @@ v1v2_hdmi: ldo6 {
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			 bst_out: boost {
@@ -213,7 +210,7 @@ vbus_otg: pwr_sw1 {
 			 vbus_sw: pwr_sw2 {
 				regulator-name = "vbus_sw";
 				interrupts = <IT_OCP_SWOUT 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			 };
 		};
 
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index f496bbfa0be6..998ea30ae024 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -226,8 +226,6 @@ vtt_ddr: ldo3 {
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -249,7 +247,6 @@ v1v8: ldo6 {
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			bst_out: boost {
@@ -265,7 +262,7 @@ vbus_otg: pwr_sw1 {
 			vbus_sw: pwr_sw2 {
 				regulator-name = "vbus_sw";
 				interrupts = <IT_OCP_SWOUT 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/stm32mp15xx-osd32.dtsi b/arch/arm/boot/dts/stm32mp15xx-osd32.dtsi
index 713485a95795..6706d8311a66 100644
--- a/arch/arm/boot/dts/stm32mp15xx-osd32.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-osd32.dtsi
@@ -146,8 +146,6 @@ vtt_ddr: ldo3 {
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -171,7 +169,6 @@ v1v2_hdmi: ldo6 {
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			bst_out: boost {
@@ -182,13 +179,13 @@ bst_out: boost {
 			vbus_otg: pwr_sw1 {
 				regulator-name = "vbus_otg";
 				interrupts = <IT_OCP_OTG 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			};
 
 			vbus_sw: pwr_sw2 {
 				regulator-name = "vbus_sw";
 				interrupts = <IT_OCP_SWOUT 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			};
 		};
 
-- 
2.30.2

