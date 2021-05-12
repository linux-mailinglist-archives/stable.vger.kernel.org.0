Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0820137C86E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhELQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237212AbhELQDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A9BF61CE2;
        Wed, 12 May 2021 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833619;
        bh=FRuAeRkFMpnn9EPkbE2+X2ot5ARnDbX+6RJ/CaSKVDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Foq/1brjmcoFMSsuLfCZ+QUpiXf9LQp42NSsNJlxPrRGyoEGjb1LrSnFDSE67uhAu
         ILwwj3G9QG2LKPVLg8S2zgE+5vaUveiTNh28E7Fd6DUW88YQPLkX6i4HmYKHrRYLzN
         C/sAY0LdfV2EO7ATkL9X+5F1jX74qAD4I65utTiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 178/601] arm64: dts: qcom: sc7180: Avoid glitching SPI CS at bootup on trogdor
Date:   Wed, 12 May 2021 16:44:15 +0200
Message-Id: <20210512144833.703311663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e440e30e26dd6b0424002ad0ddcbbcea783efd85 ]

At boot time the following happens:
1. Device core gets ready to probe our SPI driver.
2. Device core applies SPI controller's "default" pinctrl.
3. Device core calls the SPI driver's probe() function which will
   eventually setup the chip select GPIO as "unasserted".

Thinking about the above, we can find:
a) For SPI devices that the BIOS inits (Cr50 and EC), the BIOS would
   have had them configured as "GENI" pins and not as "GPIO" pins.
b) It turns out that our BIOS also happens to init these pins as
   "output" (even though it doesn't need to since they're not muxed as
   GPIO) but leaves them at the default state of "low".
c) As soon as we apply the "default" chip select it'll switch the
   function to GPIO and stop driving the chip select high (which is
   how "GENI" was driving it) and start driving it low.
d) As of commit 9378f46040be ("UPSTREAM: spi: spi-geni-qcom: Use the
   new method of gpio CS control"), when the SPI core inits things it
   inits the GPIO to be "deasserted".  Prior to that commit the GPIO
   was left untouched until first use.
e) When the first transaction happens we'll assert the chip select and
   then deassert it after done.

So before the commit to change us to use gpio descriptors we used to
have a _really long_ assertion of chip select before our first
transaction (because it got pulled down and then the first "assert"
was a no-op).  That wasn't great but (apparently) didn't cause any
real harm.

After the commit to change us to use gpio descriptors we end up
glitching the chip select line during probe.  It would go low and then
high with no data transferred.  The other side ought to be robust
against this, but it certainly could cause some confusion.  It's known
to at least cause an error message on the EC console and it's believed
that, under certain timing conditions, it could be getting the EC into
a confused state causing the EC driver to fail to probe.

Let's fix things to avoid the glitch.  We'll add an extra pinctrl
entry that sets the value of the pin to output high (CS deasserted)
before doing anything else.  We'll do this in its own pinctrl node
that comes before the normal pinctrl entries to ensure that the order
is correct and that this gets applied before the mux change.

This change is in the trogdor board file rather than in the SoC dtsi
file because chip select polarity can be different depending on what's
hooked up and it doesn't feel worth it to spam the SoC dtsi file with
both options.  The board file would need to pick the right one anyway.

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Fixes: cfbb97fde694 ("arm64: dts: qcom: Switch sc7180-trogdor to control SPI CS via GPIO")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20210218145456.1.I1da01a075dd86e005152f993b2d5d82dd9686238@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 27 +++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 5c650b902c10..472f598cd726 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -838,17 +838,17 @@ hp_i2c: &i2c9 {
 };
 
 &spi0 {
-	pinctrl-0 = <&qup_spi0_cs_gpio>;
+	pinctrl-0 = <&qup_spi0_cs_gpio_init_high>, <&qup_spi0_cs_gpio>;
 	cs-gpios = <&tlmm 37 GPIO_ACTIVE_LOW>;
 };
 
 &spi6 {
-	pinctrl-0 = <&qup_spi6_cs_gpio>;
+	pinctrl-0 = <&qup_spi6_cs_gpio_init_high>, <&qup_spi6_cs_gpio>;
 	cs-gpios = <&tlmm 62 GPIO_ACTIVE_LOW>;
 };
 
 ap_spi_fp: &spi10 {
-	pinctrl-0 = <&qup_spi10_cs_gpio>;
+	pinctrl-0 = <&qup_spi10_cs_gpio_init_high>, <&qup_spi10_cs_gpio>;
 	cs-gpios = <&tlmm 89 GPIO_ACTIVE_LOW>;
 
 	cros_ec_fp: ec@0 {
@@ -1402,6 +1402,27 @@ ap_spi_fp: &spi10 {
 		};
 	};
 
+	qup_spi0_cs_gpio_init_high: qup-spi0-cs-gpio-init-high {
+		pinconf {
+			pins = "gpio37";
+			output-high;
+		};
+	};
+
+	qup_spi6_cs_gpio_init_high: qup-spi6-cs-gpio-init-high {
+		pinconf {
+			pins = "gpio62";
+			output-high;
+		};
+	};
+
+	qup_spi10_cs_gpio_init_high: qup-spi10-cs-gpio-init-high {
+		pinconf {
+			pins = "gpio89";
+			output-high;
+		};
+	};
+
 	qup_uart3_sleep: qup-uart3-sleep {
 		pinmux {
 			pins = "gpio38", "gpio39",
-- 
2.30.2



