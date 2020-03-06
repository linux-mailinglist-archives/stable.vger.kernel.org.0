Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F8817C453
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 18:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCFR2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 12:28:04 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:13141 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFR2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 12:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583515681;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=EMIkL6ZMx1o3uNQOsK/AuYhMq5YPX55+evrim/F2BFk=;
        b=ADVu63vjxAIATIBaaaJII74iMFNeaKqAkJ4Q1Hmf6MtAVFBfpo6hRSnbM0pmN3jTE5
        8c1+gu3+DrwnyFcE0Q5sJ8GXRe6LGmwNYtJpx7TkCgNAexgscJK74z2EAkxCuqf6ZZUQ
        rgPXb9Hg1zFnP464kvLiR5hJ6z6UfcfIpav6HVq9iuFDkAusrOfGieKlfym/sUtGPEu1
        2w+V54yFBrX/x1HMdPRQKmyngd/0v1VzVSZxOhjJvXfmD64x6J2Q4TctXaVaAEc1sXXI
        X2BWh7DxEIDJZJF4QhhjjjcVVJdIQTExNhk08qf8jAdZ+E1SR4SJcjgtjJnT4T9+m9I4
        2T5g==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6GQjzrz4="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw26HRxZtN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 6 Mar 2020 18:27:59 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH v6] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Date:   Fri,  6 Mar 2020 18:27:58 +0100
Message-Id: <cccce8a3866e54859d04b3f67c7414c3efb1eedd.1583515678.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a ACT8600 on the CI20 board and the bindings of the
ACT8865 driver have changed without updating the CI20 device
tree. Therefore the PMU can not be probed successfully and
is running in power-on reset state.

Fix DT to match the latest act8865-regulator bindings.

Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/mips/boot/dts/ingenic/ci20.dts | 39 ++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 37b93166bf22..8b5fb635c66f 100644
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
-- 
2.23.0

