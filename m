Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C66B60428A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiJSLGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiJSLFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEF21DF0B;
        Wed, 19 Oct 2022 03:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3105617EA;
        Wed, 19 Oct 2022 09:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA1FC433C1;
        Wed, 19 Oct 2022 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170877;
        bh=DyF7cFPBhyiKKwMWomnIA0DO1L1nyUDi+UAHcYqsMI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAto0vey2tthbgMIVtbLsXgSb8FOLO7y+Tb0LEAbijJAP5wSRv+oTaxuRlubqpQQ4
         G2s8rOTRDXeDaijFfYn04O9cJYia8Tk9Cet5hXGo8m2WUCR4NKDRSKujaZAva46NTV
         qgzsUzO52IzFCs9d8N6YBbbP8qvjBGICtvGolk8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 788/862] arm64: dts: uniphier: Add USB-device support for PXs3 reference board
Date:   Wed, 19 Oct 2022 10:34:35 +0200
Message-Id: <20221019083324.721603131@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 19fee1a1096d21ab1f1e712148b5417bda2939a2 ]

PXs3 reference board can change each USB port 0 and 1 to device mode
with jumpers. Prepare devicetree sources for USB port 0 and 1.

This specifies dr_mode, pinctrl, and some quirks and removes nodes for
unused phys and vbus-supply properties.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20220913042321.4817-8-hayashi.kunihiko@socionext.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/uniphier-pinctrl.dtsi       | 10 +++++
 arch/arm64/boot/dts/socionext/Makefile        |  4 +-
 .../socionext/uniphier-pxs3-ref-gadget0.dts   | 41 +++++++++++++++++++
 .../socionext/uniphier-pxs3-ref-gadget1.dts   | 40 ++++++++++++++++++
 4 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
 create mode 100644 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts

diff --git a/arch/arm/boot/dts/uniphier-pinctrl.dtsi b/arch/arm/boot/dts/uniphier-pinctrl.dtsi
index c0fd029b37e5..f909ec2e5333 100644
--- a/arch/arm/boot/dts/uniphier-pinctrl.dtsi
+++ b/arch/arm/boot/dts/uniphier-pinctrl.dtsi
@@ -196,11 +196,21 @@
 		function = "usb0";
 	};
 
+	pinctrl_usb0_device: usb0-device {
+		groups = "usb0_device";
+		function = "usb0";
+	};
+
 	pinctrl_usb1: usb1 {
 		groups = "usb1";
 		function = "usb1";
 	};
 
+	pinctrl_usb1_device: usb1-device {
+		groups = "usb1_device";
+		function = "usb1";
+	};
+
 	pinctrl_usb2: usb2 {
 		groups = "usb2";
 		function = "usb2";
diff --git a/arch/arm64/boot/dts/socionext/Makefile b/arch/arm64/boot/dts/socionext/Makefile
index dda3da33614b..33989a9643ac 100644
--- a/arch/arm64/boot/dts/socionext/Makefile
+++ b/arch/arm64/boot/dts/socionext/Makefile
@@ -5,4 +5,6 @@ dtb-$(CONFIG_ARCH_UNIPHIER) += \
 	uniphier-ld20-akebi96.dtb \
 	uniphier-ld20-global.dtb \
 	uniphier-ld20-ref.dtb \
-	uniphier-pxs3-ref.dtb
+	uniphier-pxs3-ref.dtb \
+	uniphier-pxs3-ref-gadget0.dtb \
+	uniphier-pxs3-ref-gadget1.dtb
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
new file mode 100644
index 000000000000..7069f51bc120
--- /dev/null
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+//
+// Device Tree Source for UniPhier PXs3 Reference Board (for USB-Device #0)
+//
+// Copyright (C) 2021 Socionext Inc.
+//   Author: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
+
+/dts-v1/;
+#include "uniphier-pxs3-ref.dts"
+
+/ {
+	model = "UniPhier PXs3 Reference Board (USB-Device #0)";
+};
+
+/* I2C3 pinctrl is shared with USB*VBUSIN */
+&i2c3 {
+	status = "disabled";
+};
+
+&usb0 {
+	status = "okay";
+	dr_mode = "peripheral";
+	pinctrl-0 = <&pinctrl_usb0_device>;
+	snps,dis_enblslpm_quirk;
+	snps,dis_u2_susphy_quirk;
+	snps,dis_u3_susphy_quirk;
+	snps,usb2_gadget_lpm_disable;
+	phy-names = "usb2-phy", "usb3-phy";
+	phys = <&usb0_hsphy0>, <&usb0_ssphy0>;
+};
+
+&usb0_hsphy0 {
+	/delete-property/ vbus-supply;
+};
+
+&usb0_ssphy0 {
+	/delete-property/ vbus-supply;
+};
+
+/delete-node/ &usb0_hsphy1;
+/delete-node/ &usb0_ssphy1;
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
new file mode 100644
index 000000000000..a3cfa8113ffb
--- /dev/null
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+//
+// Device Tree Source for UniPhier PXs3 Reference Board (for USB-Device #1)
+//
+// Copyright (C) 2021 Socionext Inc.
+//   Author: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
+
+/dts-v1/;
+#include "uniphier-pxs3-ref.dts"
+
+/ {
+	model = "UniPhier PXs3 Reference Board (USB-Device #1)";
+};
+
+/* I2C3 pinctrl is shared with USB*VBUSIN */
+&i2c3 {
+	status = "disabled";
+};
+
+&usb1 {
+	status = "okay";
+	dr_mode = "peripheral";
+	pinctrl-0 = <&pinctrl_usb1_device>;
+	snps,dis_enblslpm_quirk;
+	snps,dis_u2_susphy_quirk;
+	snps,dis_u3_susphy_quirk;
+	snps,usb2_gadget_lpm_disable;
+	phy-names = "usb2-phy", "usb3-phy";
+	phys = <&usb1_hsphy0>, <&usb1_ssphy0>;
+};
+
+&usb1_hsphy0 {
+	/delete-property/ vbus-supply;
+};
+
+&usb1_ssphy0 {
+	/delete-property/ vbus-supply;
+};
+
+/delete-node/ &usb1_hsphy1;
-- 
2.35.1



