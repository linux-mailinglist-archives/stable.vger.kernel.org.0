Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AEA4057DC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245161AbhIINmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356713AbhIIMzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2892F63256;
        Thu,  9 Sep 2021 11:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188697;
        bh=m3yJofFf0wv0x/kEmyC+s9DoQmK+92xMzaXuscuJTkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFiqzgFONcPlMoqiiP8qrS7x3GRxy4TVsS7bhyrv+1twEWij5h1dpZVBAJwz8UBOW
         TebgeJnKo5I5Dol8wsIhkXNaDE7cMTQoCmokeDrOWbefBrEnLVEt+vAnKijihQWXpA
         EAgSm/VoS3Xr9u1HWg2gU4ygAfcKUnQgwnC4eBW/JLA1x94zjCtLiNv+TcTsUmbRPz
         5twWDvhf/GpsVQPVio89HBzk2eamgB86vO/2ConBsFwyuAwML5+0zTutcfDzUmnCm3
         F4V1YFfxgJdwXp+vSeCziVXFhUKeEDkBa+qSGSnlzIwsZp7h64OqRiXicWFDKDP1Uz
         bWzdewnm0aCpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 41/74] ARM: dts: imx53-ppd: Fix ACHC entry
Date:   Thu,  9 Sep 2021 07:56:53 -0400
Message-Id: <20210909115726.149004-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit cd7cd5b716d594e27a933c12f026d4f2426d7bf4 ]

PPD has only one ACHC device, which effectively is a Kinetis
microcontroller. It has one SPI interface used for normal
communication. Additionally it's possible to flash the device
firmware using NXP's EzPort protocol by correctly driving a
second chip select pin and the device reset pin.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20210802172309.164365-3-sebastian.reichel@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-ppd.dts | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index f202396e3f2a..f346673d34ea 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -70,6 +70,12 @@ cko2_11M: sgtl-clock-cko2 {
 		clock-frequency = <11289600>;
 	};
 
+	achc_24M: achc-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24000000>;
+	};
+
 	sgtlsound: sound {
 		compatible = "fsl,imx53-cpuvo-sgtl5000",
 			     "fsl,imx-audio-sgtl5000";
@@ -287,16 +293,13 @@ &gpio4 11 GPIO_ACTIVE_LOW
 		    &gpio4 12 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
-	spidev0: spi@0 {
-		compatible = "ge,achc";
-		reg = <0>;
-		spi-max-frequency = <1000000>;
-	};
-
-	spidev1: spi@1 {
-		compatible = "ge,achc";
-		reg = <1>;
-		spi-max-frequency = <1000000>;
+	spidev0: spi@1 {
+		compatible = "ge,achc", "nxp,kinetis-k20";
+		reg = <1>, <0>;
+		vdd-supply = <&reg_3v3>;
+		vdda-supply = <&reg_3v3>;
+		clocks = <&achc_24M>;
+		reset-gpios = <&gpio3 6 GPIO_ACTIVE_LOW>;
 	};
 
 	gpioxra0: gpio@2 {
-- 
2.30.2

