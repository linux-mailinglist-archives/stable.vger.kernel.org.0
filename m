Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3C6404986
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhIILmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236025AbhIILmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E760061131;
        Thu,  9 Sep 2021 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187681;
        bh=NU5ZOx0naDK85oG0/HUbMQFEYp7Zrotfi5JaGSGDnmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK7glzoOZz5PcZSES4DjswDgtISXFkynbYRLM++GWZe80pp202TRCko1M0oVqd1u2
         BDXOsQ8M6sl57pSqjj5qeVO2F8bszYLdSzoAq/ed3grHZG8yuW9xgNmdTt563HyWvv
         7cGGojphDWfvk4IXr7iH9lklP0s0Q2AttynCkkbOTkdPwNx6sXcXo28d/kwQg9TGMd
         ulZKEDLDsQ/5dCFaJ8Sz26fjU+5wxn5/8Ln437aIVsUBilWf/HhRoz+ubW4s9ZQQ9Q
         Zc1pmCrPWyC1cdhxOtB4FmnYmOJrFA8Obkv1Q7ZnSU2F4ysut81LUBdHfo82nRnX3O
         eYX1dyJxh/rzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        devicetree@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 011/252] drm/panel: Fix up DT bindings for Samsung lms397kf04
Date:   Thu,  9 Sep 2021 07:37:05 -0400
Message-Id: <20210909114106.141462-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 710fa9aa16321f2ffdd8383f6f780c9cc1e5a197 ]

Improve the bindings and make them more usable:

- Pick in spi-cpha and spi-cpol from the SPI node parent,
  this will specify that we are "type 3" in the device tree
  rather than hardcoding it in the operating system.
- Drop the u32 ref from the SPI frequency: comes in from
  the SPI host bindings.
- Make spi-cpha, spi-cpol and port compulsory.
- Update the example with a real-world SPI controller,
  spi-gpio.

Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210701213618.3818821-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/panel/samsung,lms397kf04.yaml      | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml b/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
index 4cb75a5f2e3a..cd62968426fb 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,lms397kf04.yaml
@@ -33,8 +33,11 @@ properties:
 
   backlight: true
 
+  spi-cpha: true
+
+  spi-cpol: true
+
   spi-max-frequency:
-    $ref: /schemas/types.yaml#/definitions/uint32
     description: inherited as a SPI client node, the datasheet specifies
       maximum 300 ns minimum cycle which gives around 3 MHz max frequency
     maximum: 3000000
@@ -44,6 +47,9 @@ properties:
 required:
   - compatible
   - reg
+  - spi-cpha
+  - spi-cpol
+  - port
 
 additionalProperties: false
 
@@ -52,15 +58,23 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
 
     spi {
+      compatible = "spi-gpio";
+      sck-gpios = <&gpio 0 GPIO_ACTIVE_HIGH>;
+      miso-gpios = <&gpio 1 GPIO_ACTIVE_HIGH>;
+      mosi-gpios = <&gpio 2 GPIO_ACTIVE_HIGH>;
+      cs-gpios = <&gpio 3 GPIO_ACTIVE_HIGH>;
+      num-chipselects = <1>;
       #address-cells = <1>;
       #size-cells = <0>;
       panel@0 {
         compatible = "samsung,lms397kf04";
         spi-max-frequency = <3000000>;
+        spi-cpha;
+        spi-cpol;
         reg = <0>;
         vci-supply = <&lcd_3v0_reg>;
         vccio-supply = <&lcd_1v8_reg>;
-        reset-gpios = <&gpio 1 GPIO_ACTIVE_LOW>;
+        reset-gpios = <&gpio 4 GPIO_ACTIVE_LOW>;
         backlight = <&ktd259>;
 
         port {
-- 
2.30.2

