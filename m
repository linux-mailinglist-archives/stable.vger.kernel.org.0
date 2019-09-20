Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DB1B94F8
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbfITQLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:11:36 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:23170 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388473AbfITQLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 12:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1568995893;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=pMuJS7ZxGerg+itWYAGiO02bP41ocHFhwtgwC16Oy+4=;
        b=hGBWKLKzjWq3O6h9+xukeP0VNFzjSOGlXzAbD90kDzOf6DTvEQbgUQX3w7HREfAIfq
        Y35h0dABORrrcyTE02T2xt8VEkxoYBg2LU67Yd6zKLqTyMEYVYsYMRCet11YxBb8pcex
        Y43ANkTglCf7V9Hy/SxbLzmjW4BnBJnH6wntosDZObE/UaL7ojL6dyV4+knHRTkhER1W
        K1NHNXLk62k8igubIjX4iNEFUiRmubjHHoXHQ5H6buDbRpAoTbvxdkQ34+6JV2Y83e1N
        S6ihrJV01pq8BFOCsYKRDXF6JsgPFsl7tm3M1yFWsBpMxuqEmLfhtfgzGejR7pPNbwNu
        LNOg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2AyPw8lBX+A"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.27.0 DYNA|AUTH)
        with ESMTPSA id u036f9v8KGBFpHV
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 20 Sep 2019 18:11:15 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, broonie@kernel.org,
        linus.walleij@linaro.org
Cc:     stable@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH v2] DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again
Date:   Fri, 20 Sep 2019 18:11:15 +0200
Message-Id: <c031340840daba810bb2a612c35eea7fab307e56.1568995874.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6953c57ab172 "gpio: of: Handle SPI chipselect legacy bindings"

did introduce logic to centrally handle the legacy spi-cs-high property
in combination with cs-gpios. This assumes that the polarity
of the CS has to be inverted if spi-cs-high is missing, even
and especially if non-legacy GPIO_ACTIVE_HIGH is specified.

The DTS for the GTA04 was orginally introduced under the assumption
that there is no need for spi-cs-high if the gpio is defined with
proper polarity GPIO_ACTIVE_HIGH.

This was not a problem until gpiolib changed the interpretation of
GPIO_ACTIVE_HIGH and missing spi-cs-high.

The effect is that the missing spi-cs-high is now interpreted as CS being
low (despite GPIO_ACTIVE_HIGH) which turns off the SPI interface when the
panel is to be programmed by the panel driver.

Therefore, we have to add the redundant and legacy spi-cs-high property
to properly activate CS.

Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index b295f6fad2a5..954c216140ad 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -120,6 +120,7 @@
 			spi-max-frequency = <100000>;
 			spi-cpol;
 			spi-cpha;
+			spi-cs-high;
 
 			backlight= <&backlight>;
 			label = "lcd";
-- 
2.19.1

