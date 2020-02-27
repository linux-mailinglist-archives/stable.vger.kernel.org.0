Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2245C171D9A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbgB0OVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389485AbgB0OQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:16:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2482469F;
        Thu, 27 Feb 2020 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812980;
        bh=A82Y9A3U3/P7mYTp+rSrNOhL2WJfvMTsvO8YMvEjdtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0gd5iGwQNI5jynl7KeijZ4g1eGd5j5qSF5Mp8HbExmLQEPe4saPrSoMRPKgqtTlX
         krZVdYH7RgZF2mKWi9P02IVlBEvNqe/4mho7FyTaUqVU1jDBP1jcIQ5cGrukoA30y7
         50qqx21/LKOFAXN2AEZ7l0iXurdo4YJvqsEG9YuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Zhou Yanjie <zhouyanjie@wanyeetech.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 5.5 063/150] MIPS: ingenic: DTS: Fix watchdog nodes
Date:   Thu, 27 Feb 2020 14:36:40 +0100
Message-Id: <20200227132242.322641300@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 11479e8e3cd896673a15af21cd0f145a4752f01a upstream.

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

Fixes: 6d532143c915 ("watchdog: jz4740: Use regmap provided by TCU driver")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Zhou Yanjie <zhouyanjie@wanyeetech.com>
Cc: od@zcrc.me
Cc: linux-mips@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/boot/dts/ingenic/jz4740.dtsi |   17 +++++++++--------
 arch/mips/boot/dts/ingenic/jz4780.dtsi |   17 +++++++++--------
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/arch/mips/boot/dts/ingenic/jz4740.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4740.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <dt-bindings/clock/jz4740-cgu.h>
+#include <dt-bindings/clock/ingenic,tcu.h>
 
 / {
 	#address-cells = <1>;
@@ -45,14 +46,6 @@
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
@@ -73,6 +66,14 @@
 
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
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <dt-bindings/clock/jz4780-cgu.h>
+#include <dt-bindings/clock/ingenic,tcu.h>
 #include <dt-bindings/dma/jz4780-dma.h>
 
 / {
@@ -67,6 +68,14 @@
 
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
@@ -348,14 +357,6 @@
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


