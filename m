Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF784B4B40
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344159AbiBNKDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:03:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344040AbiBNKCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:02:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4196B387BE;
        Mon, 14 Feb 2022 01:48:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FF26B80DC4;
        Mon, 14 Feb 2022 09:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D3CC340E9;
        Mon, 14 Feb 2022 09:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832104;
        bh=815sZeb3FV+hkGHHg7GhedUbTxZZGD5sIdel9Yx81wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z249EiS0WZC1SZtzk5Uu8598S3usfLROCmnuvM9+yPicdHVm/3xwO/RdO7hOB4esg
         5Uo6i3JddafLgWGuQznfZQbZWq6KYpJylBOjhI2wpgrYjnH2YJF4L/tpVAGs4dic52
         1pz5tlcMqq3qN2w1TijMcthdlW15LZh6XYaP+cW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/172] ARM: dts: Fix timer regression for beagleboard revision c
Date:   Mon, 14 Feb 2022 10:25:38 +0100
Message-Id: <20220214092509.175822340@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 23885389dbbbbc698986e77a45c1fc44a6e3632e ]

Commit e428e250fde6 ("ARM: dts: Configure system timers for omap3")
caused a timer regression for beagleboard revision c where the system
clockevent stops working if omap3isp module is unloaded.

Turns out we still have beagleboard revisions a-b4 capacitor c70 quirks
applied that limit the usable timers for no good reason. This also affects
the power management as we use the system clock instead of the 32k clock
source.

Let's fix the issue by adding a new omap3-beagle-ab4.dts for the old timer
quirks. This allows us to remove the timer quirks for later beagleboard
revisions. We also need to update the related timer quirk check for the
correct compatible property.

Fixes: e428e250fde6 ("ARM: dts: Configure system timers for omap3")
Cc: linux-kernel@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>
Reported-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Tested-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/arm/omap/omap.txt     |  3 ++
 arch/arm/boot/dts/Makefile                    |  1 +
 arch/arm/boot/dts/omap3-beagle-ab4.dts        | 47 +++++++++++++++++++
 arch/arm/boot/dts/omap3-beagle.dts            | 33 -------------
 drivers/clocksource/timer-ti-dm-systimer.c    |  2 +-
 5 files changed, 52 insertions(+), 34 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-beagle-ab4.dts

diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index e77635c5422c6..fa8b31660cadd 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -119,6 +119,9 @@ Boards (incomplete list of examples):
 - OMAP3 BeagleBoard : Low cost community board
   compatible = "ti,omap3-beagle", "ti,omap3430", "ti,omap3"
 
+- OMAP3 BeagleBoard A to B4 : Early BeagleBoard revisions A to B4 with a timer quirk
+  compatible = "ti,omap3-beagle-ab4", "ti,omap3-beagle", "ti,omap3430", "ti,omap3"
+
 - OMAP3 Tobi with Overo : Commercial expansion board with daughter board
   compatible = "gumstix,omap3-overo-tobi", "gumstix,omap3-overo", "ti,omap3430", "ti,omap3"
 
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7e0934180724d..27ca1ca6e827c 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -779,6 +779,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += \
 	logicpd-som-lv-37xx-devkit.dtb \
 	omap3430-sdp.dtb \
 	omap3-beagle.dtb \
+	omap3-beagle-ab4.dtb \
 	omap3-beagle-xm.dtb \
 	omap3-beagle-xm-ab.dtb \
 	omap3-cm-t3517.dtb \
diff --git a/arch/arm/boot/dts/omap3-beagle-ab4.dts b/arch/arm/boot/dts/omap3-beagle-ab4.dts
new file mode 100644
index 0000000000000..990ff2d846868
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-beagle-ab4.dts
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/dts-v1/;
+
+#include "omap3-beagle.dts"
+
+/ {
+	model = "TI OMAP3 BeagleBoard A to B4";
+	compatible = "ti,omap3-beagle-ab4", "ti,omap3-beagle", "ti,omap3430", "ti,omap3";
+};
+
+/*
+ * Workaround for capacitor C70 issue, see "Boards revision A and < B5"
+ * section at https://elinux.org/BeagleBoard_Community
+ */
+
+/* Unusable as clocksource because of unreliable oscillator */
+&counter32k {
+	status = "disabled";
+};
+
+/* Unusable as clockevent because of unreliable oscillator, allow to idle */
+&timer1_target {
+	/delete-property/ti,no-reset-on-init;
+	/delete-property/ti,no-idle;
+	timer@0 {
+		/delete-property/ti,timer-alwon;
+	};
+};
+
+/* Preferred always-on timer for clocksource */
+&timer12_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		/* Always clocked by secure_32k_fck */
+	};
+};
+
+/* Preferred timer for clockevent */
+&timer2_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		assigned-clocks = <&gpt2_fck>;
+		assigned-clock-parents = <&sys_ck>;
+	};
+};
diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index f9f34b8458e91..0548b391334fd 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -304,39 +304,6 @@ &usbhsehci {
 	phys = <0 &hsusb2_phy>;
 };
 
-/* Unusable as clocksource because of unreliable oscillator */
-&counter32k {
-	status = "disabled";
-};
-
-/* Unusable as clockevent because if unreliable oscillator, allow to idle */
-&timer1_target {
-	/delete-property/ti,no-reset-on-init;
-	/delete-property/ti,no-idle;
-	timer@0 {
-		/delete-property/ti,timer-alwon;
-	};
-};
-
-/* Preferred always-on timer for clocksource */
-&timer12_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		/* Always clocked by secure_32k_fck */
-	};
-};
-
-/* Preferred timer for clockevent */
-&timer2_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		assigned-clocks = <&gpt2_fck>;
-		assigned-clock-parents = <&sys_ck>;
-	};
-};
-
 &twl_gpio {
 	ti,use-leds;
 	/* pullups: BIT(1) */
diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index b6f97960d8ee0..5c40ca1d4740e 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -241,7 +241,7 @@ static void __init dmtimer_systimer_assign_alwon(void)
 	bool quirk_unreliable_oscillator = false;
 
 	/* Quirk unreliable 32 KiHz oscillator with incomplete dts */
-	if (of_machine_is_compatible("ti,omap3-beagle") ||
+	if (of_machine_is_compatible("ti,omap3-beagle-ab4") ||
 	    of_machine_is_compatible("timll,omap3-devkit8000")) {
 		quirk_unreliable_oscillator = true;
 		counter_32k = -ENODEV;
-- 
2.34.1



