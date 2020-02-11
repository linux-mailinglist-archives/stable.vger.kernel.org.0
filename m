Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C381159250
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 15:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBKOxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 09:53:49 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:50696 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbgBKOxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 09:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1581432827; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=V41n7jOHB7QPynsif3J/pnhegI5IrC8I/pI86s+EjUs=;
        b=ICHeqN1houPtwMeLwhsY2oyaC4llFZddxcnJ6etRDyLXujpFzFQLexpMGzPChWE8eqMi2c
        PvaVg5Ubu1hY3AHsQpzWbb7AL0U0lsgVRdkBinmVGk7n5W92p2V8/0BWv+loFheEiSSvjW
        B2Aal3PHKFWeN/TuTX/JxDOT5Jvj5kc=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Zhou Yanjie <zhouyanjie@wanyeetech.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: ingenic: DTS: Fix watchdog nodes
Date:   Tue, 11 Feb 2020 11:53:37 -0300
Message-Id: <20200211145337.16311-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The devicetree ABI was broken on purpose by commit 6d532143c915
("watchdog: jz4740: Use regmap provided by TCU driver"), and
commit 1d9c30745455 ("watchdog: jz4740: Use WDT clock provided
by TCU driver"). The commit message of the latter explains why the ABI
was broken.

However, the current devicetree files were not updated to the new ABI
described in Documentation/devicetree/bindings/timer/ingenic,tcu.txt,
so the watchdog driver would not probe.

Fix this problem by updating the watchdog nodes to comply with the new
ABI.

Fixes: 6d532143c915 ("watchdog: jz4740: Use regmap provided by TCU
driver")

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
---
 arch/mips/boot/dts/ingenic/jz4740.dtsi | 17 +++++++++--------
 arch/mips/boot/dts/ingenic/jz4780.dtsi | 17 +++++++++--------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/mips/boot/dts/ingenic/jz4740.dtsi b/arch/mips/boot/dts/ingenic/jz4740.dtsi
index 5accda2767be..a3301bab9231 100644
--- a/arch/mips/boot/dts/ingenic/jz4740.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4740.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <dt-bindings/clock/jz4740-cgu.h>
+#include <dt-bindings/clock/ingenic,tcu.h>
 
 / {
 	#address-cells = <1>;
@@ -45,14 +46,6 @@ cgu: jz4740-cgu@10000000 {
 		#clock-cells = <1>;
 	};
 
-	watchdog: watchdog@10002000 {
-		compatible = "ingenic,jz4740-watchdog";
-		reg = <0x10002000 0x10>;
-
-		clocks = <&cgu JZ4740_CLK_RTC>;
-		clock-names = "rtc";
-	};
-
 	tcu: timer@10002000 {
 		compatible = "ingenic,jz4740-tcu", "simple-mfd";
 		reg = <0x10002000 0x1000>;
@@ -73,6 +66,14 @@ &cgu JZ4740_CLK_PCLK
 
 		interrupt-parent = <&intc>;
 		interrupts = <23 22 21>;
+
+		watchdog: watchdog@0 {
+			compatible = "ingenic,jz4740-watchdog";
+			reg = <0x0 0xc>;
+
+			clocks = <&tcu TCU_CLK_WDT>;
+			clock-names = "wdt";
+		};
 	};
 
 	rtc_dev: rtc@10003000 {
diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
index f928329b034b..bb89653d16a3 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <dt-bindings/clock/jz4780-cgu.h>
+#include <dt-bindings/clock/ingenic,tcu.h>
 #include <dt-bindings/dma/jz4780-dma.h>
 
 / {
@@ -67,6 +68,14 @@ &cgu JZ4780_CLK_EXCLK
 
 		interrupt-parent = <&intc>;
 		interrupts = <27 26 25>;
+
+		watchdog: watchdog@0 {
+			compatible = "ingenic,jz4780-watchdog";
+			reg = <0x0 0xc>;
+
+			clocks = <&tcu TCU_CLK_WDT>;
+			clock-names = "wdt";
+		};
 	};
 
 	rtc_dev: rtc@10003000 {
@@ -348,14 +357,6 @@ i2c4: i2c@10054000 {
 		status = "disabled";
 	};
 
-	watchdog: watchdog@10002000 {
-		compatible = "ingenic,jz4780-watchdog";
-		reg = <0x10002000 0x10>;
-
-		clocks = <&cgu JZ4780_CLK_RTCLK>;
-		clock-names = "rtc";
-	};
-
 	nemc: nemc@13410000 {
 		compatible = "ingenic,jz4780-nemc";
 		reg = <0x13410000 0x10000>;
-- 
2.25.0

