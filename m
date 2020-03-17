Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6A1880CC
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgCQLN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgCQLN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57466205ED;
        Tue, 17 Mar 2020 11:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443607;
        bh=MhqLiY0QoUHrYeGdqaf0sjCR6NM6YcsSusNH+uq3Vq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2gkGV9rSI8GObXJwj6lZ6fIs0PXRSvtY6GFgB3bdKvGH2K38XeHo+fDDOn0x7YKX
         SkMust4JtJh62pfczPM1Rycp7wp3xmEP3n57PpVDkM232dd7uXdRsAo4JpaVud+gfx
         SxlDud82JOIXkvYlpqpyaielVuMZtF5T7xnAlHFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.5 102/151] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Date:   Tue, 17 Mar 2020 11:55:12 +0100
Message-Id: <20200317103333.707278222@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit e8d87a0b822d4b3d9a94a5da915f93aa1b674c93 upstream.

There is a ACT8600 on the CI20 board and the bindings of the
ACT8865 driver have changed without updating the CI20 device
tree. Therefore the PMU can not be probed successfully and
is running in power-on reset state.

Fix DT to match the latest act8865-regulator bindings.

Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/boot/dts/ingenic/ci20.dts |   39 ++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -4,6 +4,7 @@
 #include "jz4780.dtsi"
 #include <dt-bindings/clock/ingenic,tcu.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/regulator/active-semi,8865-regulator.h>
 
 / {
 	compatible = "img,ci20", "ingenic,jz4780";
@@ -163,63 +164,71 @@
 
 		regulators {
 			vddcore: SUDCDC1 {
-				regulator-name = "VDDCORE";
+				regulator-name = "DCDC_REG1";
 				regulator-min-microvolt = <1100000>;
 				regulator-max-microvolt = <1100000>;
 				regulator-always-on;
 			};
 			vddmem: SUDCDC2 {
-				regulator-name = "VDDMEM";
+				regulator-name = "DCDC_REG2";
 				regulator-min-microvolt = <1500000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-always-on;
 			};
 			vcc_33: SUDCDC3 {
-				regulator-name = "VCC33";
+				regulator-name = "DCDC_REG3";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
 			vcc_50: SUDCDC4 {
-				regulator-name = "VCC50";
+				regulator-name = "SUDCDC_REG4";
 				regulator-min-microvolt = <5000000>;
 				regulator-max-microvolt = <5000000>;
 				regulator-always-on;
 			};
 			vcc_25: LDO_REG5 {
-				regulator-name = "VCC25";
+				regulator-name = "LDO_REG5";
 				regulator-min-microvolt = <2500000>;
 				regulator-max-microvolt = <2500000>;
 				regulator-always-on;
 			};
 			wifi_io: LDO_REG6 {
-				regulator-name = "WIFIIO";
+				regulator-name = "LDO_REG6";
 				regulator-min-microvolt = <2500000>;
 				regulator-max-microvolt = <2500000>;
 				regulator-always-on;
 			};
 			vcc_28: LDO_REG7 {
-				regulator-name = "VCC28";
+				regulator-name = "LDO_REG7";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
 				regulator-always-on;
 			};
 			vcc_15: LDO_REG8 {
-				regulator-name = "VCC15";
+				regulator-name = "LDO_REG8";
 				regulator-min-microvolt = <1500000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-always-on;
 			};
-			vcc_18: LDO_REG9 {
-				regulator-name = "VCC18";
-				regulator-min-microvolt = <1800000>;
-				regulator-max-microvolt = <1800000>;
+			vrtc_18: LDO_REG9 {
+				regulator-name = "LDO_REG9";
+				/* Despite the datasheet stating 3.3V
+				 * for REG9 and the driver expecting that,
+				 * REG9 outputs 1.8V.
+				 * Likely the CI20 uses a proprietary
+				 * factory programmed chip variant.
+				 * Since this is a simple on/off LDO the
+				 * exact values do not matter.
+				 */
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
 			vcc_11: LDO_REG10 {
-				regulator-name = "VCC11";
-				regulator-min-microvolt = <1100000>;
-				regulator-max-microvolt = <1100000>;
+				regulator-name = "LDO_REG10";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
 			};
 		};


