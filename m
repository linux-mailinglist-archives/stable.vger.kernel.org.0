Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5581F4F44A3
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382428AbiDEMPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiDEKfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C397F13E3D;
        Tue,  5 Apr 2022 03:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F0FF61562;
        Tue,  5 Apr 2022 10:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD24C385A1;
        Tue,  5 Apr 2022 10:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153985;
        bh=Z6OySrSX32Hkx5sPKsLlBhXghDamj+OXKiODTtxYEdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbQSyLfGGFD0lPEcryVJDDWNhQuSJeu8T/Z4UcYCSofi1QmX0+cg8p14JNZx7a4bA
         MdSC/I7okRYDUOx027sITEN3hoXr9vhWx5TnVegpX6+OGlkTxBQCeBs2jAS2IFwCSc
         dnoBxY00digHOpCvT88micafBTwpWbMzIIBltzbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/599] staging: mt7621-dts: fix GB-PC2 devicetree
Date:   Tue,  5 Apr 2022 09:31:51 +0200
Message-Id: <20220405070311.241220517@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 5bc148649cf358d0cccf525452a4efbd4bc89a0f ]

Fix the GB-PC2 devicetree. Refer to the schematics of the device for more
information.

GB-PC2 devicetree fixes:
- Include mt7621.dtsi instead of gbpc1.dts. Add the missing definitions.
- Remove gpio-leds node as the system LED is not wired to anywhere on
the board and the power LED is directly wired to GND.
- Remove uart3 pin group from gpio-pinmux node as it's not used as GPIO.
- Use reg 7 for the external phy to be on par with
Documentation/devicetree/bindings/net/dsa/mt7530.txt.
- Use the status value "okay".

Link: https://github.com/ngiger/GnuBee_Docs/blob/master/GB-PCx/Documents/GB-PC2_V1.1_schematic.pdf
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20220311090320.3068-2-arinc.unal@arinc9.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-dts/gbpc2.dts | 110 +++++++++++++++++++++++++--
 1 file changed, 102 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/mt7621-dts/gbpc2.dts b/drivers/staging/mt7621-dts/gbpc2.dts
index f9b69091bfc0..6f6fed071dda 100644
--- a/drivers/staging/mt7621-dts/gbpc2.dts
+++ b/drivers/staging/mt7621-dts/gbpc2.dts
@@ -1,27 +1,121 @@
 /dts-v1/;
 
-#include "gbpc1.dts"
+#include "mt7621.dtsi"
+
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 
 / {
 	compatible = "gnubee,gb-pc2", "mediatek,mt7621-soc";
 	model = "GB-PC2";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x1c000000>,
+		      <0x20000000 0x04000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,57600";
+	};
+
+	palmbus: palmbus@1e000000 {
+		i2c@900 {
+			status = "okay";
+		};
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		reset {
+			label = "reset";
+			gpios = <&gpio 18 GPIO_ACTIVE_HIGH>;
+			linux,code = <KEY_RESTART>;
+		};
+	};
 };
 
-&default_gpio {
-	groups = "wdt", "uart3";
-	function = "gpio";
+&sdhci {
+	status = "okay";
+};
+
+&spi0 {
+	status = "okay";
+
+	m25p80@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "jedec,spi-nor";
+		reg = <0>;
+		spi-max-frequency = <50000000>;
+		broken-flash-reset;
+
+		partition@0 {
+			label = "u-boot";
+			reg = <0x0 0x30000>;
+			read-only;
+		};
+
+		partition@30000 {
+			label = "u-boot-env";
+			reg = <0x30000 0x10000>;
+			read-only;
+		};
+
+		factory: partition@40000 {
+			label = "factory";
+			reg = <0x40000 0x10000>;
+			read-only;
+		};
+
+		partition@50000 {
+			label = "firmware";
+			reg = <0x50000 0x1fb0000>;
+		};
+	};
+};
+
+&pcie {
+	status = "okay";
+};
+
+&pinctrl {
+	pinctrl-names = "default";
+	pinctrl-0 = <&state_default>;
+
+	state_default: state-default {
+		gpio-pinmux {
+			groups = "wdt";
+			function = "gpio";
+		};
+	};
 };
 
 &ethernet {
 	gmac1: mac@1 {
-		status = "ok";
-		phy-handle = <&phy_external>;
+		status = "okay";
+		phy-handle = <&ethphy7>;
 	};
 
 	mdio-bus {
-		phy_external: ethernet-phy@5 {
-			reg = <5>;
+		ethphy7: ethernet-phy@7 {
+			reg = <7>;
 			phy-mode = "rgmii-rxid";
 		};
 	};
 };
+
+&switch0 {
+	ports {
+		port@0 {
+			status = "okay";
+			label = "ethblack";
+		};
+
+		port@4 {
+			status = "okay";
+			label = "ethblue";
+		};
+	};
+};
-- 
2.34.1



