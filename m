Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0B640E6C3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347735AbhIPRZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347104AbhIPRWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:22:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08CEF61A2F;
        Thu, 16 Sep 2021 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810594;
        bh=NU5ZOx0naDK85oG0/HUbMQFEYp7Zrotfi5JaGSGDnmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PviFyakPMUB9lc9DShIgpQLRbk9e9GBiUqZR6dtiLrpIjHtWh+xClSTp8G/QKP31m
         w82Zmz0x01FV8oe/22ESmTcSOT8ycMtj20i7jYzijK1FryybSAV47+iulTp7/Is+JT
         fqttcTSGD2N6xVeyG7KgO3wsSDNXEcJL12DaCZwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 166/432] drm/panel: Fix up DT bindings for Samsung lms397kf04
Date:   Thu, 16 Sep 2021 17:58:35 +0200
Message-Id: <20210916155816.371280765@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



