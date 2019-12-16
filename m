Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4DC1214DF
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbfLPSPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbfLPSPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6C220CC7;
        Mon, 16 Dec 2019 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520152;
        bh=5fLDD5kXfqmNfszHj/dxVtJZScXrkLT2oIRKa31FBy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+7ljy9mTkGKiCyfVlt+kgvFPA6VNog0Hfm2EOW+tpvSbGUsJFxLJ6y7qvBj2q4Y6
         p7y08qfGIPJ5zNvXXBoIB6z7iC05tmrWOtBTSp8r+FM/JsOiGC/iwc/48pBeHtkJBA
         1VmaRjuR5t6Cl2EASQqBt0uSnq0OoSQTiJN2D7DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 036/177] ARM: dts: pandora-common: define wl1251 as child node of mmc3
Date:   Mon, 16 Dec 2019 18:48:12 +0100
Message-Id: <20191216174828.678820673@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 4f9007d692017cef38baf2a9b82b7879d5b2407b upstream.

Since v4.7 the dma initialization requires that there is a
device tree property for "rx" and "tx" channels which is
not provided by the pdata-quirks initialization.

By conversion of the mmc3 setup to device tree this will
finally allows to remove the OpenPandora wlan specific omap3
data-quirks.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.7+
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-pandora-common.dtsi |   36 ++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/omap3-pandora-common.dtsi
+++ b/arch/arm/boot/dts/omap3-pandora-common.dtsi
@@ -226,6 +226,17 @@
 		gpio = <&gpio6 4 GPIO_ACTIVE_HIGH>;	/* GPIO_164 */
 	};
 
+	/* wl1251 wifi+bt module */
+	wlan_en: fixed-regulator-wg7210_en {
+		compatible = "regulator-fixed";
+		regulator-name = "vwlan";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		startup-delay-us = <50000>;
+		enable-active-high;
+		gpio = <&gpio1 23 GPIO_ACTIVE_HIGH>;
+	};
+
 	/* wg7210 (wifi+bt module) 32k clock buffer */
 	wg7210_32k: fixed-regulator-wg7210_32k {
 		compatible = "regulator-fixed";
@@ -522,9 +533,30 @@
 	/*wp-gpios = <&gpio4 31 GPIO_ACTIVE_HIGH>;*/	/* GPIO_127 */
 };
 
-/* mmc3 is probed using pdata-quirks to pass wl1251 card data */
 &mmc3 {
-	status = "disabled";
+	vmmc-supply = <&wlan_en>;
+
+	bus-width = <4>;
+	non-removable;
+	ti,non-removable;
+	cap-power-off-card;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc3_pins>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	wlan: wifi@1 {
+		compatible = "ti,wl1251";
+
+		reg = <1>;
+
+		interrupt-parent = <&gpio1>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* GPIO_21 */
+
+		ti,wl1251-has-eeprom;
+	};
 };
 
 /* bluetooth*/


