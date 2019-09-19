Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF7B8751
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405361AbfISWJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393524AbfISWJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0A6B218AF;
        Thu, 19 Sep 2019 22:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930950;
        bh=HG04MnMtyHZXAlO8F+WuIQp+1U7sG5+8U7kCHEbHDaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaMqPJCLPTVk7hH9NpA2sEVwHdMBoU8qJXH7K3wSaI9iGLoryZiypCSyGkqX5TbwE
         thKwCdmXSzW7BKpyFssL/APlSuXsP4ItmQ/jJRkuXrft2sv8P2sHtPj6X4VUncDpZl
         fGh4lgaLBFHniJ6ht3ReRGQZ9gvhBgqvvuGNdX50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Lechner <david@lechnology.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 042/124] ARM: dts: Fix incomplete dts data for am3 and am4 mmc
Date:   Fri, 20 Sep 2019 00:02:10 +0200
Message-Id: <20190919214820.535413518@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 5b63fb90adb95a178ad403e1703f59bf1ff2c16b ]

Commit 4e27f752ab8c ("ARM: OMAP2+: Drop mmc platform data for am330x and
am43xx") dropped legacy mmc platform data for am3 and am4, but missed the
fact that we never updated the dts files for mmc3 that is directly on l3
interconnect instead of l4 interconnect. This leads to a situation with
no legacy platform data and incomplete dts data.

Let's update the mmc instances on l3 interconnect to probe properly with
ti-sysc interconnect target module driver to make mmc3 work again. Let's
still keep legacy "ti,hwmods" property around for v5.2 kernel and only
drop it later on.

Note that there is no need to use property status = "disabled" for mmc3.
The default for dts is enabled, and runtime PM will idle unused instances
just fine.

Fixes: 4e27f752ab8c ("ARM: OMAP2+: Drop mmc platform data for am330x and am43xx")
Reported-by: David Lechner <david@lechnology.com>
Tested-by: David Lechner <david@lechnology.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 32 ++++++++++++++++++++++++++------
 arch/arm/boot/dts/am4372.dtsi | 32 ++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index e5c2f71a7c77d..fb6b8aa12cc56 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -234,13 +234,33 @@
 			interrupt-names = "edma3_tcerrint";
 		};
 
-		mmc3: mmc@47810000 {
-			compatible = "ti,omap4-hsmmc";
+		target-module@47810000 {
+			compatible = "ti,sysc-omap2", "ti,sysc";
 			ti,hwmods = "mmc3";
-			ti,needs-special-reset;
-			interrupts = <29>;
-			reg = <0x47810000 0x1000>;
-			status = "disabled";
+			reg = <0x478102fc 0x4>,
+			      <0x47810110 0x4>,
+			      <0x47810114 0x4>;
+			reg-names = "rev", "sysc", "syss";
+			ti,sysc-mask = <(SYSC_OMAP2_CLOCKACTIVITY |
+					 SYSC_OMAP2_ENAWAKEUP |
+					 SYSC_OMAP2_SOFTRESET |
+					 SYSC_OMAP2_AUTOIDLE)>;
+			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
+					<SYSC_IDLE_NO>,
+					<SYSC_IDLE_SMART>;
+			ti,syss-mask = <1>;
+			clocks = <&l3s_clkctrl AM3_L3S_MMC3_CLKCTRL 0>;
+			clock-names = "fck";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x47810000 0x1000>;
+
+			mmc3: mmc@0 {
+				compatible = "ti,omap4-hsmmc";
+				ti,needs-special-reset;
+				interrupts = <29>;
+				reg = <0x0 0x1000>;
+			};
 		};
 
 		usb: usb@47400000 {
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 55aff4db9c7c2..848e2a8884e2c 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -228,13 +228,33 @@
 			interrupt-names = "edma3_tcerrint";
 		};
 
-		mmc3: mmc@47810000 {
-			compatible = "ti,omap4-hsmmc";
-			reg = <0x47810000 0x1000>;
+		target-module@47810000 {
+			compatible = "ti,sysc-omap2", "ti,sysc";
 			ti,hwmods = "mmc3";
-			ti,needs-special-reset;
-			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
-			status = "disabled";
+			reg = <0x478102fc 0x4>,
+			      <0x47810110 0x4>,
+			      <0x47810114 0x4>;
+			reg-names = "rev", "sysc", "syss";
+			ti,sysc-mask = <(SYSC_OMAP2_CLOCKACTIVITY |
+					 SYSC_OMAP2_ENAWAKEUP |
+					 SYSC_OMAP2_SOFTRESET |
+					 SYSC_OMAP2_AUTOIDLE)>;
+			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
+					<SYSC_IDLE_NO>,
+					<SYSC_IDLE_SMART>;
+			ti,syss-mask = <1>;
+			clocks = <&l3s_clkctrl AM4_L3S_MMC3_CLKCTRL 0>;
+			clock-names = "fck";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x0 0x47810000 0x1000>;
+
+			mmc3: mmc@0 {
+				compatible = "ti,omap4-hsmmc";
+				ti,needs-special-reset;
+				interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
+				reg = <0x0 0x1000>;
+			};
 		};
 
 		sham: sham@53100000 {
-- 
2.20.1



