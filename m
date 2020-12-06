Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A1E2D0439
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgLFLoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:44:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgLFLn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.9 18/46] dt-bindings: net: correct interrupt flags in examples
Date:   Sun,  6 Dec 2020 12:17:26 +0100
Message-Id: <20201206111557.337432983@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 4d521943f76bd0d1e68ea5e02df7aadd30b2838a ]

GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning:
1. GPIO_ACTIVE_HIGH = 0 = IRQ_TYPE_NONE
2. GPIO_ACTIVE_LOW  = 1 = IRQ_TYPE_EDGE_RISING

Correct the interrupt flags, assuming the author of the code wanted same
logical behavior behind the name "ACTIVE_xxx", this is:
  ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW
  ACTIVE_HIGH => IRQ_TYPE_LEVEL_HIGH

Fixes: a1a8b4594f8d ("NFC: pn544: i2c: Add DTS Documentation")
Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Fixes: e3b329221567 ("dt-bindings: can: tcan4x5x: Update binding to use interrupt property")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for tcan4x5x.txt
Link: https://lore.kernel.org/r/20201026153620.89268-1-krzk@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt |    2 +-
 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt  |    2 +-
 Documentation/devicetree/bindings/net/nfc/pn544.txt    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -33,7 +33,7 @@ tcan4x5x: tcan4x5x@0 {
 		spi-max-frequency = <10000000>;
 		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <14 GPIO_ACTIVE_LOW>;
+		interrupts = <14 IRQ_TYPE_LEVEL_LOW>;
 		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 		device-wake-gpios = <&gpio1 15 GPIO_ACTIVE_HIGH>;
 		reset-gpios = <&gpio1 27 GPIO_ACTIVE_HIGH>;
--- a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
+++ b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
@@ -25,7 +25,7 @@ Example (for ARM-based BeagleBone with N
 		clock-frequency = <100000>;
 
 		interrupt-parent = <&gpio1>;
-		interrupts = <29 GPIO_ACTIVE_HIGH>;
+		interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
 
 		enable-gpios = <&gpio0 30 GPIO_ACTIVE_HIGH>;
 		firmware-gpios = <&gpio0 31 GPIO_ACTIVE_HIGH>;
--- a/Documentation/devicetree/bindings/net/nfc/pn544.txt
+++ b/Documentation/devicetree/bindings/net/nfc/pn544.txt
@@ -25,7 +25,7 @@ Example (for ARM-based BeagleBone with P
 		clock-frequency = <400000>;
 
 		interrupt-parent = <&gpio1>;
-		interrupts = <17 GPIO_ACTIVE_HIGH>;
+		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
 
 		enable-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 		firmware-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;


