Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B141620E1
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfGHOwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:52:22 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:29806 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGHOwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 10:52:22 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2019 10:52:20 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562597539;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=/5MRjzRqaUGjrhBFjHxJCusOtBew5uCthHfQYabNy/k=;
        b=HDfIIz/p/A8wQattq/8RZ5eEKrjVXHxonhMLlA95HtnDYN2a3T/qe2mNncJxsebPcW
        4RDZ3hs6JjHCUhYVi0+fbXD/QmuG4Ahneu3yo7b5RSzMELMd9I29uuQfDNUpVCGt0aIL
        gcVbXaPmr9lHmIWkwRm9WD7ssnZEcaOhuhpSH2w8TV/7h1j8C0u4B3RRz+baw8s8zo8m
        KKw1PxutCbpM3eDAAK/+xEPEzVi3oTiXr+rursvXoNQFkvkeaDHKSqiJlWC7x7cGccAf
        XM8awEUjz77uKcOPx4cAaKQT6Q9apnRKMTs/DO2pY1XiTVThPGe/CKHjlr1wzmGyh55l
        ZStQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2AyOEF/R66y"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id V09459v68Ek7X7H
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 8 Jul 2019 16:46:07 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc:     letux-kernel@openphoenux.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again
Date:   Mon,  8 Jul 2019 16:46:05 +0200
Message-Id: <8ae7cf816b22ef9cecee0d789fcf9e8a06495c39.1562597164.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1562597164.git.hns@goldelico.com>
References: <cover.1562597164.git.hns@goldelico.com>
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
to properly pass through the legacy handler.

Since this is nowhere documented in the bindings, we add some words of
WARNING.

Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 Documentation/devicetree/bindings/spi/spi-bus.txt | 6 ++++++
 arch/arm/boot/dts/omap3-gta04.dtsi                | 1 +
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index 1f6e86f787ef..982aa590058b 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -47,6 +47,10 @@ cs1 : native
 cs2 : &gpio1 1 0
 cs3 : &gpio1 2 0
 
+WARNING: the polarity of cs-gpios may be inverted in some cases compared
+to what is specified in the third parameter. In that case the spi-cs-high
+property must be defined for slave nodes.
+
 
 SPI slave nodes must be children of the SPI controller node.
 
@@ -69,6 +73,8 @@ All slave nodes can contain the following optional properties:
 		    phase (CPHA) mode.
 - spi-cs-high     - Empty property indicating device requires chip select
 		    active high.
+                   WARNING: this is especially required even if the cs-gpios
+		    define the gpio as GPIO_ACTIVE_HIGH
 - spi-3wire       - Empty property indicating device requires 3-wire mode.
 - spi-lsb-first   - Empty property indicating device requires LSB first mode.
 - spi-tx-bus-width - The bus width (number of data wires) that is used for MOSI.
diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 9a9a29fe88ec..47bab8e1040e 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -124,6 +124,7 @@
 			spi-max-frequency = <100000>;
 			spi-cpol;
 			spi-cpha;
+			spi-cs-high;
 
 			backlight= <&backlight>;
 			label = "lcd";
-- 
2.19.1

