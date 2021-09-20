Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD46412296
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350976AbhITSQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376370AbhITSMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B65C96327C;
        Mon, 20 Sep 2021 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158434;
        bh=IH2bqORCcfiRGXYybGqC3vEwO/2EBO1dREiMH6gGzv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u63kA2Y+tni+DmSByjy4PTF07UV2IBW79m+/Gzx4xkxA7beD1mf6AVkBqz7NafOlv
         vbu/lUDUkWfe3VO1vNQOowSIEj3fRaSKLPKR2DfPYSJ8o6619TPgGVI4xNOFfygLtF
         cuYwB3W4QdwzkRCknnmkPmA948nbyAHNfh030XaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/260] ARM: dts: imx53-ppd: Fix ACHC entry
Date:   Mon, 20 Sep 2021 18:42:20 +0200
Message-Id: <20210920163935.270826832@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5ff9a179c83c..c80d1700e094 100644
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



