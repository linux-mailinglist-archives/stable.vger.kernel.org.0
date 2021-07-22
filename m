Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDA63D287D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhGVP5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232893AbhGVP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F63D613B2;
        Thu, 22 Jul 2021 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971871;
        bh=FwvTyc/eQRkYOB2QF2HMg+J5mZchQtZLRVt4TevWwUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDjM3ccrKmRF2Fz+eYPAHD8OVrZ5e0IUfWdBnb+a43kx05Og0bbGVOmYhMWNi/aHi
         g69mWqbkv19MZdAB8lXEDp8/pdHvzbbbEdOQm4bC011kRmaM4AYfR+cJ/SRtNbHy0E
         Qt1YOJTdDkU+y0nwrRTgJVb/HSvoD2uwF4Jj46Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/125] ARM: dts: stm32: fix stpmic node for stm32mp1 boards
Date:   Thu, 22 Jul 2021 18:30:49 +0200
Message-Id: <20210722155626.627848103@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -184,8 +184,6 @@
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -208,7 +206,6 @@
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			bst_out: boost {
@@ -219,13 +216,13 @@
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
@@ -173,8 +173,6 @@
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -197,7 +195,6 @@
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			 bst_out: boost {
@@ -213,7 +210,7 @@
 			 vbus_sw: pwr_sw2 {
 				regulator-name = "vbus_sw";
 				interrupts = <IT_OCP_SWOUT 0>;
-				regulator-active-discharge;
+				regulator-active-discharge = <1>;
 			 };
 		};
 
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index c43c5c93f8eb..8221bf69fefe 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -234,8 +234,6 @@
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -257,7 +255,6 @@
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			bst_out: boost {
@@ -273,7 +270,7 @@
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
@@ -146,8 +146,6 @@
 
 			vdd_usb: ldo4 {
 				regulator-name = "vdd_usb";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				interrupts = <IT_CURLIM_LDO4 0>;
 			};
 
@@ -171,7 +169,6 @@
 			vref_ddr: vref_ddr {
 				regulator-name = "vref_ddr";
 				regulator-always-on;
-				regulator-over-current-protection;
 			};
 
 			bst_out: boost {
@@ -182,13 +179,13 @@
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



