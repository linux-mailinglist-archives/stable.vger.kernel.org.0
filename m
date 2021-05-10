Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60D5378773
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhEJLPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236402AbhEJLIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA5461962;
        Mon, 10 May 2021 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644454;
        bh=JABW8bHj77nAZdL1EpbuBYuo87vndIsCkb1TU4sIQfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoLW3DHTCST1gT8sPchtO5IlXF36QE/8JwWh6CGUHJS15kz99dE05JcaXnnCSVf5G
         1ccpyzUAFnjZQlPgpboZcFVmCLpCirpmyVHBF8JG1B/Je5+JuM5wESthuUP2TrvNjJ
         JDoT/FqrWTDrnSbcYbFYcMRIA5L4Qf0CG6dcDrIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 090/384] ARM: dts: ux500: Fix up TVK R3 sensors
Date:   Mon, 10 May 2021 12:17:59 +0200
Message-Id: <20210510102017.849638761@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit aeceecd40d94ed3c00bfe1cfe59dd1bfac2fc6fe ]

The TVK1281618 R3 sensors are different from the R2 board,
some incorrectness is fixed and some new sensors added, we
also rename the nodes appropriately with accelerometer@
etc.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi | 73 +++++++++++++------
 1 file changed, 50 insertions(+), 23 deletions(-)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
index cb3677f0a1cb..b580397ede83 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
@@ -8,37 +8,43 @@
 / {
 	soc {
 		i2c@80128000 {
-			/* Marked:
-			 * 129
-			 * M35
-			 * L3GD20
-			 */
-			l3gd20@6a {
-				/* Gyroscope */
-				compatible = "st,l3gd20";
-				status = "disabled";
+			accelerometer@19 {
+				compatible = "st,lsm303dlhc-accel";
 				st,drdy-int-pin = <1>;
-				drive-open-drain;
-				reg = <0x6a>; // 0x6a or 0x6b
+				reg = <0x19>;
 				vdd-supply = <&ab8500_ldo_aux1_reg>;
 				vddio-supply = <&db8500_vsmps2_reg>;
+				interrupt-parent = <&gpio2>;
+				interrupts = <18 IRQ_TYPE_EDGE_RISING>,
+					     <19 IRQ_TYPE_EDGE_RISING>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&accel_tvk_mode>;
 			};
-			/*
-			 * Marked:
-			 * 2122
-			 * C3H
-			 * DQEEE
-			 * LIS3DH?
-			 */
-			lis3dh@18 {
-				/* Accelerometer */
-				compatible = "st,lis3dh-accel";
+			magnetometer@1e {
+				compatible = "st,lsm303dlm-magn";
 				st,drdy-int-pin = <1>;
-				reg = <0x18>;
+				reg = <0x1e>;
 				vdd-supply = <&ab8500_ldo_aux1_reg>;
 				vddio-supply = <&db8500_vsmps2_reg>;
+				// This interrupt is not properly working with the driver
+				// interrupt-parent = <&gpio1>;
+				// interrupts = <0 IRQ_TYPE_EDGE_RISING>;
 				pinctrl-names = "default";
-				pinctrl-0 = <&accel_tvk_mode>;
+				pinctrl-0 = <&magn_tvk_mode>;
+			};
+			gyroscope@68 {
+				/* Gyroscope */
+				compatible = "st,l3g4200d-gyro";
+				reg = <0x68>;
+				vdd-supply = <&ab8500_ldo_aux1_reg>;
+				vddio-supply = <&db8500_vsmps2_reg>;
+			};
+			pressure@5c {
+				/* Barometer/pressure sensor */
+				compatible = "st,lps001wp-press";
+				reg = <0x5c>;
+				vdd-supply = <&ab8500_ldo_aux1_reg>;
+				vddio-supply = <&db8500_vsmps2_reg>;
 			};
 		};
 
@@ -54,5 +60,26 @@
 				};
 			};
 		};
+
+		pinctrl {
+			accelerometer {
+				accel_tvk_mode: accel_tvk {
+					/* Accelerometer interrupt lines 1 & 2 */
+					tvk_cfg {
+						pins = "GPIO82_C1", "GPIO83_D3";
+						ste,config = <&gpio_in_pd>;
+					};
+				};
+			};
+			magnetometer {
+				magn_tvk_mode: magn_tvk {
+					/* GPIO 32 used for DRDY, pull this down */
+					tvk_cfg {
+						pins = "GPIO32_V2";
+						ste,config = <&gpio_in_pd>;
+					};
+				};
+			};
+		};
 	};
 };
-- 
2.30.2



