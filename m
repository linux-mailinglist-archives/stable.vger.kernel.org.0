Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2806173F1C
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 19:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgB1SDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 13:03:20 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:33451 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgB1SDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 13:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582912978;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=vBXvmFWAkccWf37eeFfgn5yiVRBwwJsqAAKcSSUBpbk=;
        b=QK4OOiMfhKzap8ynfVpqVr78YLxVQyvi0QLKE/eZv3UvinJHvLGVPKRcZI6S3jxm2W
        WY80Ja0nzVDnNWslccpvl3jBUsmCO/m8f3CRlLRL81jribqWXMEsEfXl1NtmY/KRMIOh
        P04Cd5v5/x7DdxcgiRPLlGMjnrvFmbqT74een+T6hRF+XdwrNYMJ7KvNRl+TsLPWqlIC
        RaCDwjImVZsNPaIhN3ad/Sfv2SA39squdnq7x/+DwTn9ki8rb7kJNP8hvkxNT/5zlg4h
        YH/eJFdsmpwl7gn3L1A+1fkezRyxX8HYMti6uQD6kE1MUrfw9A1Abe25sdnuK1l4NrT3
        Zkqg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6G1+ULkA="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw1SI2t2JL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 28 Feb 2020 19:02:55 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Boddie <paul@boddie.org.uk>,
        Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH v4 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Date:   Fri, 28 Feb 2020 19:02:50 +0100
Message-Id: <af70bb34d95746cdbc468e91e531c4576a1855a6.1582912972.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1582912972.git.hns@goldelico.com>
References: <cover.1582912972.git.hns@goldelico.com>
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
---
 arch/mips/boot/dts/ingenic/ci20.dts | 48 ++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 59c104289ece..44741e927d2b 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -4,6 +4,8 @@
 #include "jz4780.dtsi"
 #include <dt-bindings/clock/ingenic,tcu.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/regulator/active-semi,8865-regulator.h>
 
 / {
 	compatible = "img,ci20", "ingenic,jz4780";
@@ -166,65 +168,81 @@
 		reg = <0x5a>;
 		status = "okay";
 
+/*
+Optional input supply properties:
+- for act8600:
+  - vp1-supply: The input supply for DCDC_REG1
+  - vp2-supply: The input supply for DCDC_REG2
+  - vp3-supply: The input supply for DCDC_REG3
+  - inl-supply: The input supply for LDO_REG5, LDO_REG6, LDO_REG7 and LDO_REG8
+  SUDCDC_REG4, LDO_REG9 and LDO_REG10 do not have separate supplies.
+*/
+
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
+				/* Despite the datasheet stating 3.3V for REG9 and
+				   driver expecting that, REG9 outputs 1.8V.
+				   Likely the CI20 uses a chip variant.
+				   Since it is a simple on/off LDO the exact values
+				   do not matter.
+				*/
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

