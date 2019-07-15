Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3969010
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389636AbfGOOSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:18:53 -0400
Received: from glenfiddich.mraw.org ([62.210.215.98]:51522 "EHLO
        glenfiddich.mraw.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389986AbfGOOSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 10:18:51 -0400
X-Greylist: delayed 1021 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2019 10:18:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mraw.org;
         s=mail; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:
        Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NyFDnf5SZdSrncCeOu+Fi41+k1etiPYFLYhtSjNFtHw=; b=g1hZW+S9b2xSyNu3d0SXLpQZ89
        tZxVB1w6YokcsZwcFz4ioarXJImrjsJvdVO/JM1GbMVsdhATSGcsMs5VTrkRQMIZuVSSYSlDPRskM
        6wJ1ZCZ9nlBMoS+L2AH8D6Dm5p6cnPUMcHKhI10YNByLCG3B8ak/3HtzKsy+WgKUOJ4c=;
Received: from localhost ([127.0.0.1] helo=armor.home)
        by glenfiddich.mraw.org with esmtp (Exim 4.89)
        (envelope-from <cyril@debamax.com>)
        id 1hn1Y8-00008C-Ub; Mon, 15 Jul 2019 16:01:53 +0200
From:   Cyril Brulebois <cyril@debamax.com>
To:     stable@vger.kernel.org
Cc:     charles.fendt@me.com, Stefan Wahren <stefan.wahren@i2se.com>,
        Cyril Brulebois <cyril@debamax.com>
Subject: [PATCH 1/3] ARM: dts: add Raspberry Pi Compute Module 3 and IO board
Date:   Mon, 15 Jul 2019 16:01:10 +0200
Message-Id: <20190715140112.6180-2-cyril@debamax.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190715140112.6180-1-cyril@debamax.com>
References: <20190715140112.6180-1-cyril@debamax.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit a54fe8a6cf66828499b121c3c39c194b43b8ed94 upstream.

The Raspberry Pi Compute Module 3 (CM3) and the Raspberry Pi
Compute Module 3 Lite (CM3L) are SoMs which contains a BCM2837 processor,
1 GB RAM and a GPIO expander. The CM3 has a 4 GB eMMC, but on the CM3L
the eMMC is unpopulated and it's up to the user to connect their
own SD/MMC device. The dtsi file is designed to work for both modules.
There is also a matching carrier board which is called
Compute Module IO Board V3.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Charles Fendt <charles.fendt@me.com>
Signed-off-by: Cyril Brulebois <cyril@debamax.com>
---
 arch/arm/boot/dts/Makefile                |  1 +
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts | 87 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi    | 52 ++++++++++++++++++
 3 files changed, 140 insertions(+)
 create mode 100644 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
 create mode 100644 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b5bd3de87c33..35c749fe22eb 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -81,6 +81,7 @@ dtb-$(CONFIG_ARCH_BCM2835) += \
 	bcm2836-rpi-2-b.dtb \
 	bcm2837-rpi-3-b.dtb \
 	bcm2837-rpi-3-b-plus.dtb \
+	bcm2837-rpi-cm3-io3.dtb \
 	bcm2835-rpi-zero.dtb \
 	bcm2835-rpi-zero-w.dtb
 dtb-$(CONFIG_ARCH_BCM_5301X) += \
diff --git a/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
new file mode 100644
index 000000000000..6c8233a36d86
--- /dev/null
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+#include "bcm2837-rpi-cm3.dtsi"
+#include "bcm283x-rpi-usb-host.dtsi"
+
+/ {
+	compatible = "raspberrypi,3-compute-module", "brcm,bcm2837";
+	model = "Raspberry Pi Compute Module 3 IO board V3.0";
+};
+
+&gpio {
+	/*
+	 * This is based on the official GPU firmware DT blob.
+	 *
+	 * Legend:
+	 * "NC" = not connected (no rail from the SoC)
+	 * "FOO" = GPIO line named "FOO" on the schematic
+	 * "FOO_N" = GPIO line named "FOO" on schematic, active low
+	 */
+	gpio-line-names = "GPIO0",
+			  "GPIO1",
+			  "GPIO2",
+			  "GPIO3",
+			  "GPIO4",
+			  "GPIO5",
+			  "GPIO6",
+			  "GPIO7",
+			  "GPIO8",
+			  "GPIO9",
+			  "GPIO10",
+			  "GPIO11",
+			  "GPIO12",
+			  "GPIO13",
+			  "GPIO14",
+			  "GPIO15",
+			  "GPIO16",
+			  "GPIO17",
+			  "GPIO18",
+			  "GPIO19",
+			  "GPIO20",
+			  "GPIO21",
+			  "GPIO22",
+			  "GPIO23",
+			  "GPIO24",
+			  "GPIO25",
+			  "GPIO26",
+			  "GPIO27",
+			  "GPIO28",
+			  "GPIO29",
+			  "GPIO30",
+			  "GPIO31",
+			  "GPIO32",
+			  "GPIO33",
+			  "GPIO34",
+			  "GPIO35",
+			  "GPIO36",
+			  "GPIO37",
+			  "GPIO38",
+			  "GPIO39",
+			  "GPIO40",
+			  "GPIO41",
+			  "GPIO42",
+			  "GPIO43",
+			  "GPIO44",
+			  "GPIO45",
+			  "GPIO46",
+			  "GPIO47",
+			  /* Used by eMMC */
+			  "SD_CLK_R",
+			  "SD_CMD_R",
+			  "SD_DATA0_R",
+			  "SD_DATA1_R",
+			  "SD_DATA2_R",
+			  "SD_DATA3_R";
+
+	pinctrl-0 = <&gpioout &alt0>;
+};
+
+&hdmi {
+	hpd-gpios = <&expgpio 1 GPIO_ACTIVE_LOW>;
+};
+
+&uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_gpio14>;
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi b/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
new file mode 100644
index 000000000000..7b7ab6aea988
--- /dev/null
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+#include "bcm2837.dtsi"
+#include "bcm2835-rpi.dtsi"
+
+/ {
+	memory {
+		reg = <0 0x40000000>;
+	};
+
+	reg_3v3: fixed-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "3V3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-always-on;
+	};
+
+	reg_1v8: fixed-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "1V8";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-always-on;
+	};
+};
+
+&firmware {
+	expgpio: gpio {
+		compatible = "raspberrypi,firmware-gpio";
+		gpio-controller;
+		#gpio-cells = <2>;
+		gpio-line-names = "HDMI_HPD_N",
+				  "EMMC_EN_N",
+				  "NC",
+				  "NC",
+				  "NC",
+				  "NC",
+				  "NC",
+				  "NC";
+		status = "okay";
+	};
+};
+
+&sdhost {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdhost_gpio48>;
+	bus-width = <4>;
+	vmmc-supply = <&reg_3v3>;
+	vqmmc-supply = <&reg_1v8>;
+	status = "okay";
+};
-- 
2.11.0

